package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.ViewService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ViewController {

    @Autowired
    ViewService viewService;
    
    // 최근 본 상품 더보기
    @RequestMapping("/user/recent/history.do")
    public String recentHistoryPage() {
        return "/user/recent-history";
    }
    
    // 최근 본 상품 호출
    @RequestMapping(value = "/user/recent/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRecentList(HttpServletRequest request,
                                @RequestParam HashMap<String, Object> map) {

        String userId = (String) request.getSession().getAttribute("sessionId");
        map.put("userId", userId);

        HashMap<String, Object> resultMap = viewService.getRecentList(map);

        return new Gson().toJson(resultMap);
    }
}