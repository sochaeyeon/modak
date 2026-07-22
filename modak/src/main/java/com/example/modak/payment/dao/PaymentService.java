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
	@Transactional
	public HashMap<String, Object> readyPayment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		System.out.println("=== cartType: " + map.get("cartType"));
		System.out.println("=== guestItems: " + map.get("guestItems"));

		try {
			List<HashMap<String, Object>> items;
			String guestItemsJson = String.valueOf(map.get("guestItems"));

			if (guestItemsJson != null && !"null".equals(guestItemsJson) && !"".equals(guestItemsJson)) {
				Gson gson = new Gson();
				items = gson.fromJson(guestItemsJson,
						new com.google.gson.reflect.TypeToken<List<HashMap<String, Object>>>() {
						}.getType());
			} else {
				items = paymentMapper.selectCheckoutItems(map);
			}

			if (items == null || items.isEmpty()) {
				throw new RuntimeException("주문 상품이 없습니다.");
			}

			String cartType = String.valueOf(map.get("cartType"));
			long serverAmount = 0;

			for (HashMap<String, Object> item : items) {
				normalizeOrderItem(item, cartType);

				long unitPrice = ((Number) item.get("unitPrice")).longValue();
				long quantity = ((Number) item.get("quantity")).longValue();

				if ("RENTAL".equals(cartType)) {
					long deposit = item.get("deposit") == null ? 0 : ((Number) item.get("deposit")).longValue();

					String start = String.valueOf(item.get("rentalStart"));
					String end = String.valueOf(item.get("rentalEnd"));

					long nights = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.parse(start),
							java.time.LocalDate.parse(end));

					if (nights <= 0) {
						throw new RuntimeException("대여 기간이 올바르지 않습니다.");
					}

					serverAmount += (unitPrice * nights + deposit) * quantity;
				} else {
					serverAmount += unitPrice * quantity;
				}
			}

			long discountAmt = 0;
			if (map.get("discountAmt") != null && !"".equals(String.valueOf(map.get("discountAmt")))
					&& !"null".equals(String.valueOf(map.get("discountAmt")))) {
				discountAmt = Long.parseLong(String.valueOf(map.get("discountAmt")));
			}

			long usePoint = 0;
			if (map.get("usePoint") != null && !"".equals(String.valueOf(map.get("usePoint")))
					&& !"null".equals(String.valueOf(map.get("usePoint")))) {
				usePoint = Long.parseLong(String.valueOf(map.get("usePoint")));
			}

			if (map.get("userCouponId") != null && !"".equals(String.valueOf(map.get("userCouponId")))
					&& !"null".equals(String.valueOf(map.get("userCouponId")))) {

				HashMap<String, Object> coupon = paymentMapper.selectValidCoupon(map);

				if (coupon == null) {
					throw new RuntimeException("이미 사용된 쿠폰입니다.");
				}
			}

			long finalAmount = Math.max(0, serverAmount - discountAmt - usePoint);

			map.put("amount", finalAmount);
			map.put("usePoint", usePoint);

			paymentMapper.insertTempOrder(map);

			Object orderId = map.get("orderId");

			if (orderId == null) {
				throw new RuntimeException("주문번호 생성에 실패했습니다.");
			}

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
		Long orderIdLong = Long.parseLong(orderId.replace("modak-", ""));

		HashMap<String, Object> checkMap = new HashMap<>();
		checkMap.put("orderId", orderIdLong);

		int paidCount = paymentMapper.selectPaidPaymentCount(checkMap);

		if (paidCount > 0) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "success");
			resultMap.put("message", "이미 처리된 결제입니다.");
			return resultMap;
		}

		HttpResponse<String> response = callTossApi(paymentKey, orderId, amount);

		if (response != null && response.statusCode() == 200) {
			try {
				HashMap<String, Object> tossMap = new Gson().fromJson(response.body(), HashMap.class);

				String payMethod = tossMap.get("method") == null ? "CARD" : String.valueOf(tossMap.get("method"));

				Object easyPayObj = tossMap.get("easyPay");

				String easyPayProvider = null;

				if (easyPayObj instanceof java.util.Map) {

					java.util.Map<String, Object> easyPayMap = (java.util.Map<String, Object>) easyPayObj;

					if (easyPayMap.get("provider") != null) {
						easyPayProvider = String.valueOf(easyPayMap.get("provider"));
					}
				}

				System.out.println("easyPayProvider : " + easyPayProvider);

				return processAfterPayment(orderIdLong, amount, paymentKey, payMethod, easyPayProvider);
			} catch (Exception e) {
				e.printStackTrace();

				HashMap<String, Object> failMap = new HashMap<>();
				failMap.put("orderId", orderIdLong);
				failMap.put("orderStatus", "CANCELLED");
				paymentMapper.updateOrderStatus(failMap);

				HashMap<String, Object> resultMap = new HashMap<>();
				resultMap.put("result", "error");
				resultMap.put("message", e.getMessage());
				return resultMap;
			}
		} else {
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

			HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

			System.out.println("=== 토스 결제 confirm 응답 ===");
			System.out.println("orderId : " + orderId);
			System.out.println("statusCode : " + response.statusCode());
			System.out.println("body : " + response.body());
			System.out.println("==============================");

			return response;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// DB 처리 전용 - 트랜잭션 적용
	@Transactional
	public HashMap<String, Object> processAfterPayment(Long orderIdLong, Long amount, String paymentKey,
			String payMethod, String easyPayProvider) {
		HashMap<String, Object> resultMap = new HashMap<>();

		HashMap<String, Object> baseMap = new HashMap<>();
		baseMap.put("orderId", orderIdLong);

		HashMap<String, Object> orderInfo = paymentMapper.selectOrderById(baseMap);

		if (orderInfo == null) {
			throw new RuntimeException("주문 정보를 찾을 수 없습니다.");
		}

		int paidCount = paymentMapper.selectPaidPaymentCount(baseMap);
		if (paidCount > 0) {
			resultMap.put("result", "success");
			return resultMap;
		}

		String userId = String.valueOf(orderInfo.get("userId"));
		if (userId == null || "null".equals(userId)) {
			userId = String.valueOf(orderInfo.get("USER_ID"));
		}

		boolean isGuest = userId != null && userId.startsWith("GUEST_");

		baseMap.put("orderStatus", "PAID");
		paymentMapper.updateOrderStatus(baseMap);

		baseMap.put("amount", amount);
		baseMap.put("paymentKey", paymentKey);
		baseMap.put("payMethod", payMethod);
		baseMap.put("easyPayProvider", easyPayProvider);
		paymentMapper.insertPayment(baseMap);

		String orderType = getStringValue(orderInfo, "orderType", "ORDER_TYPE");
		baseMap.put("payType", orderType);
		paymentMapper.insertPaymentHistory(baseMap);

		Object userCouponId = orderInfo.get("userCouponId");
		if (userCouponId == null) {
			userCouponId = orderInfo.get("USER_COUPON_ID");
		}

		if (!isGuest && userCouponId != null && !"".equals(String.valueOf(userCouponId))
				&& !"null".equals(String.valueOf(userCouponId))) {

			long discountAmt = getLongValue(orderInfo, "discountAmt", "DISCOUNT_AMT");

			HashMap<String, Object> couponMap = new HashMap<>();
			couponMap.put("userCouponId", userCouponId);
			couponMap.put("userId", userId);
			couponMap.put("orderId", orderIdLong);
			couponMap.put("discountAmt", discountAmt);

			int updated = paymentMapper.updateCouponUsed(couponMap);

			if (updated == 0) {
				throw new RuntimeException("이미 사용된 쿠폰입니다.");
			}

			paymentMapper.insertCouponUseLog(couponMap);

			alarmService.createAlarm(userId, "EVENT", "쿠폰이 사용되었습니다 🎫", "보유 쿠폰이 결제에 적용되었습니다.", orderIdLong);
		}

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

		List<HashMap<String, Object>> orderItems = paymentMapper.selectOrderItemsForStock(baseMap);

		if (orderItems == null || orderItems.isEmpty()) {
			throw new RuntimeException("주문상품 정보가 없습니다.");
		}

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
			    stockMap.put("defaultQty", 10);

			    // 대여 최대 기간(7박) 서버 검증 - 프론트 캘린더 검증과 동일한 정책을
			    // 결제 승인 단계에서도 강제해, API 직접 호출로 프론트 검증을 우회하는 경우를 방지
			    long rentalDays = java.time.temporal.ChronoUnit.DAYS.between(
			            java.time.LocalDate.parse(String.valueOf(stockMap.get("startDate"))),
			            java.time.LocalDate.parse(String.valueOf(stockMap.get("endDate"))));

			    if (rentalDays > 7) {
			        throw new RuntimeException(
			                "최대 대여 가능 기간은 7일(7박)입니다 - PRODUCT_ID: " + stockMap.get("productId"));
			    }
			    
			    paymentMapper.insertStockIfNotExists(stockMap);

			    int updatedRows = paymentMapper.decreaseStockForRental(stockMap);

				if (updatedRows != rentalDays) {
					throw new RuntimeException("대여 재고 부족 - PRODUCT_ID: " + stockMap.get("productId"));
				}

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

		baseMap.put("userId", userId);
		paymentMapper.deleteCartByOrderId(baseMap);

		if (!isGuest) {
			String orderName = getStringValue(orderInfo, "orderName", "ORDER_NAME");

			alarmService.createAlarm(userId, "NOTICE", "결제가 완료되었습니다 🛒",
					(orderName != null ? orderName : "주문") + "의 결제가 완료되었습니다.", orderIdLong);
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
		if (value == null || "".equals(String.valueOf(value)))
			return 0L;

		if (value instanceof Number) {
			return ((Number) value).longValue(); // Gson Double이든 DB Integer든 전부 처리
		}
		return Long.parseLong(String.valueOf(value)); // 혹시 String으로 온 경우 폴백
	}

	private void normalizeOrderItem(HashMap<String, Object> item, String cartType) {
		if ("EXCHANGE".equals(cartType)) {
			if (item.get("quantity") == null || "null".equals(String.valueOf(item.get("quantity")))) {
				item.put("quantity", 1);
			}
			if (item.get("unitPrice") == null || "null".equals(String.valueOf(item.get("unitPrice")))) {
				item.put("unitPrice", item.get("price"));
			}
			if (item.get("unitPrice") == null || "null".equals(String.valueOf(item.get("unitPrice")))) {
				throw new RuntimeException("교환 차액 가격 정보가 없습니다.");
			}
			// 교환 결제는 productId/optionItemId 없으므로 0으로 세팅
			if (item.get("productId") == null)
				item.put("productId", 0);
			if (item.get("optionItemId") == null)
				item.put("optionItemId", 0);
			item.put("rentalStart", null);
			item.put("rentalEnd", null);
			return;
		}

		if (item.get("productId") == null || "null".equals(String.valueOf(item.get("productId")))) {
			throw new RuntimeException("상품 정보가 없습니다.");
		}

		if (item.get("optionItemId") == null || "null".equals(String.valueOf(item.get("optionItemId")))) {
			throw new RuntimeException("옵션 정보가 없습니다.");
		}

		if (item.get("quantity") == null || "null".equals(String.valueOf(item.get("quantity")))) {
			item.put("quantity", 1);
		}

		if (item.get("unitPrice") == null || "null".equals(String.valueOf(item.get("unitPrice")))) {
			item.put("unitPrice", item.get("price"));
		}

		if (item.get("unitPrice") == null || "null".equals(String.valueOf(item.get("unitPrice")))) {
			throw new RuntimeException("상품 가격 정보가 없습니다.");
		}

		if ("RENTAL".equals(cartType)) {
			if (item.get("rentalStart") == null || "null".equals(String.valueOf(item.get("rentalStart")))) {
				item.put("rentalStart", item.get("startDate"));
			}

			if (item.get("rentalEnd") == null || "null".equals(String.valueOf(item.get("rentalEnd")))) {
				item.put("rentalEnd", item.get("endDate"));
			}

			if (item.get("rentalStart") == null || item.get("rentalEnd") == null
					|| "null".equals(String.valueOf(item.get("rentalStart")))
					|| "null".equals(String.valueOf(item.get("rentalEnd")))
					|| "".equals(String.valueOf(item.get("rentalStart")))
					|| "".equals(String.valueOf(item.get("rentalEnd")))) {
				throw new RuntimeException("대여 날짜가 없습니다.");
			}
		} else {
			item.put("rentalStart", null);
			item.put("rentalEnd", null);
		}
	}

}