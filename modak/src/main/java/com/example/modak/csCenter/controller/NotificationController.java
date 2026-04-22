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

	// 공지사항 상세 페이지
	@RequestMapping("/notification/detail.do")
	public String notificationDetail(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map);
		request.setAttribute("map", map);
		return "/cs/notification-detail";
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

	/**
	 * 공지사항 단건 조회 API (Ajax) 요청 파라미터: notificationId
	 */
	@RequestMapping(value = "/notification/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = notificationService.getNotificationInfo(map);
		return new Gson().toJson(resultMap);
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
}
