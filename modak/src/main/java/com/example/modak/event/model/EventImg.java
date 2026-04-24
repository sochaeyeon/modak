package com.example.modak.event.model;

import lombok.Data;

@Data
public class EventImg {
    private int eventImgId;
    private String imgUrl;
    private String isMain;
    private int sortOrder;
    private int eventId;
}