<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>이벤트 상세 - 모닥모닥</title>

		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

		<!-- Vue 스크립트 -->
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<link href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.2.0/remixicon.min.css" rel="stylesheet">

		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/event/event-detail.css">
	</head>

	<body>
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div id="app" v-cloak>
				<div class="breadcrumb">
					<a href="${pageContext.request.contextPath}/main.do">홈</a>
					<span>›</span>
					<a href="${pageContext.request.contextPath}/event/list.do">이벤트</a>
					<span>›</span>
					<span class="cur">{{ eventInfo.title || '상세보기' }}</span>
				</div>

				<main>
					<div v-if="isLoading" class="loading-box">
						<div class="spin"></div>
						<span>불러오는 중...</span>
					</div>
					<div v-else-if="errorMsg" class="error-box">
						<i class="ri-error-warning-line"></i>
						<span>{{ errorMsg }}</span>
					</div>

					<div v-else class="detail-card">
						<div class="detail-image" v-if="eventInfo.imgPath">
							<span class="detail-badge" :class="badgeClass">
								{{ badgeText }}
							</span>

							<img :src="contextPath + eventInfo.imgPath" alt="이벤트 이미지" class="event-detail-img"
								@load="fnMoveTop">
						</div>

						<div class="detail-body">
							<div class="detail-meta">
								<span class="meta-date">
									📅 {{ eventInfo.startDate }} ~ {{ eventInfo.endDate }}
								</span>
							</div>

							<h1 class="detail-title">
								{{ eventInfo.title }}
							</h1>

							<div class="detail-divider"></div>

							<img v-for="img in eventInfo.imgList" :key="img.eventImgId" :src="contextPath + img.imgUrl"
								alt="이벤트 상세 이미지" class="event-content-img" @load="fnMoveTop">

							<div class="detail-content">
								{{ eventInfo.content }}
							</div>

						</div>
					</div>

					<a href="${pageContext.request.contextPath}/event/list.do" class="btn-back">
						목록으로 돌아가기
					</a>
				</main>
				<button class="floating-top-btn" :class="{ show: showTopBtn }" @click="fnMoveTop">
					<i class="ri-arrow-up-line"></i>
				</button>
			</div>

			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					const app = Vue.createApp({
						data() {
							return {
								contextPath: "${pageContext.request.contextPath}",
								eventId: "${map.eventId}",

								eventInfo: {},
								isLoading: true,
								errorMsg: "",
								showTopBtn: false,
							};
						},

						computed: {
							isEnded: function () {
								if (!this.eventInfo.endDate) {
									return false;
								}

								let today = new Date();
								today.setHours(0, 0, 0, 0);

								let endDate = new Date(this.eventInfo.endDate);
								endDate.setHours(0, 0, 0, 0);

								return endDate < today;
							},

							badgeClass: function () {
								return this.isEnded ? "badge-ended" : "badge-ongoing";
							},

							badgeText: function () {
								return this.isEnded ? "종료된 이벤트" : "진행중인 이벤트";
							}
						},

						methods: {
							fnGetEventInfo: function () {
								let self = this;

								if (!self.eventId || self.eventId === "null" || self.eventId === "undefined") {
									self.errorMsg = "잘못된 접근입니다.";
									self.isLoading = false;

									setTimeout(function () {
										location.href = self.contextPath + "/event/list.do";
									}, 900);

									return;
								}

								$.ajax({
									url: self.contextPath + "/event/info.dox",
									type: "POST",
									dataType: "json",
									data: {
										eventId: self.eventId
									},
									success: function (data) {
										if (data.result === "success" && data.info) {
											self.eventInfo = data.info;

											self.$nextTick(function () {
												self.fnMoveTop();
											});
										} else {
											self.errorMsg = data.message || "이벤트 정보를 불러오지 못했습니다.";

											setTimeout(function () {
												location.href = self.contextPath + "/event/list.do";
											}, 900);
										}

										self.isLoading = false;
									},
									error: function (xhr) {
										self.errorMsg = "서버 연결 오류(" + xhr.status + ")";
										self.isLoading = false;

										setTimeout(function () {
											location.href = self.contextPath + "/event/list.do";
										}, 900);
									}
								});
							},

							fnMoveTop: function () {
								window.scrollTo({
									top: 0,
									behavior: "smooth"
								});
							},

							fnHandleScroll: function () {
								this.showTopBtn = window.scrollY > 300;
							}
						},

						mounted() {
							this.fnGetEventInfo();
							window.addEventListener("scroll", this.fnHandleScroll);
						},

						unmounted() {
							window.removeEventListener("scroll", this.fnHandleScroll);
						}
					});

					app.mount("#app");
				</script>
	</body>

	</html>