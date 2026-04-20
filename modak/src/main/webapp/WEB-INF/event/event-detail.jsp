<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>첫 캠핑 시작을 위한 '모다기'의 선물 - 모닥모닥</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
			rel="stylesheet">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
				--accent: #b85c1a;
				--text-primary: #2c1f0e;
				--text-secondary: #7a6a55;
				--text-muted: #a89880;
				--border: #e8dfd0;
				--card-bg: #f5f0e8;
			}

			body {
				font-family: 'GgiBatang', sans-serif;
				background: var(--bg);
				color: var(--text-primary);
				min-height: 100vh;
			}

			/* ── Hero Section ── */
			.hero {
				background: #eaf4fb;
				border-bottom: 1px solid #c9e2f0;
				padding: 28px 20px 32px;
				text-align: center;
			}

			.hero-badge {
				display: inline-block;
				background: var(--accent);
				color: #fff;
				font-size: 11px;
				font-weight: 600;
				padding: 4px 12px;
				border-radius: 20px;
				margin-bottom: 16px;
				letter-spacing: 0.3px;
			}

			.hero-title {
				font-size: 26px;
				font-weight: 700;
				color: var(--text-primary);
				letter-spacing: -0.5px;
				margin-bottom: 16px;
				line-height: 1.4;
			}

			.hero-meta {
				display: flex;
				justify-content: center;
				align-items: center;
				gap: 20px;
				font-size: 13px;
				color: var(--text-secondary);
			}

			.hero-meta span {
				display: flex;
				align-items: center;
				gap: 5px;
			}

			/* ── Content Wrapper ── */
			.content-wrap {
				max-width: 700px;
				margin: 0 auto;
				padding: 36px 20px 60px;
			}

			/* ── Banner Image ── */
			.event-banner {
				width: 100%;
				aspect-ratio: 3/1;
				background: #e8e0d5;
				border-radius: 12px;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 13px;
				color: var(--text-muted);
				margin-bottom: 30px;
				overflow: hidden;
				position: relative;
			}

			.event-banner img {
				width: 100%;
				height: 100%;
				object-fit: cover;
			}

			/* ── Body Text ── */
			.event-body {
				font-size: 14px;
				color: var(--text-secondary);
				line-height: 1.85;
				margin-bottom: 28px;
			}

			.event-body p+p {
				margin-top: 10px;
			}

			/* ── Coupon Box ── */
			.coupon-box {
				border: 1.5px dashed #c8a882;
				border-radius: 12px;
				background: #fffaf4;
				padding: 28px 24px;
				text-align: center;
				margin-bottom: 28px;
			}

			.coupon-box .coupon-title {
				font-size: 17px;
				font-weight: 700;
				color: var(--accent);
				margin-bottom: 10px;
				letter-spacing: -0.3px;
			}

			.coupon-box .coupon-desc {
				font-size: 13px;
				color: var(--text-secondary);
				margin-bottom: 20px;
				line-height: 1.7;
			}

			.btn-coupon {
				display: inline-flex;
				align-items: center;
				gap: 8px;
				background: var(--accent);
				color: #fff;
				font-size: 14px;
				font-weight: 600;
				padding: 12px 28px;
				border-radius: 8px;
				border: none;
				cursor: pointer;
				font-family: 'GgiBatang', sans-serif;
				letter-spacing: -0.2px;
				transition: background .2s, transform .15s;
			}

			.btn-coupon:hover {
				background: #9e4e15;
				transform: translateY(-1px);
			}

			.btn-coupon:active {
				transform: translateY(0);
			}

			/* ── Notice Text ── */
			.event-notice-text {
				font-size: 13px;
				color: var(--text-secondary);
				line-height: 1.8;
				margin-bottom: 24px;
			}

			/* ── Notice Box ── */
			.notice-box {
				background: var(--card-bg);
				border-radius: 10px;
				padding: 20px 22px;
				margin-bottom: 40px;
			}

			.notice-box h4 {
				font-size: 14px;
				font-weight: 600;
				color: var(--text-primary);
				margin-bottom: 12px;
			}

			.notice-box ul {
				list-style: none;
				display: flex;
				flex-direction: column;
				gap: 7px;
			}

			.notice-box ul li {
				font-size: 13px;
				color: var(--text-secondary);
				line-height: 1.6;
				padding-left: 14px;
				position: relative;
			}

			.notice-box ul li::before {
				content: '·';
				position: absolute;
				left: 2px;
				color: var(--accent);
				font-weight: 700;
			}

			/* ── Back Button ── */
			.back-wrap {
				text-align: center;
				padding: 20px 0 40px;
				border-top: 1px solid var(--border);
			}

			.btn-back {
				display: inline-flex;
				align-items: center;
				gap: 6px;
				background: #fff;
				border: 1px solid var(--border);
				color: var(--text-secondary);
				font-size: 13px;
				font-weight: 500;
				padding: 10px 24px;
				border-radius: 8px;
				cursor: pointer;
				font-family: 'GgiBatang', sans-serif;
				transition: all .2s;
				text-decoration: none;
			}

			.btn-back:hover {
				border-color: var(--accent);
				color: var(--accent);
			}

			/* ── Footer placeholder ── */
			.footer-placeholder {
				background: var(--card-bg);
				border-top: 1px solid var(--border);
				padding: 20px 40px;
				font-size: 12px;
				color: var(--text-muted);
				display: flex;
				justify-content: space-between;
				align-items: center;
			}
		</style>
	</head>

	<body>

		<!-- Header -->
				<%@ include file="/WEB-INF/common/header.jsp" %>

			<!-- Hero -->
			<section class="hero">
				<div class="hero-badge">진행중인 이벤트</div>
				<h1 class="hero-title">🔥 첫 캠핑 시작을 위한 '모다기'의 선물</h1>
				<div class="hero-meta">
					<span><i class="fa-solid fa-campground" style="color:#b85c1a;"></i> 기간: 2026.04.01 ~
						2026.05.31</span>
					<span><i class="fa-regular fa-eye" style="color:#a89880;"></i> 조회수: 1,240</span>
				</div>
			</section>

			<!-- Content -->
			<div class="content-wrap">

				<!-- Banner Image -->
				<div class="event-banner">
					<span>이벤트 메인 배너 이미지 영역 (1200x400)</span>
				</div>

				<!-- Body Text -->
				<div class="event-body">
					<p>안녕하세요 캠핑 머러분, 모닥모닥입니다!</p>
					<p>드디어 캠핑의 계절 봄이 찾아왔습니다. 처음 캠핑을 시작하시는 분들의 부담을 덜어드리고자 '모다기'로 특별한 혜택을 준비했습니다.</p>
				</div>

				<!-- Coupon Box -->
				<div class="coupon-box">
					<div class="coupon-title">신규 회원 대여 20% 할인 쿠폰</div>
					<div class="coupon-desc">모든 대여 상품에 사용 가능한 쿠폰을 지금 바로 다운로드 하세요!</div>
					<button class="btn-coupon">
						쿠폰 다운로드 받기 <i class="fa-solid fa-download"></i>
					</button>
				</div>

				<!-- Notice Text -->
				<p class="event-notice-text">
					본 이벤트는 한정 수량으로 진행되며, 조기 종료될 수 있습니다. 지금 바로 장바구니에 담아둔 텐트를 확인해보세요!
				</p>

				<!-- Notice Box -->
				<div class="notice-box">
					<h4>유의사항</h4>
					<ul>
						<li>쿠폰은 마이페이지 대여에 발급 가능합니다.</li>
						<li>이 이벤트 및 쿠폰은 중복 사용이 불가합니다.</li>
						<li>대여 기간이 최소 2일 이상인 경우에만 적용됩니다.</li>
					</ul>
				</div>

				<!-- Back Button -->
				<div class="back-wrap">
					<a href="/event/list.do" class="btn-back">
						<i class="fa-solid fa-chevron-left"></i>
						목록으로 돌아가기
					</a>
				</div>

			</div>

			<!-- Footer -->
						<%@ include file="/WEB-INF/common/footer.jsp" %>

	</body>

	</html>



	<script>
		const app = Vue.createApp({
			data() {
				return {
					eventId: "${map.eventId}",
					info: {}
				};
			},
			methods: {
				// 함수(메소드) - (key : function())

				fnGetInfo: function () {
					let self = this;
					let param = {
						eventId: self.eventId
					};
					$.ajax({
						url: "http://localhost:8080/event/detail.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							console.log(data);
							self.info = data.info;
						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnGetInfo();
			}
		});

		app.mount('#app');
	</script>