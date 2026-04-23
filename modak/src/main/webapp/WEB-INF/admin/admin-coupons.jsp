<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:directive.page deferredSyntaxAllowedAsLiteral="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>쿠폰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-camps.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="camp-page-container">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:32px;">
                <div>
                    <h2 style="color:#fff; margin:0;">🎫 쿠폰 발행 및 관리</h2>
                    <p style="color:var(--c-text-muted); font-size:14px; margin-top:5px;">신규 회원 및 등급별 쿠폰을 관리합니다.</p>
                </div>
                <button class="p-btn" @click="fnAddCoupon">+ 신규 쿠폰 발행</button>
            </div>

            <div class="member-search-bar" style="background:var(--c-card); padding:18px; border-radius:18px; margin-bottom:24px; display:flex; gap:12px; border:1px solid var(--c-border);">
                <input type="text" class="m-input" v-model="keyword" placeholder="쿠폰명으로 검색" @keyup.enter="fnLoad" style="flex:1; background:#262a3a; border:none; padding:12px; border-radius:10px; color:#fff; outline:none;">
                <button class="p-btn" @click="fnLoad">조회</button>
            </div>

            <div class="camp-table-card">
                <table class="c-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>쿠폰명</th>
                            <th>혜택</th>
                            <th>발행 대상</th>
                            <th>기간</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in couponList" :key="item.COUPON_ID">
                            <td style="color:var(--c-text-muted)">{{ item.COUPON_ID }}</td>
                            <td style="font-weight:600; text-align:left;">{{ item.COUPON_NAME }}</td>
                            <td>
                                <span v-if="item.COUPON_TYPE === 'AMOUNT'" style="color:#58d68d">
                                    {{ item.DISCOUNT_AMT.toLocaleString() }}원 할인
                                </span>
                                <span v-else style="color:#f4d03f">
                                    {{ item.DISCOUNT_RATE }}% 할인
                                </span>
                            </td>
                            <td><span class="badge-induty">{{ item.ISSUE_TARGET }}</span></td>
                            <td style="font-size:12px; color:var(--c-text-muted)">
                                {{ item.START_DATE }} ~ {{ item.END_DATE }}
                            </td>
                            <td>
                                <span :style="{color: item.IS_ACTIVE === 'Y' ? '#58d68d' : '#ec7063'}">
                                    ● {{ item.IS_ACTIVE === 'Y' ? '활성' : '중단' }}
                                </span>
                            </td>
                            <td>
                                <div style="display:flex; gap:8px; justify-content:center;">
                                    <button class="p-btn-secondary" @click="fnToggleStatus(item)">
                                        {{ item.IS_ACTIVE === 'Y' ? '중지' : '재개' }}
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
            data() {
                return { couponList: [], keyword: '' };
            },
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
                fnToggleStatus(item) {
                    const nextStatus = item.IS_ACTIVE === 'Y' ? 'N' : 'Y';
                    if(!confirm("쿠폰 상태를 변경하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/coupon/updateStatus.dox",
                        type: "POST",
                        data: { couponId: item.COUPON_ID, isActive: nextStatus },
                        success: (res) => {
                            this.fnLoad();
                        }
                    });
                },
                fnDelete(cId) {
                    if(!confirm("정말로 이 쿠폰을 삭제하시겠습니까?")) return;
                    // 삭제 로직 호출...
                    alert("삭제 프로세스는 캠핑장과 동일하게 구현하시면 됩니다!");
                },
                fnAddCoupon() {
                    alert("쿠폰 발행 팝업이나 페이지로 이동합니다.");
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>