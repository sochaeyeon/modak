package com.example.modak.category.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.category.dao.CategoryService;
import com.google.gson.Gson;

@Controller
public class CategoryController {
	
	@Autowired
	CategoryService categoryService;
	
	// 부모 카테고리 목록 조회 (parent_category IS NULL) - pill 바용
    @RequestMapping(value = "/category/parentList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String parentCategoryList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        resultMap = categoryService.getParentCategory();

        return new Gson().toJson(resultMap);
    }

    // 자식 카테고리 목록 조회 (parent_category = parentId) - 사이드바용
    @RequestMapping(value = "/category/childList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String childCategoryList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        int parentId = Integer.parseInt(map.get("parentId").toString());
        resultMap = categoryService.getChildCategory(parentId);

        return new Gson().toJson(resultMap);
    }
	
	

}
