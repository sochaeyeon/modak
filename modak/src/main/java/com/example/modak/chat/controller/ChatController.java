package com.example.modak.chat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.example.modak.chat.dao.ChatService;
import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

    @Autowired private ChatService chatService;

    @RequestMapping("/chat/bot.do")
    public String goChatBot() { return "chat/chatbot"; }

    @PostMapping(value = "/api/chat/ask.dox", produces = "text/plain;charset=UTF-8")
    @ResponseBody 
    public String ask(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId = (session.getAttribute("userId") != null) ? (String) session.getAttribute("userId") : "eundong";
        String message = (String) params.get("message");
        String roomId = (String) params.get("roomId");
        
        // 💡 챗봇 답변 예시: "예약은 [인터파크 예약하기|https://www.interpark.com] 에서 가능하다닥!"
        return chatService.getGeminiResponse(userId, message, roomId);
    }

    @PostMapping("/api/chat/recommend.dox")
    @ResponseBody
    public List<String> getRecommend(@RequestBody HashMap<String, Object> params) {
        String lastMsg = (String) params.get("message");
        List<String> list = new ArrayList<>();

        if (lastMsg.contains("추천") || lastMsg.contains("캠핑장")) {
            list.addAll(Arrays.asList("🏕️ 예약 방법", "🚗 차박지 추천", "🏠 메인으로"));
        } else if (lastMsg.contains("장비")) {
            list.addAll(Arrays.asList("⛺ 텐트 설치법", "📦 대여 가격", "🏠 메인으로"));
        } else if (lastMsg.equals("START")) {
            list.addAll(Arrays.asList("⛺ 캠핑장 추천", "📦 필수 장비", "🔥 불멍 꿀팁", "🍳 요리 추천", "🚨 주의사항"));
        } else {
            list.addAll(Arrays.asList("❓ 가이드 확인", "📞 고객센터", "🏠 메인으로"));
        }
        return list;
    }

    @PostMapping("/api/chat/history.dox")
    @ResponseBody
    public List<HashMap<String, Object>> getHistory(HttpSession session) {
        String userId = (session.getAttribute("userId") != null) ? (String) session.getAttribute("userId") : "eundong";
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        return chatService.getChatHistory(map);
    }
    
    @PostMapping("/api/chat/roomMessages.dox")
    @ResponseBody
    public List<HashMap<String, Object>> getRoomMessages(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId = (session.getAttribute("userId") != null) ? (String) session.getAttribute("userId") : "eundong";
        params.put("userId", userId);
        return chatService.getChatMessagesByRoom(params);
    }

    @PostMapping("/api/chat/deleteRoom.dox")
    @ResponseBody
    public String deleteRoom(@RequestBody HashMap<String, Object> params, HttpSession session) {
        String userId = (session.getAttribute("userId") != null) ? (String) session.getAttribute("userId") : "eundong";
        params.put("userId", userId);
        int result = chatService.deleteChatRoom(params);
        return result > 0 ? "success" : "fail";
    }
}