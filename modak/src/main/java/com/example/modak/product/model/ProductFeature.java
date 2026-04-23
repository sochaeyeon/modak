package com.example.modak.product.model;

import lombok.Data;

@Data
public class ProductFeature {
	
    private int featureId;
    private int productId;
    private String title; // ex) 초경량 설계
    private String content; // ex) 총 중량 1.38kg...
    private int sortOrder; // 노출순서
    
}