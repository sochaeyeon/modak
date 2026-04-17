<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>찜한 상품 전체보기</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <link rel="stylesheet" href="/css/wishlist/wishlist-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app">
                            <div class="wishlist-history-page">
                                <div class="wishlist-history-wrap">

                                    <!-- 상단 헤더 -->
                                    <div class="page-hero">
                                        <div>
                                            <div class="page-eyebrow">MY WISHLIST</div>
                                            <h2 class="page-title">찜한 상품 전체보기</h2>
                                            <p class="page-desc">
                                                관심 있는 상품을 한눈에 확인하고, 바로 상세 페이지로 이동할 수 있어요.
                                            </p>
                                        </div>

                                        <div class="hero-summary-card">
                                            <div class="hero-summary-label">찜한 상품</div>

                                            <div class="hero-summary-value">
                                                <transition name="count-rise" mode="out-in">
                                                    <span class="result-count-number" :key="wishlist.length">{{
                                                        wishlist.length }}</span>
                                                </transition>
                                                <span class="result-count-unit">개</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 찜 목록 -->
                                    <div class="section-card">
                                        <div class="section-head">
                                            <h3>전체 찜 목록</h3>
                                        </div>

                                        <transition name="list-rise" mode="out-in">
                                            <div class="wishlist-content" :key="'wishlist-' + listAnimateKey">
                                                <div v-if="wishlist.length === 0" class="empty-state">
                                                    <p>찜한 상품이 없습니다.</p>
                                                </div>

                                                <div v-else class="wish-grid">
                                                    <div class="wish-item" v-for="item in wishlist"
                                                        :key="item.productId"
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
                                                                찜한 날짜 {{ fnFormatDate(item.createdAt) }}
                                                            </div>
                                                            <button type="button"
                                                                class="btn-outline btn-small btn-unwish"
                                                                @click.stop="fnRemoveWishlist(item.wishId)">
                                                                찜 해제
                                                            </button>
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
                                wishlist: [],
                                listAnimateKey: 0
                            };
                        },
                        methods: {
                            fnGetWishlist: function () {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/user/wishlist/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.wishlist = data.list || [];
                                        } else {
                                            self.wishlist = [];
                                        }
                                        self.listAnimateKey++;
                                    },
                                    error: function () {
                                        self.wishlist = [];
                                        self.listAnimateKey++;
                                    }
                                });
                            },

                            fnGoProductDetail: function (productId) {
                                pageChange("/product/detail.do", { productId: productId });
                            },

                            fnRemoveWishlist: function (wishId) {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/user/wishlist/remove.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { wishId: wishId },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.fnGetWishlist();
                                        } else {
                                            alert(data.message || "찜 해제에 실패했습니다.");
                                        }
                                    },
                                    error: function () {
                                        alert("서버 오류가 발생했습니다.");
                                    }
                                });
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
                            this.fnGetWishlist();
                        }
                    });

                    app.mount("#app");
                </script>