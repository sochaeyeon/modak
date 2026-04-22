package com.example.modak.product.model;

import lombok.Data;

@Data
public class Stock {
	
    private int stockId; 
    private String stockDate; // 재고 기준일 (마지막으로 수정된 날짜) 
    private int totalQty; // 총 수량 - 구매시에만 감소!!
    private int reservedQty; // 예약 수량 - 대여시에만 증가 / 반납시 복구 
    private int availableQty; // 가용 수량 - 대여시에만 감소 / 반납시 복구
    private int optionId; 
    private int productId; 
    
}