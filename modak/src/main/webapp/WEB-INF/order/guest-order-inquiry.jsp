<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>비회원 주문조회 - 모닥모닥</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="/css/order/guest-inquiry.css">
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">

    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div class="guest-inquiry-page">

                <section class="inquiry-hero">
                    <p class="hero-kicker">GUEST ORDER</p>
                    <h1>비회원 주문조회</h1>
                    <p class="hero-desc">
                        주문 시 입력한 정보로 주문 내역을 확인할 수 있습니다.
                    </p>
                </section>

                <section class="inquiry-card-new">

                    <div class="form-grid">

                        <div class="form-group">
                            <label>주문번호</label>
                            <input type="text" id="orderId" placeholder="주문번호 입력">
                            <span class="err-msg" id="errOrderId">주문번호를 입력해주세요.</span>
                        </div>

                        <div class="form-group">
                            <label>주문자 이름</label>
                            <input type="text" id="guestName" placeholder="이름 입력">
                            <span class="err-msg" id="errGuestName">이름을 입력해주세요.</span>
                        </div>

                        <div class="form-group">
                            <label>전화번호</label>
                            <input type="tel" id="guestPhone" placeholder="01012345678">
                            <span class="err-msg" id="errGuestPhone">올바른 번호 입력</span>
                        </div>

                    </div>

                    <div class="alert-box" id="alertBox">
                        입력 정보와 일치하는 주문이 없습니다.
                    </div>

                    <button class="btn-submit" id="btnSubmit" onclick="fnSubmit()">
                        주문 조회하기
                    </button>
                    <a href="/order/guest/orders.do" class="btn-guest-all">
                        <i class="ri-file-list-3-line"></i>
                        <span>전체 주문내역 조회하기</span>
                        <em>SMS 인증 필요</em>
                    </a>
                    <div class="signup-promo">
                        <div class="coupon-badge">신규가입 혜택</div>

                        <p class="promo-text">
                            지금 가입하면 <strong>3,000원 쿠폰</strong> 지급!
                        </p>

                        <p class="promo-sub">
                            회원은 주문내역을 더 간편하게 확인할 수 있어요.
                        </p>

                        <a href="/user/sign-up.do" class="btn-signup-link">
                            회원가입하고 쿠폰 받기
                        </a>
                    </div>
                </section>

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