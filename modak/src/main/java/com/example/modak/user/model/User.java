package com.example.modak.user.model;

import lombok.Data;

@Data
public class User {
	private String userId;
	private String userPwd;
	private String userName;
	private String userPhone;
	private String email;
	private String nickName;
	private String userSatus;
	private String updatedAt;
	private String createdAt;
	private String gradeId;
	private String socialType;
	private String socialId;
	private String userStatus;

	private String gradeName;

	// 휴대폰 인증 관련
	private String phoneVerifyYn;
	private String phoneVerifiedAt;
	// 프로필 이미지 URL
	private String profileImgUrl;
}