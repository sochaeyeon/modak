package com.example.modak.delivery.model;

import lombok.Data;

@Data
public class DeliveryTrackingEvent {
    private String time;
    private String status;
    private String location;
    private String description;
}