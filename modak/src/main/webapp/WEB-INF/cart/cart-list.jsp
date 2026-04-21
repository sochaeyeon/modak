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
    <style>
       
    </style>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>
    <div id="app">
        <!-- ===== 메인 ===== -->
        <main class="main-wrap">

        <!-- 브레드크럼
        <div class="breadcrumb">
            <a href="#">홈</a>
            <span class="bc-sep">/</span>
            <a href="#">장바구니</a>
            <span class="bc-sep">/</span>
            <strong>대여 장바구니</strong>
            <span class="bc-badge" id="totalCartBadge">0</span>
        </div> -->

        <div class="cart-tabs">
            <input type="radio" id="tab-rental" name="cart-tab" value="rental" v-model="activeTab" class="tab-radio" hidden>
            <label for="tab-rental" class="tab-btn">
                대여 장바구니
                <span class="tab-badge"></span>
            </label>

            <input type="radio" id="tab-purchase" name="cart-tab" value="purchase" v-model="activeTab" class="tab-radio" hidden>
            <label for="tab-purchase" class="tab-btn">
                구매 장바구니
                <span class="tab-badge"></span>
            </label>
        </div>

        <!-- 콘텐츠 -->
        <div class="cart-layout">

            <!-- ── 왼쪽 상품 목록 ── -->
            <div class="cart-left">

            <!-- 대여 패널 -->
            <div id="panel-rental" class="tab-panel">

                <div class="period-bar">
                <span class="period-label">대여 기간</span>
                <input type="date" id="rentalStart" class="date-input" onchange="onDateChange()" />
                <span class="period-arrow">→</span>
                <input type="date" id="rentalEnd" class="date-input" onchange="onDateChange()" />
                <span class="nights-badge" id="nightsBadge"></span>
                </div>

                <div class="select-all-bar">
                <label class="chk-label">
                    <input type="checkbox" id="allRentalChk" onchange="toggleAllRental(this)" />
                    <span class="chk-box"></span>
                    전체 선택&nbsp;<span id="rentalSelCount">0</span>/<span id="rentalTotalCount">0</span>개
                </label>
                <button class="text-btn" onclick="deleteSelectedRental()">선택 삭제</button>
                </div>

                <div id="rentalItemList">
                    <div v-for="item in list" :key="item.cartId" class="cart-item">
                        <label class="chk-label">
                            <input type="checkbox" v-model="item.checked" /> 
                            <span class="chk-box"></span>
                        </label>
                        
                        <img v-if="item.imagePath" :src="item.imagePath" class="item-img" alt="상품 이미지">
                        <div v-else class="item-img-placeholder">🔥</div> <div class="item-info">
                            <div class="item-brand-small">{{ item.brandName }}</div> <div class="item-name">{{ item.productName }}</div>
                            
                            <div class="item-tags">
                                <span class="tag tag-available" v-if="activeTab === 'rental'">대여가능</span>
                                <span class="tag tag-nights" v-if="item.nights">{{ item.nights }}박</span>
                            </div>

                            <div class="item-qty-row">
                                <div class="qty-control">
                                    <button type="button" class="qty-btn" @click="fnUpdateQty(item, -1)">-</button>
                                    <div class="qty-value">{{ item.quantity }}</div>
                                    <button type="button" class="qty-btn" @click="fnUpdateQty(item, 1)">+</button>
                                </div>

                                <div class="price-wrap">
                                    <span class="price-final">{{ (item.price * item.quantity).toLocaleString() }}원</span>
                                </div>
                            </div>
                        </div>
                        
                        <button type="button" class="item-remove-btn" @click="fnDeleteCart(item.cartId)">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>

                    <div v-if="list.length === 0" class="empty-msg" style="padding: 50px 0; text-align: center; color: var(--text-hint);">
                        <p>장바구니에 담긴 상품이 없습니다.</p>
                    </div>
                </div>

                <div class="add-product-btn" onclick="location.href='http://localhost:8080/product/list.do'">
                + 상품 추가하기
                </div>
            </div>

            <!-- 구매 패널 -->
            <div id="panel-purchase" class="tab-panel" style="display:none">

                <div class="select-all-bar">
                <label class="chk-label">
                    <input type="checkbox" id="allPurchaseChk" onchange="toggleAllPurchase(this)" />
                    <span class="chk-box"></span>
                    전체 선택&nbsp;<span id="purchaseSelCount">0</span>/<span id="purchaseTotalCount">0</span>개
                </label>
                <button class="text-btn" onclick="deleteSelectedPurchase()">선택 삭제</button>
                </div>

                <div id="purchaseItemList">
                <div class="loading-msg">장바구니를 불러오는 중...</div>
                </div>

                <div class="add-product-btn" onclick="location.href='http://localhost:8080/product/list.do'">
                + 상품 추가하기
                </div>
            </div>

            </div><!-- /cart-left -->

            <!-- ── 오른쪽 주문 요약 ── -->
            <aside class="order-summary">
            <h3 class="summary-title">주문 요약</h3>

            <div class="summary-row">
                <span>상품 금액 (<span id="summaryItemCount">0</span>개)</span>
                <span id="summaryProductPrice">0원</span>
            </div>
            <div class="summary-row discount-row">
                <span>할인 금액</span>
                <span id="summaryDiscount">-0원</span>
            </div>
            <div class="summary-row" id="summaryPeriodRow" style="display:none">
                <span>대여 기간</span>
                <span id="summaryPeriodText">-</span>
            </div>
            <div class="summary-row">
                <span>배송비</span>
                <span class="free-label">무료</span>
            </div>

            <div class="coupon-row">
                <input type="text" id="couponInput" class="coupon-input" placeholder="쿠폰 선택" />
                <button class="coupon-apply-btn" onclick="applyCoupon()">적용</button>
            </div>

            <hr class="summary-divider" />

            <div class="summary-final-row">
                <span>최종 결제 금액</span>
                <span class="final-price" id="summaryFinalPrice">0원</span>
            </div>
            <p class="vat-note">VAT 포함</p>

            <button class="checkout-btn" onclick="goCheckout()">결제하기 →</button>

            <p class="cancel-note">
                반나 전 취소 불가합니다.<br />
                반나 주 영업일 기준 최대 3일 내 환불됩니다.
            </p>
            </aside>

        </div><!-- /cart-layout -->

        <!-- ===== 추천 상품 ===== -->
        <section class="rec-section" id="recSection">
            <h3 class="rec-title">함께 대여하면 좋아요</h3>
            <div class="rec-list" id="recList"></div>
        </section>

        </main>
    </div><!-- app -->
<%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>

<script>
    
    const app = Vue.createApp({
        data() {
            return {
                list : [],
                activeTab : 'rental',
                allChecked: false, // 전체 선택 체크박스 상태
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCartList: function () {
                let self = this;
                let param = { cartType: self.activeTab };
                $.ajax({
                    url: "/cart/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            self.list = data.list;
                            console.log(data.list)
                        }
                    }
                });
            },
            
        }, // methods
        watch: {
            // activeTab 변수를 감시하여 값이 바뀌면 자동으로 실행
            activeTab: function() {
                this.fnCartList();
            }
        },
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnCartList();
        }
    });

    app.mount('#app');
</script>