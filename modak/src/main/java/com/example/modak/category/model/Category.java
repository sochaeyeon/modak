package com.example.modak.category.model;

import lombok.Data;

@Data
public class Category {
	
	private int categoryId; // 카테고리 아이디
	private Integer parentCategory; // 최상위 카테고리 null이면 자식카테고리 - null허용 필요때문에 Integer
	private String categoryName; // 카테고리명

}
