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

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.payment.mapper.PaymentMapper;
import com.google.gson.Gson;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;
	@Autowired
	private AlarmService alarmService;
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
	        // 1. 주문 상품 먼저 조회
	    	List<HashMap<String, Object>> items;
	    	String guestItemsJson = String.valueOf(map.get("guestItems"));

	    	if (guestItemsJson != null && !"null".equals(guestItemsJson) && !"".equals(guestItemsJson)) {
	    	    Gson gson = new Gson();
	    	    items = gson.fromJson(guestItemsJson,
	    	        new com.google.gson.reflect.TypeToken<List<HashMap<String, Object>>>(){}.getType());
	    	} else {
	    	    items = paymentMapper.selectCheckoutItems(map);
	    	}

	        // 2. 서버에서 총액 재계산
	        long serverAmount = 0;
	        String cartType = String.valueOf(map.get("cartType"));

	        for (HashMap<String, Object> item : items) {
	        	
	        	long unitPrice = item.get("unitPrice") != null
	        		    ? ((Number) item.get("unitPrice")).longValue()
	        		    : ((Number) item.get("price")).longValue();

	        	long quantity = ((Number) item.get("quantity")).longValue();

	            if ("RENTAL".equals(cartType)) {
	            	long deposit = item.get("deposit") == null ? 0
	            		    : ((Number) item.get("deposit")).longValue();

	                String start = String.valueOf(item.get("rentalStart"));
	                String end = String.valueOf(item.get("rentalEnd"));
	                if (start == null || end == null || "null".equals(start) || "null".equals(end) || "".equals(start) || "".equals(end)) {
	                    throw new RuntimeException("대여 날짜가 없습니다.");
	                }

	                long nights = java.time.temporal.ChronoUnit.DAYS.between(
	                    java.time.LocalDate.parse(start),
	                    java.time.LocalDate.parse(end)
	                );

	                serverAmount += (unitPrice * nights + deposit) * quantity;
	            } else {
	                serverAmount += unitPrice * quantity;
	            }
	        }

	     // 3. 쿠폰 할인 + 포인트 반영
	        long discountAmt = 0;
	        if (map.get("discountAmt") != null && !"".equals(String.valueOf(map.get("discountAmt")))) {
	            discountAmt = Long.parseLong(String.valueOf(map.get("discountAmt")));
	        }

	        long usePoint = 0;
	        if (map.get("usePoint") != null && !"".equals(String.valueOf(map.get("usePoint"))) && !"null".equals(String.valueOf(map.get("usePoint")))) {
	            usePoint = Long.parseLong(String.valueOf(map.get("usePoint")));
	        }
	     // ✅ 쿠폰 검증
	        if (map.get("userCouponId") != null 
	                && !"".equals(String.valueOf(map.get("userCouponId")))
	                && !"null".equals(String.valueOf(map.get("userCouponId")))) {

	            HashMap<String, Object> coupon = paymentMapper.selectValidCoupon(map);

	            if (coupon == null) {
	                throw new RuntimeException("이미 사용된 쿠폰입니다.");
	            }
	        }

	        map.put("usePoint", usePoint); // ← insertTempOrder에 넘기기 위해 필요
	        long finalAmount = Math.max(0, serverAmount - discountAmt - usePoint);
	        map.put("amount", finalAmount);
	        

	        // 4. 주문 생성
	        paymentMapper.insertTempOrder(map);

	        Object orderId = map.get("orderId");

	        // 5. 주문상품 생성
	        for (HashMap<String, Object> item : items) {
	            item.put("orderId", orderId);

	            if (item.get("unitPrice") == null) {
	                item.put("unitPrice", item.get("price"));
	            }

	            if (item.get("optionItemId") == null || "null".equals(String.valueOf(item.get("optionItemId")))) {
	                throw new RuntimeException("optionItemId 없음 - 주문상품 저장 불가");
	            }

	            paymentMapper.insertOrderItem(item);
	        }
	        resultMap.put("result", "success");
	        resultMap.put("orderId", orderId);
	        resultMap.put("amount", finalAmount);

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "주문 준비 실패: " + e.getMessage());
	    }

	    return resultMap;
	}
	// 토스 API 승인 - 트랜잭션 없음
	public HashMap<String, Object> confirmPayment(String paymentKey, String orderId, Long amount) {

	    HttpResponse<String> response = callTossApi(paymentKey, orderId, amount);
	    Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));

	    if (response != null && response.statusCode() == 200) {
	        try {
	            return processAfterPayment(orderIdLong, amount, paymentKey);
	        } catch (Exception e) {
	            // ✅ DB 처리 중 오류 → 주문 취소 처리 후 에러 페이지로
	            e.printStackTrace();
	            HashMap<String, Object> failMap = new HashMap<>();
	            failMap.put("orderId", orderIdLong);
	            failMap.put("orderStatus", "CANCELLED");
	            paymentMapper.updateOrderStatus(failMap);

	            HashMap<String, Object> resultMap = new HashMap<>();
	            resultMap.put("result", "error");        // ← "fail"과 구분하기 위해 "error"
	            resultMap.put("message", e.getMessage());
	            return resultMap;
	        }
	    } else {
	        // 토스 승인 실패 → 결제 실패 페이지
	        HashMap<String, Object> failMap = new HashMap<>();
	        failMap.put("orderId", orderIdLong);
	        failMap.put("orderStatus", "CANCELLED");
	        paymentMapper.updateOrderStatus(failMap);

	        HashMap<String, Object> resultMap = new HashMap<>();
	        resultMap.put("result", "fail");
	        String failMessage = response == null ? "토스 승인 요청 실패" : response.body();
	        resultMap.put("message", "토스 승인 실패: " + failMessage);
	        return resultMap;
	    }
	}

	private HttpResponse<String> callTossApi(String paymentKey, String orderId, Long amount) {
		try {
			String auth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes());

			String body = String.format("{\"paymentKey\":\"%s\",\"orderId\":\"%s\",\"amount\":%d}", paymentKey, orderId,
					amount);

			HttpClient client = HttpClient.newHttpClient();
			HttpRequest request = HttpRequest.newBuilder()
					.uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
					.header("Authorization", "Basic " + auth).header("Content-Type", "application/json")
					.POST(HttpRequest.BodyPublishers.ofString(body)).build();

			return client.send(request, HttpResponse.BodyHandlers.ofString());

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// DB 처리 전용 - 트랜잭션 적용
	@Transactional
	public HashMap<String, Object> processAfterPayment(Long orderIdLong, Long amount, String paymentKey) {
		HashMap<String, Object> resultMap = new HashMap<>();

		HashMap<String, Object> baseMap = new HashMap<>();
		baseMap.put("orderId", orderIdLong);

		HashMap<String, Object> orderInfo = paymentMapper.selectOrderById(baseMap);
		if (orderInfo == null) {
			throw new RuntimeException("주문 정보를 찾을 수 없습니다.");
		}

		String userId = String.valueOf(orderInfo.get("userId"));
		if (userId == null || "null".equals(userId)) {
			userId = String.valueOf(orderInfo.get("USER_ID"));
		}

		boolean isGuest = userId != null && userId.startsWith("GUEST_");

		// 1. 주문 상태 PAID
		baseMap.put("orderStatus", "PAID");
		paymentMapper.updateOrderStatus(baseMap);

		// 2. 결제 INSERT
		baseMap.put("amount", amount);
		baseMap.put("paymentKey", paymentKey);
		paymentMapper.insertPayment(baseMap);

		// 3. 결제 이력 INSERT
		String orderType = getStringValue(orderInfo, "orderType", "ORDER_TYPE");
		baseMap.put("payType", orderType);
		paymentMapper.insertPaymentHistory(baseMap);

		// 4. 장바구니 삭제
		baseMap.put("userId", userId);
		paymentMapper.deleteCartByOrderId(baseMap);

		// 5. 쿠폰 사용 처리
		Object userCouponId = orderInfo.get("userCouponId");
		if (userCouponId == null) {
		    userCouponId = orderInfo.get("USER_COUPON_ID");
		}

		// ✅ 1. "null" 문자열 체크 추가 (DB에서 null이 "null" 문자열로 올 때 방지)
		if (!isGuest && userCouponId != null && !"".equals(String.valueOf(userCouponId)) && !"null".equals(String.valueOf(userCouponId))) {
		    long totalPrice = getLongValue(orderInfo, "totalPrice", "TOTAL_PRICE");
		    long discountAmt = getLongValue(orderInfo, "discountAmt", "DISCOUNT_AMT");

		    HashMap<String, Object> couponMap = new HashMap<>();
		    couponMap.put("userCouponId", userCouponId);
		    couponMap.put("userId", userId);
		    couponMap.put("orderId", orderIdLong);
		    couponMap.put("discountAmt", discountAmt);

		    // ✅ 2. 결과값 확인용 로그 추가 (updateCouponUsed가 0이면 WHERE 조건 불일치)
		    int updated = paymentMapper.updateCouponUsed(couponMap);

		    if (updated == 0) {
		        throw new RuntimeException("이미 사용된 쿠폰입니다.");
		    }

		    paymentMapper.insertCouponUseLog(couponMap);
		    alarmService.createAlarm(userId, "EVENT",
		            "쿠폰이 사용되었습니다 🎫",
		            "보유 쿠폰이 결제에 적용되었습니다.",
		            orderIdLong);
		}

		// 6. 포인트 적립
		if (!isGuest) {
			long earnedPoint = amount / 100;
			long usePoint = getLongValue(orderInfo, "usePoint", "USE_POINT");

			String orderName = getStringValue(orderInfo, "orderName", "ORDER_NAME");
			long itemCount = getLongValue(orderInfo, "itemCount", "ITEM_COUNT");

			String description = "구매 적립";
			if (orderName != null && !"".equals(orderName)) {
				description += " - " + orderName;
				if (itemCount > 1) {
					description += " 외 " + (itemCount - 1) + "건";
				}
			}

			HashMap<String, Object> userUpdateMap = new HashMap<>();
			userUpdateMap.put("userId", userId);
			userUpdateMap.put("earnedPoint", earnedPoint);
			userUpdateMap.put("usePoint", usePoint);
			userUpdateMap.put("amount", amount);
			userUpdateMap.put("description", description);

			if (earnedPoint > 0) {
				paymentMapper.insertPointHistory(userUpdateMap);
			}

			paymentMapper.updateUserPointAndAmount(userUpdateMap);
		}

		// 7. 재고 차감
		List<HashMap<String, Object>> orderItems = paymentMapper.selectOrderItemsForStock(baseMap);

		for (HashMap<String, Object> item : orderItems) {
		    String itemOrderType = getStringValue(item, "orderType", "ORDER_TYPE");

		    HashMap<String, Object> stockMap = new HashMap<>();
		    stockMap.put("productId", getValue(item, "productId", "PRODUCT_ID"));
		    stockMap.put("optionItemId", getValue(item, "optionItemId", "OPTION_ITEM_ID"));
		    stockMap.put("quantity", getValue(item, "quantity", "QUANTITY"));
		    if (stockMap.get("optionItemId") == null || "null".equals(String.valueOf(stockMap.get("optionItemId")))) {
		        throw new RuntimeException("optionItemId 없음 - 재고 처리 불가");
		    }

		    if ("PURCHASE".equals(itemOrderType)) {
		        int updated = paymentMapper.decreaseStockForPurchase(stockMap);
		        if (updated == 0) {
		        	throw new RuntimeException("구매 재고 부족 또는 재고 데이터 없음 - PRODUCT_ID: " + stockMap.get("productId")
	                + ", OPTION_ITEM_ID: " + stockMap.get("optionItemId"));
		        }

		    } else if ("RENTAL".equals(itemOrderType)) {
		        stockMap.put("startDate", getValue(item, "startDate", "START_DATE"));
		        stockMap.put("endDate", getValue(item, "endDate", "END_DATE"));

		        // 1. 날짜별 재고 레코드 없으면 자동 생성
		        stockMap.put("defaultQty", 10);
		        paymentMapper.insertStockIfNotExists(stockMap);
		        System.out.println("재고 생성 완료: " + stockMap);

		        // 2. 재고 차감
		        int updatedRows = paymentMapper.decreaseStockForRental(stockMap);

		        // 3. 차감된 rows가 대여 일수보다 적으면 재고 부족
		        long rentalDays = java.time.temporal.ChronoUnit.DAYS.between(
		            java.time.LocalDate.parse(String.valueOf(stockMap.get("startDate"))),
		            java.time.LocalDate.parse(String.valueOf(stockMap.get("endDate")))
		        );
		        
		        long expectedRows = rentalDays;

		        if (updatedRows != expectedRows) {
		            throw new RuntimeException("대여 재고 부족 - PRODUCT_ID: " + stockMap.get("productId"));
		        }

		        // 4. rental 이력 INSERT
		        int quantity = Integer.parseInt(String.valueOf(getValue(item, "quantity", "QUANTITY")));
		        for (int i = 0; i < quantity; i++) {
		            HashMap<String, Object> rentalMap = new HashMap<>();
		            rentalMap.put("itemId", getValue(item, "itemId", "ITEM_ID"));
		            rentalMap.put("userId", userId);
		            rentalMap.put("startDate", getValue(item, "startDate", "START_DATE"));
		            rentalMap.put("returnDate", getValue(item, "endDate", "END_DATE"));
		            rentalMap.put("guestName", getValue(orderInfo, "guestName", "GUEST_NAME"));
		            rentalMap.put("guestPhone", getValue(orderInfo, "guestPhone", "GUEST_PHONE"));
		            paymentMapper.insertRental(rentalMap);
		        }
		    }
		}
	
		if (!isGuest) {
		    String orderName = getStringValue(orderInfo, "orderName", "ORDER_NAME");
		    alarmService.createAlarm(userId, "NOTICE",
		        "결제가 완료되었습니다 🛒",
		        (orderName != null ? orderName : "주문") + "의 결제가 완료되었습니다.",
		        orderIdLong);
		}
		resultMap.put("result", "success");
		return resultMap;
	}

	private Object getValue(HashMap<String, Object> map, String camelKey, String upperKey) {
		Object value = map.get(camelKey);
		if (value == null) {
			value = map.get(upperKey);
		}
		return value;
	}

	private String getStringValue(HashMap<String, Object> map, String camelKey, String upperKey) {
		Object value = getValue(map, camelKey, upperKey);
		return value == null ? null : String.valueOf(value);
	}

	private long getLongValue(HashMap<String, Object> map, String camelKey, String upperKey) {
	    Object value = getValue(map, camelKey, upperKey);
	    if (value == null || "".equals(String.valueOf(value))) return 0L;
	    
	    if (value instanceof Number) {
	        return ((Number) value).longValue();  // Gson Double이든 DB Integer든 전부 처리
	    }
	    return Long.parseLong(String.valueOf(value));  // 혹시 String으로 온 경우 폴백
	}

}