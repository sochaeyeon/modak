package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Notification;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface NotificationMapper {

	// 여러 개 리턴
	public List<Notification> selectNotificationList(HashMap<String, Object> map);

	// 한 개 리턴
	public Notification selectNotification(HashMap<String, Object> map);

	// 삭제
	public int deleteNotification(HashMap<String, Object> map);

	// 추가
	public int insertNotification(HashMap<String, Object> map);

	// 수정
	public int updateNotification(HashMap<String, Object> map);
}
