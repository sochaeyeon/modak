package com.example.modak.chat.dao;

import java.util.List;
import java.util.Map;

public interface GroupChatService {
    void createRoom(Map<String, Object> params);
    void addMember(Map<String, Object> params);
    int getMemberCount(Long roomId);
    Map<String, Object> getRoom(Long roomId);
    List<Map<String, Object>> getMyRooms(String userId);
    List<Map<String, Object>> getMembers(Long roomId);
    boolean isMember(Long roomId, String userId);
    void sendMessage(Map<String, Object> params);
    List<Map<String, Object>> getMessages(Map<String, Object> params);
    void leaveRoom(Map<String, Object> params);
}