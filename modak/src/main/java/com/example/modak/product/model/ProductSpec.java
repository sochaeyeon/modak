package com.example.modak.product.model;

import lombok.Data;

@Data
public class ProductSpec {
	
    private int specId;
    private int productId;
    private String capacity;   // 수용 인원
    private String size;       // 전개 사이즈
    private String weight;     // 총 중량
    private String material;   // 소재
    private String origin;     // 원산지
    
}