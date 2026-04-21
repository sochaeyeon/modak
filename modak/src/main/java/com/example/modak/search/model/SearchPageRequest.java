package com.example.modak.search.model;

import lombok.Data;

@Data
public class SearchPageRequest {

    private String keyword;
    private int page = 1;
    private int pageSize = 10;
    private int offset;
}