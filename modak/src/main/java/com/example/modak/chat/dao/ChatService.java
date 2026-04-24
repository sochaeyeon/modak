package com.example.modak.chat.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.modak.chat.mapper.ChatMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class ChatService {

	@Autowired
	private ChatMapper chatMapper;
	
	@Autowired
	private HttpSession session;

	@Value("${gemini.api.key}")
	private String apiKey;

	private final RestTemplate restTemplate = new RestTemplate();

	/* ── 메시지 전송 + Gemini 호출 ── */
	public String getGeminiResponse(String userId, String userMessage, String roomId) {

		if (roomId == null || roomId.trim().isEmpty()) {
			roomId = "ROOM_" + userId + "_" + System.currentTimeMillis();
		}

		boolean isLogin = (userId != null && !userId.trim().isEmpty());

		if (roomId == null || roomId.trim().isEmpty()) {
		    if (isLogin) {
		        roomId = "ROOM_" + userId + "_" + System.currentTimeMillis();
		    } else {
		        roomId = "GUEST_" + System.currentTimeMillis();
		    }
		}

		// 회원일 때만 사용자 메시지 저장
		if (isLogin) {
		    saveChat(userId, "user", userMessage, roomId);
		}

		// 회원일 때만 이전 대화 조회
		List<HashMap<String, Object>> history = new ArrayList<>();

		if (isLogin) {
		    HashMap<String, Object> param = new HashMap<>();
		    param.put("userId", userId);
		    param.put("roomId", roomId);
		    history = chatMapper.selectChatMessagesByRoom(param);
		} else {
		    HashMap<String, Object> guestMsg = new HashMap<>();
		    guestMsg.put("role", "user");
		    guestMsg.put("message", userMessage);
		    history.add(guestMsg);
		}
//		// 1순위 추천: 최신이면서 빠른 2.0 모델
		String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + apiKey;


		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		String systemInstruction = "너는 캠핑 전문 AI 도우미 '모닥이'야. " + "사용자들에게 친절하고 따뜻하게 캠핑 정보와 장비 추천을 해줘. "
				+ "답변은 반드시 한국어로 하고, 끝에는 항상 '즐거운 캠핑 되세요! 🔥'라고 덧붙여줘.";

		List<Map<String, Object>> contents = new ArrayList<>();
		int startIdx = Math.max(0, history.size() - 10);

		for (int i = startIdx; i < history.size(); i++) {
			HashMap<String, Object> msg = history.get(i);
			String role = "bot".equals(msg.get("role")) ? "model" : "user";
			String text = msg.get("message").toString();

			if (i == startIdx && "user".equals(role)) {
				text = systemInstruction + "\n\n" + text;
			}

			Map<String, Object> part = new HashMap<>();
			part.put("text", text);
			Map<String, Object> content = new HashMap<>();
			content.put("role", role);
			content.put("parts", Collections.singletonList(part));
			contents.add(content);
		}

		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("contents", contents);

		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

		try {
			ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
			String botResponse = parseBotMessage(response);

			if (isLogin) {
			    saveChat(userId, "bot", botResponse, roomId);
			}

			return botResponse;

		} catch (HttpClientErrorException.TooManyRequests e) {
			System.err.println("[챗봇] 쿼터 초과(429)");
			return "지금 모닥불 앞에 사람이 너무 많아요! 잠시 후 다시 질문해 주세요 🔥";
		} catch (Exception e) {
			System.err.println("[챗봇] API 오류: " + e.getMessage());
			return "서버 통신 오류가 발생했습니다. 불씨가 잠시 꺼진 것 같아요! 🔥";
		}
	}

	/* ── 추천 질문 생성 ── */
	public List<String> getRecommendQuestions(String lastMessage) {
		// "START" 이면 기본 추천 질문 반환
		if ("START".equals(lastMessage)) {
			List<String> defaults = new ArrayList<>();
			defaults.add("⛺ 텐트 추천해줘");
			defaults.add("🛏️ 침낭 종류 알려줘");
			defaults.add("🎒 초보 캠퍼 필수 장비");
			defaults.add("🚨 일산화탄소 경보기 필요해?");
			defaults.add("❄️ 겨울 캠핑 준비물");
			return defaults;
		}

		String url = "https://generativelanguage.googleapis.com/v1beta/models/"
				+ "gemini-2.5-flash:generateContent?key=" + apiKey;

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		String prompt = "다음 캠핑 대화 내용을 보고 사용자가 다음에 물어볼 법한 추천 질문 3개를 만들어줘. " + "반드시 아래 형식으로만 답해줘 (다른 말 없이 딱 3줄):\n"
				+ "질문1\n질문2\n질문3\n\n대화 내용: " + lastMessage;

		Map<String, Object> part = new HashMap<>();
		part.put("text", prompt);
		Map<String, Object> content = new HashMap<>();
		content.put("role", "user");
		content.put("parts", Collections.singletonList(part));

		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("contents", Collections.singletonList(content));

		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

		try {
			ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
			String raw = parseBotMessage(response);
			List<String> result = new ArrayList<>();
			for (String line : raw.split("\n")) {
				String trimmed = line.trim();
				if (!trimmed.isEmpty())
					result.add(trimmed);
				if (result.size() >= 3)
					break;
			}
			return result;
		} catch (Exception e) {
			System.err.println("[추천질문] 오류: " + e.getMessage());
			List<String> fallback = new ArrayList<>();
			fallback.add("⛺ 텐트 추천해줘");
			fallback.add("🛏️ 침낭 어떤 거 골라야 해?");
			fallback.add("🏕️ 캠핑 초보 팁 알려줘");
			return fallback;
		}
	}

	private void saveChat(String userId, String role, String message, String roomId) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("role", role);
		map.put("message", message);
		map.put("roomId", roomId);
		chatMapper.insertChatHistory(map);
	}

	private String parseBotMessage(ResponseEntity<Map> response) {
		try {
			Map body = response.getBody();
			List candidates = (List) body.get("candidates");
			Map firstCandidate = (Map) candidates.get(0);
			Map content = (Map) firstCandidate.get("content");
			List parts = (List) content.get("parts");
			Map firstPart = (Map) parts.get(0);
			return (String) firstPart.get("text");
		} catch (Exception e) {
			return "답변을 가져오지 못했어요. 다시 시도해 주세요!";
		}
	}

	public List<HashMap<String, Object>> getChatHistory(HashMap<String, Object> map) {
		return chatMapper.selectChatHistory(map);
	}

	public List<HashMap<String, Object>> getChatMessagesByRoom(HashMap<String, Object> map) {
		return chatMapper.selectChatMessagesByRoom(map);
	}

	public int deleteChatRoom(HashMap<String, Object> map) {
		return chatMapper.deleteChatRoom(map);
	}

	public HashMap<String, Object> getChatbotRoomList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");
			map.put("userId", sessionId);

			int page = 1;
			int pageSize = 10;

			if (map.get("page") != null) {
				page = Integer.parseInt(map.get("page").toString());
			}

			if (map.get("pageSize") != null) {
				pageSize = Integer.parseInt(map.get("pageSize").toString());
			}

			int offset = (page - 1) * pageSize;

			map.put("offset", offset);
			map.put("pageSize", pageSize);

			List<HashMap<String, Object>> list = chatMapper.selectChatRoomListPaged(map);
			int totalCount = chatMapper.selectChatRoomCount(map);

			resultMap.put("result", "success");
			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("page", page);
			resultMap.put("pageSize", pageSize);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "조회 중 오류가 발생했습니다.");
		}

		return resultMap;
	}
}