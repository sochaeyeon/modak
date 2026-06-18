package com.example.modak.chatroom.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.chatroom.mapper.GroupChatMapper;
import com.example.modak.follow.dao.FollowService;

@Service
public class GroupChatServiceImpl implements GroupChatService {

    private static final int DEFAULT_MAX_MEMBER = 50;

    @Autowired private GroupChatMapper groupChatMapper;
    @Autowired private FollowService followService;

    private List<String> splitIds(String memberIds) {
        List<String> list = new ArrayList<>();
        if (memberIds == null) return list;
        for (String id : memberIds.split(",")) {
            if (!id.trim().isEmpty()) list.add(id.trim());
        }
        return list;
    }

    @Override
    public Map<String, Object> createRoom(String hostId, String roomName, String memberIds, Integer maxMember) {
        Map<String, Object> result = new HashMap<>();

        if (roomName == null || roomName.trim().isEmpty()) {
            result.put("result", "fail");
            result.put("message", "채팅방 이름을 입력해주세요.");
            return result;
        }

        List<String> targetIds = splitIds(memberIds);
        if (targetIds.isEmpty()) {
            result.put("result", "fail");
            result.put("message", "초대할 멤버를 선택해주세요.");
            return result;
        }

        int limit = (maxMember != null && maxMember > 0) ? maxMember : DEFAULT_MAX_MEMBER;

        if (targetIds.size() + 1 > limit) {
            result.put("result", "fail");
            result.put("message", "최대 인원(" + limit + "명)을 초과했습니다.");
            return result;
        }

        // 맞팔 관계 검증
        for (String targetId : targetIds) {
            if (!followService.isMutual(hostId, targetId)) {
                result.put("result", "fail");
                result.put("message", "맞팔로우 관계인 사람만 초대할 수 있습니다.");
                return result;
            }
        }

        Map<String, Object> roomParams = new HashMap<>();
        roomParams.put("roomName", roomName);
        roomParams.put("hostId", hostId);
        roomParams.put("maxMember", limit);
        groupChatMapper.insertGroupRoom(roomParams);

        Long roomId = ((Number) roomParams.get("roomId")).longValue();

        Map<String, Object> hostMember = new HashMap<>();
        hostMember.put("roomId", roomId);
        hostMember.put("userId", hostId);
        hostMember.put("role", "HOST");
        groupChatMapper.insertGroupMember(hostMember);

        for (String targetId : targetIds) {
            Map<String, Object> memberParams = new HashMap<>();
            memberParams.put("roomId", roomId);
            memberParams.put("userId", targetId);
            memberParams.put("role", "MEMBER");
            groupChatMapper.insertGroupMember(memberParams);
        }

        result.put("result", "success");
        result.put("roomId", roomId);
        return result;
    }

    @Override
    public Map<String, Object> inviteMembers(String myUserId, Long roomId, String memberIds) {
        Map<String, Object> result = new HashMap<>();

        Map<String, Object> room = groupChatMapper.selectGroupRoom(roomId);
        if (room == null || !myUserId.equals(room.get("hostId"))) {
            result.put("result", "fail");
            result.put("message", "방장만 멤버를 초대할 수 있습니다.");
            return result;
        }

        List<String> targetIds = splitIds(memberIds);
        int maxMember = ((Number) room.get("maxMember")).intValue();
        int current = groupChatMapper.selectGroupMemberCount(roomId);

        if (current + targetIds.size() > maxMember) {
            result.put("result", "fail");
            result.put("message", "최대 인원(" + maxMember + "명)을 초과했습니다.");
            return result;
        }

        for (String targetId : targetIds) {
            if (!followService.isMutual(myUserId, targetId)) {
                result.put("result", "fail");
                result.put("message", "맞팔로우 관계인 사람만 초대할 수 있습니다.");
                return result;
            }
        }

        for (String targetId : targetIds) {
            Map<String, Object> memberParams = new HashMap<>();
            memberParams.put("roomId", roomId);
            memberParams.put("userId", targetId);
            memberParams.put("role", "MEMBER");
            groupChatMapper.insertGroupMember(memberParams);
        }

        result.put("result", "success");
        return result;
    }

    @Override
    public Map<String, Object> getMyRooms(String userId) {
        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("list", groupChatMapper.selectMyGroupRooms(userId));
        return result;
    }

    @Override
    public Map<String, Object> getMembers(Long roomId, String userId) {
        Map<String, Object> result = new HashMap<>();

        if (!isMember(roomId, userId)) {
            result.put("result", "fail");
            result.put("message", "채팅방 멤버가 아닙니다.");
            return result;
        }

        result.put("result", "success");
        result.put("list", groupChatMapper.selectGroupMembers(roomId));
        return result;
    }

    private boolean isMember(Long roomId, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        return groupChatMapper.selectIsMember(params) > 0;
    }

    @Override
    public Map<String, Object> sendMessage(Long roomId, String userId, String messageType, String content) {
        Map<String, Object> result = new HashMap<>();

        if (!isMember(roomId, userId)) {
            result.put("result", "fail");
            result.put("message", "채팅방 멤버가 아닙니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        params.put("messageType", messageType == null ? "TEXT" : messageType);
        params.put("content", content);
        groupChatMapper.insertGroupMessage(params);

        result.put("result", "success");
        return result;
    }

    @Override
    public Map<String, Object> getMessages(Long roomId, String userId) {
        Map<String, Object> result = new HashMap<>();

        if (!isMember(roomId, userId)) {
            result.put("result", "fail");
            result.put("message", "채팅방 멤버가 아닙니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);

        result.put("result", "success");
        result.put("list", groupChatMapper.selectGroupMessages(params));
        return result;
    }

    @Override
    public Map<String, Object> leaveRoom(Long roomId, String userId) {
        Map<String, Object> result = new HashMap<>();

        Map<String, Object> room = groupChatMapper.selectGroupRoom(roomId);
        boolean wasHost = room != null && userId.equals(room.get("hostId"));

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        groupChatMapper.deleteGroupMember(params);

        int remaining = groupChatMapper.selectGroupMemberCount(roomId);

        if (remaining == 0) {
            groupChatMapper.deleteGroupRoom(roomId);
        } else if (wasHost) {
            String nextHostId = groupChatMapper.selectNextHostCandidate(roomId);
            Map<String, Object> roleParams = new HashMap<>();
            roleParams.put("roomId", roomId);
            roleParams.put("userId", nextHostId);
            roleParams.put("role", "HOST");
            groupChatMapper.updateMemberRole(roleParams);
        }

        result.put("result", "success");
        return result;
    }
}