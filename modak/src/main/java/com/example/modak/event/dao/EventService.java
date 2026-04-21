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

	// 페이지당 카드 수
	private static final int PAGE_SIZE = 6;

	/*
	 * ── 목록 조회 (탭 + 페이징) ───────────────────────── map 파라미터: tabType : 'ongoing' |
	 * 'ended' | 'winner' | null(전체) page : 현재 페이지 번호 (1부터 시작)
	 * ───────────────────────────────────────────────────
	 */
	public HashMap<String, Object> getEventList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		// 페이지 계산
		int page = 1;
		try {
			page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
		} catch (Exception ignored) {
		}
		if (page < 1)
			page = 1;

		int offset = (page - 1) * PAGE_SIZE;
		HashMap<String, Object> queryMap = new HashMap<>();
		map.put("tabType", map.getOrDefault("tabType", ""));
		map.put("pageSize", PAGE_SIZE); // int
		map.put("offset", offset); // int

		// DB 조회
		List<Event> list = eventMapper.selectEventList(map);
		int total = eventMapper.selectEventCount(map);

		// 총 페이지 수
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

	/* ── 단건 상세 조회 ───────────────────────────────── */
	public HashMap<String, Object> getEventInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			Event info = eventMapper.selectEvent(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", "데이터 조회 성공");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", "서버 오류가 발생했습니다.");
		}

		return resultMap;
	}
}
