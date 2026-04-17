package com.example.modak.user.model;

import lombok.Data;

@Data
public class Coupon {
    private Long couponId;
    private String couponName;
    private String couponType;
    private int discountAmt;
    private int discountRate;
    private int minOrderAmt;
    private int maxDiscountAmt;
    private String issueTarget;
    private String isActive;
}