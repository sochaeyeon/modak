package com.example.modak.search.model;

import java.util.ArrayList;
import java.util.List;
import lombok.Data;

@Data
public class SearchPageResult<T> {

    private String keyword;
    private int page;
    private int pageSize;
    private int totalCount;
    private int totalPage;
    private int offset;

    private List<T> list = new ArrayList<>();

    private boolean emptyKeyword;
}