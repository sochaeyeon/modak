package com.example.modak.event.model;

import lombok.Data;

// 규칙
// 카멜표기법 사용
@Data
public class Event {

	int eventId;
	String title;
	String content;
	String startDate;
	String endDate;

}