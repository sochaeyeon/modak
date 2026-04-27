<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 실패</title>
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>
    <div style="text-align:center; padding: 80px 20px;">
        <h2>❌ 결제에 실패했습니다</h2>
        <p>${message}</p>
        <a href="javascript:history.back()">다시 시도하기</a>
    </div>
    <%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>