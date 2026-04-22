<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>대여 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-rentals.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/common/font.css">
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="rental-page-container">
            
            <div class="rental-header">
                <div class="rental-title">⛺ 대여 현황 및 일정 관리</div>
                <button @click="fnGoDashboard" class="r-btn-back">🏠 대시보드로 돌아가기</button>
            </div>

            <div class="rental-card">
                <table class="rental-table">
                    <thead>
                        <tr>
                            <th style="width: 8%;">번호</th>
                            <th style="width: 12%;">대여자 ID</th>
                            <th style="text-align: left;">대여 상품 정보</th>
                            <th style="width: 15%;">대여 시작일</th>
                            <th style="width: 15%;">반납 예정일</th>
                            <th style="width: 10%;">현재상태</th>
                            <th style="width: 15%;">상태변경</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in rentalList" :key="item.RENTAL_ID">
                            <td style="color:var(--r-accent); font-weight:700;">#{{ item.RENTAL_ID }}</td>
                            <td>{{ item.USER_ID }}</td>
                            
                            <td class="prod-info-wrap">
                                <div class="rental-img-box">
                                    <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                    <div v-else style="display:flex; justify-content:center; align-items:center; height:100%;">⛺</div>
                                </div>
                                <div style="font-weight: 500;">{{ item.PRODUCT_NAME }}</div>
                            </td>

                            <td style="color:var(--r-text-muted);">{{ item.START_DATE }}</td>
                            <td>
                                <input type="date" 
                                       v-model="item.END_DATE" 
                                       @change="fnUpdateReturnDate(item)"
                                       class="r-date-input">
                            </td>
                            <td>
                                <span :style="{color: item.RENTAL_STATUS === 'IN_USE' ? '#58d68d' : '#8a8f9d', fontSize:'12px', fontWeight:'bold'}">
                                    ● {{ item.RENTAL_STATUS_KOR }}
                                </span>
                            </td>
                            <td>
                                <select class="r-select" v-model="item.RENTAL_STATUS" @change="fnUpdateStatus(item)">
                                    <option value="IN_USE">대여중</option>
                                    <option value="RETURN_COMPLETED">반납완료</option>
                                </select>
                            </td>
                        </tr>
                        <tr v-if="rentalList.length === 0">
                            <td colspan="7" style="padding: 80px; color: var(--r-text-muted);">대여 데이터가 없습니다.</td>
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
                return { rentalList: [] };
            },
            methods: {
                fnGetList() {
                    const self = this;
                    $.ajax({
                        url: "/admin/rental/list.dox",
                        type: "POST",
                        success: function(data) {
                            if (data.result === "success") { self.rentalList = data.list; }
                        }
                    });
                },
                fnUpdateStatus(item) {
                    $.ajax({
                        url: "/admin/rental/update-status.dox",
                        type: "POST",
                        data: { rentalId: item.RENTAL_ID, status: item.RENTAL_STATUS },
                        success: function(data) {
                            if (data.result === "success") { self.fnGetList(); }
                        }
                    });
                },
                fnUpdateReturnDate(item) {
                    if(!confirm("반납 날짜를 변경하시겠습니까?")) {
                        this.fnGetList();
                        return;
                    }
                    $.ajax({
                        url: "/admin/rental/update-date.dox",
                        type: "POST",
                        data: { rentalId: item.RENTAL_ID, returnDate: item.END_DATE },
                        success: (res) => { if (res.result !== "success") alert("수정 실패"); }
                    });
                },
                fnGoDashboard() { location.href = "/admin/dashboard.do"; }
            },
            mounted() { this.fnGetList(); }
        }).mount('#app');
    </script>
</body>
</html>