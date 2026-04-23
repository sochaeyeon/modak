package com.example.modak.csCenter.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
public interface CsCenterMapper {

	List<Map<String, Object>> getFaqList(HashMap<String, Object> map) throws Exception;

	List<Map<String, Object>> getNotificationList(HashMap<String, Object> map) throws Exception;
}
