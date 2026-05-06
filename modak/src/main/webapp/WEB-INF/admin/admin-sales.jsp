<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>매출 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-sales.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="sales-page-container">
            
            <div class="sales-header">
                <div class="sales-title">💰 매출 데이터 인사이트</div>
                <button @click="fnGoDashboard" class="s-btn-back">
                    <span>🏠</span> 대시보드로 돌아가기
                </button>
            </div>

            <div class="sales-grid">
                <div class="chart-card">
                    <canvas id="salesChart"></canvas>
                </div>

                <div class="list-card">
                    <div class="list-title">🗓️ 최근 일자별 매출 현황</div>
                    <div style="flex:1; overflow-y: auto;">
                        <table class="s-table">
                            <thead>
                                <tr>
                                    <th>날짜</th>
                                    <th>매출액</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in salesList" :key="item.SALES_DATE">
                                    <td style="color:var(--s-text-muted)">{{ item.SALES_DATE }}</td>
                                    <td class="s-amt">{{ formatPrice(item.TOTAL_AMOUNT) }}원</td>
                                </tr>
                                <tr v-if="salesList.length === 0">
                                    <td colspan="2" style="padding: 40px; color: var(--s-text-muted);">
                                        데이터를 불러오는 중입니다...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
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
                    salesList: [],
                    chartInstance: null
                };
            },
            methods: {
                // 1. 매출 데이터 로드
                fnGetSalesData() {
                    const self = this;
                    $.ajax({
                        url: "/admin/sales/data.dox",
                        type: "POST",
                        dataType: "json",
                        success: function(data) {
                            if (data.result === "success") {
                                self.salesList = data.list;
                                self.fnRenderChart(data.list);
                            }
                        }
                    });
                },
                // 2. 다크 테마 커스텀 차트 렌더링
                fnRenderChart(list) {
                    const ctx = document.getElementById('salesChart').getContext('2d');
                    const sortedData = [...list].sort((a, b) => new Date(a.SALES_DATE) - new Date(b.SALES_DATE));
                    
                    if (this.chartInstance) this.chartInstance.destroy();
                    
                    // Chart.js 전용 폰트 색상 설정
                    Chart.defaults.color = '#8a8f9d';
                    Chart.defaults.borderColor = 'rgba(255, 255, 255, 0.05)';

                    this.chartInstance = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: sortedData.map(item => item.SALES_DATE),
                            datasets: [{
                                label: '일일 매출 (KRW)',
                                data: sortedData.map(item => item.TOTAL_AMOUNT),
                                borderColor: '#E8732A', // 메인 오렌지
                                backgroundColor: 'rgba(232, 115, 42, 0.1)',
                                borderWidth: 3,
                                pointBackgroundColor: '#E8732A',
                                pointBorderColor: '#fff',
                                pointHoverRadius: 6,
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false } // 상단 범례 숨김 (깔끔하게)
                            },
                            scales: {
                                x: { grid: { display: false } },
                                y: { 
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function(value) {
                                            return (value / 10000).toLocaleString() + '만';
                                        }
                                    }
                                }
                            }
                        }
                    });
                },
                formatPrice(val) { return Number(val || 0).toLocaleString(); },
                fnGoDashboard() { location.href = "/admin/dashboard.do"; }
            },
            mounted() {
                this.fnGetSalesData();
            }
        }).mount('#app');
    </script>
</body>
</html>