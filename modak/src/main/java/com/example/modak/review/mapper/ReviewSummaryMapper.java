package com.example.modak.review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.review.model.ReviewStat;
import com.example.modak.review.model.ReviewSummary;

@Mapper
public interface ReviewSummaryMapper {

    ReviewSummary selectReviewSummary(int productId);

    ReviewStat selectReviewStat(int productId);

    List<String> selectReviewContents(int productId);

    int insertReviewSummary(ReviewSummary summary);

    int updateReviewSummary(ReviewSummary summary);
}