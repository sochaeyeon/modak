package com.example.modak.user.model;

import lombok.Data;

@Data
public class SmsAuth {
    private Long authId;
    private String userPhone;
    private String authCode;
    private String authType;
    private String verifyYn;
    private String expireAt;
    private String verifiedAt;
    private String createdAt;
}