package com.example.modak.order.model;

import lombok.Data;

@Data
public class OrderItem {
    private String productName;
    private int price;
    private int count;
    private String orderType;
    private String startDate;
    private String endDate;
}