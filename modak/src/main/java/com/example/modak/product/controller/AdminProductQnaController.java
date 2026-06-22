package com.example.modak.product.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.product.dao.ProductQnaService;

@RestController
@RequestMapping("/admin/product-qna")
public class AdminProductQnaController {

    @Autowired
    private ProductQnaService qnaService;

    @PostMapping("/list.dox")
    public HashMap<String, Object> list(@RequestParam HashMap<String, Object> map) {
        return qnaService.getAdminQnaList(map);
    }

    @PostMapping("/answer.dox")
    public HashMap<String, Object> answer(@RequestParam HashMap<String, Object> map) {
        // map: qnaId, answer  (관리자는 본인 글 여부 체크 없이 답변 가능)
        return qnaService.answerQna(map);
    }

    @PostMapping("/badge.dox")
    public HashMap<String, Object> badge() {
        HashMap<String, Object> res = new HashMap<>();
        res.put("count", qnaService.getWaitingCount()); // Service에 카운트 메서드 추가 필요
        return res;
    }
}