<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 이용 가이드</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/guide/guide.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
    <div class="wrap">
       

        <div class="tabbar">
            <button class="tab" :class="{active: currentTab === 'all'}" @click="fnTabMove('all')">📋 전체 가이드</button>
            <button class="tab" :class="{active: currentTab === 4}" @click="fnTabMove(4)">🔧 설치 방법</button>
            <button class="tab" :class="{active: currentTab === 'qr'}" @click="fnTabMove('qr')">📱 QR 코드</button>
            <button class="tab" :class="{active: currentTab === 'waste'}" @click="fnTabMove('waste')">♻️ 분리수거</button>
            <button class="tab" :class="{active: currentTab === 'rental'}" @click="fnTabMove('rental')">📦 대여 안내</button>
        </div>

        <div class="page-header">
            <h1>이용 가이드</h1>
            <p>모닥모닥과 함께라면 초보 캠퍼도 걱정 없다닥! 아래 가이드를 확인해 보세요. 😊</p>
        </div>

  <div id="section-4" class="section" style="margin-top: 28px;">
    <div class="section-title">장비 설치 방법</div>
    <div class="steps-grid">
        <div class="step-card" data-tip="예약하신 자리가 맞는지 꼭 봐주라닥!">
            <div class="step-num">1</div>
            <div class="step-icon orange">🏕️</div>
            <h3>사이트 확인</h3>
            <p>예약하신 사이트 번호를 확인하고, 설레는 마음으로 이동해 볼까요?</p>
            <span class="step-tag">10분 소요</span>
        </div>

        <div class="step-card" data-tip="파손된 곳은 없는지 모닥이랑 확인해요!">
            <div class="step-num">2</div>
            <div class="step-icon green">📦</div>
            <h3>소중한 장비 수령</h3>
            <p>확인증을 보여주시면 장비를 드려요! 수령 시 상태 확인은 필수다닥!</p>
            <span class="step-tag">체크리스트 필수</span>
        </div>

        <div class="step-card" data-tip="설명이 어려우면 QR 영상을 눌러보세요!">
            <div class="step-num">3</div>
            <div class="step-icon blue">⛺</div>
            <h3>아늑한 텐트 설치</h3>
            <p>동봉된 안내서나 QR 영상을 보며 천천히 설치해 보세요. 금방 아늑해질 거예요!</p>
            <span class="step-tag">QR 영상 제공</span>
        </div>

        <div class="step-card" data-tip="완료 버튼을 누르면 캠핑 시작이다닥!">
            <div class="step-num">4</div>
            <div class="step-icon purple">✅</div>
            <h3>준비 끝, 힐링 시작!</h3>
            <p>설치 후 앱에서 완료 처리를 해 주시면 기분 좋은 대여가 시작됩니다.</p>
            <span class="step-tag">앱에서 처리</span>
        </div>
    </div>
