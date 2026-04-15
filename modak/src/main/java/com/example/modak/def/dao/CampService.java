package com.example.modak.def.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.modak.def.mapper.CampMapper;
import com.example.modak.def.model.Camp;
import com.google.gson.*;

@Service
public class CampService {
    @Autowired private CampMapper campMapper;
    private final String key = "7ba3239d3f13c3f5b4e4bb63f24e43a0c4c227ed527b4561a2e569ff7bf4d632";

    // 1. 목록 조회 (중복 데이터 제거 로직 포함)
    public HashMap<String, Object> getCampList(HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<Camp> rawList = campMapper.selectCampList(params);
        
        // 이름+주소 키값으로 중복 제거
        Map<String, Camp> cleanMap = new LinkedHashMap<>();
        for (Camp c : rawList) {
            String uniqueKey = c.getFacltNm() + c.getAddr1();
            if (!cleanMap.containsKey(uniqueKey)) {
                cleanMap.put(uniqueKey, c);
            }
        }
        resultMap.put("list", new ArrayList<>(cleanMap.values()));
        resultMap.put("result", "success");
        return resultMap;
    }

    // 2. API 데이터 동기화 (CAMP + CAMP_IMG)
    @Transactional
    public void syncCampData() throws Exception {
        String urlStr = "http://apis.data.go.kr/B551011/GoCamping/basedList?serviceKey=" + key 
                      + "&MobileOS=ETC&MobileApp=Modak&_type=json&numOfRows=1000";
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder(); String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();

        JsonObject res = JsonParser.parseString(sb.toString()).getAsJsonObject().getAsJsonObject("response");
        JsonArray items = res.getAsJsonObject("body").getAsJsonObject("items").getAsJsonArray("item");
        
        List<Camp> list = new ArrayList<>();
        Gson gson = new Gson();
        for (JsonElement item : items) {
            JsonObject obj = item.getAsJsonObject();
            Camp c = gson.fromJson(obj, Camp.class);
            if (c.getMapX() != null && !c.getMapX().isEmpty()) {
                list.add(c);
                // 이미지 데이터 추출 및 저장
                JsonElement imgElem = obj.get("firstImageUrl");
                if (imgElem != null && !imgElem.isJsonNull() && !imgElem.getAsString().isEmpty()) {
                    HashMap<String, Object> imgMap = new HashMap<>();
                    imgMap.put("campId", c.getContentId());
                    imgMap.put("imgUrl", imgElem.getAsString());
                    campMapper.insertCampImg(imgMap);
                }
            }
        }
        if (!list.isEmpty()) campMapper.insertCampList(list);
    }

    public List<HashMap<String, Object>> getReviewList(HashMap<String, Object> params) {
        return campMapper.selectReviewList(params);
    }
}