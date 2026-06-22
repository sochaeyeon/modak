package com.example.modak.product.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.product.dao.ProductQnaService;
import com.example.modak.product.model.ProductQna;

import jakarta.servlet.http.HttpSession;

@RestController // 이 클래스 내의 모든 메서드는 자동으로 JSON 반환 (@ResponseBody 생략 가능)
@RequestMapping("/product/qna") // 주소 앞부분 공통 처리
public class ProductQnaController {

    @Autowired
    private ProductQnaService qnaService;

    // 1. 목록 불러오기 (로그인 안 해도 볼 수 있음)
    @PostMapping("/list.dox")
    public HashMap<String, Object> qnaList(@RequestParam HashMap<String, Object> map) {
        return qnaService.getQnaList(map);
    }

    // 2. 문의 등록
    @PostMapping("/add.dox")
    public HashMap<String, Object> qnaAdd(ProductQna qna, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> res = new HashMap<>();
        
        // 백엔드 단에서도 로그인 검증 (안전 장치)
        if (userId == null) {
            res.put("result", "login");
            return res;
        }
        qna.setUserId(userId);
        return qnaService.addQna(qna);
    }

    // 3. 문의 수정
    @PostMapping("/edit.dox")
    public HashMap<String, Object> qnaEdit(ProductQna qna, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> res = new HashMap<>();
        
        if (userId == null) {
            res.put("result", "login");
            return res;
        }
        qna.setUserId(userId);
        return qnaService.editQna(qna);
    }

    // 4. 문의 삭제
    @PostMapping("/delete.dox")
    public HashMap<String, Object> qnaDelete(@RequestParam HashMap<String, Object> map, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> res = new HashMap<>();
        
        if (userId == null) {
            res.put("result", "login");
            return res;
        }
        map.put("userId", userId);
        return qnaService.removeQna(map);
    }
}