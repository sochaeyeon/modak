package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class InquiryHistory {
    private int inquiryId;
    private String title;
    private String content;
    private String inquiryStatus;
    private String createdAt;
    private String updatedAt;
    private String userId;

    private Integer replyId;
    private String answer;
    private String replyCreatedAt;
}