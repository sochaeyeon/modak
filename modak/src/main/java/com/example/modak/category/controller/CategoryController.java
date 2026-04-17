package com.example.modak.category.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.example.modak.category.dao.CategoryService;

@Controller
public class CategoryController {
	
	@Autowired
	CategoryService categoryService;

}
