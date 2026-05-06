package com.example.modak.wishlist.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.modak.wishlist.model.Wishlist;

@Mapper
public interface WishlistMapper {

    // 찜 목록 조회
    public List<Wishlist> selectWishlistList(HashMap<String, Object> map);

    // 찜 추가
    public int insertWishlist(HashMap<String, Object> map);

    // 찜 여부 확인
    public int selectWishlistCount(HashMap<String, Object> map);

    // 찜 삭제 — productId 기준 (토글용)
    public int deleteWishlistByProductId(HashMap<String, Object> map);

    // 찜 삭제 — wishId 기준 (위시리스트 페이지용)
    public int deleteWishlist(HashMap<String, Object> map);
 // 찜 목록 전체 개수
    public int selectWishlistCountAll(HashMap<String, Object> map);
}