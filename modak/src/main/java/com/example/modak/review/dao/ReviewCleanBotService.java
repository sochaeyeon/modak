package com.example.modak.review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.modak.alarm.mapper.AlarmMapper;
import com.example.modak.badword.dao.BadWordService;
import com.example.modak.review.mapper.ReviewMapper;

@Service
public class ReviewCleanBotService {

    @Autowired private ReviewMapper reviewMapper;
    @Autowired private AlarmMapper alarmMapper;
    @Autowired private BadWordService badWordService;

    /** 매일 새벽 3시 실행 */
    @Scheduled(cron = "0 0 3 * * *")
    @Transactional
    public Map<String, Object> scanAndClean() {
        List<Map<String, Object>> reviews = reviewMapper.selectActiveReviewsForScan();
        int total = reviews.size();
        int blocked = 0;

        for (Map<String, Object> r : reviews) {
            Long reviewId = Long.parseLong(String.valueOf(r.get("REVIEW_ID")));
            String userId = String.valueOf(r.get("USER_ID"));
            String content = String.valueOf(r.get("CONTENT"));

            if (badWordService.containsBadWord(content)) {
                // 1) 차단 처리
                reviewMapper.blockReviewByBot(reviewId);

                // 2) 알람 발송
                Map<String, Object> alarm = new HashMap<>();
                alarm.put("userId", userId);
                alarm.put("reviewId", reviewId);
                alarmMapper.insertReviewBlockedAlarm(alarm);

                blocked++;
            }
        }

        // 3) 실행 이력 로그
        Map<String, Object> log = new HashMap<>();
        log.put("total", total);
        log.put("blocked", blocked);
        reviewMapper.insertBotLog(log);

        System.out.println("[ReviewCleanBot] 총 " + total + "건 검사, " + blocked + "건 차단");
        return Map.of("result", "success", "total", total, "blocked", blocked);
    }
}