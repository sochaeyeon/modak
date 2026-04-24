<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 장바구니</title>
    <link rel="stylesheet" href="/css/cart/cart-list.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>
    <div id="app">
            <!-- 브레드크럼 -->
        <div class="breadcrumb">
            <a href="#">장바구니</a>
            <span>›</span>
            <span style="color:#bbb">주문/결제</span>
            <span>›</span>
            <span style="color:#bbb">완료</span>
        </div>

        <div class="cart-wrap">

            <!-- ── 탭: 대여 / 구매 ── -->
            <div class="cart-tabs">
                <button class="cart-tab" :class="{ on: activeTab === 'RENTAL' }" @click="switchTab('RENTAL')">
                    대여 장바구니
                </button>
                <span class="cart-tab-divider">|</span>
                <button class="cart-tab" :class="{ on: activeTab === 'PURCHASE' }" @click="switchTab('PURCHASE')">
                    구매
                </button>
            </div>

            <div class="cart-layout">

                <!-- ── 메인 영역 ── -->
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

                        <!-- 카드 헤더 (브랜드명) -->
                        <div class="cart-card-header">
                            <div class="chk" :class="{ on: isBrandChecked(group) }" @click="toggleBrand(group)"></div>
                            <span>{{ group.brandName || '모닥모닥' }}</span>
                        </div>

                        <!-- 아이템 목록 -->
                        <div v-for="item in group.items" :key="item.cartId" class="cart-item">
                            <div class="cart-item-top" @click="goDetail(item.productId)" style="cursor:pointer;">
                                <!-- 체크박스 -->
                                <div class="chk" style="margin-top:4px;"
                                    :class="{ on: checkedIds.includes(item.cartId) }"
                                    @click.stop="toggleItem(item.cartId)">
                                </div>

                                <!-- 이미지 -->
                                <div class="cart-item-img">
                                    <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName">
                                    <span v-else style="font-size:36px;display:flex;align-items:center;justify-content:center;height:100%;">🏕️</span>
                                </div>

                                <!-- 상품 정보 -->
                                <div class="cart-item-info">
                                    <div class="cart-item-badge">Npay+</div>
                                    <div class="cart-item-name">{{ item.productName }}</div>
                                    <div class="cart-item-orig">{{ formatPrice(item.price * 1.5) }}</div>
                                    <div class="cart-item-price">
                                        <span class="disc">{{ getDiscRate(item) }}%</span>
                                        {{ formatPrice(item.price) }}
                                    </div>
                                    <!-- 대여 날짜 표시 -->
                                    <div v-if="activeTab === 'RENTAL' && item.rentalStart" class="rental-dates">
                                        📅 {{ item.rentalStart }} ~ {{ item.rentalEnd }}
                                        <span style="background:var(--orange);color:#fff;border-radius:4px;padding:1px 6px;font-size:11px;">
                                            {{ calcNights(item.rentalStart, item.rentalEnd) }}박
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- 수량 + 합계 -->
                            <div class="cart-item-bottom">
                                <div class="qty-ctrl">
                                    <button class="qty-btn" @click="chgItemQty(item, -1)">−</button>
                                    <div class="qty-num">{{ item.quantity }}</div>
                                    <button class="qty-btn" @click="chgItemQty(item, 1)">+</button>
                                </div>
                                <div class="item-total">
                                    {{ formatPrice(item.price * item.quantity) }}
                                    <button class="item-del-btn" @click.stop="deleteItem(item.cartId)" title="삭제">✕</button>
                                </div>
                            </div>

                            <!-- 옵션 변경 버튼 -->
                            <button class="opt-change-btn" @click.stop="openOptModal(item)">옵션 변경</button>
                        </div>

                        <!-- 그룹 소계 -->
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
                

                <!-- ── 우측 사이드바 ── -->
                <div class="cart-aside">
                    <div class="aside-box">
                        <div class="aside-title">주문 예상 금액</div>
                        <div class="aside-rows">
                            <div class="aside-row">
                                <span>총 선택상품금액</span>
                                <span class="val">{{ formatPrice(selectedTotal) }}</span>
                            </div>
                            <div class="aside-row">
                                <span>쿠폰할인예상금액</span>
                                <span class="val red">0원</span>
                            </div>
                            <div class="aside-row">
                                <span>총 배송비</span>
                                <span class="val">0원</span>
                            </div>
                            <div class="aside-row total">
                                <span>총 주문 예상 금액</span>
                                <span class="val">{{ formatPrice(selectedTotal) }}</span>
                            </div>
                        </div>
                        <button class="order-btn"
                            :disabled="checkedIds.length === 0"
                            @click="fnOrder">
                            주문하기
                            <span class="order-badge">{{ checkedIds.length }}</span>
                        </button>
                    </div>
                </div>
                <!-- 상품 더 담기 버튼 -->
                <div class="cart-more-box">
                    <button class="cart-more-btn" @click="goProductList">
                        + 상품 추가하기
                    </button>
                </div>
            </div><!-- /cart-layout -->
        </div><!-- /cart-wrap -->

        <!-- ══════════ 옵션 변경 모달 ══════════ -->
        <div v-if="optModal.open" class="modal-overlay" @click.self="optModal.open = false">
            <div class="modal-box">

                <!-- 헤더 -->
                <div class="modal-header">
                    <span class="modal-title">옵션 변경</span>
                    <button class="modal-close" @click="optModal.open = false">✕</button>
                </div>

                <!-- 상품 미리보기 -->
                <div class="modal-product" v-if="optModal.item">
                    <img :src="optModal.item.imgUrl || '/img/product/default.jpg'" :alt="optModal.item.productName">
                    <div>
                        <div class="modal-product-name">{{ optModal.item.productName }}</div>
                        <div class="modal-product-price">{{ formatPrice(optModal.item.price) }}</div>
                    </div>
                </div>

                <!-- 대여 정보 -->
                <div v-if="activeTab === 'RENTAL'">
                    <div class="modal-info-row">
                        <span class="modal-info-label">배송방법</span>
                        <span>직접배송</span>
                    </div>
                    <div class="modal-info-row">
                        <span class="modal-info-label">배송비건시</span>
                        <span>무료</span>
                    </div>

                    <!-- 캘린더 -->
                    <div style="border:1px solid #eee;border-radius:10px;padding:14px;margin:12px 0;">
                        <!-- 월 이동 -->
                        <div class="cal-nav">
                            <button @click="changeModalMonth(-1)">‹</button>
                            <span style="font-size:14px;font-weight:700;">
                                {{ optModal.year }}년 {{ optModal.month + 1 }}월
                            </span>
                            <button @click="changeModalMonth(1)">›</button>
                        </div>

                        <!-- 캘린더 그리드 -->
                        <div class="cal-grid">
                            <div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">{{w}}</div>
                            <div v-for="(day, idx) in modalCalDays" :key="idx"
                                :class="getModalDayClass(day)"
                                @click="onModalDayClick(day)">
                                <span v-if="day">{{ day.date }}</span>
                            </div>
                        </div>

                        <!-- 선택 결과 -->
                        <div class="date-result">
                            <div v-if="optModal.startDate && optModal.endDate" style="color:#333;font-weight:600;">
                                📅 {{ optModal.startDate }} ~ {{ optModal.endDate }}
                                <span style="color:var(--orange);margin-left:6px;">
                                    {{ calcNights(optModal.startDate, optModal.endDate) }}박
                                </span>
                            </div>
                            <div v-else-if="optModal.startDate" style="color:var(--orange);">
                                종료일을 선택해주세요.
                            </div>
                            <div v-else style="color:#bbb;">시작일을 선택해주세요.</div>
                        </div>
                    </div>
                </div>

                <!-- 구매: 수량 변경 -->
                <div v-else style="margin:16px 0;">
                    <div style="font-size:13px;color:var(--muted);margin-bottom:10px;">수량</div>
                    <div style="display:flex;align-items:center;gap:0;">
                        <button class="qty-btn" style="border-radius:8px 0 0 8px;" @click="optModal.qty = Math.max(1, optModal.qty - 1)">−</button>
                        <div class="qty-num" style="width:60px;">{{ optModal.qty }}</div>
                        <button class="qty-btn" style="border-radius:0 8px 8px 0;" @click="optModal.qty++">+</button>
                    </div>
                </div>

                <!-- 금액 표시 -->
                <div class="modal-price-row">
                    <span class="modal-price-label">상품금액</span>
                    <div>
                        <div class="modal-price-val">
                            {{ optModal.item ? formatPrice(calcModalTotal()) : '0원' }}
                        </div>
                        <div style="font-size:11px;color:var(--muted);text-align:right;">
                            {{ activeTab === 'RENTAL' && optModal.startDate && optModal.endDate ? calcNights(optModal.startDate, optModal.endDate) + '박' : '' }}
                        </div>
                    </div>
                </div>

                <!-- 하단 버튼 -->
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
    </div><!-- app -->
