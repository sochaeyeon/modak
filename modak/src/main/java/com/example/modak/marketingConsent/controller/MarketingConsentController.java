package com.example.modak.marketingConsent.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MarketingConsentController {

	// 파라미터 없을 때
	@RequestMapping("/marketingConsent.do")
	public String marketingConsent(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		return "/policy/marketing-consent";
	}

	// Ajax 호출 주소
	@RequestMapping(value = "/marketingConsent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String marketingConsent(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		return new Gson().toJson(resultMap); 
	}

}
