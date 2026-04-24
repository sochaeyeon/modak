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
	        Cart cart = cartMapper.selectCartOne(map);

	        if (cart != null) {
	            // 🔥 중복 존재
	            map.put("cartId", cart.getCartId());
	            cartMapper.updateCartQty(map);

	            resultMap.put("result", "duplicate");
	            resultMap.put("message", "이미 같은 조건의 상품이 있습니다.");
	        } else {
	            // 신규 추가
	            cartMapper.insertCart(map);

	            resultMap.put("result", "success");
	            resultMap.put("message", "장바구니에 담았습니다.");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
	
	// 카트목록
	public HashMap<String, Object> getCartList(HashMap<String, Object> map){
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
	        Cart target = cartMapper.selectCartById(map);

	        map.put("productId", target.getProductId());
	        map.put("cartType", target.getCartType());

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
	    }

	    return resultMap;
	}
}
