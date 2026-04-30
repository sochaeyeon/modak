package com.example.modak.delivery.model;

import java.util.List;

import lombok.Data;

@Data
public class DeliveryDetail {

    private Integer deliveryId;
    private String deliveryStatus;
    private String trackingNo;
    private String carrierId;
    private String shippedAt;
    private String deliveredAt;
    private String pickedUpAt;
    private String receiverName;
    private String address;
    private Long orderId;
    //...
    private String orderType;
    private String orderStatus;
    private String createdAt;
    private String userId;
    private String guestName;
    private String guestPhone;
    private String zipcode;
    private String detailedAddress;
    
    // 화면용 내부 상태
    private String statusLabel;
    private String statusMessage;
    private int stepNo;
    private int progressPercent;
    private boolean returnFlow;
    private String orderTypeLabel;
    private String orderStatusLabel;
    private String carrierName;
    private String displayAddress;
    private String deliveredAtLabel;

    // 주문 상품 목록
    private List<DeliveryItem> itemList;

    // 외부 배송추적 결과
    private DeliveryTrackingResult trackingResult;
}