<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- <%
    String orderId = request.getParameter("orderId");
    if (orderId == null || orderId.isEmpty()) {
        orderId = "TEST-20260429-001";
    }
    request.setAttribute("orderId", orderId);
%> -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 완료 - 모닥모닥</title>
    <link rel="stylesheet" href="/css/payment/order-complete.css">
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>

    <div class="step-wrap">
        <div class="step active">장바구니</div>
        <div class="step-line"></div>
        <div class="step active">주문결제</div>
        <div class="step-line"></div>
        <div class="step active">완료</div>
    </div>

    <main class="complete-wrap">
        <section class="complete-card">
            <div class="complete-top">
                <div class="complete-icon">✓</div>
                <div>
                    <p class="complete-label">PAYMENT COMPLETE</p>
                    <h2 class="complete-title">주문이 완료되었습니다</h2>
                </div>
            </div>

            <p class="complete-desc">
                모닥모닥을 이용해주셔서 감사합니다.<br>
                주문 내역에서 결제 정보와 배송 상태를 확인할 수 있습니다.
            </p>

            <div class="complete-info-box">
                <div class="complete-info-row">
                    <span>주문번호</span>
                    <strong>${orderId}</strong>
                </div>
                <div class="complete-info-row">
                    <span>주문상태</span>
                    <strong class="orange">결제완료</strong>
                </div>
            </div>

            <div class="complete-notice">
                <strong>안내사항</strong>
                <p>대여 상품은 선택한 대여 기간에 맞춰 준비됩니다.</p>
                <p>구매 상품은 결제 완료 후 순차적으로 배송됩니다.</p>
            </div>

            <div class="complete-btns">
                <a href="/order/history.do" class="complete-btn primary">주문 내역 보기</a>
                <a href="/product/list.do" class="complete-btn secondary">쇼핑 계속하기</a>
            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/common/footer.jsp" %>

</body>
</html>
<script>
    const params = new URLSearchParams(location.search);
    const isBuyNow = params.get('buyNow') === 'true';

    if (isBuyNow) {
        localStorage.removeItem('modak_guest_buy_now');
    } else {
        localStorage.removeItem('modak_guest_cart');
    }
</script>