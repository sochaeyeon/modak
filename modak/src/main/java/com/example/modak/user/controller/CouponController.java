package com.example.modak.user.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.user.dao.CouponService;
import com.example.modak.user.model.UserCoupon;

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
    @PostMapping("/availableList.dox")
    public HashMap<String, Object> availableList(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            resultMap.put("result", "success");
            resultMap.put("list", new ArrayList<>());
            return resultMap;
        }

        resultMap.put("result", "success");
        resultMap.put("list", couponService.selectAvailableCouponList(userId));

        return resultMap;
    }
    
    // ↓ 추가
    @PostMapping("/bestCoupon.dox")
    public HashMap<String, Object> bestCoupon(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            resultMap.put("isLogin", false);
            resultMap.put("coupon", null);
            return resultMap;
        }

        UserCoupon best = couponService.selectBestCoupon(userId);

        resultMap.put("isLogin", true);
        resultMap.put("coupon", best); // 쿠폰 없으면 null
        return resultMap;
    }
}