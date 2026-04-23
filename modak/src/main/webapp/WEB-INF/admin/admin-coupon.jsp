<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:directive.page deferredSyntaxAllowedAsLiteral="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>쿠폰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-coupons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="coupon-page-container">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
                <h2 style="color:#fff; margin:0;">🎫 쿠폰 관리 시스템</h2>
                <button class="p-btn" @click="fnAddCoupon">신규 쿠폰 발행</button>
            </div>

            <div class="camp-table-card">
                <table class="c-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>쿠폰명</th>
                            <th>할인 혜택</th>
                            <th>대상</th>
                            <th>유효기간</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in couponList" :key="item.COUPON_ID">
                            <td>{{ item.COUPON_ID }}</td>
                            <td style="text-align:left; font-weight:600;">{{ item.COUPON_NAME }}</td>
                            <td>
                                <span v-if="item.COUPON_TYPE === 'AMOUNT'" class="benefit-amount">
                                    {{ item.DISCOUNT_AMT.toLocaleString() }}원
                                </span>
                                <span v-else class="benefit-rate">
                                    {{ item.DISCOUNT_RATE }}%
                                </span>
                            </td>
                            <td><span class="badge-target">{{ item.ISSUE_TARGET }}</span></td>
                            <td class="date-text">{{ item.START_DATE }} ~ {{ item.END_DATE }}</td>
                            <td>
                                <span :class="item.IS_ACTIVE === 'Y' ? 'status-dot active-dot' : 'status-dot inactive-dot'"></span>
                                <span :style="{color: item.IS_ACTIVE === 'Y' ? '#58d68d' : '#ec7063'}">
                                    {{ item.IS_ACTIVE === 'Y' ? '사용가능' : '정지됨' }}
                                </span>
                            </td>
                            <td>
                                <div style="display:flex; gap:8px; justify-content:center;">
                                    <button class="p-btn-secondary" @click="fnToggle(item)">
                                        {{ item.IS_ACTIVE === 'Y' ? '중지' : '해제' }}
                                    </button>
                                    <button class="p-btn-secondary btn-delete" @click="fnDelete(item.COUPON_ID)">삭제</button>
                                </div>
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
            data() { return { couponList: [], keyword: '' }; },
            methods: {
                fnLoad() {
                    const self = this;
                    $.ajax({
                        url: "/admin/coupon/list.dox",
                        type: "POST",
                        data: { keyword: self.keyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if(data.result === "success") self.couponList = data.list;
                        }
                    });
                },
                fnToggle(item) {
                    const nextStatus = item.IS_ACTIVE === 'Y' ? 'N' : 'Y';
                    if(!confirm("쿠폰 상태를 변경하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/coupon/updateStatus.dox",
                        type: "POST",
                        data: { couponId: item.COUPON_ID, isActive: nextStatus },
                        success: (res) => { this.fnLoad(); }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>