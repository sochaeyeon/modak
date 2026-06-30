package com.example.modak.common.controller; 

import org.springframework.ui.Model;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice 
public class GlobalExceptionHandler {

    // 필수 파라미터(orderId 등)가 없을 때 발생하는 에러를 낚아챔
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public String handleMissingParams(MissingServletRequestParameterException ex, Model model) {
        model.addAttribute("msg", "잘못된 접근이거나 필수 파라미터가 누락되었습니다.");
       
        return "error/error"; 
    }

    // 널 포인터 등 기타 모든 런타임 에러를 낚아챔
    @ExceptionHandler(Exception.class)
    public String handleAllExceptions(Exception ex, Model model) {
        // 서버 콘솔에 에러 로그 출력 (운영 시에는 Logger 사용 권장)
        ex.printStackTrace(); 
        
        model.addAttribute("msg", "서버 처리 중 오류가 발생했습니다.");
        
        return "error/error"; 
    }
}