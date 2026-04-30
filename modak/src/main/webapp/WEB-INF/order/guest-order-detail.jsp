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
    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app">

                <!-- 로딩 -->
                <div class="guest-detail-page" v-if="isLoading">
                    <div class="state-card">
                        <div class="spinner"></div>
                        <p>주문 정보를 불러오는 중입니다.</p>
                    </div>
                </div>

                <!-- 에러 -->
                <div class="guest-detail-page" v-else-if="isError">
                    <div class="state-card">
                        <div class="state-icon">!</div>
                        <p>주문 정보를 불러올 수 없습니다.<br>다시 조회해주세요.</p>
                        <a href="/order/guest/inquiry.do" class="outline-link">주문조회로 돌아가기</a>
                    </div>
                </div>

                <!-- 정상 -->
                <div class="guest-detail-page" v-else-if="order">

                    <!-- 상단 요약 -->
                    <section class="detail-hero">
                        <div class="hero-left">
                            <p class="hero-kicker">GUEST ORDER</p>
                            <h1>비회원 주문상세</h1>
                            <p class="hero-desc">
                                주문번호 <strong>{{ order.orderId }}</strong>
                            </p>
                        </div>

                        <div class="hero-right">
                            <span class="status-badge" :class="'st-' + order.orderStatus">
                                {{ fnStatusText(order.orderStatus) }}
                            </span>
                            <a href="/order/guest/inquiry.do" class="outline-link">다시 조회하기</a>
                        </div>
                    </section>

                    <!-- 상태 흐름 -->
                    <section class="flow-card">
                        <div class="flow-head">
                            <p>주문 진행상태</p>
                            <span>{{ order.orderType === 'PURCHASE' ? '구매 주문' : '대여 주문' }}</span>
                        </div>

                        <div class="status-flow">
                            <div v-for="step in statusSteps" :key="step.code" class="status-step"
                                :class="stepClass(step.code)">
                                <div class="step-dot"></div>
                                <p>{{ step.name }}</p>
                            </div>
                        </div>
                    </section>

                    <!-- 메인 2단 -->
                    <main class="detail-layout">

                        <!-- 왼쪽 -->
                        <div class="left-col">

                            <!-- 주문 상품 -->
                            <section class="detail-card">
                                <div class="card-head">
                                    <div>
                                        <p class="card-kicker">ITEMS</p>
                                        <h2>주문 상품</h2>
                                    </div>
                                    <span class="count-chip">{{ order.items ? order.items.length : 0 }}개</span>
                                </div>

                                <div class="product-list">
                                    <div v-if="!order.items || order.items.length === 0" class="empty-box">
                                        상품 정보가 없습니다.
                                    </div>

                                    <article v-for="item in order.items" :key="item.itemId" class="product-item"
                                        @click="fnGoProduct(item.productId)">
                                        <div class="product-thumb">
                                            <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName"
                                                @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                                            <span :style="item.imgUrl ? 'display:none' : 'display:flex'">
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

                                        <div class="product-price-box">
                                            <strong>{{ fnPrice(item.unitPrice) }}</strong>
                                            <span>{{ item.quantity }}개</span>
                                        </div>
                                    </article>
                                </div>
                            </section>

                            <!-- 배송지 정보 -->
                            <section class="detail-card"
                                v-if="order.delivery && order.delivery.deliveryId && order.delivery.receiverName">
                                <div class="card-head">
                                    <div>
                                        <p class="card-kicker">DELIVERY</p>
                                        <h2>배송지 정보</h2>
                                    </div>

                                    <a class="outline-link" v-if="order.delivery && order.delivery.deliveryId"
                                        :href="fnDeliveryUrl()">
                                        배송조회
                                    </a>
                                </div>

                                <div class="info-list">
                                    <div class="info-row">
                                        <span>수령인</span>
                                        <strong>{{ order.delivery.receiverName }}</strong>
                                    </div>
                                    <div class="info-row">
                                        <span>출고 일시</span>
                                        <strong>{{ fnDateTime(order.delivery.shippedAt) }}</strong>
                                    </div>
                                    <div class="info-row full">
                                        <span>배송지 주소</span>
                                        <strong>{{ order.delivery.address || '-' }}</strong>
                                    </div>
                                </div>
                            </section>

                        </div>

                        <!-- 오른쪽 -->
                        <aside class="right-col">

                            <!-- 결제 요약 -->
                            <section class="summary-card">
                                <div class="summary-top">
                                    <p>결제 요약</p>
                                    <span>{{ order.orderType === 'PURCHASE' ? '구매' : '대여' }}</span>
                                </div>

                                <div class="pay-row">
                                    <span>주문 일시</span>
                                    <strong>{{ fnDateTime(order.createdAt) }}</strong>
                                </div>
                                <div class="pay-row">
                                    <span>상품 금액</span>
                                    <strong>{{ fnPrice(order.totalPrice + (order.discountAmt || 0)) }}</strong>
                                </div>
                                <div class="pay-row">
                                    <span>할인 금액</span>
                                    <strong class="discount">
                                        {{ order.discountAmt > 0 ? '- ' + fnPrice(order.discountAmt) : '없음' }}
                                    </strong>
                                </div>

                                <div class="pay-total">
                                    <span>최종 결제 금액</span>
                                    <strong>{{ fnPrice(order.totalPrice) }}</strong>
                                </div>
                            </section>

                            <!-- 주문 관리 -->
                            <section class="action-card">
                                <div class="action-head">
                                    <div>
                                        <p class="card-kicker">ORDER ACTION</p>
                                        <h2>주문 관리</h2>
                                    </div>
                                    <span>{{ fnStatusText(order.orderStatus) }}</span>
                                </div>

                                <div class="action-row" v-if="fnCanShowActions()">
                                    <button class="action-btn cancel" v-if="order.orderStatus === 'PAID'"
                                        @click="openModal('cancel')">
                                        취소신청
                                    </button>

                                    <button class="action-btn exchange" v-if="order.orderStatus === 'DONE'"
                                        @click="fnGoExchange">
                                        교환신청
                                    </button>

                                    <button class="action-btn refund" v-if="order.orderStatus === 'DONE'"
                                        @click="fnGoRefund">
                                        반품/환불신청
                                    </button>
                                </div>

                                <p class="action-empty" v-if="!fnCanShowActions()">
                                    현재 상태에서는 추가 신청 가능한 메뉴가 없습니다.
                                </p>

                                <p class="action-note">
                                    결제완료 상태에서는 취소신청, 배송완료 상태에서는 교환신청 및 반품/환불신청이 가능합니다.
                                </p>
                            </section>

                            <!-- 대여 연장 -->
                            <section class="rental-link-card" v-if="order.orderType === 'RENTAL'">
                                <a :href="fnRentalManageUrl()">
                                    <div>
                                        <p>대여 연장 / 반납 신청</p>
                                        <span>이 주문의 대여 상품을 선택해 연장 또는 반납 신청할 수 있습니다.</span>
                                    </div>
                                    <b>→</b>
                                </a>
                            </section>
                        </aside>

                    </main>
                    <!-- 모달 -->
                    <div class="modal-overlay" :class="{ open: modalOpen }" @click.self="closeModal">
                        <div class="modal-box">
                            <p class="modal-title">{{ fnModalTitle() }}</p>
                            <p class="modal-desc">{{ fnModalDesc() }}</p>

                            <div class="modal-btns">
                                <button class="modal-btn cancel" @click="closeModal">닫기</button>
                                <button class="modal-btn confirm" @click="fnConfirm">
                                    {{ fnModalConfirmText() }}
                                </button>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

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
                                    { code: 'PAID', name: '결제완료' },
                                    { code: 'READY', name: '배송준비' },
                                    { code: 'SHIPPING', name: '배송중' },
                                    { code: 'DONE', name: '배송완료' }
                                ]
                            };
                        },

                        methods: {
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

                            fnGoExchange: function () {
                                var p = new URLSearchParams(location.search);
                                location.href = '/order/guest/exchange.do'
                                    + '?orderId=' + p.get('orderId')
                                    + '&token=' + p.get('token');
                            },

                            fnGoRefund: function () {
                                var p = new URLSearchParams(location.search);
                                location.href = '/refund/request.do'
                                    + '?orderId=' + p.get('orderId')
                                    + '&token=' + p.get('token');
                            },

                            stepClass: function (code) {
                                if (!this.order) return '';

                                var steps = this.statusSteps;
                                var cur = -1;
                                var idx = -1;

                                for (var i = 0; i < steps.length; i++) {
                                    if (steps[i].code === this.order.orderStatus) cur = i;
                                    if (steps[i].code === code) idx = i;
                                }

                                if (cur === -1) return '';
                                if (idx < cur) return 'done';
                                if (idx === cur) return 'done current';
                                return '';
                            },

                            openModal: function (type) {
                                this.modalType = type;
                                this.modalOpen = true;
                            },

                            closeModal: function () {
                                this.modalOpen = false;
                            },

                            fnConfirm: function () {
                                var self = this;
                                var token = new URLSearchParams(location.search).get('token');

                                var urlMap = {
                                    cancel: '/order/guest/cancel.dox'
                                };

                                var nextStatusMap = {
                                    cancel: 'CANCEL_REQUESTED'
                                };

                                $.ajax({
                                    url: urlMap[self.modalType],
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        orderId: self.order.orderId,
                                        token: token
                                    },
                                    success: function (res) {
                                        self.closeModal();

                                        if (res.result === 'success') {
                                            self.order.orderStatus = nextStatusMap[self.modalType];
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

                            fnDateTime: function (v) {
                                if (!v) return '-';

                                var d = new Date(String(v).replace(' ', 'T'));
                                if (isNaN(d.getTime())) return String(v);

                                var pad = function (n) {
                                    return String(n).padStart(2, '0');
                                };

                                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                                    + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
                            },

                            fnPrice: function (v) {
                                return Number(v || 0).toLocaleString() + '원';
                            },

                            fnStatusText: function (s) {
                                var map = {
                                    PAID: '결제완료',
                                    READY: '배송준비',
                                    SHIPPING: '배송중',
                                    DONE: '배송완료',
                                    IN_USE: '대여중',

                                    CANCEL_REQUESTED: '취소신청',
                                    CANCELLED: '취소완료',

                                    EXCHANGE_REQUESTED: '교환신청',
                                    EXCHANGE_APPROVED: '교환승인',
                                    EXCHANGE_DONE: '교환완료',

                                    REFUND_REQUESTED: '반품/환불신청',
                                    REFUND_APPROVED: '반품/환불승인',
                                    REFUND_DONE: '반품/환불완료',

                                    RETURN_REQUESTED: '반납신청',
                                    RETURNED: '반납완료'
                                };

                                return map[s] || s || '-';
                            },

                            fnCanShowActions: function () {
                                if (!this.order) return false;

                                var s = this.order.orderStatus;
                                return s === 'PAID' || s === 'DONE';
                            },

                            fnModalTitle: function () {
                                if (this.modalType === 'cancel') return '취소신청';
                                return '주문 처리';
                            },

                            fnModalDesc: function () {
                                if (this.modalType === 'cancel') {
                                    return '주문 취소를 신청하시겠습니까?\n관리자 확인 후 취소 처리됩니다.';
                                }
                                return '처리하시겠습니까?';
                            },

                            fnModalConfirmText: function () {
                                if (this.modalType === 'cancel') return '취소신청';
                                return '확인';
                            },
                            fnGoProduct: function (productId) {
                                location.href = '/product/detail.do?productId=' + productId;
                            },
                            fnRentalManageUrl: function () {
                                var p = new URLSearchParams(location.search);

                                return '/rental/extension/main.do'
                                    + '?orderId=' + encodeURIComponent(this.order.orderId)
                                    + '&token=' + encodeURIComponent(p.get('token'));
                            },
                            fnDeliveryUrl: function () {
                                var p = new URLSearchParams(location.search);

                                return '/delivery/tracking.do'
                                    + '?orderId=' + this.order.orderId
                                    + '&token=' + p.get('token');
                            },
						},	

                        mounted: function () {
                            this.fnLoad();
                        }
                    });

                    app.mount('#app');
                </script>

    </body>

    </html>