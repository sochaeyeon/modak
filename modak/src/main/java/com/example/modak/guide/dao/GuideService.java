package com.example.modak.guide.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.guide.mapper.GuideMapper;

@Service
public class GuideService {
    @Autowired private GuideMapper guideMapper;
    
    public List<HashMap<String, Object>> getGuideList(HashMap<String, Object> map) {
        return guideMapper.selectGuideList(map);
    }
}