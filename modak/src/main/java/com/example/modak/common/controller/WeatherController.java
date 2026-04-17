package com.example.modak.common.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import com.google.gson.Gson;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/weather")
public class WeatherController {

    @Value("${weather.api.key}")
    private String weatherKey;

    /**
     * 단기예보 (오늘 + 내일)
     * 파라미터: nx, ny (지역 격자 좌표)
     */
    @GetMapping("/short.dox")
    public String getShortWeather(
            @RequestParam(defaultValue = "60") String nx,
            @RequestParam(defaultValue = "127") String ny) {

        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            // 단기예보 발표시각: 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300
            // 가장 최근 발표시각 계산
            Calendar cal = Calendar.getInstance();
            int hour = cal.get(Calendar.HOUR_OF_DAY);
            int min  = cal.get(Calendar.MINUTE);

            // 발표시각 목록 (분 40 이후에 데이터 완성)
            int[] fcstHours = {2, 5, 8, 11, 14, 17, 20, 23};
            int baseHour = 23;

            for (int i = fcstHours.length - 1; i >= 0; i--) {
                if (hour > fcstHours[i] || (hour == fcstHours[i] && min >= 40)) {
                    baseHour = fcstHours[i];
                    break;
                }
            }

            // baseHour가 현재보다 크면 전날 2300 사용
            if (baseHour > hour || (baseHour == hour && min < 40)) {
                cal.add(Calendar.DATE, -1);
                baseHour = 23;
            }

            String baseDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
            String baseTime = String.format("%02d00", baseHour);

            System.out.println("[단기예보] baseDate=" + baseDate + " baseTime=" + baseTime + " nx=" + nx + " ny=" + ny);

            String apiUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                    + "?serviceKey=" + weatherKey.trim()
                    + "&pageNo=1&numOfRows=300&dataType=JSON"
                    + "&base_date=" + baseDate
                    + "&base_time=" + baseTime
                    + "&nx=" + nx
                    + "&ny=" + ny;

            String raw = callApi(apiUrl);
            System.out.println("[단기예보] 응답코드OK raw 앞부분: " + raw.substring(0, Math.min(200, raw.length())));

            if (raw.trim().startsWith("<")) {
                resultMap.put("result", "fail");
                resultMap.put("msg", "XML응답-인증키확인");
                return new Gson().toJson(resultMap);
            }

            resultMap.put("result", "success");
            resultMap.put("data", JsonParser.parseString(raw));
            return new Gson().toJson(resultMap);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
            return new Gson().toJson(resultMap);
        }
    }

    /**
     * 중기예보 (D+3 ~ D+5)
     * 파라미터: taRegId(기온코드), landRegId(육상코드)
     */
    @GetMapping("/mid.dox")
    public String getMidWeather(
            @RequestParam(defaultValue = "11B10101") String taRegId,
            @RequestParam(defaultValue = "11B00000") String landRegId) {

        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            Calendar cal = Calendar.getInstance();
            int hour = cal.get(Calendar.HOUR_OF_DAY);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String tmFc;

            if (hour < 6) {
                cal.add(Calendar.DATE, -1);
                tmFc = sdf.format(cal.getTime()) + "1800";
            } else if (hour < 18) {
                tmFc = sdf.format(cal.getTime()) + "0600";
            } else {
                tmFc = sdf.format(cal.getTime()) + "1800";
            }

            System.out.println("[중기예보] tmFc=" + tmFc + " taRegId=" + taRegId);

            String taUrl = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa"
                    + "?serviceKey=" + weatherKey.trim()
                    + "&pageNo=1&numOfRows=10&dataType=JSON"
                    + "&regId=" + taRegId
                    + "&tmFc=" + tmFc;

            String landUrl = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst"
                    + "?serviceKey=" + weatherKey.trim()
                    + "&pageNo=1&numOfRows=10&dataType=JSON"
                    + "&regId=" + landRegId
                    + "&tmFc=" + tmFc;

            String taRaw   = callApi(taUrl);
            String landRaw = callApi(landUrl);

            if (taRaw.trim().startsWith("<") || landRaw.trim().startsWith("<")) {
                resultMap.put("result", "fail");
                resultMap.put("msg", "XML응답-인증키확인");
                return new Gson().toJson(resultMap);
            }

            resultMap.put("result", "success");
            resultMap.put("ta",   JsonParser.parseString(taRaw));
            resultMap.put("land", JsonParser.parseString(landRaw));
            return new Gson().toJson(resultMap);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
            return new Gson().toJson(resultMap);
        }
    }

    /* API 호출 공통 메서드 */
    private String callApi(String apiUrl) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(7000);
        conn.setReadTimeout(7000);

        int code = conn.getResponseCode();
        System.out.println("[날씨API] 응답코드: " + code + " URL: " + apiUrl.substring(0, 80));

        BufferedReader rd = new BufferedReader(
            new InputStreamReader(
                code == 200 ? conn.getInputStream() : conn.getErrorStream(), "UTF-8"
            )
        );
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();
        conn.disconnect();
        return sb.toString();
    }
}