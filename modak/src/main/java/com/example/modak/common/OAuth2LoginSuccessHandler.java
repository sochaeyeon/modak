package com.example.modak.common;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.example.modak.user.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws IOException, ServletException {

        CustomOAuth2User customOAuth2User = (CustomOAuth2User) authentication.getPrincipal();

        User user = customOAuth2User.getUser();

        HttpSession session = request.getSession();

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionUserName", user.getUserName());
        session.setAttribute("sessionNickName", user.getNickName());

        Object returnUrl = session.getAttribute("returnUrl");

        if (returnUrl != null) {
            session.removeAttribute("returnUrl");
            response.sendRedirect(returnUrl.toString());
        } else {
            response.sendRedirect("/main.do");
        }
    }
}