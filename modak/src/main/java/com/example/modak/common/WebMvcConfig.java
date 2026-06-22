package com.example.modak.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private LoginCheckInterceptor loginCheckInterceptor;

    @Autowired
    private jakarta.servlet.ServletContext servletContext;  // ★ 추가

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginCheckInterceptor)
                .addPathPatterns("/alarm/**", "/user/chatbot/**", "/inquiry.do",
                        "/user/inquiry/**", "/order/history.do", "/order/detail.do",
                        "/user/review/**", "/user/mypage.do", "/user/benefit/**",
                        "/user/recent/**", "/user/wishlist/**", "/board/write.do",
                        "/board/edit.do", "/board/insert.do", "/board/update.do",
                        "/board/delete.do", "/board/comment/**", "/board/scrap/**",
                        "/board/like/**", "/chat-room/**")
                .excludePathPatterns("/css/**", "/js/**", "/img/**", "/images/**",
                        "/static/**", "/upload/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // ★ webapp/img/profile/ 명시적 서빙
        String profilePath = servletContext.getRealPath("/img/profile/");
        registry.addResourceHandler("/img/profile/**")
                .addResourceLocations("file:" + profilePath + "/");
    }
}