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
            <link rel="stylesheet" href="/css/order/guest-order-list.css">

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
                                <div class="field">
                                    <label>이름</label>
                                    <input v-model="form.name" placeholder="주문 시 입력한 이름">
                                </div>
                            </div>

                            <div class="field">
                                <label>휴대폰 번호</label>
                                <div class="input-row">
                                    <input v-model="form.phone" placeholder="01012345678" maxlength="11"
                                        @input="form.phone = form.phone.replace(/\D/g,'')" @keyup.enter="fnSendSms">
                                    <button class="btn-primary" :disabled="smsSent && smsTimeLeft > 0"
                                        @click="fnSendSms">
                                        {{ smsSent && smsTimeLeft > 0 ? '발송됨' : smsSent ? '재발송' : '인증번호 받기' }}
                                    </button>
                                </div>
                            </div>

                            <div v-if="smsSent">
                                <div class="field" style="margin-top:12px;">
                                    <label>인증번호</label>
                                    <div class="input-row">
                                        <input v-model="form.authCode" placeholder="6자리 입력" maxlength="6"
                                            @keyup.enter="fnVerify">
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

                                <div v-for="order in orderList" :key="order.ORDER_ID" class="order-item"
                                    @click="fnGoDetail(order)">
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
                                    smsSent: false,
                                    smsTimeLeft: 0,
                                    smsTimer: null,
                                    verified: false,
                                    orderList: [],
                                    toastVisible: false,
                                    isSendingSms: false,
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
                                    if (this.isSendingSms) return;  // ★ 중복 방지

                                    if (!this.form.name.trim()) { this.showToast('이름을 입력해주세요.'); return; }
                                    if (!this.form.phone.trim()) { this.showToast('휴대폰 번호를 입력해주세요.'); return; }

                                    this.isSendingSms = true;  // ★ 발송 시작

                                    $.ajax({
                                        url: '/user/sms/send-code.dox', type: 'POST',
                                        data: {
                                            userName: this.form.name,
                                            userPhone: this.form.phone,
                                            authPurpose: 'GUEST_ORDER'
                                        },
                                        success: (res) => {
                                            this.isSendingSms = false;  // ★ 완료 후 해제
                                            if (res.result === 'success') {
                                                this.smsSent = true;
                                                this.form.authCode = '';
                                                this.fnStartTimer();
                                                this.showToast('인증번호가 발송되었습니다.');
                                            } else {
                                                this.showToast(res.message || '발송 실패');
                                            }
                                        },
                                        error: () => {
                                            this.isSendingSms = false;  // ★ 에러 시에도 해제
                                            this.showToast('서버 오류가 발생했습니다.');
                                        }
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
                                    if (this.smsTimeLeft === 0) { this.showToast('인증번호가 만료되었습니다. 재발송해주세요.'); return; }

                                    $.ajax({
                                        url: '/order/guest/verify.dox', type: 'POST',
                                        data: {
                                            guestPhone: this.form.phone,
                                            guestName: this.form.name,
                                            authCode: this.form.authCode
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
                                        + '&token=' + encodeURIComponent(order.GUEST_TOKEN || '');
                                },

                                fnReset() {
                                    this.verified = false;
                                    this.smsSent = false;
                                    this.smsTimeLeft = 0;
                                    this.orderList = [];
                                    this.form = { name: '', phone: '', authCode: '' };
                                    clearInterval(this.smsTimer);
                                },

                                fnStatusText(s) {
                                    const map = {
                                        PAID: '결제완료',
                                        READY: '배송준비',
                                        SHIPPING: '배송중',
                                        DONE: '배송완료',
                                        IN_USE: '대여중',
                                        CANCELLED: '취소완료',
                                        RETURNED: '반납완료',
                                        RETURN_REQUESTED: '반납요청',
                                        CANCEL_REQUESTED: '취소신청',      // ★
                                        EXCHANGE_REQUESTED: '교환신청',      // ★
                                        EXCHANGE_APPROVED: '교환승인',      // ★
                                        EXCHANGE_DONE: '교환완료',      // ★
                                        REFUND_REQUESTED: '반품신청',      // ★
                                        REFUND_APPROVED: '반품승인',      // ★
                                        REFUND_DONE: '반품완료'       // ★
                                    };
                                    return map[s] || s || '-';
                                },

                                fnFormatDate(dt) {
                                    if (!dt) return '';
                                    return String(dt).slice(0, 10);
                                },

                                showToast(msg) {
                                    this.toastMsg = msg;
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