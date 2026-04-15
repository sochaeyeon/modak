package com.example.modak.event.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.event.mapper.EventMapper;
import com.example.modak.event.model.Event;

@Service
public class EventService {

   @Autowired 
   EventMapper eventMapper;
   
   public HashMap<String, Object> getEventList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Event> list = eventMapper.selectEventList(map);

		resultMap.put("list", list);
		resultMap.put("message", "데이터 조회 성공");
		resultMap.put("result", "success");

		return resultMap;
	}
   
   public HashMap<String, Object> getEventInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
		    Event info = eventMapper.selectEvent(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}

}
