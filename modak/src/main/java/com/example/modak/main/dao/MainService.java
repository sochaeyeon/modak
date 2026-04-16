package com.example.modak.main.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.camp.model.Camp;
import com.example.modak.main.mapper.MainMapper;

@Service
public class MainService {

    @Autowired
    private MainMapper mainMapper;

    // 메인 목록 조회
    public List<Camp> getMainList(HashMap<String, Object> params) {
        return mainMapper.selectMainCampList(params);
    }

    // 메인 데이터 CRUD 관리
    @Transactional
    public String saveMainData(HashMap<String, Object> params) {
        String mode = (String) params.get("mode");
        try {
            if ("insert".equals(mode)) mainMapper.insertMainCamp(params);
            else if ("update".equals(mode)) mainMapper.updateMainCamp(params);
            else if ("delete".equals(mode)) mainMapper.deleteMainCamp(params);
            return "success";
        } catch (Exception e) {
            return "fail";
        }
    }
}