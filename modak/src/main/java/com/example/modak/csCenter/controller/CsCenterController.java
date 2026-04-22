package com.example.modak.csCenter.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

@Controller
public class CsCenterController {

	@RequestMapping("/cs/center.do")
	public String test(Model model) throws Exception {
		return "/cs/cs-center";
	}
	
	
	@RequestMapping(value = "/cs/center.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String csCenter(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		return new Gson().toJson(resultMap);
	}

}
