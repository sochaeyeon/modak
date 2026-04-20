package com.example.modak.order.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.order.mapper.GuestOrderMapper;
import com.example.modak.order.model.GuestOrder;
import com.example.modak.order.model.GuestOrderItem;

@Service
public class GuestOrderService {

    @Autowired
    private GuestOrderMapper guestOrderMapper;

    /**
     * 조회 성공 시 임시 토큰 발급 — 30분 유효
     * 운영 환경에서는 Redis TTL 방식으로 교체 권장
     */
    private static final Map<String, TokenEntry> TOKEN_STORE = new ConcurrentHashMap<>();
    private static final long TOKEN_TTL_MS = 30 * 60 * 1000L;

    // ──────────────────────────────────────────────
    //  비회원 주문 조회 (조회폼 제출)
    //  주문번호 + 이름 + 전화번호 3중 검증
    // ──────────────────────────────────────────────
    public HashMap<String, Object> inquireGuestOrder(String orderId,
                                                     String guestName,
                                                     String guestPhone) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            GuestOrder order = guestOrderMapper.selectGuestOrder(
                    orderId, guestName, guestPhone);

            if (order == null) {
                result.put("result",  "fail");
                result.put("message", "입력하신 정보와 일치하는 주문을 찾을 수 없습니다.");
                return result;
            }

            // 토큰 발급
            String token = UUID.randomUUID().toString().replace("-", "");
            TOKEN_STORE.put(token, new TokenEntry(orderId, System.currentTimeMillis()));
            purgeExpiredTokens();

            result.put("result",  "success");
            result.put("orderId", orderId);
            result.put("token",   token);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ──────────────────────────────────────────────
    //  비회원 주문 상세 조회 (토큰 검증 후)
    // ──────────────────────────────────────────────
    public HashMap<String, Object> getGuestOrderDetail(String orderId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (!validateToken(token, orderId)) {
                result.put("result",  "fail");
                result.put("message", "유효하지 않은 접근입니다. 다시 조회해주세요.");
                return result;
            }

            // 토큰 검증 통과 → 주문번호만으로 조회
            GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);
            if (order == null) {
                result.put("result",  "fail");
                result.put("message", "주문 정보를 찾을 수 없습니다.");
                return result;
            }

            // 상품 목록 세팅
            List<GuestOrderItem> items = guestOrderMapper.selectGuestOrderItems(orderId);
            order.setItems(items);

            result.put("result", "success");
            result.put("order",  order);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ──────────────────────────────────────────────
    //  주문 취소
    // ──────────────────────────────────────────────
    public HashMap<String, Object> cancelGuestOrder(String orderId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (!validateToken(token, orderId)) {
                result.put("result",  "fail");
                result.put("message", "유효하지 않은 접근입니다.");
                return result;
            }

            // 취소 가능한 상태인지 확인 (PAID, READY 만 가능)
            GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);
            if (order == null) {
                result.put("result",  "fail");
                result.put("message", "주문 정보를 찾을 수 없습니다.");
                return result;
            }
            String status = order.getOrderStatus();
            if (!"PAID".equals(status) && !"READY".equals(status)) {
                result.put("result",  "fail");
                result.put("message", "현재 상태에서는 취소할 수 없습니다.");
                return result;
            }

            int updated = guestOrderMapper.updateOrderStatus(orderId, "CANCELLED");
            result.put("result", updated > 0 ? "success" : "fail");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ──────────────────────────────────────────────
    //  반품 신청 (배송중 상태에서만 가능)
    // ──────────────────────────────────────────────
    public HashMap<String, Object> returnGuestOrder(String orderId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (!validateToken(token, orderId)) {
                result.put("result",  "fail");
                result.put("message", "유효하지 않은 접근입니다.");
                return result;
            }

            GuestOrder order = guestOrderMapper.selectGuestOrderById(orderId);
            if (order == null) {
                result.put("result",  "fail");
                result.put("message", "주문 정보를 찾을 수 없습니다.");
                return result;
            }
            if (!"SHIPPING".equals(order.getOrderStatus())) {
                result.put("result",  "fail");
                result.put("message", "배송중인 주문만 반품 신청할 수 있습니다.");
                return result;
            }

            int updated = guestOrderMapper.updateOrderStatus(orderId, "CANCELLED");
            result.put("result", updated > 0 ? "success" : "fail");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ──────────────────────────────────────────────
    //  토큰 유틸
    // ──────────────────────────────────────────────
    private boolean validateToken(String token, String orderId) {
        if (token == null || orderId == null) return false;
        TokenEntry entry = TOKEN_STORE.get(token);
        if (entry == null) return false;
        if (!entry.orderId.equals(orderId)) return false;
        if (System.currentTimeMillis() - entry.createdAt > TOKEN_TTL_MS) {
            TOKEN_STORE.remove(token);
            return false;
        }
        return true;
    }

    private void purgeExpiredTokens() {
        long now = System.currentTimeMillis();
        TOKEN_STORE.entrySet().removeIf(e -> now - e.getValue().createdAt > TOKEN_TTL_MS);
    }

    private static class TokenEntry {
        final String orderId;
        final long   createdAt;
        TokenEntry(String orderId, long createdAt) {
            this.orderId   = orderId;
            this.createdAt = createdAt;
        }
    }
}
