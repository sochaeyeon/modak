package com.example.modak.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private LoginCheckInterceptor loginCheckInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(loginCheckInterceptor)
                .addPathPatterns(
                    "/alarm/**",

                    "/user/chatbot/**",

                    "/inquiry.do",

                    "/user/inquiry/**",

                    "/order/history.do",
                    "/order/detail.do",

                    "/rental/extension/main.do",

                    "/user/review/**",

                    "/user/mypage.do",

                    "/user/benefit/**",

                    "/user/recent/**",

                    "/user/wishlist/**"
                )
                .excludePathPatterns(
                    "/css/**",
                    "/js/**",
                    "/img/**",
                    "/images/**",
                    "/static/**"
                );
    }
}