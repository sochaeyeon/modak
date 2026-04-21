package com.example.modak.search.model;

import lombok.Data;

@Data
public class SearchCamp {
    private Long campId;
    private String campName;
    private String address;
    private String description;
    private String induty;
    private String thumbImgUrl;
}