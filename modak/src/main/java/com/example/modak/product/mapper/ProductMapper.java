package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.product.model.Brand;
import com.example.modak.product.model.Product;

@Mapper
public interface ProductMapper {
	// 제품 리스트 product list
	public List<Product> selectProductList(HashMap<String, Object> map);
	// 상품 상세 조회 product detail
	public Product selectProduct(HashMap<String, Object> map);	
	// 상품 상세 이미지들 조회 (상세 페이지 갤러리용)
	public List<Product> selectProductImages(HashMap<String, Object> map);
	// 브랜드 리스트 만들기용
	public List<Brand> selectBrandList(Map<String, Object> map);
	// product detail -> 오더 카운트
	int selectOrderCount(HashMap<String, Object> map);
}