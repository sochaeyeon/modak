package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MypageController {

	// 파라미터 전달할 때
	@RequestMapping("/user/mypage.do")
	public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
		return "user/mypage";
	}
}
