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
}