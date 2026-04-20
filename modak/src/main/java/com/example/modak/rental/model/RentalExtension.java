package com.example.modak.rental.model;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class RentalExtension {

    // RENTAL_EXTENSION 테이블
    private Long      extensionId;
    private Integer   extensionDays;
    private int       price;
    private Timestamp createdAt;
    private Long      rentalId;

    // RENTALS 테이블
    private Long      itemId;
    private String    userId;
    private String    startDate;
    private String    returnDate;
    private String    rentalStatus;

    // 비회원 식별 (ALTER로 추가한 컬럼)
    private String    guestName;
    private String    guestPhone;

    // PRODUCT 조인
    private String    productName;
}
