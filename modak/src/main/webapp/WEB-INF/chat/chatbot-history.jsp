<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>챗봇 기록 전체보기</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <link rel="stylesheet" href="/css/chat/chatbot-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app">
                            <div class="chatbot-history-page">
                                <div class="chatbot-history-wrap">

                                    <!-- 상단 소개 -->
                                    <div class="page-hero">
                                        <div>
                                            <div class="page-eyebrow">CHATBOT HISTORY</div>
                                            <h2 class="page-title">챗봇 기록 전체보기</h2>
                                            <p class="page-desc">
                                                내가 나눈 챗봇 대화를 최신순으로 확인할 수 있어요.
                                            </p>
                                        </div>

                                        <div class="hero-summary-card">
                                            <div class="hero-summary-label">대화방 수</div>
                                            <div class="hero-summary-value">
                                                <transition name="count-rise" mode="out-in">
                                                    <span class="result-count-number" :key="totalCount">{{ totalCount
                                                        }}</span>
                                                </transition>
                                                <span class="result-count-unit">개</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 목록 카드 -->
                                    <div class="section-card">
                                        <div class="section-head">
                                            <div class="section-head-left">
                                                <h3>전체 챗봇 기록</h3>
                                                <p class="recent-guide-text">대화방은 10개씩 확인할 수 있습니다.</p>
                                            </div>
                                        </div>

                                        <transition name="list-rise" mode="out-in">
                                            <div class="chatbot-content" :key="'chatbot-' + listAnimateKey">

                                                <div v-if="chatbotList.length === 0" class="empty-state">
                                                    <p>챗봇 기록이 없습니다.</p>
                                                </div>

                                                <div v-else class="chatbot-list">
                                                    <div class="chatbot-item" v-for="item in chatbotList"
                                                        :key="item.roomId" @click="fnGoChatbotRoom(item.roomId)">

                                                        <div class="chatbot-item-left">
                                                            <div class="chatbot-icon">💬</div>

                                                            <div class="chatbot-info">
                                                                <div class="chatbot-title">
                                                                    {{ item.title && item.title.trim() ? item.title :
                                                                    '제목 없는 대화' }}
                                                                </div>

                                                                <div class="chatbot-preview" v-if="item.lastMessage">
                                                                    {{ item.lastMessage }}
                                                                </div>

                                                                <div class="chatbot-meta">
                                                                    <span class="chatbot-room">ROOM {{ item.roomId
                                                                        }}</span>
                                                                    <span class="dot">·</span>
                                                                    <span class="chatbot-date">{{ item.lastRegDate
                                                                        }}</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="chatbot-item-right">
                                                            <span class="chatbot-enter">입장하기 →</span>
                                                        </div>
                                                    </div>
                                                </div>

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
                                chatbotList: [],
                                totalCount: 0,
                                page: 1,
                                pageSize: 10,
                                totalPages: 1,
                                listAnimateKey: 0
                            };
                        },
                        methods: {
                            fnGetChatbotList: function (moveTop = false) {
                                let self = this;

                                $.ajax({
                                    url: "/user/chatbot/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: self.page,
                                        pageSize: self.pageSize
                                    },
                                    success: function (data) {
                                        console.log("응답:", data);
                                        if (data.result === "success") {
                                            self.chatbotList = data.list || [];
                                            self.totalCount = data.totalCount || self.chatbotList.length;
                                            self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;
                                            self.listAnimateKey++;

                                            if (moveTop) {
                                                window.scrollTo({
                                                    top: 0,
                                                    behavior: "smooth"
                                                });
                                            }
                                        } else {
                                            self.chatbotList = [];
                                            self.totalCount = 0;
                                            self.totalPages = 1;
                                        }
                                    },
                                    error: function () {
                                        self.chatbotList = [];
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
                                this.fnGetChatbotList(true);
                            },

                            fnGoChatbotRoom: function (roomId) {
                                pageChange("/chat/bot.do", { roomId: roomId });
                            }
                        },
                        mounted() {
                            this.fnGetChatbotList();
                        }
                    });

                    app.mount("#app");
                </script>