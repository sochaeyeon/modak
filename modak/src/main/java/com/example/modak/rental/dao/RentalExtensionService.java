package com.example.modak.rental.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.modak.rental.mapper.RentalExtensionMapper;
import com.example.modak.rental.model.RentalExtension;

@Service
public class RentalExtensionService {

    @Autowired
    private RentalExtensionMapper mapper;

    private static final int  PRICE_PER_DAY = 5000;
    private static final long TOKEN_TTL_MS  = 30 * 60 * 1000L;
    private static final Map<String, TokenEntry> TOKEN_STORE = new ConcurrentHashMap<>();

    // ══════════════════════════════════════════
    //  회원 - 대여 목록
    // ══════════════════════════════════════════
    public HashMap<String, Object> getMyRentals(String userId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            List<RentalExtension> list = mapper.selectMyRentals(userId);
            result.put("result", "success");
            result.put("list",   list);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "대여 목록을 불러오는 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ══════════════════════════════════════════
    //  회원 - 연장 내역 조회
    // ══════════════════════════════════════════
    public HashMap<String, Object> getExtensions(Long rentalId, String userId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectRentalByIdAndUser(rentalId, userId);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없습니다.");
                return result;
            }
            List<RentalExtension> extensions = mapper.selectExtensionsByRentalId(rentalId);
            result.put("result",     "success");
            result.put("rental",     rental);
            result.put("extensions", extensions);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "오류가 발생했습니다.");
        }
        return result;
    }

    // ══════════════════════════════════════════
    //  비회원 - 조회폼 검증 & 토큰 발급
    // ══════════════════════════════════════════
    public HashMap<String, Object> inquireGuestRental(Long rentalId,
                                                      String guestName,
                                                      String guestPhone) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectGuestRental(rentalId, guestName, guestPhone);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "입력하신 정보와 일치하는 대여 내역을 찾을 수 없습니다.");
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

    // ══════════════════════════════════════════
    //  비회원 - 토큰으로 상세 조회
    // ══════════════════════════════════════════
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
            List<RentalExtension> extensions = mapper.selectExtensionsByRentalId(rentalId);
            result.put("result",     "success");
            result.put("rental",     rental);
            result.put("extensions", extensions);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "오류가 발생했습니다.");
        }
        return result;
    }

    // ══════════════════════════════════════════
    //  공통 - 연장 신청
    // ══════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> applyExtension(Long rentalId, int extensionDays,
                                                   String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (extensionDays < 1 || extensionDays > 30) {
                result.put("result",  "fail");
                result.put("message", "연장 일수는 1일 이상 30일 이하로 입력해주세요.");
                return result;
            }

            // 소유자 검증
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없거나 권한이 없습니다.");
                return result;
            }

            // RESERVED 상태만 가능
            if (!"RESERVED".equals(rental.getRentalStatus())) {
                result.put("result",  "fail");
                result.put("message", "예약 완료(RESERVED) 상태의 대여만 연장할 수 있습니다.");
                return result;
            }

            int price = extensionDays * PRICE_PER_DAY;
            mapper.insertExtension(rentalId, extensionDays, price);
            mapper.updateReturnDate(rentalId, extensionDays);

            result.put("result",  "success");
            result.put("message", extensionDays + "일 연장이 완료되었습니다.");
            result.put("price",   price);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "연장 신청 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ══════════════════════════════════════════
    //  공통 - 연장 취소
    // ══════════════════════════════════════════
    @Transactional
    public HashMap<String, Object> cancelExtension(Long extensionId, Long rentalId,
                                                    String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) {
                result.put("result",  "fail");
                result.put("message", "대여 정보를 찾을 수 없거나 권한이 없습니다.");
                return result;
            }

            // 취소할 연장 건의 일수 역산
            List<RentalExtension> exts = mapper.selectExtensionsByRentalId(rentalId);
            int daysToSubtract = 0;
            for (RentalExtension ext : exts) {
                if (ext.getExtensionId().equals(extensionId)) {
                    daysToSubtract = ext.getExtensionDays();
                    break;
                }
            }
            if (daysToSubtract == 0) {
                result.put("result",  "fail");
                result.put("message", "해당 연장 내역을 찾을 수 없습니다.");
                return result;
            }

            int deleted = mapper.deleteExtension(extensionId, rentalId);
            if (deleted == 0) {
                result.put("result",  "fail");
                result.put("message", "연장 취소에 실패했습니다.");
                return result;
            }

            // RETURN_DATE 원복
            mapper.updateReturnDate(rentalId, -daysToSubtract);

            result.put("result",  "success");
            result.put("message", "연장이 취소되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result",  "fail");
            result.put("message", "연장 취소 중 오류가 발생했습니다.");
        }
        return result;
    }

    // ══════════════════════════════════════════
    //  내부 유틸
    // ══════════════════════════════════════════

    /** 회원이면 userId로, 비회원이면 token으로 소유자 확인 */
    private RentalExtension resolveRental(Long rentalId, String userId, String token) {
        if (userId != null && !userId.isBlank()) {
            return mapper.selectRentalByIdAndUser(rentalId, userId);
        }
        if (validateToken(token, rentalId)) {
            return mapper.selectRentalById(rentalId);
        }
        return null;
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
        TokenEntry(Long rentalId, long createdAt) {
            this.rentalId  = rentalId;
            this.createdAt = createdAt;
        }
    }
}
