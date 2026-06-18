package com.example.modak.follow.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.follow.mapper.FollowMapper;

@Service
public class FollowServiceImpl implements FollowService {

    @Autowired
    private FollowMapper followMapper;

    @Override
    public void follow(Map<String, Object> params) { followMapper.insertFollow(params); }

    @Override
    public void unfollow(Map<String, Object> params) { followMapper.deleteFollow(params); }

    @Override
    public boolean isFollowing(Map<String, Object> params) {
        return followMapper.selectIsFollowing(params) > 0;
    }

    @Override
    public boolean isMutual(Map<String, Object> params) {
        return followMapper.selectIsMutual(params) > 0;
    }

    @Override
    public List<Map<String, Object>> getFollowerList(Map<String, Object> params) {
        return followMapper.selectFollowerList(params);
    }

    @Override
    public List<Map<String, Object>> getFollowingList(Map<String, Object> params) {
        return followMapper.selectFollowingList(params);
    }

    @Override
    public int getFollowerCount(String userId) { return followMapper.selectFollowerCount(userId); }

    @Override
    public int getFollowingCount(String userId) { return followMapper.selectFollowingCount(userId); }

    @Override
    public List<Map<String, Object>> getMutualFollowList(String userId) {
        return followMapper.selectMutualFollowList(userId);
    }
}