package com.example.modak.alarm.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.alarm.mapper.AlarmMapper;

@Service
public class AlarmService {
    @Autowired AlarmMapper alarmMapper;

    public int getUnreadAlarmCount(String userId) { return alarmMapper.getUnreadAlarmCount(userId); }

    public HashMap<String, Object> getAlarmList(String userId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", alarmMapper.getAlarmList(userId));
        resultMap.put("result", "success");
        return resultMap;
    }

    public Map<String, Object> getAlarmInfo(int alarmId) { return alarmMapper.getAlarmInfo(alarmId); }

    public void updateAlarmRead(int alarmId) { alarmMapper.updateAlarmRead(alarmId); }
    
    public void removeAlarm(int alarmId) {
        alarmMapper.deleteAlarm(alarmId);
    }

    public void removeAllAlarms(String userId) {
        alarmMapper.deleteAllAlarms(userId);
    }
}