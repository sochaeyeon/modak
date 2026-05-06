<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>주문 완료 - 모닥모닥</title>

        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
        <link rel="stylesheet" href="/css/cart/cart-list.css">
        <link rel="stylesheet" href="/css/payment/order-complete.css">

        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    </head>

    <body>
        <%@ include file="/WEB-INF/common/header.jsp" %>
            <div id="app">
                <!-- 브레드크럼 -->
                <div class="order-step-wrap">
                    <div class="order-step" :class="{ active: currentStep === 1 }">장바구니</div>
                    <div class="order-step-line"></div>

                    <div class="order-step" :class="{ active: currentStep === 2 }">주문/결제</div>
                    <div class="order-step-line"></div>

                    <div class="order-step" :class="{ active: currentStep === 3 }">주문완료</div>
                </div>

                <main class="complete-page">
                    <section class="complete-card">
                        <div class="complete-hero">
                            <div class="complete-icon">✓</div>

                            <div class="complete-title-box">
                                <p class="complete-kicker">PAYMENT COMPLETE</p>
                                <h1>주문이 완료되었습니다</h1>
                                <p class="complete-desc">
                                    모닥모닥을 이용해주셔서 감사합니다.<br>
                                    주문 내역에서 결제 정보와 배송 상태를 확인할 수 있습니다.
                                </p>
                            </div>
                        </div>

                        <div class="complete-info-box">
                            <div class="info-row">
                                <span>주문번호</span>
                                <strong class="order-id">${orderId}</strong>
                                <p class="order-guide">※ 비회원 조회 시 반드시 필요합니다</p>
                            </div>
                            <div class="info-row">
                                <span>주문상태</span>
                                <strong class="orange">결제완료</strong>
                            </div>
                        </div>

                        <div class="complete-notice">
                            <div class="notice-head">
                                <span>!</span>
                                <strong>안내사항</strong>
                            </div>
                            <p>대여 상품은 선택한 대여 기간에 맞춰 준비됩니다.</p>
                            <p>구매 상품은 결제 완료 후 순차적으로 배송됩니다.</p>
                        </div>
                        <div class="guest-guide">
                            <div class="guest-head">
                                <i class="ri-user-line"></i>
                                <strong>비회원 주문 조회 방법</strong>
                            </div>

                            <p>비회원 주문 조회 시 아래 정보가 필요합니다.</p>

                            <ul>
                                <li>주문번호 (${orderId})</li>
                                <li>주문자 이름</li>
                                <li>휴대폰 번호</li>
                            </ul>

                            <p class="guest-desc">
                                ※ 사이드바 메뉴 하단의 <b>비회원 주문조회</b>에서 확인할 수 있습니다.
                            </p>
                        </div>
                        <div class="complete-btns">
                            <a href="/order/history.do" class="complete-btn primary">회원 주문 내역 보기</a>
                            <a href="/order/guest/inquiry.do" class="complete-btn ghost">비회원 주문 조회</a>
                            <a href="/product/list.do" class="complete-btn secondary">장비 둘러보기</a>
                        </div>
                    </section>
                </main>
            </div><!-- app -->
            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    const params = new URLSearchParams(location.search);
                    const isBuyNow = params.get('buyNow') === 'true';
                    function removeOnlyPaidGuestCartItems() {
                        let paidInfo = null;

                        try {
                            paidInfo = JSON.parse(localStorage.getItem('modak_paid_cart_info') || 'null');
                        } catch (e) {
                            paidInfo = null;
                        }

                        if (!paidInfo) {
                            return;
                        }

                        // 바로구매는 장바구니를 건드리지 않음
                        if (paidInfo.buyNow) {
                            localStorage.removeItem('modak_guest_buy_now');
                            localStorage.removeItem('checkout_items');
                            localStorage.removeItem('modak_paid_cart_info');
                            return;
                        }

                        let cart = [];

                        try {
                            cart = JSON.parse(localStorage.getItem('modak_guest_cart') || '[]');
                        } catch (e) {
                            cart = [];
                        }

                        const paidItems = paidInfo.items || [];

                        const remainedCart = cart.filter(function (cartItem) {
                            const matched = paidItems.some(function (paidItem) {
                                // cartId가 있으면 cartId 우선 비교
                                if (cartItem.cartId && paidItem.cartId) {
                                    return String(cartItem.cartId) === String(paidItem.cartId);
                                }

                                // 비회원 localStorage에 cartId가 없을 경우 상품/옵션/타입/대여일 기준 비교
                                return String(cartItem.productId) === String(paidItem.productId)
                                    && String(cartItem.optionItemId || '') === String(paidItem.optionItemId || '')
                                    && String(cartItem.cartType || paidInfo.cartType) === String(paidItem.cartType || paidInfo.cartType)
                                    && String(cartItem.rentalStart || '') === String(paidItem.rentalStart || '')
                                    && String(cartItem.rentalEnd || '') === String(paidItem.rentalEnd || '');
                            });

                            // 결제한 상품이면 제거
                            return !matched;
                        });

                        localStorage.setItem('modak_guest_cart', JSON.stringify(remainedCart));

                        localStorage.removeItem('checkout_items');
                        localStorage.removeItem('modak_paid_cart_info');
                    }

                    removeOnlyPaidGuestCartItems();
                    const app = Vue.createApp({
                        data() {
                            return {
                                currentStep: 3
                            };
                        },
                        methods: {

                        }, // methods
                        mounted() {
                            let self = this;

                        }
                    });

                    app.mount('#app');
                </script>
    </body>

    </html>