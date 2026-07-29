package com.example.modak.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.admin.mapper.AdminMapper;
import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.order.mapper.OrderMapper;
import com.example.modak.refund.dao.RefundService;

@Service
public class AdminService {

	private static final Logger logger = LoggerFactory.getLogger(AdminService.class);

	@Autowired
	private AdminMapper mapper;

	@Autowired
	private RefundService refundService;

	@Autowired
	private OrderMapper orderMapper;

	@Autowired
	private AlarmService alarmService;

	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	private void applyPaging(HashMap<String, Object> map, int defaultPageSize) {
		int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
		int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", String.valueOf(defaultPageSize))));
		map.put("offset", (page - 1) * pageSize);
		map.put("pageSize", pageSize);
	}

	public HashMap<String, Object> adminLogin(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		String id = (String) map.get("id");
		String pw = (String) map.get("password");

		HashMap<String, Object> admin = mapper.selectAdminById(id);

		if (admin != null) {
			if (passwordEncoder.matches(pw, (String) admin.get("password"))) {
				mapper.updateAdminLoginDate(id);
				result.put("result", "success");
				result.put("adminName", admin.get("adminName"));
				result.put("role", admin.get("role"));
			} else {
				result.put("result", "fail");
				result.put("message", "비밀번호가 일치하지 않습니다.");
			}
		} else {
			result.put("result", "fail");
			result.put("message", "존재하지 않는 관리자 계정입니다.");
		}
		return result;
	}

