package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Faq;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface FaqMapper {
	
	public List<Faq> selectFaqList(HashMap<String, Object> map);

	public Faq selectFaq(HashMap<String, Object> map);

}
