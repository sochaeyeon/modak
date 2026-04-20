<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비회원 대여 연장 조회 - 모닥모닥</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Noto+Sans+KR:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg:      #faf6f0;
            --white:   #fffdf8;
            --border:  rgba(200,165,130,.45);
            --border2: rgba(200,165,130,.22);
            --orange:  #E8732A;
            --orange2: #C4621E;
            --brown:   #2C1E0F;
            --brown2:  #5C4230;
            --brown3:  #8B6B4A;
            --brown4:  #B89A7A;
            --cream2:  #EDE5D4;
            --cream3:  #E2D8C3;
            --error:   #c94f1e;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex; flex-direction: column;
            color: var(--brown);
        }
        .page-wrap {
            flex: 1; display: flex;
            align-items: center; justify-content: center;
            padding: 60px 20px;
        }
        .inquiry-card {
            width: 100%; max-width: 480px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 48px 44px 44px;
            box-shadow: 0 8px 40px rgba(44,30,15,.08);
            animation: fadeUp .5s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .card-icon {
            width: 64px; height: 64px;
            background: rgba(232,115,42,.1);
            border: 1.5px solid rgba(232,115,42,.25);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 28px; margin: 0 auto 24px;
        }
        .card-eyebrow { text-align: center; font-size: 11px; letter-spacing: 2px; color: var(--brown4); margin-bottom: 8px; }
        .card-title   { font-family: 'Nanum Myeongjo', serif; font-size: 24px; font-weight: 800; color: var(--brown); text-align: center; margin-bottom: 8px; }
        .card-desc    { font-size: 13px; color: var(--brown3); text-align: center; line-height: 1.7; margin-bottom: 36px; }
        .divider      { height: 1px; background: var(--border2); margin-bottom: 28px; }

        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 18px; }
        .form-label { font-size: 12px; font-weight: 600; color: var(--brown2); }
        .form-label .req { color: var(--orange); margin-left: 2px; }
        .form-input {
            width: 100%; padding: 13px 16px;
            border: 1.5px solid var(--border); border-radius: 12px;
            background: var(--white);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 14px; color: var(--brown); outline: none;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-input::placeholder { color: var(--brown4); font-weight: 300; }
        .form-input:focus { border-color: var(--orange); box-shadow: 0 0 0 3px rgba(232,115,42,.1); }
        .form-input.is-error { border-color: var(--error); }
        .err-msg { font-size: 12px; color: var(--error); display: none; margin-top: 2px; }
        .err-msg.show { display: block; }

        .alert-box {
            background: rgba(201,79,30,.07); border: 1px solid rgba(201,79,30,.25);
            border-radius: 10px; padding: 13px 16px;
            font-size: 13px; color: var(--error);
            margin-top: 20px; display: none; line-height: 1.6;
        }
        .alert-box.show { display: block; }

        .btn-submit {
            width: 100%; margin-top: 28px; padding: 15px;
            background: var(--orange); color: #fff;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 15px; font-weight: 600;
            border: none; border-radius: 14px; cursor: pointer;
            transition: background .2s, transform .15s;
            box-shadow: 0 4px 18px rgba(232,115,42,.3);
        }
        .btn-submit:hover    { background: var(--orange2); transform: translateY(-1px); }
        .btn-submit:disabled { opacity: .65; cursor: not-allowed; transform: none; }
        .btn-submit .spinner {
            display: none; width: 16px; height: 16px;
            border: 2px solid rgba(255,255,255,.4);
            border-top-color: #fff; border-radius: 50%;
            animation: spin .7s linear infinite; margin: 0 auto;
        }
        .btn-submit.loading .btn-text { display: none; }
        .btn-submit.loading .spinner  { display: inline-block; }
        @keyframes spin { to { transform: rotate(360deg); } }

        .info-box {
            background: var(--cream2); border: 1px solid var(--cream3);
            border-radius: 12px; padding: 14px 16px; margin-top: 24px;
        }
        .info-box p { font-size: 12px; color: var(--brown3); line-height: 1.8; font-weight: 300; }

        .card-footer { margin-top: 24px; text-align: center; font-size: 12px; color: var(--brown4); }
        .card-footer a { color: var(--orange); font-weight: 600; text-decoration: none; }
        .card-footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="page-wrap">
    <div class="inquiry-card">
        <div class="card-icon">⛺</div>
        <p class="card-eyebrow">RENTAL EXTENSION</p>
        <h1 class="card-title">비회원 대여 연장</h1>
        <p class="card-desc">대여 시 입력하신 정보로<br>연장 신청 내역을 확인하실 수 있습니다.</p>
        <div class="divider"></div>

        <!-- 대여번호 -->
        <div class="form-group">
            <label class="form-label" for="rentalId">대여번호 <span class="req">*</span></label>
            <input type="number" id="rentalId" class="form-input"
                   placeholder="대여번호를 입력해주세요">
            <span class="err-msg" id="errRentalId">대여번호를 입력해주세요.</span>
        </div>

        <!-- 이름 -->
        <div class="form-group">
            <label class="form-label" for="guestName">이름 <span class="req">*</span></label>
            <input type="text" id="guestName" class="form-input"
                   placeholder="이름을 입력해주세요" maxlength="20">
            <span class="err-msg" id="errGuestName">이름을 입력해주세요.</span>
        </div>

        <!-- 전화번호 -->
        <div class="form-group">
            <label class="form-label" for="guestPhone">전화번호 <span class="req">*</span></label>
            <input type="tel" id="guestPhone" class="form-input"
                   placeholder="숫자만 입력해주세요 (예: 01012345678)" maxlength="11">
            <span class="err-msg" id="errGuestPhone">올바른 전화번호를 입력해주세요.</span>
        </div>

        <div class="alert-box" id="alertBox">
            입력하신 정보와 일치하는 대여 내역을 찾을 수 없습니다.<br>
            대여번호, 이름, 전화번호를 다시 확인해주세요.
        </div>

        <button class="btn-submit" id="btnSubmit" onclick="fnSubmit()">
            <span class="btn-text">연장 내역 조회하기</span>
            <span class="spinner"></span>
        </button>

        <div class="info-box">
            <p>대여번호는 대여 완료 시 발송된 SMS 또는 이메일에서 확인하실 수 있습니다.</p>
        </div>

        <div class="card-footer">
            회원이신가요? <a href="/user/login.do">로그인하기</a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    document.getElementById('guestPhone').addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    function validate() {
        var valid      = true;
        var rentalId   = $('#rentalId').val().trim();
        var guestName  = $('#guestName').val().trim();
        var guestPhone = $('#guestPhone').val().trim();

        if (!rentalId) {
            $('#rentalId').addClass('is-error'); $('#errRentalId').addClass('show'); valid = false;
        } else {
            $('#rentalId').removeClass('is-error'); $('#errRentalId').removeClass('show');
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

        var btn = $('#btnSubmit');
        btn.addClass('loading').prop('disabled', true);

        $.ajax({
            url     : '/rental/extension/guest/inquiry.dox',
            type    : 'POST',
            dataType: 'json',
            data: {
                rentalId  : $('#rentalId').val().trim(),
                guestName : $('#guestName').val().trim(),
                guestPhone: $('#guestPhone').val().trim()
            },
            success: function(res) {
                btn.removeClass('loading').prop('disabled', false);
                if (res.result === 'success') {
                    location.href = '/rental/extension/main.do'
                        + '?rentalId=' + encodeURIComponent(res.rentalId)
                        + '&token='    + encodeURIComponent(res.token);
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

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') fnSubmit();
    });
</script>
</body>
</html>
