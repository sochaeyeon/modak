package com.example.modak.review.model;

import lombok.Data;

@Data
public class ReviewHelpful {

    private Long helpfulId;
    private Long reviewId;
    private String userId;

}