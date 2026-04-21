package com.example.modak.product.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.product.mapper.ProductMapper;
import com.example.modak.product.model.Brand;
import com.example.modak.product.model.Product;

@Service
public class ProductService {

	@Autowired 
	ProductMapper productMapper;
	// 제품 리스트 불러오기 product list
	public HashMap<String, Object> getProductList(HashMap<String, Object> map){
	      HashMap<String, Object> resultMap = new HashMap<String, Object>();
	      try {
	    	  // 검색어 앞뒤 공백 제거
	    	  if (map.get("searchKeyword") != null) {
	              String keyword = String.valueOf(map.get("searchKeyword")).trim();
	              map.put("searchKeyword", keyword);
	          }
	    	  
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
	
	// 브랜드 리스트 불러오기 brand list
	public HashMap<String, Object> getBrandList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        // XML에서 정의한 selectBrandList 호출 (결과는 Brand 모델 리스트)
	        List<Brand> list = productMapper.selectBrandList(map);
	        
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
	
	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        // 단건 조회이므로 Mapper에서 객체 하나(Product)를 가져옵니다.
	        Product info = productMapper.selectProduct(map);
	        List<Product> img = productMapper.selectProductImages(map);
	        
	        resultMap.put("info", info);
	        resultMap.put("img", img);
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