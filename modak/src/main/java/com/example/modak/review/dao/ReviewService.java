package com.example.modak.review.dao;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.common.Message;
import com.example.modak.review.mapper.ReviewMapper;
import com.example.modak.review.model.Review;
import com.example.modak.review.model.ReviewHelpful;
import com.example.modak.review.model.ReviewImage;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class ReviewService {

    @Autowired
    ReviewMapper reviewMapper;

    @Autowired
    HttpSession session;

    // 리뷰 작성 페이지 진입용 정보 조회
    public HashMap<String, Object> getReviewWriteInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");

            if (userId == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            map.put("userId", userId);

            HashMap<String, Object> info = reviewMapper.selectReviewWriteInfo(map);

            if (info == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "리뷰 작성 대상 주문 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            int exists = reviewMapper.selectReviewExists(info);
            if (exists > 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", "이미 리뷰를 작성한 주문입니다.");
                return resultMap;
            }

            resultMap.put("result", "success");
            resultMap.put("info", info);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "리뷰 작성 페이지 조회 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 리뷰 등록
    public HashMap<String, Object> addReview(HashMap<String, Object> map, MultipartFile[] files, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");

            if (userId == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }

            map.put("userId", userId);

            // 필수값 검증
            if (map.get("productId") == null || map.get("itemId") == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "상품 정보가 없습니다.");
                return resultMap;
            }

            if (map.get("rating") == null || map.get("content") == null || map.get("title") == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "필수 입력값이 누락되었습니다.");
                return resultMap;
            }

            // 중복 리뷰 방지
            int exists = reviewMapper.selectReviewExists(map);
            if (exists > 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", "이미 리뷰를 작성한 상품입니다.");
                return resultMap;
            }

            map.put("reviewStatus", "ACTIVE");

            int result = reviewMapper.insertReview(map);

            if (result <= 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", Message.ERROR_COMMON);
                return resultMap;
            }

            Long reviewId = Long.valueOf(String.valueOf(map.get("reviewId")));

            // 이미지 저장
            saveReviewImages(reviewId, files, request);

            // 포인트 지급
            int basePoint = 500;
            int extraPoint = 0;

            // 사진 첨부 시 추가 300
            if (files != null && files.length > 0) {
                boolean hasRealFile = false;

                for (MultipartFile file : files) {
                    if (file != null && !file.isEmpty()) {
                        hasRealFile = true;
                        break;
                    }
                }

                if (hasRealFile) {
                    extraPoint = 300;
                }
            }

            int totalPoint = basePoint + extraPoint;

            HashMap<String, Object> pointMap = new HashMap<>();
            pointMap.put("userId", userId);
            pointMap.put("point", totalPoint);

            reviewMapper.updateUserPoint(pointMap);

            resultMap.put("result", "success");
            resultMap.put("message", Message.SUCCESS_ADD);
            resultMap.put("reviewId", reviewId);
            resultMap.put("point", totalPoint);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_SERVER);
        }

        return resultMap;
    }

    public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            int page = Integer.parseInt(String.valueOf(map.get("page")));
            int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
            int offset = (page - 1) * pageSize;

            map.put("offset", offset);

            List<Review> list = reviewMapper.selectReviewList(map);
            int totalCount = reviewMapper.selectReviewCount(map);

            for (Review review : list) {
                HashMap<String, Object> imgMap = new HashMap<>();
                imgMap.put("reviewId", review.getReviewId());

                List<ReviewImage> imageList = reviewMapper.selectReviewImageList(imgMap);

                // 👉 리뷰 이미지만 세팅
                review.setImageList(imageList);
                review.setImageCount(imageList != null ? imageList.size() : 0);

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
                HashMap<String, Object> imgMap = new HashMap<>();
                imgMap.put("reviewId", info.getReviewId());

                List<ReviewImage> imageList = reviewMapper.selectReviewImageList(imgMap);

                // 👉 리뷰 이미지 목록만 세팅
                info.setImageList(imageList);
                info.setImageCount(imageList != null ? imageList.size() : 0);

                // ❌ 절대 넣지마 (상품 이미지 덮어씀)
                // info.setImageUrl(...)

                resultMap.put("result", "success");
                resultMap.put("info", info);
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", Message.ERROR_COMMON);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_SERVER);
        }

        return resultMap;
    }
    // 리뷰 수정
    public HashMap<String, Object> editReview(HashMap<String, Object> map, MultipartFile[] files, HttpServletRequest request) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            int result = reviewMapper.updateReview(map);

            if (result > 0) {

            	Object keepObj = map.get("keepImgIds");

            	if (keepObj == null) {
            	    reviewMapper.deleteReviewImages(map);

            	} else {
            	    List<Long> keepList = new ArrayList<>();

            	    String json = String.valueOf(keepObj);

            	    json = json.replace("[", "")
            	               .replace("]", "")
            	               .replace(" ", "");

            	    if (!json.isEmpty()) {
            	        String[] arr = json.split(",");
            	        for (String s : arr) {
            	            keepList.add(Long.parseLong(s));
            	        }
            	    }

            	    map.put("keepImgIds", keepList);

            	    reviewMapper.deleteReviewImagesNotIn(map);
            	}
                Long reviewId = Long.valueOf(String.valueOf(map.get("reviewId")));
                saveReviewImages(reviewId, files, request);

                resultMap.put("result", "success");
                resultMap.put("message", Message.SUCCESS_UPDATE);

            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", Message.ERROR_COMMON);
            }

        } catch (Exception e) {
            e.printStackTrace();
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

    // 상품 상세 리뷰 목록
    public HashMap<String, Object> getProductReviewList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            int page = map.get("page") != null ? Integer.parseInt(String.valueOf(map.get("page"))) : 1;
            int pageSize = map.get("pageSize") != null ? Integer.parseInt(String.valueOf(map.get("pageSize"))) : 10;
            int offset = (page - 1) * pageSize;

            map.put("offset", offset);

            List<Review> list = reviewMapper.selectProductReviewList(map);

            for (Review review : list) {
                HashMap<String, Object> imgMap = new HashMap<>();
                imgMap.put("reviewId", review.getReviewId());

                List<ReviewImage> imageList = reviewMapper.selectReviewImageList(imgMap);

                // 👉 리뷰 이미지만 세팅
                review.setImageList(imageList);
                review.setImageCount(imageList != null ? imageList.size() : 0);

            }

            resultMap.put("result", "success");
            resultMap.put("list", list);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "리뷰 목록 조회 실패");
        }

        return resultMap;
    }

    // 리뷰 이미지 저장 공통 메서드
    private void saveReviewImages(Long reviewId, MultipartFile[] files, HttpServletRequest request) throws Exception {
        if (files == null || files.length == 0) {
            return;
        }

        String uploadPath = request.getServletContext().getRealPath("/upload/review");
        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) {
                continue;
            }

            String originalName = file.getOriginalFilename();
            String ext = originalName.substring(originalName.lastIndexOf("."));
            String saveName = UUID.randomUUID().toString() + ext;

            File dest = new File(dir, saveName);
            file.transferTo(dest);

            String imgUrl = "/upload/review/" + saveName;

            HashMap<String, Object> imgMap = new HashMap<>();
            imgMap.put("reviewId", reviewId);
            imgMap.put("imgUrl", imgUrl);

            reviewMapper.insertReviewImage(imgMap);
        }
    }
    public HashMap<String, Object> getReviewOrderInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            HashMap<String, Object> orderInfo = reviewMapper.selectReviewOrderInfo(map);
            List<HashMap<String, Object>> orderItemList = reviewMapper.selectReviewOrderItemList(map);

            if (orderInfo == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "주문 정보를 찾을 수 없습니다.");
                return resultMap;
            }

            resultMap.put("result", "success");
            resultMap.put("orderInfo", orderInfo);
            resultMap.put("orderItemList", orderItemList);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "주문 상세 조회 실패");
        }

        return resultMap;
    }
    public Map<String, Object> addHelpful(ReviewHelpful helpful) {
        Map<String, Object> result = new HashMap<>();

        int exists = reviewMapper.existsHelpful(helpful);

        if (exists > 0) {
            result.put("result", "duplicate");
            return result;
        }

        reviewMapper.insertHelpful(helpful);
        reviewMapper.increaseHelpfulCount(helpful.getReviewId());

        result.put("result", "success");
        return result;
    }
    public Map<String, Object> toggleHelpful(ReviewHelpful helpful) {
        Map<String, Object> result = new HashMap<>();

        int exists = reviewMapper.existsHelpful(helpful);

        if (exists > 0) {
            reviewMapper.deleteHelpful(helpful);
            reviewMapper.decreaseHelpfulCount(helpful.getReviewId());

            result.put("result", "success");
            result.put("helpfulYn", "N");
            return result;
        }

        reviewMapper.insertHelpful(helpful);
        reviewMapper.increaseHelpfulCount(helpful.getReviewId());

        result.put("result", "success");
        result.put("helpfulYn", "Y");
        return result;
    }

    public HashMap<String, Object> reportReview(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        int exists = reviewMapper.existsReport(map);

        if (exists > 0) {
            result.put("result", "duplicate");
            return result;
        }

        reviewMapper.insertReport(map);
        result.put("result", "success");

        return result;
    }
}