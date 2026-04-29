package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Faq;
import com.example.modak.product.model.Brand;
import com.example.modak.product.model.Product;
import com.example.modak.product.model.ProductFeature;
import com.example.modak.product.model.ProductOption;
import com.example.modak.product.model.ProductSpec;

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
  
	/** 메인페이지 카테고리 목록 (PARENT_CATEGORY = 1, 상위 7개) */
	public List<HashMap<String, Object>> selectMainCategoryList();
  
	
	/** 조회수 상위 4개 인기 상품 */
	public List<Product> selectPopularProducts();
	 
	/** 상품 조회수 +1 */
	void increaseViewCount(HashMap<String, Object> map);
  
	// product detail -> 오더 카운트
	int selectOrderCount(HashMap<String, Object> map);
	
	/** product detail 같은 카테고리 상품 (현재 상품 제외, 최대 4개) */
	public List<Product> selectRelatedProducts(HashMap<String, Object> map);
	
	/** 상품 스펙 단건 조회 */
	public ProductSpec selectProductSpec(HashMap<String, Object> map);

	/** 상품 특징 목록 조회 */
	public List<ProductFeature> selectProductFeatures(HashMap<String, Object> map);
	
	// faq 
	public List<Faq> selectFaqList(HashMap<String, Object> map);
	
	// 상품옵션
	public List<ProductOption> selectProductOptions(HashMap<String, Object> map);
	
	public List<HashMap<String, Object>> selectAllCategoryList();
	
	public Integer selectOptionItemId(HashMap<String, Object> map);
	
}