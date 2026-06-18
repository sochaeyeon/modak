package com.example.modak.address.model;

import lombok.Data;

@Data
public class Address {
    private String addressId;
    private String addressAlias;
    private String address;
    private String zipCode;
    private String zipcode;       // (DB 컬럼명 소문자 대응)
    private String detailedAddress;
    private String defaultYn;
    private String userId;
    private String receiverName;  
    private String receiverPhone; 
}
