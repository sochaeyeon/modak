package com.example.modak.product.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.product.mapper.ProductQnaMapper;
import com.example.modak.product.model.ProductQna;

@Service
public class ProductQnaService {

    @Autowired
    private ProductQnaMapper qnaMapper;

    // 1. QnA 목록 불러오기 (페이징 적용)
    public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // Vue에서 넘겨준 페이지 번호로 LIMIT, OFFSET 계산
            int page = map.get("page") != null ? Integer.parseInt(String.valueOf(map.get("page"))) : 1;
            int pageSize = map.get("pageSize") != null ? Integer.parseInt(String.valueOf(map.get("pageSize"))) : 5;
            int offset = (page - 1) * pageSize;

            map.put("offset", offset);
            map.put("pageSize", pageSize);

            Long productId = Long.parseLong(String.valueOf(map.get("productId")));

            List<ProductQna> list = qnaMapper.selectQnaList(map);
            int totalCount = qnaMapper.selectQnaTotalCount(map);

            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "Q&A 목록을 불러오는 중 오류가 발생했습니다.");
        }
        return resultMap;
    }

    // 2. QnA 등록
    public HashMap<String, Object> addQna(ProductQna qna) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            qnaMapper.insertQna(qna);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
        }
        return resultMap;
    }

    // 3. QnA 본인 글 수정
    public HashMap<String, Object> editQna(ProductQna qna) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            int result = qnaMapper.updateQna(qna);
            if(result > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "수정 권한이 없거나 이미 답변이 완료된 문의입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
        }
        return resultMap;
    }

    // 4. QnA 본인 글 삭제
    public HashMap<String, Object> removeQna(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            int result = qnaMapper.deleteQna(map);
            if(result > 0) {
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "삭제 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
        }
        return resultMap;
    }
    
    // 어드민 제품문의 목록
    public HashMap<String, Object> getAdminQnaList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            resultMap.put("list", qnaMapper.selectAdminQnaList(map));
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "문의 목록을 불러오는 중 오류가 발생했습니다.");
        }
        return resultMap;
    }

    public HashMap<String, Object> answerQna(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            int result = qnaMapper.updateQnaAnswer(map);
            resultMap.put("result", result > 0 ? "success" : "fail");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
        }
        return resultMap;
    }
    
    // 어드민 사이드바 배지 - 미답변 상품문의 건수
    public int getWaitingCount() {
        try {
            return qnaMapper.selectWaitingQnaCount();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}