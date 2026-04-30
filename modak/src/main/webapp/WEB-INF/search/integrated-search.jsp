<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>통합검색 - 모닥모닥</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/search/search.css">
	</head>

	<body>
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div id="app">
				<div class="search-page">
					<div class="search-top">
						<h2>통합검색</h2>

						<div class="search-box">
							<input type="text" v-model="inputKeyword" placeholder="검색어를 입력하세요" @keyup.enter="fnSearch">
							<button type="button" @click="fnSearch">검색</button>
						</div>
					</div>

					<div v-if="emptyKeyword" class="empty-box">
						검색어를 입력해주세요.
					</div>

					<template v-else>
						<div class="search-summary-wrap">
							<div class="search-summary-box">
								'<strong>{{ searchedKeyword }}</strong>' 검색 결과입니다.
							</div>

							<div class="search-summary-divider"></div>

							<div class="search-filter-box">
								<label class="switch-filter">
									<input type="checkbox" v-model="filter.product">
									<span class="switch-slider"></span>
									<span class="switch-label">상품</span>
								</label>

								<label class="switch-filter">
									<input type="checkbox" v-model="filter.faq">
									<span class="switch-slider"></span>
									<span class="switch-label">FAQ</span>
								</label>

								<label class="switch-filter">
									<input type="checkbox" v-model="filter.event">
									<span class="switch-slider"></span>
									<span class="switch-label">이벤트</span>
								</label>

								<label class="switch-filter">
									<input type="checkbox" v-model="filter.camp">
									<span class="switch-slider"></span>
									<span class="switch-label">캠핑장</span>
								</label>
								<label class="switch-filter">
									<input type="checkbox" v-model="filter.community">
									<span class="switch-slider"></span>
									<span class="switch-label">커뮤니티</span>
								</label>
							</div>
						</div>

						<!-- 상품 -->
						<transition name="filter-section">
							<div v-show="filter.product" class="section-block">
								<div class="search-section">
									<div class="section-head">
										<h3>상품 검색결과 <span class="count-em">{{ result.productCount }}</span>건</h3>
									</div>

									<div v-if="result.productList.length > 0" class="product-card-grid">
										<div v-for="item in pagedProductList" :key="item.productId" class="product-card"
											@click="fnGoProductDetail(item.productId)">
											<img :src="item.thumbImgUrl" alt="상품 이미지">
											<div class="product-card-title">{{ item.productName }}</div>
											<div class="product-card-desc">{{ item.description }}</div>
											<div class="product-card-price">{{ fnFormatNumber(item.price) }}원</div>
										</div>
									</div>
									<div v-else class="empty-row">상품 검색 결과가 없습니다.</div>

									<div class="pagination" v-if="totalProductPage > 1">
										<button class="page-btn"
											@click="fnChangePage('product', page.product - 1)">이전</button>
										<button v-for="n in productPageNumbers" :key="'product-' + n" class="page-btn"
											:class="{ active: page.product === n }" @click="fnChangePage('product', n)">
											{{ n }}
										</button>

										<button class="page-btn"
											@click="fnChangePage('product', page.product + 1)">다음</button>
									</div>
								</div>
							</div>
						</transition>

						<!-- FAQ -->
						<transition name="filter-section">
							<div v-show="filter.faq" class="section-block">
								<div class="search-section">
									<div class="section-head">
										<h3>FAQ 검색결과 <span class="count-em">{{ result.faqCount }}</span>건</h3>
									</div>

									<div v-if="result.faqList.length > 0" class="search-list">
										<div v-for="item in pagedFaqList" :key="item.faqId"
											class="search-list-item faq-item">
											<div class="search-list-content">
												<div class="faq-q">Q. {{ item.question }}</div>
												<div class="faq-a">A. {{ item.answer }}</div>
												<div class="search-list-meta">{{ item.category }}</div>
											</div>
										</div>
									</div>
									<div v-else class="empty-row">FAQ 검색 결과가 없습니다.</div>

									<div class="pagination" v-if="totalFaqPage > 1">
										<button class="page-btn" @click="fnChangePage('faq', page.faq - 1)">이전</button>
										<button v-for="n in faqPageNumbers" :key="'faq-' + n" class="page-btn"
											:class="{ active: page.faq === n }" @click="fnChangePage('faq', n)">
											{{ n }}
										</button>
										<button class="page-btn" @click="fnChangePage('faq', page.faq + 1)">다음</button>
									</div>
								</div>
							</div>
						</transition>

						<!-- 이벤트 -->
						<transition name="filter-section">
							<div v-show="filter.event" class="section-block">
								<div class="search-section">
									<div class="section-head">
										<h3>이벤트 검색결과 <span class="count-em">{{ result.eventCount }}</span>건</h3>
									</div>

									<div v-if="result.eventList.length > 0" class="search-list">
										<div v-for="item in pagedEventList" :key="item.eventId" class="search-list-item"
											@click="fnGoEventDetail(item.eventId)">
											<img v-if="item.thumbImgUrl" :src="item.thumbImgUrl"
												class="search-list-thumb">

											<div class="search-list-content">
												<div class="search-list-title">{{ item.title }}</div>
												<div class="search-list-desc">{{ item.content }}</div>
												<div class="search-list-meta">
													{{ item.startAt }} ~ {{ item.endAt }}
												</div>
											</div>
										</div>
									</div>
									<div v-else class="empty-row">이벤트 검색 결과가 없습니다.</div>

									<div class="pagination" v-if="totalEventPage > 1">
										<button class="page-btn"
											@click="fnChangePage('event', page.event - 1)">이전</button>
										<button v-for="n in eventPageNumbers" :key="'event-' + n" class="page-btn"
											:class="{ active: page.event === n }" @click="fnChangePage('event', n)">
											{{ n }}
										</button>
										<button class="page-btn"
											@click="fnChangePage('event', page.event + 1)">다음</button>
									</div>
								</div>
							</div>
						</transition>

						<!-- 캠핑장 -->
						<transition name="filter-section">
							<div v-show="filter.camp" class="section-block">
								<div class="search-section">
									<div class="section-head">
										<h3>캠핑장 검색결과 <span class="count-em">{{ result.campCount }}</span>건</h3>
									</div>

									<div v-if="result.campList.length > 0" class="search-list">
										<div v-for="item in pagedCampList" :key="item.campId" class="search-list-item"
											@click="fnGoCampDetail(item.campId)">
											<img v-if="item.thumbImgUrl" :src="item.thumbImgUrl"
												class="search-list-thumb">

											<div class="search-list-content">
												<div class="search-list-title">{{ item.campName }}</div>
												<div class="search-list-desc">{{ item.description }}</div>
												<div class="search-list-meta">
													{{ item.address }} · {{ item.induty }}
												</div>
											</div>
										</div>
									</div>
									<div v-else class="empty-row">캠핑장 검색 결과가 없습니다.</div>

									<div class="pagination" v-if="totalCampPage > 1">
										<button class="page-btn"
											@click="fnChangePage('camp', page.camp - 1)">이전</button>
										<button v-for="n in campPageNumbers" :key="'camp-' + n" class="page-btn"
											:class="{ active: page.camp === n }" @click="fnChangePage('camp', n)">
											{{ n }}
										</button>
										<button class="page-btn"
											@click="fnChangePage('camp', page.camp + 1)">다음</button>
									</div>
								</div>
							</div>
						</transition>
						<transition name="filter-section">
							<div v-show="filter.community" class="section-block">
								<div class="search-section">
									<div class="section-head">
										<h3>커뮤니티 검색결과 <span class="count-em">{{ result.communityCount }}</span>건</h3>
									</div>

									<div v-if="result.communityList.length > 0" class="search-list">
										<div v-for="item in result.communityList" :key="item.boardId"
											class="search-list-item" @click="fnGoBoardDetail(item.boardId)">

											<div class="search-list-content">
												<div class="search-list-title">{{ item.title }}</div>
												<div class="search-list-desc">
													{{ item.content.replace(/\n/g, ' ') }}
												</div>
												<div class="search-list-meta">
													{{ item.userId }} · {{ item.createdAt }}
												</div>
											</div>
										</div>
									</div>

									<div v-else class="empty-row">커뮤니티 검색 결과가 없습니다.</div>
								</div>
							</div>
						</transition>


					</template>
				</div>
			</div>

			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					const app = Vue.createApp({
						data() {
							return {
								inputKeyword: "${param.keyword != null ? param.keyword : ''}",
								searchedKeyword: "",
								emptyKeyword: false,
								result: {
									productList: [],
									faqList: [],
									eventList: [],
									campList: [],
									communityList: [],
									productCount: 0,
									faqCount: 0,
									eventCount: 0,
									campCount: 0,
									communityCount: 0
								},
								filter: {
									product: true,
									faq: true,
									event: true,
									camp: true,
									community: true
								},
								page: {
									product: 1,
									faq: 1,
									event: 1,
									camp: 1
								},
								pageSize: {
									product: 8,
									faq: 5,
									event: 5,
									camp: 5
								}
							};
						},
						computed: {
							pagedProductList() {
								const start = (this.page.product - 1) * this.pageSize.product;
								return this.result.productList.slice(start, start + this.pageSize.product);
							},
							pagedFaqList() {
								const start = (this.page.faq - 1) * this.pageSize.faq;
								return this.result.faqList.slice(start, start + this.pageSize.faq);
							},
							pagedEventList() {
								const start = (this.page.event - 1) * this.pageSize.event;
								return this.result.eventList.slice(start, start + this.pageSize.event);
							},
							pagedCampList() {
								const start = (this.page.camp - 1) * this.pageSize.camp;
								return this.result.campList.slice(start, start + this.pageSize.camp);
							},
							productPageNumbers() {
								return this.getPageNumbers(this.page.product, this.totalProductPage);
							},
							faqPageNumbers() {
								return this.getPageNumbers(this.page.faq, this.totalFaqPage);
							},
							eventPageNumbers() {
								return this.getPageNumbers(this.page.event, this.totalEventPage);
							},
							campPageNumbers() {
								return this.getPageNumbers(this.page.camp, this.totalCampPage);
							},

							totalProductPage() {
								return Math.ceil(this.result.productList.length / this.pageSize.product) || 1;
							},
							totalFaqPage() {
								return Math.ceil(this.result.faqList.length / this.pageSize.faq) || 1;
							},
							totalEventPage() {
								return Math.ceil(this.result.eventList.length / this.pageSize.event) || 1;
							},
							totalCampPage() {
								return Math.ceil(this.result.campList.length / this.pageSize.camp) || 1;
							}
						},
						methods: {
							fnSearch: function () {
								let self = this;

								if (!self.inputKeyword || !self.inputKeyword.trim()) {
									self.emptyKeyword = true;
									self.result = {
										productList: [],
										faqList: [],
										eventList: [],
										campList: [],
										productCount: 0,
										faqCount: 0,
										eventCount: 0,
										campCount: 0
									};
									return;
								}

								const requestKeyword = self.inputKeyword.trim();

								self.emptyKeyword = false;

								$.ajax({
									url: "/search/integrated.dox",
									type: "POST",
									dataType: "json",
									data: {
										keyword: requestKeyword
									},
									success: function (data) {
										self.result = data;
										self.emptyKeyword = data.emptyKeyword;

										self.searchedKeyword = requestKeyword;

										self.page.product = 1;
										self.page.faq = 1;
										self.page.event = 1;
										self.page.camp = 1;
									},
									error: function () {
										alert("검색 중 오류가 발생했습니다.");
									}
								});
							},
							fnGoProductDetail: function (productId) {
								pageChange("/product/detail.do", {
									productId: productId
								});
							},
							fnGoBoardDetail(boardId) {
								pageChange("/board/detail.do", {
									boardId: boardId
								});
							},
							getPageNumbers(currentPage, totalPage) {
								const blockSize = 5;
								const startPage = Math.floor((currentPage - 1) / blockSize) * blockSize + 1;
								const endPage = Math.min(startPage + blockSize - 1, totalPage);

								const pages = [];
								for (let i = startPage; i <= endPage; i++) {
									pages.push(i);
								}
								return pages;
							},

							fnGoEventDetail: function (eventId) {
								pageChange("/event/detail.do", {
									eventId: eventId
								});
							},

							fnGoCampDetail: function (contentId) {
								pageChange("/camp/map.do", {
									campId: contentId
								});
							},

							fnFormatNumber: function (value) {
								if (!value) {
									return "0";
								}
								return Number(value).toLocaleString();
							},
							fnChangePage: function (type, page) {
								if (page < 1) return;

								const totalPageMap = {
									product: this.totalProductPage,
									faq: this.totalFaqPage,
									event: this.totalEventPage,
									camp: this.totalCampPage
								};

								if (page > totalPageMap[type]) return;

								this.page[type] = page;
							},
							toggleAll() {
								const allOn = this.filter.product && this.filter.faq && this.filter.event && this.filter.camp;

								this.filter.product = !allOn;
								this.filter.faq = !allOn;
								this.filter.event = !allOn;
								this.filter.camp = !allOn;
							}
						},
						mounted() {
							if (this.inputKeyword && this.inputKeyword.trim()) {
								this.fnSearch();
							} else {
								this.emptyKeyword = true;
							}
						}
					});

					app.mount("#app");
				</script>
	</body>

	</html>