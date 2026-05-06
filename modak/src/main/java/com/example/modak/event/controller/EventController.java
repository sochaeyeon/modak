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

    @RequestMapping("/event/detail.do")
    public String eventDetailPage(HttpServletRequest request, Model model,
            @RequestParam HashMap<String, Object> map) throws Exception {

        Object eventId = map.get("eventId");

        // eventId 자체가 없으면 상세 페이지로 보내지 않고 목록으로 이동
        if (eventId == null || String.valueOf(eventId).isBlank()) {
            return "redirect:/event/list.do";
        }

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

    @RequestMapping(value = "/event/info.dox", method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String eventInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

        HashMap<String, Object> resultMap = eventService.getEventInfo(map);

        if (resultMap == null) {
            resultMap = new HashMap<>();
            resultMap.put("result", "fail");
            resultMap.put("message", "존재하지 않는 이벤트입니다.");
        }

        Object info = resultMap.get("info");

        if (info == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "존재하지 않는 이벤트입니다.");
        }

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
