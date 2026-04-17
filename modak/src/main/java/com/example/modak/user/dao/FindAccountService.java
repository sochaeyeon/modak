package com.example.modak.user.dao;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
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
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.modak.common.Message;
import com.example.modak.user.mapper.FindAccountMapper;
import com.example.modak.user.model.User;

@Service
public class FindAccountService {

	@Autowired
	FindAccountMapper findAccountMapper;

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Value("${solapi.api-key}")
	private String solapiApiKey;

	@Value("${solapi.api-secret}")
	private String solapiApiSecret;

	@Value("${solapi.sender-number}")
	private String senderNumber;

	// 아이디 찾기
	public HashMap<String, Object> getUserId(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			User info = findAccountMapper.selectUserId(map);
			if (info != null) {
				resultMap.put("message", Message.SUCCESS_SELECT);
				resultMap.put("info", info);
				resultMap.put("result", "success");
			} else {
				resultMap.put("message", Message.USER_NOT_FOUND);
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	// 문자 인증

	// 문자 인증번호 발송
	public HashMap<String, Object> sendSmsCode(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userName = String.valueOf(map.get("userName"));
			String userPhone = String.valueOf(map.get("userPhone"));

			if (userName == null || userName.trim().equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이름을 입력해 주세요.");
				return resultMap;
			}

			if (userPhone == null || userPhone.trim().equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "휴대폰 번호를 입력해 주세요.");
				return resultMap;
			}

			String authCode = createAuthCode();

			map.put("authCode", authCode);
			map.put("authPurpose", "FIND_ID");
			map.put("expireAt",
					LocalDateTime.now().plusMinutes(3).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

			// 기존 미인증 번호 만료
			findAccountMapper.expireSmsAuth(map);

			// 새 인증번호 저장
			findAccountMapper.insertSmsAuth(map);

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

	// 인증번호 확인
	public HashMap<String, Object> verifySmsCode(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> authInfo = findAccountMapper.selectLatestSmsAuth(map);

			if (authInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증 요청 정보가 없어요.");
				return resultMap;
			}

			String dbCode = String.valueOf(authInfo.get("AUTH_CODE"));
			String authYn = String.valueOf(authInfo.get("AUTH_YN"));
			String expireAt = String.valueOf(authInfo.get("EXPIRE_AT"));
			String inputCode = String.valueOf(map.get("authCode"));

			if ("Y".equals(authYn)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이미 인증이 완료되었어요.");
				return resultMap;
			}

			LocalDateTime expireTime = LocalDateTime.parse(expireAt.replace(" ", "T"));
			if (LocalDateTime.now().isAfter(expireTime)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증번호가 만료되었어요.");
				return resultMap;
			}

			if (!dbCode.equals(inputCode)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증번호가 일치하지 않아요.");
				return resultMap;
			}

			findAccountMapper.updateSmsAuthVerified(map);

			resultMap.put("result", "success");
			resultMap.put("message", "휴대폰 인증이 완료되었어요.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "인증 확인 중 오류가 발생했어요.");
		}

		return resultMap;
	}

	// 이름 + 전화번호 + 인증완료 후 아이디 찾기
	public HashMap<String, Object> findIdByPhone(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> verifiedInfo = findAccountMapper.selectVerifiedSmsAuth(map);

			if (verifiedInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "휴대폰 인증을 먼저 완료해 주세요.");
				return resultMap;
			}

			User info = findAccountMapper.selectUserByNameAndPhone(map);

			if (info != null) {
				resultMap.put("result", "success");
				resultMap.put("info", info);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "입력하신 정보와 일치하는 아이디가 없어요.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "아이디 조회 중 오류가 발생했어요.");
		}

		return resultMap;
	}

	// 6자리 인증번호 생성
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

		Map<String, Object> message = new HashMap<>();
		message.put("to", to);
		message.put("from", senderNumber);
		message.put("text", text);

		Map<String, Object> body = new HashMap<>();
		body.put("message", message);

		HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

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

	// 이메일 인증
	public HashMap<String, Object> sendPwAuthEmail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = String.valueOf(map.get("userId")).trim();
			String email = String.valueOf(map.get("email")).trim();

			map.put("userId", userId);
			map.put("email", email);

			User user = findAccountMapper.selectUserByIdAndEmail(map);

			if (user == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "입력한 아이디와 이메일이 일치하는 회원이 없어요.");
				return resultMap;
			}

			String authCode = createAuthCode();
			LocalDateTime expireAt = LocalDateTime.now().plusMinutes(5);

			HashMap<String, Object> authMap = new HashMap<>();
			authMap.put("userId", userId);
			authMap.put("email", email);
			authMap.put("authCode", authCode);
			authMap.put("authType", "PW_RESET");
			authMap.put("expireAt", expireAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

			// 기존 인증 제거
			findAccountMapper.deletePwResetAuth(authMap);

			// 새 인증 저장
			findAccountMapper.insertPwResetAuth(authMap);

			// 메일 발송
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(email);
			message.setSubject("[모닥모닥] 비밀번호 재설정 인증번호");
			message.setText("안녕하세요, 모닥모닥입니다.\n\n" + "비밀번호 재설정 인증번호는 [" + authCode + "] 입니다.\n"
					+ "인증번호는 5분 동안 유효합니다.\n\n" + "본인이 요청하지 않았다면 이 메일을 무시해 주세요.");

			mailSender.send(message);

			resultMap.put("result", "success");
			resultMap.put("message", "인증메일을 발송했어요.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "이메일 발송 중 오류가 발생했어요.");
		}

		return resultMap;
	}

	// 이메일 인증번호 확인
	public HashMap<String, Object> verifyPwAuthEmail(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String userId = String.valueOf(map.get("userId")).trim();
	        String email = String.valueOf(map.get("email")).trim();
	        String authCode = String.valueOf(map.get("authCode")).trim();

	        map.put("userId", userId);
	        map.put("email", email);
	        map.put("authCode", authCode);
	        map.put("authType", "PW_RESET");

	        Map<String, Object> authInfo = findAccountMapper.selectPwResetAuth(map);

	        if (authInfo == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "인증번호가 올바르지 않아요.");
	            return resultMap;
	        }

	        findAccountMapper.updatePwResetAuthVerified(map);

	        // 🔥 여기 추가: 사용자 조회
	        User info = findAccountMapper.selectUserById(map);

	        resultMap.put("result", "success");
	        resultMap.put("message", "이메일 인증이 완료되었어요.");
	        resultMap.put("userName", info.getUserName());

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "인증 확인 중 오류가 발생했어요.");
	    }

	    return resultMap;
	}

	// 비밀번호 재설정
	public HashMap<String, Object> resetPassword(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = String.valueOf(map.get("userId")).trim();
			String newPassword = String.valueOf(map.get("newPassword")).trim();

			map.put("userId", userId);
			map.put("authType", "PW_RESET");

			Map<String, Object> authInfo = findAccountMapper.selectVerifiedPwResetAuth(map);

			if (authInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이메일 인증 완료 후 비밀번호를 변경해 주세요.");
				return resultMap;
			}

			String encodedPwd = passwordEncoder.encode(newPassword);

			HashMap<String, Object> updateMap = new HashMap<>();
			updateMap.put("userId", userId);
			updateMap.put("userPwd", encodedPwd);

			findAccountMapper.updateUserPassword(updateMap);

			findAccountMapper.deletePwResetAuth(map);

			resultMap.put("result", "success");
			resultMap.put("message", "비밀번호가 변경되었어요.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "비밀번호 변경 중 오류가 발생했어요.");
		}

		return resultMap;
	}

}
