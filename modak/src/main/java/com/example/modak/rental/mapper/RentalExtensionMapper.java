package com.example.modak.rental.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.rental.model.RentalExtension;

@Mapper
public interface RentalExtensionMapper {

    /* ── 회원 ── */
    List<RentalExtension> selectMyRentals(@Param("userId") String userId);

    RentalExtension selectRentalByIdAndUser(@Param("rentalId") Long   rentalId,
                                            @Param("userId")   String userId);

    /* ── 비회원 3중 검증 ── */
    RentalExtension selectGuestRental(@Param("rentalId")   Long   rentalId,
                                      @Param("guestName")  String guestName,
                                      @Param("guestPhone") String guestPhone);

    /* ── 토큰 통과 후 단건 조회 ── */
    RentalExtension selectRentalById(@Param("rentalId") Long rentalId);

    /* ── 연장 내역 ── */
    List<RentalExtension> selectExtensionsByRentalId(@Param("rentalId") Long rentalId);

    /* ── 연장 신청 ── */
    int insertExtension(@Param("rentalId")      Long rentalId,
                        @Param("extensionDays") int  extensionDays,
                        @Param("price")         int  price);

    /* ── 연장 취소 ── */
    int deleteExtension(@Param("extensionId") Long extensionId,
                        @Param("rentalId")    Long rentalId);

    /* ── 반납일 업데이트 (음수=원복) ── */
    int updateReturnDate(@Param("rentalId")      Long rentalId,
                         @Param("extensionDays") int  extensionDays);
    
    List<HashMap<String, Object>> selectReturnableRentals(HashMap<String, Object> map);
    int updateReturnRequest(HashMap<String, Object> map);
    int updateGuestReturnRequest(HashMap<String, Object> map);
    int updateDeliveryReturnRequest(HashMap<String, Object> map);
    
    int cancelReturnRequest(HashMap<String, Object> map);
    int cancelGuestReturnRequest(HashMap<String, Object> map);
    int cancelDeliveryReturnRequest(HashMap<String, Object> map);
   
    HashMap<String, Object> selectDefaultPickupAddress(HashMap<String, Object> map);
    List<HashMap<String, Object>> selectReturnHistoryByRentalId(@Param("rentalId") Long rentalId);
    HashMap<String, Object> selectGuestPickupAddress(HashMap<String, Object> map);
    
}
