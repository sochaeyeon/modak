package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class Notification {

	String type;
	String title;
	String content;
	String createdAt;

	int viewCount; // 조회수 (DB에 컬럼 추가 시 사용)
	int isPinned; // 고정 공지 여부 (1: 고정, 0: 일반)
	int isDeleted;

	Long notificationId; // int를 Long으로 변경

	public Long getNotificationId() {
		return notificationId;
	}

	public void setNotificationId(Long notificationId) {
		this.notificationId = notificationId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public Integer getViewCount() {
		return viewCount;
	}

	public void setViewCount(Integer viewCount) {
		this.viewCount = viewCount;
	}

	public Integer getIsPinned() {
		return isPinned;
	}

	public void setIsPinned(Integer isPinned) {
		this.isPinned = isPinned;
	}

	public Integer getIsDeleted() {
		return isDeleted;
	}

	public void setIsDeleted(Integer isDeleted) {
		this.isDeleted = isDeleted;
	}
}