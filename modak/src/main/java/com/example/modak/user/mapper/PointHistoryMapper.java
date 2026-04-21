package com.example.modak.user.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.PointHistory;

@Mapper
public interface PointHistoryMapper {
	List<PointHistory> selectPointHistoryList(HashMap<String, Object> map);

	int selectPointHistoryCount(HashMap<String, Object> map);
}