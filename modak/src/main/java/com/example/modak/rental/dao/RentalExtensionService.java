package com.example.modak.rental.dao;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.order.dao.GuestOrderService;
import com.example.modak.rental.mapper.RentalExtensionMapper;
import com.example.modak.rental.model.RentalExtension;


@Service
public class RentalExtensionService {

    @Autowired
    private RentalExtensionMapper mapper;
    
    @Autowired
    private AlarmService alarmService;

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    /* ★ 연장 가능 상태 */
    private static final List<String> EXTENDABLE =
            List.of("PAID", "READY", "SHIPPING", "DONE", "IN_USE");

    /* ★ 비회원 토큰 저장소 */
    private static final long TOKEN_TTL_MS = 30 * 60 * 1000L;
    private static final Map<String, TokenEntry> TOKEN_STORE = new ConcurrentHashMap<>();

    // ════════════════════════════════════════
    // 회원 대여 목록
    // ════════════════════════════════════════
    public HashMap<String, Object> getMyRentals(String userId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            result.put("result", "success");
            result.put("list",   mapper.selectMyRentals(userId));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "대여 목록 조회 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 회원 연장 내역 조회
    // ════════════════════════════════════════
    public HashMap<String, Object> getExtensions(Long rentalId, String userId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectRentalByIdAndUser(rentalId, userId);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없습니다.");
                return result;
            }
            result.put("result",        "success");
            result.put("rental",        rental);
            result.put("extensions",    mapper.selectExtensionsByRentalId(rentalId));
            result.put("returnHistory", mapper.selectReturnHistoryByRentalId(rentalId));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 비회원 조회 & 토큰 발급
    // ════════════════════════════════════════
    public HashMap<String, Object> inquireGuestRental(Long rentalId, String guestName, String guestPhone) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectGuestRental(rentalId, guestName, guestPhone);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "일치하는 대여 내역을 찾을 수 없습니다.");
                return result;
            }
            String token = UUID.randomUUID().toString().replace("-", "");
            TOKEN_STORE.put(token, new TokenEntry(rentalId, System.currentTimeMillis()));
            purgeExpiredTokens();
            result.put("result",   "success");
            result.put("rentalId", rentalId);
            result.put("token",    token);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "서버 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 비회원 토큰 검증 후 상세 조회
    // ════════════════════════════════════════
    public HashMap<String, Object> getGuestExtensions(Long rentalId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (!validateToken(token, rentalId)) {
                result.put("result",  "fail");
                result.put("message", "유효하지 않은 접근입니다. 다시 조회해주세요.");
                return result;
            }
            RentalExtension rental = mapper.selectRentalById(rentalId);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없습니다.");
                return result;
            }
            result.put("result",        "success");
            result.put("rental",        rental);
            result.put("extensions",    mapper.selectExtensionsByRentalId(rentalId));
            result.put("returnHistory", mapper.selectReturnHistoryByRentalId(rentalId));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 연장 신청 (회원/비회원 공통) — 결제 후 호출
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> applyExtension(Long rentalId, int extensionDays,
                                                   String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (extensionDays < 1 || extensionDays > 30) {
                result.put("result",  "fail");
                result.put("message", "연장 일수는 1~30일 이하로 입력해주세요.");
                return result;
            }
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없거나 권한이 없습니다.");
                return result;
            }
            if (!EXTENDABLE.contains(rental.getRentalStatus())) {
                result.put("result",  "fail");
                result.put("message", "현재 상태에서는 연장 신청이 불가능합니다.");
                return result;
            }

            int pricePerDay = rental.getPricePerDay() > 0 ? rental.getPricePerDay() : 5000;
            int price       = pricePerDay * extensionDays;

            // HashMap으로 통일
            HashMap<String, Object> extMap = new HashMap<>();
            extMap.put("rentalId",      rentalId);
            extMap.put("extensionDays", extensionDays);
            extMap.put("price",         price);
            mapper.insertExtension(extMap);
            mapper.updateReturnDate(extMap);

            result.put("result",  "success");
            result.put("message", extensionDays + "일 연장 완료! 추가 요금: "
                    + String.format("%,d", price) + "원");
            result.put("price", price);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "연장 신청 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 연장 취소 (회원/비회원 공통)
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> cancelExtension(Long extensionId, Long rentalId,
                                                    String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "권한이 없습니다.");
                return result;
            }

            List<RentalExtension> exts = mapper.selectExtensionsByRentalId(rentalId);
            int daysToSubtract = exts.stream()
                    .filter(e -> e.getExtensionId().equals(extensionId))
                    .mapToInt(RentalExtension::getExtensionDays)
                    .findFirst().orElse(0);

            if (daysToSubtract == 0) {
                result.put("result",  "fail");
                result.put("message", "연장 내역을 찾을 수 없습니다.");
                return result;
            }

            // deleteExtension — HashMap
            HashMap<String, Object> delMap = new HashMap<>();
            delMap.put("extensionId", extensionId);
            delMap.put("rentalId",    rentalId);
            if (mapper.deleteExtension(delMap) == 0) {
                result.put("result",  "fail");
                result.put("message", "취소에 실패했습니다.");
                return result;
            }

            // updateReturnDate — 음수로 원복
            HashMap<String, Object> dateMap = new HashMap<>();
            dateMap.put("rentalId",      rentalId);
            dateMap.put("extensionDays", -daysToSubtract);
            mapper.updateReturnDate(dateMap);

            result.put("result",  "success");
            result.put("message", "연장이 취소되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "연장 취소 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 반납 가능 목록 조회
    // ════════════════════════════════════════
    public HashMap<String, Object> getReturnableList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            result.put("result", "success");
            result.put("list",   mapper.selectReturnableRentals(map));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 회원 반납 신청
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> applyReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            int affected = mapper.updateReturnRequest(map);
            if (affected > 0) {
                mapper.updateDeliveryReturnRequest(map);
                result.put("result",  "success");
                result.put("message", "반납 신청이 완료되었습니다.");
            } else {
                result.put("result",  "fail");
                result.put("message", "반납 신청할 수 없는 상태입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "반납 신청 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 비회원 반납 신청
    // ════════════════════════════════════════
    
 // ★ @PostMapping, @ResponseBody, @RequestParam 전부 제거
 // ★ rentalExtensionService 자기 자신 참조 제거
 // ★ GuestOrderService도 여기선 필요 없음 → Controller에서 처리

 @Transactional
 public HashMap<String, Object> applyGuestReturn(HashMap<String, Object> map) {
     HashMap<String, Object> result = new HashMap<>();
     try {
         int affected = mapper.updateGuestReturnRequest(map);
         if (affected > 0) {
             mapper.updateDeliveryReturnRequest(map);
             result.put("result",  "success");
             result.put("message", "반납 신청이 완료되었습니다.");
         } else {
             result.put("result",  "fail");
             result.put("message", "반납 신청할 수 없는 상태입니다.");
         }
     } catch (Exception e) {
         e.printStackTrace();
         result.put("result",  "fail");
         result.put("message", "반납 신청 중 오류가 발생했습니다.");
     }
     return result;
 }
    // ════════════════════════════════════════
    // 회원 반납 취소
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> cancelReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            int affected = mapper.cancelReturnRequest(map);
            if (affected > 0) {
                mapper.cancelDeliveryReturnRequest(map);
                result.put("result",  "success");
                result.put("message", "반납 요청이 취소되었습니다.");
            } else {
                result.put("result",  "fail");
                result.put("message", "취소할 수 없는 상태입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 비회원 반납 취소
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> cancelGuestReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            int affected = mapper.cancelGuestReturnRequest(map);
            if (affected > 0) {
                mapper.cancelDeliveryReturnRequest(map);
                result.put("result",  "success");
                result.put("message", "반납 요청이 취소되었습니다.");
            } else {
                result.put("result",  "fail");
                result.put("message", "취소할 수 없는 상태입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 픽업 주소 조회
    // ════════════════════════════════════════
    public HashMap<String, Object> getDefaultPickupAddress(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            result.put("result",  "success");
            result.put("address", mapper.selectDefaultPickupAddress(map));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    public HashMap<String, Object> getGuestPickupAddress(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            result.put("result",  "success");
            result.put("address", mapper.selectGuestPickupAddress(map));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ════════════════════════════════════════
    // 연장 결제 준비 (회원/비회원 공통)
    // ════════════════════════════════════════
    public HashMap<String, Object> readyExtensionPayment(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            int days        = Integer.parseInt(String.valueOf(map.get("extensionDays")));
            int pricePerDay = Integer.parseInt(String.valueOf(map.get("pricePerDay")));
            long price      = (long) days * pricePerDay;
            map.put("price", price);

            String userId = String.valueOf(map.get("userId"));
            if ("GUEST".equals(userId) || "null".equals(userId)) {
                map.put("userId",     "GUEST");
                map.put("guestToken", map.get("token")); // 비회원 토큰
            } else {
                map.put("guestToken", null);
            }

            mapper.insertExtensionOrder(map); // extensionOrderId 자동 반환

            result.put("result",           "success");
            result.put("extensionOrderId", map.get("extensionOrderId"));
            result.put("amount",           price);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ════════════════════════════════════════
    // 연장 결제 승인 (회원/비회원 공통)
    // ════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> confirmExtensionPayment(String paymentKey, String orderId,
                                                            Long amount, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            // 1. Toss API 승인
            String auth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes());
            String body = String.format(
                    "{\"paymentKey\":\"%s\",\"orderId\":\"%s\",\"amount\":%d}",
                    paymentKey, orderId, amount);

            HttpClient  client  = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                    .header("Authorization", "Basic " + auth)
                    .header("Content-Type",  "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body)).build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                result.put("result",  "fail");
                result.put("message", "Toss 승인 실패: " + response.body());
                return result;
            }

            // 2. extensionOrderId 파싱 (orderId 형식: "ext-{id}")
         // Service
            Long extensionOrderId = Long.parseLong(orderId.replace("ext-", ""));

            HashMap<String, Object> orderMap = new HashMap<>();
            orderMap.put("extensionOrderId", extensionOrderId);
            HashMap<String, Object> extOrder = mapper.selectExtensionOrder(orderMap);

            if (extOrder == null) throw new RuntimeException("연장 주문 정보를 찾을 수 없습니다.");

            // 3. 비회원이면 token 검증
            String savedUserId     = String.valueOf(extOrder.get("USER_ID"));
            String savedGuestToken = String.valueOf(extOrder.get("GUEST_TOKEN"));

            if ("GUEST".equals(savedUserId)) {
                if (token == null || !token.equals(savedGuestToken)) {
                    result.put("result",  "fail");
                    result.put("message", "비회원 인증 정보가 일치하지 않습니다.");
                    return result;
                }
            }

            // 4. 연장 내역 INSERT (rental_extension 테이블)
            Long rentalId      = Long.parseLong(String.valueOf(extOrder.get("RENTAL_ID")));
            int  extensionDays = Integer.parseInt(String.valueOf(extOrder.get("EXTENSION_DAYS")));
            long price         = Long.parseLong(String.valueOf(extOrder.get("PRICE")));

            HashMap<String, Object> extMap = new HashMap<>();
            extMap.put("rentalId",      rentalId);
            extMap.put("extensionDays", extensionDays);
            extMap.put("price",         price);
            mapper.insertExtension(extMap);

            // 5. 반납일 업데이트
            mapper.updateReturnDate(extMap);

            // 6. 결제 주문 상태 PAID
            orderMap.put("status", "PAID");
            mapper.updateExtensionOrderStatus(orderMap);
            
            String userId = String.valueOf(extOrder.get("USER_ID"));
           
            if (!"GUEST".equals(savedUserId)) {
                alarmService.createAlarm(savedUserId, "NOTICE",
                    "대여 연장이 완료되었습니다 📅",
                    extensionDays + "일 연장되었습니다. 추가 요금: "
                        + String.format("%,d", price) + "원", rentalId);
            }
            result.put("result",   "success");
            result.put("rentalId", rentalId);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ════════════════════════════════════════
    // 내부 헬퍼
    // ════════════════════════════════════════
    private RentalExtension resolveRental(Long rentalId, String userId, String token) {
        if (userId != null && !userId.isBlank())
            return mapper.selectRentalByIdAndUser(rentalId, userId);
        if (validateToken(token, rentalId))
            return mapper.selectRentalById(rentalId);
        return null;
    }
    
    public HashMap<String, Object> getGuestRentalListByOrder(String orderId, String token) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<RentalExtension> list = mapper.selectGuestRentalListByOrder(orderId);

            result.put("result", "success");
            result.put("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "대여 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    private boolean validateToken(String token, Long rentalId) {
        if (token == null || rentalId == null) return false;
        TokenEntry entry = TOKEN_STORE.get(token);
        if (entry == null) return false;
        if (!entry.rentalId.equals(rentalId)) return false;
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
        final Long rentalId;
        final long createdAt;
        TokenEntry(Long r, long c) { rentalId = r; createdAt = c; }
    }
    public HashMap<String, Object> getExtensionOrder(HashMap<String, Object> map) {
        return mapper.selectExtensionOrder(map);
    }
    public boolean validateGuestRental(String rentalId, String guestPhone, String guestName) {
        try {
            if (rentalId == null || "null".equals(rentalId)) return false;
            HashMap<String, Object> map = new HashMap<>();
            map.put("rentalId",   Long.parseLong(rentalId));
            map.put("guestPhone", guestPhone);
            map.put("guestName",  guestName);
            RentalExtension rental = mapper.selectGuestRentalByPhone(map);
            return rental != null;
        } catch (Exception e) {
            return false;
        }
    }
}