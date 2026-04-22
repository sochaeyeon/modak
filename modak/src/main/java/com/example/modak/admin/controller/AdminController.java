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

	/* 관리자 권한 체크 */
	private boolean isAdmin() {
		return Boolean.TRUE.equals(session.getAttribute("isAdmin"));
	}

	private String noAuth() {
		return new Gson().toJson(Map.of("result", "fail", "message", "관리자 권한이 필요합니다."));
	}

	/* =========================
	   관리자 인증
	========================= */

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

	/* =========================
	   페이지 라우팅
	========================= */

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

	/* =========================
	   API
	========================= */

	@PostMapping(value = "/dashboard.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDashboard() {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getDashboardData());
	}

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

	@PostMapping(value = "/product/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductList(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.getAdminProductList(map));
	}

	@PostMapping(value = "/product/insert.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String insertProduct(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.insertProduct(map));
	}

	@PostMapping(value = "/product/update.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProduct(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.updateProduct(map));
	}

	@PostMapping(value = "/product/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleProductAvail(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) return noAuth();
		return new Gson().toJson(adminService.toggleProductAvail(map));
	}

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