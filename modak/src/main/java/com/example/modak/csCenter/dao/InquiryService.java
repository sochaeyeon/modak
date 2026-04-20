package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.csCenter.mapper.InquiryMapper;
import com.example.modak.csCenter.model.InquiryHistory;
import com.example.modak.csCenter.model.InquiryImg;

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
}