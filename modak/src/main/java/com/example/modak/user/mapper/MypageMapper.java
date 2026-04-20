package com.example.modak.user.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.review.model.Review;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;

@Mapper
public interface MypageMapper {

	// 마이페이지 들어올 때 유저 조회
	User selectMypageUser(@Param("userId") String userId);

	// 마이페이지 유저 정보 요약
	MypageSummary selectMypageSummary(@Param("userId") String userId);

	// 포인트 내역 조회
	List<PointHistory> selectPointHistory(@Param("userId") String userId);
	
	// 리뷰 조회
	List<Review> selectMyReviewList(@Param("userId") String userId, @Param("offset") int offset,
			@Param("pageSize") int pageSize);

	int selectMyReviewCount(@Param("userId") String userId);
}