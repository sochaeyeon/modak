package com.example.modak.rental.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	public Map<String, Object> guestInquiry(@RequestParam Long rentalId, @RequestParam String guestName,
			@RequestParam String guestPhone) {
		if (rentalId == null || isBlank(guestName) || isBlank(guestPhone))
			return fail("모든 항목을 입력해주세요.");
		return service.inquireGuestRental(rentalId, guestName.trim(), guestPhone.trim());
	}

	/** 비회원 연장 내역 조회 (토큰 검증) */
	@PostMapping("/guest/detail.dox")
	@ResponseBody
	public Map<String, Object> guestDetail(@RequestParam Long rentalId, @RequestParam String token) {
		if (rentalId == null || isBlank(token))
			return fail("잘못된 요청입니다.");
		return service.getGuestExtensions(rentalId, token);
	}

	// ── 회원 AJAX ────────────────────────────────

	/** 회원 대여 목록 조회 */
	@PostMapping("/list.dox")
	@ResponseBody
	public Map<String, Object> memberList(HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (isBlank(userId))
			return fail("로그인이 필요합니다.");
		return service.getMyRentals(userId);
	}

	/** 회원 연장 내역 조회 */
	@PostMapping("/detail.dox")
	@ResponseBody
	public Map<String, Object> memberDetail(@RequestParam Long rentalId, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (isBlank(userId))
			return fail("로그인이 필요합니다.");
		return service.getExtensions(rentalId, userId);
	}

	// ── 공통 AJAX (회원/비회원 모두) ─────────────

	/** 연장 신청 */
	@PostMapping("/apply.dox")
	@ResponseBody
	public Map<String, Object> apply(@RequestParam Long rentalId, @RequestParam int extensionDays,
			@RequestParam(required = false) String token, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		// 비회원이면 userId = null, token 사용
		if (isBlank(userId) && isBlank(token))
			return fail("로그인 또는 본인 확인이 필요합니다.");
		return service.applyExtension(rentalId, extensionDays, isBlank(userId) ? null : userId, token);
	}

	/** 연장 취소 */
	@PostMapping("/cancel.dox")
	@ResponseBody
	public Map<String, Object> cancel(@RequestParam Long extensionId, @RequestParam Long rentalId,
			@RequestParam(required = false) String token, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (isBlank(userId) && isBlank(token))
			return fail("로그인 또는 본인 확인이 필요합니다.");
		return service.cancelExtension(extensionId, rentalId, isBlank(userId) ? null : userId, token);
	}

	// ── 유틸 ────────────────────────────────────
	private boolean isBlank(String s) {
		return s == null || s.isBlank();
	}

	private Map<String, Object> fail(String message) {
		Map<String, Object> map = new HashMap<>();
		map.put("result", "fail");
		map.put("message", message);
		return map;
	}

	// 반납 가능 목록
	@PostMapping(value = "/return/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReturnableList(@RequestParam HashMap<String, Object> map, HttpSession session) {
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
	public String applyReturn(@RequestParam HashMap<String, Object> map, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
		}

		map.put("userId", userId);
		return new Gson().toJson(service.applyReturn(map));
	}

