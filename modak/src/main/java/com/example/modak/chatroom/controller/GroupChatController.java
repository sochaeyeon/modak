package com.example.modak.chatroom.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.chatroom.dao.GroupChatService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/chat-room/group")
public class GroupChatController {

    @Autowired private GroupChatService groupChatService;
    @Autowired private HttpSession session;

    private static final Map<Long, Map<String, Long>> typingMap = new ConcurrentHashMap<>();

    // ── 페이지 ──────────────────────────────────
    @GetMapping("/list.do")
    public String groupListPage() {
        return "board/group-chat-list";
    }

    @GetMapping("/room.do")
    public String groupRoomPage() {
        return "board/group-chat-room";
    }

    // ── AJAX ────────────────────────────────────
    @PostMapping(value = "/create.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String create(@RequestParam String roomName,
                          @RequestParam String memberIds,
                          @RequestParam(required = false) Integer maxMember) {
        String hostId = (String) session.getAttribute("sessionId");
        if (hostId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.createRoom(hostId, roomName, memberIds, maxMember));
    }

    @PostMapping(value = "/invite.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String invite(@RequestParam Long roomId, @RequestParam String memberIds) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.inviteMembers(userId, roomId, memberIds));
    }

    @PostMapping(value = "/rooms.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String myRooms() {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.getMyRooms(userId));
    }

    @PostMapping(value = "/members.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String members(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.getMembers(roomId, userId));
    }

    @PostMapping(value = "/send.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String send(@RequestParam Long roomId, @RequestParam String content) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.sendMessage(roomId, userId, "TEXT", content));
    }

    /** 이미지 전송 — 1:1 채팅과 동일한 /img/chat/ 폴더 공유 */
    @PostMapping(value = "/send-image.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendImage(@RequestParam Long roomId,
                             @RequestParam MultipartFile image,
                             HttpServletRequest request) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }

        String uploadPath = request.getServletContext().getRealPath("/img/chat/");
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String original = image.getOriginalFilename();
        String ext = (original != null && original.contains("."))
                ? original.substring(original.lastIndexOf('.'))
                : "";
        String fileName = "group_" + System.currentTimeMillis() + "_" + (int) (Math.random() * 10000) + ext;

        try {
            image.transferTo(new File(dir, fileName));
        } catch (Exception e) {
            return "{\"result\":\"fail\",\"message\":\"이미지 업로드 실패\"}";
        }

        String content = "/img/chat/" + fileName;
        return new Gson().toJson(groupChatService.sendMessage(roomId, userId, "IMAGE", content));
    }

    /** 스티커 전송 */
    @PostMapping(value = "/send-sticker.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendSticker(@RequestParam Long roomId, @RequestParam String content) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.sendMessage(roomId, userId, "STICKER", content));
    }

    @PostMapping(value = "/messages.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String messages(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.getMessages(roomId, userId));
    }

    @PostMapping(value = "/leave.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String leave(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\",\"message\":\"로그인이 필요합니다.\"}";
        }
        return new Gson().toJson(groupChatService.leaveRoom(roomId, userId));
    }

    /** 입력 중 상태 등록 */
    @PostMapping(value = "/typing.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String typing(@RequestParam Long roomId) {
        String userId = (String) session.getAttribute("sessionId");
        if (userId == null) {
            return "{\"result\":\"fail\"}";
        }
        typingMap.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>())
                 .put(userId, System.currentTimeMillis());
        return "{\"result\":\"success\"}";
    }

    /** 나를 제외한 입력 중인 멤버 목록 (userId 배열) */
    @PostMapping(value = "/typing/list.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String typingList(@RequestParam Long roomId) {
        String myUserId = (String) session.getAttribute("sessionId");
        Map<String, Long> roomTyping = typingMap.get(roomId);
        List<String> typingUsers = new ArrayList<>();

        if (roomTyping != null) {
            long now = System.currentTimeMillis();
            for (Map.Entry<String, Long> e : roomTyping.entrySet()) {
                if (!e.getKey().equals(myUserId) && now - e.getValue() <= 3000) {
                    typingUsers.add(e.getKey());
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("typingUsers", typingUsers);
        return new Gson().toJson(result);
    }
}