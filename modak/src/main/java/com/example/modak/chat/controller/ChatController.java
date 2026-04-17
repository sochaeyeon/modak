package com.example.modak.chat.controller;

import java.util.HashMap;
import java.util.List;
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
        return chatService.getGeminiResponse(userId, message, roomId);
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