<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모닥모닥 - 캠핑 도우미 AI 모닥이</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/chatbot.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>

<div id="app" v-cloak>
    <div class="sidebar">
        <div class="sidebar-logo" onclick="location.href='/main.do'">🔥 모닥모닥</div>
        <button class="new-chat-btn" @click="fnNewChat">+ 새 대화 시작</button>
        <p style="font-size:11px;color:var(--gray);margin-bottom:15px;font-weight:800;padding-left:5px;">나의 캠핑 기록</p>

        <div v-for="h in history" :key="h.roomId"
             :class="['history-item', {active: h.roomId === currentRoomId}]"
             @click="fnSelectHistory(h)">
            <span class="history-title">{{ h.title }}</span>
            <button class="del-btn" @click.stop="fnDeleteRoom(h.roomId)">&times;</button>
        </div>
    </div>

    <div class="chat-main">
        <header class="chat-header">
            <div class="bot-avatar">🔥</div>
            <div>
                <p><b>모닥이</b> (캠핑 가이드)</p>
                <span style="font-size:11px;color:var(--orange);">무엇이든 물어봐라닥!</span>
            </div>
        </header>

        <div class="message-area" id="msgArea">
            <div v-if="messages.length === 0" style="text-align:center;padding:60px 0;">
                <div style="font-size:50px;margin-bottom:20px;">🔥</div>
                <h3>모닥불 앞에 오신 걸 환영한다닥!</h3>
                <p style="font-size:14px;color:var(--gray);margin-top:10px;">
                    장작 타는 소리와 함께 편하게 질문해라닥.<br>캠핑이 처음이어도 모닥이가 다 알려주겠다닥!
                </p>
            </div>

            <div v-for="(msg, idx) in messages" :key="idx" :class="['msg', msg.role]">
                <!-- 봇 아바타 (왼쪽) -->
                <div v-if="msg.role === 'bot'" class="bot-avatar"
                     style="width:32px;height:32px;font-size:16px;flex-shrink:0;">🔥</div>
                <!-- 유저 시간 (오른쪽) -->
                <span v-if="msg.role === 'user'" class="msg-time">{{ msg.time }}</span>

                <div class="bubble">
                    <!-- 로딩 중 -->
                    <div v-if="msg.isLoading" class="typing-dots">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                    <!-- ★ 메시지 내용 — v-html 로 마크다운 파싱 -->
                    <div v-else class="bubble-content" v-html="parseMarkdown(msg.message || msg.content || '')"></div>
                </div>

                <!-- 봇 시간 (오른쪽) -->
                <span v-if="msg.role === 'bot'" class="msg-time">{{ msg.time }}</span>
            </div>
        </div>

        <!-- 추천 질문 -->
        <div class="faq-section" v-if="recommends.length > 0">
            <button class="faq-chip" v-for="q in recommends" :key="q" @click="fnFaq(q)">{{ q }}</button>
            <button class="faq-chip home-btn" @click="fnGoMain">🏠 메인 홈으로</button>
        </div>

        <div class="input-area">
            <div class="input-wrap">
                <input type="text" class="input-box" v-model="userInput" ref="userInput"
                       @keyup.enter="fnSendMessage"
                       :disabled="isLoading"
                       placeholder="모닥이에게 물어봐라닥...">
                <button class="send-btn" @click="fnSendMessage" :disabled="isLoading">➤</button>
            </div>
        </div>
    </div>
