package com.example.modak.order.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.order.model.Order;

@Mapper
public interface OrderMapper {
	
	 // 주문 목록 조회
    List<Order> selectOrderList(@Param("userId") String userId);

    // 주문 상세 조회
    Order selectOrderDetail(@Param("orderId") Long orderId, @Param("userId") String userId);

}