package com.example.modak.follow.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.follow.dao.FollowService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/follow")
public class FollowController {

    @Autowired private FollowService followService;
    @Autowired private HttpSession session;

    /** 즉시 팔로우/언팔로우 토글 */
    @PostMapping(value = "/toggle.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String toggle(@RequestParam String targetUserId) {
        String myUserId = (String) session.getAttribute("sessionId");
        if (myUserId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(followService.toggleFollow(myUserId, targetUserId));
    }

    /** 특정 유저 기준 팔로워 목록 */
    @PostMapping(value = "/followers.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String followers(@RequestParam String userId) {
        return new Gson().toJson(followService.getFollowers(userId));
    }

    /** 특정 유저 기준 팔로잉 목록 */
    @PostMapping(value = "/followings.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String followings(@RequestParam String userId) {
        return new Gson().toJson(followService.getFollowings(userId));
    }

    /** 내 맞팔 목록 — 단체채팅 초대 후보 */
    @PostMapping(value = "/mutual.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String mutual() {
        String myUserId = (String) session.getAttribute("sessionId");
        if (myUserId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(followService.getMutualFollowList(myUserId));
    }

    /** ★ 특정 유저에 대한 내 팔로우 상태 + 그 유저의 팔로워/팔로잉 수
     *  (board-detail 미니프로필 팝업, user-profile 페이지에서 공통으로 사용)
     */
    @PostMapping(value = "/status.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String status(@RequestParam String targetUserId) {
        String myUserId = (String) session.getAttribute("sessionId");

        if (myUserId == null) {
            // 비로그인도 카운트는 보여줄 수 있게
            java.util.Map<String, Object> result = new HashMap<>();
            result.put("result", "success");
            result.put("isFollowing", false);
            result.put("isLogin", false);
            return new Gson().toJson(result);
        }

        java.util.Map<String, Object> result = followService.getStatus(myUserId, targetUserId);
        result.put("isLogin", true);
        return new Gson().toJson(result);
    }
}