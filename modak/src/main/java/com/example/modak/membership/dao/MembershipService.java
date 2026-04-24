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

	    String userId = (String) map.get("userId");

	    refreshUserGrade(userId);

	    MembershipInfo info = membershipMapper.selectMembershipInfo(map);

	    if (info == null) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "멤버십 정보가 없습니다.");
	        return resultMap;
	    }

	    resultMap.put("result", "success");
	    resultMap.put("info", info);
	    resultMap.put("allGrades", membershipMapper.selectAllGrades());
	    
	    return resultMap;
	}

	public void refreshUserGrade(String userId) {
	    HashMap<String, Object> param = new HashMap<>();
	    param.put("userId", userId);

	    MembershipInfo info = membershipMapper.selectMembershipInfo(param);

	    if (info == null) {
	        return;
	    }

	    int newGradeId = getGradeIdByAmount(info.getTotalAmount());

	    if (info.getGradeId() != newGradeId) {
	        HashMap<String, Object> updateMap = new HashMap<>();
	        updateMap.put("userId", userId);
	        updateMap.put("gradeId", newGradeId);

	        membershipMapper.updateUserGrade(updateMap);
	    }
	}

	private int getGradeIdByAmount(int totalAmount) {
	    if (totalAmount >= 300000) {
	        return 4;
	    } else if (totalAmount >= 100000) {
	        return 3;
	    } else if (totalAmount >= 30000) {
	        return 2;
	    } else {
	        return 1;
	    }
	}

	// 등급 목록 조회
	public HashMap<String, Object> getGradeList() {
		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap.put("result", "success");
		resultMap.put("grades", membershipMapper.selectAllGrades());

		return resultMap;
	}

	// FAQ 목록 조회
	public HashMap<String, Object> getFaqList() {
		HashMap<String, Object> resultMap = new HashMap<>();

		resultMap.put("result", "success");
		resultMap.put("faqs", membershipMapper.selectFaqList());

		return resultMap;
	}
}