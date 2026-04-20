package com.example.modak.csCenter.model;

import lombok.Data;

// 규칙
// 카멜표기법 사용
@Data
public class Faq {

	int faqId;
	String question;
	String answer;
	String createdAt;
	String category;

}