package com.example.modak.common;

import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.modak.user.dao.LoginService;
import com.example.modak.user.model.SocialUserInfo;
import com.example.modak.user.model.User;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final LoginService loginService;

    public CustomOAuth2UserService(LoginService loginService) {
        this.loginService = loginService;
    }

    @Override
    public OAuth2User loadUser(OAuth2UserRequest req) {
        OAuth2User oAuth2User = new DefaultOAuth2UserService().loadUser(req);

        // 소셜 로그인 제공자 구분값
        String provider = req.getClientRegistration().getRegistrationId();

        SocialUserInfo info = new SocialUserInfo();

        // =========================
        // GOOGLE
        // =========================
        if ("google".equals(provider)) {
            info.setSocialType("GOOGLE");
            info.setSocialId((String) oAuth2User.getAttributes().get("sub"));
            info.setEmail((String) oAuth2User.getAttributes().get("email"));
            info.setUserName((String) oAuth2User.getAttributes().get("name"));
            info.setNickName((String) oAuth2User.getAttributes().get("name"));
        }

        // =========================
        // KAKAO
        // =========================
        else if ("kakao".equals(provider)) {
            Map<String, Object> attributes = oAuth2User.getAttributes();

            Object idObj = attributes.get("id");
            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");

            String email = "";
            String userName = "카카오회원";
            String nickName = "카카오회원";

            if (kakaoAccount != null) {
                Object emailObj = kakaoAccount.get("email");
                if (emailObj != null) {
                    email = emailObj.toString();
                }

                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
                if (profile != null) {
                    Object nicknameObj = profile.get("nickname");
                    if (nicknameObj != null) {
                        userName = nicknameObj.toString();
                        nickName = nicknameObj.toString();
                    }
                }
            }

            info.setSocialType("KAKAO");
            info.setSocialId(idObj == null ? null : idObj.toString());
            info.setEmail(email);
            info.setUserName(userName);
            info.setNickName(nickName);
        }

        // =========================
        // NAVER
        // =========================
        else if ("naver".equals(provider)) {
            Map<String, Object> attributes = oAuth2User.getAttributes();
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");

            if (response == null) {
                throw new OAuth2AuthenticationException("네이버 사용자 정보(response)가 없습니다.");
            }

            String socialId = response.get("id") == null ? null : response.get("id").toString();
            String email = response.get("email") == null ? "" : response.get("email").toString();
            String userName = response.get("name") == null ? "네이버회원" : response.get("name").toString();
            String nickName = response.get("nickname") == null ? userName : response.get("nickname").toString();

            info.setSocialType("NAVER");
            info.setSocialId(socialId);
            info.setEmail(email);
            info.setUserName(userName);
            info.setNickName(nickName);
        }

        // =========================
        // 지원하지 않는 provider
        // =========================
        else {
            throw new OAuth2AuthenticationException("지원하지 않는 소셜 로그인입니다. provider = " + provider);
        }

        // 필수값 검증
        if (info.getSocialType() == null || info.getSocialType().trim().isEmpty()) {
            throw new OAuth2AuthenticationException("socialType 값이 비어 있습니다.");
        }

        if (info.getSocialId() == null || info.getSocialId().trim().isEmpty()) {
            throw new OAuth2AuthenticationException("socialId 값이 비어 있습니다.");
        }

        // 🔥 핵심: DB 처리
        User user = loginService.getOrCreateSocialUser(info);

        return oAuth2User; // 세션 유지용 (간단 버전)
    }
}