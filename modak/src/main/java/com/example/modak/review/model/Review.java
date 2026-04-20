package com.example.modak.review.model;

import java.util.List;

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
    private String imageUrl; // 기존 대표 이미지 유지
    private List<ReviewImage> imageList; // 추가
    private int imageCount;              // 추가
}