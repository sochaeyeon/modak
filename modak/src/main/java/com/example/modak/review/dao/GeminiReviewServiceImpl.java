package com.example.modak.review.dao;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.modak.review.mapper.ReviewSummaryMapper;
import com.example.modak.review.model.ReviewStat;
import com.example.modak.review.model.ReviewSummary;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeminiReviewServiceImpl implements GeminiReviewService {

	@Value("${gemini.api.key}")
	private String apiKey;

	private String model = "gemini-2.5-flash-lite";
	private final ObjectMapper objectMapper = new ObjectMapper();

	private static final String AI_FALLBACK_MESSAGE = "리뷰를 정리하는 중이에요 😊\n조금 더 많은 리뷰가 쌓이면 더 정확한 요약을 제공해드릴게요";
	@Autowired
	private ReviewSummaryMapper reviewSummaryMapper;

	@Override
	public String summarizeReviews(List<String> reviews) {
		if (reviews == null || reviews.isEmpty()) {
			return "아직 요약할 리뷰가 없습니다.";
		}

		List<String> validReviews = reviews.stream().filter(Objects::nonNull).map(String::trim)
				.filter(s -> !s.isEmpty()).limit(20).toList();

		if (validReviews.isEmpty()) {
			return "아직 요약할 리뷰가 없습니다.";
		}

		String prompt = """
				아래 상품 리뷰들을 보고 쇼핑몰 사용자에게 보여줄 리뷰 요약을 작성해줘.

				조건:
				- 3문장 이내
				- 장점과 아쉬운 점을 균형 있게 작성
				- 과장하지 말 것
				- 한국어로 자연스럽게 작성
				- "리뷰에 따르면" 같은 표현은 사용 가능
				- 말투는 모닥모닥 서비스 분위기에 맞게 부드럽고 귀엽게 작성
				- 너무 과한 이모지는 쓰지 말고, 필요한 경우 문장 끝에 1개 정도만 사용
				- 딱딱한 분석 보고서처럼 쓰지 말 것

				리뷰 목록:
				""" + String.join("\n", validReviews);

		return callGemini(prompt);
	}

	@Override
	public String getOrCreateSummary(int productId) {

		ReviewStat stat = reviewSummaryMapper.selectReviewStat(productId);

		if (stat == null || stat.getReviewCount() == 0) {
			return "아직 요약할 리뷰가 없습니다.";
		}

		ReviewSummary saved = reviewSummaryMapper.selectReviewSummary(productId);

		if (saved != null && saved.getReviewCount() == stat.getReviewCount()
				&& Objects.equals(saved.getLastReviewUpdatedAt(), stat.getLastReviewUpdatedAt())) {
			return saved.getSummaryText();
		}

		List<String> reviews = reviewSummaryMapper.selectReviewContents(productId);

		String newSummary = summarizeReviews(reviews);
		if (newSummary.contains("리뷰를 정리하는 중이에요")) {
		    return newSummary; // ❗ DB 저장하지 않고 바로 반환
		}
		ReviewSummary summary = new ReviewSummary();
		summary.setProductId(productId);
		summary.setSummaryText(newSummary);
		summary.setReviewCount(stat.getReviewCount());
		summary.setLastReviewUpdatedAt(stat.getLastReviewUpdatedAt());
		
		if (saved == null) {
			reviewSummaryMapper.insertReviewSummary(summary);
		} else {
			reviewSummaryMapper.updateReviewSummary(summary);
		}

		return newSummary;
	}

	private String callGemini(String prompt) {
		try {
			String url = "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent?key="
					+ apiKey;

			Map<String, Object> body = Map.of("contents", List.of(Map.of("parts", List.of(Map.of("text", prompt)))));

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);

			HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

			RestTemplate restTemplate = new RestTemplate();
			ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);

			JsonNode root = objectMapper.readTree(response.getBody());

			return root.path("candidates").path(0).path("content").path("parts").path(0).path("text")
					.asText("리뷰 요약을 생성하지 못했습니다.");

		} catch (HttpServerErrorException.ServiceUnavailable e) {
			e.printStackTrace();
			return AI_FALLBACK_MESSAGE;

		} catch (HttpServerErrorException e) {
			e.printStackTrace();

			if (e.getStatusCode() == HttpStatus.SERVICE_UNAVAILABLE) {
				return AI_FALLBACK_MESSAGE;
			}

			return "리뷰 요약을 잠시 불러오지 못했어요.\n조금 뒤에 다시 확인해 주세요 😊";

		} catch (Exception e) {
			e.printStackTrace();
			return "리뷰 요약을 잠시 불러오지 못했어요.\n조금 뒤에 다시 확인해 주세요 😊";
		}
	}
}