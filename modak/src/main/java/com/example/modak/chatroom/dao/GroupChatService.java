package com.example.modak.chatroom.dao;

import java.util.Map;

public interface GroupChatService {
    Map<String, Object> createRoom(String hostId, String roomName, String memberIds, Integer maxMember);
    Map<String, Object> inviteMembers(String myUserId, Long roomId, String memberIds);
    Map<String, Object> getMyRooms(String userId);
    Map<String, Object> getMembers(Long roomId, String userId);
    Map<String, Object> sendMessage(Long roomId, String userId, String messageType, String content);
    Map<String, Object> getMessages(Long roomId, String userId);
    Map<String, Object> leaveRoom(Long roomId, String userId);
}