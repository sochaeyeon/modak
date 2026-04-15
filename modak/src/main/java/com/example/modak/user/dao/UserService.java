package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.user.mapper.UserMapper;
import com.example.modak.user.model.SocialUserInfo;
import com.example.modak.user.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	
	@Autowired
	UserMapper userMapper;
	
	@Autowired
	HttpSession session;

	@Autowired
	PasswordEncoder passwordEncoder;
	
	// 회원가입
	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("userPwd"));
			map.put("userPwd", hashPwd);	
			int result = userMapper.insertUser(map);
			if(result > 0) {
				resultMap.put("message", Message.USER_SIGNUP_SUCCESS);
			} else {
				resultMap.put("message", Message.ERROR_COMMON);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}
	
	// 회원 아이디 중복체크
	public HashMap<String, Object> getUserCheck(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			User info = userMapper.selectUser(map);
			if(info != null) {
				resultMap.put("message", "중복된 아이디입니다.");
			} else {
				resultMap.put("message", "사용 가능한 아이디입니다!");
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
	
	// 로그인
	public HashMap<String, Object> getUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			User info = userMapper.selectUser(map);
			if (info != null) {
				if (passwordEncoder.matches((String) map.get("userPwd"), info.getUserPwd())) {
					resultMap.put("message", Message.USER_LOGIN_SUCCESS);
					resultMap.put("loginResult", true);
					session.setAttribute("sessionId", info.getUserId());
					session.setAttribute("sessionName", info.getUserName());
					
//					session.invalidate(); // 세션에 있는 모든 정보 삭제(로그아웃 버튼 누르면 실행되게)
				} else {
					resultMap.put("message", Message.USER_LOGIN_FAIL_PWD);
				}
			} else {
				resultMap.put("message", Message.USER_LOGIN_FAIL_ID);
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
	 public UserService(UserMapper userMapper) {
	        this.userMapper = userMapper;
	    }

	    public User getOrCreateSocialUser(SocialUserInfo info) {

	        HashMap<String, Object> map = new HashMap<>();
	        map.put("socialType", info.getSocialType());
	        map.put("socialId", info.getSocialId());

	        // 1. 기존 회원 조회
	        User user = userMapper.selectUserBySocial(map);
	        if (user != null) {
	            return user;
	        }

	        // 2. 신규 회원 생성
	        String userId = createUserId(info.getSocialType());

	        HashMap<String, Object> insertMap = new HashMap<>();
	        insertMap.put("userId", userId);
	        insertMap.put("userName", info.getUserName());
	        insertMap.put("email", info.getEmail());
	        insertMap.put("nickName", info.getNickName());
	        insertMap.put("socialType", info.getSocialType());
	        insertMap.put("socialId", info.getSocialId());

	        userMapper.insertSocialUser(insertMap);

	        map.put("socialType", info.getSocialType());
	        map.put("socialId", info.getSocialId());

	        return userMapper.selectUserBySocial(map);
	    }

	    private String createUserId(String socialType) {
	        while (true) {
	            String userId = socialType.toLowerCase() + "_" +
	                    UUID.randomUUID().toString().substring(0, 8);

	            HashMap<String, Object> map = new HashMap<>();
	            map.put("userId", userId);

	            if (userMapper.countUserId(map) == 0) {
	                return userId;
	            }
	        }
	    }
}
