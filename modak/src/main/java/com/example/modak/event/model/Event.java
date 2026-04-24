package com.example.modak.event.model;

import java.util.List;
import lombok.Data;

@Data
public class Event {
    private int eventId;
    private String title;
    private String content;
    private String startDate;
    private String endDate;

    private String imgPath;
    private List<EventImg> imgList;
}