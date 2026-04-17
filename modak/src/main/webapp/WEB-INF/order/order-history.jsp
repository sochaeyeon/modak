<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>주문 전체보기</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <link rel="stylesheet" href="/css/order/order-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app">
                            <div class="order-history-page">
                                <div class="order-history-wrap">

                                    <!-- 상단 헤더 -->
                                    <div class="page-hero">
                                        <div>
                                            <div class="page-eyebrow">MY SHOPPING</div>
                                            <h2 class="page-title">주문 전체보기</h2>
                                            <p class="page-desc">
                                                주문 내역을 날짜별로 확인하고, 기간별로 간편하게 필터링할 수 있어요.
                                            </p>
                                        </div>

                                        <div class="hero-summary-card">
                                            <div class="hero-summary-label">조회 결과</div>

                                            <div class="hero-summary-value">
                                                <transition name="count-rise" mode="out-in">
                                                    <span class="result-count-number" :key="animatedCount">{{
                                                        animatedCount }}</span>
                                                </transition>
                                                <span class="result-count-unit">건</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 필터 영역 -->
                                    <div class="section-card filter-card">
                                        <div class="section-head">
                                            <h3>주문 기간 선택</h3>
                                        </div>

                                        <div class="filter-body">
                                            <div class="period-chip-wrap">
                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === 'ALL' }"
                                                    @click="fnSetPeriod('ALL')">
                                                    전체
                                                </button>

                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === '1M' }"
                                                    @click="fnSetPeriod('1M')">
                                                    1개월
                                                </button>

                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === '3M' }"
                                                    @click="fnSetPeriod('3M')">
                                                    3개월
                                                </button>

                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === '6M' }"
                                                    @click="fnSetPeriod('6M')">
                                                    6개월
                                                </button>

                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === '1Y' }"
                                                    @click="fnSetPeriod('1Y')">
                                                    1년
                                                </button>

                                                <button type="button" class="period-chip"
                                                    :class="{ active : selectedPeriod === 'CUSTOM' }"
                                                    @click="fnSetPeriod('CUSTOM')">
                                                    직접 선택
                                                </button>
                                            </div>

                                            <div class="custom-date-row" v-if="selectedPeriod === 'CUSTOM'">
                                                <div class="date-field">
                                                    <label>시작일</label>
                                                    <input type="date" v-model="startDate">
                                                </div>

                                                <div class="date-tilde">~</div>

                                                <div class="date-field">
                                                    <label>종료일</label>
                                                    <input type="date" v-model="endDate">
                                                </div>

                                                <button type="button" class="btn-save" @click="fnApplyCustomRange">
                                                    적용
                                                </button>
                                            </div>
                                            <div class="date-error-msg" v-if="dateErrorMsg">
                                                {{ dateErrorMsg }}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 주문 현황 요약 -->
                                    <div class="section-card">
                                        <div class="section-head">
                                            <h3>선택 기간 내 주문 현황</h3>
                                        </div>

                                        <div class="order-flow">
                                            <div class="flow-step" :class="{ 'has-count': statusSummary.paid > 0 }">
                                                <div class="flow-circle">💳</div>
                                                <div class="flow-count">{{ statusSummary.paid }}</div>
                                                <div class="flow-name">결제완료</div>
                                            </div>

                                            <div class="flow-arrow">›</div>

                                            <div class="flow-step" :class="{ 'has-count': statusSummary.ready > 0 }">
                                                <div class="flow-circle">📦</div>
                                                <div class="flow-count">{{ statusSummary.ready }}</div>
                                                <div class="flow-name">배송준비</div>
                                            </div>

                                            <div class="flow-arrow">›</div>

                                            <div class="flow-step" :class="{ 'has-count': statusSummary.shipping > 0 }">
                                                <div class="flow-circle">🚚</div>
                                                <div class="flow-count">{{ statusSummary.shipping }}</div>
                                                <div class="flow-name">배송중</div>
                                            </div>

                                            <div class="flow-arrow">›</div>

                                            <div class="flow-step" :class="{ 'has-count': statusSummary.done > 0 }">
                                                <div class="flow-circle">✔</div>
                                                <div class="flow-count">{{ statusSummary.done }}</div>
                                                <div class="flow-name">배송완료</div>
                                            </div>

                                            <div class="flow-arrow">›</div>

                                            <div class="flow-step" :class="{ 'has-count': statusSummary.cancelled > 0 }">
                                                <div class="flow-circle">✖</div>
                                                <div class="flow-count">{{ statusSummary.cancelled }}</div>
                                                <div class="flow-name">취소/반품</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 날짜별 주문 목록 -->
                                    <div class="section-card">
                                        <div class="section-head">
                                            <h3>날짜별 주문내역</h3>
                                        </div>

                                        <transition name="list-rise" mode="out-in">
                                            <div class="group-order-list" :key="'list-' + listAnimateKey">
                                                <div v-if="groupedOrders.length === 0" class="empty-state">
                                                    <p>선택한 기간에 주문내역이 없습니다.</p>
                                                </div>

                                                <div v-else>
                                                    <div v-for="group in groupedOrders"
                                                        :key="group.date + '-' + listAnimateKey"
                                                        class="order-date-group">
                                                        <div class="group-date-head">
                                                            <div class="group-date">{{ group.date }}</div>
                                                            <div class="group-count">{{ group.items.length }}건</div>
                                                        </div>

                                                        <div class="group-items">
                                                            <div v-for="item in group.items"
                                                                :key="item.orderId + '-' + listAnimateKey"
                                                                class="order-item-card">

                                                                <div class="order-item-left">
                                                                    <div class="order-thumb">
                                                                        <span
                                                                            v-if="item.orderType === 'PURCHASE'">🛒</span>
                                                                        <span
                                                                            v-else-if="item.orderType === 'RENTAL'">⛺</span>
                                                                        <span v-else>📦</span>
                                                                    </div>

                                                                    <div class="order-info">
                                                                        <div class="order-top-line">
                                                                            <div class="order-name">
                                                                                {{ item.productName }}
                                                                                {{ item.itemCount > 1 ? ' 외 ' +
                                                                                (item.itemCount - 1) + '건' : '' }}
                                                                            </div>

                                                                            <div class="order-sub">
                                                                                주문번호 {{ item.orderId }}
                                                                            </div>
                                                                            <span class="order-type-badge"
                                                                                :class="item.orderType === 'PURCHASE' ? 'purchase' : 'rental'">
                                                                                {{ item.orderType === 'PURCHASE' ? '구매'
                                                                                : '대여' }}
                                                                            </span>
                                                                        </div>

                                                                        <div class="order-meta">
                                                                            <span class="order-date-time">{{
                                                                                fnFormatDateTime(item.createdAt)
                                                                                }}</span>
                                                                            <span class="dot">·</span>
                                                                            <span class="order-user-id">{{ item.userId
                                                                                }}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="order-item-right">
                                                                    <div class="order-status"
                                                                        :class="'status-' + item.orderStatus">
                                                                        {{ fnGetStatusText(item.orderStatus) }}
                                                                    </div>

                                                                    <div class="order-price">
                                                                        {{ fnFormatPrice(item.totalPrice) }}
                                                                    </div>

                                                                    <div class="order-action-row">
                                                                        <button type="button"
                                                                            class="btn-outline btn-small"
                                                                            @click="fnGoOrderDetail(item.orderId)">
                                                                            주문상세
                                                                        </button>

                                                                        <button type="button"
                                                                            class="btn-outline btn-small"
                                                                            v-if="item.orderStatus === 'SHIPPING'">
                                                                            배송조회
                                                                        </button>

                                                                        <button type="button" class="btn-save btn-small"
                                                                            v-if="item.orderStatus === 'DONE'">
                                                                            리뷰작성
                                                                        </button>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </transition>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <%@ include file="/WEB-INF/common/footer.jsp" %>
                </body>

                </html>

                <script>
                    const app = Vue.createApp({
                        data() {
                            return {
                                orderList: [],
                                selectedPeriod: "ALL",
                                startDate: "",
                                endDate: "",
                                appliedStartDate: "",
                                appliedEndDate: "",
                                dateErrorMsg: "",
                                animatedCount: 0,
                                listAnimateKey: 0
                            };
                        },
                        watch: {
                            startDate() {
                                this.dateErrorMsg = "";
                            },
                            endDate() {
                                this.dateErrorMsg = "";
                            },
                            'filteredOrderList.length': function (newVal) {
                                this.animatedCount = newVal;
                            }
                        },
                        computed: {
                            filteredOrderList() {
                                const self = this;

                                if (!self.orderList || self.orderList.length === 0) {
                                    return [];
                                }

                                const today = new Date();
                                let start = null;
                                let end = null;

                                if (self.selectedPeriod === "1M") {
                                    start = new Date(today);
                                    start.setMonth(start.getMonth() - 1);
                                } else if (self.selectedPeriod === "3M") {
                                    start = new Date(today);
                                    start.setMonth(start.getMonth() - 3);
                                } else if (self.selectedPeriod === "6M") {
                                    start = new Date(today);
                                    start.setMonth(start.getMonth() - 6);
                                } else if (self.selectedPeriod === "1Y") {
                                    start = new Date(today);
                                    start.setFullYear(start.getFullYear() - 1);
                                } else if (self.selectedPeriod === "CUSTOM") {
                                    if (self.appliedStartDate) {
                                        start = new Date(self.appliedStartDate + "T00:00:00");
                                    }
                                    if (self.appliedEndDate) {
                                        end = new Date(self.appliedEndDate + "T23:59:59");
                                    }
                                }

                                return self.orderList.filter(function (item) {
                                    const orderDate = self.fnParseDate(item.createdAt);
                                    if (!orderDate) {
                                        return false;
                                    }

                                    if (start && orderDate < start) {
                                        return false;
                                    }

                                    if (end && orderDate > end) {
                                        return false;
                                    }

                                    return true;
                                });
                            },
                            groupedOrders() {
                                const self = this;
                                const groupMap = {};

                                self.filteredOrderList.forEach(function (item) {
                                    const groupKey = self.fnFormatGroupDate(item.createdAt);

                                    if (!groupMap[groupKey]) {
                                        groupMap[groupKey] = [];
                                    }

                                    groupMap[groupKey].push(item);
                                });

                                return Object.keys(groupMap).map(function (date) {
                                    return {
                                        date: date,
                                        items: groupMap[date]
                                    };
                                });
                            },
                            statusSummary() {
                                const self = this;
                                const summary = {
                                    paid: 0,
                                    ready: 0,
                                    shipping: 0,
                                    done: 0,
                                    cancelled: 0
                                };

                                self.filteredOrderList.forEach(function (item) {
                                    if (item.orderStatus === "PAID") {
                                        summary.paid++;
                                    } else if (item.orderStatus === "READY") {
                                        summary.ready++;
                                    } else if (item.orderStatus === "SHIPPING") {
                                        summary.shipping++;
                                    } else if (item.orderStatus === "DONE") {
                                        summary.done++;
                                    } else if (item.orderStatus === "CANCELLED") {
                                        summary.cancelled++;
                                    }
                                });

                                return summary;
                            }
                        },
                        methods: {
                            fnGetOrderList: function () {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/order/list.dox",
                                    dataType: "json",
                                    type: "POST",
                                    success: function (data) {
                                        if (data.result === "success" && data.list) {
                                            self.orderList = data.list;
                                        } else {
                                            self.orderList = [];
                                        }
                                    },
                                    error: function () {
                                        self.orderList = [];
                                        self.animatedCount = 0;
                                    }
                                });
                            },
                            fnSetPeriod: function (period) {
                                this.selectedPeriod = period;
                                this.dateErrorMsg = "";

                                if (period !== "CUSTOM") {
                                    this.startDate = "";
                                    this.endDate = "";
                                    this.appliedStartDate = "";
                                    this.appliedEndDate = "";
                                    this.fnRunFilterAnimation();
                                }
                            },
                            fnApplyCustomRange: function () {
                                this.dateErrorMsg = "";

                                if (!this.startDate || !this.endDate) {
                                    this.dateErrorMsg = "시작일과 종료일을 모두 선택해주세요.";
                                    return;
                                }

                                if (this.startDate > this.endDate) {
                                    this.dateErrorMsg = "시작일은 종료일보다 늦을 수 없습니다.";
                                    return;
                                }

                                this.appliedStartDate = this.startDate;
                                this.appliedEndDate = this.endDate;
                                this.fnRunFilterAnimation();
                            },
                            fnParseDate: function (value) {
                                if (!value) {
                                    return null;
                                }

                                const normalized = String(value).replace(" ", "T");
                                const date = new Date(normalized);

                                if (isNaN(date.getTime())) {
                                    return null;
                                }

                                return date;
                            },
                            fnFormatGroupDate: function (value) {
                                const date = this.fnParseDate(value);

                                if (!date) {
                                    return "-";
                                }

                                const y = date.getFullYear();
                                const m = String(date.getMonth() + 1).padStart(2, "0");
                                const d = String(date.getDate()).padStart(2, "0");

                                return y + "." + m + "." + d;
                            },
                            fnFormatDateTime: function (value) {
                                const date = this.fnParseDate(value);

                                if (!date) {
                                    return value || "-";
                                }

                                const y = date.getFullYear();
                                const m = String(date.getMonth() + 1).padStart(2, "0");
                                const d = String(date.getDate()).padStart(2, "0");
                                const hh = String(date.getHours()).padStart(2, "0");
                                const mm = String(date.getMinutes()).padStart(2, "0");

                                return y + "." + m + "." + d + " " + hh + ":" + mm;
                            },
                            fnFormatPrice: function (price) {
                                return Number(price || 0).toLocaleString() + "원";
                            },
                            fnGetStatusText: function (status) {
                                if (status === "PAID") return "결제완료";
                                if (status === "READY") return "배송준비";
                                if (status === "SHIPPING") return "배송중";
                                if (status === "DONE") return "배송완료";
                                if (status === "CANCELLED") return "취소/반품";
                                return status || "-";
                            },
                            fnGoOrderDetail: function (orderId) {
                                pageChange("/order/detail.do?orderId=" + orderId, {});
                            },
                            fnRunFilterAnimation: function () {
                                this.resultAnimateKey++;
                                this.listAnimateKey++;
                            },
                        },
                        mounted() {
                            this.fnGetOrderList();

                            this.$nextTick(() => {
                                this.animatedCount = this.filteredOrderList.length;
                            });
                        }
                    });

                    app.mount("#app");
                </script>