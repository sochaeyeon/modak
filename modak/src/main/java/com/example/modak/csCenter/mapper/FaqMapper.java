package com.example.modak.csCenter.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.csCenter.model.Faq;

@Mapper
public interface FaqMapper {

	public List<Faq> selectFaqList(HashMap<String, Object> map);

	public Faq selectFaq(HashMap<String, Object> map);

}
