package com.example.modak.category.model;

import lombok.Data;

@Data
public class Category {
	
	int categoryId; // 카테고리 아이디
	int parentCategory; // 최상위 카테고리 null이면 자식카테고리
	String categoryName; // 카테고리명

}
