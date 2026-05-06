package com.example.modak.user.model;

import lombok.Data;
@Data
public class UserCoupon {

    private Long userCouponId;
    private String userId;
    private Long couponId;

    private String issuedAt;
    private String expiredAt;
    private String usedYn;
    private String usedAt;
    private Long orderId;
    private String status;
    private String createdAt;
    private String updatedAt;

    private String couponName;
    private String couponType;
    private int discountAmt;
    private int discountRate;
    private int minOrderAmt;
    private int maxDiscountAmt;
    private String issueTarget;
}