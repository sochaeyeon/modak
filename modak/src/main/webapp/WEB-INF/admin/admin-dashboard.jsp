<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 관리자 대시보드</title>
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

    <!-- ── 상단바 ── -->
    <div class="admin-topbar">
        <div class="topbar-title">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                 style="width:18px;height:18px;vertical-align:middle;margin-right:7px;color:#E8732A">
                <rect x="3" y="3" width="7" height="7" rx="1.5"/>
                <rect x="14" y="3" width="7" height="7" rx="1.5"/>
                <rect x="3" y="14" width="7" height="7" rx="1.5"/>
                <rect x="14" y="14" width="7" height="7" rx="1.5"/>
            </svg>
            대시보드
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-dot"></div>
                관리자 접속중
            </div>
            <button class="db-site-btn" onclick="location.href='/main.do'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:13px;height:13px">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                </svg>
                사이트로
            </button>
        </div>
    </div>

    <div class="admin-content" id="app" v-cloak>

        <!-- ══ 헤더 배너 ══ -->
        <div class="db-banner">
            <div class="db-banner-orb db-orb-1"></div>
            <div class="db-banner-orb db-orb-2"></div>
            <div class="db-banner-left">
                <div class="db-banner-eyebrow">MODAK MODAK ADMIN</div>
                <div class="db-banner-greeting">
                    🔥&nbsp; 모닥모닥 관리 센터
                </div>
                <div class="db-banner-date">{{ today }}</div>
            </div>
            <div class="db-banner-right">
                <div class="db-clock-wrap">
                    <div class="db-live-clock">{{ currentTime }}</div>
                    <div class="db-clock-label">현재 시각</div>
                </div>
                <button class="db-refresh-btn" @click="fnLoad" :class="{spinning: isLoading}">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="23 4 23 10 17 10"/>
                        <polyline points="1 20 1 14 7 14"/>
                        <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>
                    </svg>
                    새로고침
                </button>
            </div>
        </div>

        <!-- ══ 통계 카드 ══ -->
        <div class="stat-grid">

            <!-- 매출 -->
            <a href="/admin/sales.do" class="db-stat-card db-stat-link" style="--c:#E8732A;--cb:rgba(232,115,42,.18)">
                <div class="dsc-glow"></div>
                <div class="dsc-top">
                    <div class="dsc-icon-box" style="background:rgba(232,115,42,.15);color:#E8732A">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="1" x2="12" y2="23"/>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                        </svg>
                    </div>
                    <span class="dsc-label">이번달 매출</span>
                </div>
                <div class="dsc-value">{{ fnPrice(stats.monthSales) }}</div>
                <div class="dsc-change" :class="(stats.salesChange||0) >= 0 ? 'up' : 'down'">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="dsc-arrow">
                        <polyline v-if="(stats.salesChange||0) >= 0" points="18 15 12 9 6 15"/>
                        <polyline v-else points="6 9 12 15 18 9"/>
                    </svg>
                    전월 대비 {{ Math.abs(stats.salesChange||0) }}%
                </div>
                <div class="dsc-accent-bar"></div>
                <div class="dsc-goto-arrow">→</div>
            </a>

            <!-- 회원 -->
            <a href="/admin/members.do" class="db-stat-card db-stat-link" style="--c:#3498DB;--cb:rgba(52,152,219,.18)">
                <div class="dsc-glow"></div>
                <div class="dsc-top">
                    <div class="dsc-icon-box" style="background:rgba(52,152,219,.15);color:#3498DB">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <span class="dsc-label">전체 회원</span>
                </div>
                <div class="dsc-value">{{ (stats.totalUsers||0).toLocaleString() }}<span class="dsc-unit">명</span></div>
                <div class="dsc-change up">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="dsc-arrow">
                        <polyline points="18 15 12 9 6 15"/>
                    </svg>
                    이번달 {{ stats.newUsers||0 }}명 신규
                </div>
                <div class="dsc-accent-bar"></div>
                <div class="dsc-goto-arrow">→</div>
            </a>

            <!-- 주문 -->
            <a href="/admin/orders.do" class="db-stat-card db-stat-link" style="--c:#2ECC71;--cb:rgba(46,204,113,.18)">
                <div class="dsc-glow"></div>
                <div class="dsc-top">
                    <div class="dsc-icon-box" style="background:rgba(46,204,113,.15);color:#2ECC71">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                            <line x1="3" y1="6" x2="21" y2="6"/>
                            <path d="M16 10a4 4 0 0 1-8 0"/>
                        </svg>
                    </div>
                    <span class="dsc-label">진행중 주문</span>
                </div>
                <div class="dsc-value">{{ stats.activeOrders||0 }}<span class="dsc-unit">건</span></div>
                <div class="dsc-change neutral">
                    대여중 {{ stats.rentingCount||0 }} &nbsp;·&nbsp; 배송중 {{ stats.shippingCount||0 }}
                </div>
                <div class="dsc-accent-bar"></div>
                <div class="dsc-goto-arrow">→</div>
            </a>

            <!-- 문의 -->
            <a href="/admin/inquiry.do" class="db-stat-card db-stat-link" :class="(stats.waitingInquiry||0) > 0 ? 'dsc-warn' : ''"
                 style="--c:#F5A623;--cb:rgba(245,166,35,.18)">
                <div class="dsc-glow"></div>
                <div class="dsc-top">
                    <div class="dsc-icon-box" style="background:rgba(245,166,35,.15);color:#F5A623">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                    </div>
                    <span class="dsc-label">미답변 문의</span>
                </div>
                <div class="dsc-value" :class="(stats.waitingInquiry||0) > 0 ? 'val-warn' : ''">
                    {{ stats.waitingInquiry||0 }}<span class="dsc-unit">건</span>
                </div>
                <div class="dsc-change neutral">전체 문의 {{ stats.totalInquiry||0 }}건</div>
                <div class="dsc-accent-bar"></div>
                <div class="dsc-goto-arrow">→</div>
            </a>

        </div>

        <!-- ══ 차트 + 최근 주문 ══ -->
        <div class="db-grid-2">

            <!-- 월별 매출 차트 -->
            <div class="db-card">
                <div class="db-card-header">
                    <div class="db-card-title">
                        <div class="db-title-bar" style="background:#E8732A"></div>
                        월별 매출 현황
                    </div>
                    <span class="db-card-sub">최근 6개월</span>
                </div>
                <div class="db-chart-outer">
                    <div class="db-chart-y">
                        <span v-for="n in 5" :key="n">{{ fnShortPrice(maxSales / 4 * (5 - n)) }}</span>
                    </div>
                    <div class="db-chart-inner">
                        <div class="db-chart-grid">
                            <div v-for="n in 4" :key="n" class="db-chart-gridline"></div>
                        </div>
                        <div class="db-bars">
                            <div v-for="(item, i) in salesChart" :key="i" class="db-bar-col">
                                <div class="db-bar-tip">{{ fnPrice(item.amount) }}</div>
                                <div class="db-bar"
                                     :class="i === salesChart.length-1 ? 'db-bar-hot' : ''"
                                     :style="'height:' + Math.max(item.amount/maxSales*140, 4) + 'px'">
                                    <div class="db-bar-shine"></div>
                                </div>
                                <div class="db-bar-lbl">{{ item.month }}</div>
                            </div>
                            <div v-if="!salesChart.length" class="db-no-data">데이터 없음</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 최근 주문 -->
            <div class="db-card">
                <div class="db-card-header">
                    <div class="db-card-title">
                        <div class="db-title-bar" style="background:#2ECC71"></div>
                        최근 주문 현황
                    </div>
                    <a href="/admin/orders.do" class="db-card-link">전체보기 →</a>
                </div>
                <table class="db-table">
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th style="text-align:left">상품명</th>
                            <th>금액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="order in recentOrders" :key="order.orderId">
                            <td><span class="db-ord-id">#{{ order.orderId }}</span></td>
                            <td class="db-td-clip">{{ order.productName }}</td>
                            <td class="db-ord-price">{{ fnPrice(order.totalPrice) }}</td>
                            <td>
                                <span class="db-badge" :class="'ob-' + fnOrderBadge(order.orderStatus)">
                                    {{ fnOrderText(order.orderStatus) }}
                                </span>
                            </td>
                        </tr>
                        <tr v-if="!recentOrders.length">
                            <td colspan="4" class="db-empty-td">주문 내역 없음</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ══ 문의 + 인기상품 + 등급 ══ -->
        <div class="db-grid-3">

            <!-- 미답변 문의 -->
            <div class="db-card">
                <div class="db-card-header">
                    <div class="db-card-title">
                        <div class="db-title-bar" style="background:#F5A623"></div>
                        미답변 문의
                    </div>
                    <a href="/admin/inquiry.do" class="db-card-link">처리하기 →</a>
                </div>
                <template v-if="waitingInquiries.length">
                    <div v-for="inq in waitingInquiries" :key="inq.inquiryId" class="db-inq-row">
                        <div class="db-inq-pulse"></div>
                        <div class="db-inq-body">
                            <div class="db-inq-title">{{ inq.title }}</div>
                            <div class="db-inq-meta">{{ inq.userId }} · {{ inq.createdAt }}</div>
                        </div>
                        <a href="/admin/inquiry.do" class="db-inq-go">→</a>
                    </div>
                </template>
                <div v-else class="db-empty-box">
                    <div class="db-empty-emoji">✅</div>
                    <div>미답변 문의 없음</div>
                </div>
            </div>

            <!-- 인기 상품 TOP 5 (주문수 기준) -->
            <div class="db-card">
                <div class="db-card-header">
                    <div class="db-card-title">
                        <div class="db-title-bar" style="background:#E8732A"></div>
                        인기 상품 TOP 5
                    </div>
                    <span class="db-badge ob-view">🛒 주문수 기준</span>
                </div>
                <template v-if="topProducts.length">
                    <div v-for="(p, i) in topProducts" :key="p.productId" class="db-prod-row">
                        <div class="db-prod-rank" :class="'dr-' + (i+1)">
                            <template v-if="i===0">🥇</template>
                            <template v-else-if="i===1">🥈</template>
                            <template v-else-if="i===2">🥉</template>
                            <template v-else>{{ i+1 }}</template>
                        </div>
                        <img v-if="p.imgUrl" :src="p.imgUrl" class="db-prod-img" :alt="p.productName">
                        <div v-else class="db-prod-img db-prod-img-ph">⛺</div>
                        <div class="db-prod-info">
                            <div class="db-prod-name">{{ p.productName }}</div>
                            <div class="db-prod-bar-wrap">
                                <div class="db-prod-bar-bg">
                                    <div class="db-prod-bar"
                                         :style="'width:' + Math.round((p.orderCount||0) / (maxOrderCount||1) * 100) + '%'">
                                    </div>
                                </div>
                                <span class="db-prod-views">{{ (p.orderCount||0).toLocaleString() }}건</span>
                            </div>
                            <div class="db-prod-views-sub">조회 {{ (p.viewCount||0).toLocaleString() }}회</div>
                        </div>
                        <div class="db-prod-price">{{ fnPrice(p.price) }}</div>
                    </div>
                </template>
                <div v-else class="db-empty-box">
                    <div class="db-empty-emoji">📦</div>
                    <div>인기 상품 데이터 없음</div>
                </div>
            </div>

            <!-- 회원 등급 분포 -->
            <div class="db-card">
                <div class="db-card-header">
                    <div class="db-card-title">
                        <div class="db-title-bar" style="background:#9B59B6"></div>
                        회원 등급 분포
                    </div>
                    <a href="/admin/members.do" class="db-card-link">전체보기 →</a>
                </div>
                <template v-if="gradeStats.length">
                    <div v-for="(g, i) in gradeStats" :key="g.gradeId" class="db-grade-row">
                        <div class="db-grade-head">
                            <div class="db-grade-dot-wrap">
                                <span class="db-grade-dot" :class="'gdot-' + i"></span>
                                <span class="db-grade-name">{{ g.gradeName }}</span>
                            </div>
                            <span class="db-grade-stat">
                                {{ (g.count||0).toLocaleString() }}명
                                <span class="db-grade-pct">({{ stats.totalUsers > 0 ? Math.round(g.count/stats.totalUsers*100) : 0 }}%)</span>
                            </span>
                        </div>
                        <div class="db-grade-track">
                            <div class="db-grade-fill" :class="'gfill-' + i"
                                 :style="'width:' + Math.min(g.count/(stats.totalUsers||1)*100, 100) + '%'">
                            </div>
                        </div>
                    </div>
                </template>
                <div v-else class="db-empty-box">
                    <div class="db-empty-emoji">👥</div>
                    <div>등급 데이터 없음</div>
                </div>
            </div>
        </div>

        <!-- ══ 바로가기 ══ -->
        <div class="db-card db-shortcuts-card">
            <div class="db-card-header">
                <div class="db-card-title">
                    <div class="db-title-bar" style="background:#8890a8"></div>
                    빠른 바로가기
                </div>
                <span class="db-card-sub">주요 관리 메뉴</span>
            </div>
            <div class="db-sc-grid">
                <a href="/admin/members.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(52,152,219,.15);color:#3498DB">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <span>회원 관리</span>
                </a>
                <a href="/admin/orders.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(46,204,113,.15);color:#2ECC71">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                            <line x1="3" y1="6" x2="21" y2="6"/>
                            <path d="M16 10a4 4 0 0 1-8 0"/>
                        </svg>
                    </div>
                    <span>주문 관리</span>
                </a>
                <a href="/admin/products.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(232,115,42,.15);color:#E8732A">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                            <line x1="7" y1="7" x2="7.01" y2="7"/>
                        </svg>
                    </div>
                    <span>상품 관리</span>
                </a>
                <a href="/admin/rentals.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(155,89,182,.15);color:#9B59B6">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                            <polyline points="9 22 9 12 15 12 15 22"/>
                        </svg>
                    </div>
                    <span>대여 관리</span>
                </a>
                <a href="/admin/inquiry.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(245,166,35,.15);color:#F5A623">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                    </div>
                    <span>문의 관리</span>
                </a>
                <a href="/admin/coupon.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(231,76,60,.15);color:#E74C3C">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                    </div>
                    <span>쿠폰 관리</span>
                </a>
                <a href="/admin/events.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(46,204,113,.12);color:#27AE60">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                        </svg>
                    </div>
                    <span>이벤트</span>
                </a>
                <a href="/admin/stats.do" class="db-sc">
                    <div class="db-sc-icon" style="--ic:rgba(52,152,219,.15);color:#2980B9">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10"/>
                            <line x1="12" y1="20" x2="12" y2="4"/>
                            <line x1="6" y1="20" x2="6" y2="14"/>
                        </svg>
                    </div>
                    <span>통계</span>
                </a>
            </div>
        </div>

    </div><!-- admin-content / #app -->
