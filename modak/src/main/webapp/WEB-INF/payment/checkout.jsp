<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 결제</title>
    <link rel="stylesheet" href="/css/payment/payment.css">
    <link rel="stylesheet" href="/css/search/search.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://js.tosspayments.com/v1"></script> <!-- 토스 스크립트 -->
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>
<div id="app" v-cloak>

    <!-- 브레드크럼 -->
    <div class="breadcrumb">
        <span class="bc-done">장바구니</span>
        <span class="bc-arrow">›</span>
        <span class="bc-cur">주문/결제</span>
        <span class="bc-arrow">›</span>
        <span class="bc-next">완료</span>
    </div>

    <div class="checkout-wrap">
        <div class="checkout-layout">

            <!-- ══════════ 좌측 메인 ══════════ -->
            <div class="checkout-main">

                <!-- ── 배송지 ── -->
                <section class="co-section">
                    <div class="co-section-title">배송지</div>

                    <div class="addr-name">
                        {{ addrForm.receiverName || addrForm.addressAlias || '배송지' }}
                        <span class="addr-default-badge" v-if="addrForm.defaultYn === 'Y'">기본배송지</span>
                    </div>

                    <div class="addr-phone">{{ addrForm.receiverPhone || '연락처 없음' }}</div>

                    <div class="addr-full">
                        [{{ addrForm.zipcode }}] {{ addrForm.address }} {{ addrForm.detailedAddress }}
                    </div>

                    <button class="addr-change-btn" @click="addrModal.open = true">변경</button>

                    <!-- 배송 메모 -->
                    <select class="delivery-memo-select" v-model="deliveryMemo">
                        <option value="">배송메모를 선택해주세요</option>
                        <option>문 앞에 놓아주세요</option>
                        <option>경비실에 맡겨주세요</option>
                        <option>벨 누르지 말아주세요</option>
                        <option>직접 입력</option>
                    </select>
                    <input v-if="deliveryMemo === '직접 입력'" class="delivery-memo-input"
                        v-model="deliveryMemoCustom" placeholder="배송 메모를 입력해주세요">
                </section>

                <!-- ── 주문 상품 ── -->
                <section class="co-section">
                    <div class="co-section-title">주문상품</div>
                    <div v-if="orderItems.length === 0" class="co-loading">
                        상품을 불러오는 중...
                    </div>

                    <!-- 브랜드 그룹 -->
                    <div v-for="group in groupedItems" :key="group.brandName" class="order-brand-group">
                        <div class="order-brand-header">
                            <span class="order-brand-name">{{ group.brandName }}</span>
                            <span class="order-ship-badge">무료 배송</span>
                        </div>

                        <div v-for="item in group.items" :key="item.cartId" class="order-item">
                            <div class="order-item-img">
                                <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName">
                                <span v-else class="order-item-img-placeholder">🏕️</span>
                            </div>
                            <div class="order-item-info">
                                <div class="order-item-name">{{ item.productName }}</div>
                                <div class="order-item-option" v-if="item.optionName">
                                    옵션 : {{ item.optionName }}
                                </div>
                                <!-- 대여 날짜 -->
                                <div v-if="cartType === 'RENTAL' && item.rentalStart" class="order-rental-dates">
                                    📅 {{ item.rentalStart }} ~ {{ item.rentalEnd }}
                                    <span class="nights-badge">{{ calcNights(item.rentalStart, item.rentalEnd) }}박</span>
                                </div>
                                <div class="order-item-qty">수량 : {{ item.quantity }}개</div>
                            </div>
                            <div class="order-item-price">
                                {{ formatPrice(item.price * item.quantity) }}
                            </div>
                        </div>

                        <div class="order-brand-subtotal">
                            <span class="order-brand-subtotal-label">배송비</span>
                            <span class="order-brand-subtotal-val">무료</span>
                        </div>
                    </div>

                    <div class="order-total-row">
                        <span>총 주문금액</span>
                        <span class="order-total-price">{{ formatPrice(itemTotal) }}</span>
                    </div>
                </section>

                <!-- ── 쿠폰 / 할인 ── -->
                <section class="co-section" v-if="isLogin">
                    <div class="co-section-title">할인 혜택</div>
                    <div class="discount-row">
                        <span class="discount-label">쿠폰</span>
                        <div class="discount-right">
                            <select class="coupon-select" v-model="selectedUserCouponId">
                                <option value="">쿠폰 사용 안함</option>
                                <option
                                    v-for="coupon in couponList"
                                    :key="coupon.userCouponId"
                                    :value="coupon.userCouponId"
                                    :disabled="itemTotal < coupon.minOrderAmt"
                                >
                                    {{ coupon.couponName }} / {{ couponText(coupon) }} / {{ formatPrice(coupon.minOrderAmt) }} 이상
                                </option>
                            </select>
                            <span class="discount-amount" v-if="couponDiscount > 0">
                                -{{ formatPrice(couponDiscount) }}
                            </span>
                        </div>
                    </div>
                </section>

                <!-- ── 결제 수단 ── -->
                <section class="co-section">
                    <div class="co-section-title">결제수단
                        <span class="co-total-badge">{{ formatPrice(finalTotal) }}</span>
                    </div>

                    <div class="pay-methods">
                        <label v-for="pm in payMethods" :key="pm.value"
                            class="pay-method-item"
                            :class="{ on: payMethod === pm.value }">
                            <input type="radio" :value="pm.value" v-model="payMethod" style="display:none">
                            <span class="pay-method-radio"></span>
                            <span class="pay-method-label">{{ pm.label }}</span>
                            <span v-if="pm.badge" class="pay-method-badge">{{ pm.badge }}</span>
                        </label>
                    </div>

                    <!-- 신용/체크카드 선택 -->
                    <div v-if="payMethod === 'CARD'" class="card-select-box">
                        <select class="card-select" v-model="selectedCard">
                            <option value="">카드를 선택해주세요</option>
                            <option>신한카드</option>
                            <option>삼성카드</option>
                            <option>현대카드</option>
                            <option>KB국민카드</option>
                            <option>하나카드</option>
                            <option>우리카드</option>
                            <option>NH농협카드</option>
                            <option>롯데카드</option>
                        </select>
                        <select class="card-install-select" v-model="cardInstall">
                            <option value="0">일시불</option>
                            <option value="2">2개월</option>
                            <option value="3">3개월</option>
                            <option value="6">6개월</option>
                            <option value="12">12개월</option>
                        </select>
                    </div>

                    <!-- 계좌이체 -->
                    <div v-if="payMethod === 'TRANSFER'" class="card-select-box">
                        <select class="card-select" v-model="selectedBank">
                            <option value="">은행을 선택해주세요</option>
                            <option>신한은행</option>
                            <option>국민은행</option>
                            <option>하나은행</option>
                            <option>우리은행</option>
                            <option>카카오뱅크</option>
                            <option>토스뱅크</option>
                            <option>NH농협은행</option>
                        </select>
                    </div>
                </section>

                <!-- ── 현금영수증 ── -->
                <section class="co-section" v-if="payMethod === 'TRANSFER' || payMethod === 'VBANK'">
                    <div class="co-section-title">현금영수증</div>
                    <div class="cash-receipt-wrap">
                        <label class="cash-radio" :class="{ on: cashReceipt === 'none' }">
                            <input type="radio" value="none" v-model="cashReceipt" style="display:none">
                            <span class="cash-radio-dot"></span> 신청 안함
                        </label>
                        <label class="cash-radio" :class="{ on: cashReceipt === 'personal' }">
                            <input type="radio" value="personal" v-model="cashReceipt" style="display:none">
                            <span class="cash-radio-dot"></span> 개인소득공제
                        </label>
                        <label class="cash-radio" :class="{ on: cashReceipt === 'business' }">
                            <input type="radio" value="business" v-model="cashReceipt" style="display:none">
                            <span class="cash-radio-dot"></span> 사업자지출증빙
                        </label>
                    </div>
                    <input v-if="cashReceipt !== 'none'"
                        class="cash-number-input"
                        v-model="cashReceiptNumber"
                        :placeholder="cashReceipt === 'personal' ? '휴대폰 번호 또는 현금영수증 카드번호' : '사업자 등록번호'"
                    >
                </section>

                <!-- ── 동의 ── -->
                <section class="co-section agree-section">
                    <label class="agree-all" @click="toggleAgreeAll">
                        <div class="chk" :class="{ on: agreeAll }"></div>
                        <span>약관 및 주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.</span>
                    </label>
                </section>

            </div><!-- /checkout-main -->

            <!-- ══════════ 우측 사이드바 ══════════ -->
            <div class="checkout-aside">
                <div class="aside-sticky">
                    <div class="summary-box">
                        <div class="summary-title">결제 예정 금액</div>

                        <div class="summary-rows">
                            <div class="summary-row">
                                <span>총 상품금액</span>
                                <span class="s-val">{{ formatPrice(itemTotal) }}</span>
                            </div>
                            <div class="summary-row" v-if="couponDiscount > 0">
                                <span>쿠폰 할인</span>
                                <span class="s-val red">-{{ formatPrice(couponDiscount) }}</span>
                            </div>
                            <div class="summary-row">
                                <span>배송비</span>
                                <span class="s-val">0원</span>
                            </div>
                            <div class="summary-row total">
                                <span>최종 결제금액</span>
                                <span class="s-val orange">{{ formatPrice(finalTotal) }}</span>
                            </div>
                        </div>

                        <!-- 주문 상품 목록 요약 -->
                        <div class="summary-items">
                            <div v-for="item in orderItems" :key="item.cartId" class="summary-item-row">
                                <span class="summary-item-name">
                                    {{ item.productName }}
                                    <span v-if="item.optionName" class="summary-item-opt">/ {{ item.optionName }}</span>
                                </span>
                                <span class="summary-item-price">{{ formatPrice(item.price * item.quantity) }}</span>
                            </div>
                        </div>

                        <button class="pay-btn"
                            :disabled="!agreeAll || orderItems.length === 0"
                            @click="fnPay">
                            {{ formatPrice(finalTotal) }} 결제하기
                        </button>
                        <div class="pay-info">결제 완료 후 취소/변경이 어려울 수 있습니다</div>
                    </div>
                </div>
            </div>

        </div><!-- /checkout-layout -->
    </div><!-- /checkout-wrap -->

    <!-- ══════════ 배송지 변경 모달 ══════════ -->
    <div v-if="addrModal.open" class="modal-overlay" @click.self="addrModal.open = false">
        <div class="modal-box addr-modal-box">
            <div class="modal-header">
                <span class="modal-title">배송지 변경</span>
                <button class="modal-close" @click="addrModal.open = false">✕</button>
            </div>
            <div class="addr-list">
                <div
                    v-for="addr in addressList"
                    :key="addr.addressId"
                    class="addr-select-item"
                    :class="{ on: selectedAddressId === addr.addressId }"
                    @click="selectedAddressId = addr.addressId"
                >
                    <div class="addr-name">
                        {{ addr.addressAlias }}
                        <span class="addr-default-badge" v-if="addr.defaultYn === 'Y'">기본배송지</span>
                    </div>
                    <div class="addr-full">
                        [{{ addr.zipcode }}] {{ addr.address }} {{ addr.detailedAddress }}
                    </div>
                </div>
            </div>

            <div class="modal-btns">
                <button class="modal-btn-cancel" @click="addrModal.open = false">취소</button>
                <button class="modal-btn-ok" @click="selectAddress">선택</button>
            </div>
        </div>
    </div>

    <!-- ══════════ 토스트 ══════════ -->
    <div id="toast-msg" v-if="toast.show" class="toast-msg">{{ toast.msg }}</div>

