package com.example.modak.csCenter.dao;

import com.example.modak.csCenter.mapper.CsCenterMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class csCenterService {

	@Autowired
	private CsCenterMapper csCenterMapper;

	/**
	 * FAQ 목록 조회
	 * 
	 * @param map category(대/소분류), searchKeyword(검색어)
	 */
	public List<Map<String, Object>> getFaqList(HashMap<String, Object> map) throws Exception {
		// 기존 Impl의 로직을 그대로 가져옴
		return csCenterMapper.getFaqList(map);
	}

	/**
	 * 공지사항 최근 N건 조회 (고객센터 메인 노출용)
	 * 
	 * @param map limit(건수)
	 */
	public List<Map<String, Object>> getNotificationList(HashMap<String, Object> map) throws Exception {
		// 기존 Impl의 로직을 그대로 가져옴
		return csCenterMapper.getNotificationList(map);
	}
}