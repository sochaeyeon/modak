package com.example.modak.csCenter.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.csCenter.dao.NotificationService;
import com.example.modak.csCenter.model.Notification;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class NotificationController {

	@Autowired
	NotificationService notificationService;

	// 공지사항 목록 페이지
	@RequestMapping("/notification/list.do")
	public String notificationList(Model model) throws Exception {
		return "/cs/notification-list";
	}

	/**
	 * 공지사항 목록 데이터 API (Ajax) 응답 JSON: - result : "success" / "fail" - pinnedList :
	 * 고정 공지 배열 (IS_PINNED=1, 항상 최상단) - list : 일반 공지 배열 (IS_PINNED=0, 페이징) -
	 * totalCount : 일반 공지 전체 건수
	 */
	@RequestMapping(value = "/notification/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		// startRow, pageSize 기본값 처리
		map.put("startRow", parseIntOrDefault(map.get("startRow"), 0));
		map.put("pageSize", parseIntOrDefault(map.get("pageSize"), 10));

		HashMap<String, Object> resultMap = notificationService.getNotificationList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/notification/detail.do")
	public String detailPage(@RequestParam(value = "notificationId", required = false) Long notificationId, Model model)
			throws Exception {
		if (notificationId == null) {
			return "redirect:/notification/list.do";
		}

		HashMap<String, Object> param = new HashMap<>();
		param.put("notificationId", notificationId);

		// 조회수 +1
		notificationService.incrementViewCount(param);

		// 본문 조회
		Notification noti = notificationService.selectOne(param);
		if (noti == null) {
			model.addAttribute("noti", null);
			return "/cs/notification-detail";
		}

		// 이전글 / 다음글
		Notification prevNoti = notificationService.selectPrev(param);
		Notification nextNoti = notificationService.selectNext(param);

		// type → 한글 레이블 변환
		model.addAttribute("noti", noti);
		model.addAttribute("prevNoti", prevNoti);
		model.addAttribute("nextNoti", nextNoti);
		model.addAttribute("typeLabel", getTypeLabel(noti.getType()));

		return "/cs/notification-detail";
	}

	
	/**
	 * 공지 고정 설정 API (Ajax) 요청 파라미터: notificationId
	 */
	@RequestMapping(value = "/notification/pin.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pinNotification(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = notificationService.pinNotification(map);
		return new Gson().toJson(resultMap);
	}

	/**
	 * 공지 고정 해제 API (Ajax) 요청 파라미터: notificationId
	 */
	@RequestMapping(value = "/notification/unpin.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String unpinNotification(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = notificationService.unpinNotification(map);
		return new Gson().toJson(resultMap);
	}

	// ── 내부 유틸 ──────────────────────────────────────
	private int parseIntOrDefault(Object val, int defaultVal) {
		if (val == null || val.toString().isEmpty())
			return defaultVal;
		try {
			return Integer.parseInt(val.toString());
		} catch (NumberFormatException e) {
			return defaultVal;
		}
	}

	/*
	 * ───────────────────────────────────────── 헬퍼: type → 한글 레이블
	 * ─────────────────────────────────────────
	 */
	private String getTypeLabel(String type) {
		if (type == null)
			return "공지";
		switch (type) {
		case "ORDER":
			return "서비스 소식";
		case "SYSTEM":
			return "사이트 점검";
		case "EVENT":
			return "이벤트";
		case "POLICY":
			return "정책 변경";
		case "RENTAL":
			return "서비스 소식";
		case "INQUIRY":
			return "고객문의";
		default:
			return "공지";
		}
	}
}
