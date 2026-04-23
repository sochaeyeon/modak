package com.example.modak.cart.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.cart.dao.CartService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class CartController {
	
	@Autowired
	CartService cartService;
	@Autowired
	HttpSession session;
//
    // 페이지 이동
    @RequestMapping("/cart/list.do")
    public String cartPage() {
        return "/cart/cart-list";
    }
//
//    // 공통: userId 세션 추출
//    private String getLoginUser() {
//        String userId = (String) session.getAttribute("userId");
//        return userId != null ? userId : "user01"; // 테스트용 fallback
//    }
//
//    // 목록 조회
//    @RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String getCartList(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        return new Gson().toJson(cartService.getCartList(map));
//    }
//
//    // 담기 (product-detail에서 호출)
//    @RequestMapping(value = "/cart/insert.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String insertCart(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        // rentalStart/rentalEnd가 빈 문자열이면 null로 변환
//        if ("".equals(map.get("rentalStart"))) map.put("rentalStart", null);
//        if ("".equals(map.get("rentalEnd")))   map.put("rentalEnd",   null);
//        return new Gson().toJson(cartService.insertCart(map));
//    }
//
//    // 수량/옵션 수정
//    @RequestMapping(value = "/cart/update.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String updateCart(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        return new Gson().toJson(cartService.updateCart(map));
//    }
//
//    // 대여 날짜 일괄 수정
//    @RequestMapping(value = "/cart/updateDate.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String updateCartDate(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        return new Gson().toJson(cartService.updateCartDate(map));
//    }
//
//    // 단건 삭제
//    @RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String removeCart(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        return new Gson().toJson(cartService.deleteCart(map));
//    }
//
//    // 선택 삭제
//    @RequestMapping(value = "/cart/removeList.dox", method = RequestMethod.POST,
//                    produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String removeCartList(@RequestParam HashMap<String, Object> map) throws Exception {
//        map.put("userId", getLoginUser());
//        return new Gson().toJson(cartService.deleteCartList(map));
//    }
	
//	@RequestMapping("/cart/list.do") 
//	   public String test1(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
//	      return "/cart/cart-list";
//	   }
//	
//	// 장바구니 목록 조회
//	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//	@ResponseBody
//	public String getCartList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		
//		// 1. 세션에서 로그인한 사용자의 아이디를 꺼냅니다.
//		// (로그인 시 세션에 저장한 이름이 "userId" 또는 "sessionId"인지 확인 필요!)
//		String userId = (String) session.getAttribute("userId"); 
//				
//		// 2. 세션에 아이디가 있다면 맵에 담아줍니다.
//		if(userId != null) {
//			map.put("userId", userId);
//		} else {
//			// 로그인이 안 된 경우 테스트를 위해 임시 아이디를 넣거나 에러 처리를 합니다.
//			map.put("userId", "user01"); 
//		}
//		
//		// 3. 이제 userId와 cartType이 모두 담긴 map이 서비스로 넘어갑니다.
//		resultMap = cartService.getCartList(map);
//		return new Gson().toJson(resultMap);
//	}
	   
}
