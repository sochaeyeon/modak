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
	
}
