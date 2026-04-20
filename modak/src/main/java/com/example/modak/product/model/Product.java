package com.example.modak.product.model;

import lombok.Data;

@Data
public class Product {
	
	private int productId; // 상품id
	private String productName; // 상품명
	private String productType; // 상품타입
	private int price; // 가격 
	private int deposit; // 보증금
	private String description; // 상품설명
	private String isAvailable; // 판매가능여부
	private String createdAt; // 등록일
	
	private int categoryId; // 카테고리id
	private String categoryName; // 카테고리name
	
	private String imgUrl; // 제품 사진
	private String mainImg; // ⭐ IS_MAIN 값 (Y/N) 을 담을 필드 추가
    private int sortOrder; // ⭐ 순서 값을 담을 필드 추가
    
	private int brandId; // 브랜드 아이디 1,2,3
	private String brandName; // 브랜드명 - 브랜드없으면 1번 자체제작
}