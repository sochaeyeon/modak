package com.example.modak.user.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.RecentView;

@Mapper
public interface ViewMapper {

    List<RecentView> selectRecentList(HashMap<String, Object> map);

    int selectRecentCount(HashMap<String, Object> map);

    void insertViewHistory(HashMap<String, Object> map);

    int selectViewHistoryCount(HashMap<String, Object> map);

    void deleteOldestViewHistory(HashMap<String, Object> map);
}