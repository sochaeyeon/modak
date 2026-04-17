<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모닥모닥 - 캠핑 도우미 AI 모닥이</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { --bg: #F7F3EE; --sidebar: #EFEAE3; --orange: #E8732A; --orange2: #C4621E; --white: #FFFFFF; --dark: #2C1E0F; --gray: #8B6B4A; --gray2: #B89A7A; --cream2: #E2D8C3; --cream3: #D4C8B0; }
        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Noto Sans KR',sans-serif; background:var(--bg); color:var(--dark); overflow:hidden; }
        #app { display:flex; height:100vh; width:100vw; }
        [v-cloak] { display:none; }
        .sidebar { width:270px; background:var(--sidebar); border-right:1px solid rgba(0,0,0,0.06); display:flex; flex-direction:column; padding:20px; flex-shrink:0; }
        .sidebar-logo { display:flex; align-items:center; gap:8px; font-size:18px; font-weight:700; color:var(--dark); margin-bottom:20px; cursor:pointer; }
        .new-chat-btn { background:var(--orange); color:#fff; border:none; padding:11px; border-radius:10px; font-weight:600; font-size:13px; cursor:pointer; margin-bottom:20px; transition:0.2s; }
        .history-item { padding:10px 12px; border-radius:8px; font-size:13px; cursor:pointer; margin-bottom:4px; color:var(--gray); display:flex; justify-content:space-between; align-items:center; }
        .history-item.active { background:var(--cream2); color:var(--dark); font-weight:500; }
        .del-btn { color:var(--gray2); font-size:16px; background:none; border:none; cursor:pointer; opacity:0.5; }
        .chat-main { flex:1; display:flex; flex-direction:column; background:var(--white); }
        .chat-header { padding:14px 28px; border-bottom:1px solid #F0EBE3; display:flex; align-items:center; }
        .bot-avatar { width:40px; height:40px; background:var(--bg); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:20px; margin-right:12px; }
        .message-area { flex:1; padding:28px 32px; overflow-y:auto; display:flex; flex-direction:column; gap:20px; }
        .msg { display:flex; gap:10px; max-width:80%; }
        .msg.bot { align-self:flex-start; }
        .msg.user { align-self:flex-end; flex-direction:row-reverse; }
        .bubble { padding:13px 17px; border-radius:16px; font-size:14px; line-height:1.7; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        .bubble-content { white-space: pre-wrap; }
        .bot .bubble { background:var(--bg); border-top-left-radius:3px; }
        .user .bubble { background:var(--orange); color:#fff; border-top-right-radius:3px; }
        .welcome-card { background:linear-gradient(135deg,#FBE8DC,#FDF3EE); border:1.5px solid rgba(232,115,42,.2); border-radius:16px; padding:20px; margin-bottom:10px; }
        .faq-section { padding:0 32px 20px; }
        .faq-chip { padding:7px 14px; border-radius:20px; border:1.5px solid var(--cream3); background:#fff; font-size:12px; cursor:pointer; margin-right:6px; transition:0.2s; }
        .input-area { padding:16px 28px 20px; border-top:1px solid #F0EBE3; }
        .input-wrap { display:flex; gap:10px; }
        .input-box { flex:1; padding:13px 18px; border-radius:12px; border:1.5px solid var(--cream3); outline:none; font-size:14px; }
        .send-btn { background:var(--orange); color:#fff; border:none; width:46px; height:46px; border-radius:12px; cursor:pointer; font-size:18px; }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="sidebar">
        <div class="sidebar-logo" onclick="location.href='/main.do'">🔥 모닥모닥</div>
        <button class="new-chat-btn" @click="fnNewChat">+ 새 대화 시작</button>
        <p style="font-size:11px; color:var(--gray2); margin-bottom:8px;">최근 대화</p>
        <div v-for="h in history" :key="h.roomId" :class="['history-item', {active: h.active}]" @click="fnSelectHistory(h)">
            <span style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap; flex:1;">{{ h.title }}</span>
            <button class="del-btn" @click.stop="fnDeleteRoom(h.roomId)">&times;</button>
        </div>
    </div>
    <div class="chat-main">
        <header class="chat-header"><div class="bot-avatar">🔥</div><p><b>모닥이</b> (상담원)</p></header>
        <div class="message-area" id="msgArea">
            <div v-if="showFaq && messages.length <= 1" class="welcome-card">
                <h3>🏕️ 안녕! 나는 캠핑 도우미 모닥이다닥!</h3>
                <p style="font-size:13px; color:var(--gray); margin-top:5px;">장비 추천부터 예약까지 궁금한 건 뭐든 물어봐라닥!</p>
            </div>
            <div v-for="(msg, idx) in messages" :key="idx" :class="['msg', msg.role]">
                <div v-if="msg.role === 'bot'" class="bot-avatar" style="width:30px; height:30px; font-size:14px;">🔥</div>
                <div class="bubble"><div class="bubble-content" v-html="msg.role === 'bot' ? parseMarkdown(msg.message) : msg.message"></div></div>
            </div>
        </div>
        <div class="faq-section" v-if="showFaq">
            <button class="faq-chip" @click="fnFaq('텐트 추천해줘')">⛺ 텐트 추천</button>
            <button class="faq-chip" @click="fnFaq('캠핑 장비 대여 방법')">📦 대여 방법</button>
        </div>
        <div class="input-area">
            <div class="input-wrap">
                <input type="text" class="input-box" v-model="userInput" @keyup.enter="fnSendMessage" :disabled="isLoading" placeholder="모닥이에게 물어봐라닥...">
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
            messages: [{ role:'bot', message:'무엇을 도와줄까닥? 🏕️' }],
            history: []
        };
    },
    methods: {
        fnLoadSidebar() {
            $.ajax({ url: '/api/chat/history.dox', type: 'POST', success: (res) => {
                this.history = res.map(i => ({ roomId: i.roomId, title: i.message.substring(0,15), active: i.roomId === this.currentRoomId }));
            }});
        },
        fnSendMessage() {
            const msg = this.userInput.trim(); if(!msg || this.isLoading) return;
            const isFirst = this.messages.length <= 1;
            this.userInput = ''; this.showFaq = false; this.isLoading = true;
            this.messages.push({ role:'user', message: msg });
            $.ajax({ 
                url: '/api/chat/ask.dox', type: 'POST', contentType: 'application/json', 
                data: JSON.stringify({ message: msg, roomId: this.currentRoomId }), 
                success: (res) => {
                    this.messages.push({ role:'bot', message: res }); this.isLoading = false; this.fnScroll();
                    if(isFirst) this.fnLoadSidebar();
                },
                error: () => { this.messages.push({ role:'bot', message:'지금은 바쁘다닥! 🔥' }); this.isLoading = false; }
            });
        },
        fnSelectHistory(h) {
            this.currentRoomId = h.roomId;
            $.ajax({ url: '/api/chat/roomMessages.dox', type: 'POST', contentType: 'application/json', data: JSON.stringify({ roomId: h.roomId }), success: (res) => {
                this.messages = res; this.showFaq = false; this.fnLoadSidebar(); this.fnScroll();
            }});
        },
        fnDeleteRoom(roomId) {
            if(!confirm("삭제할거닥?")) return;
            $.ajax({ url: '/api/chat/deleteRoom.dox', type: 'POST', contentType: 'application/json', data: JSON.stringify({ roomId: roomId }), success: () => {
                if(this.currentRoomId === roomId) this.fnNewChat(); else this.fnLoadSidebar();
            }});
        },
        fnNewChat() {
            this.currentRoomId = new Date().getTime().toString();
            this.messages = [{ role:'bot', message:'새 대화를 시작한다닥! 🏕️' }];
            this.showFaq = true; this.fnLoadSidebar();
        },
        fnFaq(q) { this.userInput = q; this.fnSendMessage(); },
        parseMarkdown(t) { return t ? t.replace(/\n/g, '<br>') : ''; },
        fnScroll() { this.$nextTick(() => { const a = document.getElementById('msgArea'); if(a) a.scrollTop = a.scrollHeight; }); }
    },
    mounted() { this.fnLoadSidebar(); }
}).mount('#app');
</script>
</body>
</html>