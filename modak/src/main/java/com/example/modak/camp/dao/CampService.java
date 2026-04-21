package com.example.modak.camp.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.camp.mapper.CampMapper;
import com.example.modak.camp.model.Camp;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class CampService {

    @Autowired
    private CampMapper campMapper;

    @Value("${gocamp.api.key}")
    private String serviceKey;

    // ══════════════════════════════════════════
    //  1. 캠핑장 목록 조회 (중복 제거는 DB 레벨에서 처리)
    // ══════════════════════════════════════════
    public HashMap<String, Object> getCampList(HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<Camp> list = campMapper.selectCampList(params);
            resultMap.put("list",   list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result",  "fail");
            resultMap.put("message", "캠핑장 목록을 불러오는 중 오류가 발생했습니다.");
        }
        return resultMap;
    }

    // ══════════════════════════════════════════
    //  2. 고캠핑 API 동기화
    //     순서: CAMP 먼저 insert → 이미지 insert (FK 오류 방지)
    // ══════════════════════════════════════════
    @Transactional(rollbackFor = Exception.class)
    public void syncCampData() throws Exception {

        String urlStr = "http://apis.data.go.kr/B551011/GoCamping/basedList"
                + "?serviceKey=" + serviceKey
                + "&MobileOS=ETC&MobileApp=Modak&_type=json&numOfRows=1000";

        // API 호출
        URL url  = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();
        conn.disconnect();

        // JSON 파싱
        JsonObject responseBody = JsonParser.parseString(sb.toString())
                .getAsJsonObject()
                .getAsJsonObject("response")
                .getAsJsonObject("body");
        JsonArray items = responseBody
                .getAsJsonObject("items")
                .getAsJsonArray("item");

        Gson gson = new Gson();

        // ── 이미지 맵 (campId → imgUrl) 임시 보관
        List<HashMap<String, Object>> imgList = new ArrayList<>();
        List<Camp> campList = new ArrayList<>();

        for (JsonElement item : items) {
            JsonObject obj = item.getAsJsonObject();
            Camp c = gson.fromJson(obj, Camp.class);

            if (c.getMapX() == null || c.getMapX().isEmpty()) continue;

            // induty 직접 파싱 (Gson 자동 매핑 보조)
            JsonElement indutyElem = obj.get("induty");
            if (indutyElem != null && !indutyElem.isJsonNull()) {
                c.setInduty(indutyElem.getAsString());
            }

            campList.add(c);

            // 이미지 임시 저장 (CAMP insert 후 처리)
            JsonElement imgElem = obj.get("firstImageUrl");
            if (imgElem != null && !imgElem.isJsonNull()
                    && !imgElem.getAsString().isEmpty()) {
                HashMap<String, Object> imgMap = new HashMap<>();
                imgMap.put("campId", c.getContentId());
                imgMap.put("imgUrl", imgElem.getAsString());
                imgList.add(imgMap);
            }
        }

        // ── CAMP 먼저 insert (FK 기준 테이블)
        if (!campList.isEmpty()) {
            campMapper.insertCampList(campList);
        }

        // ── 이미지 insert (CAMP_IMG는 CAMP_ID FK 참조)
        for (HashMap<String, Object> imgMap : imgList) {
            try {
                campMapper.insertCampImg(imgMap);
            } catch (Exception e) {
                // 특정 이미지 실패해도 전체 롤백 방지
                System.err.println("[CampService] 이미지 저장 실패: " + imgMap.get("campId"));
            }
        }
    }

    // ══════════════════════════════════════════
    //  3. 리뷰 목록 조회
    // ══════════════════════════════════════════
    public List<HashMap<String, Object>> getReviewList(HashMap<String, Object> params) {
        return campMapper.selectReviewList(params);
    }
}
