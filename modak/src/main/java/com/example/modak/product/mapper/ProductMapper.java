package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.def.model.Default;
import com.example.modak.product.model.Product;

@Mapper
public interface ProductMapper {
	// 제품 리스트 product list
	public List<Product> selectProductList(HashMap<String, Object> map);
	// 상품 상세 조회 product detail
	public Product selectProduct(HashMap<String, Object> map);

}