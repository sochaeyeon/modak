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

	private String getCartUserId() {
		String loginUserId = (String) session.getAttribute("sessionId");

		if (loginUserId != null && !"".equals(loginUserId)) {
			return loginUserId;
		}

		String guestCartId = (String) session.getAttribute("guestCartId");

		if (guestCartId == null || "".equals(guestCartId)) {
			guestCartId = "GUEST_" + session.getId().substring(0, 12);
			session.setAttribute("guestCartId", guestCartId);
		}

		return guestCartId;
	}

	@RequestMapping("/cart/list.do")
	public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		return "/cart/cart-list";
	}

	// 장바구니 담기
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(@RequestParam HashMap<String, Object> map) throws Exception {
		String cartUserId = getCartUserId();

		map.put("userId", cartUserId);

		HashMap<String, Object> resultMap = cartService.addCart(map);
		return new Gson().toJson(resultMap);
	}

	// 장바구니 목록 조회
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		String cartUserId = getCartUserId();

		map.put("userId", cartUserId);

		HashMap<String, Object> resultMap = cartService.getCartList(map);
		return new Gson().toJson(resultMap);
	}

	// 장바구니 단일 삭제
	@RequestMapping(value = "/cart/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteCart(@RequestParam HashMap<String, Object> map) throws Exception {
		String cartUserId = getCartUserId();

		map.put("userId", cartUserId);

		HashMap<String, Object> resultMap = cartService.deleteCart(map);
		return new Gson().toJson(resultMap);
	}

	// 장바구니 선택 삭제
	@RequestMapping(value = "/cart/deleteSelected.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteSelectedCart(@RequestParam HashMap<String, Object> map) throws Exception {
		String cartUserId = getCartUserId();

		map.put("userId", cartUserId);

		String cartIds = (String) map.get("cartIds");

		if (cartIds != null && !"".equals(cartIds)) {
			String[] cartIdList = cartIds.split(",");
			map.put("cartIdList", cartIdList);
		}

		HashMap<String, Object> resultMap = cartService.deleteSelectedCart(map);
		return new Gson().toJson(resultMap);
	}

	// 옵션 변경
	@RequestMapping(value = "/cart/updateOption.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateCartOption(@RequestParam HashMap<String, Object> map) throws Exception {
		String cartUserId = getCartUserId();

		map.put("userId", cartUserId);

		HashMap<String, Object> resultMap = cartService.updateCartOption(map);
		return new Gson().toJson(resultMap);
	}

	// 헤더 장바구니 수량 조회
	@PostMapping(value = "/cart/count.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCartCount() {
		String cartUserId = getCartUserId();

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", cartUserId);

		HashMap<String, Object> result = cartService.getCartCount(map);
		return new Gson().toJson(result);
	}
}