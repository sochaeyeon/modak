package com.example.modak.cart.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.cart.mapper.CartMapper;
import com.example.modak.cart.model.Cart;
import com.example.modak.common.Message;

@Service
public class CartService {

	@Autowired
	CartMapper cartMapper;

	// 장바구니 담기
	public HashMap<String, Object> addCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			// 1. optionValueIds로 실제 OPTION_ITEM_ID 찾기
			String optionValueIds = String.valueOf(map.get("optionValueIds"));

			if (optionValueIds != null && !"".equals(optionValueIds) && !"null".equals(optionValueIds)) {

				String[] arr = optionValueIds.split(",");
				java.util.List<Integer> optionValueIdList = new java.util.ArrayList<>();

				for (String id : arr) {
					if (id != null && !"".equals(id.trim())) {
						optionValueIdList.add(Integer.parseInt(id.trim()));
					}
				}

				map.put("optionValueIdList", optionValueIdList);
				map.put("optionCount", optionValueIdList.size());

				Integer optionItemId = cartMapper.selectOptionItemIdByValues(map);

				if (optionItemId == null) {
					resultMap.put("result", "fail");
					resultMap.put("message", "선택한 옵션 조합을 찾을 수 없습니다.");
					return resultMap;
				}

				map.put("optionItemId", optionItemId);
			} else {
				map.put("optionItemId", null);
			}

			// 2. optionItemId까지 들어간 상태에서 중복 조회
			Cart cart = cartMapper.selectCartOne(map);

			if (cart != null) {
				map.put("cartId", cart.getCartId());
				cartMapper.updateCartQty(map);

				resultMap.put("result", "duplicate");
				resultMap.put("message", "이미 같은 조건의 상품이 있습니다.");
			} else {
				cartMapper.insertCart(map);

				resultMap.put("result", "success");
				resultMap.put("message", "장바구니에 담았습니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}

		return resultMap;
	}

	// 카트목록
	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cart> list = cartMapper.selectCartList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.FAIL_SELECT);
		}
		return resultMap;
	}

	// 장바구니 단일 삭제
	public HashMap<String, Object> deleteCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			cartMapper.deleteCart(map);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_DELETE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.FAIL_DELETE);
		}

		return resultMap;
	}

	// 장바구니 선택 삭제
	public HashMap<String, Object> deleteSelectedCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			cartMapper.deleteSelectedCart(map);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_DELETE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.FAIL_DELETE);
		}

		return resultMap;
	}

	// 장바구니 옵션변경 업데이트
	public HashMap<String, Object> updateCartOption(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        // 1. 기존 장바구니 정보 먼저 조회
	        Cart target = cartMapper.selectCartById(map);

	        if (target == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "장바구니 상품을 찾을 수 없습니다.");
	            return resultMap;
	        }

	        map.put("productId", target.getProductId());
	        map.put("cartType", target.getCartType());

	        // 2. optionValueIds로 OPTION_ITEM_ID 찾기
	        String optionValueIds = String.valueOf(map.get("optionValueIds"));

	        if (optionValueIds != null
	                && !"".equals(optionValueIds)
	                && !"null".equals(optionValueIds)) {

	            String[] arr = optionValueIds.split(",");
	            java.util.List<Integer> optionValueIdList = new java.util.ArrayList<>();

	            for (String id : arr) {
	                if (id != null && !"".equals(id.trim())) {
	                    optionValueIdList.add(Integer.parseInt(id.trim()));
	                }
	            }

	            map.put("optionValueIdList", optionValueIdList);
	            map.put("optionCount", optionValueIdList.size());

	            Integer optionItemId = cartMapper.selectOptionItemIdByValues(map);

	            if (optionItemId == null) {
	                resultMap.put("result", "fail");
	                resultMap.put("message", "선택한 옵션 조합을 찾을 수 없습니다.");
	                return resultMap;
	            }

	            map.put("optionItemId", optionItemId);
	        }

	        // 3. 같은 상품 + 같은 옵션 + 같은 날짜가 이미 있는지 확인
	        Cart sameCart = cartMapper.selectSameCartForUpdate(map);

	        if (sameCart != null && sameCart.getCartId() != target.getCartId()) {
	            map.put("targetCartId", sameCart.getCartId());
	            map.put("addQuantity", map.get("quantity"));

	            cartMapper.mergeCartQty(map);
	            cartMapper.deleteCart(map);

	            resultMap.put("merged", "Y");
	        } else {
	            cartMapper.updateCartOption(map);
	            resultMap.put("merged", "N");
	        }

	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }

	    return resultMap;
	}

	// 헤더 장바구니 개수 아이콘
	public HashMap<String, Object> getCartCount(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int count = cartMapper.selectCartCount(map);
			result.put("count", count);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("count", 0);
			result.put("result", "fail");
		}
		return result;
	}
}
