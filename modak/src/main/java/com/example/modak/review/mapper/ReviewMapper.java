package com.example.modak.review.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.review.model.Review;
import com.example.modak.review.model.ReviewHelpful;
import com.example.modak.review.model.ReviewImage;

@Mapper
public interface ReviewMapper {

	// 리뷰 등록
	int insertReview(HashMap<String, Object> map);

	// 리뷰 이미지 등록
	int insertReviewImage(HashMap<String, Object> map);

	// 내 리뷰 목록 조회
	List<Review> selectReviewList(HashMap<String, Object> map);

	// 내 리뷰 총 개수
	int selectReviewCount(HashMap<String, Object> map);

	// 리뷰 상세 조회
	Review selectReviewInfo(HashMap<String, Object> map);

	// 리뷰 수정
	int updateReview(HashMap<String, Object> map);

	// 리뷰 삭제 (soft delete)
	int updateReviewStatusDeleted(HashMap<String, Object> map);

	// 기존 리뷰 이미지 삭제
	int deleteReviewImages(HashMap<String, Object> map);
	
	List<ReviewImage> selectReviewImageList(HashMap<String, Object> map);
	
	// 상품 상세 리뷰 목록!!
	List<Review> selectProductReviewList(HashMap<String, Object> map);
	
	 // 리뷰 작성 대상 주문 정보 조회
    HashMap<String, Object> selectReviewWriteInfo(HashMap<String, Object> map);
    int deleteReviewImagesNotIn(HashMap<String, Object> map);

    // 이미 작성한 리뷰 여부 확인
    int selectReviewExists(HashMap<String, Object> map);
    
    HashMap<String, Object> selectReviewOrderInfo(HashMap<String, Object> map);
    List<HashMap<String, Object>> selectReviewOrderItemList(HashMap<String, Object> map);
    int updateUserPoint(HashMap<String, Object> map);
    


    int existsHelpful(ReviewHelpful helpful);

    int insertHelpful(ReviewHelpful helpful);

    int deleteHelpful(ReviewHelpful helpful);

    int increaseHelpfulCount(Long reviewId);

    int decreaseHelpfulCount(Long reviewId);
    
    int existsReport(HashMap<String, Object> map);

    int insertReport(HashMap<String, Object> map);
}