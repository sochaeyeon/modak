package com.example.modak.user.controller;

import java.io.File;
import java.util.HashMap;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.user.dao.UserSettingsService;
import com.example.modak.user.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserSettingsController {

	@Autowired
	UserSettingsService userSettingsService;

	@Autowired
	HttpSession session;

	// 계정설정 조회
	@RequestMapping(value = "/user/settings/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getUserSettings() {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || "".equals(sessionId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			User info = userSettingsService.getUserSettings(sessionId);

			resultMap.put("result", "success");
			resultMap.put("info", info);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "조회 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}

	// 기본정보 저장
	@RequestMapping(value = "/user/settings/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateUserSettings(User user, String originalPhone) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || "".equals(sessionId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			user.setUserId(sessionId);

			userSettingsService.updateBasicInfo(user, originalPhone);

			resultMap.put("result", "success");
			resultMap.put("message", "회원정보가 저장되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "저장 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/user/settings/password/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updatePassword(@RequestParam HashMap<String, Object> map) {
		return new Gson().toJson(userSettingsService.updatePassword(map));
	}

	// 인증번호 발송
	@RequestMapping(value = "/user/settings/send-sms-code.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendSmsCode(String userPhone) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || "".equals(sessionId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			if (userPhone == null || "".equals(userPhone.trim())) {
				resultMap.put("result", "fail");
				resultMap.put("message", "휴대폰 번호를 입력해주세요.");
				return new Gson().toJson(resultMap);
			}

			String onlyNumberPhone = userPhone.replaceAll("[^0-9]", "");

			if (!onlyNumberPhone.matches("^01[016789][0-9]{7,8}$")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "올바른 휴대폰 번호 형식이 아닙니다.");
				return new Gson().toJson(resultMap);
			}

			userSettingsService.createAndSaveSmsCode(sessionId, onlyNumberPhone);

			resultMap.put("result", "success");
			resultMap.put("message", "인증번호가 발송되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "인증번호 발송 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}

	// 인증번호 확인
	@RequestMapping(value = "/user/settings/verify-sms-code.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifySmsCode(String userPhone, String authCode) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || "".equals(sessionId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			String onlyNumberPhone = userPhone.replaceAll("[^0-9]", "");
			boolean success = userSettingsService.verifySmsCode(sessionId, onlyNumberPhone, authCode);

			if (success) {
				resultMap.put("result", "success");
				resultMap.put("message", "휴대폰 인증이 완료되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "인증번호가 올바르지 않거나 만료되었습니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "인증 처리 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}
	
	// 회원탈퇴
	@RequestMapping(value = "/user/settings/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteUser() {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String sessionId = (String) session.getAttribute("sessionId");

	        if (sessionId == null || "".equals(sessionId)) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "로그인이 필요합니다.");
	            return new Gson().toJson(resultMap);
	        }

	        userSettingsService.deleteUser(sessionId);

	        session.invalidate(); // 탈퇴 후 세션 제거

	        resultMap.put("result", "success");
	        resultMap.put("message", "회원탈퇴가 완료되었습니다.");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "회원탈퇴 중 오류가 발생했습니다.");
	    }

	    return new Gson().toJson(resultMap);
	}
	
	@PostMapping(value = "/user/profile/upload.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadProfileImage(MultipartFile profileImage) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String sessionId = (String) session.getAttribute("sessionId");

			if (sessionId == null || sessionId.equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "로그인이 필요합니다.");
				return new Gson().toJson(resultMap);
			}

			if (profileImage == null || profileImage.isEmpty()) {
				resultMap.put("result", "fail");
				resultMap.put("message", "업로드할 이미지를 선택해주세요.");
				return new Gson().toJson(resultMap);
			}

			String originalFileName = profileImage.getOriginalFilename();
			String ext = StringUtils.getFilenameExtension(originalFileName);

			if (ext == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "확장자를 확인할 수 없는 파일입니다.");
				return new Gson().toJson(resultMap);
			}

			ext = ext.toLowerCase();

			if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png") && !ext.equals("gif") && !ext.equals("webp")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "이미지 파일만 업로드 가능합니다.");
				return new Gson().toJson(resultMap);
			}

			// 저장 경로
			String uploadDirPath = "C:/modak/upload/profile";
			File uploadDir = new File(uploadDirPath);

			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}

			String saveFileName = sessionId + "_" + UUID.randomUUID().toString() + "." + ext;
			File dest = new File(uploadDir, saveFileName);

			profileImage.transferTo(dest);

			// 웹에서 접근할 경로
			String profileImgUrl = "/upload/profile/" + saveFileName;

			userSettingsService.updateProfileImage(sessionId, profileImgUrl);

			resultMap.put("result", "success");
			resultMap.put("message", "프로필 이미지가 변경되었습니다.");
			resultMap.put("profileImgUrl", profileImgUrl);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "프로필 이미지 업로드 중 오류가 발생했습니다.");
		}

		return new Gson().toJson(resultMap);
	}
}