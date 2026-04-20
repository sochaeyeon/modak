package com.example.modak.user.model;

import lombok.Data;

@Data
public class PhoneVerification {
    private Long verificationId;
    private String userId;
    private String phone;
    private String verifyCode;
    private String verifiedYn;
    private String expireAt;
    private String verifiedAt;
    private String createdAt;
}