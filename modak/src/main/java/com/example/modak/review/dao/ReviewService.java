package com.example.modak.review.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.review.mapper.ReviewMapper;
import com.example.modak.review.model.Review;
import com.example.modak.review.model.ReviewImage;

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

	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. 로그인 사용자 세션값 주입
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			// 2. 페이지 계산
			int page = Integer.parseInt(String.valueOf(map.get("page")));
			int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
			int offset = (page - 1) * pageSize;

			map.put("offset", offset);

			// 3. 리뷰 목록 / 개수 조회
			List<Review> list = reviewMapper.selectReviewList(map);
			int totalCount = reviewMapper.selectReviewCount(map);

			// 4. 리뷰별 이미지 목록 조회
			for (Review review : list) {
				HashMap<String, Object> imgMap = new HashMap<>();
				imgMap.put("reviewId", review.getReviewId());

				List<ReviewImage> imageList = reviewMapper.selectReviewImageList(imgMap);
				review.setImageList(imageList);
				review.setImageCount(imageList != null ? imageList.size() : 0);

				if (imageList != null && !imageList.isEmpty()) {
					review.setImageUrl(imageList.get(0).getImgUrl());
				}
			}

			resultMap.put("result", "success");
			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "리뷰 목록 조회 실패");
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
	
	// 상품 상세 리뷰 목록!!
	public HashMap<String, Object> getProductReviewList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
//	        int page = Integer.parseInt(String.valueOf(map.get("page")));
//	        int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
	    	int page = map.get("page") != null ? Integer.parseInt(String.valueOf(map.get("page"))) : 1;
	        int pageSize = map.get("pageSize") != null ? Integer.parseInt(String.valueOf(map.get("pageSize"))) : 10;
	        int offset = (page - 1) * pageSize;
	        map.put("offset", offset);

	        List<Review> list = reviewMapper.selectProductReviewList(map);
	        resultMap.put("result", "success");
	        resultMap.put("list", list);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "리뷰 목록 조회 실패");
	    }
	    return resultMap;
	}
}