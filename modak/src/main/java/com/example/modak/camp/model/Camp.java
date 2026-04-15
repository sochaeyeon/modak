package com.example.modak.camp.model;

import lombok.Data;

@Data
public class Camp {
    
    private String contentId;      // 콘텐츠 ID
    private String facltNm;        // 캠핑장명
    private String addr1;          // 주소
    private String mapX;           // 경도 (Longitude)
    private String mapY;           // 위도 (Latitude)
    private String firstImageUrl;  // 이미지
    private String tel;            // 전화번호
    private String lineIntro;      // 한줄소개
}