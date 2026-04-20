package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.csCenter.mapper.InquiryMapper;
import com.example.modak.csCenter.model.Inquiry;

// 규칙
// 검색 - get, 삭제 - remove, 수정 - edit, 추가 - add
@Service
public class InquiryService {

	@Autowired
	InquiryMapper inquiryMapper;

	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Inquiry> list = inquiryMapper.selectInquiryList(map);

		resultMap.put("list", list);
		resultMap.put("message", "데이터 조회 성공");
		resultMap.put("result", "success");

		return resultMap;
	}

}
