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

		<!-- 브레드크럼 -->
		<div class="breadcrumb-bar">
			<a href="${pageContext.request.contextPath}/main.do">홈</a><span>›</span>
			<a href="${pageContext.request.contextPath}/cs/center.do">고객센터</a><span>›</span>
			<span class="current">공지사항</span>
		</div>

		<!-- 페이지 헤더 + 탭 -->
		<div class="page-header-wrap">
			<div class="page-header-inner">
				<div class="page-title">공지사항</div>
				<div class="page-desc">서비스 관련 안내 및 업데이트 소식을 확인하세요.</div>
				<div class="cat-tabs">
					<div class="cat-tab" :class="{ active: selectedType === '' }"       @click="selectType('')">전체</div>
					<div class="cat-tab" :class="{ active: selectedType === 'ORDER' }"  @click="selectType('ORDER')">서비스 소식</div>
					<div class="cat-tab" :class="{ active: selectedType === 'SYSTEM' }" @click="selectType('SYSTEM')">사이트 점검</div>
					<div class="cat-tab" :class="{ active: selectedType === 'EVENT' }"  @click="selectType('EVENT')">이벤트</div>
					<div class="cat-tab" :class="{ active: selectedType === 'POLICY' }" @click="selectType('POLICY')">환경설정</div>
				</div>
			</div>
		</div>

		<!-- 컨텐츠 -->
		<div class="content">

			<!-- 툴바: 총건수 + 검색 + 정렬 -->
			<div class="toolbar">
				<div class="total-count">총 <strong>{{ totalCount }}</strong>건</div>
				<div class="search-bar">
					<div class="search-input-wrap">
						<input type="text" v-model="keyword" placeholder="검색어를 입력하세요" @keyup.enter="fnSearch">
						<button class="search-btn" @click="fnSearch">🔍</button>
					</div>
					<select class="sort-select" v-model="sort" @change="onSortChange">
						<option value="newest">최신순</option>
						<option value="oldest">오래된순</option>
						<option value="viewCount">조회수순</option>
					</select>
				</div>
			</div>

			<!-- TABLE -->
			<table class="notice-table">
				<thead>
					<tr>
						<th class="num-cell">번호</th>
						<th class="left">제목</th>
						<th style="width:90px;">분류</th>
						<th style="width:90px;">등록일자</th>
						<th style="width:56px;">조회수</th>
						<th v-if="isAdmin" style="width:64px;">고정</th>
					</tr>
				</thead>
				<tbody>
					<tr v-if="loading">
						<td :colspan="isAdmin ? 6 : 5" style="text-align:center;padding:48px;color:var(--brown4);">
							불러오는 중...
						</td>
					</tr>

					<template v-if="!loading">
						<!-- 고정 공지 -->
						<tr v-for="item in pinnedList" :key="'pin-'+item.notificationId" class="pinned">
							<td @click="fnDetail(item.notificationId)">
								<span style="color:var(--orange);font-weight:700;font-size:11px;">공지</span>
							</td>
							<td class="title-cell" @click="fnDetail(item.notificationId)">
								<div class="badge-wrap">
									<span class="n-badge" :class="getBadgeClass(item.type)">{{ getBadgeLabel(item.type) }}</span>
									<span class="title-text pinned">{{ item.title }}</span>
									<span class="new-dot" v-if="isNew(item.createdAt)"></span>
								</div>
							</td>
							<td @click="fnDetail(item.notificationId)">{{ getTypeLabel(item.type) }}</td>
							<td @click="fnDetail(item.notificationId)">{{ formatDate(item.createdAt) }}</td>
							<td @click="fnDetail(item.notificationId)">{{ item.viewCount ? item.viewCount.toLocaleString() : 0 }}</td>
							<td v-if="isAdmin">
								<button class="pin-btn unpin" @click.stop="fnUnpin(item.notificationId)">📌 해제</button>
							</td>
						</tr>

						<!-- 고정/일반 구분선 -->
						<tr v-if="pinnedList.length > 0 && list.length > 0" class="divider-row">
							<td :colspan="isAdmin ? 6 : 5"><div class="pin-divider"></div></td>
						</tr>

						<!-- 데이터 없음 -->
						<tr v-if="list.length === 0 && pinnedList.length === 0">
							<td :colspan="isAdmin ? 6 : 5" style="text-align:center;padding:48px;color:var(--brown4);">
								등록된 공지사항이 없습니다.
							</td>
						</tr>

						<!-- 일반 목록 -->
						<tr v-for="(item, index) in list" :key="'normal-'+item.notificationId">
							<td @click="fnDetail(item.notificationId)">
								{{ totalCount - ((currentPage - 1) * pageSize) - index }}
							</td>
							<td class="title-cell" @click="fnDetail(item.notificationId)">
								<div class="badge-wrap">
									<span class="n-badge" :class="getBadgeClass(item.type)">{{ getBadgeLabel(item.type) }}</span>
									<span class="title-text">{{ item.title }}</span>
									<span class="new-dot" v-if="isNew(item.createdAt)"></span>
								</div>
							</td>
							<td @click="fnDetail(item.notificationId)">{{ getTypeLabel(item.type) }}</td>
							<td @click="fnDetail(item.notificationId)">{{ formatDate(item.createdAt) }}</td>
							<td @click="fnDetail(item.notificationId)">{{ item.viewCount ? item.viewCount.toLocaleString() : 0 }}</td>
							<td v-if="isAdmin">
								<button class="pin-btn pin" @click.stop="fnPin(item.notificationId)">📌 고정</button>
							</td>
						</tr>
					</template>
				</tbody>
			</table>

			<!-- PAGINATION -->
			<div class="pagination" v-if="totalPage > 0">
				<div class="page-btn arrow" :class="{ disabled: currentPage === 1 }" @click="goPage(1)">«</div>
				<div class="page-btn arrow" :class="{ disabled: currentPage === 1 }" @click="goPage(currentPage - 1)">‹</div>
				<div class="page-btn" v-for="p in pageRange" :key="p" :class="{ active: currentPage === p }" @click="goPage(p)">{{ p }}</div>
				<div class="page-btn arrow" :class="{ disabled: currentPage === totalPage }" @click="goPage(currentPage + 1)">›</div>
				<div class="page-btn arrow" :class="{ disabled: currentPage === totalPage }" @click="goPage(totalPage)">»</div>
			</div>

		</div><!-- /content -->
	</div><!-- /page -->
