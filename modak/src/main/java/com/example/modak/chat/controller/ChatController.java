package com.example.modak.chat.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.chat.dao.ChatService;

/**
 * 챗봇 통합 컨트롤러 (화면 이동 + API 통신)
 */
@Controller // JSP를 리턴하기 위해 @Controller 사용
public class ChatController {

    @Autowired 
    private ChatService chatService;

    /**
     * 1. 챗봇 페이지 이동
     * 브라우저 주소창 : http://localhost:8080/chat/bot.do
     */
    @RequestMapping("/chat/bot.do")
    public String goChatBot() {
        // WEB-INF/chat/chatbot.jsp 위치로 이동
        return "chat/chatbot"; 
    }

    /**
     * 2. 챗봇 대화 API (AJAX 통신)
     * @ResponseBody: 이 메소드는 JSP를 찾는게 아니라 데이터를 리턴한다는 선언 (중요!)
     */
    @PostMapping(value = "/api/chat/ask.dox", produces = "text/plain;charset=UTF-8")
    @ResponseBody 
    public String ask(@RequestBody HashMap<String, Object> params) {
        String message = (String) params.get("message");
        
        if (message == null || message.trim().isEmpty()) {
            return "질문을 입력해 주세요! 🏕️";
        }
        
        
        // Gemini API 호출 결과 반환
        return chatService.getGeminiResponse(message);
    }
}