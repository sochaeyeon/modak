package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.csCenter.mapper.CsCenterMapper;

@Service
public class csCenterService {

	@Autowired
	CsCenterMapper csCenterMapper;

	public List<Map<String, Object>> getFaqList(HashMap<String, Object> map) throws Exception {
		return csCenterMapper.getFaqList(map);
	}

	
	public List<Map<String, Object>> getNotificationList(HashMap<String, Object> map) throws Exception {
		return csCenterMapper.getNotificationList(map);
	}
}