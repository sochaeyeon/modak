<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 상세 내역 - 모닥모닥</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/order-detail.css">
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app">
    <div v-if="order" class="order-detail-container">
        <header class="detail-header">
            <h2 class="page-title">주문 상세 내역</h2>
            <div class="order-meta-info">
                <span>주문번호 : <strong>{{ order.orderId }}</strong></span>
                <span class="divider">|</span>
                <span>주문일자 : <strong>{{ order.createdAt }}</strong></span>
            </div>
        </header>

        <section class="glass-card">
            <h3 class="section-title"><i class="fa-solid fa-box"></i> 주문 상품 정보</h3>
            <div class="product-list">
                <div v-for="(item, index) in order.itemList" :key="index" class="product-item">
                    <div class="product-thumb-box">
                        <span class="thumb-emoji">⛺</span>
                    </div>
                    <div class="product-info-box">
                        <span class="badge" :class="item.orderType === 'RENTAL' ? 'rental' : 'buy'">
                            {{ item.orderType === 'RENTAL' ? '대여' : '구매' }}
                        </span>
                        <h4 class="item-name">{{ item.productName }}</h4>
                        <p class="item-price">
                            <strong>{{ item.price.toLocaleString() }}원</strong> / {{ item.count }}개
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <div class="info-grid">
            <section class="glass-card">
                <h3 class="section-title"><i class="fa-solid fa-location-dot"></i> 배송지 정보</h3>
                <div class="info-content">
                    <table class="info-table">
                        <tr>
                            <th>받는분</th>
                            <td>{{ order.receiverName }}</td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td>{{ order.receiverPhone }}</td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td>
                                <template v-if="order.deliveryAddr">
                                    ({{ order.zipcode }}) {{ order.deliveryAddr }} <br>
                                    {{ order.deliveryDetailAddr }}
                                </template>
                                <template v-else>
                                    등록된 배송지 정보가 없습니다.
                                </template>
                            </td>
                        </tr>
                    </table>
                </div>
            </section>

            <section class="glass-card">
                <h3 class="section-title"><i class="fa-solid fa-credit-card"></i> 결제 금액 정보</h3>
                <div class="price-summary">
                    <div class="price-row">
                        <span>주문 합계</span>
                        <span>{{ calcSubTotal.toLocaleString() }}원</span>
                    </div>
                    <div class="price-row">
                        <span>할인 금액</span>
                        <span class="minus-text">-{{ (order.discountAmt || 0).toLocaleString() }}원</span>
                    </div>
                    <div class="total-row">
                        <span>최종 결제 금액</span>
                        <span class="total-price-text">{{ calcFinalTotal.toLocaleString() }}원</span>
                    </div>
                </div>
            </section>
        </div>

        <div class="btn-group">
            <button class="btn-back-list" @click="fnGoList">목록으로 돌아가기</button>
            
            <button v-if="order.orderStatus === 'PAID' || order.orderStatus === 'READY'" 
                    class="btn-cancel" @click="fnCancelOrder">
                주문취소
            </button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                orderId: '${orderId}',
                order: null
            }
        },
        computed: {
            calcSubTotal() {
                if (!this.order || !this.order.itemList) return 0;
                return this.order.itemList.reduce((acc, item) => acc + (item.price * item.count), 0);
            },
            calcFinalTotal() {
                return this.calcSubTotal - (this.order.discountAmt || 0);
            }
        },
        methods: {
            fnGetDetail() {
                const self = this;
                $.ajax({
                    url: "/order/detail.dox",
                    type: "POST",
                    dataType: "json",
                    data: { orderId: self.orderId },
                    success: function(res) {
                        if (res.result === "success") self.order = res.order;
                    }
                });
            },
            fnGoList() { 
                location.href = "/order/history.do"; 
            },
            fnCancelOrder() {
                if(!confirm("정말로 주문을 취소하시겠습니까?")) return;
                
                const self = this;
                $.ajax({
                    url: "/order/cancel.dox", // 취소 처리용 컨트롤러 주소
                    type: "POST",
                    dataType: "json",
                    data: { orderId: self.orderId },
                    success: function(res) {
                        if (res.result === "success") {
                            alert("주문이 취소되었습니다.");
                            self.fnGetDetail(); // 상태 갱신을 위해 재조회
                        } else {
                            alert("취소 처리 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        },
        mounted() { this.fnGetDetail(); }
    }).mount('#app');
</script>
</body>
</html>