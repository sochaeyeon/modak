<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 상세 - 모닥모닥</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-detail.css">
	</head>

	<body>

		<!-- Header -->
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<!-- BROWSER BAR -->
			<div class="browser-bar">
				<div class="b-dots">
					<div class="b-dot"></div>
					<div class="b-dot"></div>
					<div class="b-dot"></div>
				</div>

				<div class="page">

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



				</div><!-- /page -->
			</div><!-- /browser-wrap -->

			<!-- Footer -->
			<%@ include file="/WEB-INF/common/footer.jsp" %>

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