<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 - 모닥모닥</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-list.css">
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