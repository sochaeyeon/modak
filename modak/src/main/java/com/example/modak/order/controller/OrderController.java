package com.example.modak.order.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

    // 1. 전체 주문 내역 페이지 이동 (.do)
    @RequestMapping("/order/history.do")
    public String orderHistoryPage() {
        // 실제 파일명: WEB-INF/order/order-history.jsp
        return "order/order-history";
    }

    // 2. 주문 상세 페이지 이동 (.do)
    @RequestMapping("/order/detail.do")
    public String orderDetailPage(@RequestParam("orderId") int orderId, Model model) {
        // ⚠️ 중요: image_f7edeb.png 확인 결과 실제 파일명이 order-detail.jsp 입니다.
        // 하이픈(-)을 포함하여 리턴해야 404 에러가 발생하지 않습니다.
        model.addAttribute("orderId", orderId);
        return "order/order-detail"; 
    }
    

    // 3. 주문 목록 데이터 조회 (AJAX용 .dox)
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

    // 4. 주문 상세 데이터 조회 (AJAX용 .dox)
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
    @RequestMapping("/order/cancel.dox")
    @ResponseBody
    public String cancelOrder(@RequestParam Map<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        // 1. 세션에서 사용자 아이디 확인 (보안 체크)
        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || "".equals(userId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "로그인이 필요하다닥! 다시 로그인해달라닥.");
            return new Gson().toJson(resultMap);
        }

        // 2. 서비스 호출 전 유저 아이디 추가 (필요 시 서비스나 맵퍼에서 본인 확인용으로 사용)
        map.put("userId", userId);

        try {
            // 3. 서비스 호출 
            // (map 안에는 orderId, cancelReasonCode, cancelReasonText, cancelAmount 가 들어있음)
            resultMap = orderService.cancelOrder(map);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "알 수 없는 오류가 발생했다닥! 관리자에게 문의해달라닥.");
        }

        return new Gson().toJson(resultMap);
    }
}