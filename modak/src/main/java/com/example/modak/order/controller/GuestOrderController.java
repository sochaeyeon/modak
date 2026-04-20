package com.example.modak.order.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.order.dao.GuestOrderService;

@Controller
@RequestMapping("/order/guest")
public class GuestOrderController {

    @Autowired
    private GuestOrderService guestOrderService;

    // ── 페이지 ──────────────────────────────────

    /** 비회원 주문조회 폼 */
    @GetMapping("/inquiry.do")
    public String inquiryPage() {
        return "order/guest-order-inquiry";
    }

    /** 비회원 주문상세 */
    @GetMapping("/detail.do")
    public String detailPage() {
        return "order/guest-order-detail";
    }

    // ── AJAX ────────────────────────────────────

    /** 주문 조회 (3중 검증 → 토큰 발급) */
    @PostMapping("/inquiry.dox")
    @ResponseBody
    public Map<String, Object> inquiryAjax(@RequestParam String orderId,
                                           @RequestParam String guestName,
                                           @RequestParam String guestPhone) {
        if (isBlank(orderId) || isBlank(guestName) || isBlank(guestPhone)) {
            return fail("모든 항목을 입력해주세요.");
        }
        return guestOrderService.inquireGuestOrder(
                orderId.trim(), guestName.trim(), guestPhone.trim());
    }

    /** 주문 상세 조회 (토큰 검증) */
    @PostMapping("/detail.dox")
    @ResponseBody
    public Map<String, Object> detailAjax(@RequestParam String orderId,
                                          @RequestParam String token) {
        if (isBlank(orderId) || isBlank(token)) return fail("잘못된 요청입니다.");
        return guestOrderService.getGuestOrderDetail(orderId.trim(), token.trim());
    }

    /** 주문 취소 */
    @PostMapping("/cancel.dox")
    @ResponseBody
    public Map<String, Object> cancelAjax(@RequestParam String orderId,
                                          @RequestParam String token) {
        if (isBlank(orderId) || isBlank(token)) return fail("잘못된 요청입니다.");
        return guestOrderService.cancelGuestOrder(orderId.trim(), token.trim());
    }

    /** 반품 신청 */
    @PostMapping("/return.dox")
    @ResponseBody
    public Map<String, Object> returnAjax(@RequestParam String orderId,
                                          @RequestParam String token) {
        if (isBlank(orderId) || isBlank(token)) return fail("잘못된 요청입니다.");
        return guestOrderService.returnGuestOrder(orderId.trim(), token.trim());
    }

    // ── 유틸 ────────────────────────────────────
    private boolean isBlank(String s) { return s == null || s.isBlank(); }

    private Map<String, Object> fail(String message) {
        Map<String, Object> map = new HashMap<>();
        map.put("result",  "fail");
        map.put("message", message);
        return map;
    }
}
