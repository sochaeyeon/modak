package com.example.modak.follow.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.follow.mapper.FollowMapper;

@Service
public class FollowServiceImpl implements FollowService {

    @Autowired
    private FollowMapper followMapper;

    @Override
    public Map<String, Object> toggleFollow(String myUserId, String targetUserId) {
        Map<String, Object> result = new HashMap<>();

        if (myUserId.equals(targetUserId)) {
            result.put("result", "fail");
            result.put("message", "자기 자신은 팔로우할 수 없습니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("followerId", myUserId);
        params.put("followingId", targetUserId);

        boolean isFollowing = followMapper.selectIsFollowing(params) > 0;

        if (isFollowing) {
            followMapper.deleteFollow(params);
            result.put("following", false);
        } else {
            followMapper.insertFollow(params);
            result.put("following", true);
        }

        result.put("result", "success");
        result.put("followerCount", followMapper.selectFollowerCount(targetUserId));
        return result;
    }

    @Override
    public Map<String, Object> getFollowers(String userId, String myUserId) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("myUserId", myUserId == null ? "" : myUserId);
        result.put("result", "success");
        result.put("list", followMapper.selectFollowerListWithMyStatus(params));
        return result;
    }

    @Override
    public Map<String, Object> getFollowings(String userId, String myUserId) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("myUserId", myUserId == null ? "" : myUserId);
        result.put("result", "success");
        result.put("list", followMapper.selectFollowingListWithMyStatus(params));
        return result;
    }

    @Override
    public Map<String, Object> getMutualFollowList(String userId) {
        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("list", followMapper.selectMutualFollowList(userId));
        return result;
    }

    @Override
    public Map<String, Object> getStatus(String myUserId, String targetUserId) {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("followerId", myUserId);
        params.put("followingId", targetUserId);

        result.put("result", "success");
        result.put("isFollowing", followMapper.selectIsFollowing(params) > 0);
        result.put("followerCount", followMapper.selectFollowerCount(targetUserId));
        result.put("followingCount", followMapper.selectFollowingCount(targetUserId));
        return result;
    }
    
 // FollowServiceImpl.java에 추가
    @Override
    public boolean isMutual(String userIdA, String userIdB) {
        Map<String, Object> params = new HashMap<>();
        params.put("followerId", userIdA);
        params.put("followingId", userIdB);
        return followMapper.selectIsMutual(params) > 0;
    }
}