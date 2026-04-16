package com.example.modak.camp.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.camp.dao.CampService;
import com.google.gson.Gson;

@Controller
@RequestMapping("/camp")
public class CampController {
    
    @Autowired 
    private CampService campService;

    // 1. application.properties에서 카카오 API 키 가져오기
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    /**
     * 캠핑장 지도 페이지 이동
     * JSP에서 ${kakaoKey}를 사용할 수 있게 Model에 담아줍니다.
     */
    @RequestMapping("/map.do")
    public String mapPage(Model model) {
        model.addAttribute("kakaoKey", kakaoJsKey);
        return "camp/camp-map"; 
    }

    /**
     * 캠핑장 목록 조회 (JSON 반환)
     */
    @RequestMapping("/list.dox")
    @ResponseBody
    public String getList(@RequestParam HashMap<String, Object> params) {
        // 서비스 결과(HashMap 형태 예상)를 바로 JSON으로 변환
        return new Gson().toJson(campService.getCampList(params));
    }

    /**
     * 캠핑장 리뷰 목록 조회 (JSON 반환)
     */
    @RequestMapping("/reviewList.dox")
    @ResponseBody
    public String getReviewList(@RequestParam HashMap<String, Object> params) {
        HashMap<String, Object> map = new HashMap<>();
        // 리뷰 리스트를 "list" 키에 담아서 반환 (JSP의 data.list와 매칭)
        map.put("list", campService.getReviewList(params));
        return new Gson().toJson(map);
    }

    /**
     * 공공데이터 캠핑장 정보 동기화
     */
    @RequestMapping("/sync.do")
    @ResponseBody
    public String sync() {
        try { 
            campService.syncCampData(); 
            return "success"; 
        } catch (Exception e) { 
            e.printStackTrace();
            return e.getMessage(); 
        }
    }
}