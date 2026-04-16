package com.example.modak.chat.dao;

import java.util.ArrayList;
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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.HttpClientErrorException;

import com.example.modak.chat.mapper.ChatMapper;

@Service
public class ChatService {

    @Autowired
    private ChatMapper chatMapper;

    @Value("${gemini.api.key}")
    private String apiKey;

    public String getGeminiResponse(String userId, String userMessage, String roomId) {
        if (roomId == null || roomId.isEmpty()) {
            roomId = String.valueOf(System.currentTimeMillis());
        }

        // 1. 사용자 메시지 저장
        saveChat(userId, "user", userMessage, roomId);

        String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + apiKey;

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String systemInstruction = "너는 캠핑 상담원 '모닥이'야. 말끝에 '~닥'을 붙여줘. 끝엔 '즐거운 캠핑 되라닥! 🔥'라고 해줘.";

        // ===== 요청 바디 생성 =====
        Map<String, Object> requestBody = new HashMap<>();

        List<Map<String, Object>> contents = new ArrayList<>();
        Map<String, Object> content = new HashMap<>();

        List<Map<String, Object>> parts = new ArrayList<>();
        Map<String, Object> textPart = new HashMap<>();

        textPart.put("text", systemInstruction + "\n질문: " + userMessage);

        parts.add(textPart);
        content.put("parts", parts);
        content.put("role", "user"); // 중요 (Gemini 구조)

        contents.add(content);
        requestBody.put("contents", contents);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        int maxRetry = 3;

        for (int i = 0; i < maxRetry; i++) {
            try {
                ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

                String botResponse = parseBotMessage(response);

                // 2. 봇 응답 저장
                saveChat(userId, "bot", botResponse, roomId);

                return botResponse;

            } catch (HttpClientErrorException.TooManyRequests e) {
                // 429 에러 (쿼터 초과)
                System.err.println("429 Too Many Requests - 재시도 중...");
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException ie) {
                }

            } catch (HttpServerErrorException.ServiceUnavailable e) {
                // 503 에러
                System.err.println("503 Service Unavailable - 재시도 중...");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException ie) {
                }

            } catch (Exception e) {
                System.err.println("Gemini API Error: " + e.getMessage());
                break;
            }
        }

        return "지금 모닥불 앞에 사람이 너무 많다닥! 잠시 후에 다시 말해줘라닥! 🔥";
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

            if (body != null && body.containsKey("candidates")) {
                List candidates = (List) body.get("candidates");

                if (candidates != null && !candidates.isEmpty()) {
                    Map firstCandidate = (Map) candidates.get(0);
                    Map content = (Map) firstCandidate.get("content");
                    List parts = (List) content.get("parts");

                    if (parts != null && !parts.isEmpty()) {
                        Map firstPart = (Map) parts.get(0);
                        return (String) firstPart.get("text");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "모닥불 연기 때문에 대답을 못했다닥! 다시 물어봐줘라닥!";
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
}