package com.example.modak.cart.model;

import lombok.Data;

@Data
public class Cart {
	
	private int cartId; // 장바구니id
	private int quantity; // 수량
	private String cartType; // 타입구분 구매,대여
	private String createdAt; // 등록일시
	
	private String rentalStart;      
    private String rentalEnd;        
	
	private String userId; // 회원 id
	private int productId; // 상품 id
	private int optionId; // 옵션 id
	
	private String productName;
    private int price;
    private String imgUrl;
    private String brandName;    
    private String categoryName;  
    private int stock;           
    private String optionName;

}
