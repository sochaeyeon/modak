<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>비회원 주문상세 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/guest-detail.css">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>

        </style>
    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app">

                <!-- 로딩 -->
                <div class="detail-page" v-if="isLoading">
                    <div class="state-box">
                        <div class="spinner"></div>
                        <p>주문 정보를 불러오는 중입니다...</p>
                    </div>
                </div>

                <!-- 에러 -->
                <div class="detail-page" v-else-if="isError">
                    <div class="state-box">
                        <div style="font-size:48px">📭</div>
                        <p>주문 정보를 불러올 수 없습니다.<br>다시 조회해주세요.</p>
                        <a href="/order/guest/inquiry.do" class="btn-back" style="margin-top:8px">← 주문조회로 돌아가기</a>
                    </div>
                </div>

                <!-- 정상 -->
                <div class="detail-page" v-else-if="order">

                    <!-- 헤더 -->
                    <div class="page-header">
                        <div>
                            <p class="page-eyebrow">GUEST ORDER DETAIL</p>
                            <h1 class="page-title">주문 상세</h1>
                            <p class="page-order-id">주문번호 <strong>{{ order.orderId }}</strong></p>
                        </div>
                        <a href="/order/guest/inquiry.do" class="btn-back">← 다시 조회하기</a>
                    </div>

                    <!-- 주문 현황 스텝바 -->
                    <div class="section-card">
                        <div class="section-head">
                            <h3>주문 현황</h3>
                            <span class="status-badge" :class="'st-' + order.orderStatus">
                                {{ fnStatusText(order.orderStatus) }}
                            </span>
                        </div>
                        <div class="status-flow">
                            <div v-for="(step, i) in statusSteps" :key="i" class="status-step"
                                :class="stepClass(step.code)">
                                <div class="step-circle">{{ step.icon }}</div>
                                <div class="step-name">{{ step.name }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 주문 정보 -->
                    <div class="section-card">
                        <div class="section-head">
                            <h3>주문 정보</h3>
                        </div>
                        <div class="section-body">
                            <div class="info-grid">
                                <div>
                                    <p class="info-label">주문 일시</p>
                                    <p class="info-value">{{ fnDateTime(order.createdAt) }}</p>
                                </div>
                                <div>
                                    <p class="info-label">주문 유형</p>
                                    <p class="info-value">{{ order.orderType === 'PURCHASE' ? '구매' : '대여' }}</p>
                                </div>
                                <div class="info-divider"></div>
                                <div>
                                    <p class="info-label">상품 금액</p>
                                    <p class="info-value">{{ fnPrice(order.totalPrice + (order.discountAmt || 0)) }}</p>
                                </div>
                                <div>
                                    <p class="info-label">할인 금액</p>
                                    <p class="info-value" style="color:var(--orange2)">
                                        {{ order.discountAmt > 0 ? '- ' + fnPrice(order.discountAmt) : '없음' }}
                                    </p>
                                </div>
                                <div class="info-divider"></div>
                                <div style="grid-column: 1 / -1">
                                    <p class="info-label">최종 결제 금액</p>
                                    <p class="info-value price">{{ fnPrice(order.totalPrice) }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 주문 상품 -->
                    <div class="section-card">
                        <div class="section-head">
                            <h3>주문 상품</h3>
                            <span style="font-size:12px;color:var(--brown4)">
                                {{ order.items ? order.items.length : 0 }}개 상품
                            </span>
                        </div>
                        <div class="section-body">
                            <div class="product-list">
                                <div v-if="!order.items || order.items.length === 0"
                                    style="text-align:center;padding:24px;color:var(--brown4);font-size:13px">
                                    상품 정보가 없습니다.
                                </div>
                                <div v-for="item in order.items" :key="item.itemId" class="product-item">
                                    <div class="product-thumb">
                                        <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName"
                                            style="width:100%;height:100%;object-fit:cover;border-radius:12px;display:block;"
                                            @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                                        <span :style="item.imgUrl ? 'display:none' : 'display:flex'"
                                            style="width:100%;height:100%;align-items:center;justify-content:center;font-size:28px;">
                                            {{ order.orderType === 'RENTAL' ? '⛺' : '🛒' }}
                                        </span>
                                    </div>
                                    <div class="product-info">
                                        <p class="product-name">{{ item.productName }}</p>
                                        <div class="product-meta">
                                            <span class="type-badge"
                                                :class="order.orderType === 'PURCHASE' ? 'badge-purchase' : 'badge-rental'">
                                                {{ order.orderType === 'PURCHASE' ? '구매' : '대여' }}
                                            </span>
                                            <span v-if="item.startDate && item.endDate">
                                                {{ item.startDate }} ~ {{ item.endDate }}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="product-price-wrap">
                                        <p class="product-price">{{ fnPrice(item.unitPrice) }}</p>
                                        <p class="product-qty">{{ item.quantity }}개</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 배송 조회 -->
                    <div class="section-card">
                        <div class="section-head">
                            <h3>배송 조회</h3>
                        </div>

                        <!-- 배송 준비 전 -->
                        <div class="no-tracking" v-if="!order.delivery || !order.delivery.deliveryId ||
                       order.orderStatus === 'PAID' || order.orderStatus === 'READY'">
                            📦 아직 배송이 시작되지 않았습니다.<br>
                            <span style="font-size:12px">배송 준비가 완료되면 운송장 번호가 등록됩니다.</span>
                        </div>

                        <!-- 취소 -->
                        <div class="no-tracking" v-else-if="order.orderStatus === 'CANCELLED'">
                            취소 / 반품 처리된 주문입니다.
                        </div>

                        <!-- 배송 이력 -->
                        <div v-else class="section-body" style="padding: 0 24px">
                            <div class="track-list">
                                <div v-if="!trackHistory || trackHistory.length === 0" class="no-tracking">
                                    배송 조회 정보가 없습니다.
                                </div>
                                <div v-for="(t, i) in trackHistory" :key="i" class="track-item"
                                    :class="{ 'is-current': i === 0 }">
                                    <div class="track-dot-col">
                                        <div class="track-dot"></div>
                                        <div class="track-line" v-if="i < trackHistory.length - 1"></div>
                                    </div>
                                    <div class="track-body">
                                        <p class="track-status">{{ t.status }}</p>
                                        <p class="track-desc">{{ t.location }}</p>
                                    </div>
                                    <p class="track-time">{{ t.time }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- 운송장 번호 바 -->
                        <div class="delivery-info-bar" v-if="order.delivery && order.delivery.trackingNo">
                            <span>🚚 운송장번호</span>
                            <strong>{{ order.delivery.trackingNo }}</strong>
                            <span style="color:var(--brown4)">배송사 문의 시 사용</span>
                        </div>
                    </div>

                    <!-- 배송지 정보 -->
                    <div class="section-card"
                        v-if="order.delivery && order.delivery.deliveryId && order.delivery.receiverName">
                        <div class="section-head">
                            <h3>배송지 정보</h3>
                        </div>
                        <div class="section-body">
                            <div class="receiver-grid">
                                <div>
                                    <p class="info-label">수령인</p>
                                    <p class="info-value">{{ order.delivery.receiverName }}</p>
                                </div>
                                <div>
                                    <p class="info-label">출고 일시</p>
                                    <p class="info-value">{{ fnDateTime(order.delivery.shippedAt) }}</p>
                                </div>
                                <div style="grid-column: 1 / -1">
                                    <p class="info-label">배송지 주소</p>
                                    <p class="info-value">{{ order.delivery.address || '-' }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 취소/반품 -->
                    <div class="action-section"
                         v-if="order.orderStatus !== 'CANCELLED'">
                        <p class="action-title">주문 관리</p>
                        <div class="action-row">
                            <button class="btn-cancel"
                                v-if="order.orderStatus === 'PAID' || order.orderStatus === 'READY'"
                                @click="openModal('cancel')">
                                주문 취소 신청
                            </button>
                            <button class="btn-return"
                                v-if="order.orderStatus === 'DONE' && order.orderType === 'PURCHASE'"
                                @click="fnGoExchange">
                                교환 신청
                            </button>
                            <button class="btn-return" v-if="order.orderStatus === 'SHIPPING'"
                                @click="openModal('return')">
                                반품 신청
                            </button>
                        </div>
                        <p class="action-notice">
                            · 취소는 배송 준비 전까지 가능합니다.<br>
                            · 반품은 배송중 상태에서 신청 가능합니다.<br>
                            · 대여 상품은 대여 시작 24시간 전까지 취소 가능합니다.
                        </p>
                    </div>

                    <!-- 이미 취소 -->
                    <div class="action-section" v-if="order.orderStatus === 'CANCELLED'"
                        style="text-align:center;color:var(--brown4)">
                        <p style="font-size:14px">이미 취소 / 반품 처리된 주문입니다.</p>
                    </div>

                </div><!-- /detail-page -->

                <!-- 모달 -->
                <div class="modal-overlay" :class="{ open: modalOpen }" @click.self="closeModal">
                    <div class="modal-box">
                        <div class="modal-icon">{{ modalType === 'cancel' ? '🗑️' : '↩️' }}</div>
                        <p class="modal-title">{{ modalType === 'cancel' ? '주문 취소' : '반품 신청' }}</p>
                        <p class="modal-desc">
                            {{ modalType === 'cancel'
                            ? '주문을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.'
                            : '반품을 신청하시겠습니까?\n담당자 확인 후 처리됩니다.' }}
                        </p>
                        <div class="modal-btns">
                            <button class="modal-btn-no" @click="closeModal">아니요</button>
                            <button class="modal-btn-yes" @click="fnConfirm">
                                {{ modalType === 'cancel' ? '취소하기' : '반품신청' }}
                            </button>
                        </div>
                    </div>
                </div>

            </div><!-- /#app -->

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    var app = Vue.createApp({
                        data: function () {
                            return {
                                isLoading: true,
                                isError: false,
                                order: null,
                                trackHistory: [],
                                modalOpen: false,
                                modalType: '',
                                statusSteps: [
                                    { code: 'PAID', name: '결제완료', icon: '💳' },
                                    { code: 'READY', name: '배송준비', icon: '📦' },
                                    { code: 'SHIPPING', name: '배송중', icon: '🚚' },
                                    { code: 'DONE', name: '배송완료', icon: '✔' }
                                ]
                            };
                        },

                        methods: {
                            /* ── 데이터 로드 ── */
                            fnLoad: function () {
                                var self = this;
                                var p = new URLSearchParams(location.search);
                                var orderId = p.get('orderId');
                                var token = p.get('token');

                                if (!orderId || !token) {
                                    self.isLoading = false;
                                    self.isError = true;
                                    return;
                                }

                                $.ajax({
                                    url: '/order/guest/detail.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: { orderId: orderId, token: token },
                                    success: function (res) {
                                        self.isLoading = false;
                                        if (res.result === 'success' && res.order) {
                                            self.order = res.order;
                                            self.trackHistory = res.trackingList || [];
                                        } else {
                                            self.isError = true;
                                        }
                                    },
                                    error: function () {
                                        self.isLoading = false;
                                        self.isError = true;
                                    }
                                });
                            },
                            // methods 에 추가
                            fnGoExchange: function () {
                                var p = new URLSearchParams(location.search);
                                location.href = '/order/guest/exchange.do'
                                    + '?orderId=' + p.get('orderId')
                                    + '&token=' + p.get('token');
                            },
                            /* ── 스텝 클래스 ── */
                            stepClass: function (code) {
                                var steps = this.statusSteps;
                                var cur = -1;
                                var idx = -1;
                                for (var i = 0; i < steps.length; i++) {
                                    if (steps[i].code === this.order.orderStatus) cur = i;
                                    if (steps[i].code === code) idx = i;
                                }
                                if (idx < cur) return 'done';
                                if (idx === cur) return 'done current';
                                return '';
                            },

                            /* ── 모달 ── */
                            openModal: function (type) { this.modalType = type; this.modalOpen = true; },
                            closeModal: function () { this.modalOpen = false; },

                            /* ── 취소/반품 실행 ── */
                            fnConfirm: function () {
                                var self = this;
                                var url = self.modalType === 'cancel' ? '/order/guest/cancel.dox' : '/order/guest/return.dox';
                                var token = new URLSearchParams(location.search).get('token');

                                $.ajax({
                                    url: url,
                                    type: 'POST',
                                    dataType: 'json',
                                    data: { orderId: self.order.orderId, token: token },
                                    success: function (res) {
                                        self.closeModal();
                                        if (res.result === 'success') {
                                            alert(self.modalType === 'cancel'
                                                ? '주문이 취소되었습니다.'
                                                : '반품 신청이 완료되었습니다.');
                                            self.order.orderStatus = 'CANCELLED';
                                        } else {
                                            alert(res.message || '처리 중 오류가 발생했습니다.');
                                        }
                                    },
                                    error: function () {
                                        self.closeModal();
                                        alert('서버 오류가 발생했습니다.');
                                    }
                                });
                            },

                            /* ── 날짜 포맷 (템플릿 리터럴 제거 — JSP EL 충돌 방지) ── */
                            fnDateTime: function (v) {
                                if (!v) return '-';
                                var d = new Date(String(v).replace(' ', 'T'));
                                if (isNaN(d.getTime())) return String(v);
                                var pad = function (n) { return String(n).padStart(2, '0'); };
                                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                                    + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
                            },

                            /* ── 가격 포맷 ── */
                            fnPrice: function (v) {
                                return Number(v || 0).toLocaleString() + '원';
                            },

                            /* ── 상태 텍스트 ── */
                            fnStatusText: function (s) {
                                var map = {
                                    PAID: '결제완료',
                                    READY: '배송준비',
                                    SHIPPING: '배송중',
                                    DONE: '배송완료',
                                    CANCELLED: '취소/반품'
                                };
                                return map[s] || s || '-';
                            }
                        },

                        mounted: function () {
                            this.fnLoad();
                        }
                    });

                    app.mount('#app');
                </script>
    </body>

    </html>