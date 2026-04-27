package com.example.modak.order.mapper;
 
import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;
 
@Mapper
public interface OrderExchangeMapper {
    HashMap<String, Object> selectExchangeOrderInfo(HashMap<String, Object> map);
    int insertExchange(HashMap<String, Object> map);
    int updateOrderStatusToExchange(HashMap<String, Object> map);
}
