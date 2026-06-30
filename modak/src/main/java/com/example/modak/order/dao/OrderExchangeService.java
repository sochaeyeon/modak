package com.example.modak.order.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.modak.order.mapper.OrderExchangeMapper;

@Service
public class OrderExchangeService {

	@Autowired
	private OrderExchangeMapper mapper;

	/* 주문 정보 조회 */
	public HashMap<String, Object> getExchangeInfo(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> info = mapper.selectExchangeOrderInfo(map);
			if (info == null) {
				result.put("result", "fail");
				result.put("message", "주문 정보를 찾을 수 없습니다.");
				return result;
			}

			HashMap<String, Object> orderInfo = new HashMap<>();
			orderInfo.put("productName", info.get("productName"));
			orderInfo.put("count", info.get("count"));
			orderInfo.put("imgUrl", info.get("imgUrl"));
			orderInfo.put("price", info.get("price"));
			orderInfo.put("optionName", info.get("optionName"));
			orderInfo.put("optionItemId", info.get("optionItemId"));
			orderInfo.put("itemId", info.get("itemId"));
			orderInfo.put("productId", info.get("productId")); 

			HashMap<String, Object> addr = new HashMap<>();
			addr.put("zipcode", info.get("zipcode"));
			addr.put("address", info.get("address"));
			addr.put("detailedAddress", info.get("detailedAddress"));

			// ✅ 올바른 메서드명
			List<HashMap<String, Object>> options = mapper.selectOptionListByProduct(map);

			result.put("result", "success");
			result.put("orderInfo", orderInfo);
			result.put("defaultAddress", addr);
			result.put("options", options);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "오류가 발생했습니다.");
		}
		return result;
	}

	/* 교환 신청 */

	@Transactional
	public HashMap<String, Object> applyExchange(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			String oldOptionItemId = (String) map.get("oldOptionItemId");
			String newOptionItemId = (String) map.get("newOptionItemId");

			// ✅ quantity 기본값 1로 보장
			int quantity = 1;
			Object qtyObj = map.get("quantity");
			if (qtyObj != null && !qtyObj.toString().isEmpty()) {
				try {
					quantity = Integer.parseInt(qtyObj.toString());
				} catch (Exception e) {
				}
			}
			map.put("quantity", quantity);

			// 1. 기존 옵션 재고 복구
			if (oldOptionItemId != null && !oldOptionItemId.isEmpty()) {
				mapper.increaseStockForExchange(map);
			}

			// 2. 새 옵션 재고 차감
			if (newOptionItemId != null && !newOptionItemId.isEmpty()) {
				int decreased = mapper.decreaseStockForExchange(map);
				if (decreased == 0) {
					result.put("result", "fail");
					result.put("message", "선택한 옵션의 재고가 부족합니다.");
					return result;
				}
			}

			// 3. 교환 신청 등록
			mapper.insertExchange(map);
			mapper.updateOrderStatusToExchange(map);

			Object idObj = map.get("exchangeId");
			Long exchangeId = idObj != null ? ((Number) idObj).longValue() : null;
			result.put("exchangeId", exchangeId);
			result.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "교환 신청 중 오류가 발생했습니다.");
		}
		return result;
	}
}