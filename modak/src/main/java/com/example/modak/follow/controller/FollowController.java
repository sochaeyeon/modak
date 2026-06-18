package com.example.modak.follow.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.follow.dao.FollowService;

import jakarta.servlet.http.HttpSession;

@RestController
public class FollowController {

    @Autowired
    private FollowService followService;

    /* 팔로우 토글 (즉시 팔로우/언팔로우) */
    @PostMapping("/follow/toggle.dox")
    public Map<String, Object> toggleFollow(@RequestParam String targetUserId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String myUserId = (String) session.getAttribute("userId");

        if (myUserId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        if (myUserId.equals(targetUserId)) {
            result.put("result", "fail");
            result.put("message", "자기 자신은 팔로우할 수 없습니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("followerId", myUserId);
        params.put("followingId", targetUserId);

        boolean isFollowing = followService.isFollowing(params);

        if (isFollowing) {
            followService.unfollow(params);
            result.put("following", false);
        } else {
            followService.follow(params);
            result.put("following", true);
        }

        result.put("result", "success");
        result.put("followerCount", followService.getFollowerCount(targetUserId));
        return result;
    }

    @PostMapping("/follow/followers.dox")
    public Map<String, Object> getFollowers(@RequestParam String userId) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);

        result.put("result", "success");
        result.put("list", followService.getFollowerList(params));
        return result;
    }

    @PostMapping("/follow/followings.dox")
    public Map<String, Object> getFollowings(@RequestParam String userId) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);

        result.put("result", "success");
        result.put("list", followService.getFollowingList(params));
        return result;
    }

    /* 맞팔 목록 — 단체채팅 초대 후보 */
    @PostMapping("/follow/mutual.dox")
    public Map<String, Object> getMutualFollows(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String myUserId = (String) session.getAttribute("userId");

        if (myUserId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        result.put("result", "success");
        result.put("list", followService.getMutualFollowList(myUserId));
        return result;
    }
}