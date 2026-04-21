package com.example.modak.user.dao;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.user.mapper.UserSettingsMapper;
import com.example.modak.user.model.PhoneVerification;
import com.example.modak.user.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserSettingsService {

	@Autowired
	UserSettingsMapper userSettingsMapper;

	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	// 계정설정 정보 조회
	public User getUserSettings(String userId) {
		return userSettingsMapper.selectUserSettings(userId);
	}

	// 기본정보 저장
	public int updateBasicInfo(User user, String originalPhone) {

		// 1. 전화번호 숫자만 남기기
		String newPhone = user.getUserPhone() == null ? "" : user.getUserPhone().replaceAll("[^0-9]", "");

		String oldPhone = originalPhone == null ? "" : originalPhone.replaceAll("[^0-9]", "");

		user.setUserPhone(newPhone);

		// 2. 기본정보 저장
		int result = userSettingsMapper.updateUserBasicInfo(user);

		// 3. 번호가 바뀌었으면 인증상태 초기화
		if (!oldPhone.equals(newPhone)) {
			userSettingsMapper.resetPhoneVerification(user.getUserId());
		}

		return result;
	}

	public HashMap<String, Object> updatePassword(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String sessionId = (String) session.getAttribute("sessionId");
	        map.put("sessionId", sessionId);

	        User user = userSettingsMapper.selectUserSettings(sessionId);

	        if (user == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "회원 정보를 찾을 수 없습니다.");
	            return resultMap;
	        }

	        String currentPwd = map.get("currentPwd") == null ? "" : map.get("currentPwd").toString();
	        String newPwd = map.get("newPwd") == null ? "" : map.get("newPwd").toString();

	        if (user.getUserPwd() == null || !passwordEncoder.matches(currentPwd, user.getUserPwd())) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "현재 비밀번호가 일치하지 않습니다.");
	            return resultMap;
	        }

	        if (passwordEncoder.matches(newPwd, user.getUserPwd())) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
	            return resultMap;
	        }

	        map.put("userPwd", passwordEncoder.encode(newPwd));
	        userSettingsMapper.updateUserPassword(map);

	        resultMap.put("result", "success");
	        resultMap.put("message", "비밀번호가 변경되었습니다.");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 오류가 발생했습니다.");
	    }

	    return resultMap;
	}
	
	// 인증번호 발급 + 저장
	public String createAndSaveSmsCode(String userId, String phone) {

		String verifyCode = generateVerifyCode();

		LocalDateTime expireTime = LocalDateTime.now().plusMinutes(3);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		PhoneVerification phoneVerification = new PhoneVerification();
		phoneVerification.setUserId(userId);
		phoneVerification.setPhone(phone);
		phoneVerification.setVerifyCode(verifyCode);
		phoneVerification.setExpireAt(expireTime.format(formatter));

		userSettingsMapper.insertPhoneVerification(phoneVerification);

		// 실제 SMS API 연동 전 테스트용
		System.out.println("[휴대폰 인증번호] userId=" + userId + ", phone=" + phone + ", code=" + verifyCode);

		return verifyCode;
	}

	// 인증번호 검증
	public boolean verifySmsCode(String userId, String phone, String inputCode) {

		PhoneVerification verification = userSettingsMapper.selectLatestPhoneVerification(userId, phone);

		// 최근 인증 내역 없음
		if (verification == null) {
			return false;
		}

		// 인증번호 불일치
		if (!inputCode.equals(verification.getVerifyCode())) {
			return false;
		}

		// 만료시간 체크
		LocalDateTime expireAt = LocalDateTime.parse(verification.getExpireAt(),
				DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

		if (LocalDateTime.now().isAfter(expireAt)) {
			return false;
		}

		// PHONE_VERIFICATION 인증 완료 처리
		userSettingsMapper.updatePhoneVerificationSuccess(verification.getVerificationId());

		// USER 인증 완료 처리
		userSettingsMapper.updateUserPhoneVerified(userId, phone);

		return true;
	}
	
	// 회원탈퇴
	public void deleteUser(String userId) {
	    userSettingsMapper.deleteUser(userId);
	}
	
	public HashMap<String, Object> updateUserSettings(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");
			map.put("sessionId", sessionId);

			String userPhone = map.get("userPhone") == null ? "" : map.get("userPhone").toString();
			String originalPhone = map.get("originalPhone") == null ? "" : map.get("originalPhone").toString();

			// 이름/닉네임은 항상 수정
			userSettingsMapper.updateUserBasicInfo(map);

			// 전화번호가 바뀐 경우 인증 초기화
			if (!userPhone.equals(originalPhone)) {
				userSettingsMapper.resetPhoneVerifyStatus(map);
			}

			resultMap.put("result", "success");
			resultMap.put("message", "회원정보가 저장되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "저장에 실패했습니다.");
		}

		return resultMap;
	}

	// 인증번호 6자리 생성
	private String generateVerifyCode() {
		Random random = new Random();
		int number = 100000 + random.nextInt(900000);
		return String.valueOf(number);
	}

	public int updateProfileImage(String userId, String profileImgUrl) {
		return userSettingsMapper.updateProfileImage(userId, profileImgUrl);
	}
}