package com.example.modak.rental.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RentalCalendarMapper {
    // 날짜 조회
    List<HashMap<String, Object>> selectRentedDates(HashMap<String, Object> params);
    
    // 상품 정보 조회
    HashMap<String, Object> selectProductPrice(HashMap<String, Object> params);
    
    // 대여 신청
    int insertRental(HashMap<String, Object> map);
    
    // 상태 변경 (취소 등)
    int updateRentalStatus(HashMap<String, Object> map);
}