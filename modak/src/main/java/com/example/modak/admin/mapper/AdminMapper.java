package com.example.modak.admin.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {
	/* ─── 관리자 인증 ─── */
	HashMap<String, Object> selectAdminById(String adminId); // ID로 관리자 정보 조회

	void updateAdminLoginDate(String adminId); // 로그인 시각 업데이트

	/* ─── 대시보드 통계 ─── */
	long selectMonthSales(); // 이번 달 매출액

	long selectLastMonthSales(); // 지난 달 매출액

	Map<String, Object> selectActiveOrders(); // 진행 중인 주문 현황

	int selectTotalUsers(); // 전체 회원 수

	int selectNewUsers(); // 신규 가입자 수

	int selectRentingCount(); // 대여 중인 상품 수

	int selectWaitingInquiryCount(); // 답변 대기 문의 수

	int selectTotalInquiryCount(); // 전체 문의 건수

	List<HashMap<String, Object>> selectMonthlySales(); // 월별 매출 통계 (차트용)

	List<HashMap<String, Object>> selectRecentOrders(); // 최근 주문 5건

	List<HashMap<String, Object>> selectWaitingInquiries(); // 미답변 문의 5건

	List<HashMap<String, Object>> selectTopProducts(); // 인기 상품 상위 5개

	List<HashMap<String, Object>> selectGradeStats(); // 등급별 회원 분포

	/* ─── 주문 관리 (수정 및 추가) ─── */
	List<Map<String, Object>> selectAdminOrderList(HashMap<String, Object> map); // 주문 목록 조회

	int selectAdminOrderCount(HashMap<String, Object> map); // 주문 목록 개수 (페이징용)

	void updateOrderStatus(HashMap<String, Object> map); // 주문 상태 수정 (배송상태 변경 등)

	/* ─── 고객 문의 관리 ─── */
	List<Map<String, Object>> selectInquiryList(HashMap<String, Object> map);
	void insertInquiryAnswer(HashMap<String, Object> map);
	void updateInquiryStatus(HashMap<String, Object> map);

	// 문의 답변 업데이트
	void updateInquiryAnswer(HashMap<String, Object> map);

	/* ─── 회원 관리 ─── */
	List<HashMap<String, Object>> selectMemberList(HashMap<String, Object> map);

	int selectMemberCount(HashMap<String, Object> map);

	HashMap<String, Object> selectMemberSummary();

	void updateMemberStatus(HashMap<String, Object> map);

	/* ─── 상품 관리 ─── */
	List<HashMap<String, Object>> selectAdminProductList(HashMap<String, Object> map);

	int selectAdminProductCount(HashMap<String, Object> map);

	void insertProduct(HashMap<String, Object> map);

	void updateProduct(HashMap<String, Object> map);

	void updateProductAvail(HashMap<String, Object> map);

	/* ─── 리뷰 및 이벤트 관리 ─── */
	// 수정 후 권장 스타일
	List<Map<String, Object>> selectAdminReviewList(HashMap<String, Object> map);

	// 기존과 동일하게 유지 (이미 좋음)
	List<Map<String, Object>> selectReviewList(HashMap<String, Object> map);

	// 삭제 (동일)
	void deleteReview(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectEventList(HashMap<String, Object> map);

	int selectEventCount();

	void insertEvent(HashMap<String, Object> map);

	void updateEvent(HashMap<String, Object> map);

	void deleteEvent(HashMap<String, Object> map);

	/* ─── 기타 통계 ─── */
	List<HashMap<String, Object>> selectSalesByPeriod(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectViewStats(HashMap<String, Object> map);

	/* ─── 대여 관리 ─── */
	List<Map<String, Object>> selectAdminRentalList(HashMap<String, Object> map); // 대여 목록 조회

	void updateRentalStatus(HashMap<String, Object> map);

	void updateRentalDate(HashMap<String, Object> map);

	List<Map<String, Object>> selectProductViewStats();

	List<Map<String, Object>> selectCampList(HashMap<String, Object> map);

	// 2. 캠핑장 노출 상태 업데이트 (Y/N)
	// XML의 <update id="updateCampStatus">와 이름이 같아야 함
	void updateCampStatus(HashMap<String, Object> map);

	Map<String, Object> selectCampDetail(HashMap<String, Object> map);

	void updateCampInfo(HashMap<String, Object> map);

	void deleteCamp(HashMap<String, Object> map);

	// 쿠폰 목록 조회
	List<Map<String, Object>> selectCouponList(HashMap<String, Object> map);

	// 쿠폰 활성화/비활성화 전환 (IS_ACTIVE: Y/N)
	void updateCouponStatus(HashMap<String, Object> map);

}