</div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        const roomId = '${roomId}';
        return {
            currentRoomId: (roomId && roomId !== 'null' && roomId !== '')
                ? roomId
                : new Date().getTime().toString(),
            initialRoomId: (roomId && roomId !== 'null' && roomId !== '') ? roomId : '',
            userInput  : '',
            isLoading  : false,
            messages   : [],   /* ★ 빈 배열로 시작 — 웰컴 메시지는 v-if 로 처리 */
            history    : [],
            recommends : [],
        };
    },

    methods: {
        /* 현재 시각 */
        fnGetCurrentTime() {
            const now = new Date();
            let h = now.getHours();
            const ampm = h >= 12 ? '오후' : '오전';
            h = h % 12 || 12;
            return ampm + ' ' + h + ':' + String(now.getMinutes()).padStart(2, '0');
        },

        /* 사이드바 히스토리 로드 */
        fnLoadSidebar() {
            $.ajax({
                url: '/api/chat/history.dox', type: 'POST',
                success: (res) => {
                    this.history = res.map(i => ({
                        roomId: i.roomId,
                        title : (i.message || '').substring(0, 14) + ((i.message || '').length > 14 ? '…' : ''),
                    }));

                    /* URL로 들어온 방 자동 선택 */
                    if (this.initialRoomId) {
                        const target = this.history.find(h => h.roomId === this.initialRoomId);
                        if (target) this.fnSelectHistory(target);
                        this.initialRoomId = '';
                    }
                }
            });
        },

        /* ★ 방 전환 — 메시지 사라짐 버그 수정
           DB 컬럼명이 message / content 둘 다 올 수 있으므로 둘 다 처리 */
        fnSelectHistory(h) {
            this.currentRoomId = h.roomId;

            $.ajax({
                url        : '/api/chat/roomMessages.dox',
                type       : 'POST',
                contentType: 'application/json',
                data       : JSON.stringify({ roomId: h.roomId }),
                success    : (res) => {
                    /* ★ 핵심: role 필드 정규화 + message 필드 보장 */
                    this.messages = res.map(m => ({
                        role   : (m.role || 'bot').toLowerCase(),       /* 'BOT' → 'bot' */
                        message: m.message || m.content || '',          /* 둘 다 처리 */
                        time   : m.time || m.createdAt || this.fnGetCurrentTime(),
                        isLoading: false
                    }));
                    this.fnScroll();
                    if (res.length > 0) {
                        const last = res[res.length - 1];
                        this.fnGetRecommend(last.message || last.content || '');
                    }
                }
            });
        },

        /* 추천 질문 */
        fnGetRecommend(lastMsg) {
            $.ajax({
                url        : '/api/chat/recommend.dox',
                type       : 'POST',
                contentType: 'application/json',
                data       : JSON.stringify({ message: lastMsg || 'START' }),
                success    : (res) => { this.recommends = res; }
            });
        },

        /* 메시지 전송 */
        fnSendMessage() {
            const msg = this.userInput.trim();
            if (!msg || this.isLoading) return;
            this.userInput  = '';
            this.isLoading  = true;
            this.recommends = [];
            const time = this.fnGetCurrentTime();

            this.messages.push({ role: 'user', message: msg,    time, isLoading: false });
            this.messages.push({ role: 'bot',  message: '',     time, isLoading: true  });
            this.fnScroll();

            $.ajax({
                url        : '/api/chat/ask.dox',
                type       : 'POST',
                contentType: 'application/json',
                data       : JSON.stringify({ message: msg, roomId: this.currentRoomId }),
                success    : (res) => {
                    const last     = this.messages[this.messages.length - 1];
                    last.isLoading = false;
                    last.message   = res;
                    this.isLoading = false;
                    this.fnGetRecommend(msg);
                    this.fnLoadSidebar();
                    this.fnScroll();
                },
                error: () => {
                    const last     = this.messages[this.messages.length - 1];
                    last.isLoading = false;
                    last.message   = '오류가 발생했다닥! 다시 시도해봐라닥. 🔥';
                    this.isLoading = false;
                }
            });
        },

        fnFaq(q)   { this.userInput = q; this.fnSendMessage(); },
        fnGoMain() { if (confirm('메인으로 가시겠닥? 🏕️')) location.href = '/main.do'; },

        /* 마크다운 파싱 */
        parseMarkdown(t) {
            if (!t) return '';
            let html = t
                .replace(/\*\*(.*?)\*\*/g, '<b>$1</b>')
                .replace(/\*(.*?)\*/g, '<i>$1</i>')
                .replace(/\n/g, '<br>');
            /* [버튼명|URL] 형식 → 이동 버튼 */
            return html.replace(/\[([^|]+)\|([^\]]+)\]/g, (_, title, url) =>
                '<div class="msg-link-box"><button class="move-btn" onclick="window.open(\'' + url + '\',\'_blank\')">' + title + ' →</button></div>'
            );
        },

        /* 새 대화 */
        fnNewChat() {
            this.currentRoomId = new Date().getTime().toString();
            this.messages      = [];
            this.recommends    = [];
            this.fnGetRecommend('START');
            this.fnLoadSidebar();
        },

        /* 방 삭제 */
        fnDeleteRoom(roomId) {
            if (!confirm('삭제하시겠닥?')) return;
            $.ajax({
                url        : '/api/chat/deleteRoom.dox',
                type       : 'POST',
                contentType: 'application/json',
                data       : JSON.stringify({ roomId }),
                success    : () => { this.fnLoadSidebar(); this.fnNewChat(); }
            });
        },

        /* 스크롤 하단 이동 */
        fnScroll() {
            this.$nextTick(() => {
                const a = document.getElementById('msgArea');
                if (a) a.scrollTop = a.scrollHeight;
            });
        }
    },

    mounted() {
        this.fnLoadSidebar();
        this.fnGetRecommend('START');
    }
}).mount('#app');
</script>
</body>
</html>
