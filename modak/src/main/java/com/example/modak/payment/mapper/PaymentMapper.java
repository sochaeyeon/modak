package com.example.modak.payment.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {
	
	// 배송지목록
	public List<HashMap<String, Object>> selectAddressList(HashMap<String, Object> map);
	// cart
	public List<HashMap<String, Object>> selectCheckoutItems(HashMap<String, Object> map);

}
