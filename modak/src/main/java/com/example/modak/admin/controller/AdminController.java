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
@RequestMapping("/admin") // 👈 클래스 레벨에서 /admin이 선언됨
public class AdminController {

	@Autowired
	private AdminService adminService;

	@Autowired
	private HttpSession session;

	/* ==========================================================
       1. 관리자 권한 및 공통 유틸리티
       ========================================================== */
	private boolean isAdmin() {
		return Boolean.TRUE.equals(session.getAttribute("isAdmin"));
	}

	private String noAuth() {
		return new Gson().toJson(Map.of("result", "fail", "message", "관리자 권한이 필요합니다."));
	}

	/* ==========================================================
       2. 관리자 인증 (Login / Logout)
       ========================================================== */
	@GetMapping("/login.do")
	public String loginPage() {
		return "admin/admin-login";
	}

	@PostMapping(value = "/login.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> loginResult = adminService.adminLogin(map);
		if ("success".equals(loginResult.get("result"))) {
			session.setAttribute("sessionId", map.get("id"));
			session.setAttribute("adminName", loginResult.get("adminName"));
			session.setAttribute("isAdmin", true);
			session.setMaxInactiveInterval(60 * 60 * 2);
		}
		return new Gson().toJson(loginResult);
	}

	@GetMapping("/logout.do")
	public String logout() {
		session.invalidate();
		return "redirect:/admin/login.do";
	}

