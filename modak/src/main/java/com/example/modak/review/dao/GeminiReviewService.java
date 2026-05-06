package com.example.modak.review.dao;

import java.util.List;

public interface GeminiReviewService {

    String summarizeReviews(List<String> reviews);

    String getOrCreateSummary(int productId);
}