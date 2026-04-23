package com.example.modak.review.model;

import lombok.Data;

@Data
public class ReviewImage {
    private Long imgId;
    private Long reviewId;
    private String imgUrl;
}