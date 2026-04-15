package com.example.modak.event.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.def.dao.DefaultService;
import com.example.modak.event.dao.EventService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class EventController {

	@Autowired
	EventService eventService;

	@RequestMapping("/event/list.do")
	public String test(Model model) throws Exception {
		return "/event/event-list";
	}

	@RequestMapping("/event/detail.do")
	public String eventView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		System.out.println(map);
		request.setAttribute("map", map);
		return "/event/event-detail";
	}

	@RequestMapping(value = "/event/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String eventList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = eventService.getEventList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/event/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String eventInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = eventService.getEventInfo(map);
		return new Gson().toJson(resultMap);
	}

}
