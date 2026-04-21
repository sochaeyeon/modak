package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.PointHistoryService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PointHistoryController {

    @Autowired
    private PointHistoryService pointHistoryService;

    @Autowired
    private HttpSession session;

    // 포인트 내역 전체보기 페이지
    @RequestMapping("/user/point/history.do")
    public String pointHistoryPage(HttpServletRequest request) {
        return "user/point-history";
    }

    // 포인트 내역 목록 조회
    @RequestMapping(value = "/user/point/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getPointHistoryList(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String sessionId = (String) session.getAttribute("sessionId");

            int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
            int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "10")));
            int offset = (page - 1) * pageSize;

            map.put("userId", sessionId);
            map.put("page", page);
            map.put("pageSize", pageSize);
            map.put("offset", offset);

            resultMap = pointHistoryService.getPointHistoryList(map);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "포인트 내역 조회 중 오류가 발생했습니다.");
        }

        return new Gson().toJson(resultMap);
    }
}