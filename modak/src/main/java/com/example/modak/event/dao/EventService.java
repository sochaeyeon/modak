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
	    HashMap<String, Object> result = new HashMap<>();
	    try {
	        int page     = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
	        int pageSize = 9; // 한 페이지에 9개

	        map.put("offset",   (page - 1) * pageSize);
	        map.put("pageSize", pageSize);

	        List<?> list       = eventMapper.selectEventList(map);
	        int     totalCount = eventMapper.selectEventCount(map);
	        int     totalPages = (int) Math.ceil((double) totalCount / pageSize);

	        result.put("result",      "success");
	        result.put("list",        list);
	        result.put("totalCount",  totalCount);
	        result.put("totalPages",  Math.max(totalPages, 1));
	        result.put("currentPage", page);

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result",  "fail");
	        result.put("message", "이벤트 목록 조회 실패");
	    }
	    return result;
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
