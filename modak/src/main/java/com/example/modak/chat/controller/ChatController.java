package com.example.modak.chat.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.chat.dao.ChatService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

	@Autowired
	private ChatService chatService;
	
	@Autowired
	private HttpSession session;

	private final Gson gson = new Gson();

	/* 챗봇 페이지 이동 */
	@RequestMapping("/chat/bot.do")
	public String chatbotPage(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {

		request.setAttribute("roomId", map.get("roomId"));
		return "chat/chatbot";
	}

	@RequestMapping("/user/chatbot/history.do")
	public String chatbotHistory(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "chat/chatbot-history";
	}

	@PostMapping(value = "/api/chat/ask.dox", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String ask(@RequestBody HashMap<String, Object> params, HttpSession session) {

	    String userId = (String) session.getAttribute("sessionId");
	    String message = (String) params.get("message");
	    String roomId = (String) params.get("roomId");

	    if (message == null || message.trim().isEmpty()) {
	        return "질문을 입력해 주세요! 🏕️";
	    }

	    // 비회원 여부
	    boolean guest = (userId == null || userId.trim().isEmpty());

	    // 비회원이면 저장용 userId를 넘기지 않음
	    if (guest) {
	        userId = null;
	    }

	    return chatService.getGeminiResponse(userId, message, roomId);
	}

	/* ── 사이드바 히스토리 (방 목록) ── */
	@PostMapping(value = "/api/chat/history.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getHistory(HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (userId == null)
			return "[]";

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		return gson.toJson(chatService.getChatHistory(map));
	}

	/* ── 방 내 메시지 조회 ── */
	@PostMapping(value = "/api/chat/roomMessages.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRoomMessages(@RequestBody HashMap<String, Object> params, HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		if (userId == null)
			return "[]";

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
		if (userId == null)
			return "{\"result\":\"fail\"}";

		params.put("userId", userId);
		chatService.deleteChatRoom(params);
		return "{\"result\":\"success\"}";
	}

	// 전체보기용 챗봇 방 목록 + 페이징
	@RequestMapping(value = "/user/chatbot/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getChatbotRoomList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || sessionId.equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			map.put("userId", sessionId);

			resultMap = chatService.getChatbotRoomList(map);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "조회 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}

}