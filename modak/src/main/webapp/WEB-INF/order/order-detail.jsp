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

<div id="app" v-cloak>
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
                <div v-for="(item, index) in order.itemList" :key="index"
                     class="product-item" @click="fnGoProductDetail(item.productId)">

                    <div class="product-thumb-box">
                        <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.productName" class="thumb-img"
                             @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                        <span class="thumb-emoji" :style="item.imgUrl ? 'display:none' : 'display:flex'">
                            {{ item.orderType === 'RENTAL' ? '⛺' : '🛒' }}
                        </span>
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
                    <div class="item-arrow"><i class="fa-solid fa-chevron-right"></i></div>
                </div>
            </div>
        </section>

        <div class="info-grid">
            <section class="glass-card">
                <h3 class="section-title"><i class="fa-solid fa-location-dot"></i> 배송지 정보</h3>
                <div class="info-content">
                    <table class="info-table">
                        <tr><th>받는분</th><td>{{ order.receiverName }}</td></tr>
                        <tr><th>연락처</th><td>{{ order.receiverPhone }}</td></tr>
                        <tr>
                            <th>주소</th>
                            <td>({{ order.zipcode }}) {{ order.deliveryAddr }} {{ order.deliveryDetailAddr }}</td>
                        </tr>
                    </table>
                </div>
            </section>

            <section class="glass-card">
                <h3 class="section-title"><i class="fa-solid fa-credit-card"></i> 결제 정보</h3>
                <div class="price-summary">
                    <div class="price-row">
                        <span class="label">결제 수단</span>
                        <span class="val-orange">{{ order.payMethod || 'CARD' }}</span>
                    </div>
                    <div class="price-row">
                        <span class="label">결제 시각</span>
                        <span class="val-sub">{{ order.payDate || order.createdAt || '-' }}</span>
                    </div>
                    <div class="info-divider"></div>
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
            <button v-if="['PAID','READY','PAY_COMPLETED'].includes((order.orderStatus || '').toUpperCase())"
                    class="btn-cancel" @click="fnOpenCancelModal">주문취소</button>
        </div>

        <div v-if="isCancelModalOpen" class="modal-overlay" @click.self="isCancelModalOpen = false">
            <div class="cancel-modal">
                <h3 class="section-title"><i class="fa-solid fa-circle-exclamation"></i> 주문 취소 신청</h3>
                
                <div class="cancel-info-box">
                    <p v-if="order.itemList && order.itemList.length > 0">
                        취소 상품: <strong>{{ order.itemList[0].productName }} <span v-if="order.itemList.length > 1">외 {{ order.itemList.length - 1 }}건</span></strong>
                    </p>
                    <p>환불 예정 금액: <strong class="val-orange">{{ calcFinalTotal.toLocaleString() }}원</strong></p>
                </div>

                <div class="cancel-form">
                    <label class="label">취소 사유 선택</label>
                    <select v-model="cancelReasonCode" class="cancel-select">
                        <option value="">사유를 선택해주세요.</option>
                        <option value="CHANGE_MIND">단순 변심</option>
                        <option value="WRONG_OPTION">옵션 변경 </option>
                        <option value="DELAYED">배송 지연 </option>
                        <option value="ETC">기타 (직접 입력)</option>
                    </select>

                    <label class="label">상세 사유 (선택)</label>
                    <textarea v-model="cancelReasonText" class="cancel-textarea" placeholder="상세한 내용을 적어주면 큰 도움이 됩니다! ⛺"></textarea>
                </div>

                <div class="btn-group">
                    <button class="btn-back-list" @click="isCancelModalOpen = false" style="flex:1;">닫기</button>
                    <button class="btn-cancel" @click="fnSubmitCancel" :disabled="!cancelReasonCode" style="flex:1.5;">취소 확정</button>
                </div>
            </div>
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
            order: null,
            isCancelModalOpen: false,
            cancelReasonCode: "",
            cancelReasonText: ""
        }; 
    },
    computed: {
        calcSubTotal() {
            if (!this.order || !this.order.itemList) return 0;
            return this.order.itemList.reduce(function(acc, item) {
                return acc + (item.price * item.count);
            }, 0);
        },
        calcFinalTotal() {
            if (!this.order) return 0;
            return this.calcSubTotal - (this.order.discountAmt || 0);
        }
    },
    methods: {
        fnGetDetail() {
            $.ajax({
                url: "/order/detail.dox", type: "POST", dataType: "json",
                data: { orderId: this.orderId },
                success: (res) => {
                    if (res.result === "success") this.order = res.order;
                }
            });
        },
        fnOpenCancelModal() { this.isCancelModalOpen = true; },
        fnSubmitCancel() {
            if (!this.cancelReasonCode) return;
            if (!confirm("정말로 주문을 취소하시겠습니까? 사유가 접수되었습니다!")) return;

            const params = {
                orderId: this.orderId,
                cancelReasonCode: this.cancelReasonCode,
                cancelReasonText: this.cancelReasonText,
                cancelAmount: this.calcFinalTotal
            };

            $.ajax({
                url: "/order/cancel.dox", 
                type: "POST", 
                dataType: "json",
                data: params,
                success: (res) => {
                    if (res.result === "success") {
                        alert("주문이 성공적으로 취소되었습니다! 🔥");
                        this.isCancelModalOpen = false;
                        this.fnGetDetail();
                    } else {
                        alert(res.message || "취소 중 오류가 발생했습니다!");
                    }
                }
            });
        },
        fnGoProductDetail(id) { if (id) location.href = "/product/detail.do?productId=" + id; },
        fnGoList() { location.href = "/order/history.do"; }
    },
    mounted() { this.fnGetDetail(); }
}).mount('#app');
</script>
</body>
</html>