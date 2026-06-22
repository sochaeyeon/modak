package com.example.modak.chatroom.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatUserMapper {
    List<Map<String, Object>> selectAllUsersExceptMe(String myUserId);
}