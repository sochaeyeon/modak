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

		String systemInstruction = 
			    "너는 캠핑 장비 대여·구매 플랫폼 '모닥모닥'의 전문 AI 상담사 '모닥이'야.\n\n" +

			    "## 모닥모닥 서비스 안내\n" +
			    "- 캠핑 장비를 대여하거나 구매할 수 있는 온라인 플랫폼이야.\n" +
			    "- 텐트, 침낭, 매트, 랜턴, 버너, 테이블, 의자 등 다양한 캠핑 장비를 취급해.\n" +
			    "- 대여: 원하는 날짜를 선택해 일정 기간 빌릴 수 있고, 보증금은 반납 후 환불돼.\n" +
			    "- 구매: 일반 쇼핑몰처럼 바로 구매할 수 있어.\n" +
			    "- 배송은 무료이며 제주·도서산간은 3,000원 추가돼.\n" +
			    "- 반납일 오전 10시까지 반납해야 해. 연체 시 1일당 대여가의 150%가 부과돼.\n" +
			    "- 파손·분실 시 수리 비용 또는 정가의 80%를 배상해야 해.\n\n" +

			    "## 회원 혜택\n" +
			    "- 회원 등급: 브론즈 → 실버 → 골드 → VIP\n" +
			    "- 구매 시 포인트 적립, 대여 확정 시 박당 포인트 적립\n" +
			    "- 쿠폰 발급 혜택 (회원가입 시 쿠폰 제공)\n" +
			    "- 위시리스트, 주문·대여 내역 관리 가능\n" +
			    "- 비회원도 장바구니·대여 이용 가능하지만 기록이 저장되지 않아.\n\n" +

			    "## 주요 페이지 안내\n" +
			    "- 메인: /main.do\n" +
			    "- 상품 목록: /product/list.do\n" +
			    "- 장바구니: /cart/list.do\n" +
			    "- 마이페이지: /user/mypage.do\n" +
			    "- 고객센터: /cs/center.do\n" +
			    "- 캠핑장 지도: /camp/map.do\n" +
			    "- 이용 가이드: /guide/guide.do\n" +
			    "- 1:1 문의: /inquiry.do\n" +
			    "- 로그인: /user/login.do\n\n" +
			    "- 자주묻는질문: /faq.do\n\n" +
			    "- 이벤트: /event/list.do\n\n" +
			    

			    "## 링크 버튼 생성 규칙\n" +
			    "사용자가 특정 페이지로 이동이 필요할 때는 반드시 아래 형식으로 버튼을 만들어줘:\n" +
			    "[버튼 텍스트|/페이지경로.do]\n" +
			    "예: [상품 보러가기|/product/list.do], [장바구니 확인|/cart/list.do]\n\n" +

			    "## 응답 규칙\n" +
			    "1. 반드시 한국어로 답변해.\n" +
			    "2. 모닥모닥 관련 질문(장비, 대여, 구매, 배송, 환불 등)을 우선적으로 답변해.\n" +
			    "3. 캠핑 정보나 장비 추천 질문도 모닥모닥 상품과 연결해서 답변해.\n" +
			    "4. 사이트에 없는 정보(타사 비교, 외부 링크 등)는 안내하지 마.\n" +
			    "5. 친절하고 따뜻한 말투를 써. 어미에 '~다닥', '~봐라닥' 같은 귀여운 표현을 가끔 써.\n" +
			    "6. 답변 마지막에는 '즐거운 캠핑 되세요! 🔥'를 붙여줘.\n" +
			    "7. 마크다운 볼드(**텍스트**)나 줄바꿈을 적절히 사용해서 읽기 쉽게 해줘.";
		
		// ChatService.java — getGeminiResponse 메서드 안, systemInstruction 아래에 추가
		// 인기 상품 top5를 DB에서 조회해서 프롬프트에 추가
		try {
		    List<HashMap<String, Object>> topProducts = chatMapper.selectTopProducts(); // mapper 추가 필요
		    if (topProducts != null && !topProducts.isEmpty()) {
		        StringBuilder productInfo = new StringBuilder("\n## 현재 인기 상품\n");
		        for (HashMap<String, Object> p : topProducts) {
		            productInfo.append("- ")
		                .append(p.get("productName"))
		                .append(" / ")
		                .append(p.get("productType").equals("RENTAL") ? "대여" : "구매")
		                .append(" / ")
		                .append(p.get("price"))
		                .append("원\n");
		        }
		        systemInstruction += productInfo.toString();
		    }
		} catch (Exception e) {
		    // 상품 조회 실패해도 챗봇은 정상 동작
		}

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
	    List<String> result = new ArrayList<>();

	    if (lastMessage == null) {
	        lastMessage = "";
	    }

	    if (lastMessage.contains("텐트")) {
	        result.add("⛺ 2인용 텐트 추천해줘");
	        result.add("🏕️ 초보자용 텐트는 뭐가 좋아?");
	        result.add("📦 텐트 대여 방법 알려줘");
	    } else if (lastMessage.contains("침낭")) {
	        result.add("🛏️ 겨울용 침낭 추천해줘");
	        result.add("📦 침낭 대여 가능해?");
	        result.add("🌡️ 침낭 고르는 기준 알려줘");
	    } else if (lastMessage.contains("대여")) {
	        result.add("📅 대여 기간은 어떻게 정해?");
	        result.add("💰 보증금은 언제 환불돼?");
	        result.add("📦 반납은 어떻게 해?");
	    } else if (lastMessage.contains("배송")) {
	        result.add("🚚 배송비는 얼마야?");
	        result.add("📦 배송은 얼마나 걸려?");
	        result.add("🏝️ 제주도 배송비 알려줘");
	    } else {
	        result.add("⛺ 텐트 추천해줘");
	        result.add("🛏️ 침낭 종류 알려줘");
	        result.add("🏕️ 초보 캠퍼 필수 장비 알려줘");
	    }

	    return result;
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