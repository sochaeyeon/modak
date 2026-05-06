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
</head>

<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
	<div class="guide-page">
		<div class="wrap">

			<section class="page-header">
				<div class="badge">
					<i class="fa-solid fa-compass"></i>
					GUIDE CENTER
				</div>
				<h1>이용 가이드</h1>
				<p>
					모닥모닥과 함께라면 초보 캠퍼도 걱정 없어요
					<i class="fa-solid fa-face-smile guide-inline-icon"></i>
				</p>
			</section>

			<nav class="tabbar-container">
				<div class="tabbar">
					<button type="button" class="tab" :class="{active: currentTab === 'all'}" @click="fnTabMove('all')">
						<i class="fa-solid fa-table-list"></i>
						전체
					</button>
					<button type="button" class="tab" :class="{active: currentTab === 'install'}" @click="fnTabMove('install')">
						<i class="fa-solid fa-screwdriver-wrench"></i>
						설치방법
					</button>
					<button type="button" class="tab" :class="{active: currentTab === 'qr'}" @click="fnTabMove('qr')">
						<i class="fa-solid fa-qrcode"></i>
						QR코드
					</button>
					<button type="button" class="tab" :class="{active: currentTab === 'waste'}" @click="fnTabMove('waste')">
						<i class="fa-solid fa-recycle"></i>
						분리수거
					</button>
					<button type="button" class="tab" :class="{active: currentTab === 'rental'}" @click="fnTabMove('rental')">
						<i class="fa-solid fa-box-open"></i>
						대여안내
					</button>
				</div>
			</nav>

			<section id="section-install" class="section">
				<div class="section-title">
					<i class="fa-solid fa-campground"></i>
					장비 설치 방법
				</div>

				<div class="steps-grid">
					<div class="step-card" data-tip="예약하신 자리가 맞는지 꼭 봐주세요!">
						<div class="step-num">01</div>
						<div class="step-icon orange">
							<i class="fa-solid fa-location-dot"></i>
						</div>
						<h3>사이트 확인</h3>
						<p>
							예약하신 사이트 번호를 확인하고 이동해 볼까요?
							<i class="fa-solid fa-map-location-dot text-icon"></i>
						</p>
					</div>

					<div class="step-card" data-tip="파손된 곳은 없는지 모닥이랑 확인해요!">
						<div class="step-num">02</div>
						<div class="step-icon green">
							<i class="fa-solid fa-box-open"></i>
						</div>
						<h3>장비 수령</h3>
						<p>
							수령 시 상태 확인은 필수다닥!
							<i class="fa-solid fa-clipboard-check text-icon"></i>
						</p>
					</div>

					<div class="step-card" data-tip="설명이 어려우면 QR 영상을 눌러보세요!">
						<div class="step-num">03</div>
						<div class="step-icon blue">
							<i class="fa-solid fa-tent"></i>
						</div>
						<h3>텐트 설치</h3>
						<p>
							안내서나 QR 영상을 보며 천천히 해보세요.
							<i class="fa-solid fa-circle-play text-icon"></i>
						</p>
					</div>

					<div class="step-card" data-tip="완료 버튼을 누르면 캠핑 시작입니다!">
						<div class="step-num">04</div>
						<div class="step-icon purple">
							<i class="fa-solid fa-mug-hot"></i>
						</div>
						<h3>힐링 시작!</h3>
						<p>
							앱에서 완료 처리를 해 주시면 끝!
							<i class="fa-solid fa-check text-icon"></i>
						</p>
					</div>
				</div>
			</section>

			<section id="section-qr" class="section">
				<div class="section-title">
					<i class="fa-solid fa-qrcode"></i>
					QR 코드로 똑똑하게!
				</div>

				<div class="qr-card">
					<div class="qr-box">
						<i class="fa-solid fa-qrcode"></i>
						<div class="qr-label">SCAN ME</div>
					</div>

					<div class="qr-info">
						<h3>
							QR 하나로 다 해결된다닥!
							<i class="fa-solid fa-wand-magic-sparkles text-icon"></i>
						</h3>
						<p>장비에 붙은 QR 코드를 스캔만 하세요.<br>설치 방법부터 반납까지 모닥이가 알려드릴게요!</p>
					</div>
				</div>
			</section>

			<section id="section-waste" class="section">
				<div class="section-title">
					<i class="fa-solid fa-seedling"></i>
					깨끗한 캠핑을 위한 약속
				</div>

				<div class="waste-grid">
					<div class="waste-card" data-tip="내용물을 비우고 라벨은 꼭 떼주세요!">
						<div class="waste-icon-wrap blue">
							<i class="fa-solid fa-bottle-water"></i>
						</div>
						<h4>플라스틱</h4>
						<div class="waste-badge blue">파란 봉투</div>
					</div>

					<div class="waste-card" data-tip="국물을 버린 뒤 수거함에 넣어주세요!">
						<div class="waste-icon-wrap green">
							<i class="fa-solid fa-leaf"></i>
						</div>
						<h4>음식물</h4>
						<div class="waste-badge green">초록 수거함</div>
					</div>

					<div class="waste-card" data-tip="다 먹은 캔은 물로 한 번 헹궈주세요!">
						<div class="waste-icon-wrap orange">
							<i class="fa-solid fa-wine-bottle"></i>
						</div>
						<h4>캔·유리</h4>
						<div class="waste-badge orange">황색 수거함</div>
					</div>

					<div class="waste-card" data-tip="불씨가 완전히 꺼졌는지 꼭 확인!">
						<div class="waste-icon-wrap purple">
							<i class="fa-solid fa-fire-flame-simple"></i>
						</div>
						<h4>잔불과 재</h4>
						<div class="waste-badge purple">잿불 수거함</div>
					</div>
				</div>
			</section>

			<section id="section-rental" class="section">
				<div class="section-title">
					<i class="fa-solid fa-route"></i>
					간편한 대여 &amp; 반납 절차
				</div>

				<div class="rental-flow">
					<div class="rental-step" data-tip="모닥모닥 앱에서 장비 찜!">
						<div class="rental-circle">
							<i class="fa-solid fa-magnifying-glass"></i>
						</div>
						<h4>장비 찾기</h4>
					</div>

					<div class="rental-arrow">
						<i class="fa-solid fa-chevron-right"></i>
					</div>

					<div class="rental-step" data-tip="결제하면 예약 확정!">
						<div class="rental-circle">
							<i class="fa-solid fa-credit-card"></i>
						</div>
						<h4>예약&amp;결제</h4>
					</div>

					<div class="rental-arrow">
						<i class="fa-solid fa-chevron-right"></i>
					</div>

					<div class="rental-step" data-tip="현장에서 QR 찍고 수령!">
						<div class="rental-circle">
							<i class="fa-solid fa-box"></i>
						</div>
						<h4>현장 수령</h4>
					</div>

					<div class="rental-arrow">
						<i class="fa-solid fa-chevron-right"></i>
					</div>

					<div class="rental-step" data-tip="지정함에 넣어주세요!">
						<div class="rental-circle">
							<i class="fa-solid fa-rotate-left"></i>
						</div>
						<h4>깔끔 반납</h4>
					</div>
				</div>
			</section>

			<section class="cta-section">
				<div class="cta-card">
					<div class="cta-text">
						<h3>
							지금 바로 캠핑 떠나보실래요?
							<i class="fa-solid fa-campground cta-title-icon"></i>
						</h3>
						<p>
							인기 장비는 빠르게 소진되니 서둘러주세요!
							<i class="fa-solid fa-bolt text-icon light"></i>
						</p>
					</div>

					<button type="button" class="cta-btn" onclick="location.href='/product/list.do'">
						장비 둘러보기
						<i class="fa-solid fa-arrow-right"></i>
					</button>
				</div>
			</section>

		</div>
	</div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
	const { createApp } = Vue;

	createApp({
		data() {
			return {
				currentTab: 'all'
			};
		},

		methods: {
			fnTabMove(tab) {
				this.currentTab = tab;

				if (tab === 'all') {
					window.scrollTo({
						top: 0,
						behavior: 'smooth'
					});
					return;
				}

				const el = document.getElementById('section-' + tab);
				if (!el) {
					return;
				}

				const top = el.getBoundingClientRect().top + window.pageYOffset - 92;

				window.scrollTo({
					top: top,
					behavior: 'smooth'
				});
			}
		}
	}).mount('#app');
</script>

</body>
</html>
