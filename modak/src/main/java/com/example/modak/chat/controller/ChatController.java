package com.example.modak.chat.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.chat.dao.ChatService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

    @Autowired
    private ChatService chatService;

    private final Gson gson = new Gson();

    /* 챗봇 페이지 이동 */
    @RequestMapping("/chat/bot.do")
    public String goChatBot() {
        return "chat/chatbot";
    }

    /* ── 메시지 전송 ── */
    @PostMapping(value = "/api/chat/ask.dox", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String ask(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId  = (String) session.getAttribute("sessionId");
        String message = (String) params.get("message");
        String roomId  = (String) params.get("roomId");

        if (message == null || message.trim().isEmpty()) return "질문을 입력해 주세요! 🏕️";
        if (userId == null || userId.trim().isEmpty())   return "로그인 후 이용해 주세요! 🔥";

        return chatService.getGeminiResponse(userId, message, roomId);
    }

    /* ── 사이드바 히스토리 (방 목록) ── */
    @PostMapping(value = "/api/chat/history.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getHistory(HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) return "[]";

        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        return gson.toJson(chatService.getChatHistory(map));
    }

    /* ── 방 내 메시지 조회 ── */
    @PostMapping(value = "/api/chat/roomMessages.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRoomMessages(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) return "[]";

        params.put("userId", userId);
        return gson.toJson(chatService.getChatMessagesByRoom(params));
    }

    /* ── 추천 질문 ── */
    @PostMapping(value = "/api/chat/recommend.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRecommend(@RequestBody HashMap<String, Object> params) {
        String lastMessage = (String) params.getOrDefault("message", "START");
        return gson.toJson(chatService.getRecommendQuestions(lastMessage));
    }

    /* ── 방 삭제 ── */
    @PostMapping(value = "/api/chat/deleteRoom.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String deleteRoom(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) return "{\"result\":\"fail\"}";

        params.put("userId", userId);
        chatService.deleteChatRoom(params);
        return "{\"result\":\"success\"}";
    }
}