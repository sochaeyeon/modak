package com.example.modak.guide.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.guide.dao.GuideService;

@Controller
public class GuideController {
    @Autowired private GuideService guideService;

    // 페이지 이동: http://localhost:8080/guide/guide.do
    @RequestMapping("/guide/guide.do")
    public String goGuide() {
        return "guide/guide"; 
    }

    // 데이터 API 주소
    @PostMapping("/api/guide/list.dox")
    @ResponseBody
    public List<HashMap<String, Object>> guideList(@RequestBody HashMap<String, Object> params) {
        return guideService.getGuideList(params);
    }
}