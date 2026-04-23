package com.example.modak.product.model;

import lombok.Data;

@Data
public class ProductOption {
	
    private int optionId;
    private String optionName;   // ex) 색상, 사이즈
    private String optionValue;  // ex) 샌드베이지, 롱형
    private int addPrice;        // 추가금액
    private int productId;
    
}
