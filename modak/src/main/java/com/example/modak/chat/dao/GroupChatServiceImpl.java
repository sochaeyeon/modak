package com.example.modak.chat.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.chat.mapper.GroupChatMapper;

@Service
public class GroupChatServiceImpl implements GroupChatService {

    @Autowired
    private GroupChatMapper groupChatMapper;

    @Override
    public void createRoom(Map<String, Object> params) { groupChatMapper.insertGroupRoom(params); }

    @Override
    public void addMember(Map<String, Object> params) { groupChatMapper.insertGroupMember(params); }

    @Override
    public int getMemberCount(Long roomId) { return groupChatMapper.selectGroupMemberCount(roomId); }

    @Override
    public Map<String, Object> getRoom(Long roomId) { return groupChatMapper.selectGroupRoom(roomId); }

    @Override
    public List<Map<String, Object>> getMyRooms(String userId) { return groupChatMapper.selectMyGroupRooms(userId); }

    @Override
    public List<Map<String, Object>> getMembers(Long roomId) { return groupChatMapper.selectGroupMembers(roomId); }

    @Override
    public boolean isMember(Long roomId, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        return groupChatMapper.selectIsMember(params) > 0;
    }

    @Override
    public void sendMessage(Map<String, Object> params) { groupChatMapper.insertGroupMessage(params); }

    @Override
    public List<Map<String, Object>> getMessages(Map<String, Object> params) {
        return groupChatMapper.selectGroupMessages(params);
    }

    /* 나가기 — 방장이 나가면 다음 멤버에게 위임, 인원 0명이면 방 삭제 */
    @Override
    public void leaveRoom(Map<String, Object> params) {
        Long roomId = ((Number) params.get("roomId")).longValue();
        String userId = (String) params.get("userId");

        Map<String, Object> room = groupChatMapper.selectGroupRoom(roomId);
        boolean wasHost = room != null && userId.equals(room.get("hostId"));

        groupChatMapper.deleteGroupMember(params);

        int remaining = groupChatMapper.selectGroupMemberCount(roomId);

        if (remaining == 0) {
            groupChatMapper.deleteGroupRoom(roomId);
            return;
        }

        if (wasHost) {
            String nextHostId = groupChatMapper.selectNextHostCandidate(roomId);
            Map<String, Object> roleParams = new HashMap<>();
            roleParams.put("roomId", roomId);
            roleParams.put("userId", nextHostId);
            roleParams.put("role", "HOST");
            groupChatMapper.updateMemberRole(roleParams);
        }
    }
}