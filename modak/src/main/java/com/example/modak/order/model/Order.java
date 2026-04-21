package com.example.modak.order.model;

import java.util.List;
import lombok.Data;

@Data // Getter, Setter, ToString 등을 자동으로 생성해줍니다.
public class Order {
    private Long orderId;
    private String orderType;
    private String orderStatus;
    private int totalPrice;
    private int discountAmt;
    private String createdAt;
    private String userId;
    private Long userCouponId;

    // ✅ MyBatis 에러 해결을 위해 추가해야 하는 배송 정보 필드
    // XML의 <result property="..." column="..."> 이름과 일치해야 합니다.
    private String receiverName;    // 받는분 (홍길동)
    private String receiverPhone;   // 연락처
    private String zipcode;         // 우편번호
    private String deliveryAddr;    // 주소
    private String deliveryDetailAddr; // 상세주소

    // ✅ 상품 리스트 매핑
    private List<OrderItem> itemList; 
    
    private String payMethod; // 쿼리의 PAY_METHOD (PAY_TYPE 데이터)
    private String payDate;
}