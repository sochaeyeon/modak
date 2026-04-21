package com.example.modak.event.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.example.modak.event.model.Event;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface EventMapper {

	// 여러 개 리턴 (목록)
	public List<Event> selectEventList(HashMap<String, Object> map);

	// 전체 건수 (페이징)
	public int selectEventCount(HashMap<String, Object> map);

	// 단건 리턴 (상세)
	public Event selectEvent(HashMap<String, Object> map);

}
