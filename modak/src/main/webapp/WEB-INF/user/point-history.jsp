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
                                    <h3>포인트 내역 전체보기</h3>
                                    <a href="javascript:;" @click="fnGoMypage">마이페이지로 →</a>
                                </div>

                                <!-- 현재 포인트 표시 -->
                                <div class="point-summary-box">
                                    <div class="point-summary-label">현재 보유 포인트</div>
                                    <div class="point-summary-amount">
                                        {{ Number(currentPoint || 0).toLocaleString() }}<span>P</span>
                                    </div>
                                    <div class="point-summary-desc">
                                        적립 및 사용 내역을 확인할 수 있습니다.
                                    </div>
                                </div>

                                <div class="point-history-full" :key="renderKey">
                                    <div v-if="pointList.length === 0" class="empty-state">
                                        <p>포인트 내역이 없습니다.</p>
                                    </div>

                                    <div v-for="(item, index) in pointList" :key="item.historyId"
                                        class="point-history-card" :style="{ animationDelay: (index * 0.06) + 's' }">
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
                                <div class="paging-wrap" v-if="totalPages > 1">
                                    <button class="paging-btn" :disabled="page === 1" @click="fnPrevPage">
                                        이전
                                    </button>

                                    <button v-for="p in totalPages" :key="p" class="paging-btn"
                                        :class="{ active: page === p }" @click="fnChangePage(p)">
                                        {{ p }}
                                    </button>

                                    <button class="paging-btn" :disabled="page === totalPages" @click="fnNextPage">
                                        다음
                                    </button>
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
                        pointList: [],
                        currentPoint: 0,
                        page: 1,
                        pageSize: 10,
                        totalCount: 0,
                        renderKey: 0
                    };
                },
                computed: {
                    totalPages() {
                        return Math.ceil(this.totalCount / this.pageSize);
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
                                page: self.page,
                                pageSize: self.pageSize
                            },
                            success: function (data) {
                                if (data.result === "success") {
                                    self.pointList = data.list || [];
                                    self.totalCount = data.totalCount || 0;
                                    self.renderKey++;

                                    if (self.page === 1 && self.pointList.length > 0) {
                                        self.currentPoint = self.pointList[0].balanceAfter || 0;
                                    }
                                } else {
                                    self.pointList = [];
                                    self.totalCount = 0;
                                    self.renderKey++;
                                }
                            },
                            error: function () {
                                self.pointList = [];
                                self.totalCount = 0;
                                self.renderKey++;
                            }
                        });
                    },
                    fnGoMypage: function () {
                        pageChange("/user/mypage.do", {});
                    },
                    fnChangePage: function (page) {
                        if (page < 1 || page > this.totalPages) {
                            return;
                        }

                        this.page = page;
                        this.fnGetPointHistoryList();

                        window.scrollTo({
                            top: 0,
                            behavior: "smooth"
                        });
                    },

                    fnPrevPage: function () {
                        if (this.page > 1) {
                            this.page--;
                            this.fnGetPointHistoryList();

                            window.scrollTo({
                                top: 0,
                                behavior: "smooth"
                            });
                        }
                    },

                    fnNextPage: function () {
                        if (this.page < this.totalPages) {
                            this.page++;
                            this.fnGetPointHistoryList();

                            window.scrollTo({
                                top: 0,
                                behavior: "smooth"
                            });
                        }
                    },
                },
                mounted() {
                    this.fnGetPointHistoryList();
                }
            });

            app.mount("#app");
        </script>