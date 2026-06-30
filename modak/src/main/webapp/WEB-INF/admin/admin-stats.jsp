<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>조회수 통계 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-stats.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="st-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="st-header">
        <div class="st-title-wrap">
            <div class="st-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                </svg>
            </div>
            <div>
                <div class="st-page-title">상품 조회수 통계</div>
                <div class="st-page-sub">상품별 누적 조회수 순위 및 인기 비중을 확인합니다</div>
            </div>
        </div>
        <div class="st-header-actions">
            <button class="st-refresh-btn" @click="fnGetStats" :class="{spinning: isLoading}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="23 4 23 10 17 10"/>
                    <polyline points="1 20 1 14 7 14"/>
                    <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>
                </svg>
                새로고침
            </button>
            <button class="st-back-btn" onclick="location.href='/admin/dashboard.do'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="7" height="7" rx="1"/>
                    <rect x="14" y="3" width="7" height="7" rx="1"/>
                    <rect x="3" y="14" width="7" height="7" rx="1"/>
                    <rect x="14" y="14" width="7" height="7" rx="1"/>
                </svg>
                대시보드
            </button>
        </div>
    </div>

    <!-- ── KPI 카드 ── -->
    <div class="st-kpi-grid">

        <div class="st-kpi-card" style="--kc:#E8732A;--kcb:rgba(232,115,42,.18)">
            <div class="st-kpi-glow"></div>
            <div class="st-kpi-top">
                <span class="st-kpi-label">조회 대상 상품</span>
                <div class="st-kpi-icon" style="background:rgba(232,115,42,.15);color:#E8732A">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                        <line x1="7" y1="7" x2="7.01" y2="7"/>
                    </svg>
                </div>
            </div>
            <div class="st-kpi-val">{{ statsList.length }}<span class="st-kpi-unit">개</span></div>
            <div class="st-kpi-sub">조회수 상위 상품</div>
            <div class="st-kpi-bar"></div>
        </div>

        <div class="st-kpi-card" style="--kc:#3498DB;--kcb:rgba(52,152,219,.18)">
            <div class="st-kpi-glow"></div>
            <div class="st-kpi-top">
                <span class="st-kpi-label">총 누적 조회수</span>
                <div class="st-kpi-icon" style="background:rgba(52,152,219,.15);color:#3498DB">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                        <circle cx="12" cy="12" r="3"/>
                    </svg>
                </div>
            </div>
            <div class="st-kpi-val">{{ totalViews.toLocaleString() }}<span class="st-kpi-unit">회</span></div>
            <div class="st-kpi-sub">상위 {{ statsList.length }}개 합산</div>
            <div class="st-kpi-bar"></div>
        </div>

        <div class="st-kpi-card" style="--kc:#2ECC71;--kcb:rgba(46,204,113,.18)">
            <div class="st-kpi-glow"></div>
            <div class="st-kpi-top">
                <span class="st-kpi-label">평균 조회수</span>
                <div class="st-kpi-icon" style="background:rgba(46,204,113,.15);color:#2ECC71">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="20" x2="18" y2="10"/>
                        <line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                </div>
            </div>
            <div class="st-kpi-val">{{ avgViews.toLocaleString() }}<span class="st-kpi-unit">회</span></div>
            <div class="st-kpi-sub">상품당 평균</div>
            <div class="st-kpi-bar"></div>
        </div>

        <div class="st-kpi-card" style="--kc:#F5A623;--kcb:rgba(245,166,35,.18)">
            <div class="st-kpi-glow"></div>
            <div class="st-kpi-top">
                <span class="st-kpi-label">1위 상품</span>
                <div class="st-kpi-icon" style="background:rgba(245,166,35,.15);color:#F5A623">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                    </svg>
                </div>
            </div>
            <div class="st-kpi-val st-kpi-name">{{ topProduct.PRODUCT_NAME || '-' }}</div>
            <div class="st-kpi-sub">{{ (topProduct.VIEW_COUNT || 0).toLocaleString() }}회 조회</div>
            <div class="st-kpi-bar"></div>
        </div>

    </div>

    <!-- ── 차트 + 테이블 ── -->
    <div class="st-main-grid">

        <!-- 수평 바 차트 -->
        <div class="st-card st-chart-card">
            <div class="st-card-header">
                <div class="st-card-title">
                    <div class="st-title-dot" style="background:#E8732A"></div>
                    TOP 10 조회수 차트
                </div>
                <span class="st-card-sub">조회수 기준 상위 10개</span>
            </div>
            <div class="st-chart-wrap">
                <canvas id="viewChart"></canvas>
            </div>
            <div v-if="!statsList.length" class="st-chart-empty">
                <div>📊</div>
                <div>데이터를 불러오는 중...</div>
            </div>
        </div>

        <!-- 상세 테이블 -->
        <div class="st-card st-table-card">
            <div class="st-card-header">
                <div class="st-card-title">
                    <div class="st-title-dot" style="background:#3498DB"></div>
                    상품별 상세 순위
                </div>
                <span class="st-card-sub">{{ statsList.length }}개 상품</span>
            </div>
            <div class="st-table-wrap">
                <table class="st-table">
                    <thead>
                        <tr>
                            <th style="width:40px">#</th>
                            <th style="width:52px">이미지</th>
                            <th style="text-align:left">상품명</th>
                            <th style="width:90px">조회수</th>
                            <th style="width:120px">비중</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, i) in statsList" :key="item.PRODUCT_ID"
                            :class="i === 0 ? 'st-top-row' : ''">
                            <td>
                                <span class="st-rank">
                                    <template v-if="i===0">🥇</template>
                                    <template v-else-if="i===1">🥈</template>
                                    <template v-else-if="i===2">🥉</template>
                                    <template v-else>{{ i+1 }}</template>
                                </span>
                            </td>
                            <td>
                                <div class="st-prod-img">
                                    <img v-if="item.IMG_URL" :src="item.IMG_URL" :alt="item.PRODUCT_NAME">
                                    <span v-else class="st-img-ph">⛺</span>
                                </div>
                            </td>
                            <td class="st-prod-name-cell">
                                <div class="st-prod-name">{{ item.PRODUCT_NAME }}</div>
                                <div class="st-prod-id">#{{ item.PRODUCT_ID }}</div>
                            </td>
                            <td class="st-view-cnt">{{ Number(item.VIEW_COUNT || 0).toLocaleString() }}<span class="st-unit">회</span></td>
                            <td>
                                <div class="st-bar-wrap">
                                    <div class="st-bar-track">
                                        <div class="st-bar-fill"
                                             :style="'width:' + Math.round((item.VIEW_COUNT||0) / (maxViews||1) * 100) + '%'">
                                        </div>
                                    </div>
                                    <span class="st-bar-pct">{{ Math.round((item.VIEW_COUNT||0) / (maxViews||1) * 100) }}%</span>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="!statsList.length">
                            <td colspan="5" class="st-empty-td">데이터를 불러오는 중...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div><!-- st-container -->
