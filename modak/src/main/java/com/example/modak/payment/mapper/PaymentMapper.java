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
	// order item
	void insertOrderItem(HashMap<String, Object> map);
	
	// ORDERS에 READY로 INSERT, ORDER_ID 반환
    public int insertTempOrder(HashMap<String, Object> map);      
    // 결제 성공 후 PAID로 UPDATE
    public int updateOrderStatus(HashMap<String, Object> map);    
    // PAYMENT 테이블 INSERT
    public int insertPayment(HashMap<String, Object> map);    
    
    // ORDERS에서 CART_IDS 조회 후 CART 삭제
    public int deleteCartByOrderId(HashMap<String, Object> map);

    // ORDERS에서 userId, cartIds 등 부가정보 조회 (confirmPayment에서 쓸 것)
    public HashMap<String, Object> selectOrderById(HashMap<String, Object> map);
    
    // 쿠폰 사용 처리
    public int updateCouponUsed(HashMap<String, Object> map);

    // 쿠폰 사용 로그 INSERT
    public int insertCouponUseLog(HashMap<String, Object> map);
    
    // 포인트 적립 이력 INSERT
    public int insertPointHistory(HashMap<String, Object> map);
    
    // 기존 updateUserPoint, updateUserTotalAmount 대신 하나로
    public int updateUserPointAndAmount(HashMap<String, Object> map);
    
    // 주문 아이템 목록 조회 (재고 차감용)
    public List<HashMap<String, Object>> selectOrderItemsForStock(HashMap<String, Object> map);

    // 구매 재고 차감
    public int decreaseStockForPurchase(HashMap<String, Object> map);

    // 대여 재고 차감
    public int decreaseStockForRental(HashMap<String, Object> map);
    
    // 결제 내역 생성
    public int insertPaymentHistory(HashMap<String, Object> map);
    
    public int insertRental(HashMap<String, Object> map);
}
