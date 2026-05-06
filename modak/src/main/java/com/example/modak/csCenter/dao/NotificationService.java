package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.common.Message;
import com.example.modak.csCenter.mapper.NotificationMapper;
import com.example.modak.csCenter.model.Notification;

// 규칙
// 검색 - get, 삭제 - remove, 수정 - edit, 추가 - add
@Service
@Transactional
public class NotificationService {

	@Autowired
	NotificationMapper notificationMapper;

	public NotificationService(NotificationMapper notificationMapper) {
		this.notificationMapper = notificationMapper;
	}

	public List<Notification> selectPinnedList(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectPinnedNotificationList(map);
	}

	public List<Notification> selectList(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectNotificationList(map);
	}

	public int selectCount(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectNotificationCount(map);
	}

	public Notification selectOne(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectNotification(map);
	}

	public Notification selectPrev(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectPrevNotification(map);
	}

	public Notification selectNext(HashMap<String, Object> map) throws Exception {
		return notificationMapper.selectNextNotification(map);
	}

	@Transactional // 쓰기 작업이 포함된 메서드에만 Transactional 추가
	public void incrementViewCount(HashMap<String, Object> map) throws Exception {
		notificationMapper.incrementViewCount(map);
	}

	@Transactional
	public void pin(HashMap<String, Object> map) throws Exception {
		notificationMapper.pinNotification(map);
	}

	@Transactional
	public void unpin(HashMap<String, Object> map) throws Exception {
		notificationMapper.unpinNotification(map);
	}

	/**
	 * 공지사항 목록 조회 (페이징 + 필터 + 검색 + 정렬) 파라미터: type, keyword, sort, startRow, pageSize
	 */
	public HashMap<String, Object> getNotificationList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		List<Notification> pinnedList = notificationMapper.selectPinnedNotificationList(map);
		int totalCount = notificationMapper.selectNotificationCount(map);
		List<Notification> list = notificationMapper.selectNotificationList(map);

		resultMap.put("pinnedList", pinnedList);
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("result", "success");
		resultMap.put("message", "데이터 조회 성공");
		return resultMap;
	}

	/**
	 * 공지사항 단건 조회 + 조회수 +1 파라미터: notificationId
	 *
	 * 순서: ① VIEW_COUNT +1 ② 갱신된 데이터 SELECT → 상세 페이지 진입마다 조회수가 1씩 누적됨
	 */
	public HashMap<String, Object> getNotificationInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// ① 조회수 +1
			notificationMapper.incrementViewCount(map);

			// ② 갱신된 단건 조회
			Notification info = notificationMapper.selectNotification(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	/**
	 * 고정 설정 (IS_PINNED = 1)
	 */
	public HashMap<String, Object> pinNotification(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = notificationMapper.pinNotification(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
			resultMap.put("message", cnt > 0 ? "고정 설정이 완료되었습니다." : "해당 공지사항을 찾을 수 없습니다.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}

	/**
	 * 고정 해제 (IS_PINNED = 0)
	 */
	public HashMap<String, Object> unpinNotification(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int cnt = notificationMapper.unpinNotification(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
			resultMap.put("message", cnt > 0 ? "고정 해제가 완료되었습니다." : "해당 공지사항을 찾을 수 없습니다.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}

}
