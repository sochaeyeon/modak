package com.example.modak.chat.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.modak.chat.dao.GroupChatService;
import com.example.modak.follow.dao.FollowService;

import jakarta.servlet.http.HttpSession;

@RestController
public class GroupChatController {

    private static final int DEFAULT_MAX_MEMBER = 50;

    @Autowired
    private GroupChatService groupChatService;

    @Autowired
    private FollowService followService;

    /* 단체채팅방 생성 — 맞팔 관계인 사람만 초대 가능 */
    @PostMapping("/chat/group/create.dox")
    public Map<String, Object> createGroupRoom(
            @RequestParam String roomName,
            @RequestParam String memberIds,
            @RequestParam(required = false) Integer maxMember,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String hostId = (String) session.getAttribute("userId");

        if (hostId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        List<String> targetIds = new ArrayList<>();
        for (String id : memberIds.split(",")) {
            if (!id.trim().isEmpty()) targetIds.add(id.trim());
        }

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

        // ★ 맞팔 관계 검증
        for (String targetId : targetIds) {
            Map<String, Object> params = new HashMap<>();
            params.put("followerId", hostId);
            params.put("followingId", targetId);

            if (!followService.isMutual(params)) {
                result.put("result", "fail");
                result.put("message", "맞팔로우 관계인 사람만 초대할 수 있습니다.");
                return result;
            }
        }

        Map<String, Object> roomParams = new HashMap<>();
        roomParams.put("roomName", roomName);
        roomParams.put("hostId", hostId);
        roomParams.put("maxMember", limit);
        groupChatService.createRoom(roomParams);

        Long roomId = ((Number) roomParams.get("roomId")).longValue();

        Map<String, Object> hostMember = new HashMap<>();
        hostMember.put("roomId", roomId);
        hostMember.put("userId", hostId);
        hostMember.put("role", "HOST");
        groupChatService.addMember(hostMember);

        for (String targetId : targetIds) {
            Map<String, Object> memberParams = new HashMap<>();
            memberParams.put("roomId", roomId);
            memberParams.put("userId", targetId);
            memberParams.put("role", "MEMBER");
            groupChatService.addMember(memberParams);
        }

        result.put("result", "success");
        result.put("roomId", roomId);
        return result;
    }

    /* 기존 방에 멤버 초대 (방장만, 맞팔 검증 동일) */
    @PostMapping("/chat/group/invite.dox")
    public Map<String, Object> inviteMembers(
            @RequestParam Long roomId,
            @RequestParam String memberIds,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String myUserId = (String) session.getAttribute("userId");

        Map<String, Object> room = groupChatService.getRoom(roomId);
        if (room == null || !myUserId.equals(room.get("hostId"))) {
            result.put("result", "fail");
            result.put("message", "방장만 멤버를 초대할 수 있습니다.");
            return result;
        }

        List<String> targetIds = new ArrayList<>();
        for (String id : memberIds.split(",")) {
            if (!id.trim().isEmpty()) targetIds.add(id.trim());
        }

        int maxMember = ((Number) room.get("maxMember")).intValue();
        int current = groupChatService.getMemberCount(roomId);

        if (current + targetIds.size() > maxMember) {
            result.put("result", "fail");
            result.put("message", "최대 인원(" + maxMember + "명)을 초과했습니다.");
            return result;
        }

        for (String targetId : targetIds) {
            Map<String, Object> params = new HashMap<>();
            params.put("followerId", myUserId);
            params.put("followingId", targetId);

            if (!followService.isMutual(params)) {
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
            groupChatService.addMember(memberParams);
        }

        result.put("result", "success");
        return result;
    }

    @PostMapping("/chat/group/myrooms.dox")
    public Map<String, Object> getMyRooms(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        result.put("result", "success");
        result.put("list", groupChatService.getMyRooms(userId));
        return result;
    }

    @PostMapping("/chat/group/members.dox")
    public Map<String, Object> getMembers(@RequestParam Long roomId) {
        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("list", groupChatService.getMembers(roomId));
        return result;
    }

    @PostMapping("/chat/group/send.dox")
    public Map<String, Object> sendMessage(
            @RequestParam Long roomId,
            @RequestParam String content,
            @RequestParam(required = false) String imgUrl,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String userId = (String) session.getAttribute("userId");

        if (userId == null || !groupChatService.isMember(roomId, userId)) {
            result.put("result", "fail");
            result.put("message", "채팅방 멤버가 아닙니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        params.put("content", content);
        params.put("imgUrl", imgUrl);

        groupChatService.sendMessage(params);
        result.put("result", "success");
        return result;
    }

    @PostMapping("/chat/group/messages.dox")
    public Map<String, Object> getMessages(@RequestParam Long roomId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String userId = (String) session.getAttribute("userId");

        if (userId == null || !groupChatService.isMember(roomId, userId)) {
            result.put("result", "fail");
            result.put("message", "채팅방 멤버가 아닙니다.");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);

        result.put("result", "success");
        result.put("list", groupChatService.getMessages(params));
        return result;
    }

    @PostMapping("/chat/group/leave.dox")
    public Map<String, Object> leaveRoom(@RequestParam Long roomId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String userId = (String) session.getAttribute("userId");

        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);

        groupChatService.leaveRoom(params);
        result.put("result", "success");
        return result;
    }
}