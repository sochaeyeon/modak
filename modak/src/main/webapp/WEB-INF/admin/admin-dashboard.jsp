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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-dashboard.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
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

    <div class="admin-content" id="app" v-cloak>

        <!-- ── 헤더 배너 ── -->
        <div class="db-banner">
            <div class="db-banner-left">
                <div class="db-banner-greeting">🔥 모닥모닥 관리 센터</div>
                <div class="db-banner-date">{{ today }}</div>
            </div>
            <button class="db-refresh-btn" @click="fnLoad">⟳ 새로고침</button>
        </div>

        <!-- ── 통계 카드 4개 ── -->
        <div class="stat-grid">
            <div class="stat-card db-stat" style="--accent:var(--orange)">
                <div class="db-stat-watermark">💰</div>
                <div class="db-stat-top">
                    <span class="stat-label">이번달 매출</span>
                    <span class="db-stat-icon-sm" style="background:rgba(232,115,42,.15);color:var(--orange)">💰</span>
                </div>
                <div class="stat-value">{{ fnPrice(stats.monthSales) }}</div>
                <div class="stat-change" :class="stats.salesChange >= 0 ? 'up' : 'down'">
                    {{ stats.salesChange >= 0 ? '▲' : '▼' }} 전월 대비 {{ Math.abs(stats.salesChange || 0) }}%
                </div>
            </div>
            <div class="stat-card db-stat" style="--accent:var(--blue)">
                <div class="db-stat-watermark">👥</div>
                <div class="db-stat-top">
                    <span class="stat-label">전체 회원</span>
                    <span class="db-stat-icon-sm" style="background:rgba(52,152,219,.15);color:var(--blue)">👥</span>
                </div>
                <div class="stat-value">
                    {{ (stats.totalUsers || 0).toLocaleString() }}<span class="stat-unit">명</span>
                </div>
                <div class="stat-change up">▲ 이번달 {{ stats.newUsers || 0 }}명 신규</div>
            </div>
            <div class="stat-card db-stat" style="--accent:var(--green)">
                <div class="db-stat-watermark">📦</div>
                <div class="db-stat-top">
                    <span class="stat-label">진행중 주문</span>
                    <span class="db-stat-icon-sm" style="background:rgba(46,204,113,.15);color:var(--green)">📦</span>
                </div>
                <div class="stat-value">
                    {{ stats.activeOrders || 0 }}<span class="stat-unit">건</span>
                </div>
                <div class="stat-change neutral">
                    대여중 {{ stats.rentingCount || 0 }} / 배송중 {{ stats.shippingCount || 0 }}
                </div>
            </div>
            <div class="stat-card db-stat" style="--accent:var(--amber)">
                <div class="db-stat-watermark">💬</div>
                <div class="db-stat-top">
                    <span class="stat-label">미답변 문의</span>
                    <span class="db-stat-icon-sm" style="background:rgba(245,166,35,.15);color:var(--amber)">💬</span>
                </div>
                <div class="stat-value" :style="(stats.waitingInquiry || 0) > 0 ? 'color:var(--amber)' : ''">
                    {{ stats.waitingInquiry || 0 }}<span class="stat-unit">건</span>
                </div>
                <div class="stat-change neutral">전체 문의 {{ stats.totalInquiry || 0 }}건</div>
            </div>
        </div>

        <!-- ── 차트 + 주문 ── -->
        <div class="db-grid-2" style="margin-bottom:20px">

            <div class="a-card">
                <div class="a-card-title">
                    월별 매출 현황
                    <span>최근 6개월</span>
                </div>
                <div class="db-chart-container">
                    <div class="db-chart-grid">
                        <div class="db-grid-line" v-for="n in 4" :key="n"></div>
                    </div>
                    <div class="chart-wrap">
                        <div v-for="(item, i) in salesChart" :key="i" class="chart-bar-col">
                            <div class="chart-bar"
                                 :class="i === salesChart.length - 1 ? 'chart-bar-current' : ''"
                                 :style="'height:' + Math.max(item.amount / maxSales * 180, 4) + 'px'"
                                 :data-val="fnPrice(item.amount)">
                            </div>
                            <div class="chart-label">{{ item.month }}</div>
                        </div>
                        <div v-if="!salesChart.length" class="db-no-data">데이터 없음</div>
                    </div>
                </div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    최근 주문 현황
                    <a href="/admin/orders.do" class="card-link">전체보기 →</a>
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
                                <td style="color:var(--text2);font-family:monospace;font-size:12px">#{{ order.orderId }}</td>
                                <td class="db-td-ellipsis">{{ order.productName }}</td>
                                <td style="font-weight:700;color:var(--orange);white-space:nowrap">{{ fnPrice(order.totalPrice) }}</td>
                                <td>
                                    <span class="badge" :class="fnOrderBadge(order.orderStatus)">
                                        {{ fnOrderText(order.orderStatus) }}
                                    </span>
                                </td>
                            </tr>
                            <tr v-if="!recentOrders.length">
                                <td colspan="4" class="db-empty-cell">데이터 없음</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ── 문의 + 인기상품 + 등급분포 ── -->
        <div class="db-grid-3" style="margin-bottom:20px">

            <div class="a-card">
                <div class="a-card-title">
                    미답변 문의
                    <a href="/admin/inquiry.do" class="card-link">처리하기 →</a>
                </div>
                <div v-if="waitingInquiries.length">
                    <div v-for="inq in waitingInquiries" :key="inq.inquiryId" class="db-inq-item">
                        <div class="db-inq-dot"></div>
                        <div class="db-inq-body">
                            <div class="db-inq-title">{{ inq.title }}</div>
                            <div class="db-inq-meta">{{ inq.userId }} · {{ inq.createdAt }}</div>
                        </div>
                    </div>
                </div>
                <div v-else class="db-empty-state">✅ 미답변 문의 없음</div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    인기 상품 TOP 5
                    <span>조회수 기준</span>
                </div>
                <div v-for="(p, i) in topProducts" :key="p.productId" class="db-product-item">
                    <div class="db-rank-badge" :class="'rank-' + (i + 1)">
                        <template v-if="i === 0">🥇</template>
                        <template v-else-if="i === 1">🥈</template>
                        <template v-else-if="i === 2">🥉</template>
                        <template v-else>{{ i + 1 }}</template>
                    </div>
                    <div class="db-product-info">
                        <div class="db-product-name">{{ p.productName }}</div>
                        <div class="db-product-meta">조회 {{ (p.viewCount || 0).toLocaleString() }}회</div>
                    </div>
                    <div class="db-product-price">{{ fnPrice(p.price) }}</div>
                </div>
                <div v-if="!topProducts.length" class="db-empty-state">인기 상품 데이터 없음</div>
            </div>

            <div class="a-card">
                <div class="a-card-title">
                    회원 등급 분포
                    <a href="/admin/members.do" class="card-link">전체보기 →</a>
                </div>
                <div v-for="(grade, i) in gradeStats" :key="grade.gradeId" class="db-grade-item">
                    <div class="db-grade-header">
                        <span class="db-grade-name">{{ grade.gradeName }}</span>
                        <span class="db-grade-pct">
                            {{ (grade.count || 0).toLocaleString() }}명
                            ({{ stats.totalUsers > 0 ? Math.round(grade.count / stats.totalUsers * 100) : 0 }}%)
                        </span>
                    </div>
                    <div class="db-grade-bar-bg">
                        <div class="db-grade-bar"
                             :class="'grade-color-' + i"
                             :style="'width:' + Math.min((grade.count / (stats.totalUsers || 1) * 100), 100) + '%'">
                        </div>
                    </div>
                </div>
                <div v-if="!gradeStats.length" class="db-empty-state">등급 데이터 없음</div>
            </div>
        </div>

        <!-- ── 바로가기 ── -->
        <div class="a-card">
            <div class="a-card-title">
                바로가기
                <span>주요 관리 메뉴</span>
            </div>
            <div class="db-shortcuts">
                <a href="/admin/members.do"    class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(52,152,219,.15);color:var(--blue)">👥</span>
                    <span>회원 관리</span>
                </a>
                <a href="/admin/orders.do"     class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(46,204,113,.15);color:var(--green)">📦</span>
                    <span>주문 관리</span>
                </a>
                <a href="/admin/products.do"   class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(232,115,42,.15);color:var(--orange)">🏕️</span>
                    <span>상품 관리</span>
                </a>
                <a href="/admin/inquiry.do"    class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(245,166,35,.15);color:var(--amber)">💬</span>
                    <span>문의 관리</span>
                </a>
                <a href="/admin/coupon.do"     class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(155,89,182,.15);color:var(--purple)">🎫</span>
                    <span>쿠폰 관리</span>
                </a>
                <a href="/admin/events.do"     class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(231,76,60,.15);color:var(--red)">🎉</span>
                    <span>이벤트</span>
                </a>
                <a href="/admin/alarm.do"      class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(255,154,92,.15);color:var(--orange2)">🔔</span>
                    <span>알람 발송</span>
                </a>
                <a href="/admin/stats.do"      class="db-shortcut">
                    <span class="db-sc-icon" style="background:rgba(46,204,113,.15);color:var(--green)">📊</span>
                    <span>통계</span>
                </a>
            </div>
        </div>

    </div>
