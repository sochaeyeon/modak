package com.example.modak.order.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.example.modak.order.dao.OrderExchangeService;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/order/exchange")
public class OrderExchangeController {

	@Autowired
	private OrderExchangeService service;

	/* 교환 신청 페이지 이동 */
	@GetMapping("/request.do")
	public String exchangePage() {
		return "order/order-exchange";
	}

	/* 주문 정보 + 기본 배송지 조회 */
	@PostMapping(value = "/info.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getExchangeInfo(@RequestParam HashMap<String, Object> map, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (userId == null)
			return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
		map.put("userId", userId);
		return new Gson().toJson(service.getExchangeInfo(map));
	}

	/* 교환 신청 */
	@PostMapping(value = "/apply.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String applyExchange(@RequestParam HashMap<String, Object> map, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (userId == null)
			return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
		map.put("userId", userId);
		return new Gson().toJson(service.applyExchange(map));
	}

}
