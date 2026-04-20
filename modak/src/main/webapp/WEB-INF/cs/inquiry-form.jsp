<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>온라인 문의 접수 - 모닥모닥</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<style>
			:root {
				--cream: #f7f3ee;
				--cream-dark: #f0ebe3;
				--orange: #d4714a;
				--orange-hover: #c05e3a;
				--orange-pale: #fdf5f0;
				--text-dark: #3a3530;
				--text-mid: #7a7068;
				--text-light: #b0a89e;
				--border: #e8e0d8;
				--border-focus: #d4714a;
				--white: #ffffff;
				--error: #d9534f;
				--success: #5a9a72;
			}

			* {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			body {
				font-family: 'Noto Sans KR', sans-serif;
				background: var(--cream);
				min-height: 100vh;
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 32px 16px;
			}

			/* ── CARD ── */
			.form-card {
				background: var(--white);
				border-radius: 12px;
				box-shadow: 0 4px 24px rgba(58, 53, 48, 0.10);
				padding: 32px 28px 28px;
				width: 100%;
				max-width: 360px;
			}

			/* ── TITLE ── */
			.form-title {
				font-size: 18px;
				font-weight: 700;
				color: var(--text-dark);
				letter-spacing: -0.4px;
				margin-bottom: 24px;
			}

			/* ── FIELD GROUP ── */
			.field-row {
				display: flex;
				gap: 10px;
				margin-bottom: 14px;
			}

			.field-group {
				display: flex;
				flex-direction: column;
				gap: 5px;
				flex: 1;
				margin-bottom: 14px;
			}

			.field-row .field-group {
				margin-bottom: 0;
			}

			/* ── LABEL ── */
			.field-label {
				font-size: 11px;
				font-weight: 500;
				color: var(--text-mid);
				letter-spacing: 0.2px;
			}

			/* ── INPUTS ── */
			.field-input,
			.field-select,
			.field-textarea {
				width: 100%;
				border: 1px solid var(--border);
				border-radius: 6px;
				padding: 10px 12px;
				font-size: 12px;
				font-family: 'Noto Sans KR', sans-serif;
				color: var(--text-dark);
				background: var(--white);
				outline: none;
				transition: border-color 0.18s, box-shadow 0.18s;
				-webkit-appearance: none;
				appearance: none;
			}

			.field-input::placeholder,
			.field-textarea::placeholder {
				color: var(--text-light);
			}

			.field-input:focus,
			.field-select:focus,
			.field-textarea:focus {
				border-color: var(--border-focus);
				box-shadow: 0 0 0 3px rgba(212, 113, 74, 0.10);
			}

			/* ── SELECT ── */
			.select-wrap {
				position: relative;
			}

			.field-select {
				padding-right: 32px;
				cursor: pointer;
				background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23b0a89e' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
				background-repeat: no-repeat;
				background-position: right 12px center;
			}

			.field-select option {
				color: var(--text-dark);
			}

			.field-select option[value=""] {
				color: var(--text-light);
			}

			/* ── TEXTAREA ── */
			.field-textarea {
				resize: vertical;
				min-height: 100px;
				line-height: 1.7;
			}

			/* ── ERROR STATE ── */
			.field-group.has-error .field-input,
			.field-group.has-error .field-select,
			.field-group.has-error .field-textarea {
				border-color: var(--error);
				box-shadow: 0 0 0 3px rgba(217, 83, 79, 0.09);
			}

			.field-error {
				font-size: 10px;
				color: var(--error);
				display: none;
			}

			.field-group.has-error .field-error {
				display: block;
			}

			/* ── NOTE ── */
			.form-note {
				font-size: 10px;
				color: var(--text-light);
				line-height: 1.7;
				margin-bottom: 18px;
			}

			/* ── SUBMIT ── */
			.submit-btn {
				width: 100%;
				background: var(--orange);
				color: var(--white);
				border: none;
				border-radius: 8px;
				padding: 14px;
				font-size: 14px;
				font-weight: 700;
				font-family: 'Noto Sans KR', sans-serif;
				letter-spacing: 0.5px;
				cursor: pointer;
				transition: background 0.18s, transform 0.12s;
			}

			.submit-btn:hover {
				background: var(--orange-hover);
			}

			.submit-btn:active {
				transform: scale(0.98);
			}

			.submit-btn:disabled {
				background: var(--text-light);
				cursor: not-allowed;
				transform: none;
			}

			/* ── SUCCESS MESSAGE ── */
			.success-msg {
				display: none;
				background: #f0faf4;
				border: 1px solid #c4e8d0;
				border-radius: 6px;
				padding: 14px 16px;
				text-align: center;
				margin-bottom: 16px;
			}

			.success-msg .s-icon {
				font-size: 22px;
				margin-bottom: 6px;
			}

			.success-msg p {
				font-size: 12px;
				color: var(--success);
				font-weight: 500;
			}

			.success-msg small {
				font-size: 10px;
				color: var(--text-light);
			}
		</style>
	</head>

	<body>

		<div class="form-card">
			<div class="form-title">온라인 문의 접수</div>

			<!-- SUCCESS -->
			<div class="success-msg" id="successMsg">
				<div class="s-icon">✅</div>
				<p>문의가 접수되었습니다!</p>
				<small>영업일 기준 1~2일 내에 답변드리겠습니다.</small>
			</div>

			<form id="contactForm" novalidate>

				<!-- 이름 + 이메일 -->
				<div class="field-row">
					<div class="field-group" id="g-name">
						<label class="field-label" for="name">이름</label>
						<input class="field-input" type="text" id="name" name="name" placeholder="홍길동"
							autocomplete="name">
						<span class="field-error">이름을 입력해주세요.</span>
					</div>
					<div class="field-group" id="g-email">
						<label class="field-label" for="email">이메일</label>
						<input class="field-input" type="email" id="email" name="email" placeholder="example@mail.com"
							autocomplete="email">
						<span class="field-error">올바른 이메일을 입력해주세요.</span>
					</div>
				</div>

				<!-- 연락처 -->
				<div class="field-group" id="g-phone">
					<label class="field-label" for="phone">연락처</label>
					<input class="field-input" type="tel" id="phone" name="phone" placeholder="010-0000-0000"
						autocomplete="tel" maxlength="13">
					<span class="field-error">연락처를 입력해주세요.</span>
				</div>

				<!-- 문의 유형 -->
				<div class="field-group" id="g-type">
					<label class="field-label" for="type">문의 유형</label>
					<div class="select-wrap">
						<select class="field-select" id="type" name="type">
							<option value="">선택해주세요</option>
							<option value="service">서비스 이용</option>
							<option value="payment">결제 / 환불</option>
							<option value="account">계정 / 회원</option>
							<option value="coupon">쿠폰 / 포인트</option>
							<option value="etc">기타</option>
						</select>
					</div>
					<span class="field-error">문의 유형을 선택해주세요.</span>
				</div>

				<!-- 문의 내용 -->
				<div class="field-group" id="g-message">
					<label class="field-label" for="message">문의 내용</label>
					<textarea class="field-textarea" id="message" name="message"
						placeholder="문의하실 내용을 상세히 입력해주세요."></textarea>
					<span class="field-error">문의 내용을 입력해주세요.</span>
				</div>

				<!-- 안내 문구 -->
				<p class="form-note">
					접수된 문의는 평일 영업시간 내에 순차적으로 답변드립니다. 문의가 많을 경우 다소 지연될 수 있습니다.
				</p>

				<!-- 제출 버튼 -->
				<button class="submit-btn" type="submit" id="submitBtn">문의 접수하기</button>

			</form>
		</div>

		<script>
			// ── 전화번호 자동 하이픈 ──
			document.getElementById('phone').addEventListener('input', function (e) {
				let v = e.target.value.replace(/\D/g, '');
				if (v.length <= 3) v = v;
				else if (v.length <= 7) v = v.slice(0, 3) + '-' + v.slice(3);
				else v = v.slice(0, 3) + '-' + v.slice(3, 7) + '-' + v.slice(7, 11);
				e.target.value = v;
			});

			// ── 유효성 검사 ──
			function validate() {
				let valid = true;

				const fields = [
					{
						id: 'name', group: 'g-name',
						check: v => v.trim().length > 0
					},
					{
						id: 'email', group: 'g-email',
						check: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim())
					},
					{
						id: 'phone', group: 'g-phone',
						check: v => v.trim().length >= 9
					},
					{
						id: 'type', group: 'g-type',
						check: v => v !== ''
					},
					{
						id: 'message', group: 'g-message',
						check: v => v.trim().length > 0
					},
				];

				fields.forEach(f => {
					const el = document.getElementById(f.id);
					const g = document.getElementById(f.group);
					if (!f.check(el.value)) {
						g.classList.add('has-error');
						valid = false;
					} else {
						g.classList.remove('has-error');
					}
				});

				return valid;
			}

			// ── 실시간 에러 해제 ──
			['name', 'email', 'phone', 'type', 'message'].forEach(id => {
				const el = document.getElementById(id);
				el.addEventListener('input', () => {
					document.getElementById('g-' + id)?.classList.remove('has-error');
				});
				el.addEventListener('change', () => {
					document.getElementById('g-' + id)?.classList.remove('has-error');
				});
			});

			// ── 폼 제출 ──
			document.getElementById('contactForm').addEventListener('submit', async function (e) {
				e.preventDefault();
				if (!validate()) return;

				const btn = document.getElementById('submitBtn');
				btn.disabled = true;
				btn.textContent = '접수 중...';

				const payload = {
					name: document.getElementById('name').value.trim(),
					email: document.getElementById('email').value.trim(),
					phone: document.getElementById('phone').value.trim(),
					type: document.getElementById('type').value,
					message: document.getElementById('message').value.trim(),
				};

				try {
					// ── 실제 API 연동 시 아래 주석 해제 ──
					// const res = await fetch('http://localhost:8080/api/inquiries', {
					//   method: 'POST',
					//   headers: { 'Content-Type': 'application/json' },
					//   body: JSON.stringify(payload),
					// });
					// if (!res.ok) throw new Error('서버 오류');

					// 데모: 1초 딜레이 후 성공 처리
					await new Promise(r => setTimeout(r, 900));

					document.getElementById('contactForm').style.display = 'none';
					document.getElementById('successMsg').style.display = 'block';

				} catch (err) {
					alert('접수 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
					btn.disabled = false;
					btn.textContent = '문의 접수하기';
				}
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
						url: "http://localhost:8080/inquiry.dox",
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