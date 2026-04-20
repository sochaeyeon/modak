package com.example.modak.review.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.review.mapper.ReviewMapper;
import com.example.modak.review.model.Review;

import jakarta.servlet.http.HttpSession;

@Service
public class ReviewService {

	@Autowired
	ReviewMapper reviewMapper;

	@Autowired
	HttpSession session;

	// 리뷰 등록
	public HashMap<String, Object> addReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			int result = reviewMapper.insertReview(map);

			if (result > 0) {
				// 대표 이미지 1장 저장
				if (map.get("imgUrl") != null && !"".equals(map.get("imgUrl"))) {
					reviewMapper.insertReviewImage(map);
				}

				resultMap.put("result", "success");
				resultMap.put("message", Message.SUCCESS_ADD);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.ERROR_COMMON);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	// 내 리뷰 목록 조회
	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			int page = Integer.parseInt(String.valueOf(map.get("page")));
			int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
			int offset = (page - 1) * pageSize;

			map.put("offset", offset);
			map.put("pageSize", pageSize);

			List<Review> list = reviewMapper.selectReviewList(map);
			int totalCount = reviewMapper.selectReviewCount(map);

			resultMap.put("result", "success");
			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("page", page);
			resultMap.put("pageSize", pageSize);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	// 리뷰 상세 조회
	public HashMap<String, Object> getReviewInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			Review info = reviewMapper.selectReviewInfo(map);

			if (info != null) {
				resultMap.put("result", "success");
				resultMap.put("info", info);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.ERROR_COMMON);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	// 리뷰 수정
	public HashMap<String, Object> editReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			int result = reviewMapper.updateReview(map);

			if (result > 0) {
				// 새 이미지가 넘어오면 기존 이미지 삭제 후 다시 1장 저장
				if (map.get("imgUrl") != null && !"".equals(map.get("imgUrl"))) {
					reviewMapper.deleteReviewImages(map);
					reviewMapper.insertReviewImage(map);
				}

				resultMap.put("result", "success");
				resultMap.put("message", Message.SUCCESS_UPDATE);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.ERROR_COMMON);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	// 리뷰 삭제
	public HashMap<String, Object> removeReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			int result = reviewMapper.updateReviewStatusDeleted(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.SUCCESS_DELETE);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.ERROR_COMMON);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}
}