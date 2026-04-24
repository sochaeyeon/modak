package com.example.modak.membership.model;

import lombok.Data;

@Data
public class FAQ {

    private int faqId;          // ← PK
    private String question;
    private String answer;
    private String category;
    private String createdAt;   // ← 추가
}