package com.example.modak.csCenter.controller;

import java.util.Arrays;
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
	public String faq(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "/cs/faq";
	}

	// Ajax 호출 주소
	@RequestMapping(value = "/faq.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String faqList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		// category 처리
		String category = (String) map.get("category");
		if (category != null && category.contains(",")) {
			map.put("categoryList", Arrays.asList(category.split(",")));
			map.put("category", "");
		} else if (category != null && !category.isEmpty()) {
			map.put("categoryList", Arrays.asList(category));
		}

		// excludeCategory 처리 (기타용)
		String excludeCategory = (String) map.get("excludeCategory");
		if (excludeCategory != null && !excludeCategory.isEmpty()) {
			map.put("excludeList", Arrays.asList(excludeCategory.split(",")));
		}

		HashMap<String, Object> resultMap = faqService.getFaqList(map);
		return new Gson().toJson(resultMap);
	}
}
