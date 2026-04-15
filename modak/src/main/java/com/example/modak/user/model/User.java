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
}
