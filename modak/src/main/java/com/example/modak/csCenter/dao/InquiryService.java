package com.example.modak.csCenter.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.csCenter.mapper.InquiryMapper;
import com.example.modak.csCenter.model.Inquiry;
import com.example.modak.csCenter.model.InquiryHistory;
import com.example.modak.csCenter.model.InquiryImg;

import jakarta.servlet.http.HttpSession;

@Service
public class InquiryService {

	@Autowired
	InquiryMapper inquiryMapper;

	public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int page = Integer.parseInt(String.valueOf(map.get("page")));
			int pageSize = Integer.parseInt(String.valueOf(map.get("pageSize")));
			int offset = (page - 1) * pageSize;

			map.put("offset", offset);

			List<InquiryHistory> list = inquiryMapper.selectInquiryList(map);
			int totalCount = inquiryMapper.selectInquiryCount(map);

			resultMap.put("list", list);
			resultMap.put("totalCount", totalCount);
			resultMap.put("result", "success");
			resultMap.put("message", "문의 목록 조회 성공");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "문의 목록 조회 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> getInquiryImgList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			List<InquiryImg> list = inquiryMapper.selectInquiryImgList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", "문의 이미지 조회 성공");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "문의 이미지 조회 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> removeInquiry(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int replyCount = inquiryMapper.selectInquiryReplyCount(map);

			// 답변 달린 문의는 삭제 불가
			if (replyCount > 0) {
				resultMap.put("result", "fail");
				resultMap.put("message", "답변이 등록된 문의는 삭제할 수 없습니다.");
				return resultMap;
			}

			// 자식 테이블 먼저 삭제
			inquiryMapper.deleteInquiryImg(map);
			inquiryMapper.deleteInquiryReply(map);

			int deleteCount = inquiryMapper.deleteInquiry(map);

			if (deleteCount > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "문의가 삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "삭제할 문의가 없거나 본인 문의가 아닙니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "문의 삭제 중 오류가 발생했습니다.");
		}

		return resultMap;
	}

	public int addInquiry(HashMap<String, Object> map) {
		return inquiryMapper.insertInquiry(map);
	}

	public Inquiry getInquiryForEdit(HashMap<String, Object> map) {
		Inquiry inquiry = inquiryMapper.selectInquiryForEdit(map);

		if (inquiry != null) {
			List<InquiryImg> imageList = inquiryMapper.selectInquiryImgList(map);
			inquiry.setImageList(imageList);
		}

		return inquiry;
	}

	public int editInquiry(HashMap<String, Object> map) {
		return inquiryMapper.updateInquiry(map);
	}

	public void saveInquiryEditFiles(HashMap<String, Object> map, List<MultipartFile> files, HttpSession session)
			throws Exception {
		saveInquiryFiles(map, files, session);
	}

	public void deleteInquiryEditImages(List<Integer> deletedImageIdList, HttpSession session) {
		for (Integer inquiryImgId : deletedImageIdList) {
			if (inquiryImgId == null) {
				continue;
			}

			InquiryImg img = inquiryMapper.selectInquiryImgById(inquiryImgId);

			if (img != null && img.getImgUrl() != null && !img.getImgUrl().equals("")) {
				String realPath = session.getServletContext().getRealPath(img.getImgUrl());
				File file = new File(realPath);

				if (file.exists()) {
					file.delete();
				}
			}

			inquiryMapper.deleteInquiryImgById(inquiryImgId);
		}
	}

	// ─── 문의 삭제 (이미지 → 답변 → 문의 순서) ───────────────────
	public int deleteInquiry(HashMap<String, Object> map) {
	    inquiryMapper.deleteInquiryImg(map);
	    inquiryMapper.deleteInquiryReply(map);
	    return inquiryMapper.deleteInquiry(map);
	}

	// 🔥 방금 생성된 문의 PK
	public void saveInquiryFiles(HashMap<String, Object> map, List<MultipartFile> files, HttpSession session)
			throws Exception {

		Object inquiryIdObj = map.get("inquiryId");

		if (inquiryIdObj == null) {
			throw new RuntimeException("문의 등록 후 inquiryId를 가져오지 못했습니다.");
		}

		int inquiryId = Integer.parseInt(String.valueOf(inquiryIdObj));

		// 프로필 이미지 방식처럼 실제 저장 경로 잡기
		String uploadDirPath = session.getServletContext().getRealPath("/img/inquiry/");
		File uploadDir = new File(uploadDirPath);

		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		for (MultipartFile file : files) {
			if (file == null || file.isEmpty()) {
				continue;
			}

			String originalFileName = file.getOriginalFilename();
			String ext = "";

			if (originalFileName != null && originalFileName.contains(".")) {
				ext = originalFileName.substring(originalFileName.lastIndexOf(".")).toLowerCase();
			}

			// 파일명 중복 방지
			String saveFileName = UUID.randomUUID().toString() + ext;

			File dest = new File(uploadDir, saveFileName);
			file.transferTo(dest);

			// DB 저장용 웹 경로
			String imgUrl = "/img/inquiry/" + saveFileName;

			HashMap<String, Object> fileMap = new HashMap<>();
			fileMap.put("inquiryId", inquiryId);
			fileMap.put("imgUrl", imgUrl);

			inquiryMapper.insertInquiryImage(fileMap);
		}
	}
}