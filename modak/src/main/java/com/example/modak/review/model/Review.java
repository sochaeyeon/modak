package com.example.modak.review.model;

import lombok.Data;

@Data
public class Review {


    private String reviewId;
    private String rating;
    private String content;
    private String reviewStatus;
    private String createdAt;
    private String updatedAt;
    private String userId;
    private String productId;
    private String itemId;

    private String productName;
    private String imageUrl; // 대표 이미지
}