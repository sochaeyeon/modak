package com.example.modak.admin.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.admin.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	private static final Gson gson = new Gson();
	private static final String LOGIN_REDIRECT = "redirect:/admin/login.do";
	private static final String PRODUCT_IMG_DIR = "/img/product/";

	@Autowired
	private AdminService adminService;

	@Autowired
	private HttpSession session;

	private boolean isAdmin() {
		return Boolean.TRUE.equals(session.getAttribute("isAdmin"));
	}

	private String toJson(Object obj) {
		return gson.toJson(obj);
	}

	private String noAuth() {
		return toJson(Map.of("result", "fail", "message", "관리자 권한이 필요합니다."));
	}

	private String page(String viewName) {
		return isAdmin() ? viewName : LOGIN_REDIRECT;
	}

	private String api(Supplier<?> action) {
		if (!isAdmin()) {
			return noAuth();
		}
		return toJson(action.get());
	}

	private String saveFile(MultipartFile file, String realPath) throws IOException {
		File dir = new File(realPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		String filename = "productImg_" + System.currentTimeMillis() + "_"
				+ file.getOriginalFilename().replaceAll("[^a-zA-Z0-9._-]", "");
		file.transferTo(new File(dir, filename));
		return PRODUCT_IMG_DIR + filename;
	}

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
		return toJson(loginResult);
	}

	@GetMapping("/logout.do")
	public String logout() {
		session.invalidate();
		return LOGIN_REDIRECT;
	}

	@GetMapping("/dashboard.do")
	public String dashboard() {
		return page("admin/admin-dashboard");
	}

	@GetMapping("/members.do")
	public String members() {
		return page("admin/admin-members");
	}

	@GetMapping("/products.do")
	public String products() {
		return page("admin/admin-products");
	}

	@GetMapping("/inquiry.do")
	public String inquiry() {
		return page("admin/admin-inquiry");
	}

	@GetMapping("/product-qna.do")
	public String productQna() {
		return page("admin/admin-product-qna");
	}

	@GetMapping("/reviews.do")
	public String reviews() {
		return page("admin/admin-reviews");
	}

	@GetMapping("/sales.do")
	public String sales() {
		return page("admin/admin-sales");
	}

	@GetMapping("/events.do")
	public String events() {
		return page("admin/admin-events");
	}

	@GetMapping("/stats.do")
	public String stats() {
		return page("admin/admin-stats");
	}

	@GetMapping("/orders.do")
	public String orders() {
		return page("admin/admin-orders");
	}

	@GetMapping("/coupons.do")
	public String coupons() {
		return page("admin/admin-coupons");
	}

	@GetMapping("/rentals.do")
	public String rentalsPage() {
		return page("admin/admin-rentals");
	}

	@GetMapping("/camps.do")
	public String campManagement() {
		return page("admin/admin-camps");
	}

	@GetMapping("/membership.do")
	public String membership() {
		return page("admin/admin-membership");
	}

	@GetMapping("/alarm.do")
	public String alarmPage() {
		return page("admin/admin-alarm");
	}

	@PostMapping(value = "/dashboard.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDashboard() {
		return api(() -> adminService.getDashboardData());
	}

	@PostMapping(value = "/stats/view-data.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductViewStats(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getProductViewStats(map));
	}

	@PostMapping(value = "/inquiry/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getInquiryList(map));
	}

	@PostMapping(value = "/inquiry/answer.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveInquiryAnswer(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.saveInquiryAnswer(map));
	}

	@PostMapping(value = "/inquiry/badge.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryBadge() {
		return api(() -> adminService.getInquiryBadge());
	}

	@PostMapping(value = "/member/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMemberList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getMemberList(map));
	}

	@PostMapping(value = "/member/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateMemberStatus(map));
	}

	@PostMapping(value = "/product/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getAdminProductList(map));
	}

	@PostMapping(value = "/product/insertFull.dox")
	@ResponseBody
	public String insertFullProduct(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.insertFullProduct(map));
	}

	@PostMapping(value = "/product/update.dox")
	@ResponseBody
	public String updateProduct(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateFullProduct(map));
	}

	@PostMapping(value = "/product/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeProduct(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeProduct(map));
	}

	@PostMapping(value = "/product/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleProductAvail(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.toggleProductAvail(map));
	}

	@PostMapping(value = "/product/stock/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductStockList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getProductStockList(map));
	}

	@PostMapping(value = "/product/stock/update.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateProductStock(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateProductStock(map));
	}

	@PostMapping(value = "/product/stock/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addProductStock(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.addProductStock(map));
	}

	@PostMapping(value = "/product/upload-img.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadProductImg(@RequestParam("file") MultipartFile file,
			@RequestParam(value = "type", defaultValue = "main") String type,
			HttpServletRequest request) {
		if (!isAdmin()) {
			return noAuth();
		}
		try {
			String realPath = request.getServletContext().getRealPath(PRODUCT_IMG_DIR);
			String imgUrl = saveFile(file, realPath);
			return toJson(Map.of("result", "success", "imgUrl", imgUrl));
		} catch (Exception e) {
			logger.error("상품 이미지 업로드 실패", e);
			return toJson(Map.of("result", "fail", "message", e.getMessage()));
		}
	}

	@PostMapping(value = "/product/upload-detail-imgs.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadDetailImgs(@RequestParam("files") List<MultipartFile> files,
			@RequestParam("productId") String productId,
			HttpServletRequest request) {
		if (!isAdmin()) {
			return noAuth();
		}
		try {
			String realPath = request.getServletContext().getRealPath(PRODUCT_IMG_DIR);
			for (MultipartFile file : files) {
				String imgUrl = saveFile(file, realPath);
				HashMap<String, Object> param = new HashMap<>();
				param.put("productId", productId);
				param.put("imgUrl", imgUrl);
				adminService.insertDetailImage(param);
			}
			return toJson(Map.of("result", "success"));
		} catch (Exception e) {
			logger.error("상세 이미지 업로드 실패", e);
			return toJson(Map.of("result", "fail", "message", e.getMessage()));
		}
	}

	@PostMapping(value = "/product/detail-images.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDetailImages(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getDetailImages(map));
	}

	@PostMapping(value = "/product/detail-image/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeDetailImage(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeDetailImage(map));
	}

	@PostMapping(value = "/product/option/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOptionList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getOptionList(map));
	}

	@PostMapping(value = "/product/option/group/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOptionGroup(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.addOptionGroup(map));
	}

	@PostMapping(value = "/product/option/group/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeOptionGroup(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeOptionGroup(map));
	}

	@PostMapping(value = "/product/option/value/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOptionValue(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.addOptionValue(map));
	}

	@PostMapping(value = "/product/option/value/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeOptionValue(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeOptionValue(map));
	}

	@PostMapping(value = "/product/option/item/avail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateOptionItemAvail(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateOptionItemAvail(map));
	}

	@PostMapping(value = "/brand/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBrandList() {
		return api(() -> adminService.getBrandList());
	}

	@PostMapping("/review/list.dox")
	@ResponseBody
	public String getReviewList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getReviewList(map));
	}

	@PostMapping("/review/remove.dox")
	@ResponseBody
	public String removeReview(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeReview(map));
	}

	@PostMapping(value = "/sales/data.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSalesData(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getSalesData(map));
	}

	@PostMapping(value = "/event/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getEventList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getEventList(map));
	}

	@PostMapping(value = "/event/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveEvent(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.saveEvent(map));
	}

	@PostMapping(value = "/event/delete.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteEvent(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.deleteEvent(map));
	}

	@PostMapping(value = "/order/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOrderList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getAdminOrderList(map));
	}

	@PostMapping(value = "/order/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateOrderStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateOrderStatus(map));
	}

	@PostMapping("/order/cancel-approve.dox")
	@ResponseBody
	public String approveCancel(@RequestParam String orderId) {
		return api(() -> adminService.approveCancel(orderId));
	}

	@PostMapping(value = "/rental/return/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReturnRequestList() {
		return api(() -> adminService.getReturnRequestList());
	}

	@PostMapping(value = "/rental/return/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateReturnRequestStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateReturnRequestStatus(map));
	}

	@PostMapping(value = "/rental/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRentalList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getAdminRentalList(map));
	}

	@PostMapping(value = "/rental/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRentalStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateRentalStatus(map));
	}

	@PostMapping(value = "/rental/update-date.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRentalDate(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateRentalDate(map));
	}

	@PostMapping(value = "/camp/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCampList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getCampList(map));
	}

	@PostMapping(value = "/camp/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateCampStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateCampStatus(map));
	}

	@PostMapping(value = "/camp/detail.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCampDetail(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getCampDetail(map));
	}

	@PostMapping(value = "/camp/edit.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editCamp(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.editCamp(map));
	}

	@PostMapping(value = "/camp/remove.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeCamp(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeCamp(map));
	}

	@PostMapping(value = "/camp/add.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCamp(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.addCamp(map));
	}

	@PostMapping(value = "/coupon/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCouponList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getCouponList(map));
	}

	@PostMapping(value = "/coupon/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveCoupon(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.saveCoupon(map));
	}

	@PostMapping(value = "/coupon/status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String modifyCouponStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.modifyCouponStatus(map));
	}

	@PostMapping(value = "/coupon/delete.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeCoupon(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeCoupon(map));
	}

	@PostMapping(value = "/userCoupon/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getUserCouponList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getUserCouponList(map));
	}

	@PostMapping(value = "/userCoupon/give.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String giveCouponToUser(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.giveCouponToUser(map));
	}

	@PostMapping(value = "/userCoupon/giveAll.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String giveCouponToAll(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.giveCouponToAll(map));
	}

	@PostMapping("/userCoupon/delete.dox")
	@ResponseBody
	public String removeUserCoupon(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.removeUserCoupon(map));
	}

	@PostMapping(value = "/userCoupon/updateStatus.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String modifyUserCouponStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.modifyUserCouponStatus(map));
	}

	@PostMapping(value = "/grade/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getGradeList() {
		return api(() -> adminService.getGradeList());
	}

	@PostMapping(value = "/grade/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveGrade(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.saveGrade(map));
	}

	@PostMapping(value = "/member/grade.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberGrade(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateMemberGrade(map));
	}

	@PostMapping(value = "/alarm/send.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendAlarm(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.sendAlarm(map));
	}

	@PostMapping(value = "/alarm/logs.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAlarmLogs(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getAlarmLogs(map));
	}

	@PostMapping(value = "/member/find.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findMember(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.findMember(map));
	}

	@PostMapping(value = "/delivery/register.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String registerDelivery(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.registerDelivery(map));
	}

	@PostMapping(value = "/delivery/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDeliveryList(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.getDeliveryList(map));
	}

	@PostMapping(value = "/inspection/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInspectionList() {
		return api(() -> adminService.getInspectionList());
	}

	@PostMapping(value = "/inspection/save.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String saveInspection(@RequestParam HashMap<String, Object> map) {
		if (!isAdmin()) {
			return noAuth();
		}
		map.put("adminId", session.getAttribute("sessionId"));
		return toJson(adminService.saveInspection(map));
	}

	@PostMapping(value = "/refund/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRefundList() {
		return api(() -> adminService.getRefundList());
	}

	@PostMapping(value = "/exchange/list.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getExchangeList() {
		return api(() -> adminService.getExchangeList());
	}

	@PostMapping(value = "/exchange/update-status.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateExchangeStatus(@RequestParam HashMap<String, Object> map) {
		return api(() -> adminService.updateExchangeStatus(map));
	}

	@PostMapping("/refund/update-status.dox")
	@ResponseBody
	public String updateRefundStatus(@RequestParam("refundId") int refundId,
			@RequestParam("status") String status) {
		if (!isAdmin()) {
			return noAuth();
		}
		try {
			HashMap<String, Object> map = new HashMap<>();
			map.put("refundId", refundId);
			map.put("status", status);
			adminService.updateRefundStatus(map);
			return toJson(Map.of("result", "success"));
		} catch (Exception e) {
			logger.error("환불 상태 변경 실패", e);
			return toJson(Map.of("result", "fail", "message", "환불 상태 변경 실패"));
		}
	}
}