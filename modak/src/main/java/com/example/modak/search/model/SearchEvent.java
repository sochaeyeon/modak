package com.example.modak.search.model;

import lombok.Data;

@Data
public class SearchEvent {
    private Long eventId;
    private String title;
    private String content;
    private String startAt;
    private String endAt;
    private String thumbImgUrl;
}