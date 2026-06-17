package com.example.modak.user.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.UserCoupon;

@Mapper
public interface CouponMapper {

    // 웰컴 쿠폰 조회
    Long selectWelcomeCouponId();

    // 사용자 쿠폰 발급
    int insertUserCoupon(HashMap<String, Object> map);

    // 쿠폰 발급 로그
    int insertCouponIssueLog(HashMap<String, Object> map);

    // 사용자 쿠폰 단건 조회
    UserCoupon selectUserCouponById(HashMap<String, Object> map);

    // 사용자 쿠폰 사용 처리
    int updateUserCouponUsed(HashMap<String, Object> map);

    // 쿠폰 사용 로그
    int insertCouponUseLog(HashMap<String, Object> map);
    
    List<UserCoupon> selectUserCouponList(HashMap<String, Object> map);

    int selectUserCouponCount(HashMap<String, Object> map);

    int selectAvailableCouponCount(HashMap<String, Object> map);	
    
    List<UserCoupon> selectAvailableUserCouponList(HashMap<String, Object> map);
    
    UserCoupon selectBestCoupon(HashMap<String, Object> map);  // ← 추가
}