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
	
	// ORDERS에 READY로 INSERT, ORDER_ID 반환
    public int insertTempOrder(HashMap<String, Object> map);      
    // 결제 성공 후 PAID로 UPDATE
    public int updateOrderStatus(HashMap<String, Object> map);    
    // PAYMENT 테이블 INSERT
    public int insertPayment(HashMap<String, Object> map);        

}