	public HashMap<String, Object> getDashboardData() {
		HashMap<String, Object> result = new HashMap<>();
		try {
			long monthSales = mapper.selectMonthSales();
			long lastMonth = mapper.selectLastMonthSales();
			int salesChange = lastMonth == 0 ? 100 : (int) Math.round((monthSales - lastMonth) * 100.0 / lastMonth);

			Map<String, Object> activeOrders = mapper.selectActiveOrders();

			HashMap<String, Object> stats = new HashMap<>();
			stats.put("monthSales", monthSales);
			stats.put("salesChange", salesChange);
			stats.put("totalUsers", mapper.selectTotalUsers());
			stats.put("newUsers", mapper.selectNewUsers());
			stats.put("activeOrders", activeOrders != null ? activeOrders.getOrDefault("total", 0) : 0);
			stats.put("rentingCount", mapper.selectRentingCount());
			stats.put("shippingCount", activeOrders != null ? activeOrders.getOrDefault("shipping", 0) : 0);
			stats.put("waitingInquiry", mapper.selectWaitingInquiryCount());
			stats.put("totalInquiry", mapper.selectTotalInquiryCount());

			result.put("result", "success");
			result.put("stats", stats);
			result.put("salesChart", mapper.selectMonthlySales());
			result.put("recentOrders", mapper.selectRecentOrders());
			result.put("waitingInquiries", mapper.selectWaitingInquiries());
			result.put("topProducts", mapper.selectTopProducts());
			result.put("gradeStats", mapper.selectGradeStats());
		} catch (Exception e) {
			logger.error("대시보드 데이터 로딩 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> getAdminOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			applyPaging(map, 15);
			List<Map<String, Object>> list = mapper.selectAdminOrderList(map);

			result.put("list", list);
			result.put("totalCount", mapper.selectAdminOrderCount(map));
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("주문 목록 로딩 실패", e);
			result.put("result", "fail");
			result.put("message", "주문 목록 로딩 실패");
		}
		return result;
	}

	public HashMap<String, Object> updateOrderStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		mapper.updateOrderStatus(map);
		mapper.updateRentalStatusByOrderStatus(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> approveCancel(String orderId) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			Long orderIdLong = Long.parseLong(orderId);

			HashMap<String, Object> orderInfo = orderMapper.selectOrderInfoForCancel(orderIdLong);

			if (orderInfo != null) {
				String status = String.valueOf(orderInfo.get("ORDER_STATUS"));
				if (!"CANCEL_REQUESTED".equals(status)) {
					throw new RuntimeException("취소 가능한 상태가 아닙니다.");
				}
			}

			HashMap<String, Object> pay = mapper.selectPaymentByOrderId(orderId);
			if (pay == null) {
				result.put("result", "fail");
				result.put("message", "결제 정보를 찾을 수 없습니다.");
				return result;
			}

			String paymentKey = String.valueOf(pay.get("paymentKey"));
			int amount = Integer.parseInt(String.valueOf(pay.get("amount")));

			HashMap<String, Object> cancelMap = new HashMap<>();
			cancelMap.put("refundReason", "주문취소");
			cancelMap.put("reasonDetail", "관리자 취소 승인");

			boolean tossResult = refundService.callTossCancelApi(cancelMap, paymentKey, amount);
			if (!tossResult) {
				result.put("result", "fail");
				result.put("message", "토스 결제 취소에 실패했습니다.");
				return result;
			}

			HashMap<String, Object> statusMap = new HashMap<>();
			statusMap.put("orderId", orderId);
			statusMap.put("status", "CANCELLED");
			mapper.updateOrderStatus(statusMap);

			HashMap<String, Object> paymentMap = new HashMap<>();
			paymentMap.put("orderId", orderId);
			mapper.updatePaymentRefunded(paymentMap);

			List<HashMap<String, Object>> items = orderMapper.selectOrderItemsForCancel(orderIdLong);

			for (HashMap<String, Object> item : items) {
				String orderType = String.valueOf(item.get("ORDER_TYPE"));

				HashMap<String, Object> stockMap = new HashMap<>();
				stockMap.put("productId", item.get("PRODUCT_ID"));
				stockMap.put("optionItemId", item.get("OPTION_ITEM_ID"));
				stockMap.put("quantity", item.get("QUANTITY"));

				if ("PURCHASE".equals(orderType)) {
					orderMapper.insertPurchaseStockIfNotExists(stockMap);
					orderMapper.increaseStockForPurchaseCancel(stockMap);
				} else if ("RENTAL".equals(orderType)) {
					stockMap.put("startDate", item.get("START_DATE"));
					stockMap.put("endDate", item.get("END_DATE"));
					orderMapper.restoreStockForRentalCancel(stockMap);
				}
			}

			orderInfo = orderMapper.selectOrderInfoForCancel(orderIdLong);

			if (orderInfo != null) {
				String userId = String.valueOf(orderInfo.get("USER_ID"));
				boolean isGuest = userId != null && userId.startsWith("GUEST_");

				if (!isGuest) {
					long usePoint = 0;
					Object up = orderInfo.get("USE_POINT");
					if (up != null && !"".equals(String.valueOf(up))) {
						usePoint = Long.parseLong(String.valueOf(up));
					}

					long totalPrice = 0;
					Object tp = orderInfo.get("TOTAL_PRICE");
					if (tp != null && !"".equals(String.valueOf(tp))) {
						totalPrice = Long.parseLong(String.valueOf(tp));
					}
					long earnedPoint = totalPrice / 100;

					HashMap<String, Object> pointMap = new HashMap<>();
					pointMap.put("userId", userId);
					pointMap.put("usePoint", usePoint);
					pointMap.put("earnedPoint", earnedPoint);

					if (usePoint > 0) {
						pointMap.put("description", "주문 취소 포인트 반환 - 주문번호 " + orderId);
						orderMapper.insertPointRestoreHistory(pointMap);
					}
					if (earnedPoint > 0) {
						pointMap.put("description", "주문 취소 적립 포인트 회수 - 주문번호 " + orderId);
						orderMapper.insertPointCancelHistory(pointMap);
					}
					if (usePoint > 0 || earnedPoint > 0) {
						orderMapper.restoreUserPoint(pointMap);
					}
				}
			}

			result.put("result", "success");
			result.put("message", "주문취소 및 환불이 완료되었습니다.");

		} catch (Exception e) {
			logger.error("[CRITICAL] 토스 취소 완료 후 DB 실패 orderId={}", orderId, e);
			result.put("result", "fail");
			result.put("message", "취소 승인 처리 중 오류가 발생했습니다.");
		}

		return result;
	}

