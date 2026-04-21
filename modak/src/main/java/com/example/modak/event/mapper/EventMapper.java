package com.example.modak.event.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.event.model.Event;

@Mapper
public interface EventMapper {

    /** 목록 조회 (탭 + 페이징) */
    List<Event> selectEventList(HashMap<String, Object> map);

    /** 전체 건수 (페이징용) */
    int selectEventCount(HashMap<String, Object> map);

    /** 단건 상세 조회 */
    Event selectEvent(HashMap<String, Object> map);

    /** ★ 메인 배너용 최신 이벤트 5개 */
    List<Event> selectBannerList();
}
