package com.example.modak.chatroom.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface GroupChatMapper {
    int insertGroupRoom(Map<String, Object> params);
    int insertGroupMember(Map<String, Object> params);
    int selectGroupMemberCount(Long roomId);
    List<Map<String, Object>> selectMyGroupRooms(String userId);
    Map<String, Object> selectGroupRoom(Long roomId);
    List<Map<String, Object>> selectGroupMembers(Long roomId);
    int selectIsMember(Map<String, Object> params);
    int deleteGroupMember(Map<String, Object> params);
    int insertGroupMessage(Map<String, Object> params);
    List<Map<String, Object>> selectGroupMessages(Map<String, Object> params);
    String selectNextHostCandidate(Long roomId);
    int updateMemberRole(Map<String, Object> params);
    int deleteGroupRoom(Long roomId);
}