package com.example.modak.chatroom.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.chatroom.dao.ChatRoomService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/chat-room")
public class ChatRoomController {

    @Autowired private ChatRoomService chatService;
    @Autowired private HttpSession session;

    // ── 페이지 ──────────────────────────────────

    /** 채팅방 목록 페이지 */
    @GetMapping("/list.do")
    public String chatListPage() {
        return "chat/chat-list";
    }

    /** 채팅방 페이지 */
    @GetMapping("/room.do")
    public String chatRoomPage() {
        return "chat/chat-room";
    }

    // ── AJAX ────────────────────────────────────

    /** 대화 신청 */
    @PostMapping(value = "/request.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String requestChat(@RequestParam String toUser) {
        String fromUser = (String) session.getAttribute("sessionId");
        if (fromUser == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.requestChat(fromUser, toUser));
    }

    /** 대화 신청 수락/거절 */
    @PostMapping(value = "/respond.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String respondChat(@RequestParam Long requestId,
                              @RequestParam String action) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(chatService.respondChat(userId, requestId, action));
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
}