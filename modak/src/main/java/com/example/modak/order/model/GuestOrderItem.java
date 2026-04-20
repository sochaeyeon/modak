package com.example.modak.order.model;

import lombok.Data;

@Data
public class GuestOrderItem {
    private Long   itemId;
    private String orderId;
    private Long   productId;
    private String productName;
    private int    unitPrice;    // UNIT_PRICE
    private int    quantity;
    private String startDate;    // START_DATE (대여 시작일)
    private String endDate;      // END_DATE   (대여 종료일)
}
