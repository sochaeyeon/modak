package com.example.modak.delivery.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

import com.example.modak.delivery.mapper.DeliveryMapper;
import com.example.modak.delivery.model.DeliveryDetail;
import com.example.modak.delivery.model.DeliveryItem;
import com.example.modak.delivery.model.DeliveryTrackingResult;

@Service
public class DeliveryService {

	@Autowired
	private DeliveryMapper deliveryMapper;

	@Autowired
	private TrackingService trackingService;

	public DeliveryDetail getDeliveryDetail(Integer deliveryId, String userId) {

	    DeliveryDetail delivery = deliveryMapper.selectDeliveryDetail(deliveryId, userId);

	    if (delivery == null) {
	        return null;
	    }

	    List<DeliveryItem> itemList = deliveryMapper.selectDeliveryItemList(delivery.getOrderId());
	    delivery.setItemList(itemList);

	    // 1. API 조회
	    applyTrackingResult(delivery);

	    // 2. API 결과를 DB에 반영
	    syncTrackingResultToDb(delivery);

	    // 3. DB 반영 후 다시 조회해서 최신값 사용
	    delivery = deliveryMapper.selectDeliveryDetail(deliveryId, userId);
	    delivery.setItemList(itemList);

	 // 4. 화면 상태 계산
	    applyTrackingResult(delivery);
	    applyDeliveryStatusInfo(delivery);
	    applyDisplayInfo(delivery);

	    return delivery;

	}
	private void applyTrackingResult(DeliveryDetail delivery) {

		if (delivery.getTrackingNo() == null || delivery.getTrackingNo().equals("")) {
			DeliveryTrackingResult result = new DeliveryTrackingResult();
			result.setSuccess(false);
			result.setErrorMessage("등록된 운송장번호가 없습니다.");
			delivery.setTrackingResult(result);
			return;
		}

		if (delivery.getCarrierId() == null || delivery.getCarrierId().equals("")) {
			DeliveryTrackingResult result = new DeliveryTrackingResult();
			result.setSuccess(false);
			result.setErrorMessage("택배사 코드가 없습니다.");
			delivery.setTrackingResult(result);
			return;
		}

		try {
			DeliveryTrackingResult result = trackingService.getTrackingResult(delivery.getCarrierId(),
					delivery.getTrackingNo());

			if (result == null) {
				result = new DeliveryTrackingResult();
				result.setSuccess(false);
				result.setErrorMessage("배송추적 결과를 불러오지 못했습니다.");
			}

			delivery.setTrackingResult(result);

		} catch (Exception e) {
			DeliveryTrackingResult result = new DeliveryTrackingResult();
			result.setSuccess(false);
			result.setErrorMessage("실시간 배송추적 조회 중 오류가 발생했습니다.");
			delivery.setTrackingResult(result);
		}
	}

	private void applyDeliveryStatusInfo(DeliveryDetail delivery) {

		String status = delivery.getDeliveryStatus();

		// API 성공 시 API 상태를 내부 상태값으로 변환해서 우선 사용
		if (delivery.getTrackingResult() != null && delivery.getTrackingResult().isSuccess()) {
			String apiStatus = delivery.getTrackingResult().getLastStatus();

			if (apiStatus != null && !apiStatus.equals("")) {
				String normalizedStatus = normalizeTrackingStatus(apiStatus);

				if (normalizedStatus.equals("DONE")) {
					delivery.setStatusLabel("배송 완료");
					delivery.setStatusMessage("상품이 배송지에 정상적으로 전달되었어요.");
					delivery.setStepNo(4);
					delivery.setProgressPercent(100);
					delivery.setReturnFlow(false);
					return;
				}

				if (normalizedStatus.equals("SHIPPING")) {
					delivery.setStatusLabel("배송중");
					delivery.setStatusMessage("상품이 배송지로 이동 중입니다.");
					delivery.setStepNo(3);
					delivery.setProgressPercent(75);
					delivery.setReturnFlow(false);
					return;
				}
			}
		}

		// API 실패 시 DB 상태 기준 fallback
		if (status == null || status.equals("")) {
			delivery.setStatusLabel("상태 확인중");
			delivery.setStatusMessage("배송 상태를 확인 중입니다.");
			delivery.setStepNo(0);
			delivery.setProgressPercent(0);
			delivery.setReturnFlow(false);
			return;
		}

		switch (status) {
		case "PREPARING":
			delivery.setStatusLabel("배송 준비중");
			delivery.setStatusMessage("상품을 포장하고 출고를 준비하고 있어요.");
			delivery.setStepNo(1);
			delivery.setProgressPercent(25);
			delivery.setReturnFlow(false);
			break;

		case "SHIPPING":
			delivery.setStatusLabel("배송중");
			delivery.setStatusMessage("상품이 배송지로 이동 중입니다.");
			delivery.setStepNo(3);
			delivery.setProgressPercent(75);
			delivery.setReturnFlow(false);
			break;

		case "DONE":
			delivery.setStatusLabel("배송 완료");
			delivery.setStatusMessage("상품이 배송지에 정상적으로 전달되었어요.");
			delivery.setStepNo(4);
			delivery.setProgressPercent(100);
			delivery.setReturnFlow(false);
			break;

		case "RETURN_PICKED":
			delivery.setStatusLabel("회수 완료");
			delivery.setStatusMessage("택배 기사님이 상품을 회수했어요.");
			delivery.setStepNo(2);
			delivery.setProgressPercent(66);
			delivery.setReturnFlow(true);
			break;

		default:
			delivery.setStatusLabel("상태 확인중");
			delivery.setStatusMessage("배송 상태를 확인 중입니다.");
			delivery.setStepNo(0);
			delivery.setProgressPercent(0);
			delivery.setReturnFlow(false);
			break;
		}
	}

