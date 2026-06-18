package com.example.modak.follow.dao;

import java.util.List;
import java.util.Map;

public interface FollowService {
    void follow(Map<String, Object> params);
    void unfollow(Map<String, Object> params);
    boolean isFollowing(Map<String, Object> params);
    boolean isMutual(Map<String, Object> params);
    List<Map<String, Object>> getFollowerList(Map<String, Object> params);
    List<Map<String, Object>> getFollowingList(Map<String, Object> params);
    int getFollowerCount(String userId);
    int getFollowingCount(String userId);
    List<Map<String, Object>> getMutualFollowList(String userId);
}