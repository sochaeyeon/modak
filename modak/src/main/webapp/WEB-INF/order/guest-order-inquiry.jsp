<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>비회원 주문조회 - 모닥모닥</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Noto+Sans+KR:wght@300;400;500;600&display=swap"
            rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <link rel="stylesheet" href="/css/order/guest-inquiry.css">

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

                    <!-- 주문번호 -->
                    <div class="form-group">
                        <label class="form-label" for="orderId">주문번호 <span class="req">*</span></label>
                        <input type="text" id="orderId" class="form-input" placeholder="주문번호를 입력해주세요" maxlength="30">
                        <span class="err-msg" id="errOrderId">주문번호를 입력해주세요.</span>
                    </div>

                    <!-- 이름 -->
                    <div class="form-group">
                        <label class="form-label" for="guestName">주문자 이름 <span class="req">*</span></label>
                        <input type="text" id="guestName" class="form-input" placeholder="이름을 입력해주세요" maxlength="20">
                        <span class="err-msg" id="errGuestName">이름을 입력해주세요.</span>
                    </div>

                    <!-- 전화번호 -->
                    <div class="form-group">
                        <label class="form-label" for="guestPhone">전화번호 <span class="req">*</span></label>
                        <input type="tel" id="guestPhone" class="form-input" placeholder="숫자만 입력해주세요 (예: 01012345678)"
                            maxlength="11">
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

                    <div class="signup-promo">
                        <p class="promo-text">
                            아직 <strong>모닥모닥</strong> 회원이 아니신가요?<br>
                            회원가입 시 쿠폰 혜택과 간편한 주문 관리가 가능합니다.
                        </p>
                        <a href="/user/login.do" class="btn-signup-link">
                            🔥 3초만에 회원가입하고 혜택받기
                        </a>
                    </div>

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
                    /* 전화번호 숫자만 */
                    document.getElementById('guestPhone').addEventListener('input', function () {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    });

                    function validate() {
                        let valid = true;
                        const orderId = $('#orderId').val().trim();
                        const guestName = $('#guestName').val().trim();
                        const guestPhone = $('#guestPhone').val().trim();

                        if (!orderId) {
                            $('#orderId').addClass('is-error'); $('#errOrderId').addClass('show'); valid = false;
                        } else {
                            $('#orderId').removeClass('is-error'); $('#errOrderId').removeClass('show');
                        }

                        if (!guestName) {
                            $('#guestName').addClass('is-error'); $('#errGuestName').addClass('show'); valid = false;
                        } else {
                            $('#guestName').removeClass('is-error'); $('#errGuestName').removeClass('show');
                        }

                        if (!guestPhone || !/^0[0-9]{9,10}$/.test(guestPhone)) {
                            $('#guestPhone').addClass('is-error'); $('#errGuestPhone').addClass('show'); valid = false;
                        } else {
                            $('#guestPhone').removeClass('is-error'); $('#errGuestPhone').removeClass('show');
                        }

                        return valid;
                    }

                    function fnSubmit() {
                        $('#alertBox').removeClass('show');
                        if (!validate()) return;

                        const btn = $('#btnSubmit');
                        btn.addClass('loading').prop('disabled', true);

                        $.ajax({
                            url: '/order/guest/inquiry.dox',
                            type: 'POST',
                            dataType: 'json',
                            data: {
                                orderId: $('#orderId').val().trim(),
                                guestName: $('#guestName').val().trim(),
                                guestPhone: $('#guestPhone').val().trim()
                            },
                            success: function (res) {
                                btn.removeClass('loading').prop('disabled', false);
                                if (res.result === 'success') {
                                    location.href = '/order/guest/detail.do'
                                        + '?orderId=' + encodeURIComponent(res.orderId)
                                        + '&token=' + encodeURIComponent(res.token);
                                } else {
                                    $('#alertBox').addClass('show');
                                }
                            },
                            error: function () {
                                btn.removeClass('loading').prop('disabled', false);
                                $('#alertBox').addClass('show');
                            }
                        });
                    }

                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Enter') fnSubmit();
                    });
                </script>
    </body>

    </html>