package com.example.modak.membership.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.membership.mapper.MembershipMapper;
import com.example.modak.membership.model.MembershipInfo;

@Service
public class MembershipService {
	
	@Autowired
	MembershipMapper membershipMapper;
	
	// 멤버십 정보 조회
	public HashMap<String, Object> getMembershipInfo(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    MembershipInfo info = membershipMapper.selectMembershipInfo(map);

	    resultMap.put("result", "success");
	    resultMap.put("info", info);

	    return resultMap;
	}
}
