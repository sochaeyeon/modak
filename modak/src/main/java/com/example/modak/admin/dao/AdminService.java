package com.example.modak.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.modak.admin.mapper.AdminMapper;
import com.google.gson.JsonElement;

@Service
public class AdminService {

	@Autowired
	private AdminMapper mapper;

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
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateOrderStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "상태 변경 실패: " + e.getMessage());
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
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);
			result.put("result", "success");
			result.put("list", mapper.selectAdminProductList(map));
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
	        mapper.updateProduct(map);        // 1. product 테이블 수정
	        mapper.updateProductImg(map);     // 2. product_img 테이블 수정 (ON DUPLICATE KEY)
	        mapper.updateProductSpec(map);    // 3. product_spec 테이블 수정 (ON DUPLICATE KEY)
	        mapper.updateProductFeature(map); // 4. product_feature 테이블 수정 (ON DUPLICATE KEY)
	        
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
	
}