package com.example.modak.rental.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.rental.mapper.RentalCalendarMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/rental")
public class RentalCalendarController {

    @Autowired
    private RentalCalendarMapper calendarMapper;

    @GetMapping("/calendar.do")
    public String goCalendar() {
        return "rental/rental-calendar";
    }

    @PostMapping(value = "/calendar/dates.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRentedDates(@RequestBody HashMap<String, Object> params, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        // 세션 아이디 (로그인 안되어있으면 null일 수 있으니 주의닥!)
        String userId = (String) session.getAttribute("sessionId");
        params.put("userId", userId);

        try {
            List<HashMap<String, Object>> list = calendarMapper.selectRentedDates(params);
            HashMap<String, Object> priceInfo = calendarMapper.selectProductPrice(params);

            resultMap.put("result", "success");
            resultMap.put("rentedList", list);
            resultMap.put("priceInfo", priceInfo);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            e.printStackTrace(); // 에러나면 이클립스 콘솔에 찍힌다닥!
        }
        return new Gson().toJson(resultMap);
    }

    @PostMapping("/apply.dox")
    @ResponseBody
    public String applyRental(@RequestBody HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) session.getAttribute("sessionId");
        map.put("userId", userId);

        try {
            calendarMapper.insertRental(map);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "fail");
        }
        return new Gson().toJson(resultMap);
    }
}