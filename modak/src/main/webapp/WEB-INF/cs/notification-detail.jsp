<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 상세 - 모닥모닥</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<style>
			:root {
				--cream: #f7f3ee;
				--cream-dark: #f0ebe3;
				--orange: #d4714a;
				--orange-light: #e8a07a;
				--orange-pale: #fdf5f0;
				--text-dark: #3a3530;
				--text-mid: #7a7068;
				--text-light: #b0a89e;
				--border: #e8e0d8;
				--white: #ffffff;
				--blue-pale: #eef4fa;
				--blue: #6a9abf;
			}

			* {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			body {
				font-family: 'Noto Sans KR', sans-serif;
				background: #e8e4df;
				color: var(--text-dark);
				font-size: 12px;
				line-height: 1.7;
				min-height: 100vh;
			}

			/* ── BROWSER CHROME ── */
			.browser-bar {
				background: #ddd9d4;
				padding: 7px 14px;
				display: flex;
				align-items: center;
				gap: 8px;
				border-bottom: 1px solid #ccc9c4;
			}

			.b-dots {
				display: flex;
				gap: 4px;
			}

			.b-dot {
				width: 9px;
				height: 9px;
				border-radius: 50%;
				background: #c8c4bf;
			}

			.b-url {
				flex: 1;
				background: var(--white);
				border-radius: 10px;
				padding: 3px 12px;
				font-size: 9px;
				color: var(--text-light);
				max-width: 340px;
				margin: 0 auto;
				text-align: center;
			}

			/* ── PAGE SHELL ── */
			.page {
				background: var(--white);
				max-width: 860px;
				margin: 0 auto;
				box-shadow: 0 0 40px rgba(0, 0, 0, 0.10);
				min-height: 100vh;
			}

			/* ── TOP BAR ── */
			.top-bar {
				background: var(--white);
				border-bottom: 1px solid var(--border);
				/* highlight border — purple dashed from screenshot */
				border: 2px dashed #9b6ecf;
				padding: 0 24px;
				height: 44px;
				display: flex;
				align-items: center;
				justify-content: space-between;
				position: relative;
			}

			.logo {
				font-size: 14px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: -0.5px;
			}

			.nav-center-title {
				position: absolute;
				left: 50%;
				transform: translateX(-50%);
				font-size: 15px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: 3px;
				pointer-events: none;
			}

			.top-icons {
				display: flex;
				align-items: center;
				gap: 12px;
				font-size: 13px;
				color: var(--text-mid);
			}

			.top-icons a {
				color: var(--text-mid);
				text-decoration: none;
			}

			.top-icons a:hover {
				color: var(--orange);
			}

			.cart-wrap {
				position: relative;
			}

			.cart-count {
				position: absolute;
				top: -5px;
				right: -6px;
				background: var(--orange);
				color: #fff;
				font-size: 7px;
				width: 13px;
				height: 13px;
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
				font-weight: 700;
			}

			.icon-label {
				font-size: 9px;
				color: var(--text-light);
			}

			/* ── NAV SUBNAV ── */
			.sub-nav {
				background: var(--white);
				border-bottom: 1px solid var(--border);
				padding: 0 24px;
				height: 36px;
				display: flex;
				align-items: center;
				gap: 14px;
				font-size: 10px;
			}

			.sub-nav a {
				color: var(--text-light);
				text-decoration: none;
				white-space: nowrap;
			}

			.sub-nav a:hover {
				color: var(--orange);
			}

			.sub-nav a.active {
				color: var(--orange);
				font-weight: 700;
			}

			.sub-nav .dv {
				color: var(--border);
			}

			/* ── CONTENT AREA ── */
			.content {
				max-width: 680px;
				margin: 0 auto;
				padding: 24px 20px 48px;
			}

			/* BREADCRUMB */
			.breadcrumb {
				font-size: 10px;
				color: var(--text-light);
				display: flex;
				align-items: center;
				gap: 4px;
				margin-bottom: 12px;
			}

			.breadcrumb a {
				color: var(--text-light);
				text-decoration: none;
			}

			.breadcrumb a:hover {
				color: var(--orange);
			}

			.breadcrumb .cur {
				color: var(--text-mid);
			}

			/* PAGE TITLE */
			.page-title {
				font-size: 18px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 3px;
				letter-spacing: -0.3px;
			}

			.page-desc {
				font-size: 10px;
				color: var(--text-light);
				margin-bottom: 20px;
			}

			/* ── ARTICLE HEADER CARD ── */
			.article-header {
				background: var(--orange);
				border-radius: 6px;
				padding: 18px 20px;
				margin-bottom: 0;
				position: relative;
				overflow: hidden;
			}

			.article-header::before {
				content: '';
				position: absolute;
				right: -20px;
				top: -20px;
				width: 120px;
				height: 120px;
				border-radius: 50%;
				background: rgba(255, 255, 255, 0.06);
			}

			.ah-badges {
				display: flex;
				gap: 6px;
				margin-bottom: 10px;
			}

			.ah-badge {
				display: inline-block;
				font-size: 9px;
				font-weight: 700;
				padding: 2px 8px;
				border-radius: 3px;
				background: rgba(255, 255, 255, 0.25);
				color: #fff;
				letter-spacing: 0.3px;
			}

			.ah-title {
				font-size: 17px;
				font-weight: 700;
				color: #fff;
				line-height: 1.4;
				letter-spacing: -0.3px;
			}

			/* ── META ROW ── */
			.meta-row {
				display: flex;
				align-items: center;
				justify-content: space-between;
				padding: 10px 2px;
				border-bottom: 1px solid var(--border);
				margin-bottom: 24px;
				flex-wrap: wrap;
				gap: 6px;
			}

			.meta-left {
				display: flex;
				gap: 14px;
				align-items: center;
			}

			.meta-item {
				font-size: 10px;
				color: var(--text-light);
			}

			.meta-item strong {
				color: var(--text-mid);
			}

			.meta-actions {
				display: flex;
				gap: 8px;
			}

			.meta-btn {
				font-size: 10px;
				color: var(--text-light);
				background: var(--cream);
				border: 1px solid var(--border);
				border-radius: 3px;
				padding: 4px 10px;
				cursor: pointer;
				font-family: 'Noto Sans KR', sans-serif;
				transition: all 0.15s;
			}

			.meta-btn:hover {
				border-color: var(--orange);
				color: var(--orange);
			}

			/* ── ARTICLE BODY ── */
			.article-body {
				margin-bottom: 28px;
			}

			.a-section {
				margin-bottom: 22px;
			}

			.a-section-title {
				font-size: 12px;
				font-weight: 700;
				color: var(--orange);
				margin-bottom: 7px;
				display: flex;
				align-items: center;
				gap: 5px;
			}

			.a-section-title::before {
				content: '';
				display: inline-block;
				width: 3px;
				height: 12px;
				background: var(--orange);
				border-radius: 2px;
			}

			.a-text {
				font-size: 11px;
				color: var(--text-mid);
				line-height: 1.9;
			}

			/* highlight box */
			.a-highlight {
				background: var(--blue-pale);
				border-left: 3px solid var(--blue);
				border-radius: 0 4px 4px 0;
				padding: 10px 14px;
				margin: 10px 0;
			}

			.a-highlight p {
				font-size: 10px;
				color: #4a7090;
				line-height: 1.8;
			}

			.a-highlight strong {
				font-weight: 700;
			}

			/* bullet list */
			.a-list {
				list-style: none;
				padding: 0;
				margin: 6px 0;
			}

			.a-list li {
				font-size: 11px;
				color: var(--text-mid);
				padding: 3px 0 3px 14px;
				position: relative;
				line-height: 1.7;
			}

			.a-list li::before {
				content: '•';
				position: absolute;
				left: 0;
				color: var(--orange);
				font-weight: 700;
			}

			/* inline link */
			.a-link {
				color: var(--orange);
				text-decoration: underline;
				cursor: pointer;
				font-size: 11px;
			}

			/* ── ATTACHMENTS ── */
			.attach-section {
				margin-bottom: 28px;
			}

			.attach-title {
				font-size: 11px;
				font-weight: 700;
				color: var(--text-mid);
				margin-bottom: 8px;
				display: flex;
				align-items: center;
				gap: 5px;
			}

			.attach-title::before {
				content: '';
				display: inline-block;
				width: 3px;
				height: 11px;
				background: var(--orange);
				border-radius: 2px;
			}

			.attach-item {
				display: flex;
				align-items: center;
				justify-content: space-between;
				background: var(--cream);
				border: 1px solid var(--border);
				border-radius: 4px;
				padding: 8px 12px;
				margin-bottom: 6px;
				gap: 10px;
			}

			.attach-left {
				display: flex;
				align-items: center;
				gap: 8px;
			}

			.attach-ext {
				font-size: 8px;
				font-weight: 700;
				padding: 2px 5px;
				border-radius: 2px;
				background: #d9534f;
				color: #fff;
				letter-spacing: 0.5px;
			}

			.attach-ext.hwp {
				background: var(--blue);
			}

			.attach-name {
				font-size: 11px;
				color: var(--text-dark);
			}

			.attach-right {
				display: flex;
				align-items: center;
				gap: 10px;
				font-size: 10px;
				color: var(--text-light);
			}

			.attach-size {
				white-space: nowrap;
			}

			.attach-dl {
				color: var(--orange);
				font-size: 10px;
				cursor: pointer;
				text-decoration: underline;
				white-space: nowrap;
			}

			.attach-dl:hover {
				color: #b05030;
			}

			/* ── NAV PREV/NEXT ── */
			.article-nav {
				border-top: 1px solid var(--border);
				border-bottom: 1px solid var(--border);
				margin-bottom: 20px;
			}

			.nav-row {
				display: flex;
				align-items: center;
				gap: 12px;
				padding: 11px 2px;
				border-bottom: 1px solid #f0ebe3;
				cursor: pointer;
				transition: background 0.12s;
			}

			.nav-row:last-child {
				border-bottom: none;
			}

			.nav-row:hover {
				background: var(--orange-pale);
			}

			.nav-label {
				font-size: 9px;
				color: var(--text-light);
				white-space: nowrap;
				width: 36px;
				text-align: right;
				flex-shrink: 0;
			}

			.nav-arrow {
				font-size: 11px;
				color: var(--text-light);
				flex-shrink: 0;
			}

			.nav-title {
				font-size: 11px;
				color: var(--text-mid);
				flex: 1;
			}

			.nav-title:hover {
				color: var(--orange);
			}

			.nav-date {
				font-size: 10px;
				color: var(--text-light);
				white-space: nowrap;
			}

			/* ── BACK BUTTON ── */
			.back-wrap {
				display: flex;
				justify-content: center;
				margin-top: 20px;
			}

			.back-btn {
				display: flex;
				align-items: center;
				gap: 6px;
				border: 1px solid var(--border);
				background: var(--white);
				border-radius: 4px;
				padding: 8px 28px;
				font-size: 11px;
				color: var(--text-mid);
				cursor: pointer;
				font-family: 'Noto Sans KR', sans-serif;
				transition: all 0.15s;
			}

			.back-btn:hover {
				border-color: var(--orange);
				color: var(--orange);
			}

			/* ── FOOTER ── */
			footer {
				background: var(--cream-dark);
				border-top: 1px solid var(--border);
				padding: 26px 24px 12px;
			}

			.footer-inner {
				display: flex;
				gap: 20px;
				margin-bottom: 18px;
				max-width: 680px;
				margin-left: auto;
				margin-right: auto;
			}

			.f-brand {
				flex: 1.6;
			}

			.f-brand-name {
				display: flex;
				align-items: center;
				gap: 6px;
				font-size: 12px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 6px;
			}

			.f-brand-icon {
				width: 20px;
				height: 20px;
				background: var(--orange);
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
				color: #fff;
				font-size: 9px;
			}

			.f-brand-desc {
				font-size: 9px;
				color: var(--text-light);
				line-height: 1.9;
			}

			.f-nav {
				flex: 1;
			}

			.f-nav h4 {
				font-size: 10px;
				font-weight: 700;
				color: var(--text-mid);
				margin-bottom: 7px;
			}

			.f-nav ul {
				list-style: none;
			}

			.f-nav li {
				margin-bottom: 4px;
			}

			.f-nav a {
				font-size: 9px;
				color: var(--text-light);
				text-decoration: none;
			}

			.f-nav a:hover {
				color: var(--orange);
			}

			.f-contact {
				flex: 1.2;
			}

			.f-contact h4 {
				font-size: 10px;
				font-weight: 700;
				color: var(--text-mid);
				margin-bottom: 7px;
			}

			.f-phone {
				font-size: 17px;
				font-weight: 900;
				color: var(--text-dark);
				letter-spacing: -1px;
				margin-bottom: 4px;
			}

			.f-hours {
				font-size: 9px;
				color: var(--text-light);
				line-height: 1.9;
			}

			.f-hours a {
				color: var(--orange);
				text-decoration: none;
			}

			.footer-bottom {
				max-width: 680px;
				margin: 0 auto;
				border-top: 1px solid var(--border);
				padding-top: 10px;
				display: flex;
				justify-content: space-between;
				font-size: 9px;
				color: var(--text-light);
			}

			.footer-bottom a {
				color: var(--text-light);
				text-decoration: none;
				margin-left: 9px;
			}

			.footer-bottom a:hover {
				color: var(--orange);
			}
		</style>
	</head>

	<body>

		<!-- BROWSER BAR -->
		<div class="browser-bar">
			<div class="b-dots">
				<div class="b-dot"></div>
				<div class="b-dot"></div>
				<div class="b-dot"></div>
			</div>
			<div class="b-url">modakmodak.com/notice/detail/42</div>
		</div>

		<div class="page">

			<!-- Header -->
			<%@ include file="/WEB-INF/common/header.jsp" %>
				<!-- CONTENT -->
				<div class="content">

					<!-- BREADCRUMB -->
					<div class="breadcrumb">
						<a href="#">홈</a>
						<span>›</span>
						<a href="#">고객센터</a>
						<span>›</span>
						<span class="cur">공지사항</span>
					</div>

					<div class="page-title">공지사항</div>
					<div class="page-desc">서비스 관련 안내 및 업데이트 소식을 확인하세요.</div>

					<!-- ARTICLE HEADER CARD -->
					<div class="article-header">
						<div class="ah-badges">
							<span class="ah-badge">서비스 공지</span>
							<span class="ah-badge">필독 안내</span>
						</div>
						<div class="ah-title">2024년 개인정보 처리방침 개정 안내</div>
					</div>

					<!-- META ROW -->
					<div class="meta-row">
						<div class="meta-left">
							<div class="meta-item"><strong>카테고리</strong> &nbsp;서비스 공지</div>
							<div class="meta-item"><strong>등록일자</strong> &nbsp;2024.03.20</div>
							<div class="meta-item"><strong>조회수</strong> &nbsp;3,442</div>
						</div>
						<div class="meta-actions">
							<button class="meta-btn">목록에 보관</button>
							<button class="meta-btn">인쇄하기</button>
						</div>
					</div>

					<!-- ARTICLE BODY -->
					<div class="article-body">

						<!-- 개정 개요 -->
						<div class="a-section">
							<div class="a-section-title">개정 개요</div>
							<p class="a-text">
								안녕하세요, 모닥모닥 서비스입니다.<br>
								2024년 3월 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」의 개정에 따라 당사의 개인정보 처리방침을 아래와 같이 개정하게 되었습니다. 개정된
								처리방침은
								시행일을 기준으로 적용되오니 반드시 확인하시기 바랍니다.
							</p>

							<div class="a-highlight">
								<p>
									📌 관련 근거: 「개인정보 보호법」 제30조, 「정보통신망법」 제27조의2에 따른 고지 의무<br>
									사생활적 정보처리방침의 열람은 공식 홈페이지 내 개인정보 처리방침 문서에서 확인할 수 있습니다.
								</p>
							</div>
						</div>

						<!-- 주요 개정 내용 -->
						<div class="a-section">
							<div class="a-section-title">주요 개정 내용</div>
							<ul class="a-list">
								<li>개인정보 수집 항목에서 서비스 이용 기기 정보 추가 (Wi-Fi 연결 여부, OS 버전 포함)</li>
								<li>마케팅 목적 수신 거부 방법에 관한 안내 절차 추가 및 처리방법 구체적 안내</li>
								<li>제3자 제공 목적 및 제공받는 제3자 변경 — 새로운 파트너사 알림(부록 A 참조)</li>
								<li>이용자의 권리 행사 방법(열람/정정, 삭제, 처리정지) 관련 절차 구체화</li>
								<li>보안강화 및 개인정보 보관기간 연장 안내 포함</li>
							</ul>
						</div>

						<!-- 시행 일정 -->
						<div class="a-section">
							<div class="a-section-title">시행 일정</div>
							<p class="a-text">
								개정 처리방침은 <span class="a-link">2024년 4월 1일(월)</span>부터 시행됩니다.<br>
								공지일 기준 30일간의 사전 고지 기간을 운영하며, 해당 시행일 이후 별도 동의 없이 만 11 문서를 통해 공유하시기 바랍니다.
							</p>
						</div>

					</div><!-- /article-body -->

					<!-- ATTACHMENTS -->
					<div class="attach-section">
						<div class="attach-title">첨부 파일</div>
						<div class="attach-item">
							<div class="attach-left">
								<span class="attach-ext">PDF</span>
								<span class="attach-name">개인정보_처리방침_변경안_2024.pdf</span>
							</div>
							<div class="attach-right">
								<span class="attach-size">1.2 MB</span>
								<span class="attach-dl">다운로드</span>
							</div>
						</div>
						<div class="attach-item">
							<div class="attach-left">
								<span class="attach-ext hwp">HWP</span>
								<span class="attach-name">개인정보_처리방침_변경안내문_서고문.hwp</span>
							</div>
							<div class="attach-right">
								<span class="attach-size">486 KB</span>
								<span class="attach-dl">다운로드</span>
							</div>
						</div>
					</div>

					<!-- PREV / NEXT NAV -->
					<div class="article-nav">
						<div class="nav-row">
							<span class="nav-label">이전 글</span>
							<span class="nav-arrow">∧</span>
							<span class="nav-title">앱 업데이트 필요 안내 및 재시작 사항 안내</span>
							<span class="nav-date">2024.03.18</span>
						</div>
						<div class="nav-row">
							<span class="nav-label">다음 글</span>
							<span class="nav-arrow">∨</span>
							<span class="nav-title">결제 오류/포인트 이월되지 않는 이슈 및 복구 처리 안내</span>
							<span class="nav-date">2024.03.22</span>
						</div>
					</div>

					<!-- BACK BUTTON -->
					<div class="back-wrap">
						<button class="back-btn">목록으로 ↑</button>
					</div>

				</div><!-- /content -->

				<!-- Footer -->
				<%@ include file="/WEB-INF/common/footer.jsp" %>

		</div><!-- /page -->

		<script>
			// Back button
			document.querySelector('.back-btn').addEventListener('click', function () {
				history.back ? history.back() : (window.location.href = '#');
			});
			// Attach download mock
			document.querySelectorAll('.attach-dl').forEach(el => {
				el.addEventListener('click', function (e) {
					e.preventDefault();
					alert('파일 다운로드가 시작됩니다.');
				});
			});
			// Nav rows
			document.querySelectorAll('.nav-row').forEach(row => {
				row.style.cursor = 'pointer';
			});
		</script>
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					// 변수 - (key : value)
				};
			},
			methods: {
				// 함수(메소드) - (key : function())
				fnList: function () {
					let self = this;
					let param = {};
					$.ajax({
						url: "http://localhost:8080/notification/detail.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {

						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
			}
		});

		app.mount('#app');
	</script>