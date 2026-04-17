package com.example.modak.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.User;

@Mapper
public interface MypageMapper {
	
	// 마이페이지 들어올 때 유저 조회
    User selectMypageUser(@Param("userId") String userId);
    
    // 마이페이지 유저 정보 요약
    MypageSummary selectMypageSummary(@Param("userId") String userId);
}