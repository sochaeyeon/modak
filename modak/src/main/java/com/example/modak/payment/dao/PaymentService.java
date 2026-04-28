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
	        // 1. 주문 상품 먼저 조회
	        List<HashMap<String, Object>> items = paymentMapper.selectCheckoutItems(map);

	        if (items == null || items.size() == 0) {
	            throw new RuntimeException("주문 상품이 없습니다.");
	        }

	        // 2. 서버에서 총액 재계산
	        long serverAmount = 0;
	        String cartType = String.valueOf(map.get("cartType"));

	        for (HashMap<String, Object> item : items) {
	            long unitPrice = Long.parseLong(String.valueOf(item.get("unitPrice")));
	            long quantity = Long.parseLong(String.valueOf(item.get("quantity")));

	            if ("RENTAL".equals(cartType)) {
	                long deposit = item.get("deposit") == null ? 0 : Long.parseLong(String.valueOf(item.get("deposit")));

	                String start = String.valueOf(item.get("rentalStart"));
	                String end = String.valueOf(item.get("rentalEnd"));

	                long nights = java.time.temporal.ChronoUnit.DAYS.between(
	                    java.time.LocalDate.parse(start),
	                    java.time.LocalDate.parse(end)
	                );

	                serverAmount += (unitPrice * nights + deposit) * quantity;
	            } else {
	                serverAmount += unitPrice * quantity;
	            }
	        }

	        // 3. 쿠폰 할인 반영
	        long discountAmt = 0;
	        if (map.get("discountAmt") != null && !"".equals(String.valueOf(map.get("discountAmt")))) {
	            discountAmt = Long.parseLong(String.valueOf(map.get("discountAmt")));
	        }

	        long finalAmount = Math.max(0, serverAmount - discountAmt);

	        map.put("amount", finalAmount);

	        // 4. 주문 생성
	        paymentMapper.insertTempOrder(map);

	        Object orderId = map.get("orderId");

	        // 5. 주문상품 생성
	        for (HashMap<String, Object> item : items) {
	            item.put("orderId", orderId);
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

		// 1. 토스 API 승인 요청 (트랜잭션 밖)
		HttpResponse<String> response = callTossApi(paymentKey, orderId, amount);
		Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));
		if (response != null && response.statusCode() == 200) {
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
	public HashMap<String, Object> processAfterPayment(Long orderIdLong, Long amount) {
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
		paymentMapper.insertPayment(baseMap);

		// 3. 결제 이력 INSERT
		baseMap.put("payType", "PURCHASE");
		paymentMapper.insertPaymentHistory(baseMap);

		// 4. 장바구니 삭제
		baseMap.put("userId", userId);
		paymentMapper.deleteCartByOrderId(baseMap);

		// 5. 쿠폰 사용 처리
		Object userCouponId = orderInfo.get("userCouponId");
		if (userCouponId == null) {
			userCouponId = orderInfo.get("USER_COUPON_ID");
		}

		if (!isGuest && userCouponId != null && !"".equals(String.valueOf(userCouponId))) {
			long totalPrice = getLongValue(orderInfo, "totalPrice", "TOTAL_PRICE");
			long discountAmt = Math.max(0, totalPrice - amount);

			HashMap<String, Object> couponMap = new HashMap<>();
			couponMap.put("userCouponId", userCouponId);
			couponMap.put("userId", userId);
			couponMap.put("orderId", orderIdLong);
			couponMap.put("discountAmt", discountAmt);

			paymentMapper.updateCouponUsed(couponMap);
			paymentMapper.insertCouponUseLog(couponMap);
		}

		// 6. 포인트 적립
		if (!isGuest) {
			long earnedPoint = amount / 100;

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
			String orderType = getStringValue(item, "orderType", "ORDER_TYPE");

			HashMap<String, Object> stockMap = new HashMap<>();
			stockMap.put("productId", getValue(item, "productId", "PRODUCT_ID"));
			stockMap.put("optionItemId", getValue(item, "optionItemId", "OPTION_ITEM_ID"));
			stockMap.put("quantity", getValue(item, "quantity", "QUANTITY"));

			if ("PURCHASE".equals(orderType)) {
				int updated = paymentMapper.decreaseStockForPurchase(stockMap);
				if (updated == 0) {
					throw new RuntimeException("재고 부족 - PRODUCT_ID: " + stockMap.get("productId"));
				}
			} else if ("RENTAL".equals(orderType)) {
			    stockMap.put("startDate", getValue(item, "startDate", "START_DATE"));
			    stockMap.put("endDate", getValue(item, "endDate", "END_DATE"));

			    int updated = paymentMapper.decreaseStockForRental(stockMap);
			    if (updated == 0) {
			        throw new RuntimeException("대여 재고 부족 - PRODUCT_ID: " + stockMap.get("productId"));
			    }

			    int quantity = Integer.parseInt(String.valueOf(getValue(item, "quantity", "QUANTITY")));

			    for (int i = 0; i < quantity; i++) {
			        HashMap<String, Object> rentalMap = new HashMap<>();

			        rentalMap.put("itemId", getValue(item, "optionItemId", "OPTION_ITEM_ID"));
			        rentalMap.put("userId", userId); // 회원ID 또는 GUEST
			        rentalMap.put("startDate", getValue(item, "startDate", "START_DATE"));
			        rentalMap.put("returnDate", getValue(item, "endDate", "END_DATE"));
			        rentalMap.put("guestName", getValue(orderInfo, "guestName", "GUEST_NAME"));
			        rentalMap.put("guestPhone", getValue(orderInfo, "guestPhone", "GUEST_PHONE"));

			        paymentMapper.insertRental(rentalMap);
			    }
			}
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
		if (value == null || "".equals(String.valueOf(value))) {
			return 0L;
		}
		return Long.parseLong(String.valueOf(value));
	}

}