package com.example.modak.delivery.model;

import lombok.Data;

@Data
public class DeliveryItem {
    private Long itemId;
    private Integer productId;
    private String productName;
    private Integer quantity;
    private Integer unitPrice;
    private String startDate;
    private String endDate;

    private String productType;
    private String imgUrl;
    private String brandName;
    private String categoryName;
}