package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.user.mapper.PointHistoryMapper;
import com.example.modak.user.model.PointHistory;

@Service
public class PointHistoryService {

    @Autowired
    private PointHistoryMapper pointHistoryMapper;

    public HashMap<String, Object> getPointHistoryList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<PointHistory> list = pointHistoryMapper.selectPointHistoryList(map);
            int totalCount = pointHistoryMapper.selectPointHistoryCount(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount);
            resultMap.put("page", map.get("page"));
            resultMap.put("pageSize", map.get("pageSize"));

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", "포인트 내역 조회에 실패했습니다.");
        }

        return resultMap;
    }
}