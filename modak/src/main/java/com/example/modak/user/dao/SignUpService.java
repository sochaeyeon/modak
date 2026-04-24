package com.example.modak.user.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.user.mapper.SignUpMapper;
import com.example.modak.user.model.User;

@Service
public class SignUpService {
	
	@Autowired
	SignUpMapper signUpMapper;

	@Autowired
	CouponService couponService; // 쿠폰 관리
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	// 회원 아이디 중복체크
		public HashMap<String, Object> getUserCheck(HashMap<String, Object> map) {
			HashMap<String, Object> resultMap = new HashMap<>();
			try {
				User info = signUpMapper.selectUser(map);
				
				if (info != null) {
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

	// 회원가입
		public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        String hashPwd = passwordEncoder.encode((String) map.get("userPwd"));
		        map.put("userPwd", hashPwd);

		        // ★ marketingYn이 null이면 'N' 기본값 설정
		        if (map.get("marketingYn") == null || map.get("marketingYn").toString().isEmpty()) {
		            map.put("marketingYn", "N");
		        }

		        int result = signUpMapper.insertUser(map);
		        
			
			if (result > 0) {
				couponService.issueWelcomeCoupon((String) map.get("userId"));
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
}
