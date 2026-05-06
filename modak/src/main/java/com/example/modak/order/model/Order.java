package com.example.modak.order.model;

import java.util.List;
import lombok.Data;

@Data
public class Order {
    private Long orderId;
    private String orderType;
    private String orderStatus;
    private int totalPrice;
    private int discountAmt;
    private String createdAt;
    private String userId;
    private Long userCouponId;

    // 최근 주문내역용 대표 상품 정보
    private String productName;
    private int itemCount;
    private String imgUrl;

    // 배송 정보
    private String receiverName;
    private String receiverPhone;
    private String zipcode;
    private String deliveryAddr;
    private String deliveryDetailAddr;

    // 주문 상세용
    private List<OrderItem> itemList;
    private Long itemId;
    private String payMethod; // 쿼리의 PAY_METHOD (PAY_TYPE 데이터)
    private String payDate;
    private String easyPayProvider;
    
    // 배송
    private Integer deliveryId;
    private String deliveryStatus;
    private String trackingNo;
    
    private Integer usePoint;
}