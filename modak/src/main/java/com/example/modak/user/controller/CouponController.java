package com.example.modak.user.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.user.dao.CouponService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/coupon")
public class CouponController {

    @Autowired
    CouponService couponService;

    @PostMapping("/myCouponList.dox")
    public HashMap<String, Object> myCouponList(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            resultMap.put("result", "success");
            resultMap.put("list", new ArrayList<>());
            return resultMap;
        }

        resultMap.put("result", "success");
        resultMap.put("list", couponService.selectMyCouponList(userId));

        return resultMap;
    }
}