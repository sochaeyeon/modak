package com.example.modak.guide.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface GuideMapper {
    List<HashMap<String, Object>> selectGuideList(HashMap<String, Object> map);
}