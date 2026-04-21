package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.review.model.Review;
import com.example.modak.user.mapper.MypageMapper;
import com.example.modak.user.model.ChatbotHistory;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;
import com.example.modak.user.model.UserCoupon;

@Service
public class MypageService {

	@Autowired
	MypageMapper mypageMapper;

	public User getMyPageUser(String userId) {
		return mypageMapper.selectMypageUser(userId);
	}

	public MypageSummary getMypageSummary(String userId) {
		return mypageMapper.selectMypageSummary(userId);
	}

	public List<PointHistory> getPointHistory(String userId) {
		return mypageMapper.selectPointHistory(userId);
	}
	
	public List<Review> getMyReviewList(String userId, int page, int pageSize) {
	    int offset = (page - 1) * pageSize;
		return mypageMapper.selectMyReviewList(userId, offset, pageSize);
	}

	public int getMyReviewCount(String userId) {
	    return mypageMapper.selectMyReviewCount(userId);
	}
	
	public List<ChatbotHistory> getChatbotRoomList(String userId) {
	    return mypageMapper.selectChatbotRoomList(userId);
	}
	 
	public List<UserCoupon> getCouponList(String userId) {
		return mypageMapper.selectCouponList(userId);
	}

	// 쿠폰 전체보기 페이징 조회
	public List<UserCoupon> getCouponPagingList(HashMap<String, Object> map) {
		return mypageMapper.selectCouponPagingList(map);
	}

	// 쿠폰 전체 개수
	public int getCouponCount(String userId) {
		return mypageMapper.selectCouponCount(userId);
	}

	// 사용 가능 쿠폰 수
	public int getAvailableCouponCount(String userId) {
		MypageSummary summary = mypageMapper.selectMypageSummary(userId);
		return summary != null ? summary.getCouponCount() : 0;
	}
}