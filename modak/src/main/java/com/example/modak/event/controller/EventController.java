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

    /* ── 목록 페이지 ── */
    @RequestMapping("/event/list.do")
    public String eventListPage(Model model) throws Exception {
        return "/event/event-list";
    }

    /* ── 상세 페이지 ── */
    @RequestMapping("/event/detail.do")
    public String eventDetailPage(HttpServletRequest request, Model model,
            @RequestParam HashMap<String, Object> map) throws Exception {
        System.out.println("detail param: " + map);
        request.setAttribute("map", map);
        return "/event/event-detail";
    }

    /* ── 목록 Ajax ── */
    @RequestMapping(value = "/event/list.dox", method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String eventList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = eventService.getEventList(map);
        return new Gson().toJson(resultMap);
    }

    /* ── 상세 Ajax ── */
    @RequestMapping(value = "/event/info.dox", method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String eventInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = eventService.getEventInfo(map);
        return new Gson().toJson(resultMap);
    }

    /* ────────────────────────────────────────────────────
       ★ 메인 배너용 최신 이벤트 5개 Ajax
       GET/POST /event/bannerList.dox
       응답: { result: "success", list: [ {eventId, title, content, startDate, endDate}, ... ] }
    ──────────────────────────────────────────────────── */
    @RequestMapping(value = "/event/bannerList.dox",
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String eventBannerList() throws Exception {
        HashMap<String, Object> resultMap = eventService.getBannerList();
        return new Gson().toJson(resultMap);
    }
}
