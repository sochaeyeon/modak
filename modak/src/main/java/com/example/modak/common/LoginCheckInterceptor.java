package com.example.modak.common;

import java.io.PrintWriter;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("sessionId") == null) {

            // 세션이 없으면 새로 생성해서 returnUrl 저장
            session = request.getSession();

            String requestURI = request.getRequestURI();
            String queryString = request.getQueryString();

            String returnUrl = requestURI;
            if (queryString != null && !queryString.isEmpty()) {
                returnUrl += "?" + queryString;
            }

            // 로그인 후 돌아갈 주소 저장
            session.setAttribute("returnUrl", returnUrl);

            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('로그인 후 이용 가능한 서비스입니다.');");
            out.println("location.href='/user/login.do';");
            out.println("</script>");
            out.flush();

            return false;
        }

        return true;
    }
}