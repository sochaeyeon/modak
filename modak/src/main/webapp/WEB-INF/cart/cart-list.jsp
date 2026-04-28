<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>장바구니 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/cart/cart-list.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app" v-cloak>

                <div class="step-wrap">
                    <div class="step active">장바구니</div>
                    <div class="step-line"></div>
                    <div class="step">주문결제</div>
                    <div class="step-line"></div>
                    <div class="step">완료</div>
                </div>

                <div class="cart-wrap">

                    <div class="cart-tabs">
                        <div class="tab-menu">
                            <div class="tab-item" :class="{ active: activeTab === 'RENTAL' }"
                                @click="switchTab('RENTAL')">
                                대여 장바구니
                            </div>

                            <div class="tab-item" :class="{ active: activeTab === 'PURCHASE' }"
                                @click="switchTab('PURCHASE')">
                                구매 장바구니
                            </div>

                            <!-- 움직이는 밑줄 -->
                            <div class="tab-underline" :style="underlineStyle"></div>
                        </div>
                    </div>

                    <div class="cart-layout">

                        <!-- 메인 영역 -->
                        <div class="cart-main">

                            <!-- 전체선택 바 -->
                            <div class="select-bar">
                                <div class="select-bar-left">
                                    <div class="chk" :class="{ on: isAllChecked }" @click="toggleAll"></div>
                                    <span>전체 선택</span>
                                </div>
                                <button class="del-btn" @click="deleteSelected">
                                    <span>✕</span> 선택 삭제
                                </button>
                            </div>

                            <!-- 빈 카트 -->
                            <div v-if="filteredCart.length === 0" class="empty-cart">
                                <div class="icon">🛒</div>
                                <div>장바구니가 비어있습니다.</div>
                            </div>

                            <!-- 브랜드별 그룹 카드 -->
                            <div v-for="group in groupedCart" :key="group.brandName" class="cart-card">

                                <div class="cart-card-header">
                                    <div class="chk" :class="{ on: isBrandChecked(group) }" @click="toggleBrand(group)">
                                    </div>
                                    <span>{{ group.brandName || '모닥모닥' }}</span>
                                </div>

                                <div v-for="item in group.items" :key="item.cartId" class="cart-item">
                                    <div class="cart-item-top">
                                        <div class="chk" style="margin-top:4px;"
                                            :class="{ on: checkedIds.includes(item.cartId) }"
                                            @click.stop="toggleItem(item.cartId)">
                                        </div>

                                        <div class="cart-item-img" @click.stop="goDetail(item.productId)"
                                            style="cursor:pointer;">
                                            <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName">
                                            <span v-else
                                                style="font-size:36px;display:flex;align-items:center;justify-content:center;height:100%;">🏕️</span>
                                        </div>

                                        <div class="cart-item-info">
                                            <div class="cart-item-badge">배송무료</div>
                                            <div class="cart-item-name">
                                                {{ item.productName }}
                                                <span class="cart-item-option">
                                                    {{ item.optionName }}
                                                </span>
                                            </div>
                                            <div class="cart-item-price">
                                                {{ formatPrice(item.unitPrice || item.price) }}
                                                <span v-if="item.cartType === 'RENTAL'" class="rental-price-info">
                                                    (대여료 {{ formatPrice(rentalFee(item)) }}<span v-if="item.deposit > 0"> / 보증금 {{ formatPrice(depositFee(item)) }}</span>)
                                                </span>
                                            </div>
                                            <div v-if="activeTab === 'RENTAL' && item.rentalStart" class="rental-dates">
                                                📅 {{ item.rentalStart }} ~ {{ item.rentalEnd }}
                                                <span
                                                    style="background:var(--orange);color:#fff;border-radius:4px;padding:1px 6px;font-size:11px;">
                                                    {{ calcNights(item.rentalStart, item.rentalEnd) }}박
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cart-item-bottom">
                                        <div class="qty-ctrl">
                                            <button class="qty-btn" @click="chgItemQty(item, -1)">−</button>
                                            <div class="qty-num">{{ item.quantity }}</div>
                                            <button class="qty-btn" @click="chgItemQty(item, 1)">+</button>
                                        </div>
                                        <div class="item-total">
                                            {{ formatPrice(cartItemTotal(item)) }} <button
                                                class="item-del-btn" @click.stop="deleteItem(item.cartId)"
                                                title="삭제">✕</button>
                                        </div>
                                    </div>

                                    <button class="opt-change-btn" @click.stop="toggleInlineOption(item)">
                                        {{ inlineOption.cartId === item.cartId ? '옵션 닫기' : '옵션 변경' }}
                                    </button>
                                    <div v-if="inlineOption.cartId === item.cartId" class="inline-option-box"
                                        @click.stop>
                                        <div v-for="(opts, optionName) in inlineGroupedOptions" :key="optionName"
                                            class="inline-option-group">
                                            <div class="inline-option-name">{{ optionName }}</div>

                                            <div class="inline-option-list">
                                                <button type="button" v-for="opt in opts" :key="opt.optionValueId"
                                                    class="inline-option-chip"
                                                    :class="{ active: inlineOption.selectedOptions[optionName] && inlineOption.selectedOptions[optionName].optionValueId === opt.optionValueId }"
                                                    @click="selectInlineOption(optionName, opt)">
                                                    {{ opt.optionValue }}
                                                    <span v-if="opt.addPrice > 0">+{{ formatPrice(opt.addPrice)
                                                        }}</span>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="inline-option-actions">
                                            <button type="button" class="inline-option-cancel"
                                                @click="closeInlineOption">취소</button>
                                            <button type="button" class="inline-option-apply"
                                                @click="applyInlineOption(item)">변경 완료</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="cart-subtotal">
                                    <div class="row">
                                        <span style="color:var(--muted)">총 배송비</span>
                                        <span>0원</span>
                                    </div>
                                    <div class="row total">
                                        <span>예상 주문금액</span>
                                        <span style="color:var(--orange)">{{ formatPrice(groupTotal(group)) }}</span>
                                    </div>
                                </div>
                            </div>

                        </div><!-- /cart-main -->

                        <!-- 우측 사이드바 -->
                        <div class="cart-aside">
                            <div class="aside-box">
                                <div class="aside-title">주문 예상 금액</div>
                                <div class="aside-rows">
                                    <div class="aside-row">
                                        <span>총 선택상품금액</span>
                                        <span class="val">{{ formatPrice(selectedTotal) }}</span>
                                    </div>

                                    <!-- 쿠폰: 회원만 -->
                                    <div class="coupon-box" v-if="isLogin">
                                        <div class="coupon-title">쿠폰 선택</div>
                                        <select class="coupon-select" v-model="selectedUserCouponId">
                                            <option value="">쿠폰 사용 안함</option>
                                            <option v-for="coupon in usableCouponList" :key="coupon.userCouponId"
                                                :value="coupon.userCouponId"
                                                :disabled="selectedTotal < coupon.minOrderAmt">
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
                                        쿠폰을 사용할 수 있습니다.
                                    </div>

                                    <div class="aside-row" v-if="isLogin">
                                        <span>쿠폰할인예상금액</span>
                                        <span class="val red">-{{ formatPrice(couponDiscount) }}</span>
                                    </div>
                                    <div class="point-box" v-if="isLogin">
                                        <div class="point-title">
                                            <span>포인트 사용</span>
                                            <span>보유 {{ formatPrice(userPoint) }}</span>
                                        </div>

                                        <div class="point-input-row">
                                            <input type="number" class="point-input" v-model.number="usePoint" min="0"
                                                :max="maxUsePoint" placeholder="사용할 포인트">

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
                                        <span>총 주문 예상 금액</span>
                                        <span class="val">{{ formatPrice(finalTotal) }}</span>
                                    </div>
                                </div>
                                <button class="order-btn" :disabled="checkedIds.length === 0" @click="fnOrder">
                                    주문하기
                                    <span class="order-badge">{{ checkedIds.length }}</span>
                                </button>
                            </div>
                        </div>

                        <!-- 상품 추가하기 -->
                        <div class="cart-more-box">
                            <button class="cart-more-btn" @click="goProductList">+ 더 담으러 가기</button>
                        </div>

                    </div><!-- /cart-layout -->
                </div><!-- /cart-wrap -->

                <!-- 옵션 변경 모달 -->
                <div v-if="optModal.open" class="modal-overlay" @click.self="optModal.open = false">
                    <div class="modal-box">
                        <div class="modal-header">
                            <span class="modal-title">옵션 변경</span>
                            <button class="modal-close" @click="optModal.open = false">✕</button>
                        </div>

                        <div class="modal-product" v-if="optModal.item">
                            <img :src="optModal.item.imgUrl || '/img/product/default.jpg'"
                                :alt="optModal.item.productName">
                            <div>
                                <div class="modal-product-name">{{ optModal.item.productName }}</div>
                                <div class="modal-product-price">{{ formatPrice(optModal.item.price) }}</div>
                            </div>
                        </div>

                        <!-- 대여: 캘린더 -->
                        <div v-if="activeTab === 'RENTAL'">
                            <div class="modal-info-row">
                                <span class="modal-info-label">배송방법</span><span>직접배송</span>
                            </div>
                            <div class="modal-info-row">
                                <span class="modal-info-label">배송비</span><span>무료</span>
                            </div>

                            <div style="border:1px solid #eee;border-radius:10px;padding:14px;margin:12px 0;">
                                <div class="cal-nav">
                                    <button @click="changeModalMonth(-1)">‹</button>
                                    <span style="font-size:14px;font-weight:700;">
                                        {{ optModal.year }}년 {{ optModal.month + 1 }}월
                                    </span>
                                    <button @click="changeModalMonth(1)">›</button>
                                </div>
                                <div class="cal-grid">
                                    <div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">{{w}}
                                    </div>
                                    <div v-for="(day, idx) in modalCalDays" :key="idx" :class="getModalDayClass(day)"
                                        @click="onModalDayClick(day)">
                                        <span v-if="day">{{ day.date }}</span>
                                    </div>
                                </div>

                                <div v-if="optModal.optionList && optModal.optionList.length > 0"
                                    style="margin-top:10px;">
                                    <div style="font-size:13px;color:var(--muted);margin-bottom:6px;">옵션 선택</div>
                                    <div class="opt-list">
                                        <div v-for="opt in optModal.optionList" :key="opt.optionId" class="opt-item"
                                            :class="{ active: String(optModal.selectedOption) === String(opt.optionId) }"
                                            @click="optModal.selectedOption = opt.optionId">
                                            {{ opt.optionValue }}
                                        </div>
                                    </div>
                                </div>

                                <div class="date-result">
                                    <div v-if="optModal.startDate && optModal.endDate"
                                        style="color:#333;font-weight:600;">
                                        📅 {{ optModal.startDate }} ~ {{ optModal.endDate }}
                                        <span style="color:var(--orange);margin-left:6px;">
                                            {{ calcNights(optModal.startDate, optModal.endDate) }}박
                                        </span>
                                    </div>
                                    <div v-else-if="optModal.startDate" style="color:var(--orange);">종료일을 선택해주세요.</div>
                                    <div v-else style="color:#bbb;">시작일을 선택해주세요.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 구매: 수량/옵션 -->
                        <div v-else style="margin:16px 0;">
                            <div v-if="optModal.optionList && optModal.optionList.length > 0">
                                <div style="font-size:13px;color:var(--muted);margin-bottom:10px;">옵션 선택</div>
                                <div class="opt-list">
                                    <div v-for="opt in optModal.optionList" :key="opt.optionId" class="opt-item"
                                        :class="{ active: String(optModal.selectedOption) === String(opt.optionId) }"
                                        @click="optModal.selectedOption = opt.optionId">
                                        {{ opt.optionValue }}
                                    </div>
                                </div>
                            </div>
                            <div v-else>
                                <div style="font-size:13px;color:var(--muted);margin-bottom:10px;">수량</div>
                                <div style="display:flex;align-items:center;">
                                    <button class="qty-btn"
                                        @click="optModal.qty = Math.max(1, optModal.qty - 1)">−</button>
                                    <div class="qty-num">{{ optModal.qty }}</div>
                                    <button class="qty-btn" @click="optModal.qty++">+</button>
                                </div>
                            </div>
                        </div>

                        <div class="modal-price-row">
                            <span class="modal-price-label">상품금액</span>
                            <div>
                                <div class="modal-price-val">{{ optModal.item ? formatPrice(calcModalTotal()) : '0원' }}
                                </div>
                                <div style="font-size:11px;color:var(--muted);text-align:right;">
                                    {{ activeTab === 'RENTAL' && optModal.startDate && optModal.endDate
                                    ? calcNights(optModal.startDate, optModal.endDate) + '박' : '' }}
                                </div>
                            </div>
                        </div>

                        <div class="modal-btns">
                            <button class="modal-btn-cancel" @click="optModal.open = false">취소</button>
                            <button class="modal-btn-ok"
                                :disabled="activeTab === 'RENTAL' && (!optModal.startDate || !optModal.endDate)"
                                @click="applyOptChange">
                                변경 완료
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 확인 모달 -->
                <div v-if="confirmModal.open" class="confirm-overlay" @click.self="confirmCancel">
                    <div class="confirm-box">
                        <div class="confirm-title">알림</div>
                        <div class="confirm-message">{{ confirmModal.message }}</div>
                        <div class="confirm-btns">
                            <button class="confirm-cancel" @click="confirmCancel">{{ confirmModal.cancelText }}</button>
                            <button class="confirm-ok" @click="confirmOk">{{ confirmModal.okText }}</button>
                        </div>
                    </div>
                </div>

            </div><!-- /#app -->

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    function showToast(msg) {
                        var t = document.getElementById('toast');
                        if (!t) {
                            t = document.createElement('div');
                            t.id = 'toast';
                            t.style.cssText =
                                'position:fixed;bottom:30px;left:50%;transform:translateX(-50%);' +
                                'background:#333;color:#fff;padding:10px 20px;border-radius:8px;' +
                                'font-size:13px;z-index:9999;display:none;';
                            document.body.appendChild(t);
                        }
                        t.textContent = msg;
                        t.style.display = 'block';
                        setTimeout(function () {
                            t.style.display = 'none';
                        }, 2200);
                    }

                    var LS_KEY = 'modak_guest_cart';

                    const app = Vue.createApp({
                        data() {
                            return {
                                activeTab: new URLSearchParams(location.search).get('cartType') || 'PURCHASE',
                                cartList: [],
                                checkedIds: [],
                                isLogin: false,

                                optModal: {
                                    open: false,
                                    item: null,
                                    qty: 1,
                                    startDate: null,
                                    endDate: null,
                                    year: new Date().getFullYear(),
                                    month: new Date().getMonth(),
                                    selectedOption: null,
                                    optionList: []
                                },

                                confirmModal: {
                                    open: false,
                                    message: '',
                                    okText: '확인',
                                    cancelText: '취소',
                                    onOk: null
                                },

                                couponList: [],
                                selectedUserCouponId: '',
                                inlineOption: {
                                    cartId: null,
                                    optionList: [],
                                    selectedOptions: {}
                                },
                                userPoint: 0,
                                usePoint: 0,
                            };
                        },

                        computed: {
                            underlineStyle() {
                                if (this.activeTab === 'RENTAL') {
                                    return {
                                        width: '50%',
                                        transform: 'translateX(0%)'
                                    };
                                } else {
                                    return {
                                        width: '50%',
                                        transform: 'translateX(100%)'
                                    };
                                }
                            },
                            usableCouponList() {
                                return this.couponList.filter(coupon => {
                                    const target = String(
                                        coupon.issueTarget ||
                                        coupon.issue_target ||
                                        coupon.ISSUE_TARGET ||
                                        'ALL'
                                    ).toUpperCase();

                                    // 대여 전용 쿠폰
                                    if (target === 'RENTAL') {
                                        return this.activeTab === 'RENTAL';
                                    }

                                    // 구매 전용 쿠폰
                                    if (target === 'PURCHASE') {
                                        return this.activeTab === 'PURCHASE';
                                    }

                                    // 공통 쿠폰 또는 등급/신규회원 쿠폰
                                    return target === 'ALL'
                                        || target === 'SILVER'
                                        || target === 'GOLD'
                                        || target === 'NEW_USER';
                                });
                            },
                            inlineGroupedOptions() {
                                const groups = {};

                                this.inlineOption.optionList.forEach(opt => {
                                    if (!groups[opt.optionName]) {
                                        groups[opt.optionName] = [];
                                    }
                                    groups[opt.optionName].push(opt);
                                });

                                return groups;
                            },
                            filteredCart() {
                                return this.cartList.filter(c => c.cartType === this.activeTab);
                            },

                            groupedCart() {
                                const groups = {};
                                this.filteredCart.forEach(item => {
                                    const key = item.brandName || '모닥모닥';
                                    if (!groups[key]) {
                                        groups[key] = { brandName: key, items: [] };
                                    }
                                    groups[key].items.push(item);
                                });
                                return Object.values(groups);
                            },

                            isAllChecked() {
                                if (!this.filteredCart.length) return false;
                                return this.filteredCart.every(c => this.checkedIds.includes(c.cartId));
                            },

                            selectedTotal() {
                                return this.filteredCart
                                    .filter(c => this.checkedIds.includes(c.cartId))
                                    .reduce((sum, c) => sum + this.cartItemTotal(c), 0);
                            },

                            modalCalDays() {
                                const year = this.optModal.year;
                                const month = this.optModal.month;
                                const firstDay = new Date(year, month, 1).getDay();
                                const lastDate = new Date(year, month + 1, 0).getDate();
                                const today = new Date();
                                today.setHours(0, 0, 0, 0);

                                const days = [];

                                for (let i = 0; i < firstDay; i++) {
                                    days.push(null);
                                }

                                for (let d = 1; d <= lastDate; d++) {
                                    const dateObj = new Date(year, month, d);
                                    const checkDate = new Date(dateObj);
                                    checkDate.setHours(0, 0, 0, 0);

                                    days.push({
                                        date: d,
                                        full: this.fmtDate(dateObj),
                                        isPast: checkDate < today
                                    });
                                }

                                return days;
                            },

                            selectedCoupon() {
                                return this.usableCouponList.find(c =>
                                    String(c.userCouponId) === String(this.selectedUserCouponId)
                                ) || null;
                            },
                            couponDiscount() {
                                if (!this.isLogin) return 0;

                                const coupon = this.selectedCoupon;
                                if (!coupon) return 0;
                                if (this.selectedTotal < Number(coupon.minOrderAmt || 0)) return 0;

                                let discount = 0;

                                if (coupon.couponType === 'AMOUNT') {
                                    discount = Number(coupon.discountAmt || 0);
                                } else if (coupon.couponType === 'RATE') {
                                    discount = Math.floor(this.selectedTotal * Number(coupon.discountRate || 0) / 100);
                                    if (Number(coupon.maxDiscountAmt || 0) > 0) {
                                        discount = Math.min(discount, Number(coupon.maxDiscountAmt));
                                    }
                                }

                                return Math.min(discount, this.selectedTotal);
                            },

                            maxUsePoint() {
                                return Math.min(
                                    Number(this.userPoint || 0),
                                    Math.max(0, this.selectedTotal - this.couponDiscount)
                                );
                            },

                            validUsePoint() {
                                let point = Number(this.usePoint || 0);

                                if (point < 0) point = 0;
                                if (point > this.maxUsePoint) point = this.maxUsePoint;

                                return point;
                            },

                            finalTotal() {
                                return Math.max(
                                    0,
                                    this.selectedTotal - this.couponDiscount - this.validUsePoint
                                );
                            }
                        }, watch: {
                            usableCouponList() {
                                const exists = this.usableCouponList.some(c =>
                                    String(c.userCouponId) === String(this.selectedUserCouponId)
                                );

                                if (!exists) {
                                    this.selectedUserCouponId = '';
                                }
                            },
                            activeTab() {
                                this.selectedUserCouponId = '';
                                this.usePoint = 0;
                            },

                            selectedUserCouponId() {
                                if (this.usePoint > this.maxUsePoint) {
                                    this.usePoint = this.maxUsePoint;
                                }
                            },

                            checkedIds() {
                                if (this.usePoint > this.maxUsePoint) {
                                    this.usePoint = this.maxUsePoint;
                                }
                            }
                        },

                        methods: {
                            loadGuestCart() {
                                try {
                                    const raw = localStorage.getItem(LS_KEY);
                                    this.cartList = raw ? JSON.parse(raw) : [];
                                } catch (e) {
                                    this.cartList = [];
                                }
                            },

                            saveGuestCart() {
                                localStorage.setItem(LS_KEY, JSON.stringify(this.cartList));
                            },

                            checkLogin() {
                                let self = this;

                                $.ajax({
                                    url: '/user/session-check.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    success(res) {
                                        self.isLogin = res.isLogin === true;

                                        if (self.isLogin) {
                                            self.fetchCartList();
                                            self.fetchCouponList();
                                            self.fetchUserPoint();
                                        } else {
                                            self.loadGuestCart();
                                        }
                                    },
                                    error() {
                                        self.isLogin = false;
                                        self.loadGuestCart();
                                    }
                                });
                            },

                            fetchCartList() {
                                let self = this;

                                $.ajax({
                                    url: '/cart/list.dox',
                                    type: 'POST',
                                    data: { cartType: self.activeTab },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            console.log(res);
                                            self.cartList = res.list || [];
                                            self.checkedIds = [];
                                        }
                                    }
                                });
                            },

                            fetchCouponList() {
                                let self = this;

                                $.ajax({
                                    url: '/coupon/myCouponList.dox',
                                    type: 'POST',
                                    data: {
                                        start: 0,
                                        pageSize: 100
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            console.log(res);
                                            self.couponList = res.list || [];
                                        }
                                    }
                                });
                            },

                            switchTab(tab) {
                                this.activeTab = tab;
                                this.checkedIds = [];
                                this.selectedUserCouponId = '';

                                if (this.isLogin) {
                                    this.fetchCartList();
                                }
                            },

                            toggleAll() {
                                const ids = this.filteredCart.map(c => c.cartId);

                                if (this.isAllChecked) {
                                    this.checkedIds = this.checkedIds.filter(id => !ids.includes(id));
                                } else {
                                    ids.forEach(id => {
                                        if (!this.checkedIds.includes(id)) {
                                            this.checkedIds.push(id);
                                        }
                                    });
                                }
                            },

                            isBrandChecked(group) {
                                return group.items.every(c => this.checkedIds.includes(c.cartId));
                            },

                            toggleBrand(group) {
                                const ids = group.items.map(c => c.cartId);

                                if (this.isBrandChecked(group)) {
                                    this.checkedIds = this.checkedIds.filter(id => !ids.includes(id));
                                } else {
                                    ids.forEach(id => {
                                        if (!this.checkedIds.includes(id)) {
                                            this.checkedIds.push(id);
                                        }
                                    });
                                }
                            },

                            toggleItem(cartId) {
                                const idx = this.checkedIds.indexOf(cartId);

                                if (idx > -1) {
                                    this.checkedIds.splice(idx, 1);
                                } else {
                                    this.checkedIds.push(cartId);
                                }
                            },

                            chgItemQty(item, d) {
                                const next = Number(item.quantity || 1) + d;
                                if (next < 1) return;

                                item.quantity = next;

                                if (!this.isLogin) {
                                    this.saveGuestCart();
                                    return;
                                }

                                $.ajax({
                                    url: '/cart/update.dox',
                                    type: 'POST',
                                    data: {
                                        cartId: item.cartId,
                                        quantity: next
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result !== 'success') {
                                            showToast('수량 변경에 실패했습니다.');
                                        }
                                    }
                                });
                            },

                            deleteItem(cartId) {
                                let self = this;

                                self.openConfirm('해당 상품을 삭제하시겠습니까?', function () {
                                    if (!self.isLogin) {
                                        self.cartList = self.cartList.filter(c => c.cartId !== cartId);
                                        self.checkedIds = self.checkedIds.filter(id => id !== cartId);
                                        self.saveGuestCart();
                                        showToast('삭제됐어요.');
                                        return;
                                    }

                                    $.ajax({
                                        url: '/cart/delete.dox',
                                        type: 'POST',
                                        data: { cartId: cartId },
                                        dataType: 'json',
                                        success(res) {
                                            if (res.result === 'success') {
                                                self.cartList = self.cartList.filter(c => c.cartId !== cartId);
                                                self.checkedIds = self.checkedIds.filter(id => id !== cartId);
                                                showToast('삭제됐어요.');
                                            } else {
                                                showToast('삭제에 실패했습니다.');
                                            }
                                        }
                                    });
                                }, '삭제하기');
                            },

                            deleteSelected() {
                                if (!this.checkedIds.length) {
                                    showToast('선택된 상품이 없습니다.');
                                    return;
                                }

                                let self = this;
                                const deleteIds = [...self.checkedIds];

                                self.openConfirm(deleteIds.length + '개 상품을 삭제하시겠습니까?', function () {
                                    if (!self.isLogin) {
                                        self.cartList = self.cartList.filter(c => !deleteIds.includes(c.cartId));
                                        self.checkedIds = [];
                                        self.saveGuestCart();
                                        showToast('선택 상품이 삭제됐어요.');
                                        return;
                                    }

                                    $.ajax({
                                        url: '/cart/deleteSelected.dox',
                                        type: 'POST',
                                        data: { cartIds: deleteIds.join(',') },
                                        dataType: 'json',
                                        success(res) {
                                            if (res.result === 'success') {
                                                self.cartList = self.cartList.filter(c => !deleteIds.includes(c.cartId));
                                                self.checkedIds = [];
                                                showToast('선택 상품이 삭제됐어요.');
                                            } else {
                                                showToast('삭제에 실패했습니다.');
                                            }
                                        }
                                    });
                                }, '삭제하기');
                            },

                            fnOrder() {
                                if (!this.checkedIds.length) {
                                    showToast('상품을 선택해주세요.');
                                    return;
                                }

                                const usePoint = Number(this.validUsePoint || 0);

                                if (!this.isLogin) {
                                    const selected = this.filteredCart.filter(c => this.checkedIds.includes(c.cartId));
                                    localStorage.setItem('checkout_items', JSON.stringify(selected));
                                    location.href = '/payment/checkout.do?cartType=' + this.activeTab + '&isGuest=true';
                                    return;
                                }

                                let url =
                                    '/payment/checkout.do'
                                    + '?cartIds=' + this.checkedIds.join(',')
                                    + '&cartType=' + this.activeTab
                                    + '&usePoint=' + usePoint;

                                if (this.selectedUserCouponId) {
                                    url += '&userCouponId=' + this.selectedUserCouponId;
                                }

                                location.href = url;
                            },

                            openOptModal(item) {
                                let self = this;

                                self.optModal = {
                                    open: true,
                                    item: { ...item },
                                    qty: Number(item.quantity || 1),
                                    startDate: item.rentalStart || null,
                                    endDate: item.rentalEnd || null,
                                    year: new Date().getFullYear(),
                                    month: new Date().getMonth(),
                                    selectedOption: Number(item.optionId) || null,
                                    optionList: []
                                };

                                $.ajax({
                                    url: '/product/option/list.dox',
                                    type: 'POST',
                                    data: { productId: item.productId },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.optModal.optionList = res.list || [];
                                        }
                                    }
                                });
                            },

                            changeModalMonth(diff) {
                                const d = new Date(this.optModal.year, this.optModal.month + diff, 1);
                                this.optModal.year = d.getFullYear();
                                this.optModal.month = d.getMonth();
                            },

                            getModalDayClass(day) {
                                if (!day) return 'cal-day empty';
                                if (day.isPast) return 'cal-day past';

                                if (day.full === this.optModal.startDate || day.full === this.optModal.endDate) {
                                    return 'cal-day selected';
                                }

                                if (
                                    this.optModal.startDate &&
                                    this.optModal.endDate &&
                                    day.full > this.optModal.startDate &&
                                    day.full < this.optModal.endDate
                                ) {
                                    return 'cal-day in-range';
                                }

                                return 'cal-day available';
                            },

                            onModalDayClick(day) {
                                if (!day || day.isPast) return;

                                if (!this.optModal.startDate || (this.optModal.startDate && this.optModal.endDate)) {
                                    this.optModal.startDate = day.full;
                                    this.optModal.endDate = null;
                                } else {
                                    if (day.full < this.optModal.startDate) {
                                        this.optModal.startDate = day.full;
                                    } else if (day.full === this.optModal.startDate) {
                                        this.optModal.startDate = null;
                                    } else {
                                        this.optModal.endDate = day.full;
                                    }
                                }
                            },

                            calcModalTotal() {
                                const item = this.optModal.item;
                                if (!item) return 0;

                                if (this.activeTab === 'RENTAL') {
                                    const nights = this.calcNights(this.optModal.startDate, this.optModal.endDate) || 1;
                                    return (Number(item.price || 0) * nights) + Number(item.deposit || 0);
                                }

                                return Number(item.price || 0) * Number(this.optModal.qty || 1);
                            },

                            applyOptChange() {
                                const m = this.optModal;

                                if (this.activeTab === 'RENTAL' && (!m.startDate || !m.endDate)) {
                                    showToast('날짜를 선택해주세요.');
                                    return;
                                }

                                if (!this.isLogin) {
                                    const target = this.cartList.find(c => c.cartId === m.item.cartId);

                                    if (target) {
                                        target.quantity = m.qty;
                                        // (모달에서 selectedOption이 optionValueId인지 확인 필요)
                                        target.rentalStart = m.startDate || null;
                                        target.rentalEnd = m.endDate || null;
                                    }

                                    this.saveGuestCart();
                                    this.optModal.open = false;
                                    showToast('변경됐어요.');
                                    return;
                                }

                                let self = this;

                                $.ajax({
                                    url: '/cart/updateOption.dox',
                                    type: 'POST',
                                    data: {
                                        cartId: m.item.cartId,
                                        quantity: m.qty,
                                        optionId: m.selectedOption || '',
                                        rentalStart: m.startDate || '',
                                        rentalEnd: m.endDate || ''
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.optModal.open = false;
                                            self.fetchCartList();
                                            showToast(res.merged === 'Y' ? '같은 옵션 상품과 합쳐졌어요.' : '변경됐어요.');
                                        } else {
                                            showToast('변경에 실패했습니다.');
                                        }
                                    }
                                });
                            },

                            openConfirm(message, onOk, okText = '확인', cancelText = '취소') {
                                this.confirmModal.message = message;
                                this.confirmModal.onOk = onOk;
                                this.confirmModal.okText = okText;
                                this.confirmModal.cancelText = cancelText;
                                this.confirmModal.open = true;
                            },

                            confirmOk() {
                                if (typeof this.confirmModal.onOk === 'function') {
                                    this.confirmModal.onOk();
                                }
                                this.confirmModal.open = false;
                            },

                            confirmCancel() {
                                this.confirmModal.open = false;
                            },

                            formatPrice(p) {
                                return Number(p || 0).toLocaleString('ko-KR') + '원';
                            },

                            fmtDate(dateVal) {
                                const d = new Date(dateVal);

                                return d.getFullYear() + '-'
                                    + String(d.getMonth() + 1).padStart(2, '0') + '-'
                                    + String(d.getDate()).padStart(2, '0');
                            },

                            calcNights(s, e) {
                                if (!s || !e) return 0;
                                return Math.ceil((new Date(e) - new Date(s)) / (1000 * 60 * 60 * 24));
                            },

                            groupTotal(group) {
                                return group.items.reduce((sum, c) => {
                                    return sum + this.cartItemTotal(c);
                                }, 0);
                            },

                            couponText(coupon) {
                                if (coupon.couponType === 'AMOUNT') {
                                    return this.formatPrice(coupon.discountAmt) + ' 할인';
                                }

                                if (coupon.couponType === 'RATE') {
                                    let txt = coupon.discountRate + '% 할인';
                                    if (Number(coupon.maxDiscountAmt || 0) > 0) {
                                        txt += ' / 최대 ' + this.formatPrice(coupon.maxDiscountAmt);
                                    }
                                    return txt;
                                }

                                return '';
                            },

                            goProductList() {
                                document.getElementById('app').classList.add('page-leaving');
                                location.href = '/product/list.do';
                            },

                            goDetail(productId) {
                                document.getElementById('app').classList.add('page-leaving');
                                location.href = '/product/detail.do?productId=' + productId;
                            },
                            toggleInlineOption(item) {
                                if (this.inlineOption.cartId === item.cartId) {
                                    this.closeInlineOption();
                                    return;
                                }

                                let self = this;

                                self.inlineOption = {
                                    cartId: item.cartId,
                                    optionList: [],
                                    selectedOptions: {}
                                };

                                $.ajax({
                                    url: '/product/option/list.dox',
                                    type: 'POST',
                                    data: { productId: item.productId },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            const list = res.list || [];
                                            const selectedIds = String(item.optionValueIds || '')
                                                .split(',')
                                                .filter(v => v !== '')
                                                .map(v => Number(v));

                                            const selectedOptions = {};

                                            list.forEach(opt => {
                                                if (selectedIds.includes(Number(opt.optionValueId))) {
                                                    selectedOptions[opt.optionName] = opt;
                                                }
                                            });

                                            self.inlineOption.optionList = list;
                                            self.inlineOption.selectedOptions = selectedOptions;
                                        }
                                    }
                                });
                            },

                            selectInlineOption(optionName, opt) {
                                this.inlineOption.selectedOptions = {
                                    ...this.inlineOption.selectedOptions,
                                    [optionName]: opt
                                };
                            },

                            closeInlineOption() {
                                this.inlineOption = {
                                    cartId: null,
                                    optionList: [],
                                    selectedOptions: {}
                                };
                            },

                            // ✅ 수정
                            applyInlineOption(item) {
                                const optionGroupCount = Object.keys(this.inlineGroupedOptions).length;
                                const selectedCount = Object.keys(this.inlineOption.selectedOptions).length;

                                if (selectedCount < optionGroupCount) {
                                    showToast('옵션을 모두 선택해주세요.');
                                    return;
                                }

                                const selectedOptionValues = Object.values(this.inlineOption.selectedOptions);
                                const optionValueIds = selectedOptionValues.map(opt => opt.optionValueId).join(',');
                                const optionName = selectedOptionValues.map(opt => opt.optionValue).join(' / ');

                                // ✅ 비회원 - localStorage 직접 수정
                                if (!this.isLogin) {
                                    const target = this.cartList.find(c => c.cartId === item.cartId);
                                    if (target) {
                                        target.optionValueIds = optionValueIds;
                                        target.optionName = optionName;

                                        // unitPrice도 재계산 (옵션 추가금 반영)
                                        const addPrice = selectedOptionValues.reduce((sum, opt) => sum + (opt.addPrice || 0), 0);
                                        target.unitPrice = Number(target.price || 0) + addPrice;
                                    }
                                    this.saveGuestCart();
                                    this.closeInlineOption();
                                    showToast('옵션이 변경됐어요.');
                                    return;
                                }

                                // 회원 - 기존 서버 API 호출
                                let self = this;
                                $.ajax({
                                    url: '/cart/updateOption.dox',
                                    type: 'POST',
                                    data: {
                                        cartId: item.cartId,
                                        quantity: item.quantity,
                                        optionValueIds: optionValueIds,
                                        rentalStart: item.rentalStart || '',
                                        rentalEnd: item.rentalEnd || ''
                                    },
                                    dataType: 'json',
                                    success(res) {
                                        if (res.result === 'success') {
                                            self.closeInlineOption();
                                            self.fetchCartList();
                                            showToast(res.merged === 'Y' ? '같은 옵션 상품과 합쳐졌어요.' : '옵션이 변경됐어요.');
                                        } else {
                                            showToast(res.message || '옵션 변경에 실패했습니다.');
                                        }
                                    }
                                });
                            },
                            useAllPoint() {
                                this.usePoint = this.maxUsePoint;
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
                            cartItemTotal(item) {
                                const unitPrice = Number(item.unitPrice || item.price || 0);
                                const quantity = Number(item.quantity || 1);

                                if (item.cartType === 'RENTAL') {
                                    const nights = this.calcNights(item.rentalStart, item.rentalEnd) || 1;
                                    const deposit = Number(item.deposit || 0);

                                    return (unitPrice * nights + deposit) * quantity;
                                }

                                return unitPrice * quantity;
                            },
                            rentalFee(item) {
                                const unitPrice = Number(item.unitPrice || item.price || 0);
                                const nights = this.calcNights(item.rentalStart, item.rentalEnd) || 1;
                                return unitPrice * nights;  // ✅ 1개 기준 대여료
                            },

                            depositFee(item) {
                                return Number(item.deposit || 0);  // ✅ 1개 기준 보증금
                            },
                        },

                        mounted() {
                            this.checkLogin();
                        }
                    });

                    app.mount('#app');

                    function mergeGuestCartOnLogin() {
                        var raw = localStorage.getItem(LS_KEY);
                        if (!raw) return;

                        var items = [];

                        try {
                            items = JSON.parse(raw);
                        } catch (e) {
                            return;
                        }

                        if (!items.length) return;

                        var promises = items.map(function (item) {
                            return $.ajax({
                                url: '/cart/add.dox',
                                type: 'POST',
                                dataType: 'json',
                                data: {
                                    cartType: item.cartType,
                                    productId: item.productId,
                                    quantity: item.quantity,
                                    optionValueIds: item.optionValueIds || '',
                                    optionItemId: item.optionItemId || '',
                                    rentalStart: item.rentalStart || '',
                                    rentalEnd: item.rentalEnd || ''
                                }
                            });
                        });

                        Promise.all(promises).then(function () {
                            localStorage.removeItem(LS_KEY);
                            showToast('장바구니가 복원됐습니다.');
                        });
                    }
                </script>

    </body>

    </html>
