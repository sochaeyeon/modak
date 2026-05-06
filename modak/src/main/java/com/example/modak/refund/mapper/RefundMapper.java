package com.example.modak.refund.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RefundMapper {
	
	// 환불용 주문 정보 조회 (상품 + 결제 포함)
    public List<HashMap<String, Object>> selectOrderInfoForRefund(HashMap<String, Object> map);

    // 기본 배송지 조회
    public HashMap<String, Object> selectDefaultAddress(HashMap<String, Object> map);

    // 환불 가능 여부 체크 (환불 진행중 여부 + 주문 상태)
    public HashMap<String, Object> checkRefundAvailability(HashMap<String, Object> map);

    // 환불 요청 등록
    public int insertRefund(HashMap<String, Object> map);

    // 주문 상태 환불요청으로 변경
    public int updateOrderStatus(HashMap<String, Object> map);

    // 환불 누적 금액 조회 (부분/전체 환불 판단용)
    public int selectRefundAmountSum(HashMap<String, Object> map);
    
    // 토스 환불 후 상태 업데이트
    public int updateRefundCompleted(HashMap<String, Object> map);

    public int updatePaymentRefunded(HashMap<String, Object> map);

}
