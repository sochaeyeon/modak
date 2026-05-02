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
    
    @Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> cancelOrder(Map<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            Long orderId = Long.parseLong(String.valueOf(map.get("orderId")));

            int updateCount = orderMapper.updateOrderStatus(orderId, "CANCEL_REQUESTED");

            if (updateCount > 0) {
                orderMapper.insertOrderCancel(map);

                

                resultMap.put("result", "success");
                resultMap.put("message", "주문 취소가 성공적으로 처리되었다닥! 🔥");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "취소 가능한 주문 상태가 아니다닥. 확인이 필요하다닥!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "서버 오류로 취소 처리에 실패했다닥!");
            throw e;
        }

        return resultMap;
    }
    
    
    public Integer getDeliveryIdByOrderId(Integer orderId) {
        return orderMapper.selectDeliveryIdByOrderId(orderId);
    }
    
}