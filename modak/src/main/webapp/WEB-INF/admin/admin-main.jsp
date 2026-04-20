<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>모닥모닥 관리자 센터</title>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<style>
			:root {
				--orange: #d4714a;
				--cream: #f7f3ee;
				--dark: #3a3530;
				--gray: #7a7068;
				--light-gray: #e8e0d8;
			}

			body {
				font-family: 'Noto Sans KR', sans-serif;
				background: #fdfdfd;
				margin: 0;
				display: flex;
			}

			/* 사이드바 */
			.admin-sidebar {
				width: 240px;
				height: 100vh;
				background: var(--dark);
				color: #fff;
				position: fixed;
			}

			.sidebar-logo {
				padding: 30px;
				font-size: 20px;
				font-weight: 700;
				color: var(--orange);
				border-bottom: 1px solid #4a4540;
			}

			.sidebar-menu {
				list-style: none;
				padding: 20px 0;
			}

			.sidebar-menu li {
				padding: 15px 30px;
				cursor: pointer;
				transition: 0.3s;
				color: #b0a89e;
			}

			.sidebar-menu li:hover,
			.sidebar-menu li.active {
				background: #4a4540;
				color: #fff;
			}

			/* 메인 컨텐츠 */
			.admin-content {
				margin-left: 240px;
				width: calc(100% - 240px);
				padding: 40px;
			}

			.header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 40px;
			}

			/* 통계 카드 */
			.dashboard-cards {
				display: grid;
				grid-template-columns: repeat(4, 1fr);
				gap: 20px;
				margin-bottom: 40px;
			}

			.card {
				background: #fff;
				padding: 25px;
				border-radius: 12px;
				border: 1px solid var(--light-gray);
				box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
			}

			.card-label {
				font-size: 14px;
				color: var(--gray);
				margin-bottom: 10px;
			}

			.card-value {
				font-size: 24px;
				font-weight: 700;
				color: var(--dark);
			}

			.card-value span {
				font-size: 14px;
				margin-left: 5px;
				color: var(--orange);
			}

			/* 테이블 영역 */
			.table-section {
				background: #fff;
				padding: 30px;
				border-radius: 12px;
				border: 1px solid var(--light-gray);
			}

			.section-title {
				font-size: 18px;
				font-weight: 700;
				margin-bottom: 20px;
				display: flex;
				justify-content: space-between;
			}

			.btn-more {
				font-size: 13px;
				color: var(--orange);
				text-decoration: none;
				cursor: pointer;
			}

			table {
				width: 100%;
				border-collapse: collapse;
			}

			th {
				text-align: left;
				padding: 15px 10px;
				border-bottom: 2px solid var(--cream);
				color: var(--gray);
				font-size: 14px;
			}

			td {
				padding: 15px 10px;
				border-bottom: 1px solid var(--light-gray);
				font-size: 14px;
				color: var(--dark);
			}

			.status-badge {
				padding: 4px 8px;
				border-radius: 4px;
				font-size: 11px;
				font-weight: bold;
			}

			.ongoing {
				background: #e7f5ff;
				color: #228be6;
			}

			.closed {
				background: #f1f3f5;
				color: #868e96;
			}
		</style>
	</head>

	<body>

		<div id="app" style="width: 100%; display: flex;">
			<nav class="admin-sidebar">
				<div class="sidebar-logo">MODAK ADMIN</div>
				<ul class="sidebar-menu">
					<li class="active">대시보드</li>
					<li @click="location.href='/faq-admin.do'">FAQ 관리</li>
					<li @click="location.href='/event-admin.do'">이벤트 관리</li>
					<li>회원 관리</li>
					<li>로그아웃</li>
				</ul>
			</nav>

			<main class="admin-content">
				<div class="header">
					<h2>시스템 현황</h2>
					<div style="font-size: 14px; color: var(--gray);">관리자님, 환영합니다.</div>
				</div>

				<div class="dashboard-cards">
					<div class="card">
						<div class="card-label">신규 문의</div>
						<div class="card-value">12<span>건</span></div>
					</div>
					<div class="card">
						<div class="card-label">진행중인 이벤트</div>
						<div class="card-value">{{ eventCount }}<span>개</span></div>
					</div>
					<div class="card">
						<div class="card-label">오늘 방문자</div>
						<div class="card-value">1,240<span>명</span></div>
					</div>
					<div class="card">
						<div class="card-label">누적 회원수</div>
						<div class="card-value">8,502<span>명</span></div>
					</div>
				</div>

				<div class="table-section">
					<div class="section-title">
						최근 등록 소식
						<span class="btn-more" @click="location.href='/event-admin.do'">전체보기 ></span>
					</div>
					<table>
						<thead>
							<tr>
								<th>ID</th>
								<th>제목</th>
								<th>기간</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="event in recentEvents" :key="event.eventId">
								<td>#{{ event.eventId }}</td>
								<td>{{ event.title }}</td>
								<td>{{ event.startDate }} ~ {{ event.endDate }}</td>
								<td>
									<span :class="['status-badge', fnIsOngoing(event.endDate) ? 'ongoing' : 'closed']">
										{{ fnIsOngoing(event.endDate) ? '진행중' : '종료' }}
									</span>
								</td>
							</tr>
							<tr v-if="recentEvents.length === 0">
								<td colspan="4" style="text-align:center; padding: 50px; color: #ccc;">등록된 데이터가 없습니다.
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</main>
		</div>

		<script>
			var app = new Vue({
				el: '#app',
				data: {
					recentEvents: [],
					eventCount: 0
				},
				methods: {
					fnGetData: function () {
						var self = this;
						// 기존 만들어둔 event list API 활용 (최신 5개만 가져오도록 파라미터 조절 가능)
						$.ajax({
							url: "/admin/main.dox",
							type: "POST",
							data: {startNum: 0, contentSize: 5, status: '전체'},
							success: function (data) {
								self.recentEvents = data.list;
								self.eventCount = data.count;
							}
						});
					},
					fnIsOngoing: function (endDate) {
						return new Date(endDate) >= new Date();
					}
				},
				mounted: function () {
					this.fnGetData();
				}
			});
		</script>

	</body>

	</html>