//	@PostMapping(value="/return/guest/apply.dox", produces="application/json;charset=UTF-8")
//	@ResponseBody
//	public String applyGuestReturn(@RequestParam HashMap<String, Object> map, HttpSession session) {
//	    HashMap<String, Object> result = new HashMap<>();
//	    try {
//	        // ★ 전달된 값 전체 출력
//	        System.out.println("=== 반납 신청 파라미터 ===");
//	        map.forEach((k, v) -> System.out.println(k + " = " + v));
//	        System.out.println("세션 verifiedPhone: " + session.getAttribute("guestVerifiedPhone"));
//	        System.out.println("세션 verifiedName: " + session.getAttribute("guestVerifiedName"));
//
//	        String guestPhone = String.valueOf(map.get("guestPhone"));
//	        String rentalId   = String.valueOf(map.get("rentalId"));
//
//	        System.out.println("guestPhone: " + guestPhone);
//	        System.out.println("rentalId: " + rentalId);
//
//	        // 세션 검증
//	        String verifiedPhone = (String) session.getAttribute("guestVerifiedPhone");
//	        boolean ok = verifiedPhone != null && verifiedPhone.equals(guestPhone);
//	        System.out.println("세션 검증 결과: " + ok);
//
//	        if (!ok) {
//	            ok = service.validateGuestRental(rentalId, guestPhone, String.valueOf(map.get("guestName")));
//	            System.out.println("DB 검증 결과: " + ok);
//	        }
//
//	        if (!ok) {
//	            result.put("result",  "fail");
//	            result.put("message", "유효하지 않은 접근입니다.");
//	            return new Gson().toJson(result);
//	        }
//
//	        return new Gson().toJson(service.applyGuestReturn(map));
//
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        result.put("result", "fail");
//	        result.put("message", "서버 오류: " + e.getMessage());
//	        return new Gson().toJson(result);
//	    }
//	}
	
	// 검증 로직 전체 주석 처리하고 바로 실행
	@PostMapping(value="/return/guest/apply.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String applyGuestReturn(@RequestParam HashMap<String, Object> map, HttpSession session) {
	    System.out.println("=== 반납 파라미터 ===");
	    map.forEach((k, v) -> System.out.println(k + " = " + v));
	    
	    // ★ 검증 없이 바로 실행 (테스트용)
	    return new Gson().toJson(service.applyGuestReturn(map));
	}

	@PostMapping(value = "/return/cancel.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cancelReturn(@RequestParam HashMap<String, Object> map, HttpSession session) {
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
	public String getReturnAddress(@RequestParam HashMap<String, Object> map, HttpSession session) {
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

	@Value("${toss.client-key}")
	private String tossClientKey;

	// 연장 결제 준비 (회원/비회원)
	@PostMapping(value = "/payment/ready.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String extensionPaymentReady(@RequestParam HashMap<String, Object> map, HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");

	    if (userId != null && !userId.isBlank()) {
	        map.put("userId", userId);
	        map.put("token", null);
	    } else {
	        String token = String.valueOf(map.get("token"));
	        String orderId = String.valueOf(map.get("orderId"));

	        if (token == null || "null".equals(token) || token.isBlank()) {
	            return "{\"result\":\"fail\",\"message\":\"비회원 인증 정보가 없습니다.\"}";
	        }

	        if (orderId == null || "null".equals(orderId) || orderId.isBlank()) {
	            return "{\"result\":\"fail\",\"message\":\"비회원 주문 정보가 없습니다.\"}";
	        }

	        map.put("userId", "GUEST");
	    }

	    return new Gson().toJson(service.readyExtensionPayment(map));
	}

	@GetMapping("/payment.do")
	public String extensionPaymentPage(@RequestParam HashMap<String, Object> map, Model model) {

	    String type = String.valueOf(map.getOrDefault("type", "extension"));
	    HashMap<String, Object> order;

	    if ("overdue".equals(type)) {
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("overdueOrderId", map.get("extensionOrderId")); // payUrl에서 extensionOrderId로 넘어옴
	        order = service.getOverdueOrder(orderMap);

	        model.addAttribute("tossClientKey", tossClientKey);
	        model.addAttribute("extensionOrderId", order.get("OVERDUE_ORDER_ID"));
	        model.addAttribute("amount", order.get("OVERDUE_FEE"));
	        model.addAttribute("days", order.get("OVERDUE_DAYS"));
	        model.addAttribute("productName", order.get("PRODUCT_NAME"));
	        model.addAttribute("imgUrl", order.get("IMG_URL"));
	    } else {
	        order = service.getExtensionOrder(map);

	        model.addAttribute("tossClientKey", tossClientKey);
	        model.addAttribute("extensionOrderId", order.get("EXTENSION_ORDER_ID"));
	        model.addAttribute("amount", order.get("PRICE"));
	        model.addAttribute("days", order.get("EXTENSION_DAYS"));
	        model.addAttribute("productName", order.get("PRODUCT_NAME"));
	        model.addAttribute("imgUrl", order.get("IMG_URL"));
	    }

	    model.addAttribute("token", map.getOrDefault("token", ""));
	    model.addAttribute("orderId", map.getOrDefault("orderId", ""));
	    model.addAttribute("rentalId", map.getOrDefault("rentalId", ""));

	    return "rental/extension-payment";
	}

	// 연장 결제 성공 콜백
	@GetMapping("/payment/success.do")
	public String extensionPaymentSuccess(@RequestParam String paymentKey, @RequestParam String orderId,
			@RequestParam Long amount, @RequestParam(required = false, defaultValue = "") String token,
			@RequestParam(required = false, defaultValue = "") String guestOrderId,
			@RequestParam(required = false, defaultValue = "") String rentalId, Model model) {
		HashMap<String, Object> result = service.confirmExtensionPayment(paymentKey, orderId, amount, token);

		if ("success".equals(result.get("result"))) {
			model.addAttribute("rentalId", result.get("rentalId"));
			model.addAttribute("orderId", result.get("orderId"));
			model.addAttribute("token", token);
			return "rental/extension-complete";
		}
		model.addAttribute("message", result.get("message"));
		return "payment/fail";
	}

	// 연장 결제 실패 콜백
	@GetMapping("/payment/fail.do")
	public String extensionPaymentFail(@RequestParam(required = false) String message, Model model) {
		model.addAttribute("message", message);
		return "payment/fail";
	}

	@PostMapping("/guest/order-list.dox")
	@ResponseBody
	public Map<String, Object> guestOrderList(@RequestParam String orderId, @RequestParam String token) {
		if (isBlank(orderId) || isBlank(token)) {
			return fail("잘못된 요청입니다.");
		}

		return service.getGuestRentalListByOrder(orderId.trim(), token.trim());
	}
	// 연체료 결제 준비
	@PostMapping(value = "/overdue/payment/ready.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String overduePaymentReady(@RequestParam HashMap<String, Object> map, HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    map.put("userId", userId != null ? userId : "GUEST");
	    return new Gson().toJson(service.readyOverduePayment(map));
	}

	// 연체료 결제 성공 콜백
	@GetMapping("/overdue/payment/success.do")
	public String overduePaymentSuccess(@RequestParam String paymentKey,
	        @RequestParam String orderId, @RequestParam Long amount,
	        @RequestParam(required = false, defaultValue = "") String token,
	        @RequestParam(required = false, defaultValue = "") String rentalId,
	        Model model) {
	    HashMap<String, Object> result = service.confirmOverduePayment(paymentKey, orderId, amount, token);
	    if ("success".equals(result.get("result"))) {
	        model.addAttribute("rentalId", result.get("rentalId"));
	        model.addAttribute("token", token);
	        model.addAttribute("type", "overdue");
	        return "rental/extension-complete";
	    }
	    model.addAttribute("message", result.get("message"));
	    return "payment/fail";
	}
	
	
}
