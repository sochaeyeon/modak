package com.example.modak.search.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import lombok.Data;

@Data
public class IntegratedSearchResult {

    private String keyword;

    private List<SearchProduct> productList = new ArrayList<>();
    private List<SearchCamp> campList = new ArrayList<>();
    private List<SearchFaq> faqList = new ArrayList<>();
    private List<SearchEvent> eventList = new ArrayList<>();

    private int productCount;
    private int campCount;
    private int faqCount;
    private int eventCount;

    private boolean emptyKeyword;
    
    private List<HashMap<String, Object>> communityList;
    private int communityCount;
}