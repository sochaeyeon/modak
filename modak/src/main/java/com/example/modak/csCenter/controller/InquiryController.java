package com.example.modak.csCenter.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.modak.csCenter.dao.InquiryService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class InquiryController {

	@Autowired
	InquiryService inquiryService;

	// 파라미터 없을 때
	@RequestMapping("/inquiry.do")
	public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		return "/cs/inquiry-form";
	}

}
