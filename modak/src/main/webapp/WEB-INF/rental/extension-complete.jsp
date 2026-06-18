<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>연장 완료 - 모닥모닥</title>

        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
        <link rel="stylesheet" href="/css/rental/extension-complete.css">
    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>

            <main class="extension-complete-page">

                <section class="complete-card">

                    <div class="complete-icon">
                        <i class="ri-checkbox-circle-line"></i>
                    </div>

                    <p class="complete-kicker">EXTENSION COMPLETE</p>

                    <h1 class="complete-title">
                        ${type == 'overdue' ? '반납 신청이 완료되었습니다' : '연장 신청이 완료되었습니다'}
                    </h1>
                    <p class="complete-desc">
                        <c:choose>
                            <c:when test="${type == 'overdue'}">
                                연체료 결제가 완료되었고<br>
                                반납 신청이 정상적으로 접수되었습니다.
                            </c:when>
                            <c:otherwise>
                                결제가 정상적으로 처리되었고<br>
                                반납 예정일이 자동으로 연장되었습니다.
                            </c:otherwise>
                        </c:choose>
                        <br>대여 내역은 비회원 조회에서 다시 확인해주세요.
                    </p>

                    <div class="complete-info-box">
                        <div class="complete-info-row">
                            <span>
                                <i class="ri-secure-payment-line"></i>
                                결제 상태
                            </span>
                            <strong>결제 완료</strong>
                        </div>
                        <div class="complete-info-row">
                            <span>
                                <i class="ri-calendar-check-line"></i>
                                처리 결과
                            </span>
                            <strong>${type == 'overdue' ? '반납 접수 완료' : '연장 확정'}</strong>
                        </div>
                    </div>

                    <a href="/rental/extension/main.do?rentalId=${rentalId}&token=${token}" id="completeBtn"
                        class="complete-btn">
                        <i class="ri-file-list-3-line"></i>
                        대여 내역 확인
                    </a>
                </section>

            </main>

            <%@ include file="/WEB-INF/common/footer.jsp" %>
    </body>

    </html>
    <script>
        (function () {
            var btn = document.getElementById('completeBtn');

            var token = sessionStorage.getItem('extGuestToken') || '${token}';
            var orderId = sessionStorage.getItem('extGuestOrderId') || '';
            var rentalId = sessionStorage.getItem('extGuestRentalId') || '${rentalId}';

            if (token && orderId) {
                btn.href = '/rental/extension/main.do?orderId='
                    + encodeURIComponent(orderId)
                    + '&token='
                    + encodeURIComponent(token);
                return;
            }

            if (token && rentalId) {
                btn.href = '/rental/extension/main.do?rentalId='
                    + encodeURIComponent(rentalId)
                    + '&token='
                    + encodeURIComponent(token);
            }
        })();
    </script>