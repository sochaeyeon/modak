package com.example.modak.order.model;

import java.util.List;
import lombok.Data; // Lombok 사용 시

@Data // Getter, Setter 자동 생성
public class Order {
    private Long orderId;
    private String orderType;
    private String orderStatus;
    private int totalPrice;
    private int discountAmt;
    private String createdAt;
    private String userId;
    private Long userCouponId;

    // ✅ 이 필드가 반드시 있어야 합니다! 
    // MyBatis XML의 collection property="itemList"와 이름이 똑같아야 해요.
    private List<OrderItem> itemList; 
    
    // Lombok을 안 쓰신다면 아래와 같이 Getter/Setter를 만드세요.
    /*
    public List<OrderItem> getItemList() { return itemList; }
    public void setItemList(List<OrderItem> itemList) { this.itemList = itemList; }
    */
}