</div><!-- /app -->
<%@ include file="/WEB-INF/common/footer.jsp" %>
<script>
    const app = Vue.createApp({
        data() {
            return {
                cartIds: [],
                cartType: 'RENTAL',
                orderItems: [],
                isLogin: false,

                deliveryMemo: '',
                deliveryMemoCustom: '',

                // 쿠폰
                couponList: [],
                selectedUserCouponId: '',

                // 결제수단
                payMethod: 'CARD',
                payMethods: [
                    { value: 'CARD',     label: '신용/체크카드' },
                    { value: 'TRANSFER', label: '계좌이체' },
                    { value: 'VBANK',    label: '가상계좌' },
                    { value: 'PHONE',    label: '휴대폰 결제' },
                ],
                selectedCard: '',
                cardInstall: '0',
                selectedBank: '',

                // 현금영수증
                cashReceipt: 'none',
                cashReceiptNumber: '',

                // 동의
                agreeAll: false,

                // 토스트
                toast: { show: false, msg: '' },

                // 주소
                addrModal: { open: false },
                addressList: [],
                selectedAddressId: '',
                addrForm: {
                    addressId: '',
                    addressAlias: '',
                    zipcode: '',
                    address: '',
                    detailedAddress: '',
                    defaultYn: 'N',
                    receiverName: '',
                    receiverPhone: ''
                },
            };
        },
        computed: {
            groupedItems() {
                const groups = {};
                this.orderItems.forEach(item => {
                    const key = item.brandName || '모닥모닥';
                    if (!groups[key]) groups[key] = { brandName: key, items: [] };
                    groups[key].items.push(item);
                });
                return Object.values(groups);
            },
            itemTotal() {
                return this.orderItems.reduce((sum, c) => sum + c.price * c.quantity, 0);
            },
            selectedCoupon() {
                return this.couponList.find(c => String(c.userCouponId) === String(this.selectedUserCouponId)) || null;
            },
            couponDiscount() {
                const coupon = this.selectedCoupon;
                if (!coupon) return 0;
                if (this.itemTotal < coupon.minOrderAmt) return 0;
                let discount = 0;
                if (coupon.couponType === 'AMOUNT') {
                    discount = coupon.discountAmt;
                } else if (coupon.couponType === 'RATE') {
                    discount = Math.floor(this.itemTotal * coupon.discountRate / 100);
                    if (coupon.maxDiscountAmt > 0) discount = Math.min(discount, coupon.maxDiscountAmt);
                }
                return Math.min(discount, this.itemTotal);
            },
            finalTotal() {
                return Math.max(0, this.itemTotal - this.couponDiscount);
            }
        },
        methods: {
            // ── 초기화 ──
            init() {
                const params = new URLSearchParams(location.search);
                this.cartType = params.get('cartType') || 'RENTAL';
                const ids = params.get('cartIds');
                this.cartIds = ids ? ids.split(',').map(Number) : [];
                const couponId = params.get('userCouponId');
                if (couponId) this.selectedUserCouponId = couponId;
            },

            // ── 로그인 & 데이터 로드 ──
            checkLogin() {
                let self = this;
                $.ajax({
                    url: '/user/session-check.dox',
                    type: 'POST',
                    dataType: 'json',
                    success(res) {
                        self.isLogin = res.isLogin === true;
                        if (self.isLogin) {
                            self.fetchOrderItems();
                            self.fetchCouponList();
                            self.fetchAddressList();
                        } else {
                            location.href = '/user/login.do';
                        }
                    }
                });
            },

            fetchOrderItems() {
                let self = this;
                $.ajax({
                    url: '/payment/checkoutItems.dox',
                    type: 'POST',
                    data: {
                        cartIds: self.cartIds.join(','),
                        cartType: self.cartType
                    },
                    dataType: 'json',
                    success(res) {
                        console.log("주문상품 응답:", res);

                        if (res.result === 'success') {
                            self.orderItems = res.list || [];
                        }
                    }
                });
            },

            fetchDefaultAddr() {
                let self = this;
                $.ajax({
                    url: '/user/defaultAddr.dox',
                    type: 'POST',
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success' && res.addr) {
                            self.addrForm = { ...self.addrForm, ...res.addr };
                        }
                    }
                });
            },

            fetchCouponList() {
                let self = this;
                $.ajax({
                    url: '/coupon/myCouponList.dox',
                    type: 'POST',
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success') {
                            self.couponList = res.list || [];
                        }
                    }
                });
            },

            // ── 결제하기 ──
            fnPay() {
                if (!this.agreeAll) {
                    this.showToast('약관에 동의해주세요.');
                    return;
                }
                if (this.orderItems.length === 0) {
                    this.showToast('주문 상품이 없습니다.');
                    return;
                }

                // orderId 생성 (6자~64자, 중복 불가)
                const orderId = 'modak-' + new Date().getTime();
                
                // 주문명
                const orderName = this.orderItems.length === 1
                    ? this.orderItems[0].productName
                    : this.orderItems[0].productName + ' 외 ' + (this.orderItems.length - 1) + '건';

                // ① 먼저 서버에 임시 주문 저장 (금액 변조 방지)
                let self = this;
                $.ajax({
                    url: '/payment/ready.dox',
                    type: 'POST',
                    data: {
                        orderId: orderId,
                        amount: self.finalTotal,
                        cartIds: self.cartIds.join(','),
                        cartType: self.cartType,
                        userCouponId: self.selectedUserCouponId || '',
                        receiverName: self.addrForm.receiverName,
                        receiverPhone: self.addrForm.receiverPhone,
                        address: self.addrForm.address + ' ' + (self.addrForm.detailedAddress || ''),
                        deliveryMemo: self.deliveryMemo === '직접 입력' ? self.deliveryMemoCustom : self.deliveryMemo
                    },
                    dataType: 'json',
                    success(res) {
                        if (res.result !== 'success') {
                            self.showToast(res.message || '주문 준비에 실패했습니다.');
                            return;
                        }

                        // ② 토스 결제창 호출
                        const tossPayments = TossPayments("test_ck_여기에_클라이언트키_입력");
                        
                        tossPayments.requestPayment('카드', {
                            amount: self.finalTotal,
                            orderId: orderId,
                            orderName: orderName,
                            customerName: self.addrForm.receiverName,
                            successUrl: window.location.origin + '/payment/success.do',
                            failUrl: window.location.origin + '/payment/fail.do'
                        });
                    },
                    error() {
                        self.showToast('주문 처리 중 오류가 발생했습니다.');
                    }
                });
            },

            // ── 동의 ──
            toggleAgreeAll() {
                this.agreeAll = !this.agreeAll;
            },

            // ── 유틸 ──
            formatPrice(p) {
                if (!p) return '0원';
                return Number(p).toLocaleString('ko-KR') + '원';
            },
            calcNights(s, e) {
                if (!s || !e) return 0;
                return Math.ceil((new Date(e) - new Date(s)) / (1000 * 60 * 60 * 24));
            },
            couponText(coupon) {
                if (coupon.couponType === 'AMOUNT') return this.formatPrice(coupon.discountAmt) + ' 할인';
                if (coupon.couponType === 'RATE') {
                    let txt = coupon.discountRate + '% 할인';
                    if (coupon.maxDiscountAmt > 0) txt += ' / 최대 ' + this.formatPrice(coupon.maxDiscountAmt);
                    return txt;
                }
                return '';
            },
            showToast(msg) {
                this.toast.msg = msg;
                this.toast.show = true;
                setTimeout(() => { this.toast.show = false; }, 2200);
            },
            fetchAddressList() {
                let self = this;

                $.ajax({
                    url: '/payment/addressList.dox',
                    type: 'POST',
                    dataType: 'json',
                    success(res) {
                        console.log("배송지 응답:", res);

                        if (res.result === 'success') {
                            self.addressList = res.list || [];
                            console.log("배송지 목록:", self.addressList);

                            const defaultAddr = self.addressList.find(a => a.defaultYn === 'Y');

                            if (defaultAddr) {
                                self.addrForm = { ...defaultAddr };
                                self.selectedAddressId = defaultAddr.addressId;
                            } else if (self.addressList.length > 0) {
                                self.addrForm = { ...self.addressList[0] };
                                self.selectedAddressId = self.addressList[0].addressId;
                            }
                        } else {
                            self.showToast(res.message || '배송지 조회에 실패했습니다.');
                        }
                    },
                    error(err) {
                        console.log("배송지 조회 오류:", err);
                        self.showToast('배송지 조회 중 오류가 발생했습니다.');
                    }
                });
            },
            selectAddress() {
                const addr = this.addressList.find(a => a.addressId === this.selectedAddressId);

                if (!addr) {
                    this.showToast('배송지를 선택해주세요.');
                    return;
                }

                this.addrForm = { ...addr };
                this.addrModal.open = false;
            }
        },
        mounted() {
            this.init();
            this.checkLogin();
        }
    });

    app.mount('#app');
</script>
</body>

</html>