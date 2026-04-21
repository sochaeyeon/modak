<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>모닥모닥 고객센터 - Frame</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/cs-center.css">
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