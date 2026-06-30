package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.user.mapper.CouponMapper;
import com.example.modak.user.model.UserCoupon;

@Service
public class CouponService {

    @Autowired
    CouponMapper couponMapper;

//  회원가입 웰컴쿠폰 발급
    @Transactional
    public void issueWelcomeCoupon(String userId) {
        Long couponId = couponMapper.selectWelcomeCouponId();

        if (couponId == null) {
            return;
        }

        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("couponId", couponId);

        couponMapper.insertUserCoupon(param);

        param.put("issueReason", "회원가입 웰컴쿠폰");
        couponMapper.insertCouponIssueLog(param);
    }

//  주문 시 쿠폰 사용 처리
    @Transactional
    public void useCoupon(String userId, Long userCouponId, Long orderId, int discountAppliedAmt) {
        HashMap<String, Object> selectParam = new HashMap<>();
        selectParam.put("userCouponId", userCouponId);

        UserCoupon userCoupon = couponMapper.selectUserCouponById(selectParam);

        if (userCoupon == null) {
            throw new RuntimeException("존재하지 않는 사용자 쿠폰입니다.");
        }

        if (!userId.equals(userCoupon.getUserId())) {
            throw new RuntimeException("본인 쿠폰만 사용할 수 있습니다.");
        }

        if (!"N".equals(userCoupon.getUsedYn())) {
            throw new RuntimeException("이미 사용한 쿠폰입니다.");
        }

        if (!"AVAILABLE".equals(userCoupon.getStatus())) {
            throw new RuntimeException("사용 가능한 쿠폰 상태가 아닙니다.");
        }

        HashMap<String, Object> updateParam = new HashMap<>();
        updateParam.put("userCouponId", userCouponId);
        updateParam.put("userId", userId);
        updateParam.put("orderId", orderId);

        int updateCnt = couponMapper.updateUserCouponUsed(updateParam);

        if (updateCnt == 0) {
            throw new RuntimeException("쿠폰 사용 처리에 실패했습니다.");
        }

        HashMap<String, Object> logParam = new HashMap<>();
        logParam.put("userCouponId", userCouponId);
        logParam.put("userId", userId);
        logParam.put("couponId", userCoupon.getCouponId());
        logParam.put("orderId", orderId);
        logParam.put("discountAppliedAmt", discountAppliedAmt);

        couponMapper.insertCouponUseLog(logParam);
    }
    
    public List<UserCoupon> selectMyCouponList(String userId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);

        return couponMapper.selectUserCouponList(map);
    }
    public List<UserCoupon> selectAvailableCouponList(String userId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);

        return couponMapper.selectAvailableUserCouponList(map);
    }
    
    // ↓ 추가
    public UserCoupon selectBestCoupon(String userId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);

        return couponMapper.selectBestCoupon(map);
    }
}