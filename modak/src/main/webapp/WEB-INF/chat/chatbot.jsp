<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 캠핑 도우미 AI 모닥이</title>
    
    <link rel="stylesheet" href="/css/common/font.css">
    <link rel="stylesheet" href="/css/chat/chatbot.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>

<div id="app" v-cloak>
    <div class="sidebar">
        <div class="sidebar-logo" onclick="location.href='/main.do'">🔥 모닥모닥</div>
        <button class="new-chat-btn" @click="fnNewChat">+ 새 대화 시작</button>
        
        <p class="sidebar-section-title">최근 대화</p>
        <div v-for="h in history" :key="h.roomId" 
             :class="['history-item', {active: h.active}]" 
             @click="fnSelectHistory(h)">
            <span style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap; flex:1;">
                {{ h.title }}
            </span>
            <button class="del-btn" @click.stop="fnDeleteRoom(h.roomId)">&times;</button>
        </div>
    </div>

    <div class="chat-main">
        <header class="chat-header">
            <div class="bot-avatar">🔥</div>
            <p><b>모닥이</b> (상담원)</p>
        </header>
        
        <div class="message-area" id="msgArea">
            <div v-if="showFaq && messages.length <= 1" class="welcome-card">
                <h3>🏕️ 안녕! 나는 캠핑 도우미 모닥이다닥!</h3>
                <p style="font-size:13px; color:var(--gray); margin-top:5px;">장비 추천부터 예약까지 궁금한 건 뭐든 물어봐라닥!</p>
            </div>
            
            <div v-for="(msg, idx) in messages" :key="idx" :class="['msg', msg.role]">
                <div v-if="msg.role === 'bot'" class="bot-avatar" style="width:30px; height:30px; font-size:14px;">🔥</div>
                <div class="bubble">
                    <div class="bubble-content" v-html="msg.role === 'bot' ? parseMarkdown(msg.message) : msg.message"></div>
                </div>
            </div>
        </div>

        <div class="faq-section" v-if="showFaq">
            <button class="faq-chip" @click="fnFaq('텐트 추천해줘')">⛺ 텐트 추천</button>
            <button class="faq-chip" @click="fnFaq('캠핑 장비 대여 방법')">📦 대여 방법</button>
        </div>

        <div class="input-area">
            <div class="input-wrap">
                <input type="text" 
                       class="input-box" 
                       v-model="userInput" 
                       ref="userInput"
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
        return {
            currentRoomId: new Date().getTime().toString(),
            userInput: '',
            isLoading: false,
            showFaq: true,
            messages: [{ role: 'bot', message: '무엇을 도와줄까닥? 🏕️' }],
            history: []
        };
    },
    methods: {
        fnLoadSidebar() {
            $.ajax({
                url: '/api/chat/history.dox',
                type: 'POST',
                success: (res) => {
                    this.history = res.map(i => ({
                        roomId: i.roomId,
                        title: i.message.length > 15 ? i.message.substring(0, 15) + '...' : i.message,
                        active: i.roomId === this.currentRoomId
                    }));
                }
            });
        },
        fnSendMessage() {
            const msg = this.userInput.trim();
            if (!msg || this.isLoading) return;

            const isFirst = this.messages.length <= 1;
            this.userInput = '';
            this.showFaq = false;
            this.isLoading = true;
            this.messages.push({ role: 'user', message: msg });
            this.fnScroll();

            $.ajax({
                url: '/api/chat/ask.dox',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ message: msg, roomId: this.currentRoomId }),
                success: (res) => {
                    this.messages.push({ role: 'bot', message: res });
                    this.isLoading = false;
                    this.fnScroll();
                    if (isFirst) this.fnLoadSidebar();
                },
                error: () => {
                    this.messages.push({ role: 'bot', message: '지금은 바쁘다닥! 🔥' });
                    this.isLoading = false;
                    this.fnScroll();
                }
            });
        },
        fnSelectHistory(h) {
            this.currentRoomId = h.roomId;
            $.ajax({
                url: '/api/chat/roomMessages.dox',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ roomId: h.roomId }),
                success: (res) => {
                    this.messages = res;
                    this.showFaq = false;
                    this.fnLoadSidebar();
                    this.fnScroll();
                }
            });
        },
        fnDeleteRoom(roomId) {
            if (!confirm("이 대화 내용을 모두 삭제하시겠닥? 🔥")) return;
            $.ajax({
                url: '/api/chat/deleteRoom.dox',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ roomId: roomId }),
                success: (res) => {
                    if (res === "success") {
                        if (this.currentRoomId === roomId) this.fnNewChat();
                        else this.fnLoadSidebar();
                    }
                }
            });
        },
        fnNewChat() {
            this.currentRoomId = new Date().getTime().toString();
            this.messages = [{ role: 'bot', message: '새 대화를 시작한다닥! 🏕️' }];
            this.showFaq = true;
            this.fnLoadSidebar();
            this.$nextTick(() => this.$refs.userInput.focus());
        },
        fnFaq(q) { this.userInput = q; this.fnSendMessage(); },
        parseMarkdown(t) { return t ? t.replace(/\n/g, '<br>') : ''; },
        fnScroll() {
            this.$nextTick(() => {
                const a = document.getElementById('msgArea');
                if (a) a.scrollTop = a.scrollHeight;
            });
        }
    },
    mounted() {
        this.fnLoadSidebar();
    }
}).mount('#app');
</script>
</body>
</html>