	public HashMap<String, Object> getReturnRequestList() {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("result", "success");
			result.put("list", mapper.selectReturnRequestList());
		} catch (Exception e) {
			logger.error("반납 요청 목록 조회 실패", e);
			result.put("result", "fail");
			result.put("message", "반납 요청 목록 조회 실패");
		}
		return result;
	}

	public HashMap<String, Object> updateReturnRequestStatus(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int affected = mapper.updateReturnRequestStatus(map);

			if (affected > 0) {
				String status = String.valueOf(map.get("status"));

				HashMap<String, Object> rentalMap = new HashMap<>();
				rentalMap.put("rentalId", map.get("rentalId"));

				HashMap<String, Object> rental = mapper.selectRentalByRentalId(rentalMap);

				if (rental != null && !"GUEST".equals(String.valueOf(rental.get("userId")))) {
					String uid = String.valueOf(rental.get("userId"));

					if ("RETURN_PICKED".equals(status)) {
						alarmService.createAlarm(uid, "DELIVERY",
								"물품 수거가 시작되었습니다",
								"반납 물품 수거가 시작되었습니다.", map.get("rentalId"));
					} else if ("RETURN_COMPLETED".equals(status)) {
						alarmService.createAlarm(uid, "NOTICE",
								"반납이 완료되었습니다",
								"반납이 정상 처리되었습니다. 보증금은 3~5일 내 환불됩니다.", map.get("rentalId"));
					}
				}

				result.put("result", "success");
			} else {
				result.put("result", "fail");
				result.put("message", "변경 가능한 상태가 아닙니다.");
			}
		} catch (Exception e) {
			logger.error("반납 상태 변경 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}

		return result;
	}

	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectInquiryList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("문의 목록 조회 실패", e);
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> saveInquiryAnswer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.insertInquiryAnswer(map);
			mapper.updateInquiryStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("문의 답변 저장 실패", e);
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> getInquiryBadge() {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int count = mapper.selectWaitingInquiryCount();
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getMemberList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			applyPaging(map, 15);
			result.put("result", "success");
			result.put("list", mapper.selectMemberList(map));
			result.put("totalCount", mapper.selectMemberCount(map));
			result.put("summary", mapper.selectMemberSummary());
		} catch (Exception e) {
			logger.error("회원 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> updateMemberStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateMemberStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("회원 상태 변경 실패", e);
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getAdminProductList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			if (map.get("offset") == null) {
				applyPaging(map, 20);
			} else {
				map.put("offset", Integer.parseInt(String.valueOf(map.get("offset"))));
				map.put("pageSize", Integer.parseInt(String.valueOf(map.get("pageSize"))));
			}
			result.put("result", "success");
			result.put("list", mapper.selectAdminProductList(map));
			result.put("totalCount", mapper.selectAdminProductCount(map));
		} catch (Exception e) {
			logger.error("상품 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	@Transactional
	public HashMap<String, Object> updateFullProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProduct(map);

			if (map.get("imgUrl") != null && !map.get("imgUrl").toString().isEmpty()) {
				mapper.deleteMainProductImg(map);
				mapper.insertMainProductImg(map);
			}

			mapper.updateProductSpec(map);
			mapper.updateProductFeature(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 수정 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	@Transactional
	public HashMap<String, Object> insertFullProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertProduct(map);

			if (map.get("imgUrl") != null) {
				mapper.insertProductImg(map);
			}
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 등록 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	@Transactional
	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteProductImg(map);
			mapper.deleteProductSpec(map);
			mapper.deleteProductFeature(map);
			mapper.deleteProduct(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 삭제 실패", e);
			r.put("result", "fail");
			r.put("message", "삭제 중 오류가 발생했습니다.");
		}
		return r;
	}

	public HashMap<String, Object> insertProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertProduct(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 등록 실패", e);
			r.put("result", "fail");
			r.put("message", e.getMessage());
		}
		return r;
	}

	public HashMap<String, Object> updateProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProduct(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 수정 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> toggleProductAvail(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProductAvail(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상품 판매상태 변경 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getProductStockList(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectProductStockList(map));
		} catch (Exception e) {
			logger.error("재고 목록 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> updateProductStock(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProductStock(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("재고 수정 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> addProductStock(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertProductStock(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("재고 추가 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getDetailImages(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectDetailImages(map));
		} catch (Exception e) {
			logger.error("상세 이미지 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> removeDetailImage(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteDetailImage(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("상세 이미지 삭제 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getOptionList(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			List<Map<String, Object>> groups = mapper.selectOptionGroups(map);
			for (Map<String, Object> g : groups) {
				HashMap<String, Object> param = new HashMap<>();
				param.put("optionGroupId", g.get("optionGroupId"));
				g.put("values", mapper.selectOptionValues(param));
			}
			r.put("result", "success");
			r.put("groups", groups);
			r.put("items", mapper.selectOptionItems(map));
		} catch (Exception e) {
			logger.error("옵션 목록 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> addOptionGroup(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertOptionGroup(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("옵션 그룹 추가 실패", e);
			r.put("result", "fail");
			r.put("message", e.getMessage());
		}
		return r;
	}

	@Transactional
	public HashMap<String, Object> removeOptionGroup(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("optionGroupId", map.get("optionGroupId"));
			List<Map<String, Object>> vals = mapper.selectOptionValues(param);
			for (Map<String, Object> v : vals) {
				HashMap<String, Object> vp = new HashMap<>();
				vp.put("optionValueId", v.get("optionValueId"));
				mapper.deleteOptionValue(vp);
			}
			mapper.deleteOptionGroup(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("옵션 그룹 삭제 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> addOptionValue(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertOptionValue(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("옵션 값 추가 실패", e);
			r.put("result", "fail");
			r.put("message", e.getMessage());
		}
		return r;
	}

	public HashMap<String, Object> removeOptionValue(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteOptionValue(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("옵션 값 삭제 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> updateOptionItemAvail(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateOptionItemAvail(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("옵션 아이템 판매상태 변경 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public void insertDetailImage(HashMap<String, Object> map) {
		mapper.insertDetailImage(map);
	}

	public HashMap<String, Object> getBrandList() {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("result", "success");
			result.put("list", mapper.selectBrandList());
		} catch (Exception e) {
			logger.error("브랜드 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectAdminReviewList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> removeReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.deleteReview(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getEventList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			applyPaging(map, 15);
			result.put("result", "success");
			result.put("list", mapper.selectEventList(map));
			result.put("totalCount", mapper.selectEventCount());
		} catch (Exception e) {
			logger.error("이벤트 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	@Transactional
	public HashMap<String, Object> saveEvent(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			if (map.get("eventId") == null || String.valueOf(map.get("eventId")).equals("")) {
				mapper.insertEvent(map);
			} else {
				mapper.updateEvent(map);
			}

			if (map.get("img_path") != null && !map.get("img_path").toString().equals("")) {
				mapper.updateEventImage(map);
			}

			r.put("result", "success");
		} catch (Exception e) {
			logger.error("이벤트 저장 실패", e);
			r.put("result", "fail");
			r.put("message", "저장 중 오류 발생: " + e.getMessage());
		}
		return r;
	}

	public HashMap<String, Object> deleteEvent(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteEvent(map);
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("이벤트 삭제 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getAdminRentalList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			applyPaging(map, 15);
			result.put("list", mapper.selectAdminRentalList(map));
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("대여 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> updateRentalStatus(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateRentalStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("대여 상태 변경 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> updateRentalDate(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateRentalDate(map);
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("대여 반납일 변경 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> getCampList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectCampList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> updateCampStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateCampStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getCampDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("info", mapper.selectCampDetail(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> editCamp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateCampInfo(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> addCamp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.insertCamp(map);
			if (map.get("imgUrl") != null && !map.get("imgUrl").toString().isEmpty()) {
				mapper.insertCampImg(map);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("캠핑장 등록 실패", e);
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> removeCamp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.deleteCamp(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getSalesData(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectSalesByPeriod(map));
		} catch (Exception e) {
			logger.error("매출 데이터 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getViewStats(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			map.put("pageSize", map.getOrDefault("pageSize", "20"));
			r.put("result", "success");
			r.put("list", mapper.selectViewStats(map));
		} catch (Exception e) {
			logger.error("조회수 통계 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getProductViewStats(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectProductViewStats();
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getCouponList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("list", mapper.selectCouponList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> saveCoupon(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			if (map.get("couponId") == null || String.valueOf(map.get("couponId")).equals("")) {
				mapper.insertCoupon(map);
			} else {
				mapper.updateCoupon(map);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> modifyCouponStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateCouponStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> removeCoupon(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.deleteCoupon(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> giveCouponToAll(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.insertCouponToAllUsers(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("쿠폰 전체 발송 실패", e);
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> giveCouponToUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.insertUserCoupon(map);
			alarmService.createAlarm(
					String.valueOf(map.get("userId")), "EVENT",
					"쿠폰이 발급되었습니다",
					"새로운 쿠폰이 지급되었습니다. 마이페이지에서 확인하세요.", null);
			resultMap.put("result", "success");
		} catch (Exception e) {
			logger.error("쿠폰 개별 발송 실패", e);
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> getUserCouponList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("list", mapper.selectUserCouponList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> modifyUserCouponStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateUserCouponStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> removeUserCoupon(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.deleteUserCoupon(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	public HashMap<String, Object> getGradeList() {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("result", "success");
			result.put("grades", mapper.selectGradeList());
		} catch (Exception e) {
			logger.error("등급 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> saveGrade(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateGrade(map);
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("등급 저장 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> updateMemberGrade(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateMemberGrade(map);
			result.put("result", "success");
		} catch (Exception e) {
			logger.error("회원 등급 변경 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	@Transactional
	public HashMap<String, Object> sendAlarm(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			String sendType = (String) map.get("sendType");
			int count = 0;

			if ("ALL".equals(sendType)) {
				count = mapper.insertAlarmToAllUsers(map);
			} else if ("SELECT".equals(sendType)) {
				String userIds = (String) map.get("userIds");
				if (userIds != null && !userIds.isEmpty()) {
					String[] ids = userIds.split(",");
					for (String uid : ids) {
						map.put("userId", uid.trim());
						mapper.insertAlarm(map);
						count++;
					}
				}
			} else if ("INDIVIDUAL".equals(sendType)) {
				mapper.insertAlarm(map);
				count = 1;
			}

			result.put("result", "success");
			result.put("count", count);
		} catch (Exception e) {
			logger.error("알람 발송 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> getAlarmLogs(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			applyPaging(map, 15);
			result.put("result", "success");
			result.put("list", mapper.selectAlarmLogs(map));
		} catch (Exception e) {
			logger.error("알람 발송 내역 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> findMember(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> user = mapper.selectMemberById(map);
			if (user != null) {
				result.put("result", "success");
				result.put("user", user);
			} else {
				result.put("result", "fail");
				result.put("message", "존재하지 않는 회원입니다.");
			}
		} catch (Exception e) {
			logger.error("회원 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	@Transactional
	public HashMap<String, Object> registerDelivery(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.upsertDelivery(map);
			map.put("status", "SHIPPING");
			mapper.updateOrderStatus(map);

			HashMap<String, Object> orderMap = new HashMap<>();
			orderMap.put("orderId", map.get("orderId"));
			HashMap<String, Object> orderInfo = mapper.selectOrderById(orderMap);

			if (orderInfo != null && orderInfo.get("userId") != null) {
				String uid = String.valueOf(orderInfo.get("userId"));
				alarmService.createAlarm(uid, "DELIVERY",
						"상품이 출발했습니다",
						"운송장 번호: " + map.get("trackingNo"), map.get("orderId"));
			}

			result.put("result", "success");
		} catch (Exception e) {
			logger.error("배송 등록 실패", e);
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	public HashMap<String, Object> getDeliveryList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			result.put("result", "success");
			result.put("list", mapper.selectDeliveryList(map));
		} catch (Exception e) {
			logger.error("배송 목록 조회 실패", e);
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> getInspectionList() {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectInspectionList());
		} catch (Exception e) {
			logger.error("검수 목록 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> saveInspection(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertReturnInspection(map);
			String userId = String.valueOf(map.get("userId"));
			String code = String.valueOf(map.get("conditionCode"));
			if (!"GOOD".equals(code) && !"GUEST".equals(userId)) {
				String msg = "DAMAGED".equals(code)
						? "반납 물품에 파손이 확인되어 " + map.get("deductionAmt") + "원이 공제됩니다."
						: "반납 물품 분실이 확인되어 배상금이 청구됩니다.";
				alarmService.createAlarm(userId, "NOTICE", "검수 결과 안내", msg, map.get("rentalId"));
			}
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("검수 결과 저장 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getRefundList() {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectRefundList());
		} catch (Exception e) {
			logger.error("환불 목록 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> getExchangeList() {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectExchangeList());
		} catch (Exception e) {
			logger.error("교환 목록 조회 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public HashMap<String, Object> updateExchangeStatus(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateExchangeStatus(map);
			String userId = String.valueOf(map.get("userId"));
			String status = String.valueOf(map.get("status"));
			if (!"GUEST".equals(userId)) {
				if ("APPROVED".equals(status)) {
					alarmService.createAlarm(userId, "NOTICE", "교환 신청이 승인되었습니다",
							"교환이 승인되었습니다. 새 상품이 곧 발송됩니다.", map.get("exchangeId"));
				} else if ("REJECTED".equals(status)) {
					alarmService.createAlarm(userId, "NOTICE", "교환 신청이 거절되었습니다",
							"교환 신청이 거절되었습니다. 문의사항은 고객센터로 연락해주세요.", map.get("exchangeId"));
				}
			}
			r.put("result", "success");
		} catch (Exception e) {
			logger.error("교환 상태 변경 실패", e);
			r.put("result", "fail");
		}
		return r;
	}

	public void updateRefundStatus(Map<String, Object> map) {
		mapper.updateRefundStatus(map);
	}
}