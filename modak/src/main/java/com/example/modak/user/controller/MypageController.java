package com.example.modak.user.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.review.dao.ReviewService;
import com.example.modak.user.dao.MypageService;
import com.example.modak.user.mapper.CouponMapper;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;
import com.example.modak.user.model.UserCoupon;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class MypageController {

	@Autowired
	MypageService mypageService;

	@Autowired
	HttpSession session;
	
	@Autowired
	CouponMapper couponMapper;
	
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
		List<UserCoupon> couponList = mypageService.getCouponList(sessionId);

		HashMap<String, Object> reviewMap = new HashMap<>();
		reviewMap.put("page", 1);
		reviewMap.put("pageSize", 5);
		reviewMap.put("userId", sessionId);

		HashMap<String, Object> reviewResult = reviewService.getReviewList(reviewMap);
		model.addAttribute("reviewList", reviewResult.get("list"));

		model.addAttribute("user", user);
		model.addAttribute("summary", summary);
		model.addAttribute("pointHistoryList", pointHistoryList);
		model.addAttribute("couponList", couponList);

		return "user/mypage";
	}

	@RequestMapping(value = "/user/coupon/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCouponList(@RequestParam HashMap<String, Object> map) {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String sessionId = (String) session.getAttribute("sessionId");

	        int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
	        int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "10")));
	        int start = (page - 1) * pageSize;

	        map.put("userId", sessionId);
	        map.put("start", start);
	        map.put("pageSize", pageSize);

	        List<UserCoupon> list = couponMapper.selectUserCouponList(map);

	        resultMap.put("result", "success");
	        resultMap.put("list", list);
	        resultMap.put("totalCount", couponMapper.selectUserCouponCount(map));
	        resultMap.put("availableCouponCount", couponMapper.selectAvailableCouponCount(map));

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return new Gson().toJson(resultMap);
	}
}