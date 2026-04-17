<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <p style="font-size:11px; color:var(--gray); margin-bottom:15px; font-weight:800; padding-left:5px;">나의 캠핑 기록</p>
        
        <div v-for="h in history" :key="h.roomId" 
             :class="['history-item', {active: h.active}]" 
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
                <span style="font-size:11px; color: var(--orange);">무엇이든 물어봐라닥!</span>
            </div>
        </header>
        
        <div class="message-area" id="msgArea">
            <div v-if="messages.length <= 1" class="welcome-card" style="text-align:center; padding:60px 0;">
                <div style="font-size: 50px; margin-bottom: 20px;">🔥</div>
                <h3>모닥불 앞에 오신 걸 환영한다닥!</h3>
                <p style="font-size: 14px; color: var(--gray); margin-top:10px;">
                    장작 타는 소리와 함께 편하게 질문해라닥.<br>캠핑이 처음이어도 모닥이가 다 알려주겠다닥!
                </p>
            </div>
            
            <div v-for="(msg, idx) in messages" :key="idx" :class="['msg', msg.role]">
                <div v-if="msg.role === 'bot'" class="bot-avatar" style="width:32px; height:32px; font-size:16px;">🔥</div>
                <span v-if="msg.role === 'user'" class="msg-time">{{ msg.time }}</span>
                <div class="bubble">
                    <div v-if="msg.isLoading" class="typing-dots">
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div>
                    </div>
                    <div v-else class="bubble-content" v-html="parseMarkdown(msg.message)"></div>
                </div>
                <span v-if="msg.role === 'bot'" class="msg-time">{{ msg.time }}</span>
            </div>
        </div>

        <div class="faq-section" v-if="recommends.length > 0">
            <button class="faq-chip" v-for="q in recommends" :key="q" @click="fnFaq(q)">
                {{ q }}
            </button>
            <button class="faq-chip home-btn" @click="fnGoMain">🏠 메인 홈으로</button>
        </div>

        <div class="input-area">
            <div class="input-wrap">
                <input type="text" class="input-box" v-model="userInput" ref="userInput" 
                       @keyup.enter="fnSendMessage" :disabled="isLoading" placeholder="모닥이에게 물어봐라닥...">
                <button class="send-btn" @click="fnSendMessage" :disabled="isLoading">➤</button>
            </div>
        </div>
    </div>
</div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            currentRoomId: new Date().getTime().toString(),
            userInput: '', isLoading: false, showFaq: true,
            messages: [{ role: 'bot', message: '반갑닥! 오늘 캠핑 고민은 뭐냐닥?', time: this.fnGetCurrentTime() }],
            history: [], recommends: []
        };
    },
    methods: {
        fnGetCurrentTime() {
            const now = new Date();
            let h = now.getHours();
            const ampm = h >= 12 ? '오후' : '오전';
            h = h % 12 || 12;
            return ampm + ' ' + h + ':' + now.getMinutes().toString().padStart(2, '0');
        },
        fnLoadSidebar() {
            $.ajax({
                url: '/api/chat/history.dox', type: 'POST',
                success: (res) => {
                    this.history = res.map(i => ({
                        roomId: i.roomId, 
                        title: i.message.substring(0, 12) + (i.message.length > 12 ? '...' : ''),
                        active: i.roomId === this.currentRoomId
                    }));
                }
            });
        },
        // 🎯 과거 대화방 선택 로직 (방 이동 문제 해결!)
        fnSelectHistory(h) {
            this.currentRoomId = h.roomId;
            this.history.forEach(item => item.active = (item.roomId === h.roomId));
            
            $.ajax({
                url: '/api/chat/roomMessages.dox',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ roomId: h.roomId }),
                success: (res) => {
                    this.messages = res.map(m => ({ ...m, time: m.time || this.fnGetCurrentTime() }));
                    this.showFaq = false;
                    this.fnScroll();
                    // 마지막 메시지 기준으로 추천 질문 갱신
                    if(res.length > 0) this.fnGetRecommend(res[res.length-1].message);
                }
            });
        },
        fnGetRecommend(lastMsg) {
            $.ajax({
                url: '/api/chat/recommend.dox', type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ message: lastMsg }),
                success: (res) => { this.recommends = res; }
            });
        },
        fnSendMessage() {
            const msg = this.userInput.trim();
            if (!msg || this.isLoading) return;
            this.userInput = ''; this.isLoading = true; this.recommends = [];
            const time = this.fnGetCurrentTime();
            this.messages.push({ role: 'user', message: msg, time: time });
            this.messages.push({ role: 'bot', isLoading: true, time: time });
            this.fnScroll();

            $.ajax({
                url: '/api/chat/ask.dox', type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ message: msg, roomId: this.currentRoomId }),
                success: (res) => {
                    const last = this.messages[this.messages.length - 1];
                    last.isLoading = false; last.message = res;
                    this.isLoading = false;
                    this.fnGetRecommend(msg);
                    this.fnLoadSidebar(); // 내역 타이틀 갱신
                    this.fnScroll();
                }
            });
        },
        fnFaq(q) { this.userInput = q; this.fnSendMessage(); },
        fnGoMain() { if(confirm("메인으로 가시겠닥? 🏕️")) location.href='/main.do'; },
        parseMarkdown(t) {
            if (!t) return '';
            let html = t.replace(/\n/g, '<br>');
            const linkPattern = /\[([^|]+)\|([^\]]+)\]/g;
            return html.replace(linkPattern, (match, title, url) => {
                return `<div class="msg-link-box"><button class="move-btn" onclick="window.open('${url}', '_blank')">${title} <i class="fa-solid fa-arrow-up-right-from-square"></i></button></div>`;
            });
        },
        fnNewChat() {
            this.currentRoomId = new Date().getTime().toString();
            this.messages = [{ role: 'bot', message: '새 모닥불을 피웠다닥! 🏕️', time: this.fnGetCurrentTime() }];
            this.fnGetRecommend("START");
            this.fnLoadSidebar();
        },
        fnDeleteRoom(roomId) {
            if(!confirm("삭제하시겠닥?")) return;
            $.ajax({
                url: '/api/chat/deleteRoom.dox', type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ roomId: roomId }),
                success: () => { this.fnNewChat(); }
            });
        },
        fnScroll() {
            this.$nextTick(() => {
                const a = document.getElementById('msgArea');
                if (a) a.scrollTop = a.scrollHeight;
            });
        }
    },
    mounted() { this.fnLoadSidebar(); this.fnGetRecommend("START"); }
}).mount('#app');
</script>
</body>
</html>