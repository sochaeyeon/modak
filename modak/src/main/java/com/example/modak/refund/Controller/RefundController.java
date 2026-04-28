package com.example.modak.refund.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.refund.dao.RefundService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class RefundController {
	
	@Autowired
	RefundService refundService;
	
	@Autowired
	HttpSession session;
	
	// 환불 신청 페이지 이동
    @RequestMapping("/refund/request.do")
    public String refundPage(Model model, @RequestParam HashMap<String, Object> map) {

        String sessionId = (String) session.getAttribute("sessionId");

        if (sessionId == null || sessionId.equals("")) {
            return "redirect:/user/login.do";
        }

        model.addAttribute("map", map);

        return "refund/refund-request";
    }

    // 환불 신청 처리
//    @RequestMapping(value = "/refund/apply.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public String applyRefund(@RequestParam HashMap<String, Object> map) {
//
//        HashMap<String, Object> resultMap = new HashMap<>();
//
//        try {
//            String sessionId = (String) session.getAttribute("sessionId");
//
//            if (sessionId == null || sessionId.equals("")) {
//                resultMap.put("result", "fail");
//                resultMap.put("message", "로그인이 필요합니다.");
//                return new Gson().toJson(resultMap);
//            }
//
//            map.put("userId", sessionId);
//
//            resultMap = refundService.applyRefund(map);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            resultMap.put("result", "fail");
//            resultMap.put("message", "환불 신청 중 오류가 발생했습니다.");
//        }
//
//        return new Gson().toJson(resultMap);
//    }

}