	/* ==========================================================
       3. 페이지 라우팅 (View Mapping - 100% 유지)
       ========================================================== */
	@GetMapping("/dashboard.do")
	public String dashboard() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-dashboard";
	}

	@GetMapping("/members.do")
	public String members() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-members";
	}

	@GetMapping("/products.do")
	public String products() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-products";
	}

	@GetMapping("/inquiry.do")
	public String inquiry() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-inquiry";
	}

	@GetMapping("/reviews.do")
	public String reviews() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-reviews";
	}

	@GetMapping("/sales.do")
	public String sales() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-sales";
	}

	@GetMapping("/events.do")
	public String events() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-events";
	}

	@GetMapping("/stats.do")
	public String stats() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-stats";
	}

	@GetMapping("/orders.do")
	public String orders() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-orders";
	}

	@GetMapping("/coupons.do")
	public String coupons() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-coupons";
	}

	@GetMapping("/rentals.do")
	public String rentalsPage() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-rentals";
	}

	@GetMapping("/camps.do")
	public String campManagement() {
		if (!isAdmin()) return "redirect:/admin/login.do";
		return "admin/admin-camps";
	}

	/* ==========================================================
       4. 데이터 관리 API (기능 및 주소 최적화)
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
	public String getInquiryList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getInquiryList(map));
	}

	@PostMapping(value = "/inquiry/answer.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveInquiryAnswer(@RequestParam HashMap<String, Object> map) {
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
	@PostMapping(value = "/product/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getAdminProductList(map));
	}

	@PostMapping(value = "/product/insertFull.dox")
	@ResponseBody
	public String insertFullProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.insertFullProduct(map));
	}

	@PostMapping(value = "/product/update.dox")
	@ResponseBody
	public String updateProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateFullProduct(map));
	}

	@PostMapping(value = "/product/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeProduct(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeProduct(map));
	}

	@PostMapping(value = "/product/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleProductAvail(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.toggleProductAvail(map));
	}
	
	@PostMapping(value = "/product/stock/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductStockList(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getProductStockList(map));
	}

	@PostMapping(value = "/product/stock/update.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProductStock(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateProductStock(map));
	}

	@PostMapping(value = "/product/stock/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addProductStock(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.addProductStock(map));
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
	
	// 반납 요청 목록 조회
	@PostMapping(value = "/rental/return/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReturnRequestList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getReturnRequestList());
	}
	 
	// 반납 상태 변경 (수거시작 / 반납완료)
	@PostMapping(value = "/rental/return/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateReturnRequestStatus(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateReturnRequestStatus(map));
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
	// ★ 기존 /camp/list.dox, /camp/status.dox 아래에 추가

	@PostMapping(value = "/camp/detail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCampDetail(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getCampDetail(map));
	}

	@PostMapping(value = "/camp/edit.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editCamp(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.editCamp(map));
	}

	@PostMapping(value = "/camp/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeCamp(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeCamp(map));
	}

	@PostMapping(value = "/camp/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCamp(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.addCamp(map));
	}

	/* ==========================================================
    9. 쿠폰 마스터 및 유저 쿠폰 통합 관리 API
    ========================================================== */

	/* --- [1] 쿠폰 마스터 관리 API (Master) --- */

	// 쿠폰 목록 조회
	@PostMapping(value = "/coupon/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCouponList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getCouponList(map));
	}

	// 쿠폰 저장 (신규 등록 및 수정)
	@PostMapping(value = "/coupon/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveCoupon(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.saveCoupon(map));
	}

	// 쿠폰 상태 변경 (활성/비활성)
	@PostMapping(value = "/coupon/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String modifyCouponStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.modifyCouponStatus(map));
	}

	// 쿠폰 마스터 삭제
	@PostMapping(value = "/coupon/delete.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeCoupon(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeCoupon(map));
	}
	

	/* --- [2] 유저 보유 쿠폰(User Coupon) 관리 API --- */

	// 유저별 쿠폰 보유 현황 조회
	@PostMapping(value = "/userCoupon/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getUserCouponList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getUserCouponList(map));
	}

	// 특정 개인에게 쿠폰 지급
	@PostMapping(value = "/userCoupon/give.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String giveCouponToUser(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.giveCouponToUser(map));
	}

	// ✨ 모든 유저에게 쿠폰 일괄 발송 (전체 지급)
	@PostMapping(value = "/userCoupon/giveAll.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String giveCouponToAll(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.giveCouponToAll(map));
	}

	

    // 유저 보유 쿠폰 삭제 (회수)
    @PostMapping("/userCoupon/delete.dox")
    @ResponseBody
    public String removeUserCoupon(@RequestParam HashMap<String, Object> map) {
        if (!isAdmin()) return noAuth();
        return new Gson().toJson(adminService.removeUserCoupon(map));
    }

	// 유저 쿠폰 사용 상태 강제 변경 (사용완료/미사용)
	@PostMapping(value = "/userCoupon/updateStatus.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String modifyUserCouponStatus(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.modifyUserCouponStatus(map));
	}
	@GetMapping("/membership.do")
	public String membership() {
	    if (!isAdmin()) return "redirect:/admin/login.do";
	    return "admin/admin-membership";
	}
	 
	@PostMapping(value="/grade/list.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getGradeList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getGradeList());
	}
	 
	@PostMapping(value="/grade/save.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String saveGrade(@RequestParam HashMap<String,Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.saveGrade(map));
	}
	 
	@PostMapping(value="/member/grade.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberGrade(@RequestParam HashMap<String,Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateMemberGrade(map));
	}
	@GetMapping("/alarm.do")
	public String alarmPage() {
	    if (!isAdmin()) return "redirect:/admin/login.do";
	    return "admin/admin-alarm";
	}
	 
	// 알람 발송 (전체/선택/개별)
	@PostMapping(value="/alarm/send.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String sendAlarm(@RequestParam HashMap<String,Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.sendAlarm(map));
	}
	 
	// 발송 내역 조회
	@PostMapping(value="/alarm/logs.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getAlarmLogs(@RequestParam HashMap<String,Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getAlarmLogs(map));
	}
	 
	// 회원 단건 조회 (개별 발송용 확인)
	@PostMapping(value="/member/find.dox", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String findMember(@RequestParam HashMap<String,Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.findMember(map));
	}
}