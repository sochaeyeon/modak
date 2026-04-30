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
    public String deliveryDetail(@RequestParam("deliveryId") Integer deliveryId, Model model) {

        String sessionId = (String) session.getAttribute("sessionId");

        if (sessionId == null || sessionId.equals("")) {
            return "redirect:/user/login.do";
        }

        DeliveryDetail delivery = deliveryService.getDeliveryDetail(deliveryId, sessionId);

        if (delivery == null) {
            model.addAttribute("msg", "배송 정보를 찾을 수 없습니다.");
            return "common/error";
        }

        model.addAttribute("delivery", delivery);

        return "delivery/delivery-detail";
    }
}