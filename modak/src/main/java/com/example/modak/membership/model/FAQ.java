package com.example.modak.membership.model;

import lombok.Data;

@Data
public class FAQ {
	private String questionId;
	private String question;
	private String answer;
	private String category;
}
