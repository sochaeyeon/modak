package com.example.modak.order.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.common.Message;
import com.example.modak.order.dao.OrderService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    // 전체 주문 내역 페이지
    @RequestMapping("/order/history.do")
    public String orderHistoryPage() {
        return "order/order-history";
    }
    
    // 주문 목록 조회
    @RequestMapping("/order/list.dox")
    @ResponseBody
    public String getOrderList(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || "".equals(userId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_LOGIN_REQUIRED);
            return new Gson().toJson(resultMap);
        }

        resultMap = orderService.getOrderList(userId);
        return new Gson().toJson(resultMap);
    }

    // 주문 상세 조회
    @RequestMapping("/order/detail.dox")
    @ResponseBody
    public String getOrderDetail(@RequestParam("orderId") Long orderId, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || "".equals(userId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_LOGIN_REQUIRED);
            return new Gson().toJson(resultMap);
        }

        resultMap = orderService.getOrderDetail(orderId, userId);
        return new Gson().toJson(resultMap);
    }
}