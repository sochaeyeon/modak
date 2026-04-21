package com.example.modak.csCenter.model;

import lombok.Data;

@Data
public class InquiryImg {
    private int inquiryImgId;
    private String imgUrl;
    private String createdAt;
    private int inquiryId;
}