package com.example.modak.category.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.category.model.Category;

@Mapper
public interface CategoryMapper {
	
	// 카테고리리스트
	public List<Category> selectCategoryList(HashMap<String, Object> map);
	

}