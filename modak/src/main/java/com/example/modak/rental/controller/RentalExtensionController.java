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
import com.google.gson.Gson;

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
 // 반납 가능 목록
    @PostMapping(value = "/return/list.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getReturnableList(@RequestParam HashMap<String, Object> map,
                                    HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");

        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        map.put("userId", userId);
        return new Gson().toJson(service.getReturnableList(map));
    }

    // 회원 반납 신청
    @PostMapping(value = "/return/apply.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String applyReturn(@RequestParam HashMap<String, Object> map,
                              HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");

        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        map.put("userId", userId);
        return new Gson().toJson(service.applyReturn(map));
    }

    // 비회원 반납 신청
    @PostMapping(value = "/return/guest/apply.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String applyGuestReturn(@RequestParam HashMap<String, Object> map) {
        String token = (String) map.get("token");
        String rentalId = (String) map.get("rentalId");

        return new Gson().toJson(service.applyGuestReturn(map));
    }
    
    @PostMapping(value = "/return/cancel.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String cancelReturn(@RequestParam HashMap<String, Object> map,
                               HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");

        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        map.put("userId", userId);
        return new Gson().toJson(service.cancelReturn(map));
    }
    
    @PostMapping(value = "/return/guest/cancel.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String cancelGuestReturn(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(service.cancelGuestReturn(map));
    }
    
    @PostMapping(value = "/return/address.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getReturnAddress(@RequestParam HashMap<String, Object> map,
                                   HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");

        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        map.put("userId", userId);
        return new Gson().toJson(service.getDefaultPickupAddress(map));
    }
    @PostMapping(value = "/return/guest/address.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getGuestReturnAddress(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(service.getGuestPickupAddress(map));
    }
}
