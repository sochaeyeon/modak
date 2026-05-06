<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>결제 실패 - 모닥모닥</title>

        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/payment/order-complete.css"> <!-- 기존 스타일 재사용 -->
    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div class="step-wrap">
                <div class="step active">장바구니</div>
                <div class="step-line"></div>
                <div class="step active">주문결제</div>
                <div class="step-line"></div>
                <div class="step active fail">실패</div>
            </div>

            <main class="complete-page">
                <section class="complete-card">

                    <!-- 상단 -->
                    <div class="complete-hero">
                        <div class="complete-icon fail">✕</div>

                        <div class="complete-title-box">
                            <p class="complete-kicker fail">PAYMENT FAILED</p>
                            <h1>결제에 실패했습니다</h1>
                            <p class="complete-desc">
                                결제 처리 중 문제가 발생했습니다.<br>
                                다시 시도하시거나 다른 결제 수단을 이용해주세요.
                            </p>
                        </div>
                    </div>

                    <!-- 에러 메시지 -->
                    <div class="complete-notice fail">
                        <div class="notice-head">
                            <span>!</span>
                            <strong>실패 사유</strong>
                        </div>
                        <p>${message}</p>
                    </div>

                    <!-- 버튼 -->
                    <div class="complete-btns">
                        <a href="javascript:history.back()" class="complete-btn primary">다시 결제하기</a>
                        <a href="/product/list.do" class="complete-btn secondary">장비 둘러보기</a>
                    </div>

                </section>
            </main>

            <%@ include file="/WEB-INF/common/footer.jsp" %>
    </body>

    </html>