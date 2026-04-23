package com.example.modak.cart.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.cart.model.Cart;
import com.example.modak.product.model.ProductOption;

@Mapper
public interface CartMapper {
	
	// 카트 목록 리스트
	public List<Cart> selectCartList(HashMap<String, Object> map);
//	public int insertCart(HashMap<String, Object> map);
//	public int updateCart(HashMap<String, Object> map);
//	public int updateCartDate(HashMap<String, Object> map);
//	public int deleteCart(HashMap<String, Object> map);
//	public int deleteCartList(HashMap<String, Object> map);

}
