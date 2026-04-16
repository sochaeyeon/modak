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

}