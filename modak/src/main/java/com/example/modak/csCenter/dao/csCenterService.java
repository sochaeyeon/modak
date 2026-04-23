package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface csCenterService {

	/**
	 * FAQ 목록 조회
	 * 
	 * @param map category(대/소분류), searchKeyword(검색어)
	 */
	List<Map<String, Object>> getFaqList(HashMap<String, Object> map) throws Exception;

	/**
	 * 공지사항 최근 N건 조회 (고객센터 메인 노출용)
	 * 
	 * @param map limit(건수)
	 */
	List<Map<String, Object>> getNotificationList(HashMap<String, Object> map) throws Exception;
}
