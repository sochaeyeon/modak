package com.example.modak.cart.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.cart.mapper.CartMapper;
import com.example.modak.cart.model.Cart;
import com.example.modak.common.Message;

@Service
public class CartService {

	@Autowired 
	CartMapper cartMapper;
	
	// 카트목록
//	public HashMap<String, Object> getCartList(HashMap<String, Object> map){
//	      HashMap<String, Object> resultMap = new HashMap<String, Object>();
//	      try {
//	    	  List<Cart> list = cartMapper.selectCartList(map);
//	    	  resultMap.put("list", list);
//	    	  resultMap.put("result", "success");
//	    	  resultMap.put("message", Message.SUCCESS_SELECT);  
//	      } catch (Exception e) {
//	         System.out.println(e.getMessage());
//	         resultMap.put("result", "fail");
//	         resultMap.put("message", Message.FAIL_SELECT); 
//	      }
//	      return resultMap;
//	   }
//	// 담기
//    public HashMap<String, Object> insertCart(HashMap<String, Object> map) {
//        HashMap<String, Object> result = new HashMap<>();
//        try {
//            cartMapper.insertCart(map);
//            result.put("result", "success");
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("result", "fail");
//        }
//        return result;
//    }
//
//    // 수량/옵션 수정
//    public HashMap<String, Object> updateCart(HashMap<String, Object> map) {
//        HashMap<String, Object> result = new HashMap<>();
//        try {
//            cartMapper.updateCart(map);
//            result.put("result", "success");
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("result", "fail");
//        }
//        return result;
//    }
//
//    // 날짜 수정
//    public HashMap<String, Object> updateCartDate(HashMap<String, Object> map) {
//        HashMap<String, Object> result = new HashMap<>();
//        try {
//            cartMapper.updateCartDate(map);
//            result.put("result", "success");
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("result", "fail");
//        }
//        return result;
//    }
//
//    // 단건 삭제
//    public HashMap<String, Object> deleteCart(HashMap<String, Object> map) {
//        HashMap<String, Object> result = new HashMap<>();
//        try {
//            cartMapper.deleteCart(map);
//            result.put("result", "success");
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("result", "fail");
//        }
//        return result;
//    }
//
//    // 선택 삭제
//    public HashMap<String, Object> deleteCartList(HashMap<String, Object> map) {
//        HashMap<String, Object> result = new HashMap<>();
//        try {
//            // "1,2,3" → List<Integer> 변환
//            String ids = (String) map.get("cartIds");
//            List<Integer> idList = Arrays.stream(ids.split(","))
//                .map(String::trim)
//                .map(Integer::parseInt)
//                .collect(Collectors.toList());
//            map.put("cartIdList", idList);
//            cartMapper.deleteCartList(map);
//            result.put("result", "success");
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("result", "fail");
//        }
//        return result;
//    }
}