</div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            today: '',
            stats: {
                monthSales: 0, salesChange: 0, totalUsers: 0, newUsers: 0,
                activeOrders: 0, rentingCount: 0, shippingCount: 0,
                waitingInquiry: 0, totalInquiry: 0
            },
            salesChart: [],
            recentOrders: [],
            waitingInquiries: [],
            topProducts: [],
            gradeStats: []
        };
    },
    computed: {
        maxSales() {
            if (!this.salesChart.length) return 1;
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
                        this.stats            = res.stats            || this.stats;
                        this.salesChart       = res.salesChart       || [];
                        this.recentOrders     = res.recentOrders     || [];
                        this.waitingInquiries = res.waitingInquiries || [];
                        this.topProducts      = res.topProducts      || [];
                        this.gradeStats       = res.gradeStats       || [];
                    }
                },
                error: (err) => { console.error('Dashboard Load Error:', err); }
            });
        },
        fnPrice(v) {
            return Number(v || 0).toLocaleString() + '원';
        },
        fnOrderBadge(s) {
            const m = {
                PAID: 'badge-active', READY: 'badge-wait',
                SHIPPING: 'badge-active', DONE: 'badge-done', CANCELLED: 'badge-cancel'
            };
            return m[s] || 'badge-wait';
        },
        fnOrderText(s) {
            const m = {
                PAID: '결제완료', READY: '배송준비',
                SHIPPING: '배송중', DONE: '완료', CANCELLED: '취소'
            };
            return m[s] || s;
        }
    },
    mounted() {
        const now = new Date();
        const days = ['일', '월', '화', '수', '목', '금', '토'];
        this.today = now.getFullYear() + '년 '
            + (now.getMonth() + 1) + '월 '
            + now.getDate() + '일 ('
            + days[now.getDay()] + ')';
        this.fnLoad();
    }
}).mount('#app');
</script>
</body>
</html>
