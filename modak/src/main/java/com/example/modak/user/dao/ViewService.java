package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.user.mapper.ViewMapper;
import com.example.modak.user.model.RecentView;

@Service
public class ViewService {

	@Autowired
	ViewMapper viewMapper;

	// 최근 본 상품 조회
	public HashMap<String, Object> getRecentList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int page = Integer.parseInt(String.valueOf(map.get("page")));
			int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
			int offset = (page - 1) * pageSize;

			map.put("offset", offset);

			List<RecentView> list = viewMapper.selectRecentList(map);
			int totalCount = viewMapper.selectRecentCount(map);

			resultMap.put("result", "success");
			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("page", page);
			resultMap.put("pageSize", pageSize);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "최근 본 상품 조회 중 오류가 발생했습니다.");
		}

		return resultMap;
	}

	// 최근 본 상품 저장
	@Transactional
	public HashMap<String, Object> addViewHistory(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. 같은 상품 기록이 있으면 삭제
			viewMapper.deleteSameProductViewHistory(map);

			// 2. 최신 기록으로 다시 삽입
			viewMapper.insertViewHistory(map);

			// 3. 100개 초과 시 가장 오래된 1개 삭제
			int count = viewMapper.selectViewHistoryCount(map);
			if (count > 100) {
				viewMapper.deleteOldestViewHistory(map);
			}

			resultMap.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "최근 본 상품 저장 중 오류가 발생했습니다.");
		}

		return resultMap;
	}
}