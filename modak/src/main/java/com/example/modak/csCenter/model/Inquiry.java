package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class Inquiry {
	int inquiryId;
	String title;
	String content;
	String inquiryStatus;
	String createdAt;
	String updatedAt;
	int userId;
}