<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <style>
        /* 기존 main.jsp의 CSS 스타일을 여기에 그대로 유지하세요 */
        :root {
            --bg: #F5F0E8; --white: #FFFFFF; --orange: #E8622A; --brown: #5C3D2E;
        }
        body { background-color: var(--bg); font-family: 'Noto Sans KR', sans-serif; margin: 0; }
        #app { padding: 20px; }
        .camp-card { background: white; border-radius: 15px; padding: 15px; margin-bottom: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .weather-section { background: rgba(255,255,255,0.5); backdrop-filter: blur(10px); border-radius: 20px; padding: 20px; }
        /* ... 나머지 스타일 동일하게 유지 ... */
    </style>
</head>
<body>
    <div id="app">
        <header class="main-header">
            <h1 @click="fnGoHome" style="cursor:pointer">🔥 MODAK MODAK</h1>
        </header>

        <section class="weather-section">
            <h3>오늘의 캠핑 날씨 🏕️</h3>
            <div v-if="weather" class="weather-info">
                <span>{{ weather.areaName }} : {{ weather.temp }}°C</span>
                <p>{{ weather.desc }}</p>
            </div>
        </section>

        <section class="content-list">
            <div v-for="(item, index) in campList" :key="index" class="camp-card">
                <h4>{{ item.campName }}</h4>
                <p>{{ item.addr }}</p>
                <button @click="fnDetail(item.campNo)">상세보기</button>
            </div>
        </section>

        <div v-if="showToastFlag" class="toast-msg">{{ toastMsg }}</div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 1. 변수 선언
                    campList: [],      // 캠핑장 리스트
                    weather: null,     // 날씨 데이터
                    toastMsg: '',      // 토스트 메시지 내용
                    showToastFlag: false, // 토스트 표시 여부
                    sessionId: '${sessionId}' // 세션 정보 (필요시)
                };
            },
            methods: {
                // 2. 캠핑장 리스트 가져오기 (AJAX)
                fnGetList: function () {
                    let self = this;
                    $.ajax({
                        url: "/camp/list.dox", // 실제 컨트롤러 주소로 변경
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            self.campList = data.list;
                        }
                    });
                },
                
                // 3. 상세 페이지 이동
                fnDetail: function (campNo) {
                    // 페이지 이동 유틸리티 사용 또는 location.href
                    location.href = "/camp/detail.do?campNo=" + campNo;
                },

                // 4. 홈으로 이동
                fnGoHome: function() {
                    location.href = "/main.do";
                },

                // 5. 토스트 알림 함수
                showToast: function(msg) {
                    this.toastMsg = msg;
                    this.showToastFlag = true;
                    setTimeout(() => { this.showToastFlag = false; }, 2000);
                }
            },
            mounted() {
                // 6. 시작하자마자 실행할 함수들
                this.fnGetList();
            }
        });

        app.mount('#app');
    </script>
</body>
</html>