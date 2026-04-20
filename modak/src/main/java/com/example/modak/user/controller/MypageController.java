package com.example.modak.user.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.review.dao.ReviewService;
import com.example.modak.user.dao.MypageService;
import com.example.modak.user.model.ChatbotHistory;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class MypageController {
	@Autowired
	MypageService mypageService;

	@Autowired
	HttpSession session;

	@Autowired
	ReviewService reviewService;

	@RequestMapping("/user/mypage.do")
	public String myPage(Model model) {

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || sessionId.equals("")) {
			return "redirect:/user/login.do";
		}

		User user = mypageService.getMyPageUser(sessionId);
		MypageSummary summary = mypageService.getMypageSummary(sessionId);
		List<PointHistory> pointHistoryList = mypageService.getPointHistory(sessionId);

		HashMap<String, Object> reviewMap = new HashMap<>();
		reviewMap.put("page", 1);
		reviewMap.put("pageSize", 5);
		reviewMap.put("userId", sessionId);

		HashMap<String, Object> reviewResult = reviewService.getReviewList(reviewMap);
		model.addAttribute("reviewList", reviewResult.get("list"));

		model.addAttribute("user", user);
		model.addAttribute("summary", summary);
		model.addAttribute("pointHistoryList", pointHistoryList);

		return "user/mypage";
	}

}
