package com.example.modak.address.model;

import lombok.Data;

@Data
public class Address {
	private String addressId;
	private String addressAlias;
	private String address;
	private String zipCode;
	private String detailedAddress;
	private String defaultYn;
	private String userId;
	
}
