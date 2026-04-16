package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.user.mapper.LoginMapper;
import com.example.modak.user.model.SocialUserInfo;
import com.example.modak.user.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class LoginService {
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	LoginMapper loginMapper;
	
//  일반 로그인
	public HashMap<String, Object> getUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			User info = loginMapper.selectUser(map);

			if (info != null) {
				if (passwordEncoder.matches((String) map.get("userPwd"), info.getUserPwd())) {
					resultMap.put("message", Message.USER_LOGIN_SUCCESS);
					resultMap.put("loginResult", true);

					session.setAttribute("sessionId", info.getUserId());
					session.setAttribute("sessionName", info.getUserName());

				} else {
					resultMap.put("message", Message.USER_LOGIN_FAIL_PWD);
					resultMap.put("loginResult", false);
				}
			} else {
				resultMap.put("message", Message.USER_LOGIN_FAIL_ID);
				resultMap.put("loginResult", false);
			}

			resultMap.put("result", "success");

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}

		return resultMap;
	}

	// 소셜 로그인
	public User getOrCreateSocialUser(SocialUserInfo info) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("socialType", info.getSocialType());
		map.put("socialId", info.getSocialId());

		// 1. 기존 회원 조회
		User user = loginMapper.selectUserBySocial(map);

		if (user == null) {
			// 2. 신규 회원 생성
			String userId = createUserId(info.getSocialType());

			HashMap<String, Object> insertMap = new HashMap<>();
			insertMap.put("userId", userId);
			insertMap.put("userName", info.getUserName());
			insertMap.put("email", info.getEmail());
			insertMap.put("nickName", info.getNickName());
			insertMap.put("socialType", info.getSocialType());
			insertMap.put("socialId", info.getSocialId());

			loginMapper.insertSocialUser(insertMap);

			user = loginMapper.selectUserBySocial(map);
		}

		// 3. 일반 로그인과 동일하게 세션 값 저장
		if (user != null) {
			session.setAttribute("sessionId", user.getUserId());
			session.setAttribute("sessionName", user.getUserName());

		}
		return user;
	}

	private String createUserId(String socialType) {
		while (true) {
			String userId = socialType.toLowerCase() + "_"
					+ UUID.randomUUID().toString().replace("-", "").substring(0, 8);

			HashMap<String, Object> map = new HashMap<>();
			map.put("userId", userId);

			if (loginMapper.countUserId(map) == 0) {
				return userId;
			}
		}
	}
}
