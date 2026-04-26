<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>최근 본 상품 - 모닥모닥</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <link rel="stylesheet" href="/css/user/recent-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app" v-cloak>
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
                                            <div class="hero-summary-label">
                                                {{ searchedKeyword ? '검색 결과' : '최근 본 상품' }}
                                            </div>
                                            <div class="hero-summary-value">
                                                <span class="result-count-number">{{ totalCount }}</span>
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

                                            <div class="search-box wishlist-search-box">
                                                <input type="text" v-model="keyword" placeholder="상품명 · 카테고리 · 브랜드명 검색"
                                                    @keyup.enter="fnSearchRecent" @input="fnResetSearchIfEmpty">

                                                <button type="button" @click="fnSearchRecent">검색</button>
                                            </div>
                                        </div>

                                        <div class="wishlist-content">
                                            <div v-if="recentList.length === 0" class="empty-state">
                                                <p>{{ searchedKeyword ? '검색 결과가 없습니다.' : '최근 본 상품이 없습니다.' }}</p>
                                            </div>

                                            <div v-else class="wish-grid">
                                                <div class="wish-item" v-for="item in recentList" :key="item.viewId"
                                                    @click="fnGoProductDetail(item.productId)">

                                                    <div class="wish-thumb">
                                                        <img :src="item.imgUrl" v-if="item.imgUrl"
                                                            style="width:100%; height:100%; object-fit:cover;">
                                                        <span v-else>🛒</span>
                                                    </div>

                                                    <button type="button" class="wish-remove-icon"
                                                        :class="{ on: fnIsWished(item.productId) }" title="찜하기"
                                                        @click.stop="fnToggleWishlist(item)">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <path
                                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                        </svg>
                                                    </button>

                                                    <div class="wish-body">
                                                        <div class="wish-name-wrap">
                                                            <span class="wish-name">
                                                                {{ item.productName }}
                                                                <span v-if="item.brandName" class="wish-brand-inline">
                                                                    · {{ item.brandName }}
                                                                </span>
                                                            </span>
                                                        </div>

                                                        <div class="wish-category" v-if="item.categoryName">
                                                            {{ item.categoryName }}
                                                        </div>

                                                        <div class="wish-price">
                                                            {{ Number(item.price || 0).toLocaleString() }}원
                                                        </div>
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
                                    </div>

                                </div>
                            </div>
                            <transition name="toast-fade">
                                <div v-if="toastShow" class="modak-toast">
                                    {{ toastMessage }}
                                </div>
                            </transition>
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
                                wishlist: [],
                                toastMessage: "",
                                toastShow: false,
                                toastTimer: null,
                                keyword: "",
                                searchedKeyword: "",
                            };
                        },
                        methods: {
                            fnGetRecentList: function (moveTop = false) {
                                let self = this;

                                $.ajax({
                                    url: "/user/recent/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: self.page,
                                        pageSize: self.pageSize,
                                        keyword: self.searchedKeyword
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.recentList = data.list || [];
                                            self.totalCount = data.totalCount || 0;
                                            self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;

                                            if (moveTop) {
                                                window.scrollTo({
                                                    top: 0,
                                                    behavior: "smooth"
                                                });
                                            }
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
                                this.fnGetRecentList(true);
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
                            },
                            fnSearchRecent: function () {
                                this.page = 1;
                                this.searchedKeyword = this.keyword.trim();
                                this.fnGetRecentList(true);
                            },

                            fnResetSearchIfEmpty: function () {
                                if (!this.keyword.trim()) {
                                    this.page = 1;
                                    this.searchedKeyword = "";
                                    this.fnGetRecentList();
                                }
                            },
                            fnGetWishlist: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/wishlist/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: 1,
                                        pageSize: 100
                                    },
                                    success: function (data) {
                                        self.wishlist = data.result === "success" ? (data.list || []) : [];
                                    }
                                });
                            },

                            fnFindWish: function (productId) {
                                return this.wishlist.find(function (wish) {
                                    return Number(wish.productId) === Number(productId);
                                });
                            },

                            fnIsWished: function (productId) {
                                return !!this.fnFindWish(productId);
                            },

                            fnToggleWishlist: function (item) {
                                let self = this;

                                $.ajax({
                                    url: "/user/wishlist/toggle.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        productId: item.productId
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.fnGetWishlist();

                                            if (data.action === "added") {
                                                self.fnShowToast("❤️ 위시리스트에 추가했어요!");
                                            } else {
                                                self.fnShowToast("위시리스트에서 제거되었어요");
                                            }
                                        } else {
                                            self.fnShowToast(data.message || "찜 처리에 실패했습니다.");
                                        }
                                    },
                                    error: function () {
                                        self.fnShowToast("서버 오류가 발생했습니다.");
                                    }
                                });
                            },

                            fnShowToast: function (message) {
                                let self = this;

                                self.toastMessage = message;
                                self.toastShow = true;

                                clearTimeout(self.toastTimer);

                                self.toastTimer = setTimeout(function () {
                                    self.toastShow = false;
                                }, 1800);
                            },
                        },
                        mounted() {
                            this.fnGetRecentList();
                            this.fnGetWishlist();
                        }
                    });

                    app.mount("#app");
                </script>