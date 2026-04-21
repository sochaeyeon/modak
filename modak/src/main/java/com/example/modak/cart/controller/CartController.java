package com.example.modak.cart.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.cart.dao.CartService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CartController {
	
	@Autowired
	CartService cartService;
	
	@RequestMapping("/cart/list.do") 
	   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
	      return "/cart/cart-list";
	   }
	
	// 장바구니 목록 조회
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = cartService.getCartList(map);
		return new Gson().toJson(resultMap);
	}
	   
}
