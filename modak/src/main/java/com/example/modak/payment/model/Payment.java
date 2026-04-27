package com.example.modak.payment.model;

import java.time.LocalDateTime;

import lombok.Data;
@Data
public class Payment {

    private Long payId; // PAY_ID
    private Long orderId; // ORDER_ID
    private Long amount; // AMOUNT
    private String payStatus; // PAY_STATUS
    private LocalDateTime paidAt; // PAID_AT
    private Long orderId2;

}