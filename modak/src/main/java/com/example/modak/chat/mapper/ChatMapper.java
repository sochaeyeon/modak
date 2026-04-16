package com.example.modak.chat.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatMapper {
    void insertChatHistory(HashMap<String, Object> map);
    List<HashMap<String, Object>> selectChatHistory(HashMap<String, Object> map);
    List<HashMap<String, Object>> selectChatMessagesByRoom(HashMap<String, Object> map);
    int deleteChatRoom(HashMap<String, Object> map);
}