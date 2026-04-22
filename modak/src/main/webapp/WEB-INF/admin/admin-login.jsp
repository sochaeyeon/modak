<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>모닥모닥 | 관리자 로그인</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-login.css">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>

    <body>

        <div class="login-container" id="app">
            <div class="logo">🔥 MODAK MODAK</div>
            <div class="sub-title">ADMINISTRATOR LOGIN</div>

            <div class="form-group">
                <label>ID</label>
                <input type="text" v-model="userId" @keyup.enter="fnLogin" placeholder="관리자 아이디 입력">
            </div>

            <div class="form-group">
                <label>PASSWORD</label>
                <input type="password" v-model="password" @keyup.enter="fnLogin" placeholder="비밀번호 입력">
            </div>

            <button class="btn-login" @click="fnLogin">접속하기</button>

            <a href="/main.do" class="back-home">← 사용자 메인으로 돌아가기</a>
        </div>

        <script>
            const { createApp } = Vue;
            createApp({
                data() {
                    return {
                        userId: '',
                        password: ''
                    };
                },
                methods: {
                    fnLogin() {
                        if (!this.userId.trim() || !this.password.trim()) {
                            alert("아이디와 비밀번호를 모두 입력해달라닥! ⛺");
                            return;
                        }

                        $.ajax({
                            url: '/admin/login.dox',
                            type: 'POST',
                            data: {
                                id: this.userId,
                                password: this.password
                            },
                            success: (res) => {
                                // res가 이미 JSON 객체이므로 바로 접근!
                                if (res.result === 'success') {
                                    location.href = '/admin/dashboard.do';
                                } else {
                                    alert(res.message);
                                    this.password = '';
                                }
                            },
                            error: () => {
                                alert("서버 통신 중 오류가 발생했다닥!");
                            }
                        });
                    }
                }
            }).mount('#app');
        </script>

    </body>

    </html>