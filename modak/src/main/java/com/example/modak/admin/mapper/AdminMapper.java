package com.example.modak.admin.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {

    /* ==========================================================
       1. 관리자 인증 및 계정 (Admin Auth)
       ========================================================== */
    // ID를 통한 관리자 정보 상세 조회 (로그인 검증용)
    HashMap<String, Object> selectAdminById(String adminId); 

    // 관리자 로그인 성공 시 마지막 접속 시각 갱신
    void updateAdminLoginDate(String adminId); 


    /* ==========================================================
       2. 대시보드 및 통계 (Dashboard & Stats)
       ========================================================== */
    // 당월(이번 달) 누적 매출액 조회
    long selectMonthSales(); 

    // 전월(지난 달) 누적 매출액 조회 (매출 비교용)
    long selectLastMonthSales(); 

    // 현재 진행 중인 주문(결제완료, 배송중 등) 현황 요약
    Map<String, Object> selectActiveOrders(); 

    // 서비스 전체 회원 수 조회
    int selectTotalUsers(); 

    // 당일 또는 특정 기간 신규 가입자 수 조회
    int selectNewUsers(); 

    // 현재 대여 중인 장비/상품의 총 개수
    int selectRentingCount(); 

    // 아직 관리자가 응답하지 않은 미답변 문의 건수
    int selectWaitingInquiryCount(); 

    // 서비스 전체 누적 문의 건수
    int selectTotalInquiryCount(); 

    // 월별 매출 추이 데이터 (대시보드 막대/선 차트용)
    List<HashMap<String, Object>> selectMonthlySales(); 

    // 최근 발생한 주문 내역 상위 5건 조회
    List<HashMap<String, Object>> selectRecentOrders(); 

    // 최근 들어온 미답변 문의 상위 5건 조회
    List<HashMap<String, Object>> selectWaitingInquiries(); 

    // 누적 판매/대여 수가 높은 인기 상품 상위 5개
    List<HashMap<String, Object>> selectTopProducts(); 

    // 회원 등급별(일반, 우수 등) 분포 통계
    List<HashMap<String, Object>> selectGradeStats(); 


    /* ==========================================================
       3. 주문 관리 (Order Management)
       ========================================================== */
    // 관리자용 주문 목록 통합 조회 (검색 및 필터 포함)
    List<Map<String, Object>> selectAdminOrderList(HashMap<String, Object> map); 

    // 주문 목록 페이징 처리를 위한 전체 데이터 개수 조회
    int selectAdminOrderCount(HashMap<String, Object> map); 

    // 주문 상태(결제완료 -> 배송중 -> 배송완료 등) 변경 처리
    void updateOrderStatus(HashMap<String, Object> map); 


    /* ==========================================================
       4. 1:1 문의 관리 (Inquiry Management)
       ========================================================== */
    // 고객 문의 리스트 조회 (미답변/답변완료 필터링 포함)
    List<Map<String, Object>> selectInquiryList(HashMap<String, Object> map);

    // 문의에 대한 관리자 답변 내용 등록
    void insertInquiryAnswer(HashMap<String, Object> map);

    // 문의 답변 완료 후 진행 상태 업데이트 (WAITING -> ANSWERED)
    void updateInquiryStatus(HashMap<String, Object> map);
    
    // 이미 작성된 문의 답변 내용 수정
    void updateInquiryAnswer(HashMap<String, Object> map);


    /* ==========================================================
       5. 회원 관리 (User Management)
       ========================================================== */
    // 가입된 회원 전체 리스트 조회 (검색 및 페이징)
    List<HashMap<String, Object>> selectMemberList(HashMap<String, Object> map);

    // 검색 조건에 맞는 전체 회원 수 조회 (페이징용)
    int selectMemberCount(HashMap<String, Object> map);

    // 회원 통계 요약 (성별, 연령대, 신규 가입 현황 등)
    HashMap<String, Object> selectMemberSummary();

    // 회원 상태 수정 (정상, 정지, 탈퇴 처리 등)
    void updateMemberStatus(HashMap<String, Object> map);


    /* ==========================================================
       6. 상품 및 장비 관리 (Product Management)
       ========================================================== */
 // 상품 목록 조회 및 카운트
    List<Map<String, Object>> selectAdminProductList(HashMap<String, Object> map);
    int selectAdminProductCount(HashMap<String, Object> map);

    // 상품 등록/수정
    void insertProduct(HashMap<String, Object> map);       // 기본 정보
    void insertProductImg(HashMap<String, Object> map);    // 이미지 신규 등록
    int updateProduct(HashMap<String, Object> map);       // 기본 정보 수정
    void updateProductImg(HashMap<String, Object> map);    // 이미지 수정(OR 등록)

    // 상세 사양 및 특징 (Spec/Feature)
    void insertProductSpec(HashMap<String, Object> map);
    void updateProductSpec(HashMap<String, Object> map);
    void insertProductFeature(HashMap<String, Object> map);
    void updateProductFeature(HashMap<String, Object> map);

    // 상품 상태 및 조회수
    void updateProductAvail(HashMap<String, Object> map);
    void updateProductViewCount(HashMap<String, Object> map);
    
    void deleteProductImg(HashMap<String, Object> map);
    void deleteProductSpec(HashMap<String, Object> map);
    void deleteProductFeature(HashMap<String, Object> map);
    void deleteProduct(HashMap<String, Object> map);


    /* ==========================================================
       7. 리뷰 및 이벤트 관리 (Review & Event)
       ========================================================== */
    // 고객이 작성한 전체 리뷰 리스트 조회 (관리자용)
    List<Map<String, Object>> selectAdminReviewList(HashMap<String, Object> map);

    // 리뷰 목록 조회 (일반 사용자/페이징용)
    List<Map<String, Object>> selectReviewList(HashMap<String, Object> map);

    // 부적절하거나 요청된 리뷰 삭제 처리
    void deleteReview(HashMap<String, Object> map);

    // 진행 중이거나 종료된 이벤트 목록 조회
    List<HashMap<String, Object>> selectEventList(HashMap<String, Object> map);

    // 전체 이벤트 등록 건수 조회
    int selectEventCount();

    // 신규 배너/이벤트 등록
    void insertEvent(HashMap<String, Object> map);

    // 이벤트 내용 및 이미지 경로 수정 (현재 에러 발생 지점)
    void updateEvent(HashMap<String, Object> map);
    
    // 이벤트 이미지 경로 수정/등록
    void updateEventImage(HashMap<String, Object> map);

    // 등록된 이벤트 삭제
    void deleteEvent(HashMap<String, Object> map);
    void deleteEventImages(HashMap<String, Object> map);

    /* ==========================================================
       8. 대여 및 캠핑장 관리 (Rental & Camp)
       ========================================================== */
    // 대여 상품 전용 목록 조회 및 관리
    List<Map<String, Object>> selectAdminRentalList(HashMap<String, Object> map); 

    // 대여 진행 상태 수정 (예약완료, 사용중, 반납완료 등)
    void updateRentalStatus(HashMap<String, Object> map);

    // 대여 기간 연장 및 반납 예정일 변경
    void updateRentalDate(HashMap<String, Object> map);

    // 등록된 캠핑장 목록 조회
    List<Map<String, Object>> selectCampList(HashMap<String, Object> map);

    // 캠핑장 사이트 노출 상태(Y/N) 및 예약 가능 여부 수정
    void updateCampStatus(HashMap<String, Object> map);

    // 특정 캠핑장의 상세 정보 조회
    Map<String, Object> selectCampDetail(HashMap<String, Object> map);

    // 캠핑장 정보(이름, 위치, 시설 등) 수정
    void updateCampInfo(HashMap<String, Object> map);

    // 캠핑장 데이터 삭제
    void deleteCamp(HashMap<String, Object> map);


    /* ==========================================================
       9. 쿠폰 및 부가 통계 (Coupon & Extra Stats)
       ========================================================== */
    // 기간별/카테고리별 매출 통계 데이터 상세 조회
    List<HashMap<String, Object>> selectSalesByPeriod(HashMap<String, Object> map);

    // 페이지/상품별 조회수 및 방문자 통계
    List<HashMap<String, Object>> selectViewStats(HashMap<String, Object> map);

    // 상품별 실시간 조회수 순위 통계
    List<Map<String, Object>> selectProductViewStats();

    // 생성된 쿠폰 목록 및 발급 현황 조회
    List<Map<String, Object>> selectCouponList(HashMap<String, Object> map);

    // 쿠폰 사용 가능 여부 활성화/비활성화 전환
    void updateCouponStatus(HashMap<String, Object> map);

}