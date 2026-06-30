package com.example.modak.product.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.modak.product.mapper.ProductMapper;
import com.example.modak.product.mapper.ProductRecommendMapper;
import com.example.modak.product.model.Product;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

@Service
public class ProductRecommendService {

	@Value("${gemini.api.key}")
	private String apiKey;

	private final String model = "gemini-2.5-flash-lite";
	private final ObjectMapper objectMapper = new ObjectMapper();

	// ProductMapper는 이미 있는 거 그대로 주입
	private final ProductMapper productMapper;

	// 캐시 테이블(PRODUCT_RECOMMEND) 조회/저장용 매퍼
	private final ProductRecommendMapper recommendMapper;

	public ProductRecommendService(ProductMapper productMapper, ProductRecommendMapper recommendMapper) {
		this.productMapper = productMapper;
		this.recommendMapper = recommendMapper;
	}

	private List<Product> computeRecommend(int productId) {
		// ① 현재 상품 정보 조회
		HashMap<String, Object> param = new HashMap<>();
		param.put("productId", productId);
		Product current = productMapper.selectProduct(param);
		if (current == null)
			return List.of();

		// ② 같은 카테고리 후보 최대 30개 조회 (현재 상품 제외)
		HashMap<String, Object> candidateParam = new HashMap<>();
		candidateParam.put("categoryId", current.getCategoryId());
		candidateParam.put("productId", productId);
		List<Product> candidates = productMapper.selectCoPurchasedCandidates(candidateParam);
		if (candidates.isEmpty())
			return List.of();

		// ③ 프롬프트 구성
		StringBuilder prompt = new StringBuilder();
		prompt.append("현재 상품: ").append(current.getProductName()).append(" / 카테고리: ").append(current.getCategoryName())
				.append(" / 가격: ").append(current.getPrice()).append("원\n\n");
		prompt.append("아래 후보 상품 중 현재 상품과 함께 구매하면 잘 어울리는 상품 4개를 골라줘.\n");
		prompt.append("반드시 productId만 JSON 배열로만 반환해. 설명 없이 숫자 배열만: [1,2,3,4]\n\n");
		prompt.append("후보 상품 목록:\n");
		for (Product p : candidates) {
			prompt.append("[").append(p.getProductId()).append("] ").append(p.getProductName()).append(" / ")
					.append(p.getPrice()).append("원\n");
		}

		// ④ Gemini 호출
		String aiResponse = callGemini(prompt.toString());

		// ⑤ 응답 파싱 실패 시 후보 앞 4개 반환
		List<Integer> ids = parseIds(aiResponse);
		if (ids.isEmpty()) {
			return candidates.subList(0, Math.min(4, candidates.size()));
		}

		// ⑥ AI가 뽑은 id로 실제 상품 조회
		HashMap<String, Object> idsParam = new HashMap<>();
		idsParam.put("ids", ids);
		List<Product> result = productMapper.selectProductsByIds(idsParam);

		return result.isEmpty() ? candidates.subList(0, Math.min(4, candidates.size())) : result;
	}

	// 매달 1일 새벽 3시에 전체 상품 재분석 → 결과를 PRODUCT_RECOMMEND 테이블에 저장
	@Scheduled(cron = "0 0 3 1 * *")
	public void refreshAllRecommendations() {
		List<Integer> productIds = recommendMapper.selectAllProductIds();

		for (Integer productId : productIds) {
			try {
				List<Product> result = computeRecommend(productId);

				HashMap<String, Object> delMap = new HashMap<>();
				delMap.put("productId", productId);
				recommendMapper.deleteRecommendByProductId(delMap);

				int rank = 1;
				for (Product p : result) {
					HashMap<String, Object> insertMap = new HashMap<>();
					insertMap.put("productId", productId);
					insertMap.put("recommendedProductId", p.getProductId());
					insertMap.put("rankOrder", rank++);
					insertMap.put("basis", "co-purchase");
					recommendMapper.insertRecommend(insertMap);
				}
			} catch (Exception e) {
				e.printStackTrace(); // 한 상품 실패해도 나머지는 계속 돌게
			}
		}
	}

	// 컨트롤러가 실제로 호출하는 메서드 - AI 호출 없이 캐시 테이블만 조회
	public List<Product> getRecommend(int productId) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("productId", productId);

		List<HashMap<String, Object>> cached = recommendMapper.selectCachedRecommend(map);

		if (cached.isEmpty()) {
			HashMap<String, Object> param = new HashMap<>();
			param.put("productId", productId);
			Product current = productMapper.selectProduct(param);
			if (current == null)
				return List.of();

			HashMap<String, Object> categoryParam = new HashMap<>();
			categoryParam.put("categoryId", current.getCategoryId());
			categoryParam.put("productId", productId);
			List<Product> candidates = productMapper.selectRecommendCandidates(categoryParam);
			return candidates.subList(0, Math.min(4, candidates.size()));
		}

		// ← 이 부분을 교체: ids로 다시 조회하지 않고 캐시 결과를 Product로 변환
		return cached.stream().map(m -> {
			Product p = new Product();
			p.setProductId(((Number) m.get("productId")).intValue());
			p.setProductName((String) m.get("productName"));
			p.setProductType((String) m.get("productType"));
			p.setPrice(((Number) m.get("price")).intValue());
			p.setBrandName((String) m.get("brandName"));
			p.setImgUrl((String) m.get("imgUrl"));
			p.setRating(((Number) m.get("rating")).doubleValue());
			p.setRCount(((Number) m.get("rCount")).intValue());
			if (m.get("categoryId") != null)
				p.setCategoryId(((Number) m.get("categoryId")).intValue());
			return p;
		}).collect(Collectors.toList());
	}

	private List<Integer> parseIds(String text) {
		List<Integer> result = new ArrayList<>();
		if (text == null)
			return result;
		Matcher m = Pattern.compile("\\d+").matcher(text);
		while (m.find())
			result.add(Integer.parseInt(m.group()));
		return result;
	}

	private String callGemini(String prompt) {
		try {
			String url = "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent?key="
					+ apiKey;

			Map<String, Object> body = Map.of("contents", List.of(Map.of("parts", List.of(Map.of("text", prompt)))));

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);

			RestTemplate restTemplate = new RestTemplate();
			ResponseEntity<String> response = restTemplate.postForEntity(url, new HttpEntity<>(body, headers),
					String.class);

			JsonNode root = objectMapper.readTree(response.getBody());
			return root.path("candidates").path(0).path("content").path("parts").path(0).path("text").asText(null);

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}