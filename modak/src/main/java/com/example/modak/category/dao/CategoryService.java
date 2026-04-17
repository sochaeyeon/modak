package com.example.modak.category.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.category.mapper.CategoryMapper;
import com.example.modak.category.model.Category;
import com.example.modak.common.Message;

@Service
public class CategoryService {

	@Autowired
	CategoryMapper categoryMapper;
	
	// 부모 카테고리 목록 조회 (parent_category IS NULL) - pill 바용
    public HashMap<String, Object> getParentCategory() {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            List<Category> list = categoryMapper.selectParentCategory();
            resultMap.put("list", list);
            resultMap.put("result", "success");
            resultMap.put("message", Message.SUCCESS_SELECT);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.FAIL_SELECT);
        }
        return resultMap;
    }

    // 자식 카테고리 목록 조회 (parent_category = parentId) - 사이드바용
    public HashMap<String, Object> getChildCategory(int parentId) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            List<Category> list = categoryMapper.selectChildCategory(parentId);
            resultMap.put("list", list);
            resultMap.put("result", "success");
            resultMap.put("message", Message.SUCCESS_SELECT);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.FAIL_SELECT);
        }
        return resultMap;
    }
	
}