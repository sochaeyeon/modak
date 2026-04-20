package com.example.modak.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration
public class SecurityConfig {
	
	private final CustomOAuth2UserService customOAuth2UserService;

	// 🔥 생성자 주입 추가
	public SecurityConfig(CustomOAuth2UserService customOAuth2UserService) {
		this.customOAuth2UserService = customOAuth2UserService;
	}

	// ✅ 핵심: firewall 설정 추가
	@Bean
	public HttpFirewall allowDoubleSlashFirewall() {
		StrictHttpFirewall firewall = new StrictHttpFirewall();
		firewall.setAllowUrlEncodedDoubleSlash(true);
		firewall.setAllowSemicolon(true);
		return firewall;
	}

	// ✅ firewall 적용
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
		return web -> web.httpFirewall(allowDoubleSlashFirewall());
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
				// csrf 비활성화
				.csrf(csrf -> csrf.disable())

				// http basic 비활성화
				.httpBasic(basic -> basic.disable())

				// 요청 허용 설정
				.authorizeHttpRequests(auth -> auth
						.requestMatchers("/", "/user/**", "/oauth2/**", "/login/**", "/css/**", "/js/**", "/images/**","/static/**")
						.permitAll().anyRequest().permitAll())

				// 일반 로그인 페이지를 사용할 경우
				.formLogin(form -> form
		                .loginPage("/user/login.do")
		                .loginProcessingUrl("/user/login")
		                .defaultSuccessUrl("/main.do", true)
		                .failureUrl("/user/login.do?error=true")
		                .permitAll()
		            )

				// 소셜 로그인 설정 추가
				.oauth2Login(oauth -> oauth
		                .loginPage("/user/login.do")
		                .userInfoEndpoint(userInfo -> userInfo
		                    .userService(customOAuth2UserService)
		                )
		                .defaultSuccessUrl("/main.do", true)
		                .failureUrl("/user/login.do?socialError=true")
		            )
				
				.logout(logout -> logout
		                .logoutUrl("/logout")
		                .logoutSuccessUrl("/user/login.do")
		                .invalidateHttpSession(true)
		                .deleteCookies("JSESSIONID")
		            );
		return http.build();
	}
}