package com.example.modak.membership.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.membership.model.MembershipInfo;

@Mapper
public interface MembershipMapper {
	
	MembershipInfo selectMembershipInfo(HashMap<String, Object> map);

	void updateUserGrade(HashMap<String, Object> map);

	List<MembershipInfo> selectAllGrades();

	List<HashMap<String, Object>> selectFaqList();
}	
