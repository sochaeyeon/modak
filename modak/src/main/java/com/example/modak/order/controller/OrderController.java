package com.example.modak.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.common.Message;
import com.example.modak.delivery.dao.DeliveryService;
import com.example.modak.delivery.model.DeliveryDetail;
import com.example.modak.delivery.model.DeliveryTrackingEvent;
import com.example.modak.order.dao.GuestOrderService;
import com.example.modak.order.dao.OrderService;
import com.example.modak.order.mapper.OrderMapper;
import com.example.modak.user.dao.SmsAuthService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {
	

    @Autowired
    private OrderService orderService;
    @Autowired
    private SmsAuthService smsAuthService;
    
    

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
    @GetMapping("/order/exchange.do")
    public String exchangePage() {
        return "order/order-exchange";
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
    @Autowired
    private DeliveryService deliveryService;  // 기존 서비스 주입

    @PostMapping(value = "/delivery/info.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getDeliveryInfo(@RequestParam HashMap<String, Object> map, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) return "{\"result\":\"fail\",\"message\":\"로그인 필요\"}";

        try {
            // orderId로 deliveryId 먼저 조회
            Integer deliveryId = orderService.getDeliveryIdByOrderId(
                Integer.parseInt(String.valueOf(map.get("orderId")))
            );

            if (deliveryId == null) {
                return new Gson().toJson(Map.of("result", "success", "trackingNo", "", "trackingList", new ArrayList<>()));
            }

            // 기존 DeliveryService 활용
            DeliveryDetail detail = deliveryService.getDeliveryDetail(deliveryId, userId);

            HashMap<String, Object> result = new HashMap<>();
            result.put("result", "success");
            result.put("trackingNo", detail.getTrackingNo() != null ? detail.getTrackingNo() : "");

            // TrackingResult의 eventList를 JSP용 포맷으로 변환
            List<Map<String, Object>> trackingList = new ArrayList<>();
            if (detail.getTrackingResult() != null && detail.getTrackingResult().getEventList() != null) {
                for (DeliveryTrackingEvent e : detail.getTrackingResult().getEventList()) {
                    Map<String, Object> ev = new HashMap<>();
                    ev.put("time",     e.getTime());
                    ev.put("status",   e.getStatus());
                    ev.put("location", e.getLocation());
                    trackingList.add(ev);
                }
            }
            result.put("trackingList", trackingList);
            return new Gson().toJson(result);

        } catch (Exception e) {
            e.printStackTrace();
            return new Gson().toJson(Map.of("result", "fail", "message", e.getMessage()));
        }
    }
   


    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private GuestOrderService guestOrderService;
    @PostMapping(value="/order/guest/list.dox", produces="application/json;charset=UTF-8")
    @ResponseBody
    public String getGuestOrderList(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String verifiedPhone = (String) session.getAttribute("guestVerifiedPhone");
            String verifiedName  = (String) session.getAttribute("guestVerifiedName");
            String reqPhone      = String.valueOf(map.get("guestPhone"));
            String reqName       = String.valueOf(map.get("guestName"));

            if (verifiedPhone == null || !verifiedPhone.equals(reqPhone)
                                      || !verifiedName.equals(reqName)) {
                result.put("result",  "fail");
                result.put("message", "SMS 인증이 필요합니다.");
                return new Gson().toJson(result);
            }

            List<Map<String, Object>> list = orderMapper.selectGuestOrderListByPhone(map);

            // ★ 각 주문에 토큰 새로 발급
            for (Map<String, Object> order : list) {
                String orderId = String.valueOf(order.get("ORDER_ID"));
                // GuestOrderService의 inquireGuestOrder 대신 직접 토큰 생성
                HashMap<String, Object> tokenResult = guestOrderService.inquireGuestOrder(
                    orderId,
                    reqName,
                    reqPhone
                );
                if ("success".equals(tokenResult.get("result"))) {
                    order.put("GUEST_TOKEN", tokenResult.get("token"));
                }
            }

            result.put("result", "success");
            result.put("list",   list);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return new Gson().toJson(result);
    }

    // 세션 저장 엔드포인트
    @PostMapping(value="/order/guest/verify.dox", produces="application/json;charset=UTF-8")
    @ResponseBody
    public String saveGuestSession(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String phone    = String.valueOf(map.get("guestPhone"));
            String name     = String.valueOf(map.get("guestName"));
            String authCode = String.valueOf(map.get("authCode"));

            HashMap<String, Object> verifyParam = new HashMap<>();
            verifyParam.put("userPhone",   phone);
            verifyParam.put("authCode",    authCode);
            verifyParam.put("authPurpose", "GUEST_ORDER");

            HashMap<String, Object> verifyResult = smsAuthService.verifySmsCode(verifyParam);

            if ("success".equals(verifyResult.get("result"))) {
                session.setAttribute("guestVerifiedPhone", phone);
                session.setAttribute("guestVerifiedName",  name);
                result.put("result", "success");
            } else {
                result.put("result",  "fail");
                result.put("message", verifyResult.get("message"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return new Gson().toJson(result);
    }

    // 페이지 라우팅
    @GetMapping("/order/guest/orders.do")
    public String guestOrderListPage() {
        return "order/guest-order-list";
    }
}