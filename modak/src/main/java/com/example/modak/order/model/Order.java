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

    // 배송 정보
    private String receiverName;
    private String receiverPhone;
    private String zipcode;
    private String deliveryAddr;
    private String deliveryDetailAddr;

    // 주문 상세용
    private List<OrderItem> itemList;
}