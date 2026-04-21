package com.example.modak.user.model;

import lombok.Data;

@Data
public class PointHistory {
    private int historyId;
    private String userId;
    private String description;
    private int amount;
    private String type;
    private String createdAt;
    private int balanceAfter;
}