package com.example.modak.order.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}