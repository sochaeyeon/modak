package com.example.modak.payment.dao;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.modak.payment.mapper.PaymentMapper;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;
	
	@Value("${toss.secret-key}")
    private String tossSecretKey;
	
	// 배송지 목록 조회
    public HashMap<String, Object> getAddressList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            List<HashMap<String, Object>> list = paymentMapper.selectAddressList(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", "배송지 목록 조회 실패");
        }

        return resultMap;
    }
    // cart 
    public HashMap<String, Object> getCheckoutItems(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<HashMap<String, Object>> list = paymentMapper.selectCheckoutItems(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }

        return resultMap;
    }
    
 // 임시 주문 저장 → ORDER_ID를 프론트에 반환
    public HashMap<String, Object> readyPayment(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            paymentMapper.insertTempOrder(map);
            
            // ✅ INSERT 후 생성된 ORDER_ID를 map에서 꺼내서 반환
            Object orderId = map.get("orderId");
            
            resultMap.put("result", "success");
            resultMap.put("orderId", orderId); // 프론트로 ORDER_ID 전달
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "주문 준비 실패: " + e.getMessage());
        }
        return resultMap;
    }
    
 // ✅ 토스 최종 승인 요청
    public HashMap<String, Object> confirmPayment(String paymentKey, String orderId, Long amount) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
        	String auth = Base64.getEncoder()
                    .encodeToString((tossSecretKey + ":").getBytes());

            String body = String.format(
                "{\"paymentKey\":\"%s\",\"orderId\":\"%s\",\"amount\":%d}",
                paymentKey, orderId, amount
            );

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                .header("Authorization", "Basic " + auth)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                // ✅ ORDERS 상태 PAID로 업데이트
                HashMap<String, Object> updateMap = new HashMap<>();
                Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));
                updateMap.put("orderId", orderIdLong);
                updateMap.put("orderStatus", "PAID");
                paymentMapper.updateOrderStatus (updateMap);

                // ✅ PAYMENT 테이블 INSERT
                HashMap<String, Object> payMap = new HashMap<>();
                payMap.put("orderId", orderIdLong);
                payMap.put("amount", amount);
                paymentMapper.insertPayment(payMap);

                resultMap.put("result", "success");
            } else {
                // ✅ 실패 시 ORDERS 상태 CANCELLED로 업데이트
                HashMap<String, Object> updateMap = new HashMap<>();
                Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));
                updateMap.put("orderId", orderIdLong);
                updateMap.put("orderStatus", "CANCELLED");
                paymentMapper.updateOrderStatus(updateMap);

                resultMap.put("result", "fail");
                resultMap.put("message", "토스 승인 실패: " + response.body());
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }

        return resultMap;
    }
    
    
}