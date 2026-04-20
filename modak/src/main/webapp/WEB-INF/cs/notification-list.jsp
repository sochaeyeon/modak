<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 - 모닥모닥</title>
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
				--red: #d9534f;
				--blue: #6a9abf;
				--green: #7aab8a;
			}

			* {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			body {
				font-family: 'Noto Sans KR', sans-serif;
				background: #eeebe6;
				color: var(--text-dark);
				font-size: 12px;
				line-height: 1.6;
				min-height: 100vh;
			}

			/* ── OUTER BROWSER CHROME ── */
			.browser-wrap {
				background: #e5e1dc;
				min-height: 100vh;
				padding: 0;
			}

			.browser-bar {
				background: #ddd9d4;
				padding: 8px 16px;
				display: flex;
				align-items: center;
				gap: 10px;
				border-bottom: 1px solid #ccc9c4;
			}

			.browser-dots {
				display: flex;
				gap: 5px;
			}

			.browser-dot {
				width: 10px;
				height: 10px;
				border-radius: 50%;
				background: #ccc;
			}

			.browser-url {
				flex: 1;
				background: var(--white);
				border-radius: 10px;
				padding: 3px 12px;
				font-size: 10px;
				color: var(--text-light);
				max-width: 360px;
				margin: 0 auto;
				text-align: center;
			}

			/* ── PAGE WRAP ── */
			.page {
				background: var(--white);
				max-width: 900px;
				margin: 0 auto;
				min-height: 100vh;
				box-shadow: 0 0 40px rgba(0, 0, 0, 0.08);
			}

			/* ── TOP BAR ── */
			.top-bar {
				background: var(--white);
				border-bottom: 1px solid var(--border);
				padding: 0 28px;
				height: 44px;
				display: flex;
				align-items: center;
				justify-content: space-between;
			}

			.logo {
				font-size: 15px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: -0.5px;
			}

			.top-icons {
				display: flex;
				align-items: center;
				gap: 14px;
				font-size: 14px;
				color: var(--text-mid);
			}

			.top-icons .cart-wrap {
				position: relative;
				cursor: pointer;
			}

			.cart-count {
				position: absolute;
				top: -5px;
				right: -6px;
				background: var(--orange);
				color: #fff;
				font-size: 8px;
				width: 14px;
				height: 14px;
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
				font-weight: 700;
			}

			.top-icons span {
				font-size: 10px;
				color: var(--text-light);
				cursor: pointer;
			}

			.top-icons span:hover {
				color: var(--orange);
			}

			.top-icons a {
				color: var(--text-mid);
				text-decoration: none;
				cursor: pointer;
				font-size: 13px;
			}

			.top-icons a:hover {
				color: var(--orange);
			}

			/* ── NAV BAR ── */
			.nav-bar {
				background: var(--white);
				border-bottom: 1.5px solid var(--border);
				display: flex;
				align-items: center;
				justify-content: space-between;
				padding: 0 28px;
				height: 42px;
			}

			.nav-center {
				font-size: 15px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: 3px;
				position: absolute;
				left: 50%;
				transform: translateX(-50%);
			}

			.nav-subnav {
				display: flex;
				align-items: center;
				gap: 16px;
				font-size: 10px;
				color: var(--text-light);
			}

			.nav-subnav a {
				color: var(--text-light);
				text-decoration: none;
				cursor: pointer;
			}

			.nav-subnav a:hover {
				color: var(--orange);
			}

			.nav-subnav .active {
				color: var(--orange);
				font-weight: 700;
			}

			.nav-subnav .divider-v {
				color: var(--border);
			}

			.nav-right-btns {
				display: flex;
				align-items: center;
				gap: 12px;
				font-size: 11px;
				color: var(--text-mid);
			}

			.nav-right-btns a {
				color: var(--text-mid);
				text-decoration: none;
			}

			.nav-right-btns a:hover {
				color: var(--orange);
			}

			/* ── BREADCRUMB ── */
			.breadcrumb-bar {
				background: var(--white);
				padding: 8px 28px;
				border-bottom: 1px solid var(--border);
				font-size: 10px;
				color: var(--text-light);
				display: flex;
				align-items: center;
				gap: 5px;
			}

			.breadcrumb-bar a {
				color: var(--text-light);
				text-decoration: none;
			}

			.breadcrumb-bar a:hover {
				color: var(--orange);
			}

			.breadcrumb-bar .current {
				color: var(--text-mid);
				font-weight: 500;
			}

			/* ── CONTENT ── */
			.content {
				padding: 28px 28px 48px;
				background: var(--white);
			}

			.page-title {
				font-size: 20px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: -0.5px;
				margin-bottom: 4px;
			}

			.page-desc {
				font-size: 11px;
				color: var(--text-light);
				margin-bottom: 20px;
			}

			/* ── CATEGORY TABS ── */
			.cat-tabs {
				display: flex;
				gap: 0;
				border-bottom: 2px solid var(--border);
				margin-bottom: 18px;
			}

			.cat-tab {
				padding: 8px 16px;
				font-size: 12px;
				color: var(--text-light);
				cursor: pointer;
				border-bottom: 2px solid transparent;
				margin-bottom: -2px;
				transition: color 0.15s;
				white-space: nowrap;
			}

			.cat-tab:hover {
				color: var(--text-mid);
			}

			.cat-tab.active {
				color: var(--orange);
				border-bottom-color: var(--orange);
				font-weight: 700;
			}

			/* ── SEARCH BAR ── */
			.search-bar {
				display: flex;
				justify-content: flex-end;
				align-items: center;
				gap: 6px;
				margin-bottom: 6px;
			}

			.search-input-wrap {
				display: flex;
				align-items: center;
				border: 1px solid var(--border);
				border-radius: 4px;
				overflow: hidden;
				background: var(--white);
			}

			.search-input-wrap input {
				border: none;
				outline: none;
				padding: 6px 10px;
				font-size: 10px;
				font-family: 'Noto Sans KR', sans-serif;
				color: var(--text-dark);
				width: 160px;
				background: transparent;
			}

			.search-input-wrap input::placeholder {
				color: var(--text-light);
			}

			.search-btn {
				background: none;
				border: none;
				padding: 0 8px;
				cursor: pointer;
				color: var(--text-light);
				font-size: 12px;
			}

			.search-btn:hover {
				color: var(--orange);
			}

			.search-type-btn {
				background: var(--cream-dark);
				border: 1px solid var(--border);
				border-radius: 4px;
				padding: 6px 12px;
				font-size: 10px;
				color: var(--text-mid);
				cursor: pointer;
				font-family: 'Noto Sans KR', sans-serif;
			}

			/* ── TOTAL COUNT ── */
			.total-count {
				font-size: 10px;
				color: var(--text-light);
				margin-bottom: 6px;
			}

			.total-count strong {
				color: var(--orange);
			}

			/* ── NOTICE TABLE ── */
			.notice-table {
				width: 100%;
				border-collapse: collapse;
				border-top: 1.5px solid var(--text-dark);
			}

			.notice-table thead tr {
				border-bottom: 1px solid var(--border);
				background: var(--cream);
			}

			.notice-table thead th {
				padding: 9px 10px;
				font-size: 10px;
				font-weight: 700;
				color: var(--text-mid);
				text-align: center;
				letter-spacing: 0.3px;
			}

			.notice-table thead th.left {
				text-align: left;
			}

			.notice-table tbody tr {
				border-bottom: 1px solid #f0ebe3;
				transition: background 0.12s;
			}

			.notice-table tbody tr:hover {
				background: var(--orange-pale);
			}

			.notice-table tbody tr.pinned {
				background: #fffaf7;
			}

			.notice-table tbody td {
				padding: 10px 10px;
				font-size: 11px;
				color: var(--text-mid);
				text-align: center;
				vertical-align: middle;
			}

			.notice-table tbody td.title-cell {
				text-align: left;
				color: var(--text-dark);
				cursor: pointer;
				max-width: 320px;
			}

			.notice-table tbody td.title-cell:hover {
				color: var(--orange);
			}

			.num-cell {
				width: 40px;
			}

			.badge-wrap {
				display: flex;
				align-items: center;
				gap: 6px;
				flex-wrap: nowrap;
			}

			.n-badge {
				display: inline-block;
				font-size: 9px;
				padding: 2px 6px;
				border-radius: 3px;
				font-weight: 700;
				white-space: nowrap;
				flex-shrink: 0;
			}

			.n-badge.notice {
				background: #ffeee8;
				color: var(--orange);
				border: 1px solid #f5cfc4;
			}

			.n-badge.event {
				background: #e8f0ff;
				color: #5a7bbf;
				border: 1px solid #c4d4f5;
			}

			.n-badge.update {
				background: #e8f5ee;
				color: #5a9a72;
				border: 1px solid #c4e8d0;
			}

			.n-badge.notice2 {
				background: #fff5e0;
				color: #c8880a;
				border: 1px solid #f0d898;
			}

			.n-badge.gray {
				background: #f2f0ee;
				color: var(--text-light);
				border: 1px solid var(--border);
			}

			.new-dot {
				display: inline-block;
				width: 5px;
				height: 5px;
				background: var(--orange);
				border-radius: 50%;
				margin-left: 5px;
				vertical-align: middle;
				flex-shrink: 0;
			}

			.title-text {
				font-size: 11px;
				color: var(--text-dark);
			}

			.title-text.pinned {
				font-weight: 700;
			}

			.pin-icon {
				color: var(--orange);
				font-size: 10px;
				margin-right: 3px;
			}

			/* ── PAGINATION ── */
			.pagination {
				display: flex;
				justify-content: center;
				align-items: center;
				gap: 4px;
				margin-top: 28px;
			}

			.page-btn {
				width: 26px;
				height: 26px;
				display: flex;
				align-items: center;
				justify-content: center;
				border: 1px solid var(--border);
				border-radius: 4px;
				font-size: 11px;
				color: var(--text-mid);
				cursor: pointer;
				background: var(--white);
				transition: all 0.15s;
			}

			.page-btn:hover {
				border-color: var(--orange);
				color: var(--orange);
			}

			.page-btn.active {
				background: var(--orange);
				border-color: var(--orange);
				color: #fff;
				font-weight: 700;
			}

			.page-btn.arrow {
				font-size: 12px;
				color: var(--text-light);
			}

			/* ── FOOTER ── */
			footer {
				background: var(--cream-dark);
				border-top: 1px solid var(--border);
				padding: 28px 28px 14px;
				margin-top: 0;
			}

			.footer-inner {
				display: flex;
				gap: 24px;
				margin-bottom: 20px;
			}

			.f-brand {
				flex: 1.6;
			}

			.f-brand-name {
				display: flex;
				align-items: center;
				gap: 6px;
				font-size: 13px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 7px;
			}

			.f-brand-icon {
				width: 24px;
				height: 24px;
				background: var(--orange);
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
				color: #fff;
				font-size: 10px;
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
				margin-bottom: 8px;
			}

			.f-nav ul {
				list-style: none;
			}

			.f-nav li {
				margin-bottom: 5px;
			}

			.f-nav a {
				font-size: 10px;
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
				margin-bottom: 8px;
			}

			.f-phone {
				font-size: 18px;
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
				font-size: 9px;
			}

			.footer-bottom {
				border-top: 1px solid var(--border);
				padding-top: 12px;
				display: flex;
				justify-content: space-between;
				font-size: 9px;
				color: var(--text-light);
			}

			.footer-bottom a {
				color: var(--text-light);
				text-decoration: none;
				margin-left: 10px;
			}

			.footer-bottom a:hover {
				color: var(--orange);
			}
		</style>
	</head>

	<body>
		<div class="browser-wrap">
			<div class="page">

				<!-- Header -->
				<%@ include file="/WEB-INF/common/header.jsp" %>

					<!-- BREADCRUMB -->
					<div class="breadcrumb-bar">
						<a href="#">홈</a>
						<span>›</span>
						<a href="#">고객센터</a>
						<span>›</span>
						<span class="current">공지사항</span>
					</div>

					<!-- CONTENT -->
					<div class="content">
						<div class="page-title">공지사항</div>
						<div class="page-desc">서비스 관련 안내 및 업데이트 소식을 확인하세요.</div>

						<!-- CATEGORY TABS -->
						<div class="cat-tabs">
							<div class="cat-tab active">전체</div>
							<div class="cat-tab">서비스 소식</div>
							<div class="cat-tab">사이트 점검</div>
							<div class="cat-tab">이벤트</div>
							<div class="cat-tab">환경설정</div>
						</div>

						<!-- SEARCH -->
						<div class="search-bar">
							<div class="search-input-wrap">
								<input type="text" placeholder="검색어를 입력하세요">
								<button class="search-btn">🔍</button>
							</div>
							<button class="search-type-btn">목록순</button>
						</div>

						<div class="total-count">총 <strong>42</strong>건</div>

						<!-- TABLE -->
						<table class="notice-table">
							<thead>
								<tr>
									<th class="num-cell">번호</th>
									<th class="left">제목</th>
									<th style="width:70px;">분류</th>
									<th style="width:80px;">등록일자</th>
									<th style="width:50px;">조회수</th>
								</tr>
							</thead>
							<tbody>
								<!-- pinned 1 -->
								<tr class="pinned">
									<td><span style="color:var(--orange);font-weight:700;font-size:11px;">공지</span></td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge notice">공지사항</span>
											<span class="title-text pinned">2024년 서비스 이용약관 개정 안내</span>
											<span class="new-dot"></span>
										</div>
									</td>
									<td>전체공지</td>
									<td>2024.03.25</td>
									<td>3,242</td>
								</tr>
								<!-- pinned 2 -->
								<tr class="pinned">
									<td><span style="color:var(--orange);font-weight:700;font-size:11px;">공지</span></td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge notice2">안내</span>
											<span class="title-text pinned">모닥모닥 개인정보처리방침 변경 안내 (2024.04.01 시행)</span>
											<span class="new-dot"></span>
										</div>
									</td>
									<td>전체공지</td>
									<td>2024.03.20</td>
									<td>2,965</td>
								</tr>
								<!-- normal rows -->
								<tr>
									<td>45</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge update">업데이트</span>
											<span class="title-text">정기 점검 서버 점검 안내(2024/7/22 02:00 ~ 06:00)</span>
										</div>
									</td>
									<td>사이트 점검</td>
									<td>2024/7/18</td>
									<td>836</td>
								</tr>
								<tr>
									<td>44</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge event">이벤트</span>
											<span class="title-text">봄 시즌 특가 이벤트 — 카테고리별, 10% 이상 할인...</span>
										</div>
									</td>
									<td>서비스 소식</td>
									<td>2024.04.18</td>
									<td>4,423</td>
								</tr>
								<tr>
									<td>43</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge notice">공지</span>
											<span class="title-text">업로드 기능 향상 및 신규 필터 적용 안내</span>
										</div>
									</td>
									<td>서비스 소식</td>
									<td>2024.04.11</td>
									<td>4,914</td>
								</tr>
								<tr>
									<td>42</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge gray">일반</span>
											<span class="title-text">앱 버전 업데이트 5.2.1 배포 안내</span>
										</div>
									</td>
									<td>서비스 소식</td>
									<td>2024.03.18</td>
									<td>2,157</td>
								</tr>
								<tr>
									<td>41</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge update">업데이트</span>
											<span class="title-text">결제 서비스 오류 해결 완료 및 안내 사항</span>
										</div>
									</td>
									<td>사이트 점검</td>
									<td>2024.03.05</td>
									<td>3,860</td>
								</tr>
								<tr>
									<td>40</td>
									<td class="title-cell">
										<div class="badge-wrap">
											<span class="n-badge gray">일반</span>
											<span class="title-text">환불 규정 안내 (2024.03.15 ~ 2024.03.31 기준)</span>
										</div>
									</td>
									<td>정책 변경</td>
									<td>2024.03.01</td>
									<td>2,580</td>
								</tr>
							</tbody>
						</table>

						<!-- PAGINATION -->
						<div class="pagination">
							<div class="page-btn arrow">«</div>
							<div class="page-btn arrow">‹</div>
							<div class="page-btn active">1</div>
							<div class="page-btn">2</div>
							<div class="page-btn">3</div>
							<div class="page-btn">4</div>
							<div class="page-btn">5</div>
							<div class="page-btn arrow">›</div>
							<div class="page-btn arrow">»</div>
						</div>
					</div>

					<!-- Footer -->
					<%@ include file="/WEB-INF/common/footer.jsp" %>


			</div><!-- /page -->
		</div><!-- /browser-wrap -->

		<script>
			// Category tabs
			document.querySelectorAll('.cat-tab').forEach(t => {
				t.addEventListener('click', function () {
					document.querySelectorAll('.cat-tab').forEach(x => x.classList.remove('active'));
					this.classList.add('active');
				});
			});
			// Pagination
			document.querySelectorAll('.page-btn:not(.arrow)').forEach(b => {
				b.addEventListener('click', function () {
					document.querySelectorAll('.page-btn:not(.arrow)').forEach(x => x.classList.remove('active'));
					this.classList.add('active');
				});
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
						url: "http://localhost:8080/notification/list.dox",
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