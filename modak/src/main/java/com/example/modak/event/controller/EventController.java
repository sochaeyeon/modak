package com.example.modak.event.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.event.dao.EventService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class EventController {

	@Autowired
	EventService eventService;

	/* ── 목록 페이지 이동 ─────────────────────────────── */
	@RequestMapping("/event/list.do")
	public String eventListPage(Model model) throws Exception {
		return "/event/event-list"; // → WEB-INF/views/event/event-list.jsp
	}

	/* ── 상세 페이지 이동 ─────────────────────────────── */
	@RequestMapping("/event/detail.do")
	public String eventDetailPage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println("detail param: " + map);
		request.setAttribute("map", map);
		return "/event/event-detail"; // → WEB-INF/views/event/event-detail.jsp
	}

	/*
	 * ── 목록 Ajax (JSON) ──────────────────────────────── POST /event/list.dox 요청: {
	 * tabType: 'ongoing'|'ended'|'winner', page: 1 } 응답: { result, message, list,
	 * totalCount, totalPages, currentPage }
	 * ───────────────────────────────────────────────────
	 */
	@RequestMapping(value = "/event/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String eventList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = eventService.getEventList(map);
		return new Gson().toJson(resultMap);
	}

	/*
	 * ── 상세 Ajax (JSON) ──────────────────────────────── POST /event/info.dox 요청: {
	 * eventId: 1 } 응답: { result, message, info }
	 * ───────────────────────────────────────────────────
	 */
	@RequestMapping(value = "/event/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String eventInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = eventService.getEventInfo(map);
		return new Gson().toJson(resultMap);
	}
}
