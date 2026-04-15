package com.example.modak.user.model;

import lombok.Data;

@Data
public class SocialUserInfo {
    private String socialType;
    private String socialId;
    private String email;
    private String userName;
    private String nickName;
}