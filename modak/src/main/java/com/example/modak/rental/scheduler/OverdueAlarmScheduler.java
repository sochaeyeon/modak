package com.example.modak.rental.scheduler;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.rental.mapper.RentalExtensionMapper;

@Component
public class OverdueAlarmScheduler {

    @Autowired
    private RentalExtensionMapper mapper;

    @Autowired
    private AlarmService alarmService;

    private static final int[] NOTIFY_STAGES = {1, 3, 7};

    @Scheduled(cron = "0 0 1 * * *")
    public void checkOverdueRentals() {
        for (int stage : NOTIFY_STAGES) {
            List<HashMap<String, Object>> targets = mapper.selectOverdueRentalsByStage(stage);

            for (HashMap<String, Object> rental : targets) {
                String userId = (String) rental.get("USER_ID");
                Long rentalId = ((Number) rental.get("RENTAL_ID")).longValue();
                String productName = (String) rental.get("PRODUCT_NAME");

                if (userId != null && !userId.startsWith("GUEST")) {
                    alarmService.createAlarm(
                        userId,
                        "OVERDUE",
                        "연체 " + stage + "일차 안내",
                        productName + " 반납이 " + stage + "일째 지연되고 있습니다. 연체료가 발생합니다.",
                        rentalId
                    );
                }

                mapper.updateOverdueNotifyStage(rentalId, stage);
            }
        }
    }
}