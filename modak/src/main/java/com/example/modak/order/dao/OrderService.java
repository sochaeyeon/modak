package com.example.modak.order.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.common.Message;
import com.example.modak.order.mapper.OrderMapper;
import com.example.modak.order.model.Order;

@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    // 1. 주문 목록 조회 (기존 로직 유지)
    public HashMap<String, Object> getOrderList(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<Order> list = orderMapper.selectOrderList(userId);

            resultMap.put("result", "success");
            resultMap.put("list", list);
            resultMap.put("count", list.size());
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_SERVER); // 기존 메시지 유지
        }

        return resultMap;
    }

    // 2. 주문 상세 조회 (기존 인터페이스 selectOrderDetail(Long, String) 구조 유지)
    public HashMap<String, Object> getOrderDetail(Long orderId, String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            // Mapper 인터페이스의 @Param 순서에 맞춰 직접 전달
            // XML에서 resultMap(collection)을 사용하므로 order 객체 내부에 itemList가 자동으로 채워집니다.
            Order order = orderMapper.selectOrderDetail(orderId, userId);

            if (order == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", Message.FAIL_SELECT);
                return resultMap;
            }

            resultMap.put("result", "success");
            resultMap.put("order", order);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_SERVER);
        }

        return resultMap;
    }
    @Transactional(rollbackFor = Exception.class) // 에러 발생 시 모든 작업 원복!
    public HashMap<String, Object> cancelOrder(Map<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        try {
            // [STEP 1] ORDERS 테이블 상태 업데이트 시도
            // updateOrderStatus는 업데이트된 행(row)의 수를 반환합니다.
            int updateCount = orderMapper.updateOrderStatus(
                Long.parseLong(String.valueOf(map.get("orderId"))), 
                "CANCELLED"
            );

            if (updateCount > 0) {
                // [STEP 2] 상태 변경 성공 시에만 취소 상세 정보(사유 등) 저장
                // map 안에는 JSP에서 보낸 cancelReasonCode, cancelReasonText, cancelAmount가 들어있어야 합니다.
                orderMapper.insertOrderCancel(map);

                resultMap.put("result", "success");
                resultMap.put("message", "주문 취소가 성공적으로 처리되었다닥! 🔥");
            } else {
                // 이미 배송 중이거나 취소 불가능한 상태일 때
                resultMap.put("result", "fail");
                resultMap.put("message", "취소 가능한 주문 상태가 아니다닥. 확인이 필요하다닥!");
            }

        } catch (Exception e) {
            // 로그 기록 및 실패 처리
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "서버 오류로 취소 처리에 실패했다닥!");
            
            // @Transactional 덕분에 여기서 Exception이 던져지면 
            // 위에서 실행된 updateOrderStatus 쿼리도 자동으로 취소(Rollback) 됩니다.
            throw e; 
        }

        return resultMap;
    }
    public Integer getDeliveryIdByOrderId(Integer orderId) {
        return orderMapper.selectDeliveryIdByOrderId(orderId);
    }
    
}