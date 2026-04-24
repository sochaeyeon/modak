package com.example.modak.cart.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.cart.model.Cart;

@Mapper
public interface CartMapper {
	
	// 장바구니 담기
	public int insertCart(HashMap<String, Object> map);
	
	// 카트 목록 리스트
	public List<Cart> selectCartList(HashMap<String, Object> map);
	
	// 장바구니 단일 삭제
	public int deleteCart(HashMap<String, Object> map);

	// 장바구니 선택 삭제
	public int deleteSelectedCart(HashMap<String, Object> map);
	
	// 중복 조회
	public Cart selectCartOne(HashMap<String, Object> map);
	public int updateCartQty(HashMap<String, Object> map);

}
