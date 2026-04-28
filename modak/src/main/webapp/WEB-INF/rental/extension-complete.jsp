<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>연장 완료 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/rental/extension-complete.css">
    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div class="complete-wrap">
                <div class="complete-card">
                    <div class="complete-icon">✅</div>
                    <div class="complete-title">연장 신청이 완료되었습니다!</div>
                    <div class="complete-desc">
                        결제가 정상적으로 처리되었고<br>
                        반납 예정일이 자동으로 연장되었습니다.
                    </div>

                    <a href="/rental/extension/main.do?rentalId=${rentalId}&token=${token}" class="complete-btn">
                        대여 내역 확인
                    </a>
                </div>
            </div>

            <%@ include file="/WEB-INF/common/footer.jsp" %>
    </body>

    </html>