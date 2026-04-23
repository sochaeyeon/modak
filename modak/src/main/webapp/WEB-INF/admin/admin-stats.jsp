<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- #{} 문법 에러 방지 --%>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>조회수 통계 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-stats.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="stats-page-container">
            <div class="stats-header">
                <div class="stats-title">📈 상품별 인기 조회수 통계</div>
            </div>

            <div class="chart-card">
                <canvas id="viewChart"></canvas>
            </div>

            <div class="stats-table-card">
                <table class="st-table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">순위</th>
                            <th style="width: 100px;">이미지</th>
                            <th style="width: 100px;">상품 ID</th>
                            <th style="text-align: left; padding-left: 20px;">상품 정보</th>
                            <th style="width: 150px;">누적 조회수</th>
                            <th style="width: 250px;">인기 비중</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in statsList" :key="item.PRODUCT_ID">
                            <td><span class="rank-badge" :class="'rank-' + (index + 1)">{{ index + 1 }}</span></td>
                            <td>
                                <div class="product-img-box">
                                    <img v-if="item.IMG_URL" :src="item.IMG_URL" alt="상품">
                                    <div v-else style="line-height:60px; font-size:10px; color:#444;">No Img</div>
                                </div>
                            </td>
                            <td style="color:var(--st-text-muted)">\#{{ item.PRODUCT_ID }}</td>
                            <td style="text-align: left; padding-left: 20px;">
                                <div style="font-weight: 600; font-size:15px;">{{ item.PRODUCT_NAME }}</div>
                            </td>
                            <td class="view-count">{{ Number(item.VIEW_COUNT).toLocaleString() }}회</td>
                            <td>
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <div style="flex:1; background:#2a2f3e; height:8px; border-radius:4px; overflow:hidden;">
                                        <div :style="{width: (item.VIEW_COUNT / maxViews * 100) + '%', background: 'var(--st-accent)', height: '100%'}"></div>
                                    </div>
                                    <span style="font-size:11px; color:var(--st-text-muted)">{{ Math.round(item.VIEW_COUNT / maxViews * 100) }}%</span>
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
                return {
                    statsList: [],
                    chartInstance: null,
                    maxViews: 1
                };
            },
            methods: {
                fnGetStats() {
                    const self = this;
                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/stats/view-data.dox",
                        type: "POST",
                        success: function(json) {
                            const data = typeof json === "string" ? JSON.parse(json) : json;
                            if (data.result === "success") {
                                self.statsList = data.list;
                                self.maxViews = Math.max(...data.list.map(i => i.VIEW_COUNT || 0), 1);
                                
                                self.$nextTick(() => {
                                    self.fnRenderChart(data.list.slice(0, 10));
                                });
                            }
                        }
                    });
                },
                fnRenderChart(list) {
                    const ctx = document.getElementById('viewChart').getContext('2d');
                    if (this.chartInstance) this.chartInstance.destroy();

                    this.chartInstance = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: list.map(i => i.PRODUCT_NAME),
                            datasets: [{
                                label: '조회수',
                                data: list.map(i => i.VIEW_COUNT),
                                backgroundColor: '#E8732A',
                                borderRadius: 10,
                                barThickness: 35
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: { legend: { display: false } },
                            scales: {
                                x: { ticks: { color: '#8a8f9d' }, grid: { display: false } },
                                y: { beginAtZero: true, ticks: { color: '#8a8f9d' }, grid: { color: 'rgba(255,255,255,0.05)' } }
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