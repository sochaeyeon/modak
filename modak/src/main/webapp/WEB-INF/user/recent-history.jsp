<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>최근 본 상품 전체보기</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <link rel="stylesheet" href="/css/user/recent-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app">
                            <div class="wishlist-history-page">
                                <div class="wishlist-history-wrap">

                                    <div class="page-hero">
                                        <div>
                                            <div class="page-eyebrow">MY RECENT VIEW</div>
                                            <h2 class="page-title">최근 본 상품 전체보기</h2>
                                            <p class="page-desc">
                                                최근에 확인한 상품을 한눈에 보고, 다시 상세 페이지로 이동할 수 있어요.
                                            </p>
                                        </div>

                                        <div class="hero-summary-card">
                                            <div class="hero-summary-label">최근 본 상품</div>
                                            <div class="hero-summary-value">
                                                <transition name="count-rise" mode="out-in">
                                                    <span class="result-count-number" :key="totalCount">{{ totalCount
                                                        }}</span>
                                                </transition>
                                                <span class="result-count-unit">개</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="section-card">
                                        <div class="section-head">
                                            <div class="section-head-left">
                                                <h3>전체 최근 본 상품</h3>
                                                <p class="recent-guide-text">최근 본 상품은 최대 100개까지만 보관됩니다.</p>
                                            </div>
                                        </div>

                                        <transition name="list-rise" mode="out-in">
                                            <div class="wishlist-content" :key="'recent-' + listAnimateKey">
                                                <div v-if="recentList.length === 0" class="empty-state">
                                                    <p>최근 본 상품이 없습니다.</p>
                                                </div>

                                                <div v-else class="wish-grid">
                                                    <div class="wish-item" v-for="item in recentList" :key="item.viewId"
                                                        @click="fnGoProductDetail(item.productId)">

                                                        <div class="wish-thumb">
                                                            <img :src="item.imgUrl" v-if="item.imgUrl"
                                                                style="width:100%; height:100%; object-fit:cover;">
                                                            <span v-else>🛒</span>
                                                        </div>

                                                        <div class="wish-body">
                                                            <div class="wish-name">{{ item.productName }}</div>
                                                            <div class="wish-price">{{ Number(item.price ||
                                                                0).toLocaleString() }}원</div>
                                                        </div>

                                                        <div class="wish-bottom">
                                                            <div class="wish-date">
                                                                조회일 {{ fnFormatDate(item.viewDt) }}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- 페이지네이션 -->
                                                <div v-if="totalPages > 1" class="pagination-wrap">
                                                    <button class="page-btn" :disabled="page === 1"
                                                        @click="fnChangePage(page - 1)">
                                                        이전
                                                    </button>

                                                    <button v-for="num in totalPages" :key="num" class="page-btn"
                                                        :class="{ active: page === num }" @click="fnChangePage(num)">
                                                        {{ num }}
                                                    </button>

                                                    <button class="page-btn" :disabled="page === totalPages"
                                                        @click="fnChangePage(page + 1)">
                                                        다음
                                                    </button>
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
                                recentList: [],
                                totalCount: 0,
                                page: 1,
                                pageSize: 9,
                                totalPages: 1,
                                listAnimateKey: 0
                            };
                        },
                        methods: {
                            fnGetRecentList: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/recent/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: self.page,
                                        pageSize: self.pageSize
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.recentList = data.list || [];
                                            self.totalCount = data.totalCount || 0;
                                            self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;
                                        } else {
                                            self.recentList = [];
                                            self.totalCount = 0;
                                            self.totalPages = 1;
                                        }
                                    },
                                    error: function () {
                                        self.recentList = [];
                                        self.totalCount = 0;
                                        self.totalPages = 1;
                                    }
                                });
                            },

                            fnChangePage: function (num) {
                                if (num < 1 || num > this.totalPages || num === this.page) {
                                    return;
                                }
                                this.page = num;
                                this.fnGetRecentList();
                            },

                            fnGoProductDetail: function (productId) {
                                pageChange("/product/detail.do", { productId: productId });
                            },

                            fnFormatDate: function (value) {
                                if (!value) {
                                    return "-";
                                }

                                const normalized = String(value).replace(" ", "T");
                                const date = new Date(normalized);

                                if (isNaN(date.getTime())) {
                                    return value;
                                }

                                const y = date.getFullYear();
                                const m = String(date.getMonth() + 1).padStart(2, "0");
                                const d = String(date.getDate()).padStart(2, "0");

                                return y + "." + m + "." + d;
                            }
                        },
                        mounted() {
                            this.fnGetRecentList();
                        }
                    });

                    app.mount("#app");
                </script>