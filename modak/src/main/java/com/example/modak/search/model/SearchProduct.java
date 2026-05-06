package com.example.modak.search.model;

import lombok.Data;

@Data
public class SearchProduct {
    private Long productId;
    private String productName;
    private String description;
    private Integer price;
    private String thumbImgUrl;
    private String categoryName;
    private String brandName;
    private Double ratingAvg;
    private Integer reviewCount;
}