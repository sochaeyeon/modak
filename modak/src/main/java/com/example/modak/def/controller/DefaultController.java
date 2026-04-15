package com.example.modak.def.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.def.dao.DefaultService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class DefaultController {

   @Autowired
   DefaultService defaultService;

   // 파라미터 없을 때
   @RequestMapping("/default1.do") 
   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
      return "/default1";
   } 
   
   // 파라미터 전달할 때
   @RequestMapping("/default2.do") 
   public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
      request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
      return "/default2";
   } 
   
   // Ajax 호출 주소
   @RequestMapping(value = "/default.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      // resultMap = defaultService.getDefaultList(map);
      return new Gson().toJson(resultMap); 
   }
   
}
