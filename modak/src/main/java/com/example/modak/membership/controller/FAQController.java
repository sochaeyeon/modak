package com.example.modak.membership.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.membership.dao.FAQService;
import com.google.gson.Gson;

@Controller
public class FAQController {

	@Autowired
	FAQService faqService;
	
	// FAQ 리스트 가져오기
	@RequestMapping(value = "/FAQ/list/5.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String FAQList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = faqService.getFAQList(map);
		return new Gson().toJson(resultMap);
	}
}
