package com.example.modak.csCenter.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.csCenter.dao.InquiryService;
import com.example.modak.csCenter.model.Inquiry;
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
		return "/inquiry/inquiry-form";
	}

	// 문의 목록 페이지
	@RequestMapping("/user/inquiry/history.do")
	public String inquiryHistory(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "/inquiry/inquiry-history";
	}

	@RequestMapping(value = "/user/inquiry/edit.do")
	public String inquiryEditPage(
	        @RequestParam(value = "inquiryId", required = false) Integer inquiryId,
	        HttpSession session,
	        Model model) {

	    String sessionId = (String) session.getAttribute("sessionId");

	    if (sessionId == null || sessionId.equals("")) {
	        return "redirect:/user/login.do";
	    }

	    if (inquiryId == null) {
	        return "redirect:/user/inquiry/history.do";
	    }

	    model.addAttribute("inquiryId", inquiryId);
	    return "/inquiry/inquiry-edit";
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

	@RequestMapping(value = "/user/inquiry/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiryDetail(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		String sessionId = (String) session.getAttribute("sessionId");

		if (sessionId == null || "".equals(sessionId)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", sessionId);

		Inquiry inquiry = inquiryService.getInquiryForEdit(map);

		if (inquiry == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "문의 정보를 찾을 수 없습니다.");
		} else if (inquiry.getReplyId() > 0) {
			resultMap.put("result", "fail");
			resultMap.put("message", "답변이 등록된 문의는 수정할 수 없습니다.");
		} else {
			resultMap.put("result", "success");
			resultMap.put("inquiry", inquiry);
		}

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
	public String deleteInquiry(@RequestParam HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || "".equals(sessionId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			map.put("userId", sessionId);

			resultMap = inquiryService.removeInquiry(map);

		} catch (Exception e) {
			e.printStackTrace(); // 🔥 반드시 찍어라

			resultMap.put("result", "fail");
			resultMap.put("message", "삭제 중 오류 발생");
		}

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/inquiry/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public HashMap<String, Object> addInquiry(@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) List<MultipartFile> files, HttpSession session) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String userId = (String) session.getAttribute("sessionId");

			map.put("userId", userId);
			map.put("inquiryStatus", "WAIT");

			int result = inquiryService.addInquiry(map);

			if (result > 0) {

				// 🔥 여기 추가
				if (files != null && !files.isEmpty()) {
					inquiryService.saveInquiryFiles(map, files, session);
				}

				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
		}

		return resultMap;
	}

	@RequestMapping(value = "/user/inquiry/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public HashMap<String, Object> editInquiry(@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) List<MultipartFile> files,
			@RequestParam(value = "deletedImageIdList", required = false) List<Integer> deletedImageIdList,
			HttpSession session) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || sessionId.equals("")) {
				resultMap.put("result", "loginRequired");
				return resultMap;
			}

			map.put("userId", sessionId);

			int result = inquiryService.editInquiry(map);

			if (result > 0) {
				if (deletedImageIdList != null && !deletedImageIdList.isEmpty()) {
					inquiryService.deleteInquiryEditImages(deletedImageIdList, session);
				}

				if (files != null && !files.isEmpty()) {
					inquiryService.saveInquiryEditFiles(map, files, session);
				}

				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "수정할 수 없거나 이미 답변이 등록된 문의입니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", "수정 중 오류가 발생했습니다.");
		}

		return resultMap;
	}

}