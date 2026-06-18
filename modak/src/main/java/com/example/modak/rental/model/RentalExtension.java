package com.example.modak.rental.model;

import lombok.Data;

@Data
public class RentalExtension {

    /* ── RENTALS ── */
    private Long   rentalId;
    private Long   itemId;
    private String userId;
    private String startDate;
    private String returnDate;
    private String rentalStatus;
    private String guestName;
    private String guestPhone;
    private int    overdueFee; 

    /* ── PRODUCT 조인 ── */
    private String productName;
    private int    pricePerDay;
    private String imgUrl;         
    private int    rentalDays; 

    /* ── RENTAL_EXTENSION ── */
    private Long   extensionId;
    private int    extensionDays;
    private int    price;         // 연장 결제 금액
    private String createdAt;
    private String overduePaidAt;
    
    
}