<%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>

<script>
    function showToast(msg) {
        var t = document.getElementById('toast');
        if (!t) {
            t = document.createElement('div');
            t.id = 'toast';
            t.style.cssText = 'position:fixed;bottom:30px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:10px 20px;border-radius:8px;font-size:13px;z-index:9999;display:none;';
            document.body.appendChild(t);
        }
        t.textContent = msg;
        t.style.display = 'block';
        setTimeout(function(){ t.style.display = 'none'; }, 2200);
    }

    const app = Vue.createApp({
        data() {
            return {
                activeTab: 'RENTAL',   // 'RENTAL' | 'PURCHASE'
                cartList: [],          // 전체 카트 목록
                checkedIds: [],        // 선택된 cartId 배열

                // 옵션 변경 모달
                optModal: {
                    open: false,
                    item: null,
                    qty: 1,
                    startDate: null,
                    endDate: null,
                    year: new Date().getFullYear(),
                    month: new Date().getMonth(),
                },
            };
        },
        computed: {
            // 현재 탭에 맞는 카트 목록
            filteredCart() {
                return this.cartList.filter(c => c.cartType === this.activeTab);
            },
            // 브랜드별 그룹핑
            groupedCart() {
                const groups = {};
                this.filteredCart.forEach(item => {
                    const key = item.brandName || '모닥모닥';
                    if (!groups[key]) groups[key] = { brandName: key, items: [] };
                    groups[key].items.push(item);
                });
                return Object.values(groups);
            },
            // 전체선택 여부
            isAllChecked() {
                if (this.filteredCart.length === 0) return false;
                return this.filteredCart.every(c => this.checkedIds.includes(c.cartId));
            },
            // 선택 상품 합계
            selectedTotal() {
                return this.filteredCart
                    .filter(c => this.checkedIds.includes(c.cartId))
                    .reduce((sum, c) => sum + c.price * c.quantity, 0);
            },
            // 모달 캘린더 날짜 배열
            modalCalDays() {
                const { year, month } = this.optModal;
                const firstDay = new Date(year, month, 1).getDay();
                const lastDate = new Date(year, month + 1, 0).getDate();
                const days = [];
                for (let i = 0; i < firstDay; i++) days.push(null);
                for (let d = 1; d <= lastDate; d++) {
                    const dateObj = new Date(year, month, d);
                    const full = this.fmtDate(dateObj);
                    days.push({
                        date: d, full,
                        isPast: dateObj < new Date().setHours(0,0,0,0)
                    });
                }
                return days;
            },
        },
        methods: {
            // ── 데이터 로드 ──
            fetchCartList() {
                let self = this;
                $.ajax({
                    url: '/cart/list.dox',
                    type: 'POST',
                    data: { cartType: self.activeTab },
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success') {
                            // 전체 타입 다 받아서 프론트에서 필터링
                            self.cartList = res.list || [];
                            self.checkedIds = [];
                        }
                    }
                });
            },

            // ── 탭 전환 ──
            switchTab(tab) {
                this.activeTab = tab;
                this.checkedIds = [];
            },

            // ── 체크박스 ──
            toggleAll() {
                if (this.isAllChecked) {
                    // 현재 탭 아이템 ID 제거
                    const ids = this.filteredCart.map(c => c.cartId);
                    this.checkedIds = this.checkedIds.filter(id => !ids.includes(id));
                } else {
                    const ids = this.filteredCart.map(c => c.cartId);
                    ids.forEach(id => { if (!this.checkedIds.includes(id)) this.checkedIds.push(id); });
                }
            },
            isBrandChecked(group) {
                return group.items.every(c => this.checkedIds.includes(c.cartId));
            },
            toggleBrand(group) {
                if (this.isBrandChecked(group)) {
                    const ids = group.items.map(c => c.cartId);
                    this.checkedIds = this.checkedIds.filter(id => !ids.includes(id));
                } else {
                    group.items.forEach(c => {
                        if (!this.checkedIds.includes(c.cartId)) this.checkedIds.push(c.cartId);
                    });
                }
            },
            toggleItem(cartId) {
                const idx = this.checkedIds.indexOf(cartId);
                if (idx > -1) this.checkedIds.splice(idx, 1);
                else this.checkedIds.push(cartId);
            },

            // ── 수량 변경 ──
            chgItemQty(item, d) {
                const next = item.quantity + d;
                if (next < 1) return;
                item.quantity = next;
                // 서버 동기화
                $.ajax({
                    url: '/cart/update.dox',
                    type: 'POST',
                    data: { cartId: item.cartId, quantity: next },
                    dataType: 'json',
                    success(res) {
                        if (res.result !== 'success') showToast('수량 변경에 실패했습니다.');
                    }
                });
            },

            // ── 삭제 ──
            deleteItem(cartId) {
                if (!confirm('해당 상품을 삭제하시겠습니까?')) return;
                let self = this;
                $.ajax({
                    url: '/cart/delete.dox',
                    type: 'POST',
                    data: { cartId },
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success') {
                            self.cartList = self.cartList.filter(c => c.cartId !== cartId);
                            self.checkedIds = self.checkedIds.filter(id => id !== cartId);
                            showToast('삭제됐어요.');
                        }
                    }
                });
            },
            deleteSelected() {
                if (this.checkedIds.length === 0) { showToast('선택된 상품이 없습니다.'); return; }
                if (!confirm(this.checkedIds.length + '개 상품을 삭제하시겠습니까?')) return;
                let self = this;
                $.ajax({
                    url: '/cart/deleteSelected.dox',
                    type: 'POST',
                    data: { cartIds: self.checkedIds.join(',') },
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success') {
                            self.cartList = self.cartList.filter(c => !self.checkedIds.includes(c.cartId));
                            self.checkedIds = [];
                            showToast('선택 상품이 삭제됐어요.');
                        }
                    }
                });
            },

            // ── 주문하기 ──
            fnOrder() {
                if (this.checkedIds.length === 0) { showToast('상품을 선택해주세요.'); return; }
                const ids = this.checkedIds.join(',');
                location.href = '/order/checkout.do?cartIds=' + ids + '&cartType=' + this.activeTab;
            },

            // ── 옵션 변경 모달 ──
            openOptModal(item) {
                this.optModal = {
                    open: true,
                    item: { ...item },
                    qty: item.quantity,
                    startDate: item.rentalStart || null,
                    endDate: item.rentalEnd || null,
                    year: new Date().getFullYear(),
                    month: new Date().getMonth(),
                };
            },
            changeModalMonth(diff) {
                const d = new Date(this.optModal.year, this.optModal.month + diff, 1);
                this.optModal.year = d.getFullYear();
                this.optModal.month = d.getMonth();
            },
            getModalDayClass(day) {
                if (!day) return 'cal-day empty';
                if (day.isPast) return 'cal-day past';
                if (day.full === this.optModal.startDate || day.full === this.optModal.endDate) return 'cal-day selected';
                if (this.optModal.startDate && this.optModal.endDate
                    && day.full > this.optModal.startDate && day.full < this.optModal.endDate) return 'cal-day in-range';
                return 'cal-day available';
            },
            onModalDayClick(day) {
                if (!day || day.isPast) return;
                if (!this.optModal.startDate || (this.optModal.startDate && this.optModal.endDate)) {
                    this.optModal.startDate = day.full; this.optModal.endDate = null;
                } else {
                    if (day.full < this.optModal.startDate) this.optModal.startDate = day.full;
                    else if (day.full === this.optModal.startDate) this.optModal.startDate = null;
                    else this.optModal.endDate = day.full;
                }
            },
            calcModalTotal() {
                const item = this.optModal.item;
                if (!item) return 0;
                if (this.activeTab === 'RENTAL') {
                    const nights = this.calcNights(this.optModal.startDate, this.optModal.endDate);
                    return item.price * (nights || 1);
                }
                return item.price * this.optModal.qty;
            },
            applyOptChange() {
                const m = this.optModal;
                if (this.activeTab === 'RENTAL' && (!m.startDate || !m.endDate)) {
                    showToast('날짜를 선택해주세요.');
                    return;
                }
                // 서버 업데이트
                let self = this;
                $.ajax({
                    url: '/cart/updateOption.dox',
                    type: 'POST',
                    data: {
                        cartId: m.item.cartId,
                        quantity: m.qty,
                        rentalStart: m.startDate || '',
                        rentalEnd: m.endDate || '',
                    },
                    dataType: 'json',
                    success(res) {
                        if (res.result === 'success') {
                            // 로컬 반영
                            const target = self.cartList.find(c => c.cartId === m.item.cartId);
                            if (target) {
                                target.quantity = m.qty;
                                target.rentalStart = m.startDate;
                                target.rentalEnd = m.endDate;
                            }
                            self.optModal.open = false;
                            showToast('✅ 변경됐어요.');
                        } else {
                            showToast('변경에 실패했습니다.');
                        }
                    }
                });
            },

            // ── 유틸 ──
            formatPrice(p) {
                if (!p) return '0원';
                return Number(p).toLocaleString('ko-KR') + '원';
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
            getDiscRate(item) {
                // 임시 할인율 표시용 (실제는 DB에서 받아야 함)
                return 10;
            },
            groupTotal(group) {
                return group.items.reduce((sum, c) => sum + c.price * c.quantity, 0);
            },
            goProductList() {
                location.href = '/product/list.do';
            },
            goDetail(productId) {
                location.href = '/product/detail.do?productId=' + productId;
            },
        },
        mounted() {
            this.fetchCartList();
        }
    });

    app.mount('#app');
</script>
