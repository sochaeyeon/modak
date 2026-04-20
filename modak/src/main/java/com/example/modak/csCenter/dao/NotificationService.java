package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.csCenter.mapper.NotificationMapper;
import com.example.modak.csCenter.model.Notification;

// 규칙
// 검색 - get, 삭제 - remove, 수정 - edit, 추가 - add
@Service
public class NotificationService {

	@Autowired
	NotificationMapper notificationMapper;

	public HashMap<String, Object> getNotificationList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Notification> list = notificationMapper.selectNotificationList(map);

		resultMap.put("list", list);
		resultMap.put("message", "데이터 조회 성공");
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> getNotificationInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			Notification info = notificationMapper.selectNotification(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}

}
