package com.example.modak.order.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.order.model.Order;

@Mapper
public interface OrderMapper {
	
	 // 주문 목록 조회
    List<Order> selectOrderList(@Param("userId") String userId);

    // 주문 상세 조회
    Order selectOrderDetail(@Param("orderId") Long orderId, @Param("userId") String userId);
    
 
 // 주문 상태 변경 (CANCELLED 등)
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);
    
    int insertOrderCancel(Map<String, Object> map);
    
    Integer selectDeliveryIdByOrderId(Integer orderId);
 // selectGuestOrderListByPhone — xml에 쿼리 이미 있으니 인터페이스만 추가
    List<Map<String, Object>> selectGuestOrderListByPhone(HashMap<String, Object> map);
}