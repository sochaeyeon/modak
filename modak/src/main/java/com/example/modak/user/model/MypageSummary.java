package com.example.modak.user.model;

import lombok.Data;

@Data
public class MypageSummary {
    private int orderCount;
    private int pointAmount;
    private int couponCount;
    private int wishlistCount;
    private int expiringCouponCount;
}