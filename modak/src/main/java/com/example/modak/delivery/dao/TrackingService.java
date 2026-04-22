package com.example.modak.delivery.dao;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.modak.delivery.model.DeliveryTrackingEvent;
import com.example.modak.delivery.model.DeliveryTrackingResult;

@Service
public class TrackingService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${delivery.tracker.api.url}")
    private String apiUrl;

    @Value("${delivery.tracker.client-id}")
    private String clientId;

    @Value("${delivery.tracker.client-secret}")
    private String clientSecret;

    public DeliveryTrackingResult getTrackingResult(String carrierId, String trackingNo) {
        DeliveryTrackingResult result = new DeliveryTrackingResult();
        result.setCarrierId(carrierId);
        result.setTrackingNumber(trackingNo);

        if (carrierId == null || carrierId.trim().equals("")) {
            result.setSuccess(false);
            result.setErrorMessage("택배사 코드가 없습니다.");
            return result;
        }

        if (trackingNo == null || trackingNo.trim().equals("")) {
            result.setSuccess(false);
            result.setErrorMessage("운송장번호가 없습니다.");
            return result;
        }

        try {
            String query =
                    "query TrackQuery($carrierId: ID!, $trackingNumber: String!) {"
                  + "  track(carrierId: $carrierId, trackingNumber: $trackingNumber) {"
                  + "    lastEvent {"
                  + "      time"
                  + "      location { name }"
                  + "      description"
                  + "      status { code name }"
                  + "    }"
                  + "    events(last: 10) {"
                  + "      edges {"
                  + "        node {"
                  + "          time"
                  + "          location { name }"
                  + "          description"
                  + "          status { code name }"
                  + "        }"
                  + "      }"
                  + "    }"
                  + "  }"
                  + "}";

            Map<String, Object> variables = new LinkedHashMap<>();
            variables.put("carrierId", carrierId);
            variables.put("trackingNumber", trackingNo);

            Map<String, Object> requestBody = new LinkedHashMap<>();
            requestBody.put("query", query);
            requestBody.put("variables", variables);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "TRACKQL-API-KEY " + clientId + ":" + clientSecret);

            HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    requestEntity,
                    Map.class
            );

            Map<String, Object> body = response.getBody();
            if (body == null) {
                result.setSuccess(false);
                result.setErrorMessage("응답 데이터가 없습니다.");
                return result;
            }

            if (body.containsKey("errors")) {
                result.setSuccess(false);
                result.setErrorMessage("배송 API 호출에 실패했습니다.");
                return result;
            }

            Map<String, Object> data = castMap(body.get("data"));
            Map<String, Object> track = castMap(data.get("track"));

            if (track == null || track.isEmpty()) {
                result.setSuccess(false);
                result.setErrorMessage("배송추적 결과가 없습니다.");
                return result;
            }

            Map<String, Object> lastEvent = castMap(track.get("lastEvent"));
            if (lastEvent != null && !lastEvent.isEmpty()) {
                Map<String, Object> status = castMap(lastEvent.get("status"));
                Map<String, Object> location = castMap(lastEvent.get("location"));

                result.setLastStatus(status != null ? stringValue(status.get("name")) : "");
                result.setLastLocation(location != null ? stringValue(location.get("name")) : "");
                result.setLastDescription(stringValue(lastEvent.get("description")));
                result.setLastTime(stringValue(lastEvent.get("time")));
            }

            Map<String, Object> events = castMap(track.get("events"));
            List<Object> edges = castList(events.get("edges"));

            List<DeliveryTrackingEvent> eventList = new ArrayList<>();
            for (Object edgeObj : edges) {
                Map<String, Object> edge = castMap(edgeObj);
                Map<String, Object> node = castMap(edge.get("node"));
                if (node == null || node.isEmpty()) {
                    continue;
                }

                Map<String, Object> status = castMap(node.get("status"));
                Map<String, Object> location = castMap(node.get("location"));

                DeliveryTrackingEvent event = new DeliveryTrackingEvent();
                event.setTime(stringValue(node.get("time")));
                event.setStatus(status != null ? stringValue(status.get("name")) : "");
                event.setLocation(location != null ? stringValue(location.get("name")) : "");
                event.setDescription(stringValue(node.get("description")));

                eventList.add(event);
            }

            result.setEventList(eventList);
            result.setTrackingLinkUrl(
                    "https://link.tracker.delivery/track?client_id="
                    + clientId
                    + "&carrier_id="
                    + carrierId
                    + "&tracking_number="
                    + trackingNo
            );
            result.setSuccess(true);

            return result;

        } catch (Exception e) {
            result.setSuccess(false);
            result.setErrorMessage("실시간 배송추적 조회 중 오류가 발생했습니다.");
            return result;
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> castMap(Object obj) {
        if (obj instanceof Map) {
            return (Map<String, Object>) obj;
        }
        return new LinkedHashMap<>();
    }

    @SuppressWarnings("unchecked")
    private List<Object> castList(Object obj) {
        if (obj instanceof List) {
            return (List<Object>) obj;
        }
        return new ArrayList<>();
    }

    private String stringValue(Object obj) {
        return obj == null ? "" : String.valueOf(obj);
    }
    
    
}