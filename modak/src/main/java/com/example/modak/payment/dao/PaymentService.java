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
import org.springframework.transaction.annotation.Transactional;

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
            List<HashMap<String, Object>> items = paymentMapper.selectCheckoutItems(map);

            for (HashMap<String, Object> item : items) {
                item.put("orderId", orderId);
                paymentMapper.insertOrderItem(item);
            }
            
            resultMap.put("result", "success");
            resultMap.put("orderId", orderId); // 프론트로 ORDER_ID 전달
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "주문 준비 실패: " + e.getMessage());
        }
        return resultMap;
    }
    
 // 토스 API 승인 - 트랜잭션 없음
    public HashMap<String, Object> confirmPayment(String paymentKey, String orderId, Long amount) {
        
        // 1. 토스 API 승인 요청 (트랜잭션 밖)
        HttpResponse<String> response = callTossApi(paymentKey, orderId, amount);
        Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));

        if (response.statusCode() == 200) {
            // 2. DB 처리는 별도 트랜잭션 메서드로 위임
            return processAfterPayment(orderIdLong, amount);
        } else {
            // 실패 처리
            HashMap<String, Object> failMap = new HashMap<>();
            failMap.put("orderId", orderIdLong);
            failMap.put("orderStatus", "CANCELLED");
            paymentMapper.updateOrderStatus(failMap);

            HashMap<String, Object> resultMap = new HashMap<>();
            resultMap.put("result", "fail");
            resultMap.put("message", "토스 승인 실패: " + response.body());
            return resultMap;
        }
        
    }
    private HttpResponse<String> callTossApi(String paymentKey, String orderId, Long amount) {
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

            return client.send(request, HttpResponse.BodyHandlers.ofString());

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    
	// DB 처리 전용 - 트랜잭션 적용
    @Transactional
    public HashMap<String, Object> processAfterPayment(Long orderIdLong, Long amount) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        HashMap<String, Object> baseMap = new HashMap<>();
        baseMap.put("orderId", orderIdLong);

        // 주문 정보 조회
        HashMap<String, Object> orderInfo = paymentMapper.selectOrderById(baseMap);
        System.out.println("orderInfo: " + orderInfo); 
        // String userId  = (String) orderInfo.get("userId");
        String userId  = (String) orderInfo.get("USER_ID");
        System.out.println("userId: " + userId);      
        boolean isGuest = "GUEST".equals(userId);

        // 1. ORDERS → PAID
        baseMap.put("orderStatus", "PAID");
        paymentMapper.updateOrderStatus(baseMap);

        // 2. PAYMENT INSERT
        baseMap.put("amount", amount);
        paymentMapper.insertPayment(baseMap);

        // 3. CART DELETE (회원만)
        if (!isGuest) {
        	baseMap.put("userId", userId);
            paymentMapper.deleteCartByOrderId(baseMap);
        }

        // 4. 쿠폰 처리 (회원 + 쿠폰 있을 때만)
        Object userCouponId = orderInfo.get("userCouponId");
        if (!isGuest && userCouponId != null) {
        	long totalPrice = ((Number) orderInfo.get("totalPrice")).longValue();
        	long discountAmt = totalPrice - amount;

        	HashMap<String, Object> couponMap = new HashMap<>();
        	couponMap.put("userCouponId", userCouponId);
        	couponMap.put("userId",       userId);
        	couponMap.put("orderId",      orderIdLong);
        	couponMap.put("discountAmt",  discountAmt);

            paymentMapper.updateCouponUsed(couponMap);
            paymentMapper.insertCouponUseLog(couponMap);
        }

        // 5 & 6. 포인트 적립 + TOTAL_AMOUNT (회원만)
        if (!isGuest) {
            long earnedPoint = amount / 100;

            String orderName   = (String) orderInfo.get("orderName");
            Long   itemCount   = (Long)   orderInfo.get("itemCount");
            String description = "상품 구매 적립 포인트 지급";
            if (orderName != null) {
                description += " - " + orderName;
                if (itemCount != null && itemCount > 1) {
                    description += " 외 " + (itemCount - 1) + "건";
                }
            }

            HashMap<String, Object> userUpdateMap = new HashMap<>();
            userUpdateMap.put("userId",      userId);
            userUpdateMap.put("earnedPoint", earnedPoint);
            userUpdateMap.put("amount",      amount);
            userUpdateMap.put("description", description);

            if (earnedPoint > 0) {
                paymentMapper.insertPointHistory(userUpdateMap);
            }
            paymentMapper.updateUserPointAndAmount(userUpdateMap);
        }

        // 7. 재고 차감
        List<HashMap<String, Object>> orderItems = paymentMapper.selectOrderItemsForStock(baseMap);
        for (HashMap<String, Object> item : orderItems) {
            String orderType = (String) item.get("orderType");

            HashMap<String, Object> stockMap = new HashMap<>();
            stockMap.put("productId", item.get("productId"));
            stockMap.put("optionId",  item.get("optionId"));
            stockMap.put("quantity",  item.get("quantity"));

            if ("PURCHASE".equals(orderType)) {
                int updated = paymentMapper.decreaseStockForPurchase(stockMap);
                if (updated == 0) {
                    throw new RuntimeException("재고 부족 - PRODUCT_ID: " + item.get("productId"));
                }
            } else if ("RENTAL".equals(orderType)) {
                stockMap.put("startDate", item.get("startDate"));
                stockMap.put("endDate",   item.get("endDate"));
                int updated = paymentMapper.decreaseStockForRental(stockMap);
                if (updated == 0) {
                    throw new RuntimeException("대여 재고 부족 - PRODUCT_ID: " + item.get("productId"));
                }
            }
        }

        resultMap.put("result", "success");
        return resultMap;
    }
    
}