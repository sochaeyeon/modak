package com.example.modak.category.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.category.mapper.CategoryMapper;

@Service
public class CategoryService {

	@Autowired
	CategoryMapper categoryMapper;
	
}