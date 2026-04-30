package com.example.modak.review.model;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ReviewStat {

    private int reviewCount;
    private LocalDateTime lastReviewUpdatedAt;
}