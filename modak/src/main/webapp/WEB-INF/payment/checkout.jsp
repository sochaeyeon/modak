<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>결제 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/payment/checkout.css">
        <link rel="stylesheet" href="/css/search/search.css">
        <link rel="stylesheet" href="/css/cart/cart-list.css">
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
                <div class="step-wrap cart-step-switch-wrap">
                    <div class="step" :class="{ active: currentStep === 1 }">장바구니</div>
                    <div class="step-line"></div>
                    <div class="step step-cart-switch"
                        :class="{ active: currentStep === 2 }">
                        <span class="cart-step-main">주문/결제</span>
                    </div>
                    <div class="step-line"></div>
                    <div class="step"
                        :class="{ active: currentStep === 3 }">
                        주문완료
                    </div>
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
                                                <span class="addr-default-badge"
                                                    v-if="addrForm.defaultYn === 'Y'">기본배송지</span>
                                            </div>
                                            <div class="addr-phone">{{ addrForm.receiverPhone || '연락처 없음' }}</div>
                                            <div class="addr-full">
                                                [{{ addrForm.zipcode }}] {{ addrForm.address }} {{
                                                addrForm.detailedAddress }}
                                            </div>
                                        </div>
                                        <button class="addr-change-btn" @click="openAddrModal">변경</button>
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
                                                <div class="zipcode-row">
                                                    <input class="guest-input" v-model="guestZipcode"
                                                        placeholder="06234" readonly />
                                                    <button type="button" class="addr-search-btn"
                                                        @click="openGuestPostcode">
                                                        주소찾기
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="guest-field-wrap">
                                                <span class="guest-field-label">주소 *</span>
                                                <input class="guest-input" v-model="guestAddress"
                                                    placeholder="서울시 강남구 테헤란로 123" readonly />
                                            </div>
                                        </div>
                                        <div class="guest-field-wrap">
                                            <span class="guest-field-label">상세주소</span>
                                            <input class="guest-input optional" v-model="guestDetailAddress"
                                                placeholder="101동 202호" />
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
                            <section class="co-section order-section">
                                <div class="co-section-title">주문상품</div>

                                <div v-if="orderItems.length === 0" class="co-loading">
                                    상품을 불러오는 중...
                                </div>

                                <div v-else class="order-cart-card">
                                    <template v-for="group in groupedItems" :key="group.brandName">

                                        <div class="order-cart-card-header">
                                            <span>{{ group.brandName || '모닥모닥' }}</span>
                                            <span class="order-ship-badge">무료 배송</span>
                                        </div>

                                        <div v-for="item in group.items" :key="item.cartId" class="order-cart-item">
                                            <div class="order-cart-item-top">
                                                <div class="order-cart-item-img">
                                                    <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName">
                                                    <span v-else class="order-item-img-placeholder">🏕️</span>
                                                </div>

                                                <div class="order-cart-item-info">
                                                    <div class="order-cart-item-name">
                                                        {{ item.productName }}
                                                    </div>

                                                    <div class="order-cart-option-row" v-if="item.optionName">
                                                        <span class="order-item-option">{{ item.optionName }}</span>
                                                    </div>

                                                    <div v-if="cartType === 'RENTAL' && item.rentalStart"
                                                        class="order-rental-dates">
                                                        {{ formatRentalRange(item.rentalStart, item.rentalEnd) }}
                                                        <span class="nights-badge">
                                                            {{ calcNights(item.rentalStart, item.rentalEnd) }}박
                                                        </span>
                                                    </div>
                                                </div>

                                                <div class="order-cart-item-side">
                                                    <div class="order-item-qty">
                                                        수량 : {{ item.quantity }}개
                                                    </div>

                                                    <div class="order-price-block">
                                                        <div class="order-unit-price">
                                                            <template v-if="cartType === 'RENTAL'">
                                                                {{ formatPrice(item.unitPrice || item.price) }}
                                                                × {{ calcNights(item.rentalStart, item.rentalEnd) }}박
                                                                <span v-if="item.deposit > 0">
                                                                    + 보증금 {{ formatPrice(item.deposit) }}
                                                                </span>
                                                            </template>

                                                            <template v-else>
                                                                {{ formatPrice(item.unitPrice || item.price) }}
                                                                × {{ item.quantity }}개
                                                            </template>
                                                        </div>

                                                        <div class="order-total-price">
                                                            {{ formatPrice(calcItemTotal(item)) }}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </template>

                                    <div class="order-brand-subtotal">
                                        <span class="order-brand-subtotal-label">배송비</span>
                                        <span class="order-brand-subtotal-val">무료</span>
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
                                        <div class="guest-field-wrap">
                                            <span class="guest-field-label">수령인 이름 *</span>
                                            <input class="guest-input" v-model="newAddr.receiverName" placeholder="홍길동" />
                                        </div>
                                        <div class="guest-field-wrap">
                                            <span class="guest-field-label">연락처 *</span>
                                            <input class="guest-input" v-model="newAddr.receiverPhone" placeholder="01012345678" />
                                        </div>
                                        <div class="guest-addr-row">
                                            <div class="guest-field-wrap zip">
                                                <span class="guest-field-label">우편번호 *</span>
                                                <div class="zipcode-row">
                                                    <input class="guest-input" v-model="newAddr.zipCode"
                                                        placeholder="06234" readonly />
                                                    <button type="button" class="addr-search-btn" @click="fnSearchAddress">
                                                        주소찾기
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="guest-field-wrap">
                                                <span class="guest-field-label">주소 *</span>
                                                <input class="guest-input" v-model="newAddr.address"
                                                    placeholder="서울시 강남구 테헤란로 123" readonly />
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
                                        <!-- 버튼 기능은 기존 유지: 취소/저장하기(saveNewAddress) -->
                                        <button class="modal-btn-cancel" @click="addrAddModal.open = false">취소</button>
                                        <button class="modal-btn-ok" @click="saveNewAddress">저장하기</button>
                                    </div>
                                </div>
                            </div>

                        </div><!-- /checkout-main -->

                        <!-- ══════════ 우측 사이드바 ══════════ -->
                        <div class="cart-aside checkout-aside">
                            <div class="aside-box">
                                <div class="aside-title">결제 예정 금액</div>
                                <div class="aside-rows">

                                    <div class="aside-row">
                                        <span>총 상품금액</span>
                                        <span class="val">{{ formatPrice(itemTotal) }}</span>
                                    </div>

                                    <!-- 쿠폰: 회원만 -->
                                    <div class="coupon-box" v-if="isLogin">
                                        <div class="coupon-title">쿠폰 선택</div>
                                        <select class="coupon-select" v-model="selectedUserCouponId">
                                            <option value="">쿠폰 사용 안함</option>
                                            <option v-for="coupon in couponList" :key="coupon.userCouponId"
                                                :value="coupon.userCouponId"
                                                :disabled="itemTotal < coupon.minOrderAmt">
                                                {{ coupon.couponName }}
                                                / {{ couponText(coupon) }}
                                                / {{ formatPrice(coupon.minOrderAmt) }} 이상
                                            </option>
                                        </select>
                                    </div>

                                    <!-- 비회원: 쿠폰 안내 -->
                                    <div v-if="!isLogin"
                                        style="padding:10px 0;font-size:12px;color:#999;text-align:center;">
                                        <a href="/user/login.do" style="color:var(--orange);font-weight:700;">로그인</a> 후
                                        쿠폰·포인트를 사용할 수 있습니다.
                                    </div>

                                    <div class="aside-row" v-if="isLogin">
                                        <span>쿠폰할인예상금액</span>
                                        <span class="val red">-{{ formatPrice(couponDiscount) }}</span>
                                    </div>

                                    <!-- 포인트: 회원만 -->
                                    <div class="point-box" v-if="isLogin">
                                        <div class="point-title">
                                            <span>포인트 사용</span>
                                            <span>보유 {{ formatPrice(userPoint) }}</span>
                                        </div>
                                        <div class="point-input-wrap">
                                            <div class="input-box">
                                                <input type="text"
                                                    class="point-input"
                                                    :value="usePoint"
                                                    @input="onPointInput"
                                                    placeholder="사용할 포인트">
                                                <button type="button"
                                                    class="point-clear-btn"
                                                    v-if="Number(usePoint || 0) > 0"
                                                    @click="clearPoint">
                                                    ✕
                                                </button>
                                            </div>
                                            <button type="button" class="point-use-btn" @click="useAllPoint">
                                                전액사용
                                            </button>
                                        </div>
                                        <div class="point-help">
                                            최대 {{ formatPrice(maxUsePoint) }} 사용 가능
                                        </div>
                                    </div>

                                    <div class="aside-row" v-if="isLogin">
                                        <span>포인트 사용금액</span>
                                        <span class="val red">-{{ formatPrice(validUsePoint) }}</span>
                                    </div>

                                    <div class="aside-row">
                                        <span>총 배송비</span>
                                        <span class="val">0원</span>
                                    </div>

                                    <div class="aside-row total">
                                        <span>최종 결제금액</span>
                                        <span class="val">{{ formatPrice(finalTotal) }}</span>
                                    </div>
                                </div>

                                <button class="order-btn"
                                    :disabled="!agreeAll || orderItems.length === 0"
                                    @click="fnPay">
                                    {{ formatPrice(finalTotal) }} 결제하기
                                </button>

                                <div class="pay-info">결제 완료 후 취소/변경이 어려울 수 있습니다</div>
                            </div>
                        </div>

                    </div><!-- /checkout-layout -->
                </div><!-- /checkout-wrap -->

                <div v-if="addrModal.open" class="modal-overlay" @click.self="closeAddrModal">
                    <div class="modal-box addr-modal-box">
                        <div class="modal-header">
                            <span class="modal-title">
                                {{ addrModal.mode === 'add' ? '새 배송지 등록' : '배송지 변경' }}
                            </span>
                            <button class="modal-close" @click="closeAddrModal">✕</button>
                        </div>

                        <!-- ── 목록 모드 ── -->
                        <template v-if="addrModal.mode === 'list'">
                            <div class="addr-list">
                                <div v-for="addr in addressList" :key="addr.addressId"
                                    class="addr-select-item"
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

                            <!-- 새 배송지 추가 버튼 -->
                            <button class="addr-add-btn" @click="addrModal.mode = 'add'">
                                + 새 배송지 추가
                            </button>

                            <div class="modal-btns" style="margin-top:12px;">
                                <button class="modal-btn-cancel" @click="closeAddrModal">취소</button>
                                <button class="modal-btn-ok" @click="selectAddress">선택</button>
                            </div>
                        </template>

                        <!-- ── 새 배송지 등록 모드 ── -->
                        <template v-if="addrModal.mode === 'add'">
                            <div class="guest-addr-form">
                                <div class="guest-field-wrap">
                                    <span class="guest-field-label">별칭 *</span>
                                    <input class="guest-input" v-model="newAddr.addressAlias" placeholder="집, 회사 등" />
                                </div>
                                <div class="guest-field-wrap">
                                    <span class="guest-field-label">수령인 이름 *</span>
                                    <input class="guest-input" v-model="newAddr.receiverName" placeholder="홍길동" />
                                </div>
                                <div class="guest-field-wrap">
                                    <span class="guest-field-label">연락처 *</span>
                                    <input class="guest-input" v-model="newAddr.receiverPhone" placeholder="01012345678" />
                                </div>
                                <div class="guest-addr-row">
                                    <div class="guest-field-wrap zip">
                                        <span class="guest-field-label">우편번호 *</span>
                                        <div class="zipcode-row">
                                            <input class="guest-input" v-model="newAddr.zipCode"
                                                placeholder="06234" readonly />
                                            <button type="button" class="addr-search-btn" @click="fnSearchAddressNew">
                                                주소찾기
                                            </button>
                                        </div>
                                    </div>
                                    <div class="guest-field-wrap">
                                        <span class="guest-field-label">주소 *</span>
                                        <input class="guest-input" v-model="newAddr.address"
                                            placeholder="서울시 강남구 테헤란로 123" readonly />
                                    </div>
                                </div>
                                <div class="guest-field-wrap">
                                    <span class="guest-field-label">상세주소</span>
                                    <input class="guest-input optional"
                                        ref="newAddrDetailInput"
                                        v-model="newAddr.detailedAddress"
                                        placeholder="101동 202호" />
                                </div>
                                <label style="display:flex;align-items:center;gap:8px;font-size:13px;margin-top:8px;cursor:pointer;">
                                    <input type="checkbox" v-model="newAddr.defaultYn"> 기본 배송지로 설정
                                </label>
                            </div>

                            <p v-if="addrAddMsg" style="color:#e74c3c;font-size:12px;margin-top:8px;">{{ addrAddMsg }}</p>

                            <div class="modal-btns" style="margin-top:16px;">
                                <button class="modal-btn-cancel" @click="addrModal.mode = 'list'">← 목록으로</button>
                                <button class="modal-btn-ok" @click="saveNewAddressFromModal">저장하기</button>
                            </div>
                        </template>

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
                                addrModal: { open: false, mode: 'list' },
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
                                    receiverName: '',
                                    receiverPhone: '',
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
                                requestedUsePoint: 0,
                                currentStep: 1
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
                            },
                            remainPoint() {
                                return Math.max(0, Number(this.userPoint || 0) - Number(this.validUsePoint || 0));
                            }
                            
                        },
                        watch: {
                            selectedUserCouponId() {
                                this.clampUsePoint();
                            },
                            userPoint() {
                                this.clampUsePoint();
                            },
                            itemTotal() {
                                this.clampUsePoint();
                            }
                        },
                        methods: {
                            // ── 초기화 ──
                            init() {
                                const params = new URLSearchParams(location.search);
                                this.cartType = params.get('cartType') || 'RENTAL';
                                const ids = params.get('cartIds');
                                this.cartIds = ids ? ids.split(',').map(Number) : [];
                                let savedDiscount = {};
                                try {
                                    savedDiscount = JSON.parse(localStorage.getItem('checkout_discount') || '{}');
                                } catch (e) {
                                    savedDiscount = {};
                                }

                                const couponId = params.get('userCouponId') || savedDiscount.userCouponId || '';
                                this.selectedUserCouponId = couponId;

                                const usePoint = params.get('usePoint');

                                if (usePoint !== null && usePoint !== '') {
                                    this.requestedUsePoint = Number(usePoint || 0);
                                } else {
                                    this.requestedUsePoint = Number(savedDiscount.usePoint || 0);
                                }

                                this.usePoint = this.requestedUsePoint;

                                console.log("체크아웃 적용 쿠폰:", this.selectedUserCouponId);
                                console.log("체크아웃 적용 포인트:", this.usePoint);
                                
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
                                        // 체크아웃날짜확인용
                                        console.log("체크아웃 날짜 확인:", self.orderItems.map(item => ({
                                            productName: item.productName,
                                            rentalStart: item.rentalStart,
                                            rentalEnd: item.rentalEnd,
                                            startDate: item.startDate,
                                            endDate: item.endDate,
                                            rental_start: item.rental_start,
                                            rental_end: item.rental_end
                                        })));
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
                                            const raw = localStorage.getItem('checkout_items');
                                            self.orderItems = raw ? JSON.parse(raw) : [];

                                            console.log("비회원 체크아웃 상품:", self.orderItems);
                                        } else {
                                            const raw = localStorage.getItem('checkout_items');
                                            self.orderItems = raw ? JSON.parse(raw) : [];

                                            console.log("비회원 체크아웃 상품:", self.orderItems);
                                        }
                                    } catch (e) { self.orderItems = []; }
                                    return;
                                }

                                // ── 회원 + 바로구매 ──
                                if (isBuyNow) {
                                    try {
                                        const raw = localStorage.getItem('checkout_items');
                                        self.orderItems = raw ? JSON.parse(raw) : [];

                                        console.log("비회원 체크아웃 상품:", self.orderItems);
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
                                        console.log("회원 체크아웃 전체 응답:", res);

                                        if (res.result === 'success') {
                                            self.orderItems = res.list || [];
                                            self.$nextTick(function () {
                                                self.applyRequestedPoint();
                                            });

                                            console.log("회원 체크아웃 상품:", self.orderItems);
                                            console.log("체크아웃 날짜 확인:", self.orderItems.map(item => ({
                                                productName: item.productName,
                                                rentalStart: item.rentalStart,
                                                rentalEnd: item.rentalEnd,
                                                startDate: item.startDate,
                                                endDate: item.endDate
                                            })));
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
                                    url: '/coupon/availableList.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.couponList = res.list || [];
                                            if (self.selectedUserCouponId) {
                                                const exists = self.couponList.some(c =>
                                                    String(c.userCouponId) === String(self.selectedUserCouponId)
                                                );

                                                if (!exists) {
                                                    console.log("선택 쿠폰이 체크아웃 쿠폰 목록에 없음:", self.selectedUserCouponId);
                                                    self.selectedUserCouponId = '';
                                                    self.clearSavedDiscount();
                                                }
                                            }

                                            self.clampUsePoint();
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
                                            self.isPaying = false; 

                                            if ((res.message || '').includes('쿠폰')) {
                                                self.selectedUserCouponId = '';
                                                self.clearSavedDiscount();
                                                self.fetchCouponList();
                                            }

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
                            // ① 기존 selectAddress 수정 - addrModal.open = false → closeAddrModal() 로 변경
                            selectAddress() {
                                const addr = this.addressList.find(a => a.addressId === this.selectedAddressId);

                                if (!addr) {
                                    this.showToast('배송지를 선택해주세요.');
                                    return;
                                }

                                this.addrForm = { ...addr };
                                this.closeAddrModal();  // ← 여기만 변경
                            },

                            // ② 바로 아래에 새 메서드 추가
                            closeAddrModal() {
                                this.addrModal.open = false;
                                this.addrModal.mode = 'list';
                                this.addrAddMsg = '';
                                this.newAddr = {
                                    addressAlias: '',
                                    receiverName: '',
                                    receiverPhone: '',
                                    zipCode: '',
                                    address: '',
                                    detailedAddress: '',
                                    defaultYn: false
                                };
                            },

                            fnSearchAddressNew() {
                                let self = this;
                                new daum.Postcode({
                                    oncomplete(data) {
                                        self.newAddr.zipCode = data.zonecode;
                                        self.newAddr.address = data.roadAddress || data.jibunAddress;
                                        self.$nextTick(() => {
                                            if (self.$refs.newAddrDetailInput) {
                                                self.$refs.newAddrDetailInput.focus();
                                            }
                                        });
                                    }
                                }).open();
                            },

                            saveNewAddressFromModal() {
                                let self = this;
                                self.addrAddMsg = '';

                                if (!self.newAddr.addressAlias.trim()) { self.addrAddMsg = '별칭을 입력해주세요.'; return; }
                                if (!self.newAddr.receiverName.trim()) { self.addrAddMsg = '수령인 이름을 입력해주세요.'; return; }
                                if (!self.newAddr.receiverPhone.trim()) { self.addrAddMsg = '연락처를 입력해주세요.'; return; }
                                if (!self.newAddr.zipCode.trim()) { self.addrAddMsg = '우편번호를 입력해주세요.'; return; }
                                if (!self.newAddr.address.trim()) { self.addrAddMsg = '주소를 입력해주세요.'; return; }

                                $.ajax({
                                    url: '/user/address/add.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        addressAlias:    self.newAddr.addressAlias,
                                        receiverName:    self.newAddr.receiverName,    
                                        receiverPhone:   self.newAddr.receiverPhone,   
                                        zipCode:         self.newAddr.zipCode,
                                        address:         self.newAddr.address,
                                        detailedAddress: self.newAddr.detailedAddress,
                                        defaultYn:       self.newAddr.defaultYn ? 'Y' : 'N'
                                    },
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.showToast('배송지가 저장됐어요.');
                                            self.newAddr = {
                                                addressAlias: '',
                                                receiverName: '',
                                                receiverPhone: '',
                                                zipCode: '',
                                                address: '',
                                                detailedAddress: '',
                                                defaultYn: false
                                            };
                                            self.addrModal.mode = 'list';
                                            self.fetchAddressList();
                                            self.addrAddMsg = '';
                                        } else {
                                            self.addrAddMsg = res.message || '저장에 실패했습니다.';
                                        }
                                    },
                                    error() { self.addrAddMsg = '서버 오류가 발생했습니다.'; }
                                });
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

                                            self.$nextTick(function () {
                                                self.applyRequestedPoint();
                                            });
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
                            onPointInput(e) {
                                let val = String(e.target.value || '').replace(/[^0-9]/g, '');
                                let point = Number(val || 0);

                                if (point > this.maxUsePoint) {
                                    point = this.maxUsePoint;
                                    this.showToast('사용 가능한 포인트를 초과할 수 없습니다.');
                                }

                                this.usePoint = point;
                                e.target.value = point;
                            },

                            clampUsePoint() {
                                if (Number(this.itemTotal || 0) <= 0) {
                                    return;
                                }

                                if (Number(this.userPoint || 0) <= 0 && Number(this.usePoint || 0) > 0) {
                                    return;
                                }

                                let point = Number(this.usePoint || 0);

                                if (point < 0) point = 0;
                                if (point > this.maxUsePoint) point = this.maxUsePoint;

                                this.usePoint = point;
                            },
                            applyRequestedPoint() {
                                if (Number(this.requestedUsePoint || 0) <= 0) {
                                    this.clampUsePoint();
                                    return;
                                }

                                if (Number(this.itemTotal || 0) <= 0) {
                                    return;
                                }

                                if (Number(this.userPoint || 0) <= 0) {
                                    return;
                                }

                                this.usePoint = Math.min(
                                    Number(this.requestedUsePoint || 0),
                                    Number(this.maxUsePoint || 0)
                                );

                                this.clampUsePoint();
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
                                if (!self.newAddr.zipCode.trim()) { self.addrAddMsg = '우편번호를 입력해주세요.'; return; }
                                if (!self.newAddr.address.trim()) { self.addrAddMsg = '주소를 입력해주세요.'; return; }

                                $.ajax({
                                    url: '/user/address/add.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        addressAlias: self.newAddr.addressAlias,
                                        zipCode: self.newAddr.zipCode,
                                        address: self.newAddr.address,
                                        detailedAddress: self.newAddr.detailedAddress,
                                        defaultYn: self.newAddr.defaultYn ? 'Y' : 'N'
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
                            openGuestPostcode() {
                                new daum.Postcode({
                                    oncomplete: (data) => {
                                        this.guestZipcode = data.zonecode;
                                        this.guestAddress = data.roadAddress || data.jibunAddress;

                                        this.$nextTick(() => {
                                            const detailInput = document.querySelector('.guest-input.optional');
                                            if (detailInput) detailInput.focus();
                                        });
                                    }
                                }).open();
                            },
                            normalizeDateValue(value) {
                                if (!value) return '';

                                const str = String(value).trim();

                                // 2026-05-04 또는 2026-05-04T00:00:00
                                if (/^\d{4}-\d{2}-\d{2}/.test(str)) {
                                    return str.substring(0, 10);
                                }

                                // 2026/05/04, 2026.05.04
                                let m = str.match(/^(\d{4})[./](\d{1,2})[./](\d{1,2})/);
                                if (m) {
                                    return m[1] + '-'
                                        + String(m[2]).padStart(2, '0') + '-'
                                        + String(m[3]).padStart(2, '0');
                                }

                                // 5월 4, 2026
                                m = str.match(/^(\d{1,2})월\s*(\d{1,2}),\s*(\d{4})$/);
                                if (m) {
                                    return m[3] + '-'
                                        + String(m[1]).padStart(2, '0') + '-'
                                        + String(m[2]).padStart(2, '0');
                                }

                                return '';
                            },
                            formatDate(date) {
                                return this.normalizeDateValue(date);
                            },

                            formatRentalRange(start, end) {
                                const s = this.normalizeDateValue(start);
                                const e = this.normalizeDateValue(end);

                                if (!s || !e) return '';

                                return s + ' ~ ' + e;
                            },

                            calcNights(start, end) {
                                const s = this.normalizeDateValue(start);
                                const e = this.normalizeDateValue(end);

                                if (!s || !e) return 0;

                                const startDate = new Date(s + 'T00:00:00');
                                const endDate = new Date(e + 'T00:00:00');

                                if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) return 0;

                                return Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
                            },
                            openAddrModal() {
                                // 배송지 추가할때 혹시 남아있는 값 초기화
                                this.newAddr = {
                                    addressAlias: '',
                                    receiverName: '',
                                    receiverPhone: '',
                                    zipCode: '',
                                    address: '',
                                    detailedAddress: '',
                                    defaultYn: false
                                };
                                this.addrAddMsg = '';
                                this.addrModal.mode = 'list';
                                this.addrModal.open = true;
                            },
                            clearSavedDiscount() {
                                localStorage.removeItem('checkout_discount');

                                const url = new URL(window.location.href);
                                url.searchParams.delete('userCouponId');
                                url.searchParams.delete('usePoint');

                                window.history.replaceState({}, '', url.toString());
                            },
                        },
                        mounted() {
                            this.init();
                            this.checkLogin();

                            // 상단 진행바 자동감지
                            const path = location.pathname;

                            if (path.includes('/cart')) {
                                this.currentStep = 1;
                            } else if (path.includes('/payment/checkout')) {
                                this.currentStep = 2;
                            } else if (path.includes('/payment/success')) {
                                this.currentStep = 3;
                            }
                        }
                    });

                    app.mount('#app');
                </script>
    </body>

    </html>