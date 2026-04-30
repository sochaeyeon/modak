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

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(loginCheckInterceptor)
				.addPathPatterns("/alarm/**", "/user/chatbot/**", "/inquiry.do", "/user/inquiry/**",
						"/order/history.do", "/order/detail.do", "/user/review/**", "/user/mypage.do",
						"/user/benefit/**", "/user/recent/**", "/user/wishlist/**")
				.excludePathPatterns("/css/**", "/js/**", "/img/**", "/images/**", "/static/**", "/upload/**");
	}

	// ★ 여기에 추가
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {

		// 리뷰 이미지
		 registry.addResourceHandler("/img/review/**")
         .addResourceLocations("file:///C:/Users/TJ-BU-708-P04/git/modak/modak/src/main/webapp/img/review/");

		// 프로필 이미지
		 registry.addResourceHandler("/upload/profile/**")
         .addResourceLocations("classpath:/static/upload/profile/");

	}
}