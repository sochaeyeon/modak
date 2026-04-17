<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>404 - 불씨를 찾을 수 없어요</title>
		<style>
			@font-face {
				font-family: 'SeoulHangang';
				src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/SeoulHangangM.woff') format('woff');
				font-weight: normal;
				font-display: swap;
			}
		</style>
		<style>
			*,
			*::before,
			*::after {
				margin: 0;
				padding: 0;
				box-sizing: border-box;
			}

			body {
				min-height: 100vh;
				background: #f7f3ee;
				display: flex;
				align-items: center;
				justify-content: center;
				font-family: 'SeoulHangang', sans-serif;
				overflow: hidden;
				position: relative;
			}

			/* Subtle warm vignette at bottom */
			body::before {
				content: '';
				position: fixed;
				bottom: -60px;
				left: 50%;
				transform: translateX(-50%);
				width: 700px;
				height: 360px;
				background: radial-gradient(ellipse at center bottom, rgba(200, 100, 20, 0.10) 0%, rgba(160, 70, 10, 0.05) 50%, transparent 70%);
				pointer-events: none;
			}

			/* Smoke wisps */
			.smoke-container {
				position: fixed;
				bottom: 48%;
				left: 50%;
				transform: translateX(-50%);
				width: 80px;
				pointer-events: none;
				z-index: 1;
			}

			.smoke {
				position: absolute;
				bottom: 0;
				border-radius: 50%;
				background: radial-gradient(circle, rgba(180, 150, 110, 0.22) 0%, transparent 70%);
				animation: smokeRise linear infinite;
			}

			.smoke:nth-child(1) {
				width: 30px;
				height: 30px;
				left: 25px;
				animation-duration: 5s;
				animation-delay: 0s;
			}

			.smoke:nth-child(2) {
				width: 40px;
				height: 40px;
				left: 10px;
				animation-duration: 6s;
				animation-delay: 1.5s;
			}

			.smoke:nth-child(3) {
				width: 25px;
				height: 25px;
				left: 35px;
				animation-duration: 4.5s;
				animation-delay: 3s;
			}

			@keyframes smokeRise {
				0% {
					transform: translateY(0) scale(1);
					opacity: 0;
				}

				10% {
					opacity: 0.6;
				}

				80% {
					opacity: 0.15;
				}

				100% {
					transform: translateY(-260px) scale(4);
					opacity: 0;
				}
			}

			/* ── CAMPFIRE ── */
			.campfire-wrap {
				position: fixed;
				bottom: 40px;
				left: 50%;
				transform: translateX(-50%);
				width: 200px;
				display: flex;
				flex-direction: column;
				align-items: center;
				z-index: 2;
			}

			.logs {
				width: 140px;
				height: 22px;
				position: relative;
				z-index: 3;
			}

			.log {
				position: absolute;
				height: 14px;
				border-radius: 7px;
				background: linear-gradient(to bottom, #5a3010, #2e1608);
			}

			.log::after {
				content: '';
				position: absolute;
				inset: 2px 8px;
				border-radius: 5px;
				background: linear-gradient(to bottom, #7a4520 0%, transparent 100%);
			}

			.log-1 {
				width: 120px;
				left: 10px;
				top: 8px;
				transform: rotate(-10deg);
			}

			.log-2 {
				width: 110px;
				left: 15px;
				top: 6px;
				transform: rotate(12deg);
			}

			.log-3 {
				width: 90px;
				left: 25px;
				top: 2px;
				transform: rotate(-3deg);
				background: linear-gradient(to bottom, #3d1e09, #1a0905);
			}

			/* Ember glow on logs */
			.ember-glow {
				position: absolute;
				bottom: 3px;
				left: 30px;
				width: 80px;
				height: 10px;
				border-radius: 50%;
				background: radial-gradient(ellipse, rgba(255, 120, 10, 0.6) 0%, rgba(200, 60, 0, 0.3) 50%, transparent 70%);
				animation: emberPulse 1.8s ease-in-out infinite alternate;
			}

			@keyframes emberPulse {
				from {
					opacity: 0.7;
					transform: scaleX(1);
				}

				to {
					opacity: 1;
					transform: scaleX(1.1);
				}
			}

			.flames {
				position: relative;
				width: 100px;
				height: 80px;
				margin-bottom: -8px;
				z-index: 2;
			}

			.flame {
				position: absolute;
				bottom: 0;
				border-radius: 50% 50% 35% 35%;
				transform-origin: bottom center;
				animation: flicker ease-in-out infinite alternate;
			}

			.flame-outer {
				width: 90px;
				height: 70px;
				left: 5px;
				background: radial-gradient(ellipse at 50% 85%, #ff6b00 0%, #e84800 30%, #c43000 60%, transparent 100%);
				animation-duration: 0.9s;
				opacity: 0.85;
			}

			.flame-mid {
				width: 65px;
				height: 55px;
				left: 17px;
				background: radial-gradient(ellipse at 50% 85%, #ffaa00 0%, #ff7800 40%, #e84800 70%, transparent 100%);
				animation-duration: 0.7s;
				animation-delay: 0.1s;
			}

			.flame-inner {
				width: 40px;
				height: 38px;
				left: 30px;
				background: radial-gradient(ellipse at 50% 85%, #fff0a0 0%, #ffcc00 30%, #ffaa00 60%, transparent 100%);
				animation-duration: 0.55s;
				animation-delay: 0.2s;
			}

			.flame-core {
				width: 18px;
				height: 22px;
				left: 41px;
				background: radial-gradient(ellipse at 50% 80%, #fffde0 0%, #fff5b0 50%, transparent 100%);
				animation-duration: 0.45s;
				animation-delay: 0.05s;
			}

			@keyframes flicker {
				0% {
					transform: scaleX(1) scaleY(1) rotate(-1deg);
				}

				25% {
					transform: scaleX(1.03) scaleY(0.97) rotate(0.5deg);
				}

				50% {
					transform: scaleX(0.97) scaleY(1.03) rotate(-0.5deg);
				}

				75% {
					transform: scaleX(1.02) scaleY(0.98) rotate(1deg);
				}

				100% {
					transform: scaleX(0.99) scaleY(1.02) rotate(-1.5deg);
				}
			}

			/* Floating embers */
			.embers {
				position: fixed;
				bottom: 120px;
				left: 50%;
				transform: translateX(-50%);
				width: 300px;
				height: 400px;
				pointer-events: none;
				z-index: 1;
			}

			.ember {
				position: absolute;
				border-radius: 50%;
				animation: emberFloat linear infinite;
			}

			@keyframes emberFloat {
				0% {
					transform: translateY(0) translateX(0) scale(1);
					opacity: 1;
				}

				70% {
					opacity: 0.8;
				}

				100% {
					transform: translateY(-380px) translateX(var(--dx)) scale(0.2);
					opacity: 0;
				}
			}

			/* Ground stones */
			.stones {
				display: flex;
				gap: 6px;
				justify-content: center;
				z-index: 3;
				position: relative;
			}

			.stone {
				border-radius: 50% 55% 45% 50%;
				background: linear-gradient(135deg, #4a3822 0%, #2a1e10 100%);
			}

			.stone-1 {
				width: 38px;
				height: 18px;
				transform: rotate(-8deg);
			}

			.stone-2 {
				width: 30px;
				height: 15px;
				transform: rotate(4deg) translateY(2px);
			}

			.stone-3 {
				width: 34px;
				height: 16px;
				transform: rotate(10deg);
			}

			.stone-4 {
				width: 28px;
				height: 14px;
				transform: rotate(-5deg) translateY(1px);
			}

			.stone-5 {
				width: 36px;
				height: 17px;
				transform: rotate(7deg);
			}

			/* Ground shadow */
			.ground-shadow {
				width: 160px;
				height: 16px;
				background: radial-gradient(ellipse, rgba(0, 0, 0, 0.12) 0%, transparent 70%);
				border-radius: 50%;
				margin-top: 4px;
			}

			/* ── CONTENT ── */
			.content {
				position: relative;
				z-index: 10;
				text-align: center;
				margin-bottom: 240px;
			}

			.error-number {
				font-family: 'SeoulHangang', sans-serif;
				font-weight: 900;
				font-size: clamp(80px, 12vw, 140px);
				line-height: 1;
				color: transparent;
				background: linear-gradient(160deg, #d94f00 0%, #b83000 40%, #8f1e00 80%, #5a0e00 100%);
				-webkit-background-clip: text;
				background-clip: text;
				letter-spacing: -4px;
				filter: drop-shadow(0 2px 16px rgba(180, 60, 0, 0.18));
				animation: numberGlow 2.5s ease-in-out infinite alternate;
			}

			@keyframes numberGlow {
				from {
					filter: drop-shadow(0 2px 12px rgba(180, 60, 0, 0.12));
				}

				to {
					filter: drop-shadow(0 2px 24px rgba(200, 70, 0, 0.28));
				}
			}

			.title {
				font-family: 'SeoulHangang', sans-serif;
				font-weight: 700;
				font-size: clamp(20px, 3vw, 28px);
				color: #a03a10;
				margin-top: 8px;
				letter-spacing: 0.02em;
			}

			.subtitle {
				font-weight: 300;
				font-size: clamp(13px, 1.6vw, 16px);
				color: #9a7a60;
				margin-top: 16px;
				letter-spacing: 0.04em;
				line-height: 1.9;
			}

			.divider {
				width: 48px;
				height: 1px;
				background: linear-gradient(to right, transparent, #c87840, transparent);
				margin: 24px auto;
			}

			.btn {
				display: inline-flex;
				align-items: center;
				gap: 8px;
				margin-top: 8px;
				padding: 14px 32px;
				border: 1.5px solid rgba(160, 60, 10, 0.35);
				border-radius: 3px;
				background: transparent;
				color: #a03a10;
				font-family: 'SeoulHangang', sans-serif;
				font-size: 14px;
				font-weight: 400;
				letter-spacing: 0.08em;
				cursor: pointer;
				transition: all 0.3s ease;
				text-decoration: none;
				position: relative;
				overflow: hidden;
			}

			.btn::before {
				content: '';
				position: absolute;
				inset: 0;
				background: linear-gradient(135deg, rgba(180, 70, 10, 0.08), rgba(220, 100, 0, 0.05));
				opacity: 0;
				transition: opacity 0.3s;
			}

			.btn:hover {
				border-color: rgba(200, 80, 20, 0.7);
				color: #7a2800;
				box-shadow: 0 2px 16px rgba(160, 60, 10, 0.12), inset 0 0 10px rgba(180, 70, 10, 0.05);
				transform: translateY(-1px);
			}

			.btn:hover::before {
				opacity: 1;
			}

			.btn-icon {
				font-size: 16px;
				animation: matchFlicker 1.5s ease-in-out infinite alternate;
			}

			@keyframes matchFlicker {
				from {
					opacity: 0.8;
					transform: scale(1);
				}

				to {
					opacity: 1;
					transform: scale(1.2) rotate(5deg);
				}
			}

			/* Ash particles (very subtle) */
			.ash {
				position: fixed;
				width: 3px;
				height: 3px;
				border-radius: 50%;
				background: rgba(140, 110, 80, 0.3);
				animation: ashDrift linear infinite;
				pointer-events: none;
				z-index: 1;
			}

			@keyframes ashDrift {
				0% {
					transform: translateY(0) translateX(0) rotate(0deg);
					opacity: 0.5;
				}

				50% {
					transform: translateY(-200px) translateX(var(--ax)) rotate(180deg);
					opacity: 0.3;
				}

				100% {
					transform: translateY(-420px) translateX(calc(var(--ax) * 1.5)) rotate(360deg);
					opacity: 0;
				}
			}
		</style>
	</head>

	<body>

		<!-- Smoke -->
		<div class="smoke-container">
			<div class="smoke"></div>
			<div class="smoke"></div>
			<div class="smoke"></div>
		</div>

		<!-- Floating embers (generated by JS) -->
		<div class="embers" id="embers"></div>

		<!-- Main text -->
		<div class="content">
			<div class="error-number">404</div>
			<div class="title">불씨를 찾을 수 없어요</div>
			<div class="divider"></div>
			<div class="subtitle">
				찾으시는 페이지가 꺼진 모닥불처럼 사라졌어요.<br>
				재가 된 링크일지도 모르니, 주소를 다시 확인해보세요.
			</div>
			<br>
			<a class="btn" href="/main.do">
				<span class="btn-icon">🔥</span>
				홈으로 돌아가기
			</a>
		</div>

		<!-- Campfire -->
		<div class="campfire-wrap">
			<div class="flames">
				<div class="flame flame-outer"></div>
				<div class="flame flame-mid"></div>
				<div class="flame flame-inner"></div>
				<div class="flame flame-core"></div>
			</div>
			<div class="logs">
				<div class="log log-3"></div>
				<div class="log log-1"></div>
				<div class="log log-2"></div>
				<div class="ember-glow"></div>
			</div>
			<div class="stones">
				<div class="stone stone-1"></div>
				<div class="stone stone-2"></div>
				<div class="stone stone-3"></div>
				<div class="stone stone-4"></div>
				<div class="stone stone-5"></div>
			</div>
			<div class="ground-shadow"></div>
		</div>

		<script>
			const emberContainer = document.getElementById('embers');
			const emberColors = [
				'rgba(255,120,20,0.9)',
				'rgba(255,80,0,0.85)',
				'rgba(255,180,30,0.8)',
				'rgba(220,60,0,0.75)',
				'rgba(255,140,40,0.7)',
			];

			function createEmber() {
				const el = document.createElement('div');
				el.className = 'ember';
				const size = Math.random() * 4 + 1.5;
				const left = Math.random() * 160 + 70;
				const duration = Math.random() * 3 + 2.5;
				const delay = Math.random() * 3;
				const dx = (Math.random() - 0.5) * 120;
				const color = emberColors[Math.floor(Math.random() * emberColors.length)];

				el.style.cssText = `
      width:${size}px; height:${size}px;
      left:${left}px; bottom:0;
      background:${color};
      box-shadow: 0 0 ${size * 2}px ${color};
      --dx:${dx}px;
      animation-duration:${duration}s;
      animation-delay:${delay}s;
    `;
				emberContainer.appendChild(el);
				setTimeout(() => el.remove(), (duration + delay) * 1000);
			}

			setInterval(createEmber, 220);
			for (let i = 0; i < 12; i++) setTimeout(createEmber, i * 180);

			// Ash particles
			const ashDxValues = [-60, -30, 40, 20, -50, 55, -15, 35];
			ashDxValues.forEach((ax, i) => {
				const ash = document.createElement('div');
				ash.className = 'ash';
				ash.style.cssText = `
      left:${44 + Math.random() * 12}%;
      bottom:${120 + Math.random() * 60}px;
      --ax:${ax}px;
      animation-duration:${7 + i * 0.8}s;
      animation-delay:${i * 1.1}s;
      width:${Math.random() * 2 + 2}px;
      height:${Math.random() * 2 + 2}px;
    `;
				document.body.appendChild(ash);
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
				fnError: function () {
					let self = this;
					$.ajax({
						url: "http://localhost:8080/error.dox",
						dataType: "json",
						type: "POST",
						data: {}, // Sending empty object if no params needed
						success: function (data) {
							console.log("Server Response:", data);
							self.message = data.message;
						},
						error: function (err) {
							console.error("AJAX Error:", err);
						}
					});
				}
			},
			mounted() {
				this.fnError();
			}
		});
		app.mount('#app');
	</script>