package com.example.modak.csCenter.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.modak.csCenter.dao.InquiryService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class InquiryController {

	@Autowired
	InquiryService inquiryService;

	@Autowired
	HttpSession session;

	// 문의 작성 페이지
	@RequestMapping("/inquiry.do")
	public String test1(HttpServletRequest request) throws Exception {
		return "/cs/inquiry-form";
	}

	// 문의 목록 페이지
	@RequestMapping("/user/inquiry/history.do")
	public String inquiryHistory(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "/inquiry/inquiry-history";
	}

	// 내 문의 목록 조회
	@RequestMapping(value = "/user/inquiry/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || "".equals(sessionId)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		// 프론트에서 page, pageSize 안 왔을 때 대비
		if (map.get("page") == null || "".equals(String.valueOf(map.get("page")))) {
			map.put("page", 1);
		}

		if (map.get("pageSize") == null || "".equals(String.valueOf(map.get("pageSize")))) {
			map.put("pageSize", 6);
		}

		map.put("userId", sessionId);

		resultMap = inquiryService.getInquiryList(map);
		return new Gson().toJson(resultMap);
	}

	// 문의 이미지 조회
	@RequestMapping(value = "/user/inquiry/img/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryImgList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || "".equals(sessionId)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		resultMap = inquiryService.getInquiryImgList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/user/inquiry/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteInquiry(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || "".equals(sessionId)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", sessionId);

		resultMap = inquiryService.removeInquiry(map);
		return new Gson().toJson(resultMap);
	}

	// ─── 문의 접수 (POST 폼 Submit) ────────────────────────────────
	@RequestMapping(value = "/inquiry/submit.do", method = RequestMethod.POST)
	public String submitInquiry(HttpServletRequest request, @RequestParam HashMap<String, Object> map,
			RedirectAttributes ra) throws Exception {
		try {
			// 세션에서 userId 추출 (HttpServletRequest 통해 안전하게 접근)
			HttpSession session = request.getSession(false);
			if (session != null && map.get("userId") == null) {
				Object loginUser = session.getAttribute("loginUser");
				if (loginUser != null) {
					// 프로젝트 User 모델의 getter에 맞게 수정
					map.put("userId", ((com.example.modak.user.model.User) loginUser).getUserId());
				}
			}

			// 초기 상태 세팅
			map.put("inquiryStatus", "WAIT");

			int result = inquiryService.insertInquiry(map);
			if (result > 0) {
				ra.addFlashAttribute("successMsg", "문의가 정상적으로 접수되었습니다. 답변은 마이페이지에서 확인하실 수 있습니다.");
			} else {
				ra.addFlashAttribute("errorMsg", "접수 중 오류가 발생했습니다. 다시 시도해주세요.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("errorMsg", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
		return "redirect:/inquiry.do";
	}

}