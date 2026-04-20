package com.example.modak.rental.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.rental.dao.RentalExtensionService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/rental/extension")
public class RentalExtensionController {

    @Autowired
    private RentalExtensionService service;

    // ── 페이지 ──────────────────────────────────

    /** 비회원 조회폼 */
    @GetMapping("/inquiry.do")
    public String inquiryPage() {
        return "rental/rental-inquiry";
    }

    /** 연장 메인 페이지 (회원 / 비회원 공용) */
    @GetMapping("/main.do")
    public String mainPage() {
        return "rental/rental-extension";
    }

    // ── 비회원 AJAX ──────────────────────────────

    /** 비회원 조회 (3중 검증 → 토큰 발급) */
    @PostMapping("/guest/inquiry.dox")
    @ResponseBody
    public Map<String, Object> guestInquiry(@RequestParam Long   rentalId,
                                             @RequestParam String guestName,
                                             @RequestParam String guestPhone) {
        if (rentalId == null || isBlank(guestName) || isBlank(guestPhone))
            return fail("모든 항목을 입력해주세요.");
        return service.inquireGuestRental(rentalId, guestName.trim(), guestPhone.trim());
    }

    /** 비회원 연장 내역 조회 (토큰 검증) */
    @PostMapping("/guest/detail.dox")
    @ResponseBody
    public Map<String, Object> guestDetail(@RequestParam Long   rentalId,
                                            @RequestParam String token) {
        if (rentalId == null || isBlank(token)) return fail("잘못된 요청입니다.");
        return service.getGuestExtensions(rentalId, token);
    }

    // ── 회원 AJAX ────────────────────────────────

    /** 회원 대여 목록 조회 */
    @PostMapping("/list.dox")
    @ResponseBody
    public Map<String, Object> memberList(HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (isBlank(userId)) return fail("로그인이 필요합니다.");
        return service.getMyRentals(userId);
    }

    /** 회원 연장 내역 조회 */
    @PostMapping("/detail.dox")
    @ResponseBody
    public Map<String, Object> memberDetail(@RequestParam Long rentalId,
                                             HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (isBlank(userId)) return fail("로그인이 필요합니다.");
        return service.getExtensions(rentalId, userId);
    }

    // ── 공통 AJAX (회원/비회원 모두) ─────────────

    /** 연장 신청 */
    @PostMapping("/apply.dox")
    @ResponseBody
    public Map<String, Object> apply(@RequestParam Long   rentalId,
                                      @RequestParam int    extensionDays,
                                      @RequestParam(required = false) String token,
                                      HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        // 비회원이면 userId = null, token 사용
        if (isBlank(userId) && isBlank(token)) return fail("로그인 또는 본인 확인이 필요합니다.");
        return service.applyExtension(rentalId, extensionDays,
                isBlank(userId) ? null : userId, token);
    }

    /** 연장 취소 */
    @PostMapping("/cancel.dox")
    @ResponseBody
    public Map<String, Object> cancel(@RequestParam Long   extensionId,
                                       @RequestParam Long   rentalId,
                                       @RequestParam(required = false) String token,
                                       HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (isBlank(userId) && isBlank(token)) return fail("로그인 또는 본인 확인이 필요합니다.");
        return service.cancelExtension(extensionId, rentalId,
                isBlank(userId) ? null : userId, token);
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
