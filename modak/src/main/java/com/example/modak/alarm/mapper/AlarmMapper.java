package com.example.modak.alarm.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AlarmMapper {
    int getUnreadAlarmCount(String userId);
    List<Map<String, Object>> getAlarmList(String userId);
    Map<String, Object> getAlarmInfo(int alarmId);
    void updateAlarmRead(int alarmId);
    void insertAlarm(HashMap<String, Object> map);
    
 // 알람 단건 삭제
    void deleteAlarm(int alarmId);
    
    // 알람 전체 삭제
    void deleteAllAlarms(String userId);
    
}