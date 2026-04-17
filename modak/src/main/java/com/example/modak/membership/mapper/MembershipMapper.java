package com.example.modak.membership.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.membership.model.MembershipInfo;

@Mapper
public interface MembershipMapper {
	
	// 멤버십 정보 조회
    MembershipInfo selectMembershipInfo(HashMap<String, Object> map);

    // 멤버십 정보 갱신
    int updateUserGrade(HashMap<String, Object> map);
}	
