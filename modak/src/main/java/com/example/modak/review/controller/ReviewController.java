package com.example.modak.review.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.review.dao.ReviewService;
import com.example.modak.review.model.ReviewHelpful;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

	@Autowired
	ReviewService reviewService;

	// 리뷰 전체보기 페이지
	@RequestMapping("/user/review/history.do")
	public String reviewHistory(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "review/review-history";
	}

	// 리뷰 작성 페이지
	@RequestMapping("/user/review/add.do")
	public String reviewAdd(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {

		HashMap<String, Object> resultMap = reviewService.getReviewWriteInfo(map);

		request.setAttribute("map", map);
		request.setAttribute("info", resultMap.get("info"));
		return "review/review-add";
	}

	// 리뷰 수정 페이지
	@RequestMapping("/user/review/edit.do")
	public String reviewEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {

		HashMap<String, Object> resultMap = reviewService.getReviewInfo(map);

		if (!"success".equals(resultMap.get("result"))) {
			model.addAttribute("msg", resultMap.get("message"));
			model.addAttribute("loc", "/user/review/history.do");
			return "common/msg";
		}

		request.setAttribute("map", map);
		request.setAttribute("info", resultMap.get("info"));
		return "review/review-edit";
	}

	@RequestMapping(value = "/user/review/order-info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewOrderInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.getReviewOrderInfo(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 등록
	@RequestMapping(value = "/user/review/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addReview(HttpServletRequest request, @RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) MultipartFile[] files) throws Exception {
		HashMap<String, Object> resultMap = reviewService.addReview(map, files, request);
		return new Gson().toJson(resultMap);
	}

	// 내 리뷰 목록 조회
	@RequestMapping(value = "/user/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.getReviewList(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 상세 조회
	@RequestMapping(value = "/user/review/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.getReviewInfo(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 수정
	@RequestMapping(value = "/user/review/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editReview(HttpServletRequest request, @RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) MultipartFile[] files) throws Exception {
		HashMap<String, Object> resultMap = reviewService.editReview(map, files, request);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 삭제
	@RequestMapping(value = "/user/review/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.removeReview(map);
		return new Gson().toJson(resultMap);
	}

	// 상품 상세 리뷰 목록
	@RequestMapping(value = "/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.getProductReviewList(map);
		return new Gson().toJson(resultMap);
	}

	@PostMapping("/review/helpful.dox")
	@ResponseBody
	public Map<String, Object> helpful(@RequestParam Long reviewId, HttpSession session) {
		Map<String, Object> result = new HashMap<>();

		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			result.put("result", "login");
			return result;
		}

		ReviewHelpful helpful = new ReviewHelpful();
		helpful.setReviewId(reviewId);
		helpful.setUserId(userId);

		return reviewService.toggleHelpful(helpful);
	}

	@PostMapping("/review/report.dox")
	@ResponseBody
	public HashMap<String, Object> reportReview(@RequestParam Long reviewId, @RequestParam String content,
			HttpSession session) {
		HashMap<String, Object> result = new HashMap<>();

		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			result.put("result", "login");
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("reviewId", reviewId);
		map.put("userId", userId);
		map.put("content", content);

		return reviewService.reportReview(map);
	}

	// 리뷰 전체보기 목록 (페이징 Ajax)
	@RequestMapping(value = "/user/review/history.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewHistory(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reviewService.getReviewList(map);
		return new Gson().toJson(resultMap);
	}
}