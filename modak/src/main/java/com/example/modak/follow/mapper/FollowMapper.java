package com.example.modak.follow.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FollowMapper {
    int insertFollow(Map<String, Object> params);
    int deleteFollow(Map<String, Object> params);
    int selectIsFollowing(Map<String, Object> params);
    int selectIsMutual(Map<String, Object> params);
    List<Map<String, Object>> selectFollowerList(Map<String, Object> params);
    List<Map<String, Object>> selectFollowingList(Map<String, Object> params);
    int selectFollowerCount(String userId);
    int selectFollowingCount(String userId);
    List<Map<String, Object>> selectMutualFollowList(String userId);
    List<Map<String, Object>> selectFollowerListWithMyStatus(Map<String, Object> params);
    List<Map<String, Object>> selectFollowingListWithMyStatus(Map<String, Object> params);
}