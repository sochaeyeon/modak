package com.example.modak.chatroom.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.chatroom.dao.ChatRoomService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/chat-room")
public class ChatRoomController {

    @Autowired private ChatRoomService chatService;
    @Autowired private HttpSession session;
    private static final Map<Long, Map<String, Long>> typingMap = new ConcurrentHashMap<>();

    // ── 페이지 ──────────────────────────────────

    @GetMapping("/list.do")
    public String chatListPage() {
        return "board/chat-list";
    }

    @GetMapping("/room.do")
    public String chatRoomPage() {
        return "board/chat-room";
    }


    /** 채팅방 바로 생성 (신청 없이) */
    @PostMapping(value = "/create.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String createChat(@RequestParam String toUser) {
        String fromUser = (String) session.getAttribute("sessionId");
        if (fromUser == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.createChatDirect(fromUser, toUser));
    }

    /** 내 채팅방 목록 */
    @PostMapping(value = "/rooms.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRooms() {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.getMyRooms(userId));
    }

    /** 메시지 목록 조회 */
    @PostMapping(value = "/messages.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getMessages(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.getMessages(roomId, userId));
    }

    /** 메시지 전송 */
    @PostMapping(value = "/send.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendMessage(@RequestParam Long roomId,
                              @RequestParam String content) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.sendMessage(roomId, userId, content));
    }

    /** 차단/차단해제 토글 */
    @PostMapping(value = "/block.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String blockUser(@RequestParam String targetId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.toggleBlock(userId, targetId));
    }

    /** 메시지 신고 (다중 선택 가능) */
    @PostMapping(value = "/message/report.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String reportMessage(@RequestParam Long roomId,
                                @RequestParam String messageIds,   // 콤마로 구분된 메시지ID들
                                @RequestParam String reason,        // ABUSE / SPAM / SCAM / EXPLICIT / ETC
                                @RequestParam(required = false) String detail) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        List<Long> ids = new ArrayList<>();
        for (String idStr : messageIds.split(",")) {
            idStr = idStr.trim();
            if (!idStr.isEmpty()) {
                ids.add(Long.parseLong(idStr));
            }
        }

        if (ids.isEmpty()) {
            return "{\"result\":\"fail\",\"message\":\"신고할 메시지를 선택해주세요.\"}";
        }

        return new Gson().toJson(chatService.reportMessages(roomId, ids, userId, reason, detail));
    }

    /** 차단 여부 확인 */
    @PostMapping(value = "/block/check.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String checkBlock(@RequestParam String targetId) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> result = new HashMap<>();
        if (userId == null) {
            result.put("result", "fail");
            return new Gson().toJson(result);
        }
        return new Gson().toJson(chatService.checkBlock(userId, targetId));
    }

    /** 입력 중 상태 등록 */
    @PostMapping(value = "/typing.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String typing(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> result = new HashMap<>();
        if (userId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return new Gson().toJson(result);
        }
        typingMap
            .computeIfAbsent(roomId, k -> new ConcurrentHashMap<>())
            .put(userId, System.currentTimeMillis());
        result.put("result", "success");
        return new Gson().toJson(result);
    }

    /** 상대방 입력 중 상태 확인 */
    @PostMapping(value = "/typing/check.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String checkTyping(@RequestParam Long roomId,
                              @RequestParam String otherId) {
        HashMap<String, Object> result = new HashMap<>();
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            result.put("result", "fail");
            result.put("typing", false);
            return new Gson().toJson(result);
        }
        Map<String, Long> roomTyping = typingMap.get(roomId);
        boolean typing = false;
        if (roomTyping != null && roomTyping.get(otherId) != null) {
            long lastTypingTime = roomTyping.get(otherId);
            typing = System.currentTimeMillis() - lastTypingTime <= 3000;
        }
        result.put("result", "success");
        result.put("typing", typing);
        return new Gson().toJson(result);
    }

    /** ★ 이미지 전송 — webapp/img/chat/ 에 저장 (팀원 공유 가능) */
    @PostMapping(value = "/send-image.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendImage(@RequestParam Long roomId,
                            @RequestParam MultipartFile image,
                            HttpServletRequest request) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        String uploadPath = request.getServletContext().getRealPath("/img/chat/");
        return new Gson().toJson(chatService.sendImageMessage(roomId, userId, image, uploadPath));
    }

    /** 읽음 처리 */
    @PostMapping(value = "/read.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String markRead(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> result = new HashMap<>();
        if (userId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return new Gson().toJson(result);
        }
        result.put("result", "success");
        chatService.markRead(roomId, userId);
        return new Gson().toJson(result);
    }

    /** 채팅방 나가기 */
    @PostMapping(value = "/leave.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String leaveRoom(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.leaveRoom(roomId, userId));
    }

    /** 메시지 삭제 */
    @PostMapping(value = "/message/delete.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String deleteMessage(@RequestParam Long roomId,
                                @RequestParam Long messageId,
                                @RequestParam String type) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.deleteMessage(roomId, messageId, userId, type));
    }

    private static final Map<String, Long> activeMap = new ConcurrentHashMap<>();

    /** 접속 상태 등록 */
    @PostMapping(value = "/active.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String active() {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> result = new HashMap<>();
        if (userId == null) {
            result.put("result", "fail");
            return new Gson().toJson(result);
        }
        activeMap.put(userId, System.currentTimeMillis());
        result.put("result", "success");
        return new Gson().toJson(result);
    }

    /** 접속 상태 확인 */
    @PostMapping(value = "/active/check.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String checkActive(@RequestParam String otherId) {
        HashMap<String, Object> result = new HashMap<>();
        Long last = activeMap.get(otherId);
        result.put("result", "success");
        if (last == null) {
            result.put("status", "오프라인");
            return new Gson().toJson(result);
        }
        long diff = System.currentTimeMillis() - last;
        if (diff <= 10000) {
            result.put("status", "접속 중");
        } else if (diff <= 60000) {
            result.put("status", "방금 전");
        } else {
            result.put("status", (diff / 60000) + "분 전");
        }
        return new Gson().toJson(result);
    }

    /** 스티커 전송 */
    @PostMapping(value = "/send-sticker.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendSticker(@RequestParam("roomId") Long roomId,
                              @RequestParam("content") String content) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.sendStickerMessage(roomId, userId, content));
    }

    /** 기존 채팅방 존재 여부 확인 */
    @PostMapping(value = "/status.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String chatStatus(@RequestParam String targetUser) {
        String userId = (String) session.getAttribute("sessionId");
        HashMap<String, Object> result = new HashMap<>();
        if (userId == null) {
            result.put("result", "fail");
            return new Gson().toJson(result);
        }
        return new Gson().toJson(chatService.getChatStatus(userId, targetUser));
    }
}