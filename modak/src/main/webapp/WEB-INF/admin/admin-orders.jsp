<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-orders.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="order-page-container">
            
            <div class="order-header">
                <div class="order-title">📦 실시간 주문 내역 관리</div>
                <button @click="fnGoDashboard" class="o-btn-back">
                    <span>🏠</span> 대시보드로 돌아가기
                </button>
            </div>

            <div class="order-card">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th style="width: 8%;">주문번호</th>
                            <th style="width: 12%;">주문자 ID</th>
                            <th style="text-align: left;">주문 상품 정보</th>
                            <th style="width: 15%;">총 결제금액</th>
                            <th style="width: 18%;">주문 일시</th>
                            <th style="width: 15%;">진행 상태 설정</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="order in orderList" :key="order.ORDER_ID">
                            <td class="order-id">#{{ order.ORDER_ID }}</td>
                            <td>{{ order.USER_ID }}</td>
                            
                            <td class="prod-info-td">
                                <div class="order-img-box">
                                    <img v-if="order.IMG_URL" :src="order.IMG_URL">
                                    <div v-else style="display:flex; justify-content:center; align-items:center; height:100%; font-size:12px;">🏕️</div>
                                </div>
                                <div style="font-weight: 500;">{{ order.PRODUCT_NAME }}</div>
                            </td>

                            <td class="order-price">{{ formatPrice(order.TOTAL_PRICE) }}원</td>
                            <td class="order-date">{{ order.CREATED_AT }}</td>
                            <td>
                                <select class="o-select" v-model="order.ORDER_STATUS" @change="fnUpdateStatus(order)">
                                    <option value="PAID">✅ 결제완료</option>
                                    <option value="READY">📦 상품준비중</option>
                                    <option value="SHIPPING">🚚 배송중</option>
                                    <option value="DELIVERED">🚩 배송완료</option>
                                    <option value="CANCELLED">❌ 주문취소</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    orderList: [],
                    page: 1, pageSize: 15
                };
            },
            methods: {
                fnGetList() {
                    const self = this;
                    $.ajax({
                        url: "/admin/order/list.dox",
                        type: "POST",
                        data: { page: self.page, pageSize: self.pageSize },
                        success: function(data) {
                            if (data.result === "success") { self.orderList = data.list; }
                        }
                    });
                },
                formatPrice(val) { return Number(val || 0).toLocaleString(); },
                fnUpdateStatus(order) {
                    $.ajax({
                        url: "/admin/order/update-status.dox",
                        type: "POST",
                        data: { orderId: order.ORDER_ID, status: order.ORDER_STATUS },
                        success: (res) => { if(res.result !== "success") alert("실패"); }
                    });
                },
                fnGoDashboard() { location.href = "/admin/dashboard.do"; }
            },
            mounted() { this.fnGetList(); }
        }).mount('#app');
    </script>
</body>
</html>