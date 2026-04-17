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
    public HashMap<String, Object> getWishlistList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("sessionId");
            map.put("userId", userId);

            List<Wishlist> list = wishlistMapper.selectWishlistList(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);
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
}