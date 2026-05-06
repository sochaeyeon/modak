package com.example.modak.order.model;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Delivery {
    private Long      deliveryId;
    private String    deliveryStatus;  // READY | SHIPPING | DONE
    private String    trackingNo;
    private Timestamp shippedAt;
    private Timestamp deliveredAt;
    private Timestamp pickedUpAt;
    private String    receiverName;
    private String    address;
    private String    orderId;
}
