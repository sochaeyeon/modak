package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class Notification {
	int notificationId;
	String type;
	String title;
	String content;
	String createdAt;
}