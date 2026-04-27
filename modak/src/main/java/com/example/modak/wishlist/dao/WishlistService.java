package com.example.modak.wishlist.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.wishlist.mapper.WishlistMapper;
import com.example.modak.wishlist.model.Wishlist;

import jakarta.servlet.http.HttpSession;

@Service
public class WishlistService {

    @Autowired
    WishlistMapper wishlistMapper;

    @Autowired
    HttpSession session;

    // 찜 목록 조회
 // 찜 목록 조회
    public HashMap<String, Object> getWishlistList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            int page = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
            int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "9")));
            int start = (page - 1) * pageSize;

            map.put("start", start);
            map.put("pageSize", pageSize);

            List<Wishlist> list = wishlistMapper.selectWishlistList(map);
            int totalCount = wishlistMapper.selectWishlistCountAll(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount);
            resultMap.put("message", "조회되었습니다.");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", "찜 목록 조회 중 오류가 발생했습니다.");
        }

        return resultMap;
    }
    
    // 찜 삭제
    public HashMap<String, Object> removeWishlist(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            int result = wishlistMapper.deleteWishlist(map);

            if (result > 0) {
                resultMap.put("result", "success");
                resultMap.put("message", Message.SUCCESS_DELETE);
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", Message.ERROR_COMMON);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.ERROR_SERVER);
        }

        return resultMap;
    }
    
    // ★ 찜 토글 — 없으면 추가, 있으면 삭제
    public HashMap<String, Object> toggleWishlist(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String userId = (String) session.getAttribute("sessionId");
            if (userId == null || userId.isEmpty()) {
                resultMap.put("result",  "fail");
                resultMap.put("message", "로그인이 필요합니다.");
                return resultMap;
            }
            map.put("userId", userId);
 
            int count = wishlistMapper.selectWishlistCount(map);
            if (count > 0) {
                // 이미 찜 → 삭제
                wishlistMapper.deleteWishlistByProductId(map);
                resultMap.put("action", "removed");
            } else {
                // 찜 없음 → 추가
                wishlistMapper.insertWishlist(map);
                resultMap.put("action", "added");
            }
            resultMap.put("result",  "success");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result",  "fail");
            resultMap.put("message", "오류가 발생했습니다.");
        }
        return resultMap;
    }


 
}