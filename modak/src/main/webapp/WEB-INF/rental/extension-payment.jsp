<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>연장 결제 - 모닥모닥</title>

    <link rel="stylesheet" href="/css/common/font.css">
    <link rel="stylesheet" href="/css/rental/extension-payment.css">
    <script src="https://js.tosspayments.com/v1/payment"></script>
</head>

<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="pay-wrap">
    <div class="pay-card">

        <div class="pay-badge">⛺ 대여 연장 결제</div>

        <h1 class="pay-title">연장 결제를 진행해주세요</h1>
        <p class="pay-desc">
            결제 완료 후 반납 예정일이 자동으로 연장됩니다.
        </p>

        <div class="pay-product">
            <div class="pay-product-img">
                <img src="${imgUrl}" alt="${productName}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <span>⛺</span>
            </div>
            <div class="pay-product-info">
                <div class="pay-product-label">연장 상품</div>
                <div class="pay-product-name">${productName}</div>
            </div>
        </div>

        <div class="pay-info-box">

            <div class="pay-row">
                <span>연장 일수</span>
                <strong>${days}일</strong>
            </div>

            <div class="pay-row">
                <span>주문 번호</span>
                <strong>ext-${extensionOrderId}</strong>
            </div>

            <div class="pay-total">
                <span>최종 결제 금액</span>
                <strong class="js-amount">${amount}</strong>
            </div>

        </div>

        <button type="button" id="pay-btn" class="pay-btn">
            <span class="js-amount">${amount}</span> 결제하기
        </button>

        <div class="pay-notice">
            · 테스트 결제 환경입니다.<br>
            · 결제 성공 시 연장 신청이 확정됩니다.<br>
            · 결제 중 창을 닫으면 연장 처리가 완료되지 않을 수 있습니다.
        </div>

        <a href="/rental/extension/main.do" class="pay-back">
            ← 대여 연장 페이지로 돌아가기
        </a>

    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
(function () {
    const clientKey = '${tossClientKey}';
    const extensionOrderId = '${extensionOrderId}';
    const amount = Number('${amount}');
    const days = '${days}';
    const token = '${token}';
    const productName = '${productName}';

    const orderId = 'ext-' + String(extensionOrderId).padStart(10, '0');
    const payBtn = document.getElementById('pay-btn');

    document.querySelectorAll('.js-amount').forEach(function (el) {
        el.textContent = Number(el.textContent || 0).toLocaleString() + '원';
    });

    if (!clientKey || clientKey === 'null') {
        alert('토스 clientKey가 없습니다.');
        payBtn.disabled = true;
        return;
    }

    if (!amount || amount <= 0) {
        alert('결제 금액이 올바르지 않습니다.');
        payBtn.disabled = true;
        return;
    }

    const tossPayments = TossPayments(clientKey);

    payBtn.addEventListener('click', function () {
        payBtn.disabled = true;
        payBtn.textContent = '결제창을 여는 중...';

        tossPayments.requestPayment('카드', {
            amount: amount,
            orderId: orderId,
            orderName: '대여 연장 - ' + productName + ' ' + days + '일',
            customerName: '모닥모닥 고객',
            successUrl: location.origin + '/rental/extension/payment/success.do?token=' + encodeURIComponent(token),
            failUrl: location.origin + '/rental/extension/payment/fail.do'
        }).catch(function (error) {
            console.error(error);
            alert(error.message || '결제 요청 실패');

            payBtn.disabled = false;
            payBtn.innerHTML = '<span class="js-amount">' + amount.toLocaleString() + '원</span> 결제하기';
        });
    });
})();
</script>

</body>
</html>