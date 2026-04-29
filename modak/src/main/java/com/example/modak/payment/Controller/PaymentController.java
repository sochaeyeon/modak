package com.example.modak.payment.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.payment.dao.PaymentService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PaymentController {

    @Autowired
    PaymentService paymentService;
    @Autowired
    HttpSession session;
    @Value("${toss.client-key}") 
    private String tossClientKey;

    // 장바구니 → 결제 페이지 이동
    @RequestMapping("/payment/checkout.do")
    public String checkout(HttpServletRequest request, Model model,
            @RequestParam HashMap<String, Object> map) throws Exception {

        // cartIds, cartType, userCouponId 가 map 안에 담겨서 옴
        request.setAttribute("map", map); // jsp에서 ${map.cartIds} 로 꺼내기
        model.addAttribute("tossClientKey", tossClientKey);
        return "payment/checkout"; 
    }
    
    // 배송지 목록 조회 Ajax
    @RequestMapping(value = "/payment/addressList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String addressList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        String userId = (String) session.getAttribute("sessionId");
        map.put("userId", userId);

        resultMap = paymentService.getAddressList(map);

        return new Gson().toJson(resultMap);
    }
    
    // 결제 처리 Ajax
    @RequestMapping(value = "/payment/pay.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String pay(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        // resultMap = paymentService.insertOrder(map);
        return new Gson().toJson(resultMap);
    }

    @RequestMapping(value = "/payment/checkoutItems.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String checkoutItems(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || "".equals(userId)) {
            userId = String.valueOf(map.get("guestKey"));
        }

        if (userId == null || "null".equals(userId) || "".equals(userId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "사용자 식별값이 없습니다.");
            return new Gson().toJson(resultMap);
        }

        map.put("userId", userId);

        resultMap = paymentService.getCheckoutItems(map);

        return new Gson().toJson(resultMap);
    }
    
 // 임시 주문 저장 (금액 변조 방지용)
    @RequestMapping(value = "/payment/ready.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String payReady(@RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || "".equals(userId)) {
            userId = String.valueOf(map.get("guestKey"));
        }

        if (userId == null || "null".equals(userId) || "".equals(userId)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "비회원 식별값이 없습니다.");
            return new Gson().toJson(resultMap);
        }

        map.put("userId", userId);

        resultMap = paymentService.readyPayment(map);
        return new Gson().toJson(resultMap);
    }
    
 // ✅ 토스 결제 성공 콜백 (successUrl로 리다이렉트됨)
    @RequestMapping("/payment/success.do")
    public String paySuccess(
            @RequestParam String paymentKey,
            @RequestParam String orderId,
            @RequestParam Long amount,
            Model model) throws Exception {

        HashMap<String, Object> resultMap = paymentService.confirmPayment(paymentKey, orderId, amount);

        if ("success".equals(resultMap.get("result"))) {
            model.addAttribute("orderId", orderId);
            return "payment/order-complete";
        } else if ("error".equals(resultMap.get("result"))) {
            // ✅ DB 처리 오류 → 404 에러 페이지
            return "error/error";
        } else {
            // 토스 결제 실패 → 결제 실패 페이지
            model.addAttribute("message", resultMap.get("message"));
            return "payment/fail";
        }
    }
    
    // ✅ 토스 결제 실패 콜백 (failUrl로 리다이렉트됨)
    @RequestMapping("/payment/fail.do")
    public String payFail(
            @RequestParam(required = false) String message,
            @RequestParam(required = false) String orderId,
            Model model) {
        model.addAttribute("message", message);
        model.addAttribute("orderId", orderId);
        return "payment/fail"; // /WEB-INF/views/payment/fail.jsp
    }
    
 // ✅ 임시 - UI 확인용 (작업 후 삭제)
//    @RequestMapping("/payment/complete.do")
//    public String orderCompletePreview(
//            @RequestParam(required = false, defaultValue = "TEST-20260429-001") String orderId,
//            Model model) {
//        model.addAttribute("orderId", orderId);
//        return "payment/order-complete";
//    }
    


}