</div><!-- /browser-wrap -->

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	const app = Vue.createApp({
		data() {
			return {
				pinnedList: [], list: [],
				totalCount: 0, totalPage: 0,
				currentPage: 1, pageSize: 10, pageGroupSize: 5,
				keyword: '', selectedType: '', sort: 'newest',
				loading: false, isAdmin: false,
			};
		},

		computed: {
			pageRange() {
				const gs = Math.floor((this.currentPage - 1) / this.pageGroupSize) * this.pageGroupSize + 1;
				const ge = Math.min(gs + this.pageGroupSize - 1, this.totalPage);
				const pages = [];
				for (let i = gs; i <= ge; i++) pages.push(i);
				return pages;
			}
		},

		methods: {
			fnList() {
				const self = this;
				self.loading = true;
				$.ajax({
					url: "${pageContext.request.contextPath}/notification/list.dox",
					dataType: "json", type: "POST",
					data: {
						type: self.selectedType,
						keyword: self.keyword,
						sort: self.sort,
						startRow: (self.currentPage - 1) * self.pageSize,
						pageSize: self.pageSize
					},
					success(data) {
						if (data.result === 'success') {
							self.pinnedList  = data.pinnedList  || [];
							self.list        = data.list        || [];
							self.totalCount  = data.totalCount  || 0;
							self.totalPage   = Math.ceil(self.totalCount / self.pageSize);
						} else {
							alert('목록 조회에 실패했습니다.');
						}
						self.loading = false;
					},
					error() { alert('서버 오류가 발생했습니다.'); self.loading = false; }
				});
			},

			onSortChange()        { this.currentPage = 1; this.fnList(); },
			fnSearch()            { this.currentPage = 1; this.fnList(); },
			selectType(type)      { this.selectedType = type; this.currentPage = 1; this.fnList(); },
			fnDetail(id)          { location.href = "${pageContext.request.contextPath}/notification/detail.do?notificationId=" + id; },
			goPage(page)          { if (page < 1 || page > this.totalPage) return; this.currentPage = page; this.fnList(); },

			fnPin(id) {
				if (!confirm('이 공지를 최상단에 고정하시겠습니까?')) return;
				const self = this;
				$.ajax({ url: "${pageContext.request.contextPath}/notification/pin.dox", dataType: "json", type: "POST", data: {notificationId: id},
					success(d) { d.result === 'success' ? self.fnList() : alert(d.message || '고정 설정에 실패했습니다.'); },
					error() { alert('서버 오류가 발생했습니다.'); }
				});
			},

			fnUnpin(id) {
				if (!confirm('이 공지의 고정을 해제하시겠습니까?')) return;
				const self = this;
				$.ajax({ url: "${pageContext.request.contextPath}/notification/unpin.dox", dataType: "json", type: "POST", data: {notificationId: id},
					success(d) { d.result === 'success' ? self.fnList() : alert(d.message || '고정 해제에 실패했습니다.'); },
					error() { alert('서버 오류가 발생했습니다.'); }
				});
			},

			getBadgeClass(type) {
				return {ORDER:'notice', SYSTEM:'update', EVENT:'event', POLICY:'notice2', RENTAL:'update', INQUIRY:'gray'}[type] || 'gray';
			},
			getBadgeLabel(type) {
				return {ORDER:'공지', SYSTEM:'업데이트', EVENT:'이벤트', POLICY:'안내', RENTAL:'업데이트', INQUIRY:'일반'}[type] || '일반';
			},
			getTypeLabel(type) {
				return {ORDER:'서비스 소식', SYSTEM:'사이트 점검', EVENT:'이벤트', POLICY:'정책 변경', RENTAL:'서비스 소식', INQUIRY:'고객문의'}[type] || '전체';
			},
			formatDate(d)  { return d ? d.substring(0, 10).replace(/-/g, '.') : ''; },
			isNew(d)       { return d ? (new Date() - new Date(d)) / (1000*60*60*24) <= 7 : false; }
		},

		mounted() { this.fnList(); }
	});

	app.mount('#app');
</script>

</body>
</html>
