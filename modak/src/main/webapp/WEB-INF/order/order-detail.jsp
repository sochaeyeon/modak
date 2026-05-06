<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>주문 상세 - 모닥모닥</title>

        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/order-detail.css">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app" v-cloak>

                <div class="guest-detail-page" v-if="isLoading">
                    <div class="state-card">
                        <div class="spinner"></div>
                        <p>주문 정보를 불러오는 중입니다.</p>
                    </div>
                </div>

                <div class="guest-detail-page" v-else-if="isError">
                    <div class="state-card">
                        <div class="state-icon">!</div>
                        <p>주문 정보를 불러올 수 없습니다.</p>
                        <a href="/order/history.do" class="outline-link">주문내역으로 돌아가기</a>
                    </div>
                </div>

                <div class="guest-detail-page" v-else-if="order">

                    <section class="detail-hero">
                        <div class="hero-left">
                            <p class="hero-kicker">MEMBER ORDER</p>
                            <h1>주문 상세</h1>
                            <p class="hero-desc">
                                주문번호 <strong>{{ order.orderId }}</strong>
                            </p>
                        </div>

                        <div class="hero-right">
                            <span class="status-badge" :class="'st-' + upperStatus">
                                {{ fnStatusText(order.orderStatus) }}
                            </span>
                            <a href="/order/history.do" class="outline-link">주문내역</a>
                        </div>
                    </section>

                    <section class="flow-card">
                        <div class="flow-head">
                            <p>주문 진행상태</p>
                            <span>{{ orderTypeText }}</span>
                        </div>

                        <div class="status-flow">
                            <div v-for="step in statusSteps" :key="step.code" class="status-step"
                                :class="stepClass(step.code)">
                                <div class="step-dot"></div>
                                <p>{{ step.name }}</p>
                            </div>
                        </div>
                    </section>

                    <main class="detail-layout">

                        <div class="left-col">

                            <section class="detail-card">
                                <div class="card-head">
                                    <div>
                                        <p class="card-kicker">ITEMS</p>
                                        <h2>주문 상품</h2>
                                    </div>
                                    <span class="count-chip">{{ itemList.length }}개</span>
                                </div>

                                <div class="product-list">
                                    <div v-if="itemList.length === 0" class="empty-box">
                                        상품 정보가 없습니다.
                                    </div>

                                    <article v-for="(item, index) in itemList" :key="index" class="product-item"
                                        @click="fnGoProductDetail(item.productId)">

                                        <div class="product-thumb">
                                            <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName"
                                                @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                                            <span :style="item.imgUrl ? 'display:none' : 'display:flex'">
                                                {{ fnItemType(item) === 'RENTAL' ? '⛺' : '🛒' }}
                                            </span>
                                        </div>

                                        <div class="product-info">
                                            <p class="product-name">
                                                {{ item.productName }}
                                                <span v-if="item.optionName" class="product-option-name">
                                                    {{ item.optionName }}
                                                </span>
                                            </p>
                                            <div class="product-meta">
                                                <span class="type-badge"
                                                    :class="fnItemType(item) === 'RENTAL' ? 'badge-rental' : 'badge-purchase'">
                                                    {{ fnItemType(item) === 'RENTAL' ? '대여' : '구매' }}
                                                </span>
                                                <span v-if="item.startDate && item.endDate">
                                                    {{ item.startDate }} ~ {{ item.endDate }}
                                                </span>
                                                <span v-else>{{ item.count || item.quantity || 1 }}개</span>
                                            </div>
                                        </div>

                                        <div class="product-price-box">
                                            <strong>{{ fnPrice(calcItemTotal(item)) }}</strong>

                                            <span v-if="fnItemType(item) === 'RENTAL'">
                                                {{ fnPrice(item.price || item.unitPrice) }}
                                                × {{ calcNights(item.startDate, item.endDate) }}박
                                                <template v-if="Number(item.deposit || 0) > 0">
                                                    + 보증금 {{ fnPrice(item.deposit) }}
                                                </template>
                                            </span>

                                            <span v-else>
                                                {{ item.count || item.quantity || 1 }}개
                                            </span>
                                        </div>
                                    </article>
                                </div>
                            </section>

                            <section class="detail-card">
                                <div class="card-head">
                                    <div>
                                        <p class="card-kicker">DELIVERY</p>
                                        <h2>배송지 정보</h2>
                                    </div>

                                </div>

                                <div class="info-list">
                                    <div class="info-row">
                                        <span>받는분</span>
                                        <strong>{{ order.receiverName || '-' }}</strong>
                                    </div>
                                    <div class="info-row">
                                        <span>연락처</span>
                                        <strong>{{ order.receiverPhone || '-' }}</strong>
                                    </div>
                                    <div class="info-row full">
                                        <span>배송지 주소</span>
                                        <strong>
                                            <template v-if="order.deliveryAddr">
                                                ({{ order.zipcode }}) {{ order.deliveryAddr }} {{
                                                order.deliveryDetailAddr }}
                                            </template>
                                            <template v-else>-</template>
                                        </strong>
                                    </div>
                                </div>
                            </section>

                        </div>

                        <aside class="right-col">

                            <section class="summary-card">
                                <div class="summary-top">
                                    <p>결제 요약</p>
                                    <span>{{ orderTypeText }}</span>
                                </div>

                                <div class="pay-row">
                                    <span>주문 일시</span>
                                    <strong>{{ fnDateTime(order.createdAt) }}</strong>
                                </div>

                                <div class="pay-row">
                                    <span>결제 수단</span>
                                    <template v-if="order.easyPayProvider">
                                        간편결제({{ fnEasyPayText(order.easyPayProvider) }})
                                    </template>
                                    <template v-else>
                                        {{ order.payMethod || 'CARD' }}
                                    </template>
                                </div>

                                <div class="pay-row">
                                    <span>상품 금액</span>
                                    <strong>{{ fnPrice(calcSubTotal) }}</strong>
                                </div>

                                <div class="pay-row">
                                    <span>쿠폰 할인</span>
                                    <strong class="discount">
                                        {{ couponDiscountAmt > 0 ? '- ' + fnPrice(couponDiscountAmt) : '없음' }}
                                    </strong>
                                </div>

                                <div class="pay-row">
                                    <span>포인트 사용</span>
                                    <strong class="discount">
                                        {{ usePoint > 0 ? '- ' + fnPrice(usePoint) : '없음' }}
                                    </strong>
                                </div>

                                <div class="pay-total">
                                    <span>최종 결제 금액</span>
                                    <strong>{{ fnPrice(calcFinalTotal) }}</strong>
                                </div>
                            </section>

                            <section class="action-card">
                                <div class="action-head">
                                    <div>
                                        <p class="card-kicker">ORDER ACTION</p>
                                        <h2>주문 관리</h2>
                                    </div>
                                    <span>{{ fnStatusText(order.orderStatus) }}</span>
                                </div>
                                <p class="action-empty" v-if="upperStatus === 'CANCEL_REQUESTED'">
                                    현재 취소 처리중입니다.<br>
                                    관리자 승인 후 환불이 진행됩니다.
                                </p>

                                <p class="action-empty" v-if="upperStatus === 'CANCELLED'">
                                    주문취소가 완료되었습니다.
                                </p>
                                <div class="action-row delivery-action-row"
                                    v-if="fnHasDeliveryInfo() && upperStatus !== 'CANCEL_REQUESTED' && upperStatus !== 'CANCELLED'">
                                    <button type="button" class="action-btn delivery" @click="fnGoDeliveryDetail">
                                        배송조회
                                    </button>
                                </div>
                                <div class="action-row" v-if="fnCanShowActions()">
                                    <button class="action-btn cancel" v-if="canCancel" @click="openModal('cancel')">
                                        취소신청
                                    </button>

                                    <button class="action-btn exchange" v-if="canAfterDone" @click="fnGoExchange">
                                        교환신청
                                    </button>

                                    <button class="action-btn refund" v-if="canAfterDone" @click="fnGoRefund">
                                        반품/환불신청
                                    </button>
                                </div>

                                <p class="action-empty"
                                    v-if="!fnCanShowActions() && upperStatus !== 'CANCEL_REQUESTED' && upperStatus !== 'CANCELLED'">
                                    현재 상태에서는 추가 신청 가능한 메뉴가 없습니다.
                                </p>

                                <p class="action-note">
                                    결제완료 상태에서는 취소신청, 배송완료 상태에서는 교환신청 및 반품/환불신청이 가능합니다.
                                </p>
                            </section>

                            <section class="rental-link-card" v-if="hasRental">
                                <a href="/rental/extension/main.do">
                                    <div>
                                        <p>대여 연장/조회</p>
                                        <span>대여 기간 확인과 연장 신청을 진행할 수 있습니다.</span>
                                    </div>
                                    <b>→</b>
                                </a>
                            </section>

                        </aside>

                    </main>

                    <div class="modal-overlay" :class="{ open: modalOpen }" @click.self="closeModal">
                        <div class="modal-box">
                            <p class="modal-title">취소신청</p>

                            <p class="modal-desc">
                                주문 취소를 신청하시겠습니까?
                                관리자 확인 후 취소 처리됩니다.
                            </p>

                            <div class="cancel-form">
                                <label class="label">취소 사유 선택</label>
                                <select v-model="cancelReasonCode" class="cancel-select">
                                    <option value="">사유를 선택해주세요.</option>
                                    <option value="CHANGE_MIND">단순 변심</option>
                                    <option value="WRONG_OPTION">옵션 변경</option>
                                    <option value="DELAYED">배송 지연</option>
                                    <option value="ETC">기타</option>
                                </select>

                                <label class="label">상세 사유</label>
                                <textarea v-model="cancelReasonText" class="cancel-textarea"
                                    placeholder="상세 사유를 입력해주세요."></textarea>
                            </div>

                            <div class="modal-btns">
                                <button class="modal-btn cancel" @click="closeModal">닫기</button>
                                <button class="modal-btn confirm" :disabled="!cancelReasonCode" @click="fnSubmitCancel">
                                    취소신청
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- 확인 모달 -->
                    <div class="modal-overlay" :class="{ open: confirmModal.show }"
                        @click.self="confirmModal.show = false">
                        <div class="modal-box">
                            <p class="modal-title">확인</p>
                            <p class="modal-desc" style="white-space:pre-line;">{{ confirmModal.message }}</p>
                            <div class="modal-btns">
                                <button class="modal-btn cancel" @click="confirmModal.show = false">닫기</button>
                                <button class="modal-btn confirm"
                                    @click="confirmModal.onConfirm && confirmModal.onConfirm()">확인</button>
                            </div>
                        </div>
                    </div>

                    <!-- 결과 모달 -->
                    <div class="modal-overlay" :class="{ open: resultModal.show }"
                        @click.self="resultModal.show = false">
                        <div class="modal-box">
                            <p class="modal-title">✅ 완료</p>
                            <p class="modal-desc">{{ resultModal.message }}</p>
                            <div class="modal-btns">
                                <button class="modal-btn confirm" @click="resultModal.show = false">확인</button>
                            </div>
                        </div>
                    </div>

                    <!-- 토스트 -->
                    <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>

                </div>
            </div>

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    const app = Vue.createApp({
                        data: function () {
                            return {
                                orderId: '${orderId}',
                                isLoading: true,
                                isError: false,
                                order: null,
                                modalOpen: false,
                                modalType: '',
                                cancelReasonCode: '',
                                cancelReasonText: '',
                                statusSteps: [],
                                toastVisible: false,
                                toastMsg: '',
                                confirmModal: {
                                    show: false,
                                    message: '',
                                    onConfirm: null
                                },
                                resultModal: {
                                    show: false,
                                    message: ''
                                },

                                normalSteps: [
                                    { code: 'PAID', name: '결제완료' },
                                    { code: 'READY', name: '배송준비' },
                                    { code: 'SHIPPING', name: '배송중' },
                                    { code: 'DONE', name: '배송완료' }
                                ],

                                cancelSteps: [
                                    { code: 'PAID', name: '결제완료' },
                                    { code: 'CANCEL_REQUESTED', name: '취소진행' },
                                    { code: 'CANCELLED', name: '취소완료' }
                                ],

                                refundSteps: [
                                    { code: 'DONE', name: '배송완료' },
                                    { code: 'REFUND_REQUESTED', name: '환불진행' },
                                    { code: 'REFUND_DONE', name: '환불완료' }
                                ],
                                exchangeSteps: [
                                    { code: 'DONE',               name: '배송완료' },
                                    { code: 'EXCHANGE_REQUESTED', name: '교환신청' },
                                    { code: 'EXCHANGE_APPROVED',  name: '교환승인' },
                                    { code: 'EXCHANGE_DONE',      name: '교환완료' }
                                ],
                            };
                        },

                        computed: {
                            itemList: function () {
                                return this.order && this.order.itemList ? this.order.itemList : [];
                            },
                            upperStatus: function () {
                                return this.order && this.order.orderStatus
                                    ? String(this.order.orderStatus).toUpperCase()
                                    : '';
                            },
                            couponDiscountAmt: function () {
                                return Number(this.order && this.order.discountAmt ? this.order.discountAmt : 0);
                            },
                            usePoint: function () {
                                return Number(this.order && this.order.usePoint ? this.order.usePoint : 0);
                            },
                            calcSubTotal: function () {
                                var list = this.itemList;
                                var total = 0;

                                for (var i = 0; i < list.length; i++) {
                                    total += this.calcItemTotal(list[i]);
                                }

                                return total;
                            },
                            calcFinalTotal: function () {
                                if (this.order && this.order.totalPrice) {
                                    return Number(this.order.totalPrice);
                                }
                                return this.calcSubTotal - this.couponDiscountAmt - this.usePoint;
                            },
                            hasRental: function () {
                                for (var i = 0; i < this.itemList.length; i++) {
                                    if (this.fnItemType(this.itemList[i]) === 'RENTAL') return true;
                                }
                                return false;
                            },
                            orderTypeText: function () {
                                return this.hasRental ? '대여 주문' : '구매 주문';
                            },
                            canCancel: function () {
                                return ['PAID', 'READY', 'PAY_COMPLETED'].includes(this.upperStatus);
                            },
                            canAfterDone: function () {
                                return this.upperStatus === 'DONE';
                            }
                        },

                        methods: {
                            fnGetDetail: function () {
                                var self = this;

                                $.ajax({
                                    url: '/order/detail.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        orderId: self.orderId
                                    },
                                    success: function (res) {
                                        self.isLoading = false;

                                        if (res.result === 'success' && res.order) {
                                            self.order = res.order;
                                            self.setStatusSteps();
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
                            showToast(msg) {
                                this.toastMsg = msg;
                                this.toastVisible = true;
                                setTimeout(() => { this.toastVisible = false; }, 2500);
                            },

                            fnItemType: function (item) {
                                return String(item.orderType || this.order.orderType || 'PURCHASE').toUpperCase();
                            },

                            stepClass: function (code) {
                                if (!this.order) return '';

                                var cur = -1;
                                var idx = -1;

                                for (var i = 0; i < this.statusSteps.length; i++) {
                                    if (this.statusSteps[i].code === this.upperStatus) cur = i;
                                    if (this.statusSteps[i].code === code) idx = i;
                                }

                                if (cur === -1) return '';
                                if (idx < cur) return 'done';
                                if (idx === cur) return 'done current';
                                return '';
                            },

                            fnCanShowActions: function () {
                                return this.canCancel || this.canAfterDone;
                            },

                            openModal: function (type) {
                                this.modalType = type;
                                this.modalOpen = true;
                            },

                            closeModal: function () {
                                this.modalOpen = false;
                            },

                            fnSubmitCancel: function () {
                                var self = this;
                                if (!self.cancelReasonCode) return;

                                // ★ confirm 모달로 변경
                                self.confirmModal.message = '주문을 취소 신청하시겠습니까?\n관리자 확인 후 취소 처리됩니다.';
                                self.confirmModal.onConfirm = function () {
                                    self.confirmModal.show = false;

                                    $.ajax({
                                        url: '/order/cancel.dox',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: {
                                            orderId: self.orderId,
                                            cancelReasonCode: self.cancelReasonCode,
                                            cancelReasonText: self.cancelReasonText,
                                            cancelAmount: self.calcFinalTotal
                                        },
                                        success: function (res) {
                                            if (res.result === 'success') {
                                                self.closeModal();
                                                self.order.orderStatus = 'CANCEL_REQUESTED';
                                                self.setStatusSteps();

                                                // ★ alert → 결과 모달
                                                self.resultModal.message = '주문취소 신청이 완료되었습니다.';
                                                self.resultModal.show = true;
                                            } else {
                                                self.showToast(res.message || '취소신청 처리 중 오류가 발생했습니다.');
                                            }
                                        },
                                        error: function () {
                                            self.showToast('서버 오류가 발생했습니다.');
                                        }
                                    });
                                };
                                self.confirmModal.show = true;
                            },

                            fnGoProductDetail: function (id) {
                                if (id) location.href = '/product/detail.do?productId=' + id;
                            },

                            fnGoExchange: function () {
                                location.href = '/order/exchange/request.do?orderId=' + this.orderId;
                            },

                            fnGoRefund: function () {
                                location.href = '/refund/request.do?orderId=' + this.orderId;
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
                                    PAY_COMPLETED: '결제완료',
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

                                return map[String(s || '').toUpperCase()] || s || '-';
                            },
                            fnGoDeliveryDetail: function () {
                                if (!this.order) {
                                    return;
                                }

                                if (this.order.deliveryId) {
                                    location.href = '/user/delivery/detail.do?deliveryId=' + this.order.deliveryId;
                                    return;
                                }

                                location.href = '/user/delivery/detail.do?orderId=' + this.order.orderId;
                            },

                            fnHasDeliveryInfo: function () {
                                return this.order && (this.order.deliveryId || this.order.orderId);
                            },
                            setStatusSteps: function () {
                                var s = this.upperStatus;

                                if (s === 'CANCEL_REQUESTED' || s === 'CANCELLED') {
                                    this.statusSteps = this.cancelSteps;
                                    return;
                                }

                                if (s === 'REFUND_REQUESTED' || s === 'REFUND_APPROVED' || s === 'REFUND_DONE') {
                                    this.statusSteps = this.refundSteps;
                                    return;
                                }

                                 if (s === 'EXCHANGE_REQUESTED' || s === 'EXCHANGE_APPROVED' || s === 'EXCHANGE_DONE') {
                                    this.statusSteps = this.exchangeSteps;
                                    return;
                                }

                                this.statusSteps = this.normalSteps;
                            },
                            calcNights: function (start, end) {
                                if (!start || !end) return 1;

                                var s = new Date(String(start).substring(0, 10) + 'T00:00:00');
                                var e = new Date(String(end).substring(0, 10) + 'T00:00:00');

                                if (isNaN(s.getTime()) || isNaN(e.getTime())) return 1;

                                return Math.max(1, Math.ceil((e - s) / (1000 * 60 * 60 * 24)));
                            },
                            calcNights: function (start, end) {
                                if (!start || !end) return 1;

                                var s = new Date(String(start).substring(0, 10) + 'T00:00:00');
                                var e = new Date(String(end).substring(0, 10) + 'T00:00:00');

                                if (isNaN(s.getTime()) || isNaN(e.getTime())) return 1;

                                return Math.max(1, Math.ceil((e - s) / (1000 * 60 * 60 * 24)));
                            },

                            calcItemTotal: function (item) {
                                var price = Number(item.price || item.unitPrice || 0);
                                var count = Number(item.count || item.quantity || 1);

                                if (this.fnItemType(item) === 'RENTAL') {
                                    var nights = this.calcNights(item.startDate, item.endDate);
                                    var deposit = Number(item.deposit || 0);
                                    return (price * nights + deposit) * count;
                                }

                                return price * count;
                            },
                            fnEasyPayText: function (provider) {
                                var map = {
                                    KAKAOPAY: '카카오페이',
                                    NAVERPAY: '네이버페이',
                                    TOSSPAY: '토스페이',
                                    PAYCO: '페이코',
                                    SAMSUNGPAY: '삼성페이',
                                    LPAY: '엘페이'
                                };

                                return map[String(provider || '').toUpperCase()] || provider;
                            },
                        },

                        mounted: function () {
                            this.fnGetDetail();
                        }
                    });

                    app.mount('#app');
                </script>

    </body>

    </html>