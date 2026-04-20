<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비회원 주문조회 - 모닥모닥</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Noto+Sans+KR:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/guestOrderInquiry.css?v=1.0">
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="page-wrap">
    <div class="inquiry-card">

        <div class="card-icon">📦</div>
        <p class="card-eyebrow">GUEST ORDER</p>
        <h1 class="card-title">비회원 주문조회</h1>
        <p class="card-desc">주문 시 입력하신 정보로<br>주문 내역을 확인하실 수 있습니다.</p>
        <div class="divider"></div>

        <div class="form-group">
            <label class="form-label" for="orderId">주문번호 <span class="req">*</span></label>
            <input type="text" id="orderId" class="form-input"
                   placeholder="주문번호를 입력해주세요" maxlength="30">
            <span class="err-msg" id="errOrderId">주문번호를 입력해주세요.</span>
        </div>

        <div class="form-group">
            <label class="form-label" for="guestName">주문자 이름 <span class="req">*</span></label>
            <input type="text" id="guestName" class="form-input"
                   placeholder="이름을 입력해주세요" maxlength="20">
            <span class="err-msg" id="errGuestName">이름을 입력해주세요.</span>
        </div>

        <div class="form-group">
            <label class="form-label" for="guestPhone">전화번호 <span class="req">*</span></label>
            <input type="tel" id="guestPhone" class="form-input"
                   placeholder="숫자만 입력해주세요 (예: 01012345678)" maxlength="11">
            <span class="err-msg" id="errGuestPhone">올바른 전화번호를 입력해주세요.</span>
        </div>

        <div class="alert-box" id="alertBox">
            입력하신 정보와 일치하는 주문을 찾을 수 없습니다.<br>
            주문번호, 이름, 전화번호를 다시 확인해주세요.
        </div>

        <button class="btn-submit" id="btnSubmit" onclick="fnSubmit()">
            <span class="btn-text">주문 조회하기</span>
            <span class="spinner"></span>
        </button>

        <div class="info-box">
            <p>주문번호는 주문 완료 시 발송된 SMS 또는 이메일에서 확인하실 수 있습니다.</p>
        </div>

        <div class="card-footer">
            회원이신가요? <a href="/user/login.do">로그인하기</a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    /* 입력 이벤트: 전화번호 숫자만 강제 */
    $(document).on('input', '#guestPhone', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    /* 유효성 검사 함수 */
    function validate() {
        let valid = true;
        const orderId    = $('#orderId').val().trim();
        const guestName  = $('#guestName').val().trim();
        const guestPhone = $('#guestPhone').val().trim();

        // 주문번호 체크
        if (!orderId) {
            $('#orderId').addClass('is-error'); $('#errOrderId').addClass('show'); valid = false;
        } else {
            $('#orderId').removeClass('is-error'); $('#errOrderId').removeClass('show');
        }

        // 이름 체크
        if (!guestName) {
            $('#guestName').addClass('is-error'); $('#errGuestName').addClass('show'); valid = false;
        } else {
            $('#guestName').removeClass('is-error'); $('#errGuestName').removeClass('show');
        }

        // 전화번호 체크 (숫자 10~11자리 확인)
        if (!guestPhone || !/^0[0-9]{9,10}$/.test(guestPhone)) {
            $('#guestPhone').addClass('is-error'); $('#errGuestPhone').addClass('show'); valid = false;
        } else {
            $('#guestPhone').removeClass('is-error'); $('#errGuestPhone').removeClass('show');
        }

        return valid;
    }

    /* 조회 실행 */
    function fnSubmit() {
        $('#alertBox').removeClass('show');
        if (!validate()) return;

        const btn = $('#btnSubmit');
        btn.addClass('loading').prop('disabled', true);

        $.ajax({
            url     : '/order/guest/inquiry.dox',
            type    : 'POST',
            dataType: 'json',
            data: {
                orderId   : $('#orderId').val().trim(),
                guestName : $('#guestName').val().trim(),
                guestPhone: $('#guestPhone').val().trim()
            },
            success: function(res) {
                btn.removeClass('loading').prop('disabled', false);
                if (res.result === 'success') {
                    // 성공 시 상세 페이지로 이동 (쿼리스트링 전달)
                    location.href = '/order/guest/detail.do'
                        + '?orderId=' + encodeURIComponent(res.orderId)
                        + '&token='   + encodeURIComponent(res.token);
                } else {
                    $('#alertBox').addClass('show');
                }
            },
            error: function() {
                btn.removeClass('loading').prop('disabled', false);
                $('#alertBox').addClass('show');
            }
        });
    }

    /* 엔터 키 지원 */
    $(document).on('keydown', function(e) {
        if (e.key === 'Enter') fnSubmit();
    });
</script>
</body>
</html>