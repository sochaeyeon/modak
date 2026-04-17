package com.example.modak.csCenter.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.csCenter.dao.FaqService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class FaqController {

	@Autowired
	FaqService faqService;

	// 파라미터 전달할 때
	@RequestMapping("/faq.do")
	public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
		return "/cs/faq";
	}

	// Ajax 호출 주소
	@RequestMapping(value = "/faq.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String faq(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		// resultMap = defaultService.getDefaultList(map);
		return new Gson().toJson(resultMap);
	}

}
