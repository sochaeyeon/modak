package com.example.modak.user.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.review.model.Review;
import com.example.modak.user.model.ChatbotHistory;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;
import com.example.modak.user.model.UserCoupon;

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
	
	// 챗봇 기록 조회
	List<ChatbotHistory> selectChatbotRoomList(@Param("userId") String userId);
	
	List<UserCoupon> selectCouponList(String userId);
	
	List<UserCoupon> selectCouponPagingList(HashMap<String, Object> map);

	int selectCouponCount(@Param("userId") String userId);
	
	List<Map<String, Object>> selectBookmarkList(String userId);
	
	HashMap<String, Object> selectMiniProfile(HashMap<String, Object> map);
}