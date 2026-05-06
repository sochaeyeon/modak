package com.example.modak.membership.model;

import lombok.Data;

@Data
public class MembershipInfo {

    // USER
    private String userId;
    private String userName;
    private String nickName;
    private int totalAmount;
    private int point;

    // GRADE
    private int gradeId;
    private String gradeName;
    private int minAmount;
    private int discountRate;
    private String description;
    
    // [추가] DB의 BENEFIT_TEXT 컬럼과 매핑될 변수
    private String benefitText; 

}