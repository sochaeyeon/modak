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
	
	@Autowired
	CouponService couponService;

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
					session.setAttribute("sessionNickName", info.getNickName());
					session.setAttribute("sessionGradeIdS", info.getGradeId());
					session.setMaxInactiveInterval(30 * 60);

					String returnUrl = (String) session.getAttribute("returnUrl");

					if (returnUrl != null && !returnUrl.equals("")) {
						resultMap.put("moveUrl", returnUrl);
						session.removeAttribute("returnUrl");
					} else {
						resultMap.put("moveUrl", "/main.do");
					}

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

		User user = loginMapper.selectUserBySocial(map);

		if (user == null) {
			String userId = createUserId(info.getSocialType());

			HashMap<String, Object> insertMap = new HashMap<>();
			insertMap.put("userId", userId);
			insertMap.put("userName", info.getUserName());
			insertMap.put("email", info.getEmail());
			insertMap.put("nickName", info.getNickName());
			insertMap.put("socialType", info.getSocialType());
			insertMap.put("socialId", info.getSocialId());

			int result = loginMapper.insertSocialUser(insertMap);

	        if (result > 0) {
	            couponService.issueWelcomeCoupon(userId);
	        }

			user = loginMapper.selectUserBySocial(map);
		}

		if (user != null) {
			session.setAttribute("sessionId", user.getUserId());
			session.setAttribute("sessionName", user.getUserName());
			session.setAttribute("sessionNickName", user.getNickName());
			session.setAttribute("sessionGradeId", user.getGradeId());
			session.setMaxInactiveInterval(30 * 60);
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