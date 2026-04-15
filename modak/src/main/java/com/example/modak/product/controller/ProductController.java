package com.example.modak.product.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.product.dao.ProductService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired 
	ProductService productService;
	
	// product-list 제품리스트
	   @RequestMapping("/product/list.do") 
	   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
	      return "/product/product-list";
	   } 
	   @RequestMapping(value = "/product/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = productService.getProductList(map);
			
			return new Gson().toJson(resultMap); 
		}
	
}
