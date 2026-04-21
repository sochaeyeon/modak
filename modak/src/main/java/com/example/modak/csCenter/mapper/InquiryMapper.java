package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.InquiryHistory;
import com.example.modak.csCenter.model.InquiryImg;

@Mapper
public interface InquiryMapper {

    // 내 문의 목록
    List<InquiryHistory> selectInquiryList(HashMap<String, Object> map);

    // 문의 총 개수
    int selectInquiryCount(HashMap<String, Object> map);

    // 특정 문의 이미지 목록
    List<InquiryImg> selectInquiryImgList(HashMap<String, Object> map);
    

    int selectInquiryReplyCount(HashMap<String, Object> map);

    int deleteInquiryImg(HashMap<String, Object> map);

    int deleteInquiryReply(HashMap<String, Object> map);

    int deleteInquiry(HashMap<String, Object> map);
}