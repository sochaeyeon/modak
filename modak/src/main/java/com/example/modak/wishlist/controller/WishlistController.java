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

    @Autowired
    WishlistService wishlistService;
    
    // 찜 내역 페이지
    @RequestMapping("/user/wishlist/history.do") 
	   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
	      return "/wishlist/wishlist-history";
	   } 
    
    // 찜 목록 조회
    @RequestMapping(value = "/user/wishlist/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getWishlist(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap = wishlistService.getWishlistList(map);
        return new Gson().toJson(resultMap);
    }
    
    // 찜 삭제
    @RequestMapping(value = "/user/wishlist/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String removeWishlist(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = wishlistService.removeWishlist(map);
        return new Gson().toJson(resultMap);
    }
}