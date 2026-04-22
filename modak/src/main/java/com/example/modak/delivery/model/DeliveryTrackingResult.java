package com.example.modak.delivery.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class DeliveryTrackingResult {
    private boolean success;
    private String carrierId;
    private String carrierName;
    private String trackingNumber;
    private String lastStatus;
    private String lastLocation;
    private String lastDescription;
    private String lastTime;
    private String errorMessage;
    private String trackingLinkUrl;

    private List<DeliveryTrackingEvent> eventList = new ArrayList<>();
}