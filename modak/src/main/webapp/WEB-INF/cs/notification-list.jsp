<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 - 모닥모닥</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-list.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
	</head>

	<body>

		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div class="browser-wrap">
				<div class="page" id="app">

					<div class="breadcrumb-bar">
						<a href="${pageContext.request.contextPath}/main.do">홈</a><span>›</span>
						<a href="${pageContext.request.contextPath}/cs/center.do">고객센터</a><span>›</span>
						<span class="current">공지사항</span>
					</div>

					<div class="content">
						<div class="page-title">공지사항</div>
						<div class="page-desc">서비스 관련 안내 및 업데이트 소식을 확인하세요.</div>

						<!-- CATEGORY TABS -->
						<div class="cat-tabs">
							<div class="cat-tab" :class="{ active: selectedType === '' }" @click="selectType('')">전체
							</div>
							<div class="cat-tab" :class="{ active: selectedType === 'ORDER' }"
								@click="selectType('ORDER')">서비스 소식</div>
							<div class="cat-tab" :class="{ active: selectedType === 'SYSTEM' }"
								@click="selectType('SYSTEM')">사이트 점검</div>
							<div class="cat-tab" :class="{ active: selectedType === 'EVENT' }"
								@click="selectType('EVENT')">이벤트</div>
							<div class="cat-tab" :class="{ active: selectedType === 'POLICY' }"
								@click="selectType('POLICY')">환경설정</div>
						</div>

						<!-- SEARCH + 정렬 셀렉트박스 -->
						<div class="search-bar">
							<div class="search-input-wrap">
								<input type="text" v-model="keyword" placeholder="검색어를 입력하세요" @keyup.enter="fnSearch">
								<button class="search-btn" @click="fnSearch">🔍</button>
							</div>
							<!-- ★ 정렬 셀렉트박스 (버튼 토글 → select로 변경) -->
							<select class="sort-select" v-model="sort" @change="onSortChange">
								<option value="newest">최신순</option>
								<option value="oldest">오래된순</option>
								<option value="viewCount">조회수순</option>
							</select>
						</div>

						<div class="total-count">총 <strong>{{ totalCount }}</strong>건</div>

						<!-- TABLE -->
						<table class="notice-table">
							<thead>
								<tr>
									<th class="num-cell">번호</th>
									<th class="left">제목</th>
									<th style="width:70px;">분류</th>
									<th style="width:80px;">등록일자</th>
									<th style="width:50px;">조회수</th>
									<th v-if="isAdmin" style="width:60px;">고정</th>
								</tr>
							</thead>
							<tbody>
								<tr v-if="loading">
									<td :colspan="isAdmin ? 6 : 5" style="text-align:center;padding:40px;color:#999;">
										불러오는 중...</td>
								</tr>

								<template v-if="!loading">
									<!-- 고정 공지 -->
									<tr v-for="item in pinnedList" :key="'pin-' + item.notificationId" class="pinned"
										style="cursor:pointer;">
										<td @click="fnDetail(item.notificationId)">
											<span style="color:var(--orange);font-weight:700;font-size:11px;">공지</span>
										</td>
										<td class="title-cell" @click="fnDetail(item.notificationId)">
											<div class="badge-wrap">
												<span class="n-badge" :class="getBadgeClass(item.type)">{{
													getBadgeLabel(item.type) }}</span>
												<span class="title-text pinned">{{ item.title }}</span>
												<span class="new-dot" v-if="isNew(item.createdAt)"></span>
											</div>
										</td>
										<td @click="fnDetail(item.notificationId)">{{ getTypeLabel(item.type) }}</td>
										<td @click="fnDetail(item.notificationId)">{{ formatDate(item.createdAt) }}</td>
										<td @click="fnDetail(item.notificationId)">{{ item.viewCount ?
											item.viewCount.toLocaleString() : 0 }}</td>
										<td v-if="isAdmin">
											<button class="pin-btn unpin" @click.stop="fnUnpin(item.notificationId)"
												title="고정 해제">📌 해제</button>
										</td>
									</tr>

									<!-- 구분선 -->
									<tr v-if="pinnedList.length > 0 && list.length > 0" class="divider-row">
										<td :colspan="isAdmin ? 6 : 5">
											<div class="pin-divider"></div>
										</td>
									</tr>

									<!-- 데이터 없음 -->
									<tr v-if="list.length === 0 && pinnedList.length === 0">
										<td :colspan="isAdmin ? 6 : 5"
											style="text-align:center;padding:40px;color:#999;">
											등록된 공지사항이 없습니다.
										</td>
									</tr>

									<!-- 일반 목록 -->
									<tr v-for="(item, index) in list" :key="'normal-' + item.notificationId"
										style="cursor:pointer;">
										<td @click="fnDetail(item.notificationId)">
											{{ totalCount - ((currentPage - 1) * pageSize) - index }}
										</td>
										<td class="title-cell" @click="fnDetail(item.notificationId)">
											<div class="badge-wrap">
												<span class="n-badge" :class="getBadgeClass(item.type)">{{
													getBadgeLabel(item.type) }}</span>
												<span class="title-text">{{ item.title }}</span>
												<span class="new-dot" v-if="isNew(item.createdAt)"></span>
											</div>
										</td>
										<td @click="fnDetail(item.notificationId)">{{ getTypeLabel(item.type) }}</td>
										<td @click="fnDetail(item.notificationId)">{{ formatDate(item.createdAt) }}</td>
										<td @click="fnDetail(item.notificationId)">{{ item.viewCount ?
											item.viewCount.toLocaleString() : 0 }}</td>
										<td v-if="isAdmin">
											<button class="pin-btn pin" @click.stop="fnPin(item.notificationId)"
												title="공지 고정">📌 고정</button>
										</td>
									</tr>
								</template>
							</tbody>
						</table>

						<!-- PAGINATION -->
						<div class="pagination" v-if="totalPage > 0">
							<div class="page-btn arrow" @click="goPage(1)" :class="{ disabled: currentPage === 1 }">«
							</div>
							<div class="page-btn arrow" @click="goPage(currentPage - 1)"
								:class="{ disabled: currentPage === 1 }">‹</div>
							<div class="page-btn" v-for="p in pageRange" :key="p" :class="{ active: currentPage === p }"
								@click="goPage(p)">{{ p }}</div>
							<div class="page-btn arrow" @click="goPage(currentPage + 1)"
								:class="{ disabled: currentPage === totalPage }">›</div>
							<div class="page-btn arrow" @click="goPage(totalPage)"
								:class="{ disabled: currentPage === totalPage }">»</div>
						</div>
					</div>

				</div>
			</div>

			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script src="https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js"></script>
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

				<script>
					const app = Vue.createApp({
						data() {
							return {
								pinnedList: [],
								list: [],
								totalCount: 0,
								totalPage: 0,
								currentPage: 1,
								pageSize: 10,
								pageGroupSize: 5,
								keyword: '',
								selectedType: '',
								sort: 'newest',   // ★ 셀렉트박스와 v-model 연결
								loading: false,
								isAdmin: false,
							};
						},

						computed: {
							pageRange() {
								const groupStart = Math.floor((this.currentPage - 1) / this.pageGroupSize) * this.pageGroupSize + 1;
								const groupEnd = Math.min(groupStart + this.pageGroupSize - 1, this.totalPage);
								const pages = [];
								for (let i = groupStart; i <= groupEnd; i++) pages.push(i);
								return pages;
							}
						},

						methods: {
							fnList() {
								const self = this;
								self.loading = true;
								const param = {
									type: self.selectedType,
									keyword: self.keyword,
									sort: self.sort,
									startRow: (self.currentPage - 1) * self.pageSize,
									pageSize: self.pageSize
								};
								$.ajax({
									url: "${pageContext.request.contextPath}/notification/list.dox",
									dataType: "json",
									type: "POST",
									data: param,
									success(data) {
										if (data.result === 'success') {
											self.pinnedList = data.pinnedList || [];
											self.list = data.list || [];
											self.totalCount = data.totalCount || 0;
											self.totalPage = Math.ceil(self.totalCount / self.pageSize);
										} else {
											alert('목록 조회에 실패했습니다.');
										}
										self.loading = false;
									},
									error() {
										alert('서버 오류가 발생했습니다.');
										self.loading = false;
									}
								});
							},

							// ★ 셀렉트박스 변경 이벤트
							onSortChange() {
								this.currentPage = 1;
								this.fnList();
							},

							fnDetail(notificationId) {
								location.href = "${pageContext.request.contextPath}/notification/detail.do?notificationId=" + notificationId;
							},

							fnSearch() {
								this.currentPage = 1;
								this.fnList();
							},

							selectType(type) {
								this.selectedType = type;
								this.currentPage = 1;
								this.fnList();
							},

							goPage(page) {
								if (page < 1 || page > this.totalPage) return;
								this.currentPage = page;
								this.fnList();
							},

							fnPin(notificationId) {
								if (!confirm('이 공지를 최상단에 고정하시겠습니까?')) return;
								const self = this;
								$.ajax({
									url: "${pageContext.request.contextPath}/notification/pin.dox",
									dataType: "json", type: "POST",
									data: {notificationId},
									success(data) {
										data.result === 'success' ? self.fnList() : alert(data.message || '고정 설정에 실패했습니다.');
									},
									error() {alert('서버 오류가 발생했습니다.');}
								});
							},

							fnUnpin(notificationId) {
								if (!confirm('이 공지의 고정을 해제하시겠습니까?')) return;
								const self = this;
								$.ajax({
									url: "${pageContext.request.contextPath}/notification/unpin.dox",
									dataType: "json", type: "POST",
									data: {notificationId},
									success(data) {
										data.result === 'success' ? self.fnList() : alert(data.message || '고정 해제에 실패했습니다.');
									},
									error() {alert('서버 오류가 발생했습니다.');}
								});
							},

							getBadgeClass(type) {
								return {ORDER: 'notice', SYSTEM: 'update', EVENT: 'event', POLICY: 'notice2', RENTAL: 'update', INQUIRY: 'gray'}[type] || 'gray';
							},
							getBadgeLabel(type) {
								return {ORDER: '공지', SYSTEM: '업데이트', EVENT: '이벤트', POLICY: '안내', RENTAL: '업데이트', INQUIRY: '일반'}[type] || '일반';
							},
							getTypeLabel(type) {
								return {ORDER: '서비스 소식', SYSTEM: '사이트 점검', EVENT: '이벤트', POLICY: '정책 변경', RENTAL: '서비스 소식', INQUIRY: '고객문의'}[type] || '전체';
							},
							formatDate(dateStr) {
								if (!dateStr) return '';
								return dateStr.substring(0, 10).replace(/-/g, '.');
							},
							isNew(dateStr) {
								if (!dateStr) return false;
								return (new Date() - new Date(dateStr)) / (1000 * 60 * 60 * 24) <= 7;
							}
						},

						mounted() {this.fnList();}
					});

					app.mount('#app');
				</script>

	</body>

	</html>