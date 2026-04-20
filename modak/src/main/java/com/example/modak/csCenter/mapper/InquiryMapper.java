package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Inquiry;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface InquiryMapper {

    // 여러 개 리턴
   public List<Inquiry> selectInquiryList(HashMap<String, Object> map);

}



