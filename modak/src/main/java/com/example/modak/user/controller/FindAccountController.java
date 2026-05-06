package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.FindAccountService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class FindAccountController {

	@Autowired
	FindAccountService findAccountService;

	@RequestMapping("/user/find-account.do")
	public String findAccount(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
		return "user/find-account";
	}

	// 아이디 찾기
	@RequestMapping(value = "/user/find-id.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = findAccountService.getUserId(map);
		return new Gson().toJson(resultMap);
	}

	// 이름 + 전화번호로 아이디 찾기
	@PostMapping(value = "/find-id-by-phone.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findIdByPhone(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = findAccountService.findIdByPhone(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 찾기 - 이메일 인증번호 발송
	@PostMapping(value = "/user/send-pw-auth-email.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendPwAuthEmail(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = findAccountService.sendPwAuthEmail(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 찾기 - 이메일 인증번호 확인
	@PostMapping(value = "/user/verify-pw-auth-email.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifyPwAuthEmail(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = findAccountService.verifyPwAuthEmail(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 재설정
	@PostMapping(value = "/user/reset-password.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String resetPassword(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = findAccountService.resetPassword(map);
		return new Gson().toJson(resultMap);
	}
}
