package com.example.modak.alarm.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.alarm.dao.AlarmService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/alarm")
public class AlarmController {

	@Autowired
	private AlarmService alarmService;

	@Autowired
	private HttpSession session;

	/**
	 * 1. 알림 목록 페이지 이동 URL: /alarm/notice-list.do
	 */
	@RequestMapping("/notice-list.do")
	public String noticeList() {
		// WEB-INF/alarm/notice-list.jsp 파일을 찾아갑니다.
		return "alarm/notice-list";
	}

	@RequestMapping("/notice-detail.do")
	public String noticeDetail(@RequestParam("alarmId") int alarmId) {
	    Map<String, Object> alarm = alarmService.getAlarmInfo(alarmId);

	    if (alarm != null) {
	        alarmService.updateAlarmRead(alarmId);

	        String type = (String) alarm.get("TYPE");
	        Object linkId = alarm.get("LINK_ID");

	        if ("DELIVERY".equals(type)) {
	            return "redirect:/order/detail.do?orderId=" + linkId;
	        }

	        if ("EVENT".equals(type)) {
	            return "redirect:/event/detail.do?eventId=" + linkId;
	        }

	        if ("OVERDUE".equals(type)) {
	            return "redirect:/rental/extension/main.do?rentalId=" + linkId;
	        }
	    }

	    return "redirect:/alarm/notice-list.do";
	}

	/**
	 * 3. AJAX: 최근 알림 목록 가져오기 (헤더 및 리스트용)
	 */
	@RequestMapping("/getAlarmList.dox")
	@ResponseBody
	public HashMap<String, Object> getAlarmList() {
		String userId = (String) session.getAttribute("sessionId");
		// AlarmService의 반환 타입에 맞춰 HashMap으로 리턴
		return alarmService.getAlarmList(userId);
	}

	/**
	 * 4. AJAX: 안 읽은 알림 개수 (헤더 오렌지 점 표시용)
	 */
	@RequestMapping("/alarmCount.dox")
	@ResponseBody
	public HashMap<String, Object> alarmCount() {
		HashMap<String, Object> resultMap = new HashMap<>();
		String userId = (String) session.getAttribute("sessionId");

		int count = 0;
		if (userId != null) {
			count = alarmService.getUnreadAlarmCount(userId);
		}

		resultMap.put("count", count);
		resultMap.put("result", "success");
		return resultMap;
	}

	@RequestMapping("/removeAlarm.dox")
	@ResponseBody
	public HashMap<String, Object> removeAlarm(@RequestParam("alarmId") int alarmId) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			alarmService.removeAlarm(alarmId);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	/**
	 * 6. 알림 전체 삭제 URL: /alarm/removeAllAlarms.dox
	 */
	@RequestMapping("/removeAllAlarms.dox")
	@ResponseBody
	public HashMap<String, Object> removeAllAlarms() {
		HashMap<String, Object> resultMap = new HashMap<>();
		String userId = (String) session.getAttribute("sessionId");
		try {
			if (userId != null) {
				alarmService.removeAllAlarms(userId);
				resultMap.put("result", "success");
			}
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	@PostMapping(value = "/read.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String readAlarm(@RequestParam int alarmId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			alarmService.updateAlarmRead(alarmId);
			result.put("result", "success");
		} catch (Exception e) {
			result.put("result", "fail");
		}
		return new Gson().toJson(result);
	}
}