package com.example.modak.user.dao;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Random;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.modak.user.mapper.SmsAuthMapper;
import com.example.modak.user.mapper.UserSettingsMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class SmsAuthService {

	@Autowired
	SmsAuthMapper smsAuthMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	UserSettingsMapper userSettingsMapper;

	@Value("${solapi.api-key}")
	private String solapiApiKey;

	@Value("${solapi.api-secret}")
	private String solapiApiSecret;

	@Value("${solapi.sender-number}")
	private String senderNumber;

	public HashMap<String, Object> sendSmsCode(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userName = map.get("userName") == null ? "" : String.valueOf(map.get("userName")).trim();
			String userPhone = map.get("userPhone") == null ? "" : String.valueOf(map.get("userPhone")).trim();
			String authPurpose = map.get("authPurpose") == null ? "" : String.valueOf(map.get("authPurpose")).trim();

			if ("".equals(userPhone)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "휴대폰 번호를 입력해 주세요.");
				return resultMap;
			}

			if ("".equals(authPurpose)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증 목적이 올바르지 않아요.");
				return resultMap;
			}

			String authCode = createAuthCode();

			map.put("userName", userName);
			map.put("userPhone", userPhone);
			map.put("authCode", authCode);
			map.put("expireAt",
					LocalDateTime.now().plusMinutes(3).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

			smsAuthMapper.expireSmsAuth(map);
			smsAuthMapper.insertSmsAuth(map);

			String smsText = "[모닥모닥] 인증번호는 [" + authCode + "] 입니다.";
			sendSmsBySolapi(userPhone, smsText);

			resultMap.put("result", "success");
			resultMap.put("message", "인증번호를 발송했어요.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "문자 발송 중 오류가 발생했어요.");
		}

		return resultMap;
	}

	public HashMap<String, Object> verifySmsCode(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");
			map.put("sessionId", sessionId);

			HashMap<String, Object> authInfo = smsAuthMapper.selectLatestSmsAuth(map);

			if (authInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증번호를 다시 요청해주세요.");
				return resultMap;
			}

			String dbAuthCode = String.valueOf(authInfo.get("AUTH_CODE"));
			String inputAuthCode = String.valueOf(map.get("authCode"));
			String authYn = String.valueOf(authInfo.get("AUTH_YN"));

			if ("Y".equals(authYn)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이미 인증 완료된 번호입니다.");
				return resultMap;
			}

			if (!dbAuthCode.equals(inputAuthCode)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증번호가 올바르지 않습니다.");
				return resultMap;
			}

			// 1. SMS_AUTH 인증 완료 처리
			smsAuthMapper.updateSmsAuthVerified(map);

			// 2. USER 테이블 인증 완료 처리
			userSettingsMapper.updatePhoneVerified(map);

			resultMap.put("result", "success");
			resultMap.put("message", "휴대폰 인증이 완료되었습니다.");
			resultMap.put("phoneVerifiedAt",
					LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "서버 오류가 발생했습니다.");
		}

		return resultMap;
	}

	public HashMap<String, Object> selectVerifiedSmsAuth(HashMap<String, Object> map) {
		return smsAuthMapper.selectVerifiedSmsAuth(map);
	}

	private String createAuthCode() {
		Random random = new Random();
		int number = 100000 + random.nextInt(900000);
		return String.valueOf(number);
	}

	private void sendSmsBySolapi(String to, String text) throws Exception {
		String url = "https://api.solapi.com/messages/v4/send";

		String date = DateTimeFormatter.ISO_INSTANT.format(Instant.now());
		String salt = UUID.randomUUID().toString().replace("-", "");

		String signature = makeSolapiSignature(date, salt);

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", "HMAC-SHA256 apiKey=" + solapiApiKey + ", date=" + date + ", salt=" + salt
				+ ", signature=" + signature);

		HashMap<String, Object> message = new HashMap<>();
		message.put("to", to);
		message.put("from", senderNumber);
		message.put("text", text);

		HashMap<String, Object> body = new HashMap<>();
		body.put("message", message);

		HttpEntity<HashMap<String, Object>> request = new HttpEntity<>(body, headers);

		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

		if (!response.getStatusCode().is2xxSuccessful()) {
			throw new RuntimeException("SMS 발송 실패 : " + response.getBody());
		}

		System.out.println("SOLAPI 응답 : " + response.getBody());
	}

	private String makeSolapiSignature(String date, String salt) throws Exception {
		String message = date + salt;

		Mac mac = Mac.getInstance("HmacSHA256");
		SecretKeySpec secretKeySpec = new SecretKeySpec(solapiApiSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
		mac.init(secretKeySpec);

		byte[] rawHmac = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));

		StringBuilder sb = new StringBuilder();
		for (byte b : rawHmac) {
			sb.append(String.format("%02x", b));
		}
		return sb.toString();
	}
}