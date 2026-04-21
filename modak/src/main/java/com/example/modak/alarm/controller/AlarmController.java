package com.example.modak.alarm.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.alarm.dao.AlarmService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/alarm")
public class AlarmController {

    @Autowired 
    private AlarmService alarmService;
    
    @Autowired 
    private HttpSession session;

    /**
     * 1. 알림 목록 페이지 이동
     * URL: /alarm/notice-list.do
     */
    @RequestMapping("/notice-list.do")
    public String noticeList() {
        // WEB-INF/alarm/notice-list.jsp 파일을 찾아갑니다.
        return "alarm/notice-list"; 
    }

    /**
     * 2. 알림 클릭 시 처리 (읽음 업데이트 + 해당 페이지 이동)
     * URL: /alarm/notice-detail.do?alarmId=번호
     */
    @RequestMapping("/notice-detail.do")
    public String noticeDetail(@RequestParam("alarmId") int alarmId) {
        // 1) 알림 상세 정보 가져오기
        Map<String, Object> alarm = alarmService.getAlarmInfo(alarmId);
        
        if (alarm != null) {
            // 2) 해당 알림 읽음 처리 (IS_READ = 'Y')
            alarmService.updateAlarmRead(alarmId);

            String type = (String) alarm.get("TYPE");
            Object linkId = alarm.get("LINK_ID"); // DB에 저장된 주문ID 혹은 이벤트ID

            // 3) 타입에 따른 리다이렉트 (은동님 프로젝트 주소: orderId)
            if ("DELIVERY".equals(type)) {
                // 이미지 확인 결과: /order/detail.do?orderId=번호
                return "redirect:/order/detail.do?orderId=" + linkId;
            }
            
            if ("EVENT".equals(type)) {
                // 이미지 확인 결과: /event/detail.do?eventId=번호
                return "redirect:/event/detail.do?eventId=" + linkId;
            }
        }
        
        // 데이터가 없거나 알 수 없는 타입이면 다시 목록으로
        return "redirect:/alarm/notice-list.do";
    }

    /**
     * 3. AJAX: 최근 알림 목록 가져오기 (헤더 및 리스트용)
     */
    @RequestMapping("/getAlarmList.dox")
    @ResponseBody
    public HashMap<String, Object> getAlarmList() {
        String userId = (String) session.getAttribute("sessionId");
        // AlarmService의 반환 타입에 맞춰 HashMap으로 리턴
        return alarmService.getAlarmList(userId);
    }

    /**
     * 4. AJAX: 안 읽은 알림 개수 (헤더 오렌지 점 표시용)
     */
    @RequestMapping("/alarmCount.dox")
    @ResponseBody
    public HashMap<String, Object> alarmCount() {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) session.getAttribute("sessionId");
        
        int count = 0;
        if (userId != null) {
            count = alarmService.getUnreadAlarmCount(userId);
        }
        
        resultMap.put("count", count);
        resultMap.put("result", "success");
        return resultMap;
    }
    @RequestMapping("/removeAlarm.dox")
    @ResponseBody
    public HashMap<String, Object> removeAlarm(@RequestParam("alarmId") int alarmId) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            alarmService.removeAlarm(alarmId);
            resultMap.put("result", "success");
        } catch (Exception e) {
            resultMap.put("result", "error");
        }
        return resultMap;
    }

    /**
     * 6. 알림 전체 삭제
     * URL: /alarm/removeAllAlarms.dox
     */
    @RequestMapping("/removeAllAlarms.dox")
    @ResponseBody
    public HashMap<String, Object> removeAllAlarms() {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) session.getAttribute("sessionId");
        try {
            if (userId != null) {
                alarmService.removeAllAlarms(userId);
                resultMap.put("result", "success");
            }
        } catch (Exception e) {
            resultMap.put("result", "error");
        }
        return resultMap;
    }
}