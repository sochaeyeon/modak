package com.example.modak.common.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ErrorController {

	// 파라미터 없을 때
	@RequestMapping("/error.do")
	public String error(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		return "/error/error";
	}

	// Ajax 호출 주소
	@RequestMapping(value = "/error.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String error(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		// resultMap = defaultService.getDefaultList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 글로벌 에러 핸들러 테스트용 임시 주소
	// http://localhost:8080/test-error.do 접속시 모닥에러화면이 떠야함
//    @GetMapping("/test-error.do")
//    public String testError() {
//        // 런타임 에러
//        throw new RuntimeException("글로벌 에러 핸들러가 잘 잡는지 테스트하는 중입니다!");
//    }

}
