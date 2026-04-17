package com.example.modak.order.model;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Order {

	private String orderId;
	private String orderType;
	private String orderStatus;
	private int totalPrice;
	private int discountAmt;
	private Timestamp createdAt;
	private String userId;
	private String userCouponId;
	
	// 조인
	private String productName;
	private Integer itemCount;
}
