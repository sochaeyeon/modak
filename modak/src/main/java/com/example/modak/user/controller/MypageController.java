package com.example.modak.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.modak.user.dao.MypageService;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.User;

import jakarta.servlet.http.HttpSession;

@Controller
public class MypageController {
	@Autowired
	MypageService mypageService;

	@Autowired
	HttpSession session;

	@RequestMapping("/user/mypage.do")
	public String myPage(Model model) {

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || sessionId.equals("")) {
			return "redirect:/user/login.do";
		}

		User user = mypageService.getMyPageUser(sessionId);
		MypageSummary summary = mypageService.getMypageSummary(sessionId);

		model.addAttribute("user", user);
		model.addAttribute("summary", summary);

		return "user/mypage";
	}

}
