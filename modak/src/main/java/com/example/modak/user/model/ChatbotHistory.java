package com.example.modak.user.model;

import lombok.Data;

@Data
public class ChatbotHistory {

    private Long chatId;
    private String userId;
    private String roomId;
    private String title;
    private String lastRegDate;
}
