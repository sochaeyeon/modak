package com.example.modak.csCenter.model;

import java.util.List;

import lombok.Data;

@Data
public class Inquiry {
	private int inquiryId;
	private String title;
	private String content;
	private String inquiryStatus;
	private String inquiryType;
	private String createdAt;
	private String updatedAt;
	private String userId;

	// 답변
	private int replyId;
	private String answer;
	private String replyCreatedAt;

	// 이미지
	private List<InquiryImg> imageList;
}