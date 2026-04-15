package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.UserService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UserController {

   @Autowired
   UserService userService;

   // 파라미터 전달할 때
   @RequestMapping("/user/login.do") 
   public String login(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
      request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
      return "user/login";
   } 
   
   @RequestMapping("/user/sign-up.do") 
   public String signUp(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
      request.setAttribute("map", map); // jsp에서 꺼낼 때 "${map.~}" 으로 꺼내기
      return "user/sign-up";
   } 
   
   // 회원가입
   @RequestMapping(value = "/user/sign-up.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String signUp(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      resultMap = userService.addUser(map);
      return new Gson().toJson(resultMap); 
   }
   
   // 아이디 중복체크
   @RequestMapping(value = "/user/check-user-id.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String checkUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      resultMap = userService.getUserCheck(map);
      return new Gson().toJson(resultMap); 
   }
   
   // 로그인
   @RequestMapping(value = "/user/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      resultMap = userService.getUser(map);
      return new Gson().toJson(resultMap); 
   }
   
}
