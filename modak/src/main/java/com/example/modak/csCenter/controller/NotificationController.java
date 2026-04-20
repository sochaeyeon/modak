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

	// 파라미터 없을 때
	@RequestMapping("/notification/list.do")
	public String notificationList(Model model) throws Exception {
		return "/cs/notification-list";
	}

	@RequestMapping("/notification/detail.do")
	public String notificationDetail(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map);
		request.setAttribute("map", map);
		return "/cs/notification-detail";
	}

	@RequestMapping(value = "/notification/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = notificationService.getNotificationList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/notification/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = notificationService.getNotificationInfo(map);
		return new Gson().toJson(resultMap);
	}
}
