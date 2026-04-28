package com.example.modak.user.model;

import lombok.Data;

@Data
public class RecentView {
	
	private String viewId;
    private String productId;     // 상품 ID
    private String productName; // 상품명
    private int price;          // 가격
    private String imgUrl;      // 이미지 (없으면 나중에 추가)
    private String viewDt;      // 조회 시간
    
    private String categoryName;
    private String brandName;
    
    // 별점
    private Double avgRating;
    private Integer reviewCount;
}