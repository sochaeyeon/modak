package com.example.modak.membership.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.membership.model.FAQ;

@Mapper
public interface FAQMapper {
	
	// FAQ 리스트 (5개) 호출
	public List<FAQ> selectFAQList(HashMap<String, Object> map);
}
