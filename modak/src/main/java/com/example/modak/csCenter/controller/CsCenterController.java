package com.example.modak.csCenter.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CsCenterController {

	@Autowired
	com.example.modak.csCenter.dao.csCenterService csCenterService;

	/*
	 * ───────────────────────────────────────── 고객센터 메인 페이지
	 * ─────────────────────────────────────────
	 */
	@RequestMapping("/cs/center.do")
	public String csCenterPage(Model model) throws Exception {
		return "/cs/cs-center";
	}

	/*
	 * ───────────────────────────────────────── 고객센터 Ajax 통합 API action: "faqList"
	 * → FAQ 목록 조회 action: "noticeList" → 공지사항 최근 N건 조회
	 * ─────────────────────────────────────────
	 */
	@RequestMapping(value = "/cs/center.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String csCenterAjax(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();
		String action = (String) map.getOrDefault("action", "");

		try {
			if ("faqList".equals(action)) {
				/*
				 * ── FAQ 목록 조회 ── params: category : 대분류 or 소분류 (빈 문자열이면 전체) searchKeyword :
				 * 검색어 (빈 문자열이면 전체)
				 */
				List<Map<String, Object>> faqList = csCenterService.getFaqList(map);
				resultMap.put("result", "success");
				resultMap.put("list", faqList);

			} else if ("notificationList".equals(action)) {
				/*
				 * ── 공지사항 최근 N건 조회 ── params: limit : 가져올 건수 (기본 4)
				 */
				int limit = 4;
				try {
					limit = Integer.parseInt(String.valueOf(map.getOrDefault("limit", "4")));
				} catch (NumberFormatException ignored) {
				}

				map.put("limit", limit);
				List<Map<String, Object>> notificationList = csCenterService.getNotificationList(map);
				resultMap.put("result", "success");
				resultMap.put("list", notificationList);

			} else {
				resultMap.put("result", "error");
				resultMap.put("message", "알 수 없는 action 값입니다: " + action);
			}
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", "서버 처리 중 오류가 발생했습니다.");
			e.printStackTrace();
		}

		return new Gson().toJson(resultMap);
	}
}
