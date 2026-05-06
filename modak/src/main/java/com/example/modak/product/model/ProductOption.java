package com.example.modak.product.model;

import lombok.Data;

@Data
public class ProductOption {

    private int optionGroupId;
    private String optionName;

    private int optionValueId;
    private String optionValue;

    private int addPrice;
    private int productId;

  
}