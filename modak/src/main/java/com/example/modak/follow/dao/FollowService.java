package com.example.modak.follow.dao;

import java.util.Map;

public interface FollowService {
    Map<String, Object> toggleFollow(String myUserId, String targetUserId);
    Map<String, Object> getFollowers(String userId, String myUserId);
    Map<String, Object> getFollowings(String userId, String myUserId);
    Map<String, Object> getMutualFollowList(String userId);
    Map<String, Object> getStatus(String myUserId, String targetUserId);
    boolean isMutual(String userIdA, String userIdB);
}