package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.product.model.Product;

@Mapper
public interface ProductMapper {
	
	public List<Product> selectProductList(HashMap<String, Object> map);

}
