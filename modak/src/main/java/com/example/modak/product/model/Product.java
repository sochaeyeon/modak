package com.example.modak.product.model;

import lombok.Data;

@Data
public class Product {
	
	int productId; // 상품id
	String productName; // 상품명
	String productType; // 상품타입
	int price; // 가격
	int deposit; // 보증금
	String description; // 상품설명
	String isAvailable; // 판매가능여부
	String createdAt; // 등록일
	
	int categoryId; // 카테고리id
	
	String imgUrl; // ⭐ 대표 이미지 추가
	
	int brandId; // 브랜드 아이디 1,2,3
	String brandName; // 브랜드명 - 브랜드없으면 1번 자체제작
}