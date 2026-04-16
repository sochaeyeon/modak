package com.example.modak.chat.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 모닥모닥 AI 챗봇 서비스 (Google Gemini API 연동)
 */
@Service
public class ChatService {

    // application.properties에 등록한 API 키를 가져옵니다.
    @Value("${gemini.api.key}")
    private String apiKey;

    /**
     * 사용자의 질문을 받아 Gemini API에 전달하고 답변을 반환합니다.
     */
    public String getGeminiResponse(String userMessage) {
        // 1. Gemini 1.5 Flash 모델 API 엔드포인트 URL
        String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;

        // 2. HTTP 통신을 위한 RestTemplate 설정
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // 3. API 요청 바디 구성 (Gemini JSON 규격 준수)
        Map<String, Object> requestBody = new HashMap<>();
        List<Map<String, Object>> contents = new ArrayList<>();
        Map<String, Object> content = new HashMap<>();
        List<Map<String, Object>> parts = new ArrayList<>();
        Map<String, Object> textPart = new HashMap<>();

        // [중요] 페르소나 설정: 챗봇에게 역할을 부여합니다.
        String systemInstruction = "너는 캠핑 전문 AI 도우미 '모닥모닥'이야. "
                                 + "사용자들에게 친절하고 따뜻하게 캠핑 정보와 장비 추천을 해줘. "
                                 + "답변은 반드시 한국어로 하고, 끝에는 항상 '즐거운 캠핑 되세요! 🔥'라고 덧붙여줘.";

        textPart.put("text", systemInstruction + "\n사용자 질문: " + userMessage);
        
        parts.add(textPart);
        content.put("parts", parts);
        contents.add(content);
        requestBody.put("contents", contents);

        // 4. 요청 보내기
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            
            // 5. 복잡한 응답 JSON에서 텍스트만 파싱 (candidates[0].content.parts[0].text)
            if (response.getBody() != null) {
                List candidates = (List) response.getBody().get("candidates");
                if (candidates != null && !candidates.isEmpty()) {
                    Map firstCandidate = (Map) candidates.get(0);
                    Map contentMap = (Map) firstCandidate.get("content");
                    List partsList = (List) contentMap.get("parts");
                    Map firstPart = (Map) partsList.get(0);
                    
                    return (String) firstPart.get("text");
                }
            }
            return "답변을 가져오지 못했습니다. 다시 시도해 주세요.";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "서버 통신 오류가 발생했습니다. 불씨가 잠시 꺼진 것 같아요! 🔥";
        }
    }
}