package com.example.modak.user.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.review.model.Review;
import com.example.modak.user.mapper.MypageMapper;
import com.example.modak.user.model.ChatbotHistory;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;

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
}