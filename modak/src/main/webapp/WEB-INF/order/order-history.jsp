<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 전체보기 - 모닥모닥</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/order/order-history.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>

    <div id="app">
        <div class="order-history-wrap">
            <div class="page-hero">
                <div class="hero-left">
                    <div class="page-eyebrow">MY SHOPPING</div>
                    <h2 class="page-title">주문 전체보기</h2>
                    <p class="page-desc">주문 내역을 날짜별로 확인하고, 기간별로 간편하게 필터링할 수 있어요.</p>
                </div>
                <div class="hero-summary-card">
                    <div class="hero-summary-label">조회 결과</div>
                    <div class="hero-summary-value">
                        <transition name="count-rise" mode="out-in">
                            <span class="result-count-number" :key="animatedCount">{{ animatedCount }}</span>
                        </transition>
                        <span class="result-count-unit">건</span>
                    </div>
                </div>
            </div>

            <div class="glass-card filter-card">
                <div class="section-head"><h3>주문 기간 선택</h3></div>
                <div class="filter-body">
                    <div class="period-chip-wrap">
                        <button v-for="p in ['ALL','1M','3M','6M','1Y','CUSTOM']" 
                                :key="p" class="period-chip" 
                                :class="{ active: selectedPeriod === p }" @click="fnSetPeriod(p)">
                            {{ p === 'ALL' ? '전체' : p === 'CUSTOM' ? '직접 선택' : p.replace('M','개월').replace('Y','년') }}
                        </button>
                    </div>
                    <div class="custom-date-row" v-if="selectedPeriod === 'CUSTOM'">
                        <input type="date" v-model="startDate"> <span>~</span> <input type="date" v-model="endDate">
                        <button class="btn-apply" @click="fnApplyCustomRange">적용</button>
                    </div>
                    <div class="date-error-msg" v-if="dateErrorMsg">{{ dateErrorMsg }}</div>
                </div>
            </div>

            <div class="glass-card">
                <div class="section-head"><h3>선택 기간 내 주문 현황</h3></div>
                <div class="order-flow">
                    <div v-for="(val, key) in statusMap" :key="key" class="flow-step" :class="{ 'has-count': statusSummary[key] > 0 }">
                        <div class="flow-circle">{{ val.icon }}</div>
                        <div class="flow-count">{{ statusSummary[key] }}</div>
                        <div class="flow-name">{{ val.name }}</div>
                    </div>
                </div>
            </div>

            <transition name="list-rise" mode="out-in">
                <div class="list-container" :key="listAnimateKey">
                    <div v-if="groupedOrders.length === 0" class="empty-state glass-card">
                        <p>선택한 기간에 주문내역이 없습니다.</p>
                    </div>
                    <div v-else v-for="group in groupedOrders" :key="group.date" class="date-group">
                        <div class="group-date-head">
                            <span class="group-date">{{ group.date }}</span>
                            <span class="group-count">{{ group.items.length }}건</span>
                        </div>
                        <div v-for="item in group.items" :key="item.orderId" class="order-card">
                            <div class="card-left">
                                <div class="thumb">{{ item.orderType === 'PURCHASE' ? '🛒' : '⛺' }}</div>
                                <div class="info">
                                    <div class="name-row">
                                        <strong>{{ item.productName }}</strong>
                                        <span v-if="item.itemCount > 1" class="extra">외 {{ item.itemCount - 1 }}건</span>
                                        <span class="badge" :class="item.orderType.toLowerCase()">{{ item.orderType === 'PURCHASE' ? '구매' : '대여' }}</span>
                                    </div>
                                    <div class="sub-row">주문번호 {{ item.orderId }} · {{ fnFormatDateTime(item.createdAt) }}</div>
                                </div>
                            </div>
                            <div class="card-right">
                                <div class="status-badge" :class="item.orderStatus.toLowerCase()">{{ fnGetStatusText(item.orderStatus) }}</div>
                                <div class="price">{{ fnFormatPrice(item.totalPrice - (item.discountAmt || 0)) }}</div>
                                <button class="detail-btn" @click="fnGoOrderDetail(item.orderId)">주문상세</button>
                            </div>
                        </div>
                    </div>
                </div>
            </transition>
        </div>
    </div>

    <%@ include file="/WEB-INF/common/footer.jsp" %>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    orderList: [], selectedPeriod: "ALL", startDate: "", endDate: "",
                    appliedStartDate: "", appliedEndDate: "", dateErrorMsg: "",
                    animatedCount: 0, listAnimateKey: 0,
                    statusMap: {
                        paid: { name: '결제완료', icon: '💳' }, ready: { name: '배송준비', icon: '📦' },
                        shipping: { name: '배송중', icon: '🚚' }, done: { name: '배송완료', icon: '✔' },
                        cancelled: { name: '취소/반품', icon: '✖' }
                    }
                };
            },
            watch: {
                'filteredOrderList.length'(newVal) { this.animatedCount = newVal; }
            },
            computed: {
                filteredOrderList() {
                    const today = new Date();
                    let start = null, end = null;
                    if (this.selectedPeriod === "1M") start = new Date(today.setMonth(today.getMonth() - 1));
                    else if (this.selectedPeriod === "3M") start = new Date(today.setMonth(today.getMonth() - 3));
                    else if (this.selectedPeriod === "CUSTOM" && this.appliedStartDate) {
                        start = new Date(this.appliedStartDate + "T00:00:00");
                        end = new Date(this.appliedEndDate + "T23:59:59");
                    }
                    return this.orderList.filter(item => {
                        const d = new Date(item.createdAt.replace(" ", "T"));
                        return (!start || d >= start) && (!end || d <= end);
                    });
                },
                groupedOrders() {
                    const groupMap = {};
                    this.filteredOrderList.forEach(item => {
                        const date = item.createdAt.split(' ')[0].replaceAll('-', '.');
                        if (!groupMap[date]) groupMap[date] = [];
                        groupMap[date].push(item);
                    });
                    return Object.keys(groupMap).map(date => ({ date, items: groupMap[date] }));
                },
                statusSummary() {
                    const s = { paid: 0, ready: 0, shipping: 0, done: 0, cancelled: 0 };
                    this.filteredOrderList.forEach(item => {
                        const status = item.orderStatus.toLowerCase();
                        if (s.hasOwnProperty(status)) s[status]++;
                    });
                    return s;
                }
            },
            methods: {
                fnGetOrderList() {
                    $.ajax({
                        url: "/order/list.dox", type: "POST", dataType: "json",
                        success: (res) => { if (res.result === "success") this.orderList = res.list; }
                    });
                },
                fnSetPeriod(p) { this.selectedPeriod = p; if (p !== 'CUSTOM') this.fnRunFilterAnimation(); },
                fnApplyCustomRange() { 
                    if (!this.startDate || !this.endDate) { this.dateErrorMsg = "날짜를 선택하세요."; return; }
                    this.appliedStartDate = this.startDate; this.appliedEndDate = this.endDate;
                    this.fnRunFilterAnimation();
                },
                fnRunFilterAnimation() { this.listAnimateKey++; },
                fnFormatPrice(p) { return Number(p).toLocaleString() + '원'; },
                fnGetStatusText(s) {
                    const m = { PAID:'결제완료', READY:'배송준비', SHIPPING:'배송중', DONE:'배송완료', CANCELLED:'취소/반품' };
                    return m[s] || s;
                },
                fnFormatDateTime(v) { return v.substring(0, 16).replaceAll('-', '.'); },
                fnGoOrderDetail(id) { location.href = "/order/detail.do?orderId=" + id; }
            },
            mounted() { this.fnGetOrderList(); }
        }).mount("#app");
    </script>
</body>
</html>