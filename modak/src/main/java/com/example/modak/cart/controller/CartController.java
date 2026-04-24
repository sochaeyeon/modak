package com.example.modak.cart.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.cart.dao.CartService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class CartController {
	
	@Autowired
	CartService cartService;
	@Autowired
	HttpSession session;

	@RequestMapping("/cart/list.do") 
	   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
	      return "/cart/cart-list";
	   }
	
	// 장바구니 담기
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(@RequestParam HashMap<String, Object> map) throws Exception {
	    String userId = (String) session.getAttribute("userId");

	    if (userId != null) {
	        map.put("userId", userId);
	    } else {
	        map.put("userId", "user01");
	    }

	    HashMap<String, Object> resultMap = cartService.addCart(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 장바구니 목록 조회
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		// 1. 세션에서 로그인한 사용자의 아이디를 꺼냅니다.
		// (로그인 시 세션에 저장한 이름이 "userId" 또는 "sessionId"인지 확인 필요!)
		String userId = (String) session.getAttribute("userId"); 
				
		// 2. 세션에 아이디가 있다면 맵에 담아줍니다.
		if(userId != null) {
			map.put("userId", userId);
		} else {
			// 로그인이 안 된 경우 테스트를 위해 임시 아이디를 넣거나 에러 처리를 합니다.
			map.put("userId", "user01"); 
		}
		
		// 3. 이제 userId와 cartType이 모두 담긴 map이 서비스로 넘어갑니다.
		resultMap = cartService.getCartList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 장바구니 단일 삭제
	@RequestMapping(value = "/cart/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteCart(@RequestParam HashMap<String, Object> map) throws Exception {
	    String userId = (String) session.getAttribute("userId");

	    if (userId != null) {
	        map.put("userId", userId);
	    } else {
	        map.put("userId", "user01");
	    }

	    HashMap<String, Object> resultMap = cartService.deleteCart(map);
	    return new Gson().toJson(resultMap);
	}

	// 장바구니 선택 삭제
	@RequestMapping(value = "/cart/deleteSelected.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteSelectedCart(@RequestParam HashMap<String, Object> map) throws Exception {
	    String userId = (String) session.getAttribute("userId");

	    if (userId != null) {
	        map.put("userId", userId);
	    } else {
	        map.put("userId", "user01");
	    }

	    String cartIds = (String) map.get("cartIds");
	    String[] cartIdList = cartIds.split(",");
	    map.put("cartIdList", cartIdList);

	    HashMap<String, Object> resultMap = cartService.deleteSelectedCart(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 옵션 변경
	@RequestMapping(value = "/cart/updateOption.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateCartOption(@RequestParam HashMap<String, Object> map) throws Exception {
	    String userId = (String) session.getAttribute("userId");

	    if (userId != null) {
	        map.put("userId", userId);
	    } else {
	        map.put("userId", "user01");
	    }

	    HashMap<String, Object> resultMap = cartService.updateCartOption(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 장바구니 수량 조회
	@PostMapping(value = "/cart/count.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCartCount(HttpSession session) {
	    HashMap<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    if (userId == null) {
	        result.put("count", 0);
	        return new Gson().toJson(result);
	    }
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    return new Gson().toJson(cartService.getCartCount(map));
	}
	   
}
