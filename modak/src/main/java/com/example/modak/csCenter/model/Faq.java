package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class Faq {

	int faqId;
	String question;
	String answer;
	String createdAt;
	String category;

}