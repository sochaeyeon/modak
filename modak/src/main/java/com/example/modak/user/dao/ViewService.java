package com.example.modak.user.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.user.mapper.ViewMapper;
import com.example.modak.user.model.RecentView;

@Service
public class ViewService {

    @Autowired
    ViewMapper viewMapper;

    // 최근 본 상품 조회 (페이징 포함)
    public HashMap<String, Object> getRecentList(HashMap<String, Object> map) {

        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            int page = 1;
            int pageSize = 9;

            if (map.get("page") != null) {
                page = Integer.parseInt(map.get("page").toString());
            }

            if (map.get("pageSize") != null) {
                pageSize = Integer.parseInt(map.get("pageSize").toString());
            }

            int offset = (page - 1) * pageSize;

            map.put("offset", offset);
            map.put("pageSize", pageSize);

            List<RecentView> list = viewMapper.selectRecentList(map);
            int totalCount = viewMapper.selectRecentCount(map);

            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount);
            resultMap.put("page", page);
            resultMap.put("pageSize", pageSize);
            resultMap.put("result", "success");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("list", List.of());
            resultMap.put("totalCount", 0);
        }

        return resultMap;
    }

    // 최근 본 상품 저장
    public void addRecentView(HashMap<String, Object> map) {
        try {
            viewMapper.insertViewHistory(map);

            int count = viewMapper.selectViewHistoryCount(map);

            while (count > 100) {
                viewMapper.deleteOldestViewHistory(map);
                count = viewMapper.selectViewHistoryCount(map);
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}