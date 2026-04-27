<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 완료</title>
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>
    <div style="text-align:center; padding: 80px 20px;">
        <h2>✅ 결제가 완료되었습니다!</h2>
        <p>주문번호: <strong>${orderId}</strong></p>
        <a href="/order/history.do">주문 내역 보기</a>
    </div>
    <%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>