	private String normalizeTrackingStatus(String apiStatus) {
	    if (apiStatus == null || apiStatus.equals("")) {
	        return "";
	    }

	    String upper = apiStatus.toUpperCase();

	    if (apiStatus.contains("배송완료")
	            || apiStatus.contains("배달완료")
	            || upper.contains("DELIVERED")) {
	        return "DONE";
	    }

	    if (apiStatus.contains("배송중")
	            || upper.contains("TRANSIT")
	            || upper.contains("SHIPPING")) {
	        return "SHIPPING";
	    }

	    return "";
	}
	private void applyDisplayInfo(DeliveryDetail delivery) {

		// 주문유형 한글화
		if ("PURCHASE".equalsIgnoreCase(delivery.getOrderType())) {
			delivery.setOrderTypeLabel("구매");
		} else if ("RENTAL".equalsIgnoreCase(delivery.getOrderType())) {
			delivery.setOrderTypeLabel("대여");
		} else {
			delivery.setOrderTypeLabel(delivery.getOrderType());
		}

		// 주문상태 한글화
		if ("PAID".equalsIgnoreCase(delivery.getOrderStatus())) {
			delivery.setOrderStatusLabel("결제완료");
		} else if ("READY".equalsIgnoreCase(delivery.getOrderStatus())) {
			delivery.setOrderStatusLabel("배송준비");
		} else if ("SHIPPING".equalsIgnoreCase(delivery.getOrderStatus())) {
			delivery.setOrderStatusLabel("배송중");
		} else if ("DONE".equalsIgnoreCase(delivery.getOrderStatus())) {
			delivery.setOrderStatusLabel("배송완료");
		} else if ("CANCELLED".equalsIgnoreCase(delivery.getOrderStatus())) {
			delivery.setOrderStatusLabel("취소");
		} else {
			delivery.setOrderStatusLabel(delivery.getOrderStatus());
		}

		// 택배사명 한글화
		if ("kr.cjlogistics".equalsIgnoreCase(delivery.getCarrierId())) {
			delivery.setCarrierName("CJ대한통운");
		} else {
			delivery.setCarrierName(delivery.getCarrierId());
		}

		// 주소 표시값
		if (delivery.getAddress() == null || delivery.getAddress().trim().equals("")) {
		    delivery.setDisplayAddress("등록된 배송지 정보가 없습니다.");
		} else {
		    delivery.setDisplayAddress(delivery.getAddress());
		}

		// 배송완료일시 표시값
		if (!"DONE".equalsIgnoreCase(delivery.getDeliveryStatus())) {
		    delivery.setDeliveredAtLabel("-");
		} else if (delivery.getDeliveredAt() == null || delivery.getDeliveredAt().trim().equals("")) {
		    delivery.setDeliveredAtLabel("배송완료 처리되었으나 완료일시 정보가 없습니다.");
		} else {
		    delivery.setDeliveredAtLabel(delivery.getDeliveredAt());
		}
	}
	
	private void syncTrackingResultToDb(DeliveryDetail delivery) {

	    if (delivery.getTrackingResult() == null || !delivery.getTrackingResult().isSuccess()) {
	        return;
	    }

	    String apiStatus = delivery.getTrackingResult().getLastStatus();
	    String normalizedStatus = normalizeTrackingStatus(apiStatus);

	    if ("DONE".equals(normalizedStatus)) {
	        delivery.setDeliveryStatus("DONE");

	        if (delivery.getTrackingResult().getLastTime() != null
	                && !delivery.getTrackingResult().getLastTime().isBlank()) {
	        	String lastTime = delivery.getTrackingResult().getLastTime();

	        	String formattedTime = convertToMysqlDatetime(lastTime);

	        	delivery.setDeliveredAt(formattedTime);
	        }
	    } else if ("SHIPPING".equals(normalizedStatus)) {
	        delivery.setDeliveryStatus("SHIPPING");
	        delivery.setDeliveredAt(null);
	    } else {
	        return;
	    }
	    
	    deliveryMapper.updateDeliveryTrackingSync(delivery);
	}

	private String convertToMysqlDatetime(String isoTime) {

	    if (isoTime == null || isoTime.isBlank()) {
	        return null;
	    }

	    OffsetDateTime odt = OffsetDateTime.parse(isoTime);

	    return odt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	}

}