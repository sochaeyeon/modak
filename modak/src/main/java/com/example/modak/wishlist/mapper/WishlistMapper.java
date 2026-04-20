package com.example.modak.wishlist.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.wishlist.model.Wishlist;

@Mapper
public interface WishlistMapper {

    // 찜 목록 조회
    public List<Wishlist> selectWishlistList(HashMap<String, Object> map);
    
    // 찜 목록 삭제
    public int deleteWishlist(HashMap<String, Object> map);
}