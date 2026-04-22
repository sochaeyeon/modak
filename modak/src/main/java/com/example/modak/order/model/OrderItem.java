package com.example.modak.order.model;

import lombok.Data;

@Data
public class OrderItem {
	private Long itemId;
    private Integer productId; // ✅ [추가] 상세보기 이동을 위해 반드시 필요!
    private String productName;
    private int price;
    private int count;
    private String orderType;
    private String startDate;
    private String endDate;
    private String imgUrl;
}