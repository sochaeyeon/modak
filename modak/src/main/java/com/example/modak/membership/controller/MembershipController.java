package com.example.modak.membership.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.membership.dao.MembershipService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class MembershipController {
	
	@Autowired
	MembershipService membershipService;
	
	// 멤버십 디테일
	@RequestMapping("user/membership/info.do")
	public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
		return "membership/membership-info";
	}

	// 멤버십 데이터 조회
	@RequestMapping("/membership/info.dox")
	@ResponseBody
	public String getMembershipInfo(HttpSession session) {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    String userId = (String) session.getAttribute("sessionId");

	    if (userId == null) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "로그인이 필요합니다.");
	        return new Gson().toJson(resultMap);
	    }

	    HashMap<String, Object> param = new HashMap<>();
	    param.put("userId", userId);

	    resultMap = membershipService.getMembershipInfo(param);

	    return new Gson().toJson(resultMap);
	}
}
