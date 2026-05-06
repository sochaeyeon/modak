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
    
    // 취소 시 재고 복원용 주문 아이템 조회
    List<HashMap<String, Object>> selectOrderItemsForCancel(@Param("orderId") Long orderId);

    // 렌탈 취소 — RESERVED_QTY 복원
    int restoreStockForRentalCancel(HashMap<String, Object> map);

    // 구매 취소 — AVAILABLE_QTY 복원
    int increaseStockForPurchaseCancel(HashMap<String, Object> map);
    
    // 
    int insertPurchaseStockIfNotExists(HashMap<String, Object> map);
    
    // 취소용 주문 정보 조회 (USE_POINT, USER_ID)
    HashMap<String, Object> selectOrderInfoForCancel(@Param("orderId") Long orderId);

    // 취소 시 포인트 반환 이력
    int insertPointRestoreHistory(HashMap<String, Object> map);

    // 취소 시 USER.POINT 복원
    int restoreUserPoint(HashMap<String, Object> map);

    // 취소 시 적립 포인트 회수 이력
    int insertPointCancelHistory(HashMap<String, Object> map);
    

}