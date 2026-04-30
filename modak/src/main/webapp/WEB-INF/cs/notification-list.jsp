<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>공지사항 - 모닥모닥</title>

		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-list.css">
	</head>

	<body>

		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div class="notice-page" id="app">

				<section class="notice-hero">
					<div class="notice-inner">
						<div class="notice-hero-box">
							<div>
								<div class="page-kicker">MODAK NOTICE</div>
								<h1 class="page-title">공지사항</h1>
								<p class="page-desc">모닥모닥의 서비스 안내, 점검, 이벤트 소식을 확인하세요.</p>
							</div>
						</div>
					</div>
				</section>

				<main class="notice-main">
					<div class="notice-inner notice-layout">

						<aside class="notice-side">
							<div class="side-head">
								<div class="side-title">공지 분류</div>
								<div class="side-desc">필요한 안내만 골라보세요.</div>
							</div>

							<div class="side-tab-list">
								<div class="side-indicator" :style="indicatorStyle"></div>

								<button type="button" class="side-tab" :class="{ active: selectedType === '' }"
									@click="selectType('')">
									<span>전체</span>
								</button>

								<button type="button" class="side-tab" :class="{ active: selectedType === 'ORDER' }"
									@click="selectType('ORDER')">
									<span>서비스 소식</span>
								</button>

								<button type="button" class="side-tab" :class="{ active: selectedType === 'SYSTEM' }"
									@click="selectType('SYSTEM')">
									<span>사이트 점검</span>
								</button>

								<button type="button" class="side-tab" :class="{ active: selectedType === 'EVENT' }"
									@click="selectType('EVENT')">
									<span>이벤트</span>
								</button>

								<button type="button" class="side-tab" :class="{ active: selectedType === 'POLICY' }"
									@click="selectType('POLICY')">
									<span>환경설정</span>
								</button>
							</div>
						</aside>

						<section class="notice-content">
							<div class="content-head">
								<div>
									<h2 class="content-title">공지 목록</h2>
									<p class="content-desc">총 <strong>{{ totalCount }}</strong>건의 공지사항이 있습니다.</p>
								</div>

								<div class="search-area">
									<div class="search-input-wrap">
										<input type="text" v-model="keyword" placeholder="검색어를 입력하세요"
											@keyup.enter="fnSearch">
										<button type="button" class="search-btn" @click="fnSearch">검색</button>
									</div>

									<select class="sort-select" v-model="sort" @change="onSortChange">
										<option value="newest">최신순</option>
										<option value="oldest">오래된순</option>
										<option value="viewCount">조회수순</option>
									</select>
								</div>
							</div>

							<div class="notice-list-card">
								<div class="notice-table-head" :class="{ admin: isAdmin }">
									<div class="col-num">번호</div>
									<div class="col-title">제목</div>
									<div class="col-type">분류</div>
									<div class="col-date">등록일</div>
									<div class="col-view">조회수</div>
									<div class="col-admin" v-if="isAdmin">고정</div>
								</div>

								<div class="notice-loading small" v-show="loading">불러오는 중...</div>

								<template v-if="pinnedList.length > 0 || list.length > 0">
									<div v-for="item in pinnedList" :key="'pin-' + item.notificationId"
										class="notice-row pinned" :class="{ admin: isAdmin }"
										@click="fnDetail(item.notificationId)">
										<div class="col-num">
											<span class="pin-label">공지</span>
										</div>

										<div class="col-title">
											<div class="title-line">
												<span class="n-badge" :class="getBadgeClass(item.type)">
													{{ getBadgeLabel(item.type) }}
												</span>
												<span class="title-text pinned-title">{{ item.title }}</span>
												<span class="new-dot" v-if="isNew(item.createdAt)"></span>
											</div>
										</div>

										<div class="col-type">{{ getTypeLabel(item.type) }}</div>
										<div class="col-date">{{ formatDate(item.createdAt) }}</div>
										<div class="col-view">{{ item.viewCount ? item.viewCount.toLocaleString() : 0 }}
										</div>

										<div class="col-admin" v-if="isAdmin">
											<button type="button" class="pin-btn unpin"
												@click.stop.prevent="openPinModal(item.notificationId, 'unpin')">
												해제
											</button>
										</div>
									</div>

									<div class="row-divider" v-if="pinnedList.length > 0 && list.length > 0">
										<span>일반 공지</span>
									</div>

									<div class="empty-box" v-if="!loading && list.length === 0 && pinnedList.length === 0">
										<div class="empty-title">등록된 공지사항이 없습니다.</div>
										<div class="empty-desc">검색어 또는 공지 분류를 다시 확인해 주세요.</div>
									</div>

									<div v-for="(item, index) in list" :key="'normal-' + item.notificationId"
										class="notice-row" :class="{ admin: isAdmin }"
										@click="fnDetail(item.notificationId)">
										<div class="col-num">
											{{ totalCount - ((currentPage - 1) * pageSize) - index }}
										</div>

										<div class="col-title">
											<div class="title-line">
												<span class="n-badge" :class="getBadgeClass(item.type)">
													{{ getBadgeLabel(item.type) }}
												</span>
												<span class="title-text">{{ item.title }}</span>
												<span class="new-dot" v-if="isNew(item.createdAt)"></span>
											</div>
										</div>

										<div class="col-type">{{ getTypeLabel(item.type) }}</div>
										<div class="col-date">{{ formatDate(item.createdAt) }}</div>
										<div class="col-view">{{ item.viewCount ? item.viewCount.toLocaleString() : 0 }}
										</div>

										<div class="col-admin" v-if="isAdmin">
											<button type="button" class="pin-btn pin"
												@click.stop.prevent="openPinModal(item.notificationId, 'pin')">
												고정
											</button>
										</div>
									</div>
								</template>
							</div>

							<div class="pagination" v-if="totalPage > 0">
								<button type="button" class="page-btn arrow" :class="{ disabled: currentPage === 1 }"
									@click="goPage(1)">«</button>
								<button type="button" class="page-btn arrow" :class="{ disabled: currentPage === 1 }"
									@click="goPage(currentPage - 1)">‹</button>

								<button type="button" class="page-btn" v-for="p in pageRange" :key="p"
									:class="{ active: currentPage === p }" @click="goPage(p)">
									{{ p }}
								</button>

								<button type="button" class="page-btn arrow"
									:class="{ disabled: currentPage === totalPage }"
									@click="goPage(currentPage + 1)">›</button>
								<button type="button" class="page-btn arrow"
									:class="{ disabled: currentPage === totalPage }"
									@click="goPage(totalPage)">»</button>
							</div>
						</section>
					</div>
				</main>

				<div class="modak-toast" :class="{ show: toast.show }">{{ toast.message }}</div>

				<div class="modal-backdrop" v-cloak v-if="mountedYn && confirmModal.show" @click.self="closePinModal">
					<div class="confirm-modal">
						<div class="confirm-title">{{ confirmModal.title }}</div>
						<div class="confirm-message">{{ confirmModal.message }}</div>
						<div class="confirm-actions">
							<button type="button" class="modal-btn cancel" @click.prevent="closePinModal">취소</button>
							<button type="button" class="modal-btn ok" @click.prevent="runPinAction">확인</button>
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
								sort: 'newest',
								loading: false,
								isAdmin: false,
								toast: { show: false, message: '' },

								toastTimer: null,
								mountedYn: false,
								confirmModal: { show: false, mode: '', notificationId: null, title: '', message: '' },
							};
						},

						computed: {
							indicatorStyle() {
								const indexMap = {
									'': 0,
									'ORDER': 1,
									'SYSTEM': 2,
									'EVENT': 3,
									'POLICY': 4
								};

								const index = indexMap[this.selectedType] ?? 0;

								return {
									transform: 'translateY(' + (index * 42) + 'px)'
								};
							},

							pageRange() {
								const gs = Math.floor((this.currentPage - 1) / this.pageGroupSize) * this.pageGroupSize + 1;
								const ge = Math.min(gs + this.pageGroupSize - 1, this.totalPage);
								const pages = [];

								for (let i = gs; i <= ge; i++) {
									pages.push(i);
								}

								return pages;
							}
						},

						methods: {
							fnList() {
								const self = this;
								self.loading = true;

								$.ajax({
									url: "${pageContext.request.contextPath}/notification/list.dox",
									dataType: "json",
									type: "POST",
									data: {
										type: self.selectedType,
										keyword: self.keyword,
										sort: self.sort,
										startRow: (self.currentPage - 1) * self.pageSize,
										pageSize: self.pageSize
									},
									success(data) {
										if (data.result === 'success') {
											self.pinnedList = data.pinnedList || [];
											self.list = data.list || [];
											self.totalCount = data.totalCount || 0;
											self.totalPage = Math.ceil(self.totalCount / self.pageSize);
										} else {
											self.showToast('목록 조회에 실패했습니다.');
										}

										self.loading = false;
									},
									error() {
										self.showToast('서버 오류가 발생했습니다.');
										self.loading = false;
									}
								});
							},

							onSortChange() {
								this.currentPage = 1;
								this.fnList();
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

							fnDetail(id) {
								location.href = "${pageContext.request.contextPath}/notification/detail.do?notificationId=" + id;
							},

							goPage(page) {
								if (page < 1 || page > this.totalPage) {
									return;
								}

								this.currentPage = page;
								this.fnList();
							},

							openPinModal(id, mode) {
								if (document.activeElement) {
									document.activeElement.blur();
								}

								this.confirmModal = {
									show: true,
									mode: mode,
									notificationId: id,
									title: mode === 'pin' ? '공지 고정' : '고정 해제',
									message: mode === 'pin' ? '이 공지를 최상단에 고정할까요?' : '이 공지의 고정을 해제할까요?'
								};
							},

							closePinModal() {
								this.confirmModal.show = false;
							},

							runPinAction() {
								const id = this.confirmModal.notificationId;
								const mode = this.confirmModal.mode;

								this.closePinModal();

								if (mode === 'pin') {
									this.fnPin(id);
									return;
								}

								this.fnUnpin(id);
							},

							fnPin(id) {
								const self = this;

								$.ajax({
									url: "${pageContext.request.contextPath}/notification/pin.dox",
									dataType: "json",
									type: "POST",
									data: { notificationId: id },
									success(d) {
										if (d.result === 'success') {
											self.showToast('공지사항이 고정되었습니다.');
											self.fnList();
											return;
										}

										self.showToast(d.message || '고정 설정에 실패했습니다.');
									},
									error() {
										self.showToast('서버 오류가 발생했습니다.');
									}
								});
							},

							fnUnpin(id) {
								const self = this;

								$.ajax({
									url: "${pageContext.request.contextPath}/notification/unpin.dox",
									dataType: "json",
									type: "POST",
									data: { notificationId: id },
									success(d) {
										if (d.result === 'success') {
											self.showToast('공지 고정이 해제되었습니다.');
											self.fnList();
											return;
										}

										self.showToast(d.message || '고정 해제에 실패했습니다.');
									},
									error() {
										self.showToast('서버 오류가 발생했습니다.');
									}
								});
							},

							showToast(message) {
								this.toast.message = message;
								this.toast.show = true;

								clearTimeout(this.toastTimer);
								this.toastTimer = setTimeout(() => {
									this.toast.show = false;
								}, 1800);
							},

							getBadgeClass(type) {
								return {
									ORDER: 'notice',
									SYSTEM: 'update',
									EVENT: 'event',
									POLICY: 'notice2',
									RENTAL: 'update',
									INQUIRY: 'gray'
								}[type] || 'gray';
							},

							getBadgeLabel(type) {
								return {
									ORDER: '공지',
									SYSTEM: '업데이트',
									EVENT: '이벤트',
									POLICY: '안내',
									RENTAL: '업데이트',
									INQUIRY: '일반'
								}[type] || '일반';
							},

							getTypeLabel(type) {
								return {
									ORDER: '서비스 소식',
									SYSTEM: '사이트 점검',
									EVENT: '이벤트',
									POLICY: '정책 변경',
									RENTAL: '서비스 소식',
									INQUIRY: '고객문의'
								}[type] || '전체';
							},

							formatDate(d) {
								return d ? d.substring(0, 10).replace(/-/g, '.') : '';
							},

							isNew(d) {
								return d ? (new Date() - new Date(d)) / (1000 * 60 * 60 * 24) <= 7 : false;
							}
						},

						mounted() {
							this.mountedYn = true;
							this.fnList();
						}
					});

					app.mount('#app');
				</script>

	</body>

	</html>