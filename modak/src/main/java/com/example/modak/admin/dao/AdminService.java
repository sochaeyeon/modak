package com.example.modak.admin.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.admin.mapper.AdminMapper;

@Service
public class AdminService {

	@Autowired
	private AdminMapper mapper;

	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	/* ─── 관리자 인증 (BCrypt + 시각 업데이트) ─── */
	public HashMap<String, Object> adminLogin(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		String id = (String) map.get("id");
		String pw = (String) map.get("password");

		HashMap<String, Object> admin = mapper.selectAdminById(id);

		if (admin != null) {
			// 암호화 비밀번호 비교
			if (passwordEncoder.matches(pw, (String) admin.get("password"))) {
				mapper.updateAdminLoginDate(id); // 로그인 시각 업데이트
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

	/* ─── 대시보드 통계 데이터 ─── */
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
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

	/* ─── 주문 관리 ─── */

	// 주문 목록 조회 (페이징 포함)
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

	// 주문 상태 수정
	public HashMap<String, Object> updateOrderStatus(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			// XML의 updateOrderStatus 쿼리 호출
			mapper.updateOrderStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "상태 변경 실패: " + e.getMessage());
		}
		return result;
	}

	/* ─── 고객 문의 관리 ─── */
	public HashMap<String, Object> getWaitingInquiryCount() {
		HashMap<String, Object> r = new HashMap<>();
		r.put("count", mapper.selectWaitingInquiryCount());
		return r;
	}

	public HashMap<String, Object> getAdminInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);
			result.put("result", "success");
			result.put("list", mapper.selectAdminInquiryList(map));
			result.put("totalCount", mapper.selectAdminInquiryCount(map));
			result.put("waitCount", mapper.selectWaitingInquiryCount());
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> replyInquiry(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.insertInquiryReply(map);
			map.put("status", "DONE");
			mapper.updateInquiryStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	/* ─── 회원 관리 ─── */
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

	public HashMap<String, Object> updateMemberStatus(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			mapper.updateMemberStatus(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	/* ─── 상품 관리 ─── */
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

	/* ─── 리뷰 및 이벤트 관리 ─── */
	public HashMap<String, Object> getAdminReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
			int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);
			result.put("result", "success");
			result.put("list", mapper.selectAdminReviewList(map));
			result.put("totalCount", mapper.selectAdminReviewCount(map));
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> deleteReview(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			mapper.deleteReview(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

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

	public HashMap<String, Object> saveEvent(HashMap<String, Object> map) {
		HashMap<String, Object> r = new HashMap<>();
		try {
			if (map.get("eventId") != null && !map.get("eventId").toString().isEmpty())
				mapper.updateEvent(map);
			else
				mapper.insertEvent(map);
			r.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			r.put("result", "fail");
		}
		return r;
	}

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

	/* ─── 통계 데이터 ─── */
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

	/* ─── 대여 관리 ─── */

	// 대여 목록 조회 (페이징 포함)
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

	// 대여 상태 수정
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

	public HashMap<String, Object> updateRentalDate(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			// map에 rentalId와 returnDate가 잘 넘어오는지 확인
			System.out.println("변경 요청 데이터: " + map);
			mapper.updateRentalDate(map);
			result.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace(); // 💡 이 로그가 이클립스/인텔리제이 콘솔에 찍힙니다!
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}
}