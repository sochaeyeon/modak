package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.LoginService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	@Autowired
	HttpSession session;
	
	// 파라미터 전달할 때
	@RequestMapping("/user/login.do")
	public String login(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
		return "user/login";
	}

	// 로그인
	@RequestMapping(value = "/user/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = loginService.getUser(map);
		return new Gson().toJson(resultMap);
	}
	
	// 로그인 세션 체크
	@RequestMapping("/user/session-check.dox")
	@ResponseBody
	public String sessionCheck() {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    if (session.getAttribute("sessionId") != null) {
	        resultMap.put("isLogin", true);
	        resultMap.put("sessionId", session.getAttribute("sessionId"));
	        resultMap.put("sessionName", session.getAttribute("sessionName"));
	    } else {
	        resultMap.put("isLogin", false);
	    }

	    return new Gson().toJson(resultMap);
	}
	
	// 로그아웃 
	@RequestMapping("/user/logout.dox")
	@ResponseBody
	public String logout() {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    session.invalidate();
	    resultMap.put("result", "success");
	    resultMap.put("message", "로그아웃 되었습니다.");
	    return new Gson().toJson(resultMap);
	}
}
