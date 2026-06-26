<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매출 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-sales.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main sp-root" v-cloak>
<div class="sp-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="sp-header">
        <div class="sp-title-wrap">
            <div class="sp-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="1" x2="12" y2="23"/>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                </svg>
            </div>
            <div>
                <div class="sp-page-title">매출 데이터 인사이트</div>
                <div class="sp-page-sub">일자별 매출 현황 및 주문 통계를 확인합니다</div>
            </div>
        </div>
        <button class="sp-back-btn" @click="location.href='/admin/dashboard.do'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── KPI 카드 ── -->
    <div class="sp-kpi-grid">

        <div class="sp-kpi-card" style="--kc:#E8732A;--kcb:rgba(232,115,42,.18)">
            <div class="sp-kpi-glow"></div>
            <div class="sp-kpi-top">
                <span class="sp-kpi-label">총 매출</span>
                <div class="sp-kpi-icon" style="background:rgba(232,115,42,.15);color:#E8732A">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="1" x2="12" y2="23"/>
                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                    </svg>
                </div>
            </div>
            <div class="sp-kpi-val">{{ fnPrice(totalSales) }}</div>
            <div class="sp-kpi-sub">최근 {{ salesList.length }}일 합계</div>
            <div class="sp-kpi-bar"></div>
        </div>

        <div class="sp-kpi-card" style="--kc:#3498DB;--kcb:rgba(52,152,219,.18)">
            <div class="sp-kpi-glow"></div>
            <div class="sp-kpi-top">
                <span class="sp-kpi-label">일 평균 매출</span>
                <div class="sp-kpi-icon" style="background:rgba(52,152,219,.15);color:#3498DB">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                </div>
            </div>
            <div class="sp-kpi-val">{{ fnPrice(avgSales) }}</div>
            <div class="sp-kpi-sub">일 평균 기준</div>
            <div class="sp-kpi-bar"></div>
        </div>

        <div class="sp-kpi-card" style="--kc:#2ECC71;--kcb:rgba(46,204,113,.18)">
            <div class="sp-kpi-glow"></div>
            <div class="sp-kpi-top">
                <span class="sp-kpi-label">총 주문 수</span>
                <div class="sp-kpi-icon" style="background:rgba(46,204,113,.15);color:#2ECC71">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                </div>
            </div>
            <div class="sp-kpi-val">{{ totalOrders.toLocaleString() }}<span class="sp-kpi-unit">건</span></div>
            <div class="sp-kpi-sub">취소·환불 제외</div>
            <div class="sp-kpi-bar"></div>
        </div>

        <div class="sp-kpi-card" style="--kc:#F5A623;--kcb:rgba(245,166,35,.18)">
            <div class="sp-kpi-glow"></div>
            <div class="sp-kpi-top">
                <span class="sp-kpi-label">최고 매출일</span>
                <div class="sp-kpi-icon" style="background:rgba(245,166,35,.15);color:#F5A623">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                    </svg>
                </div>
            </div>
            <div class="sp-kpi-val sp-kpi-date">{{ bestDay.SALES_DATE || '-' }}</div>
            <div class="sp-kpi-sub">{{ fnPrice(bestDay.TOTAL_AMOUNT) }}</div>
            <div class="sp-kpi-bar"></div>
        </div>

    </div>

    <!-- ── 차트 + 테이블 ── -->
    <div class="sp-main-grid">

        <!-- 차트 카드 -->
        <div class="sp-card sp-chart-card">
            <div class="sp-card-header">
                <div class="sp-card-title">
                    <div class="sp-title-dot" style="background:#E8732A"></div>
                    일자별 매출 추이
                </div>
                <div class="sp-chart-legend">
                    <span class="sp-legend-dot" style="background:#E8732A"></span>
                    <span class="sp-legend-txt">매출액 (원)</span>
                    <span class="sp-legend-dot sp-legend-bar" style="background:rgba(52,152,219,.6)"></span>
                    <span class="sp-legend-txt">주문 수</span>
                </div>
            </div>
            <div class="sp-chart-wrap">
                <canvas id="salesChart"></canvas>
            </div>
            <div v-if="!salesList.length" class="sp-chart-empty">
                <div>📊</div>
                <div>매출 데이터를 불러오는 중...</div>
            </div>
        </div>

        <!-- 테이블 카드 -->
        <div class="sp-card sp-table-card">
            <div class="sp-card-header">
                <div class="sp-card-title">
                    <div class="sp-title-dot" style="background:#3498DB"></div>
                    일자별 상세 내역
                </div>
                <span class="sp-card-sub">최근 {{ salesList.length }}일</span>
            </div>
            <div class="sp-table-wrap">
                <table class="sp-table">
                    <thead>
                        <tr>
                            <th style="width:36px">#</th>
                            <th style="text-align:left">날짜</th>
                            <th>주문</th>
                            <th>매출액</th>
                            <th>전일比</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, i) in sortedList" :key="item.SALES_DATE"
                            :class="item.SALES_DATE === bestDay.SALES_DATE ? 'sp-best-row' : ''">
                            <td>
                                <span class="sp-rank" :class="'sp-rank-' + (i+1)">
                                    <template v-if="i===0">🥇</template>
                                    <template v-else-if="i===1">🥈</template>
                                    <template v-else-if="i===2">🥉</template>
                                    <template v-else>{{ i+1 }}</template>
                                </span>
                            </td>
                            <td class="sp-date-cell">{{ item.SALES_DATE }}</td>
                            <td><span class="sp-order-cnt">{{ Number(item.ORDER_COUNT||0).toLocaleString() }}건</span></td>
                            <td class="sp-amt">{{ fnPrice(item.TOTAL_AMOUNT) }}</td>
                            <td>
                                <span v-if="i < sortedList.length - 1" class="sp-trend"
                                      :class="Number(item.TOTAL_AMOUNT) >= Number(sortedList[i+1].TOTAL_AMOUNT) ? 'sp-up' : 'sp-down'">
                                    <template v-if="Number(item.TOTAL_AMOUNT) >= Number(sortedList[i+1].TOTAL_AMOUNT)">↑</template>
                                    <template v-else>↓</template>
                                </span>
                                <span v-else class="sp-trend sp-neutral">-</span>
                            </td>
                        </tr>
                        <tr v-if="!salesList.length">
                            <td colspan="5" class="sp-empty-td">데이터를 불러오는 중...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div><!-- sp-container -->
