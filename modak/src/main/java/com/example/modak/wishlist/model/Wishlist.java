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
}