</div><!-- #app -->

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            statsList: [],
            chartInstance: null,
            isLoading: false
        };
    },
    computed: {
        maxViews()    { return Math.max(...this.statsList.map(i => Number(i.VIEW_COUNT||0)), 1); },
        totalViews()  { return this.statsList.reduce((s, i) => s + Number(i.VIEW_COUNT||0), 0); },
        avgViews()    { return this.statsList.length ? Math.round(this.totalViews / this.statsList.length) : 0; },
        topProduct()  { return this.statsList[0] || {}; }
    },
    methods: {
        fnGetStats() {
            this.isLoading = true;
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/stats/view-data.dox',
                type: 'POST',
                success: (json) => {
                    this.isLoading = false;
                    const data = typeof json === 'string' ? JSON.parse(json) : json;
                    if (data.result === 'success') {
                        this.statsList = data.list || [];
                        this.$nextTick(() => this.fnRenderChart());
                    }
                },
                error: () => { this.isLoading = false; }
            });
        },
        fnRenderChart() {
            const canvas = document.getElementById('viewChart');
            if (!canvas || !this.statsList.length) return;

            const ctx  = canvas.getContext('2d');
            const top  = this.statsList.slice(0, 10);
            const labels = top.map(i => i.PRODUCT_NAME.length > 12 ? i.PRODUCT_NAME.slice(0, 12) + '…' : i.PRODUCT_NAME);
            const data   = top.map(i => Number(i.VIEW_COUNT || 0));
            const max    = Math.max(...data, 1);

            /* 순위별 색상 — 1위 밝은 오렌지 → 점점 흐려짐 */
            const colors = data.map((_, i) => {
                const alpha = Math.max(0.9 - i * 0.07, 0.25);
                return `rgba(232,115,42,${alpha})`;
            });
            const borders = data.map(() => 'rgba(232,115,42,.7)');

            if (this.chartInstance) this.chartInstance.destroy();

            Chart.defaults.color       = '#8890a8';
            Chart.defaults.borderColor = 'rgba(255,255,255,.05)';
            Chart.defaults.font.family = 'inherit';

            this.chartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                        label: '조회수',
                        data,
                        backgroundColor: colors,
                        borderColor: borders,
                        borderWidth: 1,
                        borderRadius: 6,
                        borderSkipped: false,
                        barThickness: 28
                    }]
                },
                options: {
                    indexAxis: 'y',   /* 수평 바 차트 */
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#1f2235',
                            borderColor: 'rgba(255,255,255,.12)',
                            borderWidth: 1,
                            padding: 12,
                            callbacks: {
                                label: (ctx) => '  조회수  ' + Number(ctx.raw).toLocaleString() + '회'
                            }
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true,
                            grid: { color: 'rgba(255,255,255,.04)' },
                            ticks: {
                                font: { size: 10 },
                                callback: v => v >= 1000 ? Math.round(v/1000) + 'k' : v
                            }
                        },
                        y: {
                            grid: { display: false },
                            ticks: { font: { size: 12 } }
                        }
                    }
                }
            });
        }
    },
    mounted() { this.fnGetStats(); }
}).mount('#app');
</script>
</body>
</html>
