package com.example.modak.refund.model;

import java.sql.Date;

import lombok.Data;

@Data
public class Refund {
	
	private int refundId;        // REFUND_ID
    private int amount;          // AMOUNT
    private int deductAmount;    // DEDUCT_AMOUNT

    private String reason;       // REASON
    private String refundStatus; // REFUND_STATUS

    private Date createdAt;      // CREATED_AT
    private Date refundedAt;     // REFUNDED_AT

    private int payId;           // PAY_ID
    private int orderId;         // ORDER_ID

    private String userId;       // USER_ID
    private String refundType;   // REFUND_TYPE
    
    private String productName;
    private String imgUrl;
    private int quantity;


}
