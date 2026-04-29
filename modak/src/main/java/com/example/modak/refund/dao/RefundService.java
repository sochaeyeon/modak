package com.example.modak.refund.dao;

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

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.refund.mapper.RefundMapper;

@Service
public class RefundService {
	
	@Autowired
	RefundMapper refundMapper;
	
	@Value("${toss.secret-key}")
	private String tossSecretKey;
	
	@Autowired
	private AlarmService alarmService;
	
		
	// 환불 페이지 진입 시 데이터 조회
    public HashMap<String, Object> getRefundInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<HashMap<String, Object>> list = refundMapper.selectOrderInfoForRefund(map);
            HashMap<String, Object> addr = refundMapper.selectDefaultAddress(map);

            resultMap.put("list", list);
            resultMap.put("address", addr);
            resultMap.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
        }

        return resultMap;
    }


    @Transactional(rollbackFor = Exception.class)
    // 환불 요청 처리
    public HashMap<String, Object> addRefund(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            // 1. 환불 가능 여부 체크
            HashMap<String, Object> check = refundMapper.checkRefundAvailability(map);

            if (check == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            int refundCount = Integer.parseInt(String.valueOf(check.get("refundCount")));
            String status = String.valueOf(check.get("currentStatus"));

            if (refundCount > 0) {
                resultMap.put("message", "이미 환불이 진행중입니다.");
                resultMap.put("result", "fail");
                return resultMap;
            }

            if (!("DONE".equals(status) || "COMPLETED".equals(status))) {
                resultMap.put("message", "환불 가능한 상태가 아닙니다. 현재 상태" + status);
                resultMap.put("result", "fail");
                return resultMap;
            }

            // 2. amount null 체크
            if (map.get("amount") == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "환불 금액이 없습니다.");
                return resultMap;
            }

            int requestAmount = Integer.parseInt(String.valueOf(map.get("amount")));

            if (requestAmount <= 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", "환불 금액이 올바르지 않습니다.");
                return resultMap;
            }

            // 3. 주문 정보 조회
            List<HashMap<String, Object>> list = refundMapper.selectOrderInfoForRefund(map);

            if (list == null || list.isEmpty()) {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            Object totalPayObj = list.get(0).get("totalPayAmount");
            Object paymentKeyObj = list.get(0).get("paymentKey");
            Object payIdObj = list.get(0).get("payId");

            if (totalPayObj == null || paymentKeyObj == null || "".equals(String.valueOf(paymentKeyObj))) {
                resultMap.put("result", "fail");
                resultMap.put("message", "결제 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            int totalPay = Integer.parseInt(String.valueOf(totalPayObj));
            String paymentKey = String.valueOf(paymentKeyObj);

            map.put("paymentKey", paymentKey);
            map.put("payId", payIdObj);

            // 4. 누적 환불 금액 조회
            int refundedAmount = refundMapper.selectRefundAmountSum(map);

            // 로그
            System.out.println("orderId=" + map.get("orderId"));
            System.out.println("환불요청=" + requestAmount + ", 누적=" + refundedAmount + ", 총=" + totalPay);

            // 5. 금액 검증
            if (refundedAmount + requestAmount > totalPay) {
                resultMap.put("message", "환불 금액이 결제 금액을 초과합니다.");
                resultMap.put("result", "fail");
                return resultMap;
            }

            // 6. 환불 데이터 저장
            int insertResult = refundMapper.insertRefund(map);
            if (insertResult > 0) {
            	System.out.println("refundId=" + map.get("refundId")); // 환불정보확인

            	// 7. 토스 환불 API 호출
                boolean tossResult = callTossCancelApi(map, paymentKey, requestAmount);
                
                if (!tossResult) {
                    throw new Exception("토스 환불 API 실패");
                }

                // 8. 환불상태 완료 변경
                int refundUpdateResult = refundMapper.updateRefundCompleted(map);
                
                if (refundUpdateResult == 0) {
                	throw new Exception("환불 상태 변경 실패");
                }
                
                // 9. 결제 상태 환불 완료 처리
                int paymentUpdateResult = refundMapper.updatePaymentRefunded(map);
                
                if (paymentUpdateResult == 0) {
                	throw new Exception("결제 상태 변경 실패");
                }
                
                // 10. 주문 상태 변경
                int updateResult = refundMapper.updateOrderStatus(map);
                
                if (updateResult == 0) {
                	throw new Exception("주문 상태 변경 실패");
                }
                
                try {
                    String refundUserId = String.valueOf(map.get("userId"));
                    if (refundUserId != null && !"null".equals(refundUserId)) {
                        alarmService.createAlarm(
                            refundUserId, 
                            "NOTICE",
                            "환불이 완료되었습니다 💸",
                            requestAmount + "원 환불이 처리되었습니다. 3~5 영업일 내 입금됩니다.",
                            String.valueOf(map.get("orderId"))
                        );
                    }
                } catch (Exception e) {
                    // 알림 발송 실패가 전체 환불 로직을 롤백시키지 않도록 예외 처리
                    System.err.println("알림 발송 중 오류 발생: " + e.getMessage());
                }

                resultMap.put("result", "success");
                resultMap.put("message", "환불 요청이 완료되었습니다.");

            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "환불 요청 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "서버 오류");
            throw new RuntimeException(e);
        }

        return resultMap;
    }
    
 // 토스 환불 API 호출
    private boolean callTossCancelApi(HashMap<String, Object> map, String paymentKey, int cancelAmount) {
        try {
            String cancelReason = String.valueOf(map.get("refundReason"));

            if (map.get("reasonDetail") != null && !"".equals(String.valueOf(map.get("reasonDetail")))) {
                cancelReason += " - " + String.valueOf(map.get("reasonDetail"));
            }

            String auth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes());

            String body = "{"
                    + "\"cancelReason\":\"" + escapeJson(cancelReason) + "\","
                    + "\"cancelAmount\":" + cancelAmount
                    + "}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel"))
                    .header("Authorization", "Basic " + auth)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            System.out.println("토스 환불 status=" + response.statusCode());
            System.out.println("토스 환불 body=" + response.body());

            return response.statusCode() == 200;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // JSON 문자열 깨짐 방지
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }

        return str
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }

}