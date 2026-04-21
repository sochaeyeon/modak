package com.example.modak.cart.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.cart.model.Cart;

@Mapper
public interface CartMapper {
	
	// 카트 목록 리스트
	public List<Cart> selectCartList(HashMap<String, Object> map);

}
