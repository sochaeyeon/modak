package com.example.modak.order.model;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class GuestOrder {

    // ORDERS 테이블
    private String    orderId;
    private String    orderType;      // PURCHASE | RENTAL
    private String    orderStatus;    // PAID | READY | SHIPPING | DONE | CANCELLED
    private int       totalPrice;
    private int       discountAmt;
    private Timestamp createdAt;
    private String    userCouponId;

    // 비회원 식별 (ALTER로 추가한 컬럼)
    private String    guestName;
    private String    guestPhone;

    // DELIVERY 테이블 조인
    private Delivery  delivery;

    // ORDER_ITEM + PRODUCT 조인
    private List<GuestOrderItem> items;
    
    private Integer rentalId;
}
