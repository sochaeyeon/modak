package com.example.modak.review.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.review.dao.ReviewService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

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

	// 리뷰 수정 페이지
	@RequestMapping("/user/review/edit.do")
	public String reviewEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "review/review-edit";
	}

	// 리뷰 등록
	@RequestMapping(value = "/user/review/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.addReview(map);
		return new Gson().toJson(resultMap);
	}

	// 내 리뷰 목록 조회
	@RequestMapping(value = "/user/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.getReviewList(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 상세 조회
	@RequestMapping(value = "/user/review/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.getReviewInfo(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 수정
	@RequestMapping(value = "/user/review/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.editReview(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 삭제
	@RequestMapping(value = "/user/review/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.removeReview(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 상세 리뷰 목록 (로그인 불필요)
	@RequestMapping(value = "/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = reviewService.getProductReviewList(map);
	    return new Gson().toJson(resultMap);
	}
	
}