</div><!-- #app -->

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            salesList: [],
            chartInstance: null
        };
    },
    computed: {
        sortedList() {
            return [...this.salesList].sort((a, b) => new Date(b.SALES_DATE) - new Date(a.SALES_DATE));
        },
        totalSales()  { return this.salesList.reduce((s, i) => s + Number(i.TOTAL_AMOUNT || 0), 0); },
        totalOrders() { return this.salesList.reduce((s, i) => s + Number(i.ORDER_COUNT  || 0), 0); },
        avgSales()    { return this.salesList.length ? Math.round(this.totalSales / this.salesList.length) : 0; },
        bestDay() {
            if (!this.salesList.length) return {};
            return this.salesList.reduce((a, b) =>
                Number(a.TOTAL_AMOUNT || 0) >= Number(b.TOTAL_AMOUNT || 0) ? a : b, {});
        }
    },
    methods: {
        fnGetSalesData() {
            $.ajax({
                url: '/admin/sales/data.dox', type: 'POST', dataType: 'json',
                success: (data) => {
                    if (data.result === 'success') {
                        this.salesList = data.list || [];
                        this.$nextTick(() => this.fnRenderChart());
                    }
                },
                error: () => console.error('매출 데이터 로드 실패')
            });
        },
        fnRenderChart() {
            const canvas = document.getElementById('salesChart');
            if (!canvas || !this.salesList.length) return;
            const ctx = canvas.getContext('2d');

            const sorted = [...this.salesList].sort((a, b) => new Date(a.SALES_DATE) - new Date(b.SALES_DATE));
            const labels  = sorted.map(i => i.SALES_DATE);
            const amounts = sorted.map(i => Number(i.TOTAL_AMOUNT || 0));
            const orders  = sorted.map(i => Number(i.ORDER_COUNT  || 0));

            if (this.chartInstance) this.chartInstance.destroy();

            const orangeGrad = ctx.createLinearGradient(0, 0, 0, 300);
            orangeGrad.addColorStop(0,   'rgba(232,115,42,.35)');
            orangeGrad.addColorStop(0.6, 'rgba(232,115,42,.08)');
            orangeGrad.addColorStop(1,   'rgba(232,115,42,0)');

            Chart.defaults.color        = '#8890a8';
            Chart.defaults.borderColor  = 'rgba(255,255,255,.05)';
            Chart.defaults.font.family  = 'inherit';

            this.chartInstance = new Chart(ctx, {
                data: {
                    labels,
                    datasets: [
                        {
                            type: 'line',
                            label: '매출액',
                            data: amounts,
                            yAxisID: 'yAmt',
                            borderColor: '#E8732A',
                            backgroundColor: orangeGrad,
                            borderWidth: 2.5,
                            pointRadius: 4,
                            pointBackgroundColor: '#E8732A',
                            pointBorderColor: '#1a1d2a',
                            pointBorderWidth: 2,
                            pointHoverRadius: 7,
                            fill: true,
                            tension: 0.45,
                            order: 1
                        },
                        {
                            type: 'bar',
                            label: '주문 수',
                            data: orders,
                            yAxisID: 'yOrd',
                            backgroundColor: 'rgba(52,152,219,.25)',
                            borderColor:     'rgba(52,152,219,.5)',
                            borderWidth: 1,
                            borderRadius: 4,
                            order: 2
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#1f2235',
                            borderColor: 'rgba(255,255,255,.12)',
                            borderWidth: 1,
                            padding: 12,
                            callbacks: {
                                label: (ctx) => {
                                    if (ctx.datasetIndex === 0) return '  매출  ' + Number(ctx.raw).toLocaleString() + '원';
                                    return '  주문  ' + Number(ctx.raw).toLocaleString() + '건';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: { maxRotation: 45, font: { size: 11 } }
                        },
                        yAmt: {
                            position: 'left',
                            beginAtZero: true,
                            grid: { color: 'rgba(255,255,255,.04)' },
                            ticks: {
                                font: { size: 10 },
                                callback: v => {
                                    if (v >= 100000000) return (v/100000000).toFixed(1) + '억';
                                    if (v >= 10000)     return Math.round(v/10000) + '만';
                                    return v.toLocaleString();
                                }
                            }
                        },
                        yOrd: {
                            position: 'right',
                            beginAtZero: true,
                            grid: { drawOnChartArea: false },
                            ticks: { font: { size: 10 }, stepSize: 1 }
                        }
                    }
                }
            });
        },
        fnPrice(v) { return Number(v || 0).toLocaleString() + '원'; }
    },
    mounted() { this.fnGetSalesData(); }
}).mount('#app');
</script>
</body>
</html>
