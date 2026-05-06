package com.example.modak.wishlist.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.modak.wishlist.dao.WishlistService;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class WishlistController {

    @Autowired WishlistService wishlistService;

    // 찜 내역 페이지
    @RequestMapping("/user/wishlist/history.do")
    public String wishlistPage(HttpServletRequest request, Model model,
            @RequestParam HashMap<String, Object> map) throws Exception {
        return "/wishlist/wishlist-history";
    }

    // 찜 목록 조회
    @RequestMapping(value = "/user/wishlist/list.dox",
            method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getWishlist(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(wishlistService.getWishlistList(map));
    }

    // ★ 찜 토글 (추가 / 삭제) — 메인/상품 카드 하트 버튼에서 호출
    @RequestMapping(value = "/user/wishlist/toggle.dox",
            method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String toggleWishlist(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(wishlistService.toggleWishlist(map));
    }

    // 찜 삭제 (wishId 기준)
    @RequestMapping(value = "/user/wishlist/remove.dox",
            method = RequestMethod.POST,
            produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String removeWishlist(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(wishlistService.removeWishlist(map));
    }
    
    
}