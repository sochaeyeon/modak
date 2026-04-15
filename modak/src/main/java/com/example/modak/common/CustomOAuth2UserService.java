package com.example.modak.common;

import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.*;
import org.springframework.security.oauth2.core.user.*;
import org.springframework.stereotype.Service;

import com.example.modak.user.dao.UserService;
import com.example.modak.user.model.SocialUserInfo;
import com.example.modak.user.model.User;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final UserService userService;

    public CustomOAuth2UserService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public OAuth2User loadUser(OAuth2UserRequest req) {
        OAuth2User oAuth2User = new DefaultOAuth2UserService().loadUser(req);

        String provider = req.getClientRegistration().getRegistrationId();

        SocialUserInfo info = new SocialUserInfo();

        if ("google".equals(provider)) {
            info.setSocialType("GOOGLE");
            info.setSocialId((String) oAuth2User.getAttributes().get("sub"));
            info.setEmail((String) oAuth2User.getAttributes().get("email"));
            info.setUserName((String) oAuth2User.getAttributes().get("name"));
            info.setNickName((String) oAuth2User.getAttributes().get("name"));
        }

        // 🔥 핵심: DB 처리
        User user = userService.getOrCreateSocialUser(info);

        return oAuth2User; // 세션 유지용 (간단 버전)
    }
}