</div>

        <div id="section-qr" class="section" style="margin-top: 28px;">
            <div class="section-title">QR 코드로 똑똑하게!</div>
            <div class="qr-card">
                <div class="qr-box" data-tip="장비에 붙은 이 스티커를 찾아보세요!">
                    <div class="qr-pixel">
                        <div class="b"></div><div class="b"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="b"></div><div class="b"></div>
                        <div class="b"></div><div class="w"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="w"></div><div class="b"></div>
                        <div class="b"></div><div class="b"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="b"></div><div class="b"></div>
                        <div class="w"></div><div class="w"></div><div class="w"></div><div class="b"></div><div class="w"></div><div class="w"></div><div class="w"></div>
                        <div class="b"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="b"></div><div class="w"></div><div class="b"></div>
                        <div class="b"></div><div class="w"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="b"></div><div class="w"></div>
                        <div class="b"></div><div class="b"></div><div class="b"></div><div class="b"></div><div class="w"></div><div class="b"></div><div class="b"></div>
                    </div>
                    <div style="font-size: 10px; color: #aaa; margin-top: 6px;">장비 스캔 예시</div>
                </div>
                <div class="qr-info">
                    <h3>QR 하나로 다 해결된다닥!</h3>
                    <p>장비에 붙은 QR 코드를 스캔만 하세요.<br>설치 방법부터 반납까지 모닥이가 친절히 알려드릴게요!</p>
                </div>
            </div>
        </div>

        <div id="section-waste" class="section" style="margin-top: 28px;">
            <div class="section-title">깨끗한 캠핑을 위한 약속</div>
            <div class="waste-grid">
                <div class="waste-card" data-tip="내용물을 비우고 라벨은 꼭 떼주세요! 😊">
                    <div class="waste-icon-wrap" style="background: #ddeeff;">🧴</div>
                    <h4>플라스틱</h4>
                    <div class="waste-badge" style="background: #ddeeff; color: #185fa5;">파란 봉투</div>
                </div>
                <div class="waste-card" data-tip="국물을 버린 뒤 수거함에 넣어주세요! 🥬">
                    <div class="waste-icon-wrap" style="background: #dff0e4;">🥬</div>
                    <h4>음식물</h4>
                    <div class="waste-badge" style="background: #dff0e4; color: #3b6d11;">초록 수거함</div>
                </div>
                <div class="waste-card" data-tip="납작하게 접어서 노끈으로 묶어주세요! 📄">
                    <div class="waste-icon-wrap" style="background: #faeeda;">📄</div>
                    <h4>종이류</h4>
                    <div class="waste-badge" style="background: #faeeda; color: #854f0b;">묶어서 배출</div>
                </div>
                <div class="waste-card" data-tip="다 먹은 캔은 물로 한 번 헹궈주세요! 🍺">
                    <div class="waste-icon-wrap" style="background: #fde8d8;">🍺</div>
                    <h4>캔·유리</h4>
                    <div class="waste-badge" style="background: #fde8d8; color: #993c1d;">황색 수거함</div>
                </div>
                <div class="waste-card" data-tip="불씨가 완전히 꺼졌는지 꼭 확인! 🔥">
                    <div class="waste-icon-wrap" style="background: #ece8fb;">🔥</div>
                    <h4>잔불과 재</h4>
                    <div class="waste-badge" style="background: #ece8fb; color: #534ab7;">잿불 수거함</div>
                </div>
                <div class="waste-card" data-tip="매점에서 전용 봉투를 구매해 주세요! 🚯">
                    <div class="waste-icon-wrap" style="background: #f5f0e8;">🚯</div>
                    <h4>일반 쓰레기</h4>
                    <div class="waste-badge" style="background: #f5f0e8; color: #888;">종량제 봉투</div>
                </div>
            </div>
        </div>

        <div id="section-rental" class="section" style="margin-top: 28px;">
            <div class="section-title">간편한 대여 & 반납 절차</div>
            <div class="rental-flow">
                <div class="rental-step" data-tip="모닥모닥 앱에서 원하는 장비를 찜!">
                    <div class="rental-circle">🔍</div>
                    <h4>장비 찾기</h4>
                </div>
                <div class="rental-step" data-tip="날짜와 장소를 정해주시면 준비할게요! 📅">
                    <div class="rental-circle">📅</div>
                    <h4>예약하기</h4>
                </div>
                <div class="rental-step" data-tip="결제하면 예약 확정 문자가 가요! 💳">
                    <div class="rental-circle">💳</div>
                    <h4>결제하기</h4>
                </div>
                <div class="rental-step" data-tip="현장에서 QR 찍고 바로 가져가세요! 📦">
                    <div class="rental-circle">📦</div>
                    <h4>기분 좋은 수령</h4>
                </div>
                <div class="rental-step" data-tip="사용한 장비는 지정함에 넣어주세요! 🔄">
                    <div class="rental-circle">🔄</div>
                    <h4>깔끔한 반납</h4>
                </div>
            </div>
        </div>

        <div class="section" style="margin-top: 24px;">
            <div class="cta-card">
                <div>
                    <h3>지금 바로 캠핑 떠나보실래요?</h3>
                    <p>인기 장비는 빠르게 소진되니 서둘러주세요! 😊</p>
                </div>
                <button class="cta-btn" onclick="location.href='/product/list.do'">장비 둘러보기 →</button>
            </div>
        </div>
    </div>
</div>

<script>
const { createApp } = Vue;
createApp({
    data() { return { currentTab: 'all', guideList: [] }; },
    computed: {
        setupGuides() { return this.guideList.filter(g => g.CATEGORY_ID === 4); }
    },
    methods: {
        fnGetList() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/guide/list.dox',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({}),
                success: (res) => { this.guideList = res; }
            });
        },
        fnTabMove(tab) {
            this.currentTab = tab;
            if (tab !== 'all') {
                const element = document.getElementById('section-' + tab);
                if (element) {
                    const offset = 120;
                    const bodyRect = document.body.getBoundingClientRect().top;
                    const elementRect = element.getBoundingClientRect().top;
                    const offsetPosition = elementRect - bodyRect - offset;
                    window.scrollTo({ top: offsetPosition, behavior: 'smooth' });
                }
            } else { window.scrollTo({ top: 0, behavior: 'smooth' }); }
        }
    },
    mounted() { this.fnGetList(); }
}).mount('#app');
</script>
</body>
</html>