package com.example.modak.csCenter.dao;

import com.example.modak.csCenter.mapper.CsCenterMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CsCenterServiceImpl implements csCenterService {

	@Autowired
	private CsCenterMapper csCenterMapper;

	@Override
	public List<Map<String, Object>> getFaqList(HashMap<String, Object> map) throws Exception {
		return csCenterMapper.getFaqList(map);
	}

	@Override
	public List<Map<String, Object>> getNotificationList(HashMap<String, Object> map) throws Exception {
		return csCenterMapper.getNotificationList(map);
	}
}
