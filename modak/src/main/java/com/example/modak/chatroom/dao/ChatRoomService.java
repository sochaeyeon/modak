package com.example.modak.chatroom.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.chatroom.mapper.ChatRoomMapper;

@Service
public class ChatRoomService {

	@Autowired
	private ChatRoomMapper mapper;
	@Autowired
	private AlarmService alarmService;

	// ════════════════════════════════════════
	// 대화 신청
	// ════════════════════════════════════════
	@Transactional
	public HashMap<String, Object> respondChat(String userId, Long requestId, String action) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			Map<String, Object> req = mapper.selectRequestById(requestId);
			if (req == null) {
				result.put("result", "fail");
				result.put("message", "신청 정보를 찾을 수 없습니다.");
				return result;
			}

			String fromUser = String.valueOf(req.get("FROM_USER"));
			String toUser = String.valueOf(req.get("TO_USER"));
			String status = String.valueOf(req.get("STATUS"));

			if (!userId.equals(toUser)) {
				result.put("result", "fail");
				result.put("message", "본인에게 온 신청만 처리할 수 있습니다.");
				return result;
			}

			HashMap<String, Object> roomCheck = new HashMap<>();
			roomCheck.put("userId", fromUser);
			roomCheck.put("otherId", toUser);

			Map<String, Object> existingRoom = mapper.selectChatRoomIncludeHidden(roomCheck);

			// 이미 수락된 신청이면 기존 방으로 보내기
			if ("ACCEPTED".equals(status)) {
				if (existingRoom != null) {
					result.put("result", "success");
					result.put("roomId", existingRoom.get("ROOM_ID"));
					result.put("already", true);
					return result;
				}
			}

			if ("REJECTED".equals(status)) {
				result.put("result", "fail");
				result.put("message", "이미 거절한 신청입니다.");
				return result;
			}

			if ("ACCEPT".equals(action)) {

				Long roomId;

				if (existingRoom != null) {
					roomId = Long.parseLong(String.valueOf(existingRoom.get("ROOM_ID")));
				} else {
					HashMap<String, Object> roomParam = new HashMap<>();
					roomParam.put("userA", fromUser);
					roomParam.put("userB", userId);
					mapper.insertChatRoom(roomParam);

					roomId = Long.parseLong(String.valueOf(roomParam.get("roomId")));
				}

				HashMap<String, Object> updateParam = new HashMap<>();
				updateParam.put("requestId", requestId);
				updateParam.put("status", "ACCEPTED");
				updateParam.put("roomId", roomId);
				mapper.updateRequestStatusWithRoom(updateParam);

				alarmService.createAlarm(fromUser, "CHAT_ACCEPTED", "대화 신청이 수락되었어요 ✅", "채팅방으로 이동하세요.", roomId);

				result.put("result", "success");
				result.put("roomId", roomId);
				return result;
			}

			HashMap<String, Object> updateParam = new HashMap<>();
			updateParam.put("requestId", requestId);
			updateParam.put("status", "REJECTED");
			updateParam.put("roomId", null);
			mapper.updateRequestStatusWithRoom(updateParam);

			alarmService.createAlarm(fromUser, "CHAT_REJECTED", "대화 신청이 거절되었어요 ❌", "상대방이 대화 신청을 거절했습니다.", null);

