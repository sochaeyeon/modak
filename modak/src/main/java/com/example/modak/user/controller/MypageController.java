package com.example.modak.user.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.modak.board.dao.BoardService;
import com.example.modak.review.dao.ReviewService;
import com.example.modak.user.dao.MypageService;
import com.example.modak.user.mapper.CouponMapper;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.PointHistory;
import com.example.modak.user.model.User;
import com.example.modak.user.model.UserCoupon;
import com.google.gson.Gson;
import org.springframework.web.bind.annotation.GetMapping;

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
	
	@Autowired
	BoardService boardService;

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

		// ★ reviewService.getReviewList 대신 직접 이미지 포함 조회
		HashMap<String, Object> reviewMap = new HashMap<>();
		reviewMap.put("page", 1);
		reviewMap.put("pageSize", 5);
		reviewMap.put("userId", sessionId);

		HashMap<String, Object> reviewResult = reviewService.getReviewList(reviewMap);

		model.addAttribute("reviewList", reviewResult.get("list")); // imageList 포함된 list
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
	
	
	@PostMapping(value = "/bookmark/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBookmarkList() {

		String userId = (String) session.getAttribute("sessionId");
		

	    return new Gson().toJson(boardService.getBookmarkList(userId));
	}
	@PostMapping(value="/user/mini-profile.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getMiniProfile(@RequestParam String targetUserId) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        HashMap<String, Object> map = new HashMap<>();
	        map.put("userId", targetUserId);
	        HashMap<String, Object> user = mypageService.getMiniProfile(map);
	        if (user == null) {
	            result.put("result", "fail");
	            return new Gson().toJson(result);
	        }
	        result.put("result", "success");
	        result.put("user", user);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	    }
	    return new Gson().toJson(result);
	}
	@Autowired
	private com.example.modak.board.mapper.BoardMapper boardMapper;

	// 유저 프로필 페이지
	@GetMapping("/user/profile.do")
	public String profilePage() {
	    return "user/user-profile";
	}

	// 유저 프로필 데이터 조회
	@PostMapping(value="/user/profile.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getUserProfile(@RequestParam String targetUserId) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        HashMap<String, Object> map = new HashMap<>();
	        map.put("userId", targetUserId);

	        HashMap<String, Object> user = mypageService.getMiniProfile(map);
	        if (user == null) {
	            result.put("result", "fail");
	            result.put("message", "유저를 찾을 수 없습니다.");
	            return new Gson().toJson(result);
	        }

	        map.put("limit", 5);
	        List<java.util.Map<String, Object>> recentBoards = boardMapper.selectRecentBoardsByUser(map);

	        result.put("result", "success");
	        result.put("user", user);
	        result.put("recentBoards", recentBoards);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	    }
	    return new Gson().toJson(result);
	}
	
}