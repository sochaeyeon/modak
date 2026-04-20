package com.example.modak.order.mapper;

import com.example.modak.order.model.GuestOrder;
import com.example.modak.order.model.GuestOrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GuestOrderMapper {

    /** 비회원 주문 단건 조회 (주문번호 + 이름 + 전화번호 3중 검증) */
    GuestOrder selectGuestOrder(@Param("orderId")    String orderId,
                                @Param("guestName")  String guestName,
                                @Param("guestPhone") String guestPhone);

    /** 토큰 검증 통과 후 주문번호만으로 조회 (상세 페이지용) */
    GuestOrder selectGuestOrderById(@Param("orderId") String orderId);

    /** 주문 상품 목록 */
    List<GuestOrderItem> selectGuestOrderItems(@Param("orderId") String orderId);

    /** 주문 상태 업데이트 (취소 / 반품) */
    int updateOrderStatus(@Param("orderId")     String orderId,
                          @Param("orderStatus") String orderStatus);
}
