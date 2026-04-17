package com.example.modak.main.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.camp.model.Camp;
import com.example.modak.main.dao.MainService;
import com.google.gson.Gson;

@Controller
public class MainController {

    @Autowired
    private MainService mainService;

    // 1. application.properties에 설정한 카카오 API 키를 가져옵니다.
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    
    /**
     * [페이지 이동] 메인 페이지 접속 (localhost:8080/main.do)
     * 카카오 맵 API 키를 Model에 담아 JSP로 전달합니다.
     */
    @RequestMapping("/main.do")
    public String mainPage(Model model) {
        // JSP에서 ${kakaoKey}로 사용할 수 있도록 전달
        model.addAttribute("kakaoKey", kakaoJsKey);
        return "main"; 
    }

    /**
     * [API] 메인 화면용 캠핑장 리스트 조회 (AJAX 통신용)
     */
    @RequestMapping("/main/list.dox")
    @ResponseBody
    public String getMainCampList(@RequestParam HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // DB에서 최신 캠핑장 리스트를 가져오는 서비스 호출
        List<Camp> list = mainService.getMainList(params);
        
        resultMap.put("list", list);
        return new Gson().toJson(resultMap);
    }
}