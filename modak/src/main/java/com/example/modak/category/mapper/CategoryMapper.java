package com.example.modak.category.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.category.model.Category;

@Mapper
public interface CategoryMapper {
	
	// 카테고리리스트
	public List<Category> selectCategoryList(HashMap<String, Object> map);

	// 부모 카테고리만 조회 (parent_category IS NULL) - pill 바용
    public List<Category> selectParentCategory();

    // 자식 카테고리 조회 (parent_category = parentId) - 사이드바용
    public List<Category> selectChildCategory(int parentId);
}