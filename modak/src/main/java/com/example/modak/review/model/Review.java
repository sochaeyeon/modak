package com.example.modak.review.model;

import java.util.List;

import lombok.Data;

@Data
public class Review {

    private Long reviewId;
    private Integer rating;
    private String content;
    private String reviewStatus;
    private String createdAt;
    private String updatedAt;
    private String userId;
    private Long productId;
    private Long itemId;
    private String title;

    private String productName;
    private String imageUrl;
    private List<ReviewImage> imageList;
    private int imageCount;
    
    private String nickname;
    private String profileImgUrl;
    private int gradeId;
}