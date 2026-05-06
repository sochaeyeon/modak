package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Notification;

@Mapper
public interface NotificationMapper {

	// 고정 공지 목록 (IS_PINNED=1, 항상 최상단)
	public List<Notification> selectPinnedNotificationList(HashMap<String, Object> map);

	// 일반 공지 목록 (IS_PINNED=0, 페이징)
	public List<Notification> selectNotificationList(HashMap<String, Object> map);

	// 전체 건수 (IS_PINNED=0 기준, 페이징용)
	public int selectNotificationCount(HashMap<String, Object> map);

	// 단건 조회
	public Notification selectNotification(HashMap<String, Object> map);

	// 조회수 +1 (상세 진입 시 호출)
	public int incrementViewCount(HashMap<String, Object> map);

	// 삭제
	public int deleteNotification(HashMap<String, Object> map);

	// 추가
	public int insertNotification(HashMap<String, Object> map);

	// 수정
	public int updateNotification(HashMap<String, Object> map);

	// 고정 설정
	public int pinNotification(HashMap<String, Object> map);

	// 고정 해제
	public int unpinNotification(HashMap<String, Object> map);

	// 이전글
	public Notification selectPrevNotification(HashMap<String, Object> map) throws Exception;

	// 다음글
	public Notification selectNextNotification(HashMap<String, Object> map) throws Exception;

}
