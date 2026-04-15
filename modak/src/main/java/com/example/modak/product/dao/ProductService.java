package com.example.modak.product.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.product.mapper.ProductMapper;
import com.example.modak.product.model.Product;

@Service
public class ProductService {

	@Autowired 
	ProductMapper productMapper;
	// 제품 리스트 불러오기 product list
	public HashMap<String, Object> getProductList(HashMap<String, Object> map){
	      HashMap<String, Object> resultMap = new HashMap<String, Object>();
	      try {
	    	  List<Product> list = productMapper.selectProductList(map);
	    	  resultMap.put("list", list);
	    	  resultMap.put("result", "success");
	    	  resultMap.put("message", Message.SUCCESS_SELECT);  
	      } catch (Exception e) {
	         System.out.println(e.getMessage());
	         resultMap.put("result", "fail");
	         resultMap.put("message", Message.FAIL_SELECT); 
	      }
	      return resultMap;
	   }
	
}