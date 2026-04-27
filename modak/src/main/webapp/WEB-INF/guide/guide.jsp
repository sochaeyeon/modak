<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 이용 가이드</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/guide/guide.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <script>
        /*
         * 헤더 높이를 동적으로 측정해서 --header-h 변수에 반영합니다.
         * 헤더 높이가 변경되어도 자동으로 맞춰집니다.
         */
        function syncHeaderHeight() {
            var header = document.querySelector('.site-header');
            if (header) {
                var h = header.getBoundingClientRect().height;
                document.documentElement.style.setProperty('--header-h', h + 'px');
            }
        }
        document.addEventListener('DOMContentLoaded', function () {
            syncHeaderHeight();
            window.addEventListener('resize', syncHeaderHeight);
        });
    </script>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
    <div class="wrap">

        <!-- ── 탭바 ── -->
        <div class="tabbar-container">
            <div class="tabbar">
                <button class="tab" :class="{active: currentTab === 'all'}"    @click="fnTabMove('all')">📋 전체</button>
                <button class="tab" :class="{active: currentTab === 'install'}" @click="fnTabMove('install')">🔧 설치방법</button>
                <button class="tab" :class="{active: currentTab === 'qr'}"     @click="fnTabMove('qr')">📱 QR코드</button>
                <button class="tab" :class="{active: currentTab === 'waste'}"  @click="fnTabMove('waste')">♻️ 분리수거</button>
                <button class="tab" :class="{active: currentTab === 'rental'}" @click="fnTabMove('rental')">📦 대여안내</button>
            </div>
        </div>

        <!-- ── 페이지 헤더 ── -->
        <div class="page-header">
            <div class="badge">GUIDE CENTER</div>
            <h1>이용 가이드</h1>
            <p>모닥모닥과 함께라면 초보 캠퍼도 걱정 없다! 😊</p>
        </div>

        <!-- ── 장비 설치 방법 ── -->
        <div id="section-install" class="section">
            <div class="section-title">장비 설치 방법</div>
            <div class="steps-grid">
                <div class="step-card" data-tip="예약하신 자리가 맞는지 꼭 봐주세요!">
                    <div class="step-num">01</div>
                    <div class="step-icon orange">🏕️</div>
                    <h3>사이트 확인</h3>
                    <p>예약하신 사이트 번호를 확인하고 이동해 볼까요?</p>
                </div>
                <div class="step-card" data-tip="파손된 곳은 없는지 모닥이랑 확인해요!">
                    <div class="step-num">02</div>
                    <div class="step-icon green">📦</div>
                    <h3>장비 수령</h3>
                    <p>수령 시 상태 확인은 필수다닥!</p>
                </div>
                <div class="step-card" data-tip="설명이 어려우면 QR 영상을 눌러보세요!">
                    <div class="step-num">03</div>
                    <div class="step-icon blue">⛺</div>
                    <h3>텐트 설치</h3>
                    <p>안내서나 QR 영상을 보며 천천히 해보세요.</p>
                </div>
                <div class="step-card" data-tip="완료 버튼을 누르면 캠핑 시작입니다!">
                    <div class="step-num">04</div>
                    <div class="step-icon purple">✅</div>
                    <h3>힐링 시작!</h3>
                    <p>앱에서 완료 처리를 해 주시면 끝!</p>
                </div>
            </div>
        </div>

        <!-- ── QR 코드 ── -->
        <div id="section-qr" class="section">
            <div class="section-title">QR 코드로 똑똑하게!</div>
            <div class="qr-card">
                <div class="qr-box">
                    <i class="fa-solid fa-qrcode"></i>
                    <div class="qr-label">SCAN ME</div>
                </div>
                <div class="qr-info">
                    <h3>QR 하나로 다 해결된다닥!</h3>
                    <p>장비에 붙은 QR 코드를 스캔만 하세요.<br>설치 방법부터 반납까지 모닥이가 알려드릴게요!</p>
                </div>
            </div>
        </div>

        <!-- ── 분리수거 ── -->
        <div id="section-waste" class="section">
            <div class="section-title">깨끗한 캠핑을 위한 약속</div>
            <div class="waste-grid">
                <div class="waste-card" data-tip="내용물을 비우고 라벨은 꼭 떼주세요! 😊">
                    <div class="waste-icon-wrap" style="background:#ddeeff;">🧴</div>
                    <h4>플라스틱</h4>
                    <div class="waste-badge blue">파란 봉투</div>
                </div>
                <div class="waste-card" data-tip="국물을 버린 뒤 수거함에 넣어주세요! 🥬">
                    <div class="waste-icon-wrap" style="background:#dff0e4;">🥬</div>
                    <h4>음식물</h4>
                    <div class="waste-badge green">초록 수거함</div>
                </div>
                <div class="waste-card" data-tip="다 먹은 캔은 물로 한 번 헹궈주세요! 🍺">
                    <div class="waste-icon-wrap" style="background:#fde8d8;">🍺</div>
                    <h4>캔·유리</h4>
                    <div class="waste-badge orange">황색 수거함</div>
                </div>
                <div class="waste-card" data-tip="불씨가 완전히 꺼졌는지 꼭 확인! 🔥">
                    <div class="waste-icon-wrap" style="background:#ece8fb;">🔥</div>
                    <h4>잔불과 재</h4>
                    <div class="waste-badge purple">잿불 수거함</div>
                </div>
            </div>
        </div>

        <!-- ── 대여 & 반납 플로우 ── -->
        <div id="section-rental" class="section">
            <div class="section-title">간편한 대여 &amp; 반납 절차</div>
            <div class="rental-flow">
                <div class="rental-step" data-tip="모닥모닥 앱에서 장비 찜!">
                    <div class="rental-circle">🔍</div>
                    <h4>장비 찾기</h4>
                </div>
                <div class="rental-arrow"><i class="fa-solid fa-chevron-right"></i></div>
                <div class="rental-step" data-tip="결제하면 예약 확정! 💳">
                    <div class="rental-circle">💳</div>
                    <h4>예약&amp;결제</h4>
                </div>
                <div class="rental-arrow"><i class="fa-solid fa-chevron-right"></i></div>
                <div class="rental-step" data-tip="현장에서 QR 찍고 수령! 📦">
                    <div class="rental-circle">📦</div>
                    <h4>현장 수령</h4>
                </div>
                <div class="rental-arrow"><i class="fa-solid fa-chevron-right"></i></div>
                <div class="rental-step" data-tip="지정함에 넣어주세요! 🔄">
                    <div class="rental-circle">🔄</div>
                    <h4>깔끔 반납</h4>
                </div>
            </div>
        </div>

        <!-- ── CTA ── -->
        <div class="cta-section">
            <div class="cta-card">
                <div class="cta-text">
                    <h3>지금 바로 캠핑 떠나보실래요?</h3>
                    <p>인기 장비는 빠르게 소진되니 서둘러주세요! 😊</p>
                </div>
                <button class="cta-btn" onclick="location.href='/product/list.do'">
                    장비 둘러보기 <i class="fa-solid fa-arrow-right"></i>
                </button>
            </div>
        </div>

    </div><!-- /wrap -->
</div><!-- /#app -->

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    const { createApp } = Vue;
    createApp({
        data() { return { currentTab: 'all' }; },
        methods: {
            fnTabMove(tab) {
                this.currentTab = tab;
                if (tab === 'all') {
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                    return;
                }
                var el = document.getElementById('section-' + tab);
                if (!el) return;
                /* 헤더 + 탭바 높이를 CSS 변수에서 읽어서 offset 계산 */
                var headerH  = parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--header-h')) || 86;
                var tabbarEl = document.querySelector('.tabbar-container');
                var tabbarH  = tabbarEl ? tabbarEl.getBoundingClientRect().height : 64;
                var offset   = headerH + tabbarH + 16;
                var top = el.getBoundingClientRect().top + window.pageYOffset - offset;
                window.scrollTo({ top: top, behavior: 'smooth' });
            }
        }
    }).mount('#app');
</script>

</body>
</html>
