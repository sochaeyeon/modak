package com.example.modak.delivery.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.delivery.model.DeliveryDetail;
import com.example.modak.delivery.model.DeliveryItem;

@Mapper
public interface DeliveryMapper {

	DeliveryDetail selectDeliveryDetail(@Param("deliveryId") Integer deliveryId, @Param("userId") String userId);

	List<DeliveryItem> selectDeliveryItemList(@Param("orderId") Long orderId);

	int updateDeliveryTrackingSync(DeliveryDetail delivery);

	DeliveryDetail selectDeliveryDetailByOrderId(@Param("orderId") Long orderId, @Param("userId") String userId,
			@Param("token") String token);
	
	DeliveryDetail selectOrderDeliveryBaseByOrderId(@Param("orderId") Long orderId);
}