package com.example.modak.csCenter.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Faq;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface FaqMapper {

	public Faq selectFaq(HashMap<String, Object> map);

}
