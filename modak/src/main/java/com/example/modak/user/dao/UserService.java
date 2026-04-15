package com.example.modak.user.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.user.mapper.UserMapper;
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
					System.out.println(info);
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
}
