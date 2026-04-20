<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>자주 묻는 질문 - 모닥모닥</title>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
		rel="stylesheet">
	<style>
		:root {
			--cream: #f7f3ee;
			--orange: #d4714a;
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
			background: var(--white);
			color: var(--text-dark);
			font-size: 12px;
			line-height: 1.7;
		}

		.faq-wrap {
			max-width: 680px;
			margin: 0 auto;
			padding: 36px 24px 48px;
		}

		/* ── EYEBROW + TITLE ── */
		.eyebrow {
			font-size: 10px;
			letter-spacing: 1.5px;
			color: var(--text-light);
			text-transform: uppercase;
			margin-bottom: 4px;
		}

		.faq-title {
			font-size: 20px;
			font-weight: 700;
			color: var(--text-dark);
			letter-spacing: -0.4px;
			margin-bottom: 24px;
		}

		/* ── LAYOUT ── */
		.faq-layout {
			display: flex;
			gap: 28px;
			align-items: flex-start;
		}

		/* ── SIDEBAR ── */
		.faq-sidebar {
			width: 80px;
			flex-shrink: 0;
			padding-top: 6px;
		}

		.faq-sidebar ul {
			list-style: none;
		}

		.faq-sidebar li {
			font-size: 12px;
			color: var(--text-light);
			padding: 6px 0;
			cursor: pointer;
			transition: color 0.15s;
		}

		.faq-sidebar li:hover {
			color: var(--text-mid);
		}

		.faq-sidebar li.active {
			color: var(--text-dark);
			font-weight: 700;
		}

		/* ── MAIN ── */
		.faq-main {
			flex: 1;
			min-width: 0;
		}

		/* tabs */
		.faq-tabs {
			display: flex;
			gap: 0;
			border-bottom: 1.5px solid var(--border);
			margin-bottom: 0;
		}

		.faq-tab {
			padding: 7px 16px;
			font-size: 12px;
			color: var(--text-light);
			cursor: pointer;
			border-bottom: 2px solid transparent;
			margin-bottom: -1.5px;
			transition: color 0.15s;
			white-space: nowrap;
		}

		.faq-tab:first-child {
			padding-left: 0;
		}

		.faq-tab:hover {
			color: var(--text-mid);
		}

		.faq-tab.active {
			color: var(--orange);
			border-bottom-color: var(--orange);
			font-weight: 700;
		}

		/* faq items */
		.faq-list {
			margin-top: 0;
		}

		.faq-item {
			border-bottom: 1px solid var(--border);
			overflow: hidden;
		}

		.faq-question {
			display: flex;
			align-items: center;
			justify-content: space-between;
			padding: 16px 4px 16px 0;
			cursor: pointer;
			transition: color 0.15s;
			gap: 12px;
		}

		.faq-question:hover .q-text {
			color: var(--orange);
		}

		.q-text {
			font-size: 12px;
			color: var(--text-dark);
			flex: 1;
			transition: color 0.15s;
			line-height: 1.5;
		}

		.q-arrow {
			font-size: 12px;
			color: var(--text-light);
			flex-shrink: 0;
			transition: transform 0.25s ease, color 0.15s;
		}

		.faq-item.open .q-arrow {
			transform: rotate(90deg);
			color: var(--orange);
		}

		.faq-item.open .q-text {
			color: var(--orange);
			font-weight: 500;
		}

		/* answer */
		.faq-answer {
			max-height: 0;
			overflow: hidden;
			transition: max-height 0.3s ease, padding 0.3s ease;
			padding: 0 4px;
		}

		.faq-item.open .faq-answer {
			max-height: 400px;
			padding: 0 4px 16px;
		}

		.faq-answer-inner {
			background: var(--cream);
			border-radius: 6px;
			padding: 14px 16px;
			font-size: 11px;
			color: var(--text-mid);
			line-height: 1.85;
		}

		.faq-answer-inner a {
			color: var(--orange);
			text-decoration: underline;
			cursor: pointer;
		}

		/* bottom divider */
		.faq-bottom-line {
			height: 1px;
			background: var(--border);
			margin-top: 32px;
		}
	</style>
</head>

