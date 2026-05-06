package com.example.modak.rental.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.rental.model.RentalExtension;

@Mapper
public interface RentalExtensionMapper {

    // ════════════════════════════════════════
    // 대여 조회
    // ════════════════════════════════════════

    /** 회원 대여 목록 */
    List<RentalExtension> selectMyRentals(@Param("userId") String userId);

    /** 회원 단건 조회 */
    RentalExtension selectRentalByIdAndUser(@Param("rentalId") Long rentalId,
                                            @Param("userId")   String userId);

    /** 비회원 3중 검증 조회 */
    RentalExtension selectGuestRental(@Param("rentalId")   Long   rentalId,
                                      @Param("guestName")  String guestName,
                                      @Param("guestPhone") String guestPhone);

    /** 토큰 통과 후 단건 조회 */
    RentalExtension selectRentalById(@Param("rentalId") Long rentalId);

    // ════════════════════════════════════════
    // 연장 내역
    // ════════════════════════════════════════

    /** 연장 내역 목록 조회 */
    List<RentalExtension> selectExtensionsByRentalId(@Param("rentalId") Long rentalId);

    /** 연장 INSERT (HashMap) */
    int insertExtension(HashMap<String, Object> map);

    /** 연장 DELETE (HashMap: extensionId, rentalId) */
    int deleteExtension(HashMap<String, Object> map);

    /** 반납일 업데이트 (HashMap: rentalId, extensionDays — 음수면 원복) */
    int updateReturnDate(HashMap<String, Object> map);

    // ════════════════════════════════════════
    // 반납 내역
    // ════════════════════════════════════════

    /** 반납 신청 내역 조회 */
    List<HashMap<String, Object>> selectReturnHistoryByRentalId(@Param("rentalId") Long rentalId);

    /** 반납 신청 가능 목록 (회원) */
    List<HashMap<String, Object>> selectReturnableRentals(HashMap<String, Object> map);

    /** 회원 반납 신청 */
    int updateReturnRequest(HashMap<String, Object> map);

    /** 비회원 반납 신청 */
    int updateGuestReturnRequest(HashMap<String, Object> map);

    /** 배송 상태 반납요청으로 변경 */
    int updateDeliveryReturnRequest(HashMap<String, Object> map);

    /** 회원 반납 취소 */
    int cancelReturnRequest(HashMap<String, Object> map);

    /** 비회원 반납 취소 */
    int cancelGuestReturnRequest(HashMap<String, Object> map);

    /** 배송 상태 원복 */
    int cancelDeliveryReturnRequest(HashMap<String, Object> map);

    // ════════════════════════════════════════
    // 픽업 주소
    // ════════════════════════════════════════

    /** 회원 기본 픽업 주소 */
    HashMap<String, Object> selectDefaultPickupAddress(HashMap<String, Object> map);

    /** 비회원 픽업 주소 (배송지 기반) */
    HashMap<String, Object> selectGuestPickupAddress(HashMap<String, Object> map);

    // ════════════════════════════════════════
    // 연장 결제 주문 (RENTAL_EXTENSION_ORDER)
    // ════════════════════════════════════════

    /** 연장 결제 주문 INSERT — extensionOrderId 자동 반환 */
    int insertExtensionOrder(HashMap<String, Object> map);

    /** 연장 결제 주문 단건 조회 */
    HashMap<String, Object> selectExtensionOrder(HashMap<String, Object> map);

    /** 연장 결제 주문 상태 업데이트 (PENDING → PAID / FAILED) */
    int updateExtensionOrderStatus(HashMap<String, Object> map);
    
    List<RentalExtension> selectGuestRentalListByOrder(@Param("orderId") String orderId);
    RentalExtension selectGuestRentalByPhone(HashMap<String, Object> map);
}