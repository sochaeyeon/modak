package com.example.modak.order.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.order.mapper.GuestOrderMapper;
import com.example.modak.order.model.GuestOrder;
import com.example.modak.order.model.GuestOrderItem;

@Service
public class GuestOrderService {

	@Autowired
	private GuestOrderMapper guestOrderMapper;

	private static final Map<String, TokenEntry> TOKEN_STORE = new ConcurrentHashMap<>();
	private static final long TOKEN_TTL_MS = 30 * 60 * 1000L;

	public HashMap<String, Object> inquireGuestOrder(String orderId, String guestName, String guestPhone) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			GuestOrder order = guestOrderMapper.selectGuestOrder(orderId, guestName, guestPhone);

			if (order == null) {
				result.put("result", "fail");
				result.put("message", "입력하신 정보와 일치하는 주문을 찾을 수 없습니다.");
				return result;
			}

			String token = UUID.randomUUID().toString().replace("-", "");
			TOKEN_STORE.put(token, new TokenEntry(orderId, System.currentTimeMillis()));
			purgeExpiredTokens();

			result.put("result", "success");
			result.put("orderId", orderId);
			result.put("token", token);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	public HashMap<String, Object> getGuestOrderDetail(String orderId, String token) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			orderId = orderId.trim();
			token = token.trim();
			if (!validateToken(token, orderId)) {
				result.put("result", "fail");
				result.put("message", "유효하지 않은 접근입니다. 다시 조회해주세요.");
				return result;
			}

			GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);

			if (order == null) {
				result.put("result", "fail");
				result.put("message", "주문 정보를 찾을 수 없습니다.");
				return result;
			}

			List<GuestOrderItem> items = guestOrderMapper.selectGuestOrderItems(orderId);
			order.setItems(items);

			Integer rentalId = guestOrderMapper.selectRentalIdByOrderId(orderId);
			if (rentalId != null) {
			    order.setRentalId(rentalId);
			}

			result.put("result", "success");
			result.put("order", order);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	public HashMap<String, Object> cancelGuestOrder(String orderId, String token) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			if (!validateToken(token, orderId)) {
				result.put("result", "fail");
				result.put("message", "유효하지 않은 접근입니다.");
				return result;
			}

			GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);

			if (order == null) {
				result.put("result", "fail");
				result.put("message", "주문 정보를 찾을 수 없습니다.");
				return result;
			}

			String status = order.getOrderStatus();

			if (!"PAID".equals(status) && !"READY".equals(status)) {
				result.put("result", "fail");
				result.put("message", "현재 상태에서는 취소할 수 없습니다.");
				return result;
			}

			int updated = guestOrderMapper.updateOrderStatus(orderId, "CANCEL_REQUESTED");
			result.put("result", updated > 0 ? "success" : "fail");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	public HashMap<String, Object> returnGuestOrder(String orderId, String token) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			if (!validateToken(token, orderId)) {
				result.put("result", "fail");
				result.put("message", "유효하지 않은 접근입니다.");
				return result;
			}

			GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);

			if (order == null) {
				result.put("result", "fail");
				result.put("message", "주문 정보를 찾을 수 없습니다.");
				return result;
			}

			if (!"DONE".equals(order.getOrderStatus())) {
			    result.put("result", "fail");
			    result.put("message", "배송 완료된 주문만 반품/환불 신청할 수 있습니다.");
			    return result;
			}

			int updated = guestOrderMapper.updateOrderStatus(orderId, "REFUND_REQUESTED");
			result.put("result", updated > 0 ? "success" : "fail");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	@Transactional
	public HashMap<String, Object> exchangeGuestOrder(String orderId, String token, HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);

			if (order == null) {
				result.put("result", "fail");
				result.put("message", "주문 정보를 찾을 수 없습니다.");
				return result;
			}

			if (!"DONE".equals(order.getOrderStatus())) {
				result.put("result", "fail");
				result.put("message", "배송 완료된 주문만 교환 신청할 수 있습니다.");
				return result;
			}

			map.put("orderId", orderId);

			guestOrderMapper.insertGuestExchange(map);
			guestOrderMapper.updateOrderStatusToExchange(orderId);

			result.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	private boolean validateToken(String token, String orderId) {
		if (token == null || orderId == null)
			return false;

		TokenEntry entry = TOKEN_STORE.get(token);

		if (entry == null)
			return false;
		if (!entry.orderId.trim().equals(orderId.trim()))
			return false;

		if (System.currentTimeMillis() - entry.createdAt > TOKEN_TTL_MS) {
			TOKEN_STORE.remove(token);
			return false;
		}

		return true;
	}

	private void purgeExpiredTokens() {
		long now = System.currentTimeMillis();
		TOKEN_STORE.entrySet().removeIf(e -> now - e.getValue().createdAt > TOKEN_TTL_MS);
	}

	private static class TokenEntry {
		final String orderId;
		final long createdAt;

		TokenEntry(String orderId, long createdAt) {
			this.orderId = orderId;
			this.createdAt = createdAt;
		}
	}
	
	public HashMap<String, Object> getGuestExchangeInfo(String orderId, String token) {
	    HashMap<String, Object> result = new HashMap<>();

	    try {
	        orderId = orderId.trim();
	        token = token.trim();

	        if (!validateToken(token, orderId)) {
	            result.put("result", "fail");
	            result.put("message", "유효하지 않은 접근입니다. 다시 조회해주세요.");
	            return result;
	        }

	        GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);

	        if (order == null) {
	            result.put("result", "fail");
	            result.put("message", "주문 정보를 찾을 수 없습니다.");
	            return result;
	        }

	        List<GuestOrderItem> items = guestOrderMapper.selectGuestOrderItems(orderId);

	        HashMap<String, Object> orderInfo = new HashMap<>();

	        if (items != null && !items.isEmpty()) {
	            GuestOrderItem item = items.get(0);

	            orderInfo.put("productName", item.getProductName());
	            orderInfo.put("count", item.getQuantity());       // ✔ 수량
	            orderInfo.put("price", item.getUnitPrice());      // ✔ 가격
	            orderInfo.put("optionName", item.getOptionName()); 
	            orderInfo.put("imgUrl", item.getImgUrl());
	        }

	        result.put("result", "success");
	        result.put("orderInfo", orderInfo);

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", "서버 오류가 발생했습니다.");
	    }

	    return result;
	}
}