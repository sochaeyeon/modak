package com.example.modak.review.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.review.dao.GeminiReviewService;
import com.example.modak.review.model.ReviewSummaryRequest;
import com.example.modak.review.model.ReviewSummaryResponse;

@RestController
@RequestMapping("/api/review")
public class ReviewAiController {

    @Autowired
    private GeminiReviewService geminiReviewService;

    @PostMapping("/summary")
    public ReviewSummaryResponse summary(@RequestBody ReviewSummaryRequest request) {
        String summary = geminiReviewService.getOrCreateSummary(request.getProductId());
        return new ReviewSummaryResponse(summary);
    }
}