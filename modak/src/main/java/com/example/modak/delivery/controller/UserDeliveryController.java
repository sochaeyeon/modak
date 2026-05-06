package com.example.modak.delivery.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.modak.delivery.dao.DeliveryService;
import com.example.modak.delivery.model.DeliveryDetail;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserDeliveryController {

    @Autowired
    private DeliveryService deliveryService;

    @Autowired
    private HttpSession session;

    @RequestMapping("/user/delivery/detail.do")
    public String deliveryDetail(
            @RequestParam(value = "deliveryId", required = false) Integer deliveryId,
            @RequestParam(value = "orderId", required = false) Long orderId,
            @RequestParam(value = "token", required = false) String token,
            Model model
    ) {

        String sessionId = (String) session.getAttribute("sessionId");

        DeliveryDetail delivery = null;

        // 회원
        if (deliveryId != null && sessionId != null) {
            delivery = deliveryService.getDeliveryDetail(deliveryId, sessionId);
        }

        // 비회원 + fallback
        if (delivery == null && orderId != null) {
            delivery = deliveryService.getDeliveryDetailByOrderId(orderId, sessionId, token);
        }

        // 👉 이제 error 안 보냄
        if (delivery == null) {
            delivery = deliveryService.getReadyDeliveryDetail(orderId);
        }

        model.addAttribute("delivery", delivery);
        return "delivery/delivery-detail";
    }
}