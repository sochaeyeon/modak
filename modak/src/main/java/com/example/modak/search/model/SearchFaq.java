package com.example.modak.search.model;

import lombok.Data;

@Data
public class SearchFaq {
    private Long faqId;
    private String question;
    private String answer;
    private String category;
}