<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>모닥모닥 고객센터 - Frame</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<style>
			:root {
				--cream: #f7f3ee;
				--cream-dark: #f0ebe3;
				--orange: #d4714a;
				--orange-light: #e8a07a;
				--orange-pale: #faf0eb;
				--text-dark: #3a3530;
				--text-mid: #7a7068;
				--text-light: #b0a89e;
				--border: #e8e0d8;
				--white: #ffffff;
			}

			* {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			body {
				font-family: 'GgiBatang', sans-serif;
				background: var(--cream);
				color: var(--text-dark);
				font-size: 12px;
				line-height: 1.7;
			}

			/* ── HEADER ── */
			.top-bar {
				background: var(--white);
				border-bottom: 1px solid var(--border);
				padding: 0 32px;
				display: flex;
				align-items: center;
				justify-content: space-between;
				height: 44px;
			}

			.logo {
				font-size: 17px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: -0.5px;
			}

			.logo span {
				color: var(--orange);
			}

			.top-right {
				display: flex;
				align-items: center;
				gap: 16px;
				font-size: 11px;
				color: var(--text-mid);
			}

			.top-right a {
				color: var(--text-mid);
				text-decoration: none;
			}

			.top-right a:hover {
				color: var(--orange);
			}

			.nav-bar {
				background: var(--white);
				border-bottom: 1px solid var(--border);
				display: flex;
				align-items: center;
				justify-content: space-between;
				padding: 0 32px;
				height: 40px;
			}

			.nav-left {
				display: flex;
				align-items: center;
				gap: 20px;
			}

			.nav-left a {
				font-size: 11px;
				color: var(--text-mid);
				text-decoration: none;
			}

			.nav-left a:hover {
				color: var(--orange);
			}

			.nav-center {
				font-size: 14px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: 2px;
			}

			.nav-right {
				font-size: 11px;
				color: var(--text-mid);
				display: flex;
				gap: 12px;
			}

			.nav-right a {
				color: var(--text-mid);
				text-decoration: none;
			}

			.nav-right a:hover {
				color: var(--orange);
			}

			/* ── HERO ── */
			.hero {
				background: var(--cream-dark);
				padding: 36px 32px 28px;
				text-align: center;
				position: relative;
				overflow: hidden;
			}

			.hero::before {
				content: '';
				position: absolute;
				top: 0;
				left: 0;
				right: 0;
				bottom: 0;
				background: radial-gradient(ellipse at 50% 0%, rgba(212, 113, 74, 0.06) 0%, transparent 70%);
				pointer-events: none;
			}

			.hero-icon {
				font-size: 28px;
				margin-bottom: 10px;
				display: block;
			}

			.hero h1 {
				font-size: 17px;
				font-weight: 700;
				color: var(--orange);
				margin-bottom: 4px;
				letter-spacing: -0.3px;
			}

			.hero p {
				font-size: 17px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 16px;
				letter-spacing: -0.3px;
			}

			.hero-search-wrap {
				display: flex;
				align-items: center;
				max-width: 340px;
				margin: 0 auto 10px;
				background: var(--white);
				border: 1px solid var(--border);
				border-radius: 4px;
				overflow: hidden;
			}

			.hero-search-wrap input {
				flex: 1;
				border: none;
				outline: none;
				padding: 8px 12px;
				font-size: 11px;
				font-family: 'GgiBatang', sans-serif;
				background: transparent;
				color: var(--text-dark);
			}

			.hero-search-wrap input::placeholder {
				color: var(--text-light);
			}

			.hero-search-wrap button {
				background: none;
				border: none;
				padding: 0 12px;
				cursor: pointer;
				color: var(--text-light);
				font-size: 14px;
			}

			.hero-links {
				font-size: 10px;
				color: var(--text-light);
				display: flex;
				justify-content: center;
				gap: 12px;
				flex-wrap: wrap;
			}

			.hero-links a {
				color: var(--text-light);
				text-decoration: none;
			}

			.hero-links a:hover {
				color: var(--orange);
			}

			.hero-links span {
				color: var(--border);
			}

			/* ── MAIN ── */
			.main {
				max-width: 720px;
				margin: 0 auto;
				padding: 32px 24px 60px;
			}

			.sec-eyebrow {
				font-size: 9px;
				letter-spacing: 1.5px;
				text-transform: uppercase;
				color: var(--text-light);
				margin-bottom: 3px;
			}

			.sec-title {
				font-size: 16px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 16px;
				letter-spacing: -0.3px;
			}

			/* ── CATEGORY CARDS ── */
			.cat-section {
				margin-bottom: 16px;
			}

			.cat-grid {
				display: flex;
				gap: 8px;
			}

			.cat-card {
				flex: 1;
				background: var(--white);
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 16px 8px;
				text-align: center;
				cursor: pointer;
				transition: all 0.18s ease;
			}

			.cat-card:hover,
			.cat-card.active {
				border-color: var(--orange);
				background: var(--orange-pale);
			}

			.cat-card .ci {
				font-size: 18px;
				margin-bottom: 6px;
			}

			.cat-card .cn {
				font-size: 11px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 2px;
			}

			.cat-card .cd {
				font-size: 9px;
				color: var(--text-light);
			}

			/* ── NOTICE STRIP ── */
			.notice-strip {
				background: var(--orange-pale);
				border: 1px solid #f0d8cc;
				border-radius: 6px;
				padding: 10px 14px;
				display: flex;
				align-items: center;
				justify-content: space-between;
				margin-bottom: 40px;
				gap: 12px;
			}

			.notice-strip-left {
				display: flex;
				align-items: center;
				gap: 10px;
			}

			.ns-dot {
				width: 28px;
				height: 28px;
				background: var(--orange);
				border-radius: 50%;
				flex-shrink: 0;
				display: flex;
				align-items: center;
				justify-content: center;
				color: #fff;
				font-size: 11px;
				font-weight: 700;
			}

			.ns-text {
				font-size: 11px;
				color: var(--text-mid);
			}

			.ns-text strong {
				color: var(--text-dark);
			}

			.ns-btn {
				background: var(--orange);
				color: #fff;
				border: none;
				padding: 6px 14px;
				border-radius: 4px;
				font-size: 10px;
				cursor: pointer;
				white-space: nowrap;
				font-family: 'GgiBatang', sans-serif;
				letter-spacing: 0.3px;
			}

			/* ── FAQ ── */
			.faq-section {
				margin-bottom: 48px;
			}

			.faq-layout {
				display: flex;
				gap: 20px;
			}

			.faq-sidebar {
				width: 100px;
				flex-shrink: 0;
			}

			.faq-sidebar ul {
				list-style: none;
			}

			.faq-sidebar li {
				font-size: 11px;
				color: var(--text-light);
				padding: 5px 0;
				cursor: pointer;
				border-bottom: 1px solid transparent;
				transition: color 0.15s;
			}

			.faq-sidebar li:hover {
				color: var(--orange);
			}

			.faq-sidebar li.active {
				color: var(--orange);
				font-weight: 700;
			}

			.faq-main {
				flex: 1;
			}

			.faq-tabs {
				display: flex;
				gap: 0;
				border-bottom: 1.5px solid var(--border);
				margin-bottom: 2px;
			}

			.faq-tab {
				padding: 6px 12px;
				font-size: 11px;
				cursor: pointer;
				color: var(--text-light);
				border-bottom: 2px solid transparent;
				margin-bottom: -1.5px;
				transition: color 0.15s;
				white-space: nowrap;
			}

			.faq-tab.active {
				color: var(--orange);
				border-bottom-color: var(--orange);
				font-weight: 700;
			}

			.faq-item {
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding: 9px 2px;
				border-bottom: 1px solid #f0ebe3;
				cursor: pointer;
				font-size: 11px;
				color: var(--text-mid);
				transition: color 0.15s;
			}

			.faq-item:hover {
				color: var(--orange);
			}

			.faq-item .arr {
				color: var(--border);
				font-size: 12px;
			}

			/* ── CONSULT ── */
			.consult-section {
				margin-bottom: 48px;
			}

			.consult-layout {
				display: flex;
				gap: 16px;
				align-items: flex-start;
			}

			.consult-left {
				flex: 1;
				display: flex;
				flex-direction: column;
				gap: 10px;
			}

			.consult-card {
				background: var(--white);
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 14px 16px;
				display: flex;
				align-items: flex-start;
				gap: 12px;
				transition: box-shadow 0.18s;
			}

			.consult-card:hover {
				box-shadow: 0 2px 12px rgba(212, 113, 74, 0.10);
			}

			.c-avatar {
				width: 32px;
				height: 32px;
				border-radius: 50%;
				background: var(--orange);
				display: flex;
				align-items: center;
				justify-content: center;
				color: #fff;
				font-size: 11px;
				font-weight: 700;
				flex-shrink: 0;
			}

			.c-avatar.blue {
				background: #8aadcc;
			}

			.c-avatar.gray {
				background: #b8b0a8;
			}

			.c-info {
				flex: 1;
			}

			.c-name {
				font-size: 12px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 2px;
			}

			.c-desc {
				font-size: 10px;
				color: var(--text-light);
				line-height: 1.6;
				margin-bottom: 8px;
			}

			.c-btn {
				display: inline-block;
				background: var(--orange);
				color: #fff;
				border: none;
				padding: 5px 12px;
				border-radius: 4px;
				font-size: 10px;
				cursor: pointer;
				font-family: 'GgiBatang', sans-serif;
			}

			.c-btn.blue {
				background: #8aadcc;
			}

			.c-btn.gray {
				background: #b8b0a8;
			}

			/* FORM */
			.contact-form {
				width: 280px;
				flex-shrink: 0;
				background: var(--white);
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 18px;
			}

			.cf-title {
				font-size: 13px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 14px;
			}

			.cf-row {
				display: flex;
				gap: 8px;
				margin-bottom: 8px;
			}

			.cf-group {
				flex: 1;
				margin-bottom: 8px;
			}

			.cf-group label {
				display: block;
				font-size: 9px;
				color: var(--text-light);
				margin-bottom: 3px;
				letter-spacing: 0.3px;
			}

			.cf-group input,
			.cf-group select,
			.cf-group textarea {
				width: 100%;
				border: 1px solid var(--border);
				border-radius: 4px;
				padding: 6px 9px;
				font-size: 10px;
				font-family: 'GgiBatang', sans-serif;
				outline: none;
				color: var(--text-dark);
				background: #fff;
				transition: border-color 0.15s;
			}

			.cf-group input::placeholder,
			.cf-group textarea::placeholder {
				color: var(--text-light);
			}

			.cf-group input:focus,
			.cf-group select:focus,
			.cf-group textarea:focus {
				border-color: var(--orange-light);
			}

			.cf-group textarea {
				resize: vertical;
				min-height: 60px;
			}

			.cf-note {
				font-size: 9px;
				color: var(--text-light);
				line-height: 1.6;
				margin-bottom: 12px;
			}

			.cf-submit {
				width: 100%;
				background: var(--orange);
				color: #fff;
				border: none;
				padding: 9px;
				border-radius: 4px;
				font-size: 12px;
				font-weight: 700;
				cursor: pointer;
				font-family: 'GgiBatang', sans-serif;
				letter-spacing: 0.3px;
				transition: background 0.15s;
			}

			.cf-submit:hover {
				background: #c05e3a;
			}

			/* ── HOW TO USE ── */
			.howto-section {
				margin-bottom: 48px;
			}

			.howto-grid {
				display: flex;
				gap: 10px;
			}

			.howto-card {
				flex: 1;
				background: var(--white);
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 16px 12px;
			}

			.hw-num {
				font-size: 20px;
				font-weight: 900;
				color: var(--orange);
				opacity: 0.45;
				margin-bottom: 6px;
				letter-spacing: -1px;
			}

			.hw-title {
				font-size: 11px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 5px;
			}

			.hw-desc {
				font-size: 10px;
				color: var(--text-light);
				line-height: 1.6;
			}

			/* ── NOTICE LIST ── */
			.notice-section {
				margin-bottom: 48px;
			}

			.notice-header {
				display: flex;
				justify-content: space-between;
				align-items: flex-end;
				margin-bottom: 12px;
			}

			.notice-more {
				font-size: 10px;
				color: var(--text-light);
				text-decoration: none;
			}

			.notice-more:hover {
				color: var(--orange);
			}

			.n-row {
				display: flex;
				align-items: center;
				padding: 9px 0;
				border-bottom: 1px solid #f0ebe3;
				gap: 8px;
			}

			.n-badge {
				font-size: 9px;
				padding: 2px 7px;
				border-radius: 10px;
				background: var(--orange);
				color: #fff;
				flex-shrink: 0;
				letter-spacing: 0.3px;
			}

			.n-badge.gray {
				background: var(--text-light);
			}

			.n-badge.blue {
				background: #8aadcc;
			}

			.n-text {
				flex: 1;
				font-size: 11px;
				color: var(--text-mid);
				cursor: pointer;
			}

			.n-text:hover {
				color: var(--orange);
			}

			.n-date {
				font-size: 10px;
				color: var(--text-light);
				flex-shrink: 0;
			}

			/* ── FOOTER ── */
			footer {
				background: var(--white);
				border-top: 1px solid var(--border);
				padding: 28px 0 14px;
				margin-top: 20px;
			}

			.footer-inner {
				max-width: 720px;
				margin: 0 auto;
				padding: 0 24px;
				display: flex;
				gap: 24px;
			}

			.f-brand {
				flex: 1.6;
			}

			.f-brand-name {
				font-size: 14px;
				font-weight: 700;
				color: var(--text-dark);
				margin-bottom: 6px;
			}

			.f-brand-name span {
				color: var(--orange);
				font-size: 11px;
				margin-left: 4px;
			}

			.f-brand-desc {
				font-size: 9px;
				color: var(--text-light);
				line-height: 1.8;
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
				margin-bottom: 4px;
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
				letter-spacing: -0.5px;
				margin-bottom: 4px;
			}

			.f-hours {
				font-size: 9px;
				color: var(--text-light);
				line-height: 1.8;
			}

			.footer-bottom {
				max-width: 720px;
				margin: 16px auto 0;
				padding: 12px 24px 0;
				border-top: 1px solid var(--border);
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

			/* divider */
			.section-divider {
				height: 1px;
				background: var(--border);
				margin: 0 0 40px;
			}
		</style>
	</head>

	<body>

		<!-- Header -->
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<!-- HERO -->
			<div class="hero">
				<span class="hero-icon">🔥</span>
				<h1>모닥모닥 고객센터에</h1>
				<p>오신 것을 환영합니다</p>
				<div class="hero-search-wrap">
					<input type="text" placeholder="궁금한 것을 검색해보세요">
					<button>🔍</button>
				</div>
				<div class="hero-links">
					<a href="#">자주 묻는 질문</a>
					<span>|</span>
					<a href="#">공지사항</a>
					<span>|</span>
					<a href="#">1:1 문의</a>
					<span>|</span>
					<a href="/terms.do">이용약관</a>
					<span>|</span>
					<a href="/privacyPolicy.do">개인정보처리방침</a>
				</div>
			</div>

			<!-- MAIN -->
			<div class="main">

				<!-- CATEGORY -->
				<div class="cat-section">
					<div class="sec-eyebrow">HELP CENTER</div>
					<div class="sec-title">어떤 도움이 필요하세요?</div>
					<div class="cat-grid">
						<div class="cat-card">
							<div class="ci">🏠</div>
							<div class="cn">서비스 안내</div>
							<div class="cd">이용방법</div>
						</div>
						<div class="cat-card">
							<div class="ci">📧</div>
							<div class="cn">청구 / 요금</div>
							<div class="cd">결제 문의</div>
						</div>
						<div class="cat-card">
							<div class="ci">📋</div>
							<div class="cn">공지 / 이벤트</div>
							<div class="cd">최신 소식</div>
						</div>
						<div class="cat-card">
							<div class="ci">🔧</div>
							<div class="cn">계약 / 설정</div>
							<div class="cd">계정 관리</div>
						</div>
						<div class="cat-card">
							<div class="ci">👤</div>
							<div class="cn">회원 / 계정</div>
							<div class="cd">회원정보</div>
						</div>
					</div>
				</div>

				<!-- NOTICE STRIP -->
				<div class="notice-strip">
					<div class="notice-strip-left">
						<div class="ns-dot">!</div>
						<div class="ns-text">
							<strong>도움이 필요하신가요?</strong><br>
							전문 상담사가 빠르게 도와드리겠습니다. 평일 09:00 ~ 18:00 운영중입니다.
						</div>
					</div>
					<button class="ns-btn">상담 신청하기 →</button>
				</div>

				<!-- FAQ -->
				<div class="faq-section">
					<div class="sec-eyebrow">FAQ</div>
					<div class="sec-title">자주 묻는 질문</div>
					<div class="faq-layout">
						<div class="faq-sidebar">
							<ul>
								<li class="active">전체</li>
								<li>서비스 안내</li>
								<li>요금 / 결제</li>
								<li>회원 / 계정</li>
								<li>기타 문의</li>
							</ul>
						</div>
						<div class="faq-main">
							<div class="faq-tabs">
								<div class="faq-tab active">전체</div>
								<div class="faq-tab">서비스</div>
								<div class="faq-tab">요금</div>
								<div class="faq-tab">계정</div>
							</div>
							<div class="faq-item">서비스 이용 방법이 어떻게 되나요? <span class="arr">›</span></div>
							<div class="faq-item">비밀번호를 잊어버렸을 때 어떻게 하나요? <span class="arr">›</span></div>
							<div class="faq-item">요금제 변경은 어떻게 하나요? <span class="arr">›</span></div>
							<div class="faq-item">영수증 발급은 어떻게 하나요? <span class="arr">›</span></div>
							<div class="faq-item">회원 탈퇴 후 재가입이 가능한가요? <span class="arr">›</span></div>
							<div class="faq-item">환불 정책이 어떻게 되나요? <span class="arr">›</span></div>
							<div class="faq-item">결제 오류가 발생했을 때는 어떻게 하나요? <span class="arr">›</span></div>
							<div class="faq-item">서비스 이용 중 오류가 발생했을 때 대처 방법은? <span class="arr">›</span></div>
						</div>
					</div>
				</div>

				<div class="section-divider"></div>

				<!-- CONSULT -->
				<div class="consult-section">
					<div class="sec-eyebrow">CONTACT</div>
					<div class="sec-title">직접 문의하기</div>
					<div style="font-size:10px;color:var(--text-light);margin-bottom:14px;">평일 09:00 ~ 18:00 (주말/공휴일 제외)
					</div>
					<div class="consult-layout">
						<div class="consult-left">
							<div class="consult-card">
								<div class="c-avatar">전</div>
								<div class="c-info">
									<div class="c-name">전화 상담</div>
									<div class="c-desc">전화를 통해 빠르게 상담받으실 수 있습니다.<br>대기 시간이 발생할 수 있습니다.</div>
									<button class="c-btn">전화 연결</button>
								</div>
							</div>
							<div class="consult-card">
								<div class="c-avatar blue">채</div>
								<div class="c-info">
									<div class="c-name">채팅 상담</div>
									<div class="c-desc">실시간 채팅 상담이 가능합니다.<br>빠른 답변을 받아보실 수 있습니다.</div>
									<button class="c-btn blue">채팅 시작</button>
								</div>
							</div>
							<div class="consult-card">
								<div class="c-avatar gray">이</div>
								<div class="c-info">
									<div class="c-name">이메일 문의</div>
									<div class="c-desc">help@modakmodak.com으로 문의해주세요.<br>1~2 영업일 내 답변드립니다.</div>
									<button class="c-btn gray">이메일 보내기</button>
								</div>
							</div>
						</div>
						<div class="contact-form">
							<div class="cf-title">온라인 문의 접수</div>
							<div class="cf-row">
								<div class="cf-group" style="flex:1">
									<label>이름</label>
									<input type="text" placeholder="홍길동">
								</div>
								<div class="cf-group" style="flex:1.4">
									<label>이메일</label>
									<input type="email" placeholder="example@mail.com">
								</div>
							</div>
							<div class="cf-group">
								<label>연락처</label>
								<input type="text" placeholder="010-0000-0000">
							</div>
							<div class="cf-group">
								<label>문의 유형</label>
								<select>
									<option>선택해주세요</option>
									<option>서비스 이용</option>
									<option>결제 / 환불</option>
									<option>계정 / 회원</option>
									<option>기타</option>
								</select>
							</div>
							<div class="cf-group">
								<label>문의 내용</label>
								<textarea placeholder="문의하실 내용을 상세히 입력해주세요."></textarea>
							</div>
							<div class="cf-note">
								접수된 문의는 평일 영업시간 내에 순차적으로 답변드립니다. 문의가 많을 경우 다소 지연될 수 있습니다.
							</div>
							<button class="cf-submit">문의 접수하기</button>
						</div>
					</div>
				</div>

				<div class="section-divider"></div>

				<!-- HOW TO USE -->
				<div class="howto-section">
					<div class="sec-eyebrow">GUIDE</div>
					<div class="sec-title">서비스 이용 방법</div>
					<div class="howto-grid">
						<div class="howto-card">
							<div class="hw-num">01</div>
							<div class="hw-title">회원 가입</div>
							<div class="hw-desc">이메일 또는 소셜 계정으로 간편하게 회원가입 하세요.</div>
						</div>
						<div class="howto-card">
							<div class="hw-num">02</div>
							<div class="hw-title">요금제 선택</div>
							<div class="hw-desc">다양한 요금제 중 원하시는 플랜을 선택하세요.</div>
						</div>
						<div class="howto-card">
							<div class="hw-num">03</div>
							<div class="hw-title">No.1 선택</div>
							<div class="hw-desc">결제 수단 등록 후 원하는 서비스 옵션을 선택하세요.</div>
						</div>
						<div class="howto-card">
							<div class="hw-num">04</div>
							<div class="hw-title">이용 완료</div>
							<div class="hw-desc">모든 준비 완료! 지금 바로 서비스를 이용하실 수 있습니다.</div>
						</div>
					</div>
				</div>

				<div class="section-divider"></div>

				<!-- NOTICE LIST -->
				<div class="notice-section">
					<div class="notice-header">
						<div>
							<div class="sec-eyebrow">NOTICE</div>
							<div class="sec-title" style="margin-bottom:0">공지사항</div>
						</div>
						<a href="#" class="notice-more">더보기 →</a>
					</div>
					<div class="n-row">
						<span class="n-badge">공지</span>
						<span class="n-text">2024년 상반기 서비스 업데이트 안내 및 새로운 기능 추가 예정에 대해 안내드립니다</span>
						<span class="n-date">2024.03.15</span>
					</div>
					<div class="n-row">
						<span class="n-badge blue">이벤트</span>
						<span class="n-text">서비스 3주년 기념 특별 이벤트 - 요금제 50% 할인 프로모션 안내</span>
						<span class="n-date">2024.03.10</span>
					</div>
					<div class="n-row">
						<span class="n-badge gray">일반</span>
						<span class="n-text">정기 서버 점검 안내 (3월 20일 새벽 2시 ~ 4시)</span>
						<span class="n-date">2024.03.08</span>
					</div>
					<div class="n-row">
						<span class="n-badge gray">일반</span>
						<span class="n-text">개인정보처리방침 변경 안내 - 시행일: 2024년 4월 1일부터 적용</span>
						<span class="n-date">2024.03.05</span>
					</div>
				</div>

			</div><!-- /main -->

			<!-- Footer -->
			<%@ include file="/WEB-INF/common/footer.jsp" %>


				<script>
					// FAQ tab switch
					document.querySelectorAll('.faq-tab').forEach(t => {
						t.addEventListener('click', function () {
							document.querySelectorAll('.faq-tab').forEach(x => x.classList.remove('active'));
							this.classList.add('active');
						});
					});
					// FAQ sidebar
					document.querySelectorAll('.faq-sidebar li').forEach(li => {
						li.addEventListener('click', function () {
							document.querySelectorAll('.faq-sidebar li').forEach(x => x.classList.remove('active'));
							this.classList.add('active');
						});
					});
					// Category card
					document.querySelectorAll('.cat-card').forEach(c => {
						c.addEventListener('click', function () {
							document.querySelectorAll('.cat-card').forEach(x => x.classList.remove('active'));
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
					message: ""
				};
			},
			methods: {
				fnCs: function () {
					let self = this;
					$.ajax({
						url: "http://localhost:8080/cs/center.dox",
						dataType: "json",
						type: "POST",
						data: {}, // Sending empty object if no params needed
						success: function (data) {
							console.log("Server Response:", data);
							self.message = data.message;
						},
						cs: function (cs) {
							console.cs("AJAX Cs:", cs);
						}
					});
				}
			},
			mounted() {
				this.fnCs();
			}
		});
		app.mount('#app');
	</script>