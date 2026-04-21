<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>포인트 내역</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/js/page-change.js"></script>

            <link rel="stylesheet" href="/css/user/mypage.css">
            <link rel="stylesheet" href="/css/user/point-history.css">
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app">
                    <div class="page-wrap point-history-page">
                        <main class="main full">
                            <div class="section-card">
                                <div class="section-head">
                                    <h3>포인트 · 쿠폰 내역 전체보기</h3>
                                    <a href="javascript:;" @click="fnGoMypage">마이페이지로 →</a>
                                </div>

                                <div class="benefit-summary-grid">
                                    <div class="point-summary-box">
                                        <div class="point-summary-label">현재 보유 포인트</div>
                                        <div class="point-summary-amount">
                                            {{ Number(currentPoint || 0).toLocaleString() }}<span>P</span>
                                        </div>
                                        <div class="point-summary-desc">
                                            적립 및 사용 내역을 확인할 수 있습니다.
                                        </div>
                                    </div>

                                    <div class="point-summary-box coupon-summary-box">
                                        <div class="point-summary-label">사용 가능 쿠폰</div>
                                        <div class="point-summary-amount">
                                            {{ Number(availableCouponCount || 0).toLocaleString() }}<span>장</span>
                                        </div>
                                        <div class="point-summary-desc">
                                            보유 중인 쿠폰 내역을 확인할 수 있습니다.
                                        </div>
                                    </div>
                                </div>
                                <div class="benefit-tab-wrap">
                                    <button class="benefit-tab-btn" :class="{ active: activeTab === 'point' }"
                                        @click="fnChangeTab('point')">
                                        포인트 내역
                                    </button>

                                    <button class="benefit-tab-btn" :class="{ active: activeTab === 'coupon' }"
                                        @click="fnChangeTab('coupon')">
                                        쿠폰 내역
                                    </button>
                                </div>

                                <div v-if="activeTab === 'point'">
                                    <div class="point-history-full" :key="'point-' + renderKey">
                                        <div v-if="pointList.length === 0" class="empty-state">
                                            <p>포인트 내역이 없습니다.</p>
                                        </div>

                                        <div v-for="(item, index) in pointList" :key="item.historyId"
                                            class="point-history-card"
                                            :style="{ animationDelay: (index * 0.06) + 's' }">
                                            <div class="point-history-left">
                                                <div class="point-history-desc">{{ item.description }}</div>
                                                <div class="point-history-date">{{ item.createdAt }}</div>
                                            </div>

                                            <div class="point-history-right">
                                                <div class="point-history-amount"
                                                    :class="item.type === 'PLUS' ? 'plus' : 'minus'">
                                                    {{ item.type === 'PLUS' ? '+' : '-' }}{{ Number(item.amount ||
                                                    0).toLocaleString() }}P
                                                </div>
                                                <div class="point-history-balance">
                                                    잔액 {{ Number(item.balanceAfter || 0).toLocaleString() }}P
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="paging-wrap" v-if="pointTotalPages > 1">
                                        <button class="paging-btn" :disabled="pointPage === 1"
                                            @click="fnPrevPointPage">이전</button>

                                        <button v-for="p in pointTotalPages" :key="'point-page-' + p" class="paging-btn"
                                            :class="{ active: pointPage === p }" @click="fnChangePointPage(p)">
                                            {{ p }}
                                        </button>

                                        <button class="paging-btn" :disabled="pointPage === pointTotalPages"
                                            @click="fnNextPointPage">다음</button>
                                    </div>
                                </div>
                                <div v-if="activeTab === 'coupon'">
                                    <div class="coupon-history-full" :key="'coupon-' + renderKey">
                                        <div v-if="couponList.length === 0" class="empty-state">
                                            <p>쿠폰 내역이 없습니다.</p>
                                        </div>

                                        <div v-for="(item, index) in couponList" :key="item.userCouponId"
                                            class="coupon-history-card"
                                            :style="{ animationDelay: (index * 0.06) + 's' }">
                                            <div class="coupon-history-left">
                                                <div class="coupon-history-name">{{ item.couponName }}</div>
                                                <div class="coupon-history-date">
                                                    발급일 {{ item.issuedAt }} · 만료일 {{ item.expiredAt }}
                                                </div>
                                            </div>

                                            <div class="coupon-history-right">
                                                <div class="coupon-history-status"
                                                    :class="(item.status || '').toLowerCase()">
                                                    {{ fnCouponStatusText(item.status) }}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="paging-wrap" v-if="couponTotalPages > 1">
                                        <button class="paging-btn" :disabled="couponPage === 1"
                                            @click="fnPrevCouponPage">이전</button>

                                        <button v-for="p in couponTotalPages" :key="'coupon-page-' + p"
                                            class="paging-btn" :class="{ active: couponPage === p }"
                                            @click="fnChangeCouponPage(p)">
                                            {{ p }}
                                        </button>

                                        <button class="paging-btn" :disabled="couponPage === couponTotalPages"
                                            @click="fnNextCouponPage">다음</button>
                                    </div>
                                </div>
                                
                            </div>
                        </main>
                    </div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>
        </body>

        </html>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        activeTab: "point",

                        currentPoint: 0,
                        availableCouponCount: 0,

                        pointList: [],
                        pointPage: 1,
                        pointPageSize: 10,
                        pointTotalCount: 0,

                        couponList: [],
                        couponPage: 1,
                        couponPageSize: 10,
                        couponTotalCount: 0,

                        renderKey: 0
                    };
                },
                computed: {
                    pointTotalPages() {
                        return Math.ceil(this.pointTotalCount / this.pointPageSize);
                    },
                    couponTotalPages() {
                        return Math.ceil(this.couponTotalCount / this.couponPageSize);
                    }
                },
                methods: {
                    fnGetPointHistoryList: function () {
                        let self = this;

                        $.ajax({
                            url: "/user/point/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                page: self.pointPage,
                                pageSize: self.pointPageSize
                            },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.pointList = data.list || [];
                                    self.pointTotalCount = data.totalCount || 0;

                                    if (self.pointList.length > 0 && self.pointPage === 1) {
                                        self.currentPoint = self.pointList[0].balanceAfter || 0;
                                    }

                                    self.renderKey++;
                                } else {
                                    self.pointList = [];
                                    self.pointTotalCount = 0;
                                    self.renderKey++;
                                }
                            },
                            error: function () {
                                self.pointList = [];
                                self.pointTotalCount = 0;
                                self.renderKey++;
                            }
                        });
                    },
                    fnGetCouponList: function () {
                        let self = this;

                        $.ajax({
                            url: "/user/coupon/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                page: self.couponPage,
                                pageSize: self.couponPageSize
                            },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.couponList = data.list || [];
                                    self.couponTotalCount = data.totalCount || 0;
                                    self.availableCouponCount = data.availableCouponCount || 0;
                                    self.renderKey++;
                                } else {
                                    self.couponList = [];
                                    self.couponTotalCount = 0;
                                    self.availableCouponCount = 0;
                                    self.renderKey++;
                                }
                            },
                            error: function () {
                                self.couponList = [];
                                self.couponTotalCount = 0;
                                self.availableCouponCount = 0;
                                self.renderKey++;
                            }
                        });
                    },
                    fnGoMypage: function () {
                        pageChange("/user/mypage.do", {});
                    },
                    fnChangeTab: function (tab) {
                        this.activeTab = tab;
                        this.renderKey++;
                    },

                    fnChangePointPage: function (page) {
                        if (page < 1 || page > this.pointTotalPages) return;
                        this.pointPage = page;
                        this.fnGetPointHistoryList();
                        window.scrollTo({ top: 0, behavior: "smooth" });
                    },
                    fnPrevPointPage: function () {
                        if (this.pointPage > 1) {
                            this.pointPage--;
                            this.fnGetPointHistoryList();
                            window.scrollTo({ top: 0, behavior: "smooth" });
                        }
                    },
                    fnNextPointPage: function () {
                        if (this.pointPage < this.pointTotalPages) {
                            this.pointPage++;
                            this.fnGetPointHistoryList();
                            window.scrollTo({ top: 0, behavior: "smooth" });
                        }
                    }, fnChangeCouponPage: function (page) {
                        if (page < 1 || page > this.couponTotalPages) return;
                        this.couponPage = page;
                        this.fnGetCouponList();
                        window.scrollTo({ top: 0, behavior: "smooth" });
                    },
                    fnPrevCouponPage: function () {
                        if (this.couponPage > 1) {
                            this.couponPage--;
                            this.fnGetCouponList();
                            window.scrollTo({ top: 0, behavior: "smooth" });
                        }
                    },
                    fnNextCouponPage: function () {
                        if (this.couponPage < this.couponTotalPages) {
                            this.couponPage++;
                            this.fnGetCouponList();
                            window.scrollTo({ top: 0, behavior: "smooth" });
                        }
                    },
                    fnCouponStatusText: function (status) {
                        if (status === "AVAILABLE") return "사용 가능";
                        if (status === "USED") return "사용 완료";
                        if (status === "EXPIRED") return "만료";
                        return status || "-";
                    },
                },
                mounted() {
                    this.fnGetPointHistoryList();
                    this.fnGetCouponList();
                }
            });

            app.mount("#app");
        </script>