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

    /* ★ 연장 가능 상태: RESERVED + IN_USE 둘 다 허용 */
    private static final List<String> EXTENDABLE = List.of("RESERVED", "IN_USE");

    private static final long TOKEN_TTL_MS = 30 * 60 * 1000L;
    private static final Map<String, TokenEntry> TOKEN_STORE = new ConcurrentHashMap<>();

    // 회원 대여 목록
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

    // 회원 연장 내역 조회
    public HashMap<String, Object> getExtensions(Long rentalId, String userId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectRentalByIdAndUser(rentalId, userId);
            if (rental == null) { result.put("result","fail"); result.put("message","대여 정보를 찾을 수 없습니다."); return result; }
            result.put("result",     "success");
            result.put("rental",     rental);
            result.put("extensions", mapper.selectExtensionsByRentalId(rentalId));
            result.put("returnHistory", mapper.selectReturnHistoryByRentalId(rentalId));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result","fail"); result.put("message","오류가 발생했습니다.");
        }
        return result;
    }

    // 비회원 조회 & 토큰 발급
    public HashMap<String, Object> inquireGuestRental(Long rentalId, String guestName, String guestPhone) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = mapper.selectGuestRental(rentalId, guestName, guestPhone);
            if (rental == null) { result.put("result","fail"); result.put("message","일치하는 대여 내역을 찾을 수 없습니다."); return result; }
            String token = UUID.randomUUID().toString().replace("-","");
            TOKEN_STORE.put(token, new TokenEntry(rentalId, System.currentTimeMillis()));
            purgeExpiredTokens();
            result.put("result","success"); result.put("rentalId",rentalId); result.put("token",token);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result","fail"); result.put("message","서버 오류가 발생했습니다.");
        }
        return result;
    }

    // 비회원 토큰 검증 후 상세 조회
    public HashMap<String, Object> getGuestExtensions(Long rentalId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (!validateToken(token, rentalId)) { result.put("result","fail"); result.put("message","유효하지 않은 접근입니다. 다시 조회해주세요."); return result; }
            RentalExtension rental = mapper.selectRentalById(rentalId);
            
            if (rental == null) { result.put("result","fail"); result.put("message","대여 정보를 찾을 수 없습니다."); return result; }
            result.put("result","success"); result.put("rental",rental); result.put("extensions",mapper.selectExtensionsByRentalId(rentalId));
            result.put("returnHistory", mapper.selectReturnHistoryByRentalId(rentalId)); // ← 추가
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result","fail"); result.put("message","오류가 발생했습니다.");
        }
        return result;
    }

    // ★ 공통 연장 신청 — 상품 가격 기준 요금 계산, RESERVED+IN_USE 허용
    @Transactional
    public HashMap<String, Object> applyExtension(Long rentalId, int extensionDays,
                                                   String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            if (extensionDays < 1 || extensionDays > 30) {
                result.put("result","fail"); result.put("message","연장 일수는 1~30일 이하로 입력해주세요."); return result;
            }
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) {
                result.put("result","fail"); result.put("message","대여 정보를 찾을 수 없거나 권한이 없습니다."); return result;
            }
            /* ★ RESERVED 또는 IN_USE 상태만 허용 */
            if (!EXTENDABLE.contains(rental.getRentalStatus())) {
                result.put("result","fail");
                result.put("message","대여중(IN_USE) 또는 예약완료(RESERVED) 상태만 연장 가능합니다.");
                return result;
            }
            /* ★ 상품별 1일 가격 × 연장일수 */
            int pricePerDay = rental.getPricePerDay() > 0 ? rental.getPricePerDay() : 5000;
            int price = pricePerDay * extensionDays;

            mapper.insertExtension(rentalId, extensionDays, price);
            mapper.updateReturnDate(rentalId, extensionDays);

            result.put("result","success");
            result.put("message", extensionDays + "일 연장 완료! 추가 요금: " + String.format("%,d",price) + "원");
            result.put("price", price);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result","fail"); result.put("message","연장 신청 중 오류가 발생했습니다.");
        }
        return result;
    }

    // 공통 연장 취소
    @Transactional
    public HashMap<String, Object> cancelExtension(Long extensionId, Long rentalId,
                                                    String userId, String token) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            RentalExtension rental = resolveRental(rentalId, userId, token);
            if (rental == null) { result.put("result","fail"); result.put("message","권한이 없습니다."); return result; }

            List<RentalExtension> exts = mapper.selectExtensionsByRentalId(rentalId);
            int daysToSubtract = exts.stream()
                .filter(e -> e.getExtensionId().equals(extensionId))
                .mapToInt(RentalExtension::getExtensionDays).findFirst().orElse(0);

            if (daysToSubtract == 0) { result.put("result","fail"); result.put("message","연장 내역을 찾을 수 없습니다."); return result; }
            if (mapper.deleteExtension(extensionId, rentalId) == 0) { result.put("result","fail"); result.put("message","취소에 실패했습니다."); return result; }

            mapper.updateReturnDate(rentalId, -daysToSubtract);
            result.put("result","success"); result.put("message","연장이 취소되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result","fail"); result.put("message","연장 취소 중 오류가 발생했습니다.");
        }
        return result;
    }

    private RentalExtension resolveRental(Long rentalId, String userId, String token) {
        if (userId != null && !userId.isBlank()) return mapper.selectRentalByIdAndUser(rentalId, userId);
        if (validateToken(token, rentalId))       return mapper.selectRentalById(rentalId);
        return null;
    }

    private boolean validateToken(String token, Long rentalId) {
        if (token == null || rentalId == null) return false;
        TokenEntry entry = TOKEN_STORE.get(token);
        if (entry == null) return false;
        if (!entry.rentalId.equals(rentalId)) return false;
        if (System.currentTimeMillis() - entry.createdAt > TOKEN_TTL_MS) { TOKEN_STORE.remove(token); return false; }
        return true;
    }

    private void purgeExpiredTokens() {
        long now = System.currentTimeMillis();
        TOKEN_STORE.entrySet().removeIf(e -> now - e.getValue().createdAt > TOKEN_TTL_MS);
    }

    private static class TokenEntry {
        final Long rentalId; final long createdAt;
        TokenEntry(Long r, long c) { rentalId = r; createdAt = c; }
    }
    
 // 반납 가능 목록 조회
    public HashMap<String, Object> getReturnableList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = mapper.selectReturnableRentals(map);
            result.put("result", "success");
            result.put("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // 반납 신청
    @Transactional
    public HashMap<String, Object> applyReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int affected = mapper.updateReturnRequest(map);

            if (affected > 0) {
                mapper.updateDeliveryReturnRequest(map);

                result.put("result", "success");
                result.put("message", "반납 신청이 완료되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "반납 신청할 수 없는 상태입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반납 신청 중 오류가 발생했습니다.");
        }

        return result;
    }
    // 비회원 반납 신청
    @Transactional
    public HashMap<String, Object> applyGuestReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int affected = mapper.updateGuestReturnRequest(map);

            if (affected > 0) {
                mapper.updateDeliveryReturnRequest(map);

                result.put("result", "success");
                result.put("message", "반납 신청이 완료되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "반납 신청할 수 없는 상태입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반납 신청 중 오류가 발생했습니다.");
        }

        return result;
    }
    
    
    @Transactional
    public HashMap<String, Object> cancelReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int affected = mapper.cancelReturnRequest(map);

            if (affected > 0) {
                mapper.cancelDeliveryReturnRequest(map);

                result.put("result", "success");
                result.put("message", "반납 요청이 취소되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "취소할 수 없는 상태입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }

        return result;
    }

    @Transactional
    public HashMap<String, Object> cancelGuestReturn(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int affected = mapper.cancelGuestReturnRequest(map);

            if (affected > 0) {
                mapper.cancelDeliveryReturnRequest(map);

                result.put("result", "success");
                result.put("message", "반납 요청이 취소되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "취소할 수 없는 상태입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }

        return result;
    }
    public HashMap<String, Object> getDefaultPickupAddress(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            HashMap<String, Object> address = mapper.selectDefaultPickupAddress(map);

            result.put("result", "success");
            result.put("address", address);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }

        return result;
    }

    public HashMap<String, Object> getGuestPickupAddress(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            HashMap<String, Object> address = mapper.selectGuestPickupAddress(map);

            result.put("result", "success");
            result.put("address", address);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }

        return result;
    }
    

    
}