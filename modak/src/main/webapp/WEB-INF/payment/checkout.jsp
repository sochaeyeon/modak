<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>결제 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/payment/checkout.css">
        <link rel="stylesheet" href="/css/search/search.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <script src="https://js.tosspayments.com/v1"></script> <!-- 토스 스크립트 -->
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>
            <div id="app" v-cloak>

                <!-- 브레드크럼 -->
                <div class="step-wrap">
                    <div class="step active">장바구니</div>
                    <div class="step-line active"></div>
                    <div class="step active">주문결제</div>
                    <div class="step-line"></div>
                    <div class="step">완료</div>
                </div>

                <div class="checkout-wrap">
                    <div class="checkout-layout">

                        <!-- ══════════ 좌측 메인 ══════════ -->
                        <div class="checkout-main">

                            <!-- ── 배송지 ── -->
                            <section class="co-section">
                                <div class="co-section-title">배송지</div>

                                        <!-- 회원 -->
                                        <template v-if="isLogin">
                                            <div class="addr-info-box">
                                                <div class="addr-info-content">
                                                    <div class="addr-name">
                                                        {{ addrForm.receiverName || addrForm.addressAlias || '배송지' }}
                                                        <span class="addr-default-badge" v-if="addrForm.defaultYn === 'Y'">기본배송지</span>
                                                    </div>
                                                    <div class="addr-phone">{{ addrForm.receiverPhone || '연락처 없음' }}</div>
                                                    <div class="addr-full">
                                                        [{{ addrForm.zipcode }}] {{ addrForm.address }} {{ addrForm.detailedAddress }}
                                                    </div>
                                                </div>
                                                <button class="addr-change-btn" @click="addrModal.open = true">변경</button>
                                            </div>
                                        </template>

                                        <!-- 비회원 -->
                                        <template v-else>
                                            <div class="guest-addr-form">
                                                <div class="guest-field-wrap">
                                                    <span class="guest-field-label">수령인 이름 *</span>
                                                    <input class="guest-input" v-model="guestName" placeholder="홍길동" />
                                                </div>
                                                <div class="guest-field-wrap">
                                                    <span class="guest-field-label">연락처 *</span>
                                                    <input class="guest-input" v-model="guestPhone" placeholder="01012345678" />
                                                </div>
                                                <div class="guest-addr-row">
                                                    <div class="guest-field-wrap zip">
                                                        <span class="guest-field-label">우편번호 *</span>
                                                        <input class="guest-input" v-model="guestZipcode" placeholder="06234" />
                                                    </div>
                                                    <div class="guest-field-wrap">
                                                        <span class="guest-field-label">주소 *</span>
                                                        <input class="guest-input" v-model="guestAddress" placeholder="서울시 강남구 테헤란로 123" />
                                                    </div>
                                                </div>
                                                <div class="guest-field-wrap">
                                                    <span class="guest-field-label">상세주소</span>
                                                    <input class="guest-input optional" v-model="guestDetailAddress" placeholder="101동 202호" />
                                                </div>
                                            </div>
                                        </template>

                                        <!-- 배송 메모 (공통) -->
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
                                                {{ item.optionName }}
                                            </div>
                                            <!-- 대여 날짜 -->
                                            <div v-if="cartType === 'RENTAL' && item.rentalStart"
                                                class="order-rental-dates">
                                                📅 {{ item.rentalStart }} ~ {{ item.rentalEnd }}
                                                <span class="nights-badge">{{ calcNights(item.rentalStart,
                                                    item.rentalEnd) }}박</span>
                                            </div>
                                            <div class="order-item-qty">수량 : {{ item.quantity }}개</div>
                                        </div>
                                        <div class="order-item-price">
                                            {{ formatPrice(calcItemTotal(item)) }}
                                        </div>
                                    </div>

                                    <div class="order-brand-subtotal">
                                        <span class="order-brand-subtotal-label">배송비</span>
                                        <span class="order-brand-subtotal-val">무료</span>
                                    </div>
                                </div>
                            </section>

                            <!-- ── 쿠폰 / 할인 ── -->
                            <section class="co-section" v-if="isLogin">
                                <div class="co-section-title">할인 혜택</div>

                                <!-- 쿠폰 -->
                                <div class="discount-row">
                                    <span class="discount-label">쿠폰</span>
                                    <div class="discount-right">
                                        <select class="coupon-select" v-model="selectedUserCouponId">
                                            <option value="">쿠폰 사용 안함</option>
                                            <option v-for="coupon in couponList" :key="coupon.userCouponId"
                                                :value="coupon.userCouponId" :disabled="itemTotal < coupon.minOrderAmt">
                                                {{ coupon.couponName }} / {{ couponText(coupon) }} / {{
                                                formatPrice(coupon.minOrderAmt) }} 이상
                                            </option>
                                        </select>
                                        <span class="discount-amount" v-if="couponDiscount > 0">
                                            -{{ formatPrice(couponDiscount) }}
                                        </span>
                                    </div>
                                </div>
                                <!-- 포인트 -->
                                <div class="discount-row point-discount-row">
                                    <span class="discount-label point-label">포인트</span>

                                    <div class="discount-right point-discount-right">
                                        <div class="point-input-wrap">
                                            <input type="number"
                                                class="coupon-select point-input"
                                                v-model.number="usePoint"
                                                :max="maxUsePoint"
                                                min="0"
                                                placeholder="0"
                                                style="background-image: none;" />

                                            <button type="button"
                                                    class="point-clear-btn"
                                                    v-if="validUsePoint > 0"
                                                    @click="clearPoint">
                                                ×
                                            </button>
                                        </div>

                                        <span class="point-own">
                                            보유 {{ formatPrice(userPoint) }}
                                            <em>/ 사용가능 {{ formatPrice(maxUsePoint) }}</em>
                                        </span>

                                        <button type="button" class="addr-change-btn point-all-btn" @click="useAllPoint">
                                            전액사용
                                        </button>

                                        <span class="discount-amount" v-if="validUsePoint > 0">
                                            -{{ formatPrice(validUsePoint) }}
                                        </span>
                                    </div>
                                </div>
                            </section>

                            <!-- ── 동의 ── -->
                            <section class="co-section agree-section">
                                <label class="agree-all" @click="toggleAgreeAll">
                                    <div class="chk" :class="{ on: agreeAll }"></div>
                                    <span>약관 및 주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.</span>
                                </label>
                            </section>

                            <!-- ══════════ 배송지 없음 → 신규 등록 모달 ══════════ -->
                            <div v-if="addrAddModal.open" class="modal-overlay" @click.self="addrAddModal.open = false">
                                <div class="modal-box addr-modal-box">
                                    <div class="modal-header">
                                        <span class="modal-title">배송지 등록</span>
                                        <button class="modal-close" @click="addrAddModal.open = false">✕</button>
                                    </div>

                                    <p style="font-size:13px;color:#E8732A;font-weight:700;margin-bottom:16px;">
                                        📦 등록된 배송지가 없습니다. 배송지를 등록해주세요.
                                    </p>

                                    <div class="guest-addr-form">
                                        <div class="guest-field-wrap">
                                            <span class="guest-field-label">별칭 *</span>
                                            <input class="guest-input" v-model="newAddr.addressAlias" placeholder="집, 회사 등" />
                                        </div>
                                        <div class="guest-addr-row">
                                            <div class="guest-field-wrap zip">
                                                <span class="guest-field-label">우편번호 *</span>
                                                <input class="guest-input" v-model="newAddr.zipCode" placeholder="주소검색" readonly />
                                            </div>

                                            <div class="guest-field-wrap">
                                                <span class="guest-field-label">주소 *</span>
                                                <div style="display:flex; gap:8px;">
                                                    <input class="guest-input" v-model="newAddr.address" placeholder="주소검색을 눌러주세요" readonly />
                                                    <button type="button" class="addr-change-btn" @click="fnSearchAddress">
                                                        주소검색
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="guest-field-wrap">
                                            <span class="guest-field-label">상세주소</span>
                                            <input class="guest-input optional"
                                                ref="detailAddressInput"
                                                v-model="newAddr.detailedAddress"
                                                placeholder="101동 202호" />
                                        </div>
                                        <label style="display:flex;align-items:center;gap:8px;font-size:13px;margin-top:8px;cursor:pointer;">
                                            <input type="checkbox" v-model="newAddr.defaultYn"> 기본 배송지로 설정
                                        </label>
                                    </div>

                                    <p v-if="addrAddMsg" style="color:#e74c3c;font-size:12px;margin-top:8px;">{{ addrAddMsg }}</p>

                                    <div class="modal-btns" style="margin-top:16px;">
                                        <button class="modal-btn-cancel" @click="addrAddModal.open = false">취소</button>
                                        <button class="modal-btn-ok" @click="saveNewAddress">저장하기</button>
                                    </div>
                                </div>
                            </div>

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
                                        <div class="summary-row" v-if="isLogin && validUsePoint > 0">
                                            <span>포인트 할인</span>
                                            <span class="s-val red">-{{ formatPrice(validUsePoint) }}</span>
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



                                    <button class="pay-btn" :disabled="!agreeAll || orderItems.length === 0"
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
                            <div v-for="addr in addressList" :key="addr.addressId" class="addr-select-item"
                                :class="{ on: selectedAddressId === addr.addressId }"
                                @click="selectedAddressId = addr.addressId">
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
                    const TOSS_CLIENT_KEY = "${tossClientKey}";
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
                                addrAddModal: { open: false },
                                newAddr: {
                                    addressAlias: '',
                                    zipCode: '',
                                    address: '',
                                    detailedAddress: '',
                                    defaultYn: false
                                },
                                addrAddMsg: '',
                                // 비회원 정보
                                guestName: '',
                                guestPhone: '',
                                guestZipcode: '',
                                guestAddress: '',
                                guestDetailAddress: '',
                                isPaying: false,
                                guestKey: localStorage.getItem('guestKey') || '',

                                userPoint: 0,
                                usePoint: 0,
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
                                return this.orderItems.reduce((sum, c) => sum + this.calcItemTotal(c), 0);
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
                            maxUsePoint() {
                                return Math.min(
                                    Number(this.userPoint || 0),
                                    Math.max(0, this.itemTotal - this.couponDiscount)
                                );
                            },
                            validUsePoint() {
                                let point = Number(this.usePoint || 0);
                                if (point < 0) point = 0;
                                if (point > this.maxUsePoint) point = this.maxUsePoint;
                                return point;
                            },
                            finalTotal() {
                                return Math.max(0, this.itemTotal - this.couponDiscount - this.validUsePoint);
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
                                if (couponId) {
                                    this.selectedUserCouponId = couponId;
                                }

                                const usePoint = params.get('usePoint');
                                if (usePoint) {
                                    this.usePoint = Number(usePoint || 0);
                                }
                                if (!this.guestKey) {
                                    this.guestKey = 'GUEST_' + Date.now() + '_' + Math.floor(Math.random() * 100000);
                                    localStorage.setItem('guestKey', this.guestKey);
                                }
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
                                        // ✅ 비회원도 그냥 통과 (redirect 제거)
                                        self.fetchOrderItems();
                                        //self.fetchAddressList();
                                        if (self.isLogin) {
                                            self.fetchAddressList(); // ✅ 회원만 호출
                                            self.fetchCouponList(); // 쿠폰조회
                                            self.fetchUserPoint(); // 포인트조회
                                        }
                                    }
                                });
                            },

                            fetchOrderItems() {
                                let self = this;
                                const params = new URLSearchParams(location.search);
                                const isBuyNow = params.get('buyNow') === 'true';

                                // ── 비회원 ──
                                if (!self.isLogin) {
                                    try {
                                        if (isBuyNow) {
                                            const raw = localStorage.getItem('modak_guest_buy_now');
                                            self.orderItems = raw ? JSON.parse(raw) : [];
                                        } else {
                                            const raw = localStorage.getItem('modak_guest_cart');
                                            self.orderItems = raw ? JSON.parse(raw) : [];
                                        }
                                    } catch (e) { self.orderItems = []; }
                                    return;
                                }

                                // ── 회원 + 바로구매 ──
                                if (isBuyNow) {
                                    try {
                                        const raw = localStorage.getItem('modak_guest_buy_now');
                                        self.orderItems = raw ? JSON.parse(raw) : [];
                                    } catch (e) { self.orderItems = []; }
                                    return;
                                }

                                // ── 회원 + 장바구니 ──
                                $.ajax({
                                    url: '/payment/checkoutItems.dox',
                                    type: 'POST',
                                    data: {
                                        cartIds: self.cartIds.join(','),
                                        cartType: self.cartType,
                                        guestKey: self.guestKey
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.orderItems = res.list || [];
                                        } else {
                                            self.orderItems = [];
                                            self.showToast(res.message || '주문상품 조회 실패');
                                        }
                                    },
                                    error() {
                                        self.orderItems = [];
                                        self.showToast('주문상품 조회 중 오류가 발생했습니다.');
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
                                if (this.isPaying) return; // ✅ 중복 방지
                                this.isPaying = true;

                                if (!this.agreeAll) {
                                    this.isPaying = false;
                                    this.showToast('약관에 동의해주세요.');
                                    return;
                                }

                                if (this.orderItems.length === 0) {
                                    this.isPaying = false;
                                    this.showToast('주문 상품이 없습니다.');
                                    return;
                                }
                                // 회원인데 배송지 등록 안되어있을때
                                if (this.isLogin) {
                                    if (!this.addrForm.addressId || !this.addrForm.zipcode || !this.addrForm.address) {
                                        this.isPaying = false;
                                        this.addrAddModal.open = true;
                                        this.showToast('배송지를 등록해주세요.');
                                        return;
                                    }
                                }
                                // ✅ 비회원 검증
                                if (!this.isLogin) {
                                    if (!this.guestName.trim()) { this.isPaying = false; this.showToast('수령인 이름을 입력해주세요.'); return; }
                                    if (!this.guestPhone.trim()) { this.isPaying = false; this.showToast('연락처를 입력해주세요.'); return; }
                                    if (!this.guestZipcode.trim()) { this.isPaying = false; this.showToast('우편번호를 입력해주세요.'); return; }
                                    if (!this.guestAddress.trim()) { this.isPaying = false; this.showToast('주소를 입력해주세요.'); return; }
                                }

                                // ✅ orderId는 이제 서버에서 받아옴 (프론트에서 생성 X)
                                const orderName = this.orderItems.length === 1
                                    ? this.orderItems[0].productName
                                    : this.orderItems[0].productName + ' 외 ' + (this.orderItems.length - 1) + '건';

                                const isBuyNow = new URLSearchParams(location.search).get('buyNow') === 'true';
                                // 콘솔 테스트용
                                console.log("amount:", this.finalTotal, typeof this.finalTotal);
                                console.log("orderName:", orderName);
                                console.log("customerName:", this.isLogin ? this.addrForm.receiverName : this.guestName);

                                let self = this;
                                $.ajax({
                                    url: '/payment/ready.dox',
                                    type: 'POST',
                                    data: {
                                        amount: self.finalTotal, // 최종 결제금액 (할인 후)
                                        cartIds: self.cartIds.join(','),
                                        cartType: self.cartType,
                                        guestKey: self.guestKey,
                                        //guestItems: !self.isLogin ? JSON.stringify(self.orderItems) : '',
                                        guestItems: (isBuyNow || !self.isLogin)
                                            ? JSON.stringify(self.orderItems)
                                            : '',
                                        userCouponId: self.selectedUserCouponId || '',
                                        discountAmt: self.couponDiscount,
                                        receiverName: self.isLogin ? self.addrForm.receiverName : self.guestName,
                                        receiverPhone: self.isLogin ? self.addrForm.receiverPhone : self.guestPhone,
                                        address: self.isLogin
                                            ? self.addrForm.address + ' ' + (self.addrForm.detailedAddress || '')
                                            : self.guestAddress + ' ' + self.guestDetailAddress,  // ✅ 비회원 주소
                                        zipcode: self.isLogin ? self.addrForm.zipcode : self.guestZipcode, // ✅ 추가
                                        deliveryMemo: self.deliveryMemo === '직접 입력' ? self.deliveryMemoCustom : self.deliveryMemo,
                                        guestName: self.isLogin ? '' : self.guestName,
                                        guestPhone: self.isLogin ? '' : self.guestPhone,
                                        isGuest: self.isLogin ? 'N' : 'Y',
                                        usePoint: self.validUsePoint,
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result !== 'success') {
                                            self.isPaying = false;  // ✅ 추가
                                            self.showToast(res.message || '주문 준비에 실패했습니다.');
                                            return;
                                        }

                                        const orderId = 'modak-' + String(res.orderId);
                                        const tossPayments = TossPayments(TOSS_CLIENT_KEY);

                                        tossPayments.requestPayment('카드', {
                                            //amount: res.amount,
                                            amount: Number(res.amount),
                                            orderId: orderId,
                                            orderName: orderName,
                                            customerName: self.isLogin ? self.addrForm.receiverName : self.guestName,
                                            successUrl: window.location.origin
                                                + '/payment/success.do?buyNow='
                                                + (new URLSearchParams(location.search).get('buyNow') === 'true'),
                                            failUrl: window.location.origin + '/payment/fail.do'
                                        }).catch(() => {
                                            self.isPaying = false;  // ✅ 토스 창 닫거나 취소 시 해제
                                        });
                                    },
                                    error() {
                                        self.isPaying = false; // ✅ 실패 시 잠금 해제
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
                                            } else if (self.isLogin) {
                                                // ✅ 등록된 배송지 없으면 모달 오픈
                                                self.addrAddModal.open = true;
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
                            },
                            calcItemTotal(item) {
                                const price = Number(item.unitPrice || item.price || 0);
                                const quantity = Number(item.quantity || 1);

                                if (this.cartType === 'RENTAL') {
                                    const nights = this.calcNights(item.rentalStart, item.rentalEnd) || 1;
                                    const deposit = Number(item.deposit || 0);

                                    return (price * nights + deposit) * quantity;
                                }

                                return price * quantity;
                            },
                            fetchUserPoint() {
                                let self = this;
                                $.ajax({
                                    url: '/user/point.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.userPoint = Number(res.point || 0);
                                        }
                                    }
                                });
                            },
                            useAllPoint() {
                                this.usePoint = this.maxUsePoint;
                            },
                            clearPoint() {
                                this.usePoint = 0;
                            },
                            fnSearchAddress() {
                                let self = this;

                                new daum.Postcode({
                                    oncomplete: function (data) {
                                        let addr = "";

                                        if (data.userSelectedType === "R") {
                                            addr = data.roadAddress;
                                        } else {
                                            addr = data.jibunAddress;
                                        }

                                        self.newAddr.zipCode = data.zonecode;
                                        self.newAddr.address = addr;

                                        self.$nextTick(function () {
                                            if (self.$refs.detailAddressInput) {
                                                self.$refs.detailAddressInput.focus();
                                            }
                                        });
                                    }
                                }).open();
                            },
                            saveNewAddress() {
                                let self = this;
                                self.addrAddMsg = '';

                                if (!self.newAddr.addressAlias.trim()) { self.addrAddMsg = '배송지 별칭을 입력해주세요.'; return; }
                                if (!self.newAddr.zipCode.trim())      { self.addrAddMsg = '우편번호를 입력해주세요.'; return; }
                                if (!self.newAddr.address.trim())      { self.addrAddMsg = '주소를 입력해주세요.'; return; }

                                $.ajax({
                                    url: '/user/address/add.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        addressAlias:    self.newAddr.addressAlias,
                                        zipCode:         self.newAddr.zipCode,
                                        address:         self.newAddr.address,
                                        detailedAddress: self.newAddr.detailedAddress,
                                        defaultYn:       self.newAddr.defaultYn ? 'Y' : 'N'
                                    },
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.addrAddModal.open = false;
                                            self.fetchAddressList(); // 저장 후 목록 다시 불러와서 addrForm 세팅
                                            self.showToast('배송지가 저장됐어요.');
                                        } else {
                                            self.addrAddMsg = res.message || '저장에 실패했습니다.';
                                        }
                                    },
                                    error() { self.addrAddMsg = '서버 오류가 발생했습니다.'; }
                                });
                            },
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