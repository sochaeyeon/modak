package com.example.modak.order.dao;
 
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.modak.order.mapper.OrderExchangeMapper;
 
@Service
public class OrderExchangeService {
 
    @Autowired
    private OrderExchangeMapper mapper;
 
    /* 주문 정보 조회 */
    public HashMap<String, Object> getExchangeInfo(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            HashMap<String, Object> info = mapper.selectExchangeOrderInfo(map);
            if (info == null) {
                result.put("result", "fail");
                result.put("message", "주문 정보를 찾을 수 없습니다.");
                return result;
            }
            // orderInfo / defaultAddress 분리
            HashMap<String, Object> orderInfo = new HashMap<>();
            orderInfo.put("productName", info.get("productName"));
            orderInfo.put("count",       info.get("count"));
            orderInfo.put("imgUrl",      info.get("imgUrl"));
            orderInfo.put("price",       info.get("price"));
 
            HashMap<String, Object> addr = new HashMap<>();
            addr.put("zipcode",          info.get("zipcode"));
            addr.put("address",          info.get("address"));
            addr.put("detailedAddress",  info.get("detailedAddress"));
 
            result.put("result",         "success");
            result.put("orderInfo",      orderInfo);
            result.put("defaultAddress", addr);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "오류가 발생했습니다.");
        }
        return result;
    }
 
    /* 교환 신청 */
    @Transactional
    public HashMap<String, Object> applyExchange(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            mapper.insertExchange(map);
            mapper.updateOrderStatusToExchange(map);
            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "교환 신청 중 오류가 발생했습니다.");
        }
        return result;
    }
}