<body>

	<div class="faq-wrap">
		<div class="eyebrow">FAQ</div>
		<div class="faq-title">자주 묻는 질문</div>

		<div class="faq-layout">

			<!-- SIDEBAR -->
			<div class="faq-sidebar">
				<ul>
					<li class="active" data-cat="전체">전체</li>
					<li data-cat="서비스 안내">서비스 안내</li>
					<li data-cat="요금 / 결제">요금 / 결제</li>
					<li data-cat="회원 / 계정">회원 / 계정</li>
					<li data-cat="기타 문의">기타 문의</li>
				</ul>
			</div>

			<!-- MAIN -->
			<div class="faq-main">
				<!-- TABS -->
				<div class="faq-tabs">
					<div class="faq-tab active" data-tab="전체">전체</div>
					<div class="faq-tab" data-tab="서비스">서비스</div>
					<div class="faq-tab" data-tab="요금">요금</div>
					<div class="faq-tab" data-tab="계정">계정</div>
				</div>

				<!-- FAQ LIST -->
				<div class="faq-list" id="faqList"></div>
			</div>

		</div>

		<div class="faq-bottom-line"></div>
	</div>

	<script>
		const faqs = [
			{
				cat: ['전체', '서비스'],
				q: '서비스 이용 방법이 어떻게 되나요?',
				a: '모닥모닥 서비스는 회원가입 후 원하시는 요금제를 선택하여 바로 이용하실 수 있습니다. 로그인 후 메인 화면에서 원하는 기능을 선택하시면 됩니다. 자세한 내용은 <a href="#">이용 가이드</a>를 참고해 주세요.'
			},
			{
				cat: ['전체', '계정'],
				q: '비밀번호를 잊어버렸을 때 어떻게 하나요?',
				a: '로그인 화면 하단의 "비밀번호 찾기"를 클릭하시면 가입하신 이메일로 재설정 링크가 발송됩니다. 이메일을 확인하신 후 안내에 따라 새 비밀번호를 설정해 주세요.'
			},
			{
				cat: ['전체', '요금'],
				q: '요금제 변경은 어떻게 하나요?',
				a: '마이페이지 > 요금제 관리에서 언제든지 요금제를 변경하실 수 있습니다. 변경 사항은 다음 결제일부터 적용되며, 당월 요금은 기존 요금제로 유지됩니다.'
			},
			{
				cat: ['전체', '요금'],
				q: '영수증 발급은 어떻게 하나요?',
				a: '마이페이지 > 결제 내역에서 원하시는 결제 건을 선택하신 후 "영수증 발급" 버튼을 클릭하시면 됩니다. PDF 또는 이메일 발송 형태로 받아보실 수 있습니다.'
			},
			{
				cat: ['전체', '계정'],
				q: '회원 탈퇴 후 재가입이 가능한가요?',
				a: '탈퇴 후 30일 이내에는 동일 계정으로 재가입이 제한됩니다. 30일 경과 후에는 동일한 이메일로 재가입이 가능하나, 기존 데이터는 복구되지 않습니다.'
			},
			{
				cat: ['전체', '요금'],
				q: '환불 정책이 어떻게 되나요?',
				a: '결제일 기준 7일 이내, 서비스를 이용하지 않으신 경우에 한해 전액 환불이 가능합니다. 이용 내역이 있는 경우 일할 계산 후 잔여 금액을 환불해 드립니다. 환불 신청은 1:1 문의를 이용해 주세요.'
			},
			{
				cat: ['전체', '요금'],
				q: '결제 오류가 발생했을 때는 어떻게 하나요?',
				a: '결제 오류 발생 시 고객센터 1588-0000 또는 1:1 문의로 연락해 주시면 신속하게 처리해 드립니다. 오류 화면 캡처 및 결제 시도 시간을 함께 알려주시면 빠른 처리에 도움이 됩니다.'
			},
			{
				cat: ['전체', '서비스'],
				q: '서비스 이용 중 오류가 발생했을 때 대처 방법은?',
				a: '앱 또는 브라우저를 재시작하신 후 다시 시도해 주세요. 문제가 지속될 경우 공지사항에서 서버 점검 일정을 확인하시거나, 1:1 문의를 통해 오류 증상과 환경(OS, 브라우저 버전)을 알려주시면 빠르게 해결해 드립니다.'
			},
		];

		let currentTab = '전체';
		let currentCat = '전체';

		function render() {
			const list = document.getElementById('faqList');
			const filtered = faqs.filter(f => {
				const tabMatch = currentTab === '전체' || f.cat.includes(currentTab);
				const catMap = {'서비스 안내': '서비스', '요금 / 결제': '요금', '회원 / 계정': '계정', '기타 문의': '기타'};
				const catTab = catMap[currentCat] || currentCat;
				const catMatch = currentCat === '전체' || f.cat.includes(catTab);
				return tabMatch && catMatch;
			});

			list.innerHTML = filtered.map((f, i) => `
      <div class="faq-item" data-index="${i}">
        <div class="faq-question">
          <span class="q-text">${f.q}</span>
          <span class="q-arrow">›</span>
        </div>
        <div class="faq-answer">
          <div class="faq-answer-inner">${f.a}</div>
        </div>
      </div>
    `).join('');

			list.querySelectorAll('.faq-question').forEach(q => {
				q.addEventListener('click', function () {
					const item = this.closest('.faq-item');
					const wasOpen = item.classList.contains('open');
					list.querySelectorAll('.faq-item').forEach(x => x.classList.remove('open'));
					if (!wasOpen) item.classList.add('open');
				});
			});
		}

		// Tabs
		document.querySelectorAll('.faq-tab').forEach(t => {
			t.addEventListener('click', function () {
				document.querySelectorAll('.faq-tab').forEach(x => x.classList.remove('active'));
				this.classList.add('active');
				currentTab = this.dataset.tab;
				render();
			});
		});

		// Sidebar
		document.querySelectorAll('.faq-sidebar li').forEach(li => {
			li.addEventListener('click', function () {
				document.querySelectorAll('.faq-sidebar li').forEach(x => x.classList.remove('active'));
				this.classList.add('active');
				currentCat = this.dataset.cat;
				render();
			});
		});

		render();
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
					url: "http://localhost:8080/faq.dox",
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