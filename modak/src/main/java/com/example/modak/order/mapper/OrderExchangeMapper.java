package com.example.modak.order.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderExchangeMapper {
	HashMap<String, Object> selectExchangeOrderInfo(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectOptionListByProduct(HashMap<String, Object> map);

	int insertExchange(HashMap<String, Object> map);

	int updateOrderStatusToExchange(HashMap<String, Object> map);

	int increaseStockForExchange(HashMap<String, Object> map);

	int decreaseStockForExchange(HashMap<String, Object> map);
}