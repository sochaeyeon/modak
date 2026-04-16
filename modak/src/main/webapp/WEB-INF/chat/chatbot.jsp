<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 캠핑 도우미 AI</title>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-base: #F7F3EE;
            --sidebar-bg: #EFEAE3;
            --orange: #E8732A;
            --white: #FFFFFF;
            --text-dark: #2C1E0F;
            --text-gray: #8B6B4A;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Noto Sans KR', sans-serif; background: var(--bg-base); color: var(--text-dark); overflow: hidden; }

        #app { display: flex; height: 100vh; width: 100vw; }
        [v-cloak] { display: none; } /* 로드 전 Vue 문법 노출 방지 */

        /* ─── 사이드바 ─── */
        .sidebar {
            width: 280px; background: var(--sidebar-bg);
            border-right: 1px solid rgba(0,0,0,0.05);
            display: flex; flex-direction: column; padding: 24px;
        }
        .new-chat-btn {
            background: var(--orange); color: white; border: none; padding: 12px;
            border-radius: 8px; font-weight: 500; cursor: pointer; margin-bottom: 24px;
        }
        .history-item {
            padding: 12px; border-radius: 8px; font-size: 13px; cursor: pointer;
            margin-bottom: 8px; color: var(--text-gray); transition: 0.2s;
        }
        .history-item.active { background: #E2D8C3; color: var(--text-dark); font-weight: 500; }

        /* ─── 메인 채팅창 ─── */
        .chat-main { flex: 1; display: flex; flex-direction: column; background: var(--white); }
        
        .chat-header {
            padding: 16px 32px; border-bottom: 1px solid #F0F0F0;
            display: flex; align-items: center; justify-content: space-between;
        }
        .bot-profile { display: flex; align-items: center; gap: 12px; }
        .bot-avatar { width: 40px; height: 40px; background: var(--bg-base); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }

        .message-area { flex: 1; padding: 32px; overflow-y: auto; display: flex; flex-direction: column; gap: 24px; }
        
        .msg { display: flex; gap: 12px; max-width: 80%; animation: fadeIn 0.3s ease; }
        .msg.bot { align-self: flex-start; }
        .msg.user { align-self: flex-end; flex-direction: row-reverse; }

        .bubble {
            padding: 14px 18px; border-radius: 16px; font-size: 14px; line-height: 1.6;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03); word-break: break-all;
        }
        .bot .bubble { background: var(--bg-base); color: var(--text-dark); border-top-left-radius: 2px; }
        .user .bubble { background: var(--orange); color: white; border-top-right-radius: 2px; }

        /* 입력창 */
        .input-area { padding: 24px 32px; border-top: 1px solid #F0F0F0; position: relative; }
        .input-box {
            width: 100%; padding: 16px 60px 16px 20px; border-radius: 12px;
            border: 1px solid #DDD; outline: none; background: #FAFAFA; font-size: 14px;
        }
        .input-box:focus { border-color: var(--orange); background: white; }
        .send-btn {
            position: absolute; right: 45px; top: 50%; transform: translateY(-50%);
            background: var(--orange); border: none; width: 36px; height: 36px;
            border-radius: 8px; color: white; cursor: pointer;
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="sidebar">
        <button class="new-chat-btn">+ 새 대화 시작</button>
        <div class="chat-history">
            <div v-for="h in history" :key="h.id" :class="['history-item', {active: h.active}]">
                {{ h.title }}
            </div>
        </div>
    </div>

    <div class="chat-main">
        <header class="chat-header">
            <div class="bot-profile">
                <div class="bot-avatar">🤖</div>
                <div>
                    <p style="font-weight: 700; font-size: 15px;">캠핑 도우미</p>
                    <p style="font-size: 12px; color: #28a745;">● 온라인</p>
                </div>
            </div>
        </header>

        <div class="message-area" id="msgArea">
            <div v-for="(msg, index) in messages" :key="index" :class="['msg', msg.role]">
                <div v-if="msg.role === 'bot'" class="bot-avatar" style="width:30px; height:30px; font-size:14px;">🔥</div>
                <div class="bubble" v-text="msg.text"></div>
            </div>
        </div>

        <div class="input-area">
            <input type="text" 
                   class="input-box" 
                   v-model="userInput" 
                   @keyup.enter="fnSendMessage" 
                   placeholder="캠핑 장비 추천이나 대여 문의를 입력하세요...">
            <button class="send-btn" @click="fnSendMessage">➤</button>
        </div>
    </div>
</div>

<script>
    const { createApp } = Vue;

    createApp({
        data() {
            return {
                userInput: '',
                messages: [
                    { role: 'bot', text: '안녕하세요! 모닥모닥 AI 도우미입니다. 캠핑에 대해 무엇이든 물어보세요! 🏕️' }
                ],
                history: [
                    { id: 1, title: '텐트 추천해줘', active: true },
                    { id: 2, title: '장비 반납 절차', active: false }
                ]
            }
        },
        methods: {
            fnSendMessage() {
                if (!this.userInput.trim()) return;

                const userText = this.userInput;
                this.messages.push({ role: 'user', text: userText });
                this.userInput = '';
                this.fnScroll();

                // 서버 대기 메시지
                const botLoading = { role: 'bot', text: '생각 중...' };
                this.messages.push(botLoading);
                const botIdx = this.messages.length - 1;

                // AJAX 호출
                $.ajax({
                    url: "/api/chat/ask.dox",
                    type: "POST",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify({ message: userText }),
                    success: (res) => {
                        this.messages[botIdx].text = res;
                        this.fnScroll();
                    },
                    error: (err) => {
                        this.messages[botIdx].text = "불씨가 잠시 꺼졌네요. 다시 시도해 주세요! 🔥";
                    }
                });
            },
            fnScroll() {
                this.$nextTick(() => {
                    const area = document.getElementById('msgArea');
                    area.scrollTop = area.scrollHeight;
                });
            }
        }
    }).mount('#app');
</script>
</body>
</html>