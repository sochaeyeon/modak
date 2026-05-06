package com.example.modak.wishlist.model;

import lombok.Data;

@Data
public class Wishlist {

    // WISHLIST 테이블
    private int wishId;
    private String createdAt;
    private String userId;
    private int productId;

    // PRODUCT 조인
    private String productName;
    private int price;

    // PRODUCT_IMG 조인
    private String imgUrl;
    
    // PRODUCT_CATEGORY 조인
    private String categoryName;
    
    // 브랜드 .............
    private String brandName;
    
    private Double avgRating;
    private Integer reviewCount;
}