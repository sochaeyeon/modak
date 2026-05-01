package com.example.modak.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;

import com.example.modak.admin.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
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
	@PostMapping(value = "/product/upload-img.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadProductImg(@RequestParam("file") MultipartFile file,
	                                @RequestParam(value="type", defaultValue="main") String type,
	                                HttpServletRequest request) {
	    if (!isAdmin()) return noAuth();
	    try {
	        // ★ 프로젝트 static/img/product/ 경로에 저장
	        String realPath = request.getServletContext().getRealPath("/img/product/");
	        File dir = new File(realPath);
	        if (!dir.exists()) dir.mkdirs();

	        String originalName = file.getOriginalFilename();
	        String filename = "productImg_" + System.currentTimeMillis() + "_" 
	                        + originalName.replaceAll("[^a-zA-Z0-9._-]", "");
	        
	        File saveFile = new File(dir, filename);
	        file.transferTo(saveFile);

	        String imgUrl = "/img/product/" + filename;
	        return new Gson().toJson(Map.of("result", "success", "imgUrl", imgUrl));

	    } catch (Exception e) {
	        e.printStackTrace();
	        return new Gson().toJson(Map.of("result", "fail", "message", e.getMessage()));
	    }
	}
	 
	// ── 상세 이미지 복수 업로드 ──
	@PostMapping(value = "/product/upload-detail-imgs.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadDetailImgs(@RequestParam("files") List<MultipartFile> files,
	                                @RequestParam("productId") String productId,
	                                HttpServletRequest request) {
	    if (!isAdmin()) return noAuth();
	    try {
	        String realPath = request.getServletContext().getRealPath("/img/product/");
	        File dir = new File(realPath);
	        if (!dir.exists()) dir.mkdirs();

	        for (MultipartFile file : files) {
	            String filename = "productImg_" + System.currentTimeMillis() + "_" 
	                            + file.getOriginalFilename().replaceAll("[^a-zA-Z0-9._-]", "");
	            file.transferTo(new File(dir, filename));

	            HashMap<String, Object> param = new HashMap<>();
	            param.put("productId", productId);
	            param.put("imgUrl", "/img/product/" + filename);
	            adminService.insertDetailImage(param);
	        }
	        return new Gson().toJson(Map.of("result", "success"));

	    } catch (Exception e) {
	        e.printStackTrace();
	        return new Gson().toJson(Map.of("result", "fail", "message", e.getMessage()));
	    }
	}
	 
	// ── 상세 이미지 목록 조회 ──
	@PostMapping(value = "/product/detail-images.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDetailImages(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getDetailImages(map));
	}
	
	 
	// ── 상세 이미지 삭제 ──
	@PostMapping(value = "/product/detail-image/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeDetailImage(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeDetailImage(map));
	}
	 
	// ── 옵션 목록 조회 ──
	@PostMapping(value = "/product/option/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOptionList(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getOptionList(map));
	}
	 
	// ── 옵션 그룹 추가 ──
	@PostMapping(value = "/product/option/group/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOptionGroup(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.addOptionGroup(map));
	}
	 
	// ── 옵션 그룹 삭제 ──
	@PostMapping(value = "/product/option/group/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeOptionGroup(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeOptionGroup(map));
	}
	 
	// ── 옵션 값 추가 ──
	@PostMapping(value = "/product/option/value/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOptionValue(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.addOptionValue(map));
	}
	 
	// ── 옵션 값 삭제 ──
	@PostMapping(value = "/product/option/value/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeOptionValue(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.removeOptionValue(map));
	}
	 
	// ── 옵션 아이템 판매상태 변경 ──
	@PostMapping(value = "/product/option/item/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateOptionItemAvail(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateOptionItemAvail(map));
	}
	@PostMapping(value = "/brand/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBrandList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getBrandList());
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
//	비회원 주문취소요청
	@PostMapping("/order/cancel-approve.dox")
	@ResponseBody
	public Map<String, Object> approveCancel(@RequestParam String orderId) {
	    if (!isAdmin()) return Map.of("result","fail","message","권한없음");
	    return adminService.approveCancel(orderId);
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
	// AdminController.java 추가
	@PostMapping(value = "/delivery/register.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String registerDelivery(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.registerDelivery(map));
	}

	@PostMapping(value = "/delivery/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDeliveryList(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getDeliveryList(map));
	}
	
	@PostMapping(value = "/inspection/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInspectionList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getInspectionList());
	}

	@PostMapping(value = "/inspection/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveInspection(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    String adminId = (String) session.getAttribute("sessionId");
	    map.put("adminId", adminId);
	    return new Gson().toJson(adminService.saveInspection(map));
	}

	@PostMapping(value = "/refund/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRefundList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getRefundList());
	}

	@PostMapping(value = "/exchange/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getExchangeList() {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.getExchangeList());
	}

	@PostMapping(value = "/exchange/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateExchangeStatus(@RequestParam HashMap<String, Object> map) {
	    if (!isAdmin()) return noAuth();
	    return new Gson().toJson(adminService.updateExchangeStatus(map));
	}
	@RequestMapping("/refund/update-status.dox")
	@ResponseBody
	public Map<String, Object> updateRefundStatus(
	        @RequestParam("refundId") int refundId,
	        @RequestParam("status") String status) {

	    Map<String, Object> result = new HashMap<>();

	    try {
	        Map<String, Object> map = new HashMap<>();
	        map.put("refundId", refundId);
	        map.put("status", status);

	        adminService.updateRefundStatus(map);

	        result.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", "환불 상태 변경 실패");
	    }

	    return result;
	}
}