			result.put("result", "rejected");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류가 발생했습니다.");
		}

		return result;
	}

	@Transactional
	public HashMap<String, Object> requestChat(String fromUser, String toUser) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			if (fromUser.equals(toUser)) {
				result.put("result", "fail");
				result.put("message", "자기 자신에게는 신청 불가");
				return result;
			}

			// 이미 채팅방 있는지 체크
			HashMap<String, Object> param = new HashMap<>();
			param.put("userId", fromUser);
			param.put("otherId", toUser);

			Map<String, Object> room = mapper.selectChatRoomIncludeHidden(param);

			if (room != null) {
				result.put("result", "exists");
				result.put("roomId", room.get("ROOM_ID"));
				return result;
			}

			// 요청 생성
			HashMap<String, Object> reqParam = new HashMap<>();
			reqParam.put("fromUser", fromUser);
			reqParam.put("toUser", toUser);

			mapper.insertChatRequest(reqParam);

			// 알림
			alarmService.createAlarm(toUser, "CHAT_REQUEST", "대화 신청이 왔어요 💬", "새로운 대화 신청이 도착했습니다.",
					reqParam.get("requestId"));

			result.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "서버 오류");
		}

		return result;
	}

	// ════════════════════════════════════════
	// 채팅방 목록
	// ════════════════════════════════════════
	public HashMap<String, Object> getMyRooms(String userId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			List<Map<String, Object>> list = mapper.selectMyRooms(userId);
			result.put("result", "success");
			result.put("list", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// ════════════════════════════════════════
	// 메시지 목록
	// ════════════════════════════════════════
	@Transactional
	public HashMap<String, Object> getMessages(Long roomId, String userId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("userId", userId);

			// 삭제해야 함
			// mapper.showRoomAgain(param);

			mapper.markMessagesRead(param);

			List<Map<String, Object>> list = mapper.selectMessages(param);
			result.put("result", "success");
			result.put("list", list);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// ════════════════════════════════════════
	// 메시지 전송
	// ════════════════════════════════════════
	public HashMap<String, Object> sendMessage(Long roomId, String userId, String content) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("userId", userId);
			param.put("senderId", userId);
			param.put("content", content);

			// 내가 다시 메시지 보내면 내 채팅방 복구
			mapper.showRoomAgain(param);

			mapper.insertMessage(param);

			result.put("result", "success");
			result.put("messageId", param.get("messageId"));

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// ════════════════════════════════════════
	// 차단 토글
	// ════════════════════════════════════════
	public HashMap<String, Object> toggleBlock(String blockerId, String blockedId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("blockerId", blockerId);
			param.put("blockedId", blockedId);

			int exists = mapper.selectBlockExists(param);
			if (exists > 0) {
				mapper.deleteBlock(param);
				result.put("blocked", false);
				result.put("message", "차단을 해제했습니다.");
			} else {
				mapper.insertBlock(param);
				result.put("blocked", true);
				result.put("message", "차단했습니다. 🚫");
			}
			result.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	// ════════════════════════════════════════
	// 차단 여부 확인
	// ════════════════════════════════════════
	public HashMap<String, Object> checkBlock(String userId, String targetId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("blockerId", userId);
			param.put("blockedId", targetId);
			boolean blocked = mapper.selectBlockExists(param) > 0;
			result.put("result", "success");
			result.put("blocked", blocked);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}

	public HashMap<String, Object> sendImageMessage(Long roomId, String userId, MultipartFile image,
			String uploadPath) { // ★ uploadPath 파라미터 추가
		HashMap<String, Object> result = new HashMap<>();
		try {
			if (image == null || image.isEmpty()) {
				result.put("result", "fail");
				result.put("message", "이미지가 없습니다.");
				return result;
			}

			String originalName = image.getOriginalFilename();
			String ext = originalName.substring(originalName.lastIndexOf("."));
			String saveName = UUID.randomUUID().toString() + ext;

// ★ 하드코딩 경로 삭제, 파라미터로 받은 경로 사용
			File dir = new File(uploadPath);
			if (!dir.exists())
				dir.mkdirs();

			image.transferTo(new File(dir, saveName));

			String imgUrl = "/img/chat/" + saveName;

			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("senderId", userId);
			param.put("content", imgUrl);

			mapper.insertImageMessage(param);

			result.put("result", "success");
			result.put("messageId", param.get("messageId"));
			result.put("imgUrl", imgUrl);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "이미지 전송 실패");
		}
		return result;
	}

	@Transactional
	public void markRead(Long roomId, String userId) {
		HashMap<String, Object> param = new HashMap<>();
		param.put("roomId", roomId);
		param.put("userId", userId);

		mapper.markMessagesRead(param);
	}

	public HashMap<String, Object> leaveRoom(Long roomId, String userId) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("userId", userId);

			mapper.hideRoomForMe(param);

			result.put("result", "success");
			result.put("message", "채팅방을 나갔습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "채팅방 나가기 실패");
		}

		return result;
	}

	public HashMap<String, Object> deleteMessage(Long roomId, Long messageId, String userId, String type) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("messageId", messageId);
			param.put("userId", userId);

			if ("ALL".equals(type)) {
				mapper.deleteMessageForAll(param);
			} else {
				mapper.hideMessageForMe(param);
			}

			result.put("result", "success");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "메시지 삭제 실패");
		}

		return result;
	}

	public HashMap<String, Object> sendStickerMessage(Long roomId, String userId, String content) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("roomId", roomId);
			param.put("senderId", userId);
			param.put("content", content);
			param.put("messageType", "STICKER");

			mapper.insertStickerMessage(param);

			result.put("result", "success");
			result.put("messageId", param.get("messageId"));
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "이모티콘 전송 실패");
		}

		return result;
	}

	public HashMap<String, Object> getChatStatus(String userId, String otherId) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			HashMap<String, Object> param = new HashMap<>();
			param.put("userId", userId);
			param.put("otherId", otherId);

			Map<String, Object> room = mapper.selectChatStatus(param);

			result.put("result", "success");
			if (room != null) {
				result.put("exists", true);
				result.put("roomId", room.get("ROOM_ID"));
			} else {
				result.put("exists", false);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		return result;
	}
}