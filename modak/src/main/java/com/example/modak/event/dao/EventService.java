package com.example.modak.event.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.event.mapper.EventMapper;
import com.example.modak.event.model.Event;

@Service
public class EventService {

	@Autowired
	EventMapper eventMapper;

	private static final int PAGE_SIZE = 6;

	/* ── 목록 조회 (탭 + 페이징) ── */
	public HashMap<String, Object> getEventList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		int page = 1;
		try {
			page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
		} catch (Exception ignored) {
		}
		if (page < 1)
			page = 1;

		int offset = (page - 1) * PAGE_SIZE;
		map.put("tabType", map.getOrDefault("tabType", ""));
		map.put("pageSize", PAGE_SIZE);
		map.put("offset", offset);

		List<Event> list = eventMapper.selectEventList(map);
		int total = eventMapper.selectEventCount(map);
		int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
		if (totalPages < 1)
			totalPages = 1;

		resultMap.put("list", list);
		resultMap.put("totalCount", total);
		resultMap.put("totalPages", totalPages);
		resultMap.put("currentPage", page);
		resultMap.put("result", "success");
		resultMap.put("message", "데이터 조회 성공");
		return resultMap;
	}

	public HashMap<String, Object> getEventInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Event info = eventMapper.selectEvent(map);

			if (info == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이벤트 정보를 찾을 수 없습니다.");
				return resultMap;
			}

			info.setImgList(eventMapper.selectEventImgList(map));

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", "데이터 조회 성공");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "서버 오류가 발생했습니다.");
		}

		return resultMap;
	}

	/*
	 * ──────────────────────────────────────── ★ 메인 배너용 최신 이벤트 5개
	 * ────────────────────────────────────────
	 */
	public HashMap<String, Object> getBannerList() {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Event> list = eventMapper.selectBannerList();
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}
}
