package com.example.modak.camp.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.camp.dao.CampService;
import com.google.gson.Gson;

@Controller
@RequestMapping("/camp")
public class CampController {
    @Autowired private CampService campService;

    @RequestMapping("/map.do")
    public String mapPage() { return "camp/camp_map"; }

    @RequestMapping("/list.dox")
    @ResponseBody
    public String getList(@RequestParam HashMap<String, Object> params) {
        return new Gson().toJson(campService.getCampList(params));
    }

    @RequestMapping("/reviewList.dox")
    @ResponseBody
    public String getReviewList(@RequestParam HashMap<String, Object> params) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("list", campService.getReviewList(params));
        return new Gson().toJson(map);
    }

    @RequestMapping("/sync.do")
    @ResponseBody
    public String sync() {
        try { campService.syncCampData(); return "success"; } catch (Exception e) { return e.getMessage(); }
    }
}