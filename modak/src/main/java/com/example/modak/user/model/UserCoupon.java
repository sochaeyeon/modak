package com.example.modak.user.model;

import lombok.Data;

@Data
public class UserCoupon {

    private int userCouponId;
    private String userId;
    private int couponId;

    private String issuedAt;
    private String expiredAt;
    private String usedYn;
    private String usedAt;
    private String orderId;
    private String status;
    private String createdAt;
    private String updatedAt;

    // COUPON 테이블 조인용
    private String couponName;
    private String discountType;
    private int discountValue;
}