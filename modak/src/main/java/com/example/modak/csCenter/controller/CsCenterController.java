package com.example.modak.csCenter.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

@Controller
public class CsCenterController {

	@Autowired
	com.example.modak.csCenter.dao.csCenterService csCenterService;

	@RequestMapping("/cs/center.do")
	public String csCenterPage(Model model) throws Exception {
		return "/cs/cs-center";
	}

	@RequestMapping(value = "/cs/center.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String csCenterAjax(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<>();
		String action = (String) map.getOrDefault("action", "");

		try {
			if ("faqList".equals(action)) {

				// category 콤마 분리 처리
				String category = (String) map.get("category");
				if (category != null && category.contains(",")) {
					map.put("categoryList", Arrays.asList(category.split(",")));
					map.put("category", "");
				} else if (category != null && !category.isEmpty()) {
					map.put("categoryList", Arrays.asList(category));
				}

				// excludeCategory 처리 (기타용)
				String excludeCategory = (String) map.get("excludeCategory");
				if (excludeCategory != null && !excludeCategory.isEmpty()) {
					map.put("excludeList", Arrays.asList(excludeCategory.split(",")));
				}

				List<Map<String, Object>> faqList = csCenterService.getFaqList(map);
				resultMap.put("result", "success");
				resultMap.put("list", faqList);

			} else if ("notificationList".equals(action)) {

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
