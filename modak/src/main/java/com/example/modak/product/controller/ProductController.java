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
import com.example.modak.user.dao.ViewService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;
//	ViewService viewService;

	// product-list 제품리스트
	@RequestMapping("/product/list.do")
	public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		return "/product/product-list";
	}

	@RequestMapping(value = "/product/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(Model model, @RequestParam HashMap<String, Object> map,
			@RequestParam(value = "brandId", required = false) java.util.List<Integer> brandId,
			@RequestParam(value = "priceMax", required = false) Integer priceMax) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		boolean rentable = Boolean.parseBoolean(String.valueOf(map.get("rentable")));
		boolean buyable = Boolean.parseBoolean(String.valueOf(map.get("buyable")));

		map.put("rentable", rentable);
		map.put("buyable", buyable);

		map.put("brandId", brandId);
		map.put("priceMax", priceMax);

		resultMap = productService.getProductList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/product/brandList.dox")
	@ResponseBody
	public HashMap<String, Object> getBrandList(@RequestParam HashMap<String, Object> map) {
	    // 서비스의 getBrandList를 호출하여 그대로 리턴
	    return productService.getBrandList(map);
	}

	@RequestMapping("/product/detail.do")
	public String view(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		// System.out.println(map);
		// jsp에서 "${map.productId}"로 꺼내 쓸 수 있도록 전달
		request.setAttribute("productId", map.get("productId"));
		return "/product/product-detail";
	}

	// 2. 상품 상세 데이터 호출 (.dox)
	// Vue의 ajax에서 호출하여 실제 DB 데이터를 JSON으로 반환
	@RequestMapping(value = "/product/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		// 서비스에서 상세 정보를 가져와서 resultMap에 담음
		resultMap = productService.getProduct(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/mainCategoryList.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String mainCategoryList() throws Exception {
	    HashMap<String, Object> resultMap = productService.getMainCategoryList();
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/popularList.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String popularList() throws Exception {
	    HashMap<String, Object> resultMap = productService.getPopularProducts();
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/related.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRelated(@RequestParam HashMap<String, Object> map) throws Exception {
	return new Gson().toJson(productService.getRelatedProducts(map));
	}
	

}