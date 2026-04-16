<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>모닥모닥 소식</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
			rel="stylesheet">
		<style>
			*,
			*::before,
			*::after {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			:root {
				--bg: #faf7f2;
				--card-bg: #f5f0e8;
				--accent: #b85c1a;
				--accent-light: #d4763a;
				--text-primary: #2c1f0e;
				--text-secondary: #7a6a55;
				--text-muted: #a89880;
				--border: #e8dfd0;
				--badge-active: #b85c1a;
				--badge-ended: #8a8a8a;
				--tab-active-bg: #b85c1a;
				--tab-active-text: #fff;
				--tab-inactive-bg: #fff;
				--tab-inactive-text: #5a4a38;
				--tab-border: #d4c4b0;
			}

			body {
				font-family: 'Noto Sans KR', sans-serif;
				background: var(--bg);
				color: var(--text-primary);
				min-height: 100vh;
			}

			/* ── Header ── */
			.site-header {
				background: #fff;
				border-bottom: 1px solid var(--border);
				padding: 0 40px;
				display: flex;
				align-items: center;
				justify-content: space-between;
				height: 60px;
			}

			.logo {
				font-size: 18px;
				font-weight: 700;
				color: var(--text-primary);
				letter-spacing: -0.3px;
			}

			.logo span {
				color: var(--accent);
			}

			.header-nav {
				display: flex;
				gap: 28px;
				font-size: 14px;
				color: var(--text-secondary);
				cursor: pointer;
			}

			.header-nav a {
				color: var(--text-secondary);
				text-decoration: none;
			}

			.header-nav a:hover {
				color: var(--accent);
			}

			/* ── Main Content ── */
			main {
				max-width: 1040px;
				margin: 0 auto;
				padding: 60px 20px 80px;
			}

			.page-title {
				text-align: center;
				font-size: 28px;
				font-weight: 700;
				color: var(--text-primary);
				letter-spacing: -0.5px;
				margin-bottom: 10px;
			}

			.page-subtitle {
				text-align: center;
				font-size: 14px;
				color: var(--text-secondary);
				margin-bottom: 36px;
			}

			/* ── Tabs ── */
			.tabs {
				display: flex;
				justify-content: center;
				gap: 8px;
				margin-bottom: 40px;
			}

			.tab {
				padding: 9px 22px;
				border-radius: 20px;
				font-size: 14px;
				font-weight: 500;
				cursor: pointer;
				border: 1px solid var(--tab-border);
				background: var(--tab-inactive-bg);
				color: var(--tab-inactive-text);
				transition: all .2s;
			}

			.tab.active {
				background: var(--tab-active-bg);
				color: var(--tab-active-text);
				border-color: var(--tab-active-bg);
			}

			.tab:hover:not(.active) {
				border-color: var(--accent-light);
				color: var(--accent);
			}

			/* ── Cards ── */
			.cards-grid {
				display: grid;
				grid-template-columns: repeat(3, 1fr);
				gap: 24px;
				margin-bottom: 48px;
			}

			.card {
				background: #fff;
				border-radius: 14px;
				overflow: hidden;
				border: 1px solid var(--border);
				transition: box-shadow .2s, transform .2s;
				cursor: pointer;
			}

			.card:hover {
				box-shadow: 0 8px 28px rgba(0, 0, 0, .09);
				transform: translateY(-2px);
			}

			.card-image {
				width: 100%;
				aspect-ratio: 16/9;
				background: var(--card-bg);
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 12px;
				color: var(--text-muted);
				position: relative;
			}

			.card-image-placeholder {
				text-align: center;
				line-height: 1.6;
			}

			.card-badge {
				position: absolute;
				top: 12px;
				left: 12px;
				padding: 4px 10px;
				border-radius: 6px;
				font-size: 11px;
				font-weight: 600;
				color: #fff;
			}

			.badge-active {
				background: var(--badge-active);
			}

			.badge-ended {
				background: var(--badge-ended);
			}

			.card-body {
				padding: 18px 20px 20px;
			}

			.card-title {
				font-size: 16px;
				font-weight: 700;
				color: var(--text-primary);
				line-height: 1.45;
				margin-bottom: 10px;
				letter-spacing: -0.3px;
			}

			.card-desc {
				font-size: 13px;
				color: var(--text-secondary);
				line-height: 1.7;
				margin-bottom: 14px;
			}

			.card-date {
				font-size: 12px;
				color: var(--text-muted);
				display: flex;
				align-items: center;
				gap: 5px;
			}

			.card-date::before {
				content: '🏕';
				font-size: 12px;
			}

			/* ── Pagination ── */
			.pagination {
				display: flex;
				justify-content: center;
				gap: 6px;
				margin-bottom: 80px;
			}

			.page-btn {
				width: 36px;
				height: 36px;
				border-radius: 8px;
				border: 1px solid var(--border);
				background: #fff;
				font-size: 14px;
				color: var(--text-secondary);
				cursor: pointer;
				display: flex;
				align-items: center;
				justify-content: center;
				transition: all .15s;
				font-family: inherit;
			}

			.page-btn.active {
				background: var(--accent);
				color: #fff;
				border-color: var(--accent);
				font-weight: 600;
			}

			.page-btn:hover:not(.active) {
				border-color: var(--accent-light);
				color: var(--accent);
			}

			/* ── Footer ── */
			footer {
				background: #f5f0e8;
				border-top: 1px solid var(--border);
				padding: 48px 60px 28px;
			}

			.footer-top {
				display: grid;
				grid-template-columns: 1.6fr 1fr 1fr 1.2fr;
				gap: 40px;
				margin-bottom: 40px;
			}

			.footer-brand .brand-name {
				font-size: 15px;
				font-weight: 700;
				color: var(--text-primary);
				margin-bottom: 8px;
				display: flex;
				align-items: center;
				gap: 6px;
			}

			.footer-brand .brand-name::before {
				content: '🔥';
				font-size: 14px;
			}

			.footer-brand p {
				font-size: 12px;
				color: var(--text-secondary);
				line-height: 1.7;
			}

			.footer-col h4 {
				font-size: 14px;
				font-weight: 600;
				color: var(--text-primary);
				margin-bottom: 14px;
			}

			.footer-col ul {
				list-style: none;
				display: flex;
				flex-direction: column;
				gap: 8px;
			}

			.footer-col ul li a {
				font-size: 13px;
				color: var(--text-secondary);
				text-decoration: none;
			}

			.footer-col ul li a:hover {
				color: var(--accent);
			}

			.footer-contact .phone {
				font-size: 22px;
				font-weight: 700;
				color: var(--text-primary);
				letter-spacing: -0.5px;
				margin-bottom: 6px;
			}

			.footer-contact .hours {
				font-size: 12px;
				color: var(--text-secondary);
				line-height: 1.8;
				margin-bottom: 8px;
			}

			.footer-contact .email {
				font-size: 12px;
				color: var(--accent);
			}

			.footer-bottom {
				border-top: 1px solid var(--border);
				padding-top: 20px;
				display: flex;
				justify-content: space-between;
				align-items: center;
			}

			.footer-bottom .copy {
				font-size: 12px;
				color: var(--text-muted);
			}

			.footer-bottom .links {
				display: flex;
				gap: 16px;
			}

			.footer-bottom .links a {
				font-size: 12px;
				color: var(--text-secondary);
				text-decoration: none;
			}

			.footer-bottom .links a:hover {
				color: var(--accent);
			}
		</style>
	</head>

	<body>

		<!-- Header -->
		<a href="/header"></a>

		<!-- Main -->
		<main>
			<h1 class="page-title">모닥모닥 소식</h1>
			<p class="page-subtitle">특별한 혜택과 캠핑 소식을 가장 먼저 확인해보세요.</p>

			<!-- Tabs -->
			<div class="tabs">
				<button class="tab active" onclick="setTab(this)">진행중인 이벤트</button>
				<button class="tab" onclick="setTab(this)">종료된 이벤트</button>
				<button class="tab" onclick="setTab(this)">당첨자 발표</button>
			</div>

			<!-- Cards -->
			<div class="cards-grid">
				<!-- Card 1 -->
				<div class="card">
					<div class="card-image">
						<span class="card-badge badge-active">진행중</span>
						<div class="card-image-placeholder">메인 배너 이미지<br>(4:3 비율)</div>
					</div>
					<div class="card-body">
						<h3 class="card-title">신규 회원이라면? 캠핑 장비 대여<br>20% 할인 쿠폰!</h3>
						<p class="card-desc">모닥모닥과 함께하는 첫 캠핑을 응원합니다. 지금 바로 할인 쿠폰을 다운로드하고 가까운 마음으로 떠나보세요.</p>
						<div class="card-date">2026.04.01 ~ 2026.05.31</div>
					</div>
				</div>

				<!-- Card 2 -->
				<div class="card">
					<div class="card-image">
						<span class="card-badge badge-active">진행중</span>
						<div class="card-image-placeholder">메인 배너 이미지<br>(4:3 비율)</div>
					</div>
					<div class="card-body">
						<h3 class="card-title">나만의 차박 성지 공유하고 포인트<br>받자!</h3>
						<p class="card-desc">알려지지 않은 나만의 좋은 차박지를 커뮤니티에 공유해주세요. 베스트 리뷰어로 선정되면 3만 포인트를 드립니다.</p>
						<div class="card-date">2026.04.15 ~ 2026.05.15</div>
					</div>
				</div>

				<!-- Card 3 -->
				<div class="card">
					<div class="card-image">
						<span class="card-badge badge-ended">종료</span>
						<div class="card-image-placeholder">메인 배너 이미지<br>(4:3 비율)</div>
					</div>
					<div class="card-body">
						<h3 class="card-title">[조기종료] 겨울 장비 클리어런스 최<br>대 50% 세일</h3>
						<p class="card-desc">한정 수량으로 진행된 겨울 캠핑 장비 세일이 여러분의 뜨거운 성원에 힘입어 조기 종료되었습니다.</p>
						<div class="card-date">2026.03.01 ~ 2026.03.31</div>
					</div>
				</div>
			</div>

			<!-- Pagination -->
			<div class="pagination">
				<button class="page-btn active">1</button>
				<button class="page-btn">2</button>
				<button class="page-btn">3</button>
			</div>
		</main>

		<!-- Footer -->
		<footer>
			<div class="footer-top">
				<div class="footer-brand">
					<div class="brand-name">모닥모닥</div>
					<p>사람이 함께하는 뜨한한 손손을<br>모닥모닥이 함께합니다.</p>
				</div>

				<div class="footer-col">
					<h4>서비스</h4>
					<ul>
						<li><a href="#">대여시기</a></li>
						<li><a href="#">구매하기</a></li>
						<li><a href="#">캠핑장 찾기</a></li>
						<li><a href="#">신요음</a></li>
						<li><a href="#">에스토</a></li>
					</ul>
				</div>

				<div class="footer-col">
					<h4>고객지원</h4>
					<ul>
						<li><a href="#">공지사항</a></li>
						<li><a href="#">자주 묻는 질문</a></li>
						<li><a href="#">1:1 문의</a></li>
						<li><a href="#">배송 조회</a></li>
						<li><a href="#">반품/환불</a></li>
					</ul>
				</div>

				<div class="footer-col">
					<h4>문의</h4>
					<div class="footer-contact">
						<div class="phone">1588-0000</div>
						<div class="hours">
							연평시간<br>
							평일 09:00 ~ 18:00<br>
							이메일
						</div>
						<div class="email">help@modakmodak.kr</div>
					</div>
				</div>
			</div>

			<div class="footer-bottom">
				<span class="copy">© 2026 MODAK MODAK. All rights reserved.</span>
				<div class="links">
					<a href="#">이용약관</a>
					<a href="#">개인정보처리방침</a>
					<a href="#">회사소개</a>
				</div>
			</div>
		</footer>

		<script>
			function setTab(el) {
				document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
				el.classList.add('active');
			}

			document.querySelectorAll('.page-btn').forEach(btn => {
				btn.addEventListener('click', function () {
					document.querySelectorAll('.page-btn').forEach(b => b.classList.remove('active'));
					this.classList.add('active');
				});
			});
		</script>
	</body>

	</html>

	<body>
		<div id="app">
			<!-- html 코드는 id가 app인 태그 안에서 작업 -->
		</div>
		<div>
			<table>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>내용</th>
					<th>이벤트 시작일</th>
					<th>이벤트 종료일</th>
					<div class="event-period">
						<label>이벤트 기간:</label>
						<span>${event.startDate}</span> ~ <span>${event.endDate}</span>
					</div>
				</tr>
				<tr v-for="item in list">
					<td>{{item.eventId}}</td>
					<td>{{item.title}}</td>
					<td>{{item.content}}</td>
					<td>{{item.startDate}}</td>
					<td>{{item.endDate}}</td>
				</tr>
			</table>
		</div>
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					// 변수 - (키 : 값)
					list: []
				};
			},
			methods: {
				// 함수(메소드) - (key : function())
				fnList: function () {
					let self = this;
					let param = {
						// 백엔드로 전달할 데이터
					};
					$.ajax({
						url: "http://localhost:8080/event/list.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							console.log(data);
							self.list = data.list;
						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnList();
			}
		});

		app.mount('#app');
	</script>