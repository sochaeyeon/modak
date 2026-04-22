package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class Notification {
	int notificationId;
	String type;
	String title;
	String content;
	String createdAt;

	int viewCount; // 조회수 (DB에 컬럼 추가 시 사용)
	int isPinned; // 고정 공지 여부 (1: 고정, 0: 일반)
}