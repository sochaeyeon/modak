package com.example.modak.address.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.address.dao.AddressService;
import com.google.gson.Gson;

@Controller
public class AddressController {

	@Autowired
	AddressService addressService;

   // 배송지 추가
   @RequestMapping(value = "/user/address/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String addAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
       resultMap = addressService.addAddress(map);
      return new Gson().toJson(resultMap); 
   }
   
   // 배송지 목록 조회
   @RequestMapping(value = "/user/address/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String getAddressList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      resultMap = addressService.getAddressList(map);
      return new Gson().toJson(resultMap); 
   }
   
}
