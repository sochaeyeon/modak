<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 관리자</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">

    <div class="admin-topbar">
        <div class="topbar-title">📊 대시보드</div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-dot"></div>
                관리자 접속중
            </div>
            <button class="btn-sm btn-ghost" onclick="location.href='/main.do'">← 사이트로</button>
        </div>
    </div>

    <div class="admin-content" id="app">

        <div class="stat-grid">
            <div class="stat-card" style="--accent:var(--orange)">
                <span class="stat-icon">💰</span>
                <div class="stat-label">이번달 매출</div>
                <div class="stat-value">{{ fnPrice(stats.monthSales) }}</div>
                <div class="stat-change" :class="stats.salesChange >= 0 ? 'up' : 'down'">
                    {{ stats.salesChange >= 0 ? '▲' : '▼' }} 전월 대비 {{ Math.abs(stats.salesChange || 0) }}%
                </div>
            </div>
            <div class="stat-card" style="--accent:var(--blue)">
                <span class="stat-icon">👥</span>
                <div class="stat-label">전체 회원</div>
                <div class="stat-value">{{ (stats.totalUsers || 0).toLocaleString() }}</div>
                <div class="stat-change up">▲ 이번달 {{ stats.newUsers || 0 }}명 신규</div>
            </div>
            <div class="stat-card" style="--accent:var(--green)">
                <span class="stat-icon">📦</span>
                <div class="stat-label">진행중 주문</div>
                <div class="stat-value">{{ stats.activeOrders || 0 }}</div>
                <div class="stat-change neutral">대여중 {{ stats.rentingCount || 0 }} / 배송중 {{ stats.shippingCount || 0 }}</div>
            </div>
            <div class="stat-card" style="--accent:var(--amber)">
                <span class="stat-icon">💬</span>
                <div class="stat-label">미답변 문의</div>
                <div class="stat-value" :style="stats.waitingInquiry > 0 ? 'color:var(--amber)' : ''">
                    {{ stats.waitingInquiry || 0 }}
                </div>
                <div class="stat-change neutral">전체 문의 {{ stats.totalInquiry || 0 }}건</div>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px">

            <div class="a-card">
                <div class="a-card-title">
                    월별 매출 현황
                    <span>최근 6개월</span>
                </div>
                <div class="chart-wrap" id="salesChart">
                    <div v-for="(item, i) in salesChart" :key="i" class="chart-bar-col">
                        <div class="chart-bar"
                             :style="'height:' + (item.amount / maxSales * 180) + 'px;'"
                             :data-val="fnPrice(item.amount)">
                        </div>
                        <div class="chart-label">{{ item.month }}</div>
                    </div>
                </div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    최근 주문 현황
                    <a href="/admin/orders.do" style="font-size:12px;color:var(--orange);text-decoration:none">전체보기</a>
                </div>
                <div class="a-table-wrap">
                    <table class="a-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>상품</th>
                                <th>금액</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="order in recentOrders" :key="order.orderId">
                                <td style="color:var(--text2)">#{{ order.orderId }}</td>
                                <td>{{ order.productName }}</td>
                                <td>{{ fnPrice(order.totalPrice) }}</td>
                                <td><span class="badge" :class="fnOrderBadge(order.orderStatus)">{{ fnOrderText(order.orderStatus) }}</span></td>
                            </tr>
                            <tr v-if="!recentOrders.length">
                                <td colspan="4" style="text-align:center;color:var(--text3);padding:20px">데이터 없음</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:20px">

            <div class="a-card">
                <div class="a-card-title">
                    미답변 문의
                    <a href="/admin/inquiry.do" style="font-size:12px;color:var(--orange);text-decoration:none">처리하기</a>
                </div>
                <div v-for="inq in waitingInquiries" :key="inq.inquiryId"
                     style="padding:10px 0;border-bottom:1px solid var(--border);">
                    <div style="font-size:13px;color:var(--text);margin-bottom:3px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                        {{ inq.title }}
                    </div>
                    <div style="font-size:11px;color:var(--text3)">{{ inq.userId }} · {{ inq.createdAt }}</div>
                </div>
                <div v-if="!waitingInquiries.length" style="text-align:center;padding:20px;color:var(--text3);font-size:13px">
                    ✅ 미답변 문의 없음
                </div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    인기 상품 TOP 5
                    <span>조회수 기준</span>
                </div>
                <div v-for="(p, i) in topProducts" :key="p.productId"
                     style="display:flex;align-items:center;gap:12px;padding:8px 0;border-bottom:1px solid var(--border)">
                    <div style="width:22px;height:22px;border-radius:50%;background:var(--bg3);display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:var(--orange);flex-shrink:0">
                        {{ i+1 }}
                    </div>
                    <div style="flex:1;min-width:0">
                        <div style="font-size:13px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{{ p.productName }}</div>
                        <div style="font-size:11px;color:var(--text3)">조회 {{ (p.viewCount || 0).toLocaleString() }}회</div>
                    </div>
                    <div style="font-size:12px;color:var(--orange)">{{ fnPrice(p.price) }}</div>
                </div>
                <div v-if="!topProducts.length" style="text-align:center;padding:20px;color:var(--text3);font-size:13px">
                    인기 상품 데이터 없음
                </div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    회원 등급 분포
                    <a href="/admin/members.do" style="font-size:12px;color:var(--orange);text-decoration:none">전체보기</a>
                </div>
                <div v-for="grade in gradeStats" :key="grade.gradeId"
                     style="margin-bottom:14px">
                    <div style="display:flex;justify-content:space-between;margin-bottom:4px">
                        <span style="font-size:12px">{{ grade.gradeName }}</span>
                        <span style="font-size:12px;color:var(--text2)">{{ grade.count || 0 }}명</span>
                    </div>
                    <div style="height:6px;background:var(--bg3);border-radius:3px;overflow:hidden">
                        <div :style="'width:' + (grade.count / (stats.totalUsers || 1) * 100) + '%; height:100%; background:var(--orange); border-radius:3px; transition:width .8s'"></div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            // 초기값 설정으로 렌더링 시 undefined 에러 2차 방어
            stats: { monthSales:0, salesChange:0, totalUsers:0, newUsers:0, activeOrders:0, rentingCount:0, shippingCount:0, waitingInquiry:0, totalInquiry:0 },
            salesChart: [],
            recentOrders: [],
            waitingInquiries: [],
            topProducts: [],
            gradeStats: []
        };
    },
    computed: {
        maxSales() {
            if(!this.salesChart.length) return 1;
            return Math.max(...this.salesChart.map(s => s.amount), 1);
        }
    },
    methods: {
        fnLoad() {
            $.ajax({
                url: '/admin/dashboard.dox', 
                type: 'POST', 
                dataType: 'json',
                success: (res) => {
                    if (res.result === 'success') {
                        this.stats           = res.stats           || this.stats;
                        this.salesChart      = res.salesChart      || [];
                        this.recentOrders    = res.recentOrders    || [];
                        this.waitingInquiries= res.waitingInquiries|| [];
                        this.topProducts     = res.topProducts     || [];
                        this.gradeStats      = res.gradeStats      || [];
                    }
                },
                error: (err) => {
                    console.error("Dashboard Load Error:", err);
                }
            });
        },
        // 💰 가격 포맷팅 및 null 방어 함수
        fnPrice(v) { 
            return Number(v || 0).toLocaleString() + '원'; 
        },
        fnOrderBadge(s) {
            const m = { PAID:'badge-active', READY:'badge-wait', SHIPPING:'badge-active', DONE:'badge-done', CANCELLED:'badge-cancel' };
            return m[s] || 'badge-wait';
        },
        fnOrderText(s) {
            const m = { PAID:'결제완료', READY:'배송준비', SHIPPING:'배송중', DONE:'완료', CANCELLED:'취소' };
            return m[s] || s;
        }
    },
    mounted() { 
        this.fnLoad(); 
    }
}).mount('#app');
</script>
</body>
</html>