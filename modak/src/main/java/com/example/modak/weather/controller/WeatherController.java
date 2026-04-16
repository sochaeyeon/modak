package com.example.modak.weather.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/weather")
public class WeatherController {

    @Value("${weather.api.key}")
    private String weatherKey;

    @RequestMapping("/now.dox")
    public String getNowWeather() throws Exception {
        // 1. 기상청 API 기준 시간 계산 (현재 시간에서 40분 전 데이터가 가장 안전함)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, -40); 
        
        String baseDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
        String baseTime = new SimpleDateFormat("HH00").format(cal.getTime());

        // 2. URL 조립 (초단기실황: getUltraSrtNcst)
        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst");
        urlBuilder.append("?serviceKey=" + weatherKey);
        urlBuilder.append("&pageNo=1&numOfRows=10&dataType=JSON");
        urlBuilder.append("&base_date=" + baseDate);
        urlBuilder.append("&base_time=" + baseTime);
        urlBuilder.append("&nx=60&ny=127"); // 서울(시청) 기준 격자 좌표

        // 3. API 호출
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            return "{\"result\":\"error\"}";
        }
        
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        
        return sb.toString();
    }
}