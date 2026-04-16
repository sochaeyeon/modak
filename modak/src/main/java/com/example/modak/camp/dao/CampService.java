package com.example.modak.camp.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

    // [수정] application.properties에서 GoCamping API 키를 가져옵니다.
    @Value("${gocamp.api.key}")
    private String serviceKey;

    /**
     * 1. 캠핑장 목록 조회 (이름+주소 중복 제거 로직 포함)
     */
    public HashMap<String, Object> getCampList(HashMap<String, Object> params) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<Camp> rawList = campMapper.selectCampList(params);
        
        // LinkedHashMap을 사용하여 순서를 유지하면서 이름+주소 키값으로 중복 제거
        Map<String, Camp> cleanMap = new LinkedHashMap<>();
        for (Camp c : rawList) {
            if (c.getFacltNm() != null && c.getAddr1() != null) {
                String uniqueKey = c.getFacltNm() + c.getAddr1();
                if (!cleanMap.containsKey(uniqueKey)) {
                    cleanMap.put(uniqueKey, c);
                }
            }
        }
        
        resultMap.put("list", new ArrayList<>(cleanMap.values()));
        resultMap.put("result", "success");
        return resultMap;
    }

    /**
     * 2. 공공데이터 API 데이터 동기화 (CAMP 정보 및 이미지 저장)
     */
    @Transactional(rollbackFor = Exception.class)
    public void syncCampData() throws Exception {
        // [수정] 하드코딩된 key 대신 @Value로 주입받은 serviceKey를 사용합니다.
        String urlStr = "http://apis.data.go.kr/B551011/GoCamping/basedList?serviceKey=" + serviceKey 
                      + "&MobileOS=ETC&MobileApp=Modak&_type=json&numOfRows=1000";
        
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder(); 
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();

        // JSON 파싱
        JsonObject jsonResponse = JsonParser.parseString(sb.toString()).getAsJsonObject();
        JsonObject responseBody = jsonResponse.getAsJsonObject("response").getAsJsonObject("body");
        JsonArray items = responseBody.getAsJsonObject("items").getAsJsonArray("item");
        
        List<Camp> list = new ArrayList<>();
        Gson gson = new Gson();

        for (JsonElement item : items) {
            JsonObject obj = item.getAsJsonObject();
            Camp c = gson.fromJson(obj, Camp.class);
            
            // 좌표 정보가 있는 데이터만 처리
            if (c.getMapX() != null && !c.getMapX().isEmpty()) {
                list.add(c);
                
                // 이미지 데이터(firstImageUrl) 추출 및 CAMP_IMG 테이블 저장
                JsonElement imgElem = obj.get("firstImageUrl");
                if (imgElem != null && !imgElem.isJsonNull() && !imgElem.getAsString().isEmpty()) {
                    HashMap<String, Object> imgMap = new HashMap<>();
                    imgMap.put("campId", c.getContentId());
                    imgMap.put("imgUrl", imgElem.getAsString());
                    campMapper.insertCampImg(imgMap);
                }
            }
        }
        
        // 데이터가 존재할 경우 일괄 인서트
        if (!list.isEmpty()) {
            campMapper.insertCampList(list);
        }
    }

    /**
     * 3. 캠핑장 리뷰 목록 조회
     */
    public List<HashMap<String, Object>> getReviewList(HashMap<String, Object> params) {
        return campMapper.selectReviewList(params);
    }
}