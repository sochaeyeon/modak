package com.example.modak.review.model;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ReviewSummary {

    private int summaryId;
    private int productId;
    private String summaryText;
    private int reviewCount;
    private LocalDateTime lastReviewUpdatedAt;
}