</div><!-- admin-main -->

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            today: '', currentTime: '',
            isLoading: false,
            stats: { monthSales:0, salesChange:0, totalUsers:0, newUsers:0,
                     activeOrders:0, rentingCount:0, shippingCount:0,
                     waitingInquiry:0, totalInquiry:0 },
            salesChart: [],
            recentOrders: [],
            waitingInquiries: [],
            topProducts: [],
            gradeStats: []
        };
    },
    computed: {
        maxSales() {
            return Math.max(...this.salesChart.map(s => Number(s.amount)||0), 1);
        },
        maxOrderCount() {
            return Math.max(...this.topProducts.map(p => Number(p.orderCount)||0), 1);
        }
    },
    methods: {
        fnLoad() {
            this.isLoading = true;
            $.ajax({
                url: '/admin/dashboard.dox', type: 'POST', dataType: 'json',
                success: (res) => {
                    this.isLoading = false;
                    console.log('[Dashboard]', res);
                    if (res.result === 'success') {
                        this.stats            = res.stats            || this.stats;
                        this.salesChart       = res.salesChart       || [];
                        this.recentOrders     = res.recentOrders     || [];
                        this.waitingInquiries = res.waitingInquiries || [];
                        this.topProducts      = res.topProducts      || [];
                        this.gradeStats       = res.gradeStats       || [];
                        console.log('[topProducts]', this.topProducts);
                    } else {
                        console.error('[Dashboard fail]', res.message);
                    }
                },
                error: (err) => { this.isLoading = false; console.error('[Dashboard AJAX error]', err); }
            });
        },
        fnPrice(v) { return Number(v||0).toLocaleString() + '원'; },
        fnShortPrice(v) {
            const n = Number(v||0);
            if (n >= 100000000) return (n/100000000).toFixed(1) + '억';
            if (n >= 10000)     return Math.round(n/10000) + '만';
            return n.toLocaleString();
        },
        fnOrderBadge(s) {
            return { PAID:'paid', READY:'wait', SHIPPING:'ship', DONE:'done', CANCELLED:'cancel' }[s] || 'wait';
        },
        fnOrderText(s) {
            return { PAID:'결제완료', READY:'배송준비', SHIPPING:'배송중', DONE:'완료', CANCELLED:'취소' }[s] || s;
        },
        fnTick() {
            const n = new Date();
            this.currentTime = String(n.getHours()).padStart(2,'0') + ':' +
                               String(n.getMinutes()).padStart(2,'0') + ':' +
                               String(n.getSeconds()).padStart(2,'0');
        }
    },
    mounted() {
        const n = new Date();
        const d = ['일','월','화','수','목','금','토'];
        this.today = n.getFullYear() + '년 ' + (n.getMonth()+1) + '월 ' + n.getDate() + '일 (' + d[n.getDay()] + ')';
        this.fnTick();
        setInterval(() => this.fnTick(), 1000);
        this.fnLoad();
    }
}).mount('#app');
</script>
</body>
</html>
