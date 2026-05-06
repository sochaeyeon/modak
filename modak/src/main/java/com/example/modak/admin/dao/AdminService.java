package com.example.modak.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	@Autowired
	private AdminMapper mapper;
	
	@Autowired
	private RefundService refundService;
	
	@Autowired
	private OrderMapper orderMapper;

	// 비밀번호 암호화 및 매칭을 위한 시큐리티 인코더
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	/* ==========================================================
       1. 관리자 인증 및 계정 로직
       ========================================================== */
	
	/**
	 * 관리자 로그인 검증
	 * - ID 존재 여부 확인 후 BCrypt 암호화된 비밀번호와 대조
	 * - 성공 시 로그인 시각 업데이트 및 관리자 권한 정보 반환
	 */
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

	/* ==========================================================
       2. 대시보드 통계 분석 로직
       ========================================================== */
	
	/**
	 * 관리자 메인 대시보드 데이터 통합 로드
	 * - 매출 통계(전월 대비 증감률), 회원 현황, 문의/대여 현황 요약
	 * - 차트용 데이터 및 최근 내역 리스트 포함
	 */
	public HashMap<String, Object> getDashboardData() {
		HashMap<String, Object> result = new HashMap<>();
		try {
			// 매출 및 증감률 계산
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
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	/* ==========================================================
       3. 주문 및 배송 관리 로직
       ========================================================== */

	// 관리자용 주문 목록 조회 (페이징 및 검색 필터 적용)
	public HashMap<String, Object> getAdminOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);

			List<Map<String, Object>> list = mapper.selectAdminOrderList(map);

			result.put("list", list);
			result.put("totalCount", mapper.selectAdminOrderCount(map));
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "주문 목록 로딩 실패");
		}
		return result;
	}

	// 주문 진행 상태 변경 (배송준비, 배송중, 완료 등)
	public HashMap<String, Object> updateOrderStatus(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    mapper.updateOrderStatus(map);

	    // 대여 주문이면 rentals.rental_status도 함께 동기화
	    mapper.updateRentalStatusByOrderStatus(map);

	    resultMap.put("result", "success");
	    return resultMap;
	}

	@Transactional
	public HashMap<String, Object> approveCancel(String orderId) {
	    HashMap<String, Object> result = new HashMap<>();

	    try {
	    	    Long orderIdLong = Long.parseLong(orderId);

	    	    HashMap<String, Object> orderInfo =
	    	        orderMapper.selectOrderInfoForCancel(orderIdLong);
	    	    
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

	        // ★ 재고 복원 (비회원 취소 승인 시)
	        List<HashMap<String, Object>> items =
	            orderMapper.selectOrderItemsForCancel(orderIdLong);

	        for (HashMap<String, Object> item : items) {
	            String orderType = String.valueOf(item.get("ORDER_TYPE"));

	            HashMap<String, Object> stockMap = new HashMap<>();
	            stockMap.put("productId",    item.get("PRODUCT_ID"));
	            stockMap.put("optionItemId", item.get("OPTION_ITEM_ID"));
	            stockMap.put("quantity",     item.get("QUANTITY"));

	            if ("PURCHASE".equals(orderType)) {
	            	orderMapper.insertPurchaseStockIfNotExists(stockMap);
	                orderMapper.increaseStockForPurchaseCancel(stockMap);
	            } else if ("RENTAL".equals(orderType)) {
	                stockMap.put("startDate", item.get("START_DATE"));
	                stockMap.put("endDate",   item.get("END_DATE"));
	                orderMapper.restoreStockForRentalCancel(stockMap);
	            }
	        }
	        
	     // ★ 포인트 복원 + 적립 포인트 회수
	        orderInfo = orderMapper.selectOrderInfoForCancel(Long.parseLong(orderId));

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
	                pointMap.put("userId",      userId);
	                pointMap.put("usePoint",    usePoint);
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
	        e.printStackTrace();
	        // 토스 취소는 완료됐으나 DB 처리 실패 — 수동 확인 필요
	        System.err.println("[CRITICAL] 토스 취소 완료 후 DB 실패 orderId=" + orderId);
	        result.put("result", "fail");
	        result.put("message", "취소 승인 처리 중 오류가 발생했습니다.");
	    }

	    return result;
	}
	
	// 반납 요청 목록 조회
	public HashMap<String, Object> getReturnRequestList() {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        result.put("result", "success");
	        result.put("list", mapper.selectReturnRequestList());
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", "반납 요청 목록 조회 실패");
	    }
	    return result;
	}
	 
	// 반납 상태 변경
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
	                        "물품 수거가 시작되었습니다 🚚",
	                        "반납 물품 수거가 시작되었습니다.", map.get("rentalId"));

	                } else if ("RETURN_COMPLETED".equals(status)) {
	                    alarmService.createAlarm(uid, "NOTICE",
	                        "반납이 완료되었습니다 📦",
	                        "반납이 정상 처리되었습니다. 보증금은 3~5일 내 환불됩니다.", map.get("rentalId"));
	                }
	            }

	            result.put("result", "success");

	        } else {
	            result.put("result", "fail");
	            result.put("message", "변경 가능한 상태가 아닙니다.");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", e.getMessage());
	    }

	    return result;
	}

	/* ==========================================================
       4. 1:1 문의 및 고객 지원 로직
       ========================================================== */

	// 1:1 문의 리스트 로드
	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectInquiryList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace(); 
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage()); 
		}
		return resultMap;
	}

	// 문의 답변 저장 (답변 등록 및 문의 상태 'ANSWERED'로 일괄 변경)
	public HashMap<String, Object> saveInquiryAnswer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.insertInquiryAnswer(map); // 답변 insert/update
			mapper.updateInquiryStatus(map); // 상태 변경
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
		}
		return resultMap;
	}

	// 관리자 헤더/사이드바용 미답변 문의 개수(배지) 조회
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

	/* ==========================================================
       5. 회원 관리 로직
       ========================================================== */

	// 회원 리스트 및 회원 요약 통계 조회
	public HashMap<String, Object> getMemberList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);
			result.put("result", "success");
			result.put("list", mapper.selectMemberList(map));
			result.put("totalCount", mapper.selectMemberCount(map));
			result.put("summary", mapper.selectMemberSummary());
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// 회원 활동 상태 변경 (정상, 정지, 탈퇴 등)
	public HashMap<String, Object> updateMemberStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateMemberStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	/* ==========================================================
       6. 상품 및 장비 관리 로직
       ========================================================== */

	// 관리자용 상품 목록 조회 (재고 및 노출 상태 포함)
	public HashMap<String, Object> getAdminProductList(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        if (map.get("offset") == null) {
	            int page     = Integer.parseInt(String.valueOf(map.getOrDefault("page",     "1")));
	            int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "20")));
	            map.put("offset",   (page - 1) * pageSize);
	            map.put("pageSize", pageSize);
	        } else {
	            // ★ 문자열로 넘어온 경우 int로 변환
	            map.put("offset",   Integer.parseInt(String.valueOf(map.get("offset"))));
	            map.put("pageSize", Integer.parseInt(String.valueOf(map.get("pageSize"))));
	        }
	        result.put("result",     "success");
	        result.put("list",       mapper.selectAdminProductList(map));
	        result.put("totalCount", mapper.selectAdminProductCount(map));
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	    }
	    return result;
	}

	// 상품 통합 등록 (기본 정보 + 상세 사양 + 주요 특징 일괄 처리)
	@Transactional
	public HashMap<String, Object> updateFullProduct(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        mapper.updateProduct(map);

	        // 이미지가 있을 때만 처리
	        if (map.get("imgUrl") != null && !map.get("imgUrl").toString().isEmpty()) {
	            mapper.deleteMainProductImg(map);   // 기존 메인 이미지 삭제
	            mapper.insertMainProductImg(map);   // 새 이미지 INSERT
	        }

	        mapper.updateProductSpec(map);
	        mapper.updateProductFeature(map);
	        r.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        r.put("result", "fail");
	    }
	    return r;
	}
	@Transactional
	public HashMap<String, Object> insertFullProduct(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        mapper.insertProduct(map); // 1. 상품 등록 (keyProperty="productId"로 ID 생성됨)
	        
	        if (map.get("imgUrl") != null) {
	            mapper.insertProductImg(map); // 2. 생성된 ID로 이미지 등록
	        }
	        r.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        r.put("result", "fail");
	    }
	    return r;
	}
	@Transactional
	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        // 하위 테이블 데이터부터 삭제 (참조 무결성 유지)
	        mapper.deleteProductImg(map);
	        mapper.deleteProductSpec(map);
	        mapper.deleteProductFeature(map);
	        
	        // 최종적으로 상품 정보 삭제
	        mapper.deleteProduct(map);
	        
	        r.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        r.put("result", "fail");
	        r.put("message", "삭제 중 오류가 발생했습니다.");
	    }
	    return r;
	}
	// 상품 기본 정보만 등록
	public HashMap<String, Object> insertProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.insertProduct(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
			r.put("message", e.getMessage());
		}
		return r;
	}

	// 상품 정보 수정
	public HashMap<String, Object> updateProduct(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProduct(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

	// 상품 판매/대여 가능 여부 토글
	public HashMap<String, Object> toggleProductAvail(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.updateProductAvail(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}
	
	public HashMap<String, Object> getProductStockList(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        r.put("result", "success");
	        r.put("list", mapper.selectProductStockList(map));
	    } catch (Exception e) { e.printStackTrace(); r.put("result", "fail"); }
	    return r;
	}

	public HashMap<String, Object> updateProductStock(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.updateProductStock(map); r.put("result", "success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result", "fail"); }
	    return r;
	}

	public HashMap<String, Object> addProductStock(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.insertProductStock(map); r.put("result", "success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result", "fail"); }
	    return r;
	}
	// 상세 이미지 목록
	public HashMap<String, Object> getDetailImages(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { r.put("result","success"); r.put("list", mapper.selectDetailImages(map)); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}
	 
	// 상세 이미지 삭제
	public HashMap<String, Object> removeDetailImage(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.deleteDetailImage(map); r.put("result","success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}
	 
	// 옵션 전체 조회 (그룹 + 값 + 아이템)
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
	        r.put("items",  mapper.selectOptionItems(map));
	    } catch (Exception e) {
	        e.printStackTrace(); r.put("result","fail");
	    }
	    return r;
	}
	 
	// 옵션 그룹 추가
	public HashMap<String, Object> addOptionGroup(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.insertOptionGroup(map); r.put("result","success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); r.put("message", e.getMessage()); }
	    return r;
	}
	 
	// 옵션 그룹 삭제 (값도 같이 삭제 — ON DELETE CASCADE 설정 필요)
	@Transactional
	public HashMap<String, Object> removeOptionGroup(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        // 값 먼저 삭제
	        HashMap<String, Object> param = new HashMap<>();
	        param.put("optionGroupId", map.get("optionGroupId"));
	        List<Map<String, Object>> vals = mapper.selectOptionValues(param);
	        for (Map<String, Object> v : vals) {
	            HashMap<String, Object> vp = new HashMap<>();
	            vp.put("optionValueId", v.get("optionValueId"));
	            mapper.deleteOptionValue(vp);
	        }
	        mapper.deleteOptionGroup(map);
	        r.put("result","success");
	    } catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}
	 
	// 옵션 값 추가
	public HashMap<String, Object> addOptionValue(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.insertOptionValue(map); r.put("result","success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); r.put("message", e.getMessage()); }
	    return r;
	}
	 
	// 옵션 값 삭제
	public HashMap<String, Object> removeOptionValue(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.deleteOptionValue(map); r.put("result","success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}
	 
	// 옵션 아이템 판매 상태 변경
	public HashMap<String, Object> updateOptionItemAvail(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try { mapper.updateOptionItemAvail(map); r.put("result","success"); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
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
	        e.printStackTrace(); result.put("result", "fail");
	    }
	    return result;
	}

	/* ==========================================================
       7. 리뷰 및 이벤트 관리 로직
       ========================================================== */
	
	// 관리자용 상품 리뷰 전체 조회 (작성자와 상품 정보 매핑)
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

	// 부적절 리뷰 삭제 처리
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

	// 이벤트 및 프로모션 리스트 조회
	public HashMap<String, Object> getEventList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);
			result.put("result", "success");
			result.put("list", mapper.selectEventList(map));
			result.put("totalCount", mapper.selectEventCount());
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// 이벤트 신규 저장 및 수정 (ID 존재 여부에 따라 분기)
	@Transactional
	public HashMap<String, Object> saveEvent(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        // 1. 등록인가 수정인가 판단 (eventId가 없거나 빈 문자열이면 등록)
	        if (map.get("eventId") == null || String.valueOf(map.get("eventId")).equals("")) {
	            // [등록 로직]
	            mapper.insertEvent(map); 
	            // 🚨 MyBatis의 useGeneratedKeys 덕분에 map에 eventId가 자동으로 채워집니다.
	            System.out.println("신규 등록된 ID: " + map.get("eventId"));
	        } else {
	            // [수정 로직]
	            mapper.updateEvent(map);
	            System.out.println("기존 데이터 수정 ID: " + map.get("eventId"));
	        }
	        
	        // 2. 이미지 처리 (등록/수정 공통)
	        // 위에서 등록된 혹은 넘어온 eventId가 map에 있으므로 그대로 사용합니다.
	        if (map.get("img_path") != null && !map.get("img_path").toString().equals("")) {
	            mapper.updateEventImage(map);
	        }
	        
	        r.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        r.put("result", "fail");
	        r.put("message", "저장 중 오류 발생: " + e.getMessage());
	    }
	    return r;
	}
	// 등록된 이벤트 삭제
	public HashMap<String, Object> deleteEvent(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteEvent(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

	/* ==========================================================
       8. 대여 현황 및 캠핑장 관리 로직
       ========================================================== */

	// 관리자 대여 목록 조회 (대여중, 반납완료 등 상태 포함)
	public HashMap<String, Object> getAdminRentalList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);

			result.put("list", mapper.selectAdminRentalList(map));
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// 대여 상태 변경
	public HashMap<String, Object> updateRentalStatus(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateRentalStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	// 대여 반납 예정일 연장/수정
	public HashMap<String, Object> updateRentalDate(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateRentalDate(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace(); 
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	// 캠핑장 리스트 로드
	public HashMap<String, Object> getCampList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectCampList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 캠핑장 예약 가능 상태(노출 여부) 변경
	public HashMap<String, Object> updateCampStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			mapper.updateCampStatus(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 캠핑장 상세 정보 로드
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

	// 캠핑장 기본 정보 수정
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
	// ★ 캠핑장 신규 등록
	@Transactional
	public HashMap<String, Object> addCamp(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        mapper.insertCamp(map);  // camp 테이블 INSERT
	        // imgUrl이 있으면 camp_img에도 등록
	        if (map.get("imgUrl") != null && !map.get("imgUrl").toString().isEmpty()) {
	            mapper.insertCampImg(map);
	        }
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "error");
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}

	// 캠핑장 데이터 완전 삭제
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

	/* ==========================================================
       9. 쿠폰 및 기타 통계 서비스
       ========================================================== */

	// 기간별 매출 데이터 조회
	public HashMap<String, Object> getSalesData(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			r.put("result", "success");
			r.put("list", mapper.selectSalesByPeriod(map));
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

	// 상품/페이지 조회수 통계 로드
	public HashMap<String, Object> getViewStats(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			map.put("pageSize", map.getOrDefault("pageSize", "20"));
			r.put("result", "success");
			r.put("list", mapper.selectViewStats(map));
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

	// 상품별 인기 순위(조회수 기준) 조회
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
	
	// --- [1] 쿠폰 마스터 관리 ---

	/* ==========================================================
    9. 쿠폰 마스터 및 유저 쿠폰 통합 관리 서비스
    ========================================================== */

 // --- [1] 쿠폰 마스터 관리 (Master) ---

 // 쿠폰 마스터 목록 조회
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

 // 쿠폰 마스터 저장 (신규 등록 / 기존 수정)
 @Transactional
 public HashMap<String, Object> saveCoupon(HashMap<String, Object> map) {
     HashMap<String, Object> resultMap = new HashMap<>();
     try {
         // couponId가 없으면 insert, 있으면 update
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

 // 쿠폰 마스터 상태 변경 (활성/비활성)
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

 // 쿠폰 마스터 삭제
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


 // --- [2] 유저 보유 쿠폰 관리 (User Coupon) ---

 // ✨ 모든 유저에게 쿠폰 일괄 발송 (전체 지급)
 @Autowired AlarmService alarmService;
 public HashMap<String, Object> giveCouponToAll(HashMap<String, Object> map) {
     HashMap<String, Object> resultMap = new HashMap<>();
     try {
         mapper.insertCouponToAllUsers(map);
         resultMap.put("result", "success");
     } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "error");
     }
     return resultMap;
 }

 // ✨ 특정 유저에게 쿠폰 개별 발송 (개별 지급)
 public HashMap<String, Object> giveCouponToUser(HashMap<String, Object> map) {
     HashMap<String, Object> resultMap = new HashMap<>();
     try {
         mapper.insertUserCoupon(map);
         alarmService.createAlarm(
        		    String.valueOf(map.get("userId")), "EVENT",
        		    "쿠폰이 발급되었습니다 🎫",
        		    "새로운 쿠폰이 지급되었습니다. 마이페이지에서 확인하세요.", null);
         resultMap.put("result", "success");
     } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "error");
     }		
     return resultMap;
 }

 // 유저별 쿠폰 보유 현황 조회 (조인 리스트)
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

 // 유저 쿠폰 사용 상태 강제 변경 (사용완료/미사용)
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

 // 발급된 유저 쿠폰 회수 (삭제)
 @Transactional


 // [유저 보유 쿠폰 삭제/회수]
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
	        e.printStackTrace();
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
	        e.printStackTrace();
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
	        e.printStackTrace();
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
	            // 전체 발송
	            count = mapper.insertAlarmToAllUsers(map);
	 
	        } else if ("SELECT".equals(sendType)) {
	            // 선택 발송 — userIds: "user01,user02,user03"
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
	            // 개별 발송
	            mapper.insertAlarm(map);
	            count = 1;
	        }
	 
	        result.put("result", "success");
	        result.put("count",  count);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	        result.put("message", e.getMessage());
	    }
	    return result;
	}
	 
	// 발송 내역 조회
	public HashMap<String, Object> getAlarmLogs(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        int page     = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
	        int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
	        map.put("offset", (page - 1) * pageSize);
	        map.put("pageSize", pageSize);
	        result.put("result", "success");
	        result.put("list",   mapper.selectAlarmLogs(map));
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	    }
	    return result;
	}
	 
	// 회원 단건 조회
	public HashMap<String, Object> findMember(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        HashMap<String, Object> user = mapper.selectMemberById(map);
	        if (user != null) {
	            result.put("result", "success");
	            result.put("user",   user);
	        } else {
	            result.put("result",  "fail");
	            result.put("message", "존재하지 않는 회원입니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "fail");
	    }
	    return result;
	}
	// AdminService.java 추가
	@Transactional
	public HashMap<String, Object> registerDelivery(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        mapper.upsertDelivery(map);
	        map.put("status", "SHIPPING");
	        mapper.updateOrderStatus(map);

	        // ★ orderInfo 조회 추가
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("orderId", map.get("orderId"));
	        HashMap<String, Object> orderInfo = mapper.selectOrderById(orderMap);

	        if (orderInfo != null && orderInfo.get("userId") != null) {
	            String uid = String.valueOf(orderInfo.get("userId"));
	            alarmService.createAlarm(uid, "DELIVERY",
	                "상품이 출발했습니다 🚚",
	                "운송장 번호: " + map.get("trackingNo"), map.get("orderId"));
	        }

	        result.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
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
	        e.printStackTrace(); result.put("result", "fail");
	    }
	    return result;
	}
	
	public HashMap<String, Object> getInspectionList() {
	    HashMap<String, Object> r = new HashMap<>();
	    try { r.put("result","success"); r.put("list", mapper.selectInspectionList()); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}

	public HashMap<String, Object> saveInspection(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        mapper.insertReturnInspection(map);
	        // 파손/분실 시 알람
	        String userId = String.valueOf(map.get("userId"));
	        String code   = String.valueOf(map.get("conditionCode"));
	        if (!"GOOD".equals(code) && !"GUEST".equals(userId)) {
	            String msg = "DAMAGED".equals(code)
	                ? "반납 물품에 파손이 확인되어 " + map.get("deductionAmt") + "원이 공제됩니다."
	                : "반납 물품 분실이 확인되어 배상금이 청구됩니다.";
	            alarmService.createAlarm(userId, "NOTICE", "검수 결과 안내 📋", msg, map.get("rentalId"));
	        }
	        r.put("result","success");
	    } catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}

	public HashMap<String, Object> getRefundList() {
	    HashMap<String, Object> r = new HashMap<>();
	    try { r.put("result","success"); r.put("list", mapper.selectRefundList()); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}

	public HashMap<String, Object> getExchangeList() {
	    HashMap<String, Object> r = new HashMap<>();
	    try { r.put("result","success"); r.put("list", mapper.selectExchangeList()); }
	    catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}

	public HashMap<String, Object> updateExchangeStatus(HashMap<String, Object> map) {
	    HashMap<String, Object> r = new HashMap<>();
	    try {
	        mapper.updateExchangeStatus(map);
	        // 교환 승인/거절 알람
	        String userId = String.valueOf(map.get("userId"));
	        String status = String.valueOf(map.get("status"));
	        if (!"GUEST".equals(userId)) {
	            if ("APPROVED".equals(status)) {
	                alarmService.createAlarm(userId, "NOTICE", "교환 신청이 승인되었습니다 ✅",
	                    "교환이 승인되었습니다. 새 상품이 곧 발송됩니다.", map.get("exchangeId"));
	            } else if ("REJECTED".equals(status)) {
	                alarmService.createAlarm(userId, "NOTICE", "교환 신청이 거절되었습니다 ❌",
	                    "교환 신청이 거절되었습니다. 문의사항은 고객센터로 연락해주세요.", map.get("exchangeId"));
	            }
	        }
	        r.put("result","success");
	    } catch (Exception e) { e.printStackTrace(); r.put("result","fail"); }
	    return r;
	}
	public void updateRefundStatus(Map<String, Object> map) {
	    mapper.updateRefundStatus(map);
	}
	
}