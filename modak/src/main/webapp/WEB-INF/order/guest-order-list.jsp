<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비회원 주문내역 - 모닥모닥</title>
    <link rel="stylesheet" href="/css/common/font.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        :root {
            --cream:#F6F0E6; --cream2:#EDE5D4;
            --orange:#E8732A; --orange2:#C4621E;
            --brown:#2C1E0F; --brown2:#5C4230; --brown3:#8B6B4A; --brown4:#B89A7A;
            --white:#FFFDF8; --border:rgba(44,30,15,.12);
            --green:#2e7d32; --blue:#2f6fd8; --amber:#9B6A00; --red:#C94F1E;
        }
        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
        body { background:var(--cream); color:var(--brown); font-family:'Apple SD Gothic Neo',sans-serif; min-height:100vh; }
        [v-cloak] { display:none; }

        .page-wrap { max-width:720px; margin:0 auto; padding:48px 24px 80px; }

        /* 페이지 헤더 */
        .page-kicker { font-size:11px; letter-spacing:2px; color:var(--orange2); font-weight:800; margin-bottom:8px; }
        .page-title  { font-size:28px; font-weight:900; color:var(--brown); margin-bottom:6px; letter-spacing:-.02em; }
        .page-sub    { font-size:13px; color:var(--brown3); margin-bottom:32px; font-weight:600; }

        /* 카드 공통 */
        .card {
            background:var(--white); border:1.5px solid var(--border);
            border-radius:20px; padding:28px; margin-bottom:16px;
        }
        .card-title { font-size:15px; font-weight:800; color:var(--brown); margin-bottom:20px; }

        /* 폼 필드 */
        .field { margin-bottom:14px; }
        .field label {
            display:block; font-size:11.5px; font-weight:800;
            color:var(--brown3); letter-spacing:.04em; margin-bottom:7px;
        }
        .field input {
            width:100%; padding:12px 14px; border:1.5px solid var(--border);
            border-radius:11px; font-size:14px; color:var(--brown);
            font-family:inherit; outline:none; background:var(--white);
            transition:border-color .18s, box-shadow .18s;
        }
        .field input:focus {
            border-color:var(--orange);
            box-shadow:0 0 0 3px rgba(232,115,42,.1);
        }
        .input-row { display:flex; gap:8px; }
        .input-row input { flex:1; }

        /* 버튼 */
        .btn-primary {
            height:46px; padding:0 24px; border:none; border-radius:11px;
            background:var(--orange); color:#fff; font-size:13px; font-weight:800;
            cursor:pointer; transition:background .18s; white-space:nowrap;
            font-family:inherit;
        }
        .btn-primary:hover { background:var(--orange2); }
        .btn-primary:disabled { opacity:.5; cursor:not-allowed; }
        .btn-outline {
            height:36px; padding:0 16px; border:1.5px solid var(--border);
            border-radius:10px; background:var(--white); color:var(--brown3);
            font-size:12px; font-weight:700; cursor:pointer; font-family:inherit;
            transition:all .18s;
        }
        .btn-outline:hover { border-color:var(--orange); color:var(--orange2); }

        /* 타이머 */
        .timer-text { font-size:12px; color:var(--orange); font-weight:700; margin-top:6px; }
        .timer-expired { font-size:12px; color:var(--red); font-weight:700; margin-top:6px; }

        /* 인증 완료 */
        .verify-ok {
            padding:10px 14px; border-radius:10px;
            background:rgba(46,125,50,.08); color:var(--green);
            font-size:13px; font-weight:700; margin-top:8px;
            border:1px solid rgba(46,125,50,.2);
        }

        /* 주문 목록 헤더 */
        .list-header {
            display:flex; align-items:center; justify-content:space-between;
            margin-bottom:16px;
        }
        .list-header-left .list-title { font-size:18px; font-weight:800; color:var(--brown); }
        .list-header-left .list-count { font-size:12px; color:var(--brown3); margin-top:2px; }

        /* 주문 아이템 */
        .order-item {
            display:flex; align-items:center; gap:16px;
            padding:18px 0; border-bottom:1px solid var(--border);
            cursor:pointer; border-radius:8px;
            transition:background .15s, padding .15s;
        }
        .order-item:last-child { border-bottom:none; }
        .order-item:hover { background:rgba(232,115,42,.04); padding-left:8px; }
        .order-icon {
            width:54px; height:54px; border-radius:12px; flex-shrink:0;
            background:var(--cream2); display:flex; align-items:center;
            justify-content:center; font-size:24px;
            border:1px solid var(--border);
        }
        .order-info { flex:1; min-width:0; }
        .order-name {
            font-size:14px; font-weight:700; color:var(--brown); margin-bottom:5px;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        .order-meta { font-size:12px; color:var(--brown3); display:flex; gap:6px; flex-wrap:wrap; }
        .order-meta .dot { color:var(--brown4); }
        .order-side { text-align:right; flex-shrink:0; }
        .order-price { font-size:15px; font-weight:800; color:var(--brown); }
        .order-badge {
            display:inline-block; margin-top:5px; padding:3px 10px;
            border-radius:999px; font-size:11px; font-weight:800;
        }
        .st-PAID           { background:rgba(232,115,42,.12); color:var(--orange2); }
        .st-READY          { background:#FFF8EA; color:var(--amber); }
        .st-SHIPPING       { background:#EEF5FF; color:var(--blue); }
        .st-DONE           { background:#EFF8F0; color:var(--green); }
        .st-IN_USE         { background:#EFF8F0; color:var(--green); }
        .st-CANCELLED      { background:#FFF1ED; color:var(--red); }
        .st-RETURNED       { background:#EFF8F0; color:var(--green); }
        .st-RETURN_REQUESTED { background:#FFF8EA; color:var(--amber); }
        .st-CANCEL_REQUESTED { background:#FFF1ED; color:var(--red); }

        /* 빈 목록 */
        .empty-state {
            padding:56px 20px; text-align:center;
            color:var(--brown3); font-size:13px; font-weight:600;
        }
        .empty-emoji { font-size:52px; margin-bottom:14px; }

        /* 구분선 */
        .divider {
            height:1px; background:var(--border); margin:16px 0;
        }

        /* 기존 조회 링크 */
        .back-link {
            display:block; text-align:center; margin-top:16px;
            font-size:13px; color:var(--brown3); font-weight:600;
        }
        .back-link a { color:var(--orange); text-decoration:none; font-weight:700; }
        .back-link a:hover { text-decoration:underline; }
		/* guest-order-list.jsp style 태그 안에 추가 */
		.st-CANCEL_REQUESTED   { background:rgba(232,115,42,.12); color:var(--orange2); }
		.st-EXCHANGE_REQUESTED { background:#FFF8EA; color:var(--amber); }
		.st-EXCHANGE_APPROVED  { background:#EEF5FF; color:var(--blue); }
		.st-EXCHANGE_DONE      { background:#EFF8F0; color:var(--green); }
		.st-REFUND_REQUESTED   { background:#FFF1ED; color:var(--red); }
		.st-REFUND_APPROVED    { background:#EEF5FF; color:var(--blue); }
		.st-REFUND_DONE        { background:#EFF8F0; color:var(--green); }

        /* 토스트 */
        .toast {
            position:fixed; left:50%; bottom:32px;
            transform:translateX(-50%) translateY(20px);
            padding:12px 22px; border-radius:999px;
            background:var(--brown); color:var(--white);
            font-size:13px; opacity:0; pointer-events:none;
            transition:.25s ease; z-index:9999;
        }
        .toast.show { opacity:1; transform:translateX(-50%) translateY(0); }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
<div class="page-wrap">

    <p class="page-kicker">GUEST ORDER</p>
    <div class="page-title">비회원 주문내역</div>
    <div class="page-sub">휴대폰 인증 후 모든 주문내역을 한 번에 확인하세요.</div>

    <!-- ── STEP 1: 인증 ── -->
    <div class="card" v-if="!verified">
        <div class="card-title">📱 본인 확인</div>

        <div class="field">
            <label>이름</label>
            <input v-model="form.name" placeholder="주문 시 입력한 이름"
                   @keyup.enter="fnSendSms">
        </div>

        <div class="field">
            <label>휴대폰 번호</label>
            <div class="input-row">
                <input v-model="form.phone" placeholder="01012345678" maxlength="11"
                       @input="form.phone = form.phone.replace(/\D/g,'')"
                       @keyup.enter="fnSendSms">
                <button class="btn-primary"
                        :disabled="smsSent && smsTimeLeft > 0"
                        @click="fnSendSms">
                    {{ smsSent && smsTimeLeft > 0 ? '발송됨' : smsSent ? '재발송' : '인증번호 받기' }}
                </button>
            </div>
        </div>

        <div v-if="smsSent">
            <div class="field" style="margin-top:12px;">
                <label>인증번호</label>
                <div class="input-row">
                    <input v-model="form.authCode" placeholder="6자리 입력"
                           maxlength="6" @keyup.enter="fnVerify">
                    <button class="btn-primary" @click="fnVerify"
                            :disabled="smsTimeLeft === 0">확인</button>
                </div>
                <div class="timer-text" v-if="smsTimeLeft > 0">
                    남은 시간 {{ formattedTime }}
                </div>
                <div class="timer-expired" v-if="smsTimeLeft === 0 && smsSent">
                    인증번호가 만료되었습니다. 재발송해주세요.
                </div>
            </div>
        </div>

        <div class="divider"></div>
        <div class="back-link">
            주문번호로 바로 조회하려면 →
            <a href="/order/guest/inquiry.do">개별 주문조회</a>
        </div>
    </div>

    <!-- ── STEP 2: 주문 목록 ── -->
    <div v-if="verified">
        <div class="list-header">
            <div class="list-header-left">
                <div class="list-title">{{ form.name }}님의 주문내역</div>
                <div class="list-count">총 {{ orderList.length }}건</div>
            </div>
            <button class="btn-outline" @click="fnReset">다른 번호로 조회</button>
        </div>

        <div class="card">
            <div v-if="orderList.length === 0" class="empty-state">
                <div class="empty-emoji">📭</div>
                <div>주문내역이 없습니다.</div>
            </div>

            <div v-for="order in orderList" :key="order.ORDER_ID"
                 class="order-item" @click="fnGoDetail(order)">
				 <!-- 기존 -->
				 <div class="order-icon">
				     {{ order.ORDER_TYPE === 'RENTAL' ? '⛺' : '🛒' }}
				 </div>

				 <!-- 변경 -->
				 <div class="order-icon" style="overflow:hidden;padding:0;">
				     <img v-if="order.thumbUrl" :src="order.thumbUrl"
				          style="width:100%;height:100%;object-fit:cover;border-radius:12px;">
				     <span v-else style="font-size:24px;">
				         {{ order.ORDER_TYPE === 'RENTAL' ? '⛺' : '🛒' }}
				     </span>
				 </div>
                <div class="order-info">
                    <div class="order-name">
                        {{ order.firstProductName || '상품명 없음' }}
                        <span v-if="order.itemCount > 1"
                              style="color:var(--brown3);font-weight:500;font-size:13px;">
                            외 {{ Number(order.itemCount) - 1 }}건
                        </span>
                    </div>
                    <div class="order-meta">
                        <span>주문번호 {{ order.ORDER_ID }}</span>
                        <span class="dot">·</span>
                        <span>{{ fnFormatDate(order.CREATED_AT) }}</span>
                        <span class="dot">·</span>
                        <span>{{ order.ORDER_TYPE === 'RENTAL' ? '대여' : '구매' }}</span>
                    </div>
                </div>
                <div class="order-side">
                    <div class="order-price">
                        {{ Number(order.TOTAL_PRICE || 0).toLocaleString() }}원
                    </div>
                    <div class="order-badge" :class="'st-' + order.ORDER_STATUS">
                        {{ fnStatusText(order.ORDER_STATUS) }}
                    </div>
                </div>
            </div>
        </div>

        <div class="back-link">
            주문번호로 바로 조회 →
            <a href="/order/guest/inquiry.do">개별 주문조회</a>
        </div>
    </div>

</div>

<div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            form: { name: '', phone: '', authCode: '' },
            smsSent:   false,
            smsTimeLeft: 0,
            smsTimer:  null,
            verified:  false,
            orderList: [],
            toastVisible: false,
            toastMsg: ''
        };
    },
    computed: {
        formattedTime() {
            const m = Math.floor(this.smsTimeLeft / 60);
            const s = this.smsTimeLeft % 60;
            return m + ':' + String(s).padStart(2, '0');
        }
    },
    methods: {
        fnSendSms() {
            if (!this.form.name.trim())  { this.showToast('이름을 입력해주세요.');         return; }
            if (!this.form.phone.trim()) { this.showToast('휴대폰 번호를 입력해주세요.'); return; }

            $.ajax({
                url: '/user/sms/send-code.dox', type: 'POST',
                data: {
                    userName:    this.form.name,
                    userPhone:   this.form.phone,
                    authPurpose: 'GUEST_ORDER'
                },
                success: (res) => {
                    if (res.result === 'success') {
                        this.smsSent = true;
                        this.form.authCode = '';
                        this.fnStartTimer();
                        this.showToast('인증번호가 발송되었습니다.');
                    } else {
                        this.showToast(res.message || '발송 실패');
                    }
                },
                error: () => this.showToast('서버 오류가 발생했습니다.')
            });
        },

        fnStartTimer() {
            clearInterval(this.smsTimer);
            this.smsTimeLeft = 180;
            this.smsTimer = setInterval(() => {
                if (this.smsTimeLeft > 0) this.smsTimeLeft--;
                else clearInterval(this.smsTimer);
            }, 1000);
        },

        fnVerify() {
            if (!this.form.authCode.trim()) { this.showToast('인증번호를 입력해주세요.'); return; }
            if (this.smsTimeLeft === 0)     { this.showToast('인증번호가 만료되었습니다. 재발송해주세요.'); return; }

            $.ajax({
                url: '/order/guest/verify.dox', type: 'POST',
                data: {
                    guestPhone: this.form.phone,
                    guestName:  this.form.name,
                    authCode:   this.form.authCode
                },
                success: (res) => {
                    if (res.result === 'success') {
                        this.verified = true;
                        clearInterval(this.smsTimer);
                        this.fnLoadOrders();
                    } else {
                        this.showToast(res.message || '인증 실패');
                    }
                },
                error: () => this.showToast('서버 오류가 발생했습니다.')
            });
        },

        fnLoadOrders() {
            $.ajax({
                url: '/order/guest/list.dox', type: 'POST',
                data: { guestPhone: this.form.phone, guestName: this.form.name },
                success: (res) => {
                    if (res.result === 'success') {
                        this.orderList = res.list || [];
                    } else {
                        this.showToast(res.message || '조회 실패');
                    }
                },
                error: () => this.showToast('서버 오류가 발생했습니다.')
            });
        },

        fnGoDetail(order) {
            location.href = '/order/guest/detail.do'
                + '?orderId=' + order.ORDER_ID
                + '&token='   + encodeURIComponent(order.GUEST_TOKEN || '');
        },

        fnReset() {
            this.verified  = false;
            this.smsSent   = false;
            this.smsTimeLeft = 0;
            this.orderList = [];
            this.form      = { name: '', phone: '', authCode: '' };
            clearInterval(this.smsTimer);
        },

		fnStatusText(s) {
		    const map = {
		        PAID:               '결제완료',
		        READY:              '배송준비',
		        SHIPPING:           '배송중',
		        DONE:               '배송완료',
		        IN_USE:             '대여중',
		        CANCELLED:          '취소완료',
		        RETURNED:           '반납완료',
		        RETURN_REQUESTED:   '반납요청',
		        CANCEL_REQUESTED:   '취소신청',      // ★
		        EXCHANGE_REQUESTED: '교환신청',      // ★
		        EXCHANGE_APPROVED:  '교환승인',      // ★
		        EXCHANGE_DONE:      '교환완료',      // ★
		        REFUND_REQUESTED:   '반품신청',      // ★
		        REFUND_APPROVED:    '반품승인',      // ★
		        REFUND_DONE:        '반품완료'       // ★
		    };
		    return map[s] || s || '-';
		},

        fnFormatDate(dt) {
            if (!dt) return '';
            return String(dt).slice(0, 10);
        },

        showToast(msg) {
            this.toastMsg     = msg;
            this.toastVisible = true;
            setTimeout(() => { this.toastVisible = false; }, 2500);
        }
    },
    beforeUnmount() {
        clearInterval(this.smsTimer);
    }
}).mount('#app');
</script>
</body>
</html>
