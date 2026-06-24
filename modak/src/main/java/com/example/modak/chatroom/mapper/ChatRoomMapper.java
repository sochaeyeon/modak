package com.example.modak.chatroom.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomMapper {

    // 대화 신청
    int insertChatRequest(HashMap<String, Object> map);
    Map<String, Object> selectPendingRequest(HashMap<String, Object> map);
    Map<String, Object> selectRequestById(Long requestId);
    int updateRequestStatus(HashMap<String, Object> map);
    Map<String, Object> selectChatRoomIncludeHidden(HashMap<String, Object> param);
    Map<String, Object> selectChatStatus(HashMap<String, Object> param);
    
    void updateRequestStatusWithRoom(HashMap<String, Object> param);
    // 채팅방
    int insertChatRoom(HashMap<String, Object> map);
    Map<String, Object> selectChatRoom(HashMap<String, Object> map);
    List<Map<String, Object>> selectMyRooms(String userId);
    void insertMessageReport(Map<String, Object> param);
    List<Long> selectReportedMessageIds(Map<String, Object> param);
    // 메시지
    int insertMessage(HashMap<String, Object> map);
    List<Map<String, Object>> selectMessages(HashMap<String, Object> map);
    int markMessagesRead(HashMap<String, Object> map);

    // 차단
    int insertBlock(HashMap<String, Object> map);
    int deleteBlock(HashMap<String, Object> map);
    int selectBlockExists(HashMap<String, Object> map);
    List<String> selectBlockedIds(String userId);
    
    int insertImageMessage(HashMap<String, Object> map);
 // 채팅방 나가기
    int hideRoomForMe(HashMap<String, Object> map);

    // 메시지 삭제
    int hideMessageForMe(HashMap<String, Object> map);
    int deleteMessageForAll(HashMap<String, Object> map);
    
    int insertStickerMessage(HashMap<String, Object> map);
    int showRoomAgain(HashMap<String, Object> map);
}