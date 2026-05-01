package com.example.modak.chatroom.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.File;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.chatroom.mapper.ChatRoomMapper;

@Service
public class ChatRoomService {

    @Autowired private ChatRoomMapper mapper;
    @Autowired private AlarmService alarmService;

    // ════════════════════════════════════════
    // 대화 신청
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> requestChat(String fromUser, String toUser) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (fromUser.equals(toUser)) {
                result.put("result",  "fail");
                result.put("message", "자신에게는 신청할 수 없습니다.");
                return result;
            }

            // 차단 여부 확인
            HashMap<String, Object> blockParam = new HashMap<>();
            blockParam.put("blockerId", toUser);
            blockParam.put("blockedId", fromUser);
            if (mapper.selectBlockExists(blockParam) > 0) {
                result.put("result",  "fail");
                result.put("message", "대화를 신청할 수 없습니다.");
                return result;
            }

            // 이미 채팅방 있는지 확인
            HashMap<String, Object> roomParam = new HashMap<>();
            roomParam.put("userId",  fromUser);
            roomParam.put("otherId", toUser);
            Map<String, Object> room = mapper.selectChatRoom(roomParam);
            if (room != null) {
                HashMap<String, Object> showParam = new HashMap<>();
                showParam.put("roomId", room.get("ROOM_ID"));
                showParam.put("userId", fromUser);

                mapper.showRoomAgain(showParam);

                result.put("result", "exists");
                result.put("roomId", room.get("ROOM_ID"));
                return result;
            }

            // 이미 신청 중인지 확인
            HashMap<String, Object> reqParam = new HashMap<>();
            reqParam.put("fromUser", fromUser);
            reqParam.put("toUser",   toUser);
            Map<String, Object> existing = mapper.selectPendingRequest(reqParam);
            if (existing != null) {
                result.put("result",  "fail");
                result.put("message", "이미 신청 중입니다.");
                return result;
            }

            // 신청 INSERT
            mapper.insertChatRequest(reqParam);

            // 알림 발송
            alarmService.createAlarm(
                toUser, "CHAT_REQUEST",
                "대화 신청이 왔어요 💬",
                "새로운 대화 신청이 도착했습니다.",
                reqParam.get("requestId")
            );

            result.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 수락 / 거절
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> respondChat(String userId, Long requestId, String action) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            HashMap<String, Object> param = new HashMap<>();
            param.put("requestId", requestId);
            param.put("status", "ACCEPT".equals(action) ? "ACCEPTED" : "REJECTED");
            mapper.updateRequestStatus(param);

            Map<String, Object> req = mapper.selectRequestById(requestId);
            if (req == null) {
                result.put("result",  "fail");
                result.put("message", "신청 정보를 찾을 수 없습니다.");
                return result;
            }

            String fromUser = String.valueOf(req.get("FROM_USER"));

            if ("ACCEPT".equals(action)) {
                // 채팅방 생성
                HashMap<String, Object> roomParam = new HashMap<>();
                roomParam.put("userA", fromUser);
                roomParam.put("userB", userId);
                mapper.insertChatRoom(roomParam);

                Long roomId = Long.parseLong(String.valueOf(roomParam.get("roomId")));

                alarmService.createAlarm(
                    fromUser, "CHAT_ACCEPTED",
                    "대화 신청이 수락되었어요 ✅",
                    "채팅방으로 이동하세요.",
                    roomId
                );

                result.put("result", "success");
                result.put("roomId", roomId);

            } else {
                alarmService.createAlarm(
                    fromUser, "CHAT_REJECTED",
                    "대화 신청이 거절되었어요 ❌",
                    "상대방이 대화 신청을 거절했습니다.",
                    null
                );
                result.put("result", "rejected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
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
            result.put("list",   list);
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

            // 읽음 처리
            mapper.markMessagesRead(param);

            List<Map<String, Object>> list = mapper.selectMessages(param);
            result.put("result", "success");
            result.put("list",   list);
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
            param.put("roomId",   roomId);
            param.put("senderId", userId);
            param.put("content",  content);
            mapper.insertMessage(param);

            result.put("result",    "success");
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
            result.put("result",  "success");
            result.put("blocked", blocked);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }
    
    public HashMap<String, Object> sendImageMessage(Long roomId, String userId, MultipartFile image) {
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

            String uploadPath = "C:/Users/TJ-BU-708-P04/git/modak/modak/src/main/webapp/img/chat";

            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

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
}