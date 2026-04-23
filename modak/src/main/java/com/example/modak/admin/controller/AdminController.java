package com.example.modak.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.admin.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService;

	@Autowired
	private HttpSession session;

	/* ==========================================================
       1. 관리자 권한 및 공통 유틸리티
       ========================================================== */

	// 세션을 확인하여 현재 사용자가 관리자인지 여부 판단
	private boolean isAdmin() {
		return Boolean.TRUE.equals(session.getAttribute("isAdmin"));
	}

	// 권한이 없는 접근에 대해 표준화된 실패 메시지 반환 (JSON)
	private String noAuth() {
		return new Gson().toJson(Map.of("result", "fail", "message", "관리자 권한이 필요합니다."));
	}

	/* ==========================================================
       2. 관리자 인증 (Login / Logout)
       ========================================================== */

	// 관리자 로그인 페이지 호출
	@GetMapping("/login.do")
	public String loginPage() {
		return "admin/admin-login";
	}

	// 관리자 로그인 처리 (비동기 API)
	@PostMapping(value = "/login.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> loginResult = adminService.adminLogin(map);

		if ("success".equals(loginResult.get("result"))) {
			session.setAttribute("sessionId", map.get("id"));
			session.setAttribute("adminName", loginResult.get("adminName"));
			session.setAttribute("isAdmin", true);
			session.setMaxInactiveInterval(60 * 60 * 2); // 세션 유지 시간 2시간
		}
		return new Gson().toJson(loginResult);
	}

	// 관리자 로그아웃 처리 및 세션 무효화
	@GetMapping("/logout.do")
	public String logout() {
		session.invalidate();
		return "redirect:/admin/login.do";
	}

	/* ==========================================================
       3. 페이지 라우팅 (View Mapping)
       ========================================================== */

	// 대시보드 메인 페이지
	@GetMapping("/dashboard.do")
	public String dashboard() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-dashboard";
	}

	// 회원 관리 페이지
	@GetMapping("/members.do")
	public String members() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-members";
	}

	// 상품 관리 페이지
	@GetMapping("/products.do")
	public String products() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-products";
	}

	// 1:1 문의 관리 페이지
	@GetMapping("/inquiry.do")
	public String inquiry() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-inquiry";
	}

	// 리뷰 관리 페이지
	@GetMapping("/reviews.do")
	public String reviews() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-reviews";
	}

	// 매출 현황 페이지
	@GetMapping("/sales.do")
	public String sales() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-sales";
	}

	// 이벤트 및 배너 관리 페이지
	@GetMapping("/events.do")
	public String events() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-events";
	}

	// 통합 통계 페이지
	@GetMapping("/stats.do")
	public String stats() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-stats";
	}

	// 주문 관리 페이지
	@GetMapping("/orders.do")
	public String orders() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-orders";
	}

	// 쿠폰 발행 및 관리 페이지
	@GetMapping("/coupons.do")
	public String coupons() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-coupons";
	}

	// 대여 현황 관리 페이지
	@GetMapping("/rentals.do")
	public String rentalsPage() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-rentals";
	}

	// 캠핑장 정보 관리 페이지
	@GetMapping("/camps.do")
	public String campManagement() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-camps";
	}

	/* ==========================================================
       4. 데이터 관리 API (RESTful API / JSON 반환)
       ========================================================== */

	/* --- 대시보드 & 통계 API --- */
	@PostMapping(value = "/dashboard.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDashboard() {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getDashboardData());
	}

	@PostMapping(value = "/stats/view-data.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductViewStats(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getProductViewStats(map));
	}

	/* --- 1:1 문의 관리 API --- */
	@PostMapping(value = "/inquiry/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryList(@RequestParam HashMap<String, Object> map) throws Exception {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getInquiryList(map));
	}

	@PostMapping(value = "/inquiry/answer.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveInquiryAnswer(@RequestParam HashMap<String, Object> map) throws Exception {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.saveInquiryAnswer(map));
	}

	@PostMapping(value = "/inquiry/badge.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryBadge() {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getInquiryBadge());
	}

	/* --- 회원 관리 API --- */
	@PostMapping(value = "/member/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMemberList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getMemberList(map));
	}

	@PostMapping(value = "/member/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateMemberStatus(map));
	}

	/* --- 상품 관리 API --- */
/* ─── 상품 관리 API ─── */
	
	// 상품 리스트 조회
	@PostMapping(value = "/product/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getAdminProductList(map));
	}

	// 신규 상품 등록 (이미지 + 사양 + 특징 포함)
	@PostMapping(value = "/product/insertFull.dox")
	@ResponseBody
	public String insertFullProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    // 서비스의 insertFullProduct 메서드 호출
	    return new Gson().toJson(adminService.insertFullProduct(map));
	}

	@PostMapping(value = "/product/update.dox")
	@ResponseBody
	public String updateProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    // 서비스의 updateFullProduct 메서드 호출
	    return new Gson().toJson(adminService.updateFullProduct(map));
	}
	@PostMapping(value = "/product/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeProduct(map));
	}

	// 상품 판매 상태 변경 (중지/복구)
	@PostMapping(value = "/product/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleProductAvail(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.toggleProductAvail(map));
	}

	/* --- 리뷰 관리 API --- */
	@PostMapping("/review/list.dox")
	@ResponseBody
	public String getReviewList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getReviewList(map));
	}

	@PostMapping("/review/remove.dox")
	@ResponseBody
	public String removeReview(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.removeReview(map));
	}

	/* --- 매출 및 이벤트 관리 API --- */
	@PostMapping(value = "/sales/data.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSalesData(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getSalesData(map));
	}

	@PostMapping(value = "/event/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getEventList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getEventList(map));
	}

	@PostMapping(value = "/event/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveEvent(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.saveEvent(map));
	}

	@PostMapping(value = "/event/delete.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteEvent(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.deleteEvent(map));
	}

	/* --- 주문 및 대여 관리 API --- */
	@PostMapping(value = "/order/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOrderList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getAdminOrderList(map));
	}

	@PostMapping(value = "/order/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateOrderStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateOrderStatus(map));
	}

	@PostMapping(value = "/rental/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRentalList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getAdminRentalList(map));
	}

	@PostMapping(value = "/rental/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRentalStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateRentalStatus(map));
	}

	@PostMapping(value = "/rental/update-date.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRentalDate(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateRentalDate(map));
	}

	/* --- 캠핑장 및 쿠폰 관리 API --- */
	@PostMapping(value = "/camp/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCampList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getCampList(map));
	}

	@PostMapping(value = "/camp/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateCampStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateCampStatus(map));
	}

	@PostMapping("/coupon/list.dox")
	@ResponseBody
	public String getCouponList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getCouponList(map));
	}

	@PostMapping("/coupon/updateStatus.dox")
	@ResponseBody
	public String updateCouponStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.modifyCouponStatus(map));
	}
}