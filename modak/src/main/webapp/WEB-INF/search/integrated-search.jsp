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
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
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
						<div class="result-section-wrap">

							<!-- 상품 -->
							<transition name="filter-section">
								<div v-show="filter.product" class="section-block" :ref="'section-product'"
									:style="{ order: fnSectionOrder('product') }">
									<div class="search-section">
										<div class="section-head">
											<h3>상품 검색결과 <span class="count-em">{{ result.productCount }}</span>건</h3>
										</div>

										<div v-if="result.productList.length > 0" class="product-card-grid">
											<div v-for="item in pagedProductList" :key="item.productId"
												class="product-card" @click="fnGoProductDetail(item.productId)">

												<div class="product-img-box" v-if="item.thumbImgUrl">
													<img :src="item.thumbImgUrl" alt="상품 이미지">
												</div>

												<div class="product-category-badge">
													{{ item.categoryName || '상품' }}
												</div>

												<div class="product-title-line">
													<span class="product-card-title">
														{{ item.productName }}
													</span>

													<template v-if="item.brandName">
														<span class="product-title-dot">·</span>
														<span class="product-brand-name">{{ item.brandName }}</span>
													</template>
												</div>

												<div class="product-rating-row">
													<div class="star-rating" :title="fnRatingText(item.ratingAvg)">
														<span class="star-item" v-for="n in 5"
															:key="'star-' + item.productId + '-' + n">
															<span class="star-empty">★</span>
															<span class="star-fill-one"
																:style="{ width: fnStarPercent(item.ratingAvg, n) }">★</span>
														</span>
													</div>

													<span class="rating-score">
														{{ fnRatingNumber(item.ratingAvg) }}
													</span>
													<span class="review-count">
														({{ item.reviewCount || 0 }})
													</span>
												</div>

												<div class="product-card-price">
													{{ fnFormatNumber(item.price) }}원
												</div>
											</div>
										</div>
										<div v-else class="empty-row">상품 검색 결과가 없습니다.</div>

										<div class="pagination" v-if="totalProductPage > 1">
											<button class="page-btn"
												@click="fnChangePage('product', page.product - 1)">이전</button>
											<button v-for="n in productPageNumbers" :key="'product-' + n"
												class="page-btn" :class="{ active: page.product === n }"
												@click="fnChangePage('product', n)">
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
								<div v-show="filter.faq" class="section-block" :ref="'section-faq'"
									:style="{ order: fnSectionOrder('faq') }">
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
											<button class="page-btn"
												@click="fnChangePage('faq', page.faq - 1)">이전</button>
											<button v-for="n in faqPageNumbers" :key="'faq-' + n" class="page-btn"
												:class="{ active: page.faq === n }" @click="fnChangePage('faq', n)">
												{{ n }}
											</button>
											<button class="page-btn"
												@click="fnChangePage('faq', page.faq + 1)">다음</button>
										</div>
									</div>
								</div>
							</transition>

							<!-- 이벤트 -->
							<transition name="filter-section">
								<div v-show="filter.event" class="section-block" :ref="'section-event'"
									:style="{ order: fnSectionOrder('event') }">
									<div class="search-section">
										<div class="section-head">
											<h3>이벤트 검색결과 <span class="count-em">{{ result.eventCount }}</span>건</h3>
										</div>

										<div v-if="result.eventList.length > 0" class="search-list">
											<div v-for="item in pagedEventList" :key="item.eventId"
												class="search-list-item" @click="fnGoEventDetail(item.eventId)">
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
								<div v-show="filter.camp" class="section-block" :ref="'section-camp'"
									:style="{ order: fnSectionOrder('camp') }">
									<div class="search-section">
										<div class="section-head">
											<h3>캠핑장 검색결과 <span class="count-em">{{ result.campCount }}</span>건</h3>
										</div>

										<div v-if="result.campList.length > 0" class="search-list">
											<div v-for="item in pagedCampList" :key="item.campId"
												class="search-list-item" @click="fnGoCampDetail(item.campId)">
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
								<div v-show="filter.community" class="section-block" :ref="'section-community'"
									:style="{ order: fnSectionOrder('community') }">
									<div class="search-section">
										<div class="section-head">
											<h3>커뮤니티 검색결과 <span class="count-em">{{ result.communityCount }}</span>건
											</h3>
										</div>

										<div v-if="result.communityList.length > 0" class="community-result-list">
											<div v-for="item in pagedCommunityList" :key="item.boardId"
												class="community-result-card" @click="fnGoBoardDetail(item.boardId)">

												<div class="community-result-body">
													<div class="community-category-pill">
														{{ fnCommunityCategoryLabel(item.category) }}
													</div>

													<div class="community-result-title">
														{{ item.title }}
													</div>

													<div class="community-result-desc" v-if="item.content">
														{{ fnPlainText(item.content) }}
													</div>

													<div class="community-result-meta">
														<span class="community-writer">
															{{ fnCommunityWriter(item) }}
														</span>

														<span class="community-dot">·</span>

														<span>
															{{ fnFormatDate(item.createdAt) }}
														</span>

														<span class="community-dot">·</span>

														<span class="community-icon-meta">
															<i class="ri-eye-line"></i>
															{{ item.viewCount || 0 }}
														</span>

														<span class="community-icon-meta like">
															<i class="ri-heart-3-fill"></i>
															{{ item.likeCount || 0 }}
														</span>

														<span class="community-icon-meta">
															<i class="ri-chat-3-line"></i>
															{{ item.commentCount || 0 }}
														</span>
													</div>
												</div>
												<div class="community-thumb-wrap" v-if="fnCommunityImage(item)">
													<img :src="fnCommunityImage(item)" alt="커뮤니티 이미지">
												</div>
											</div>
										</div>
										<div v-else class="empty-row">커뮤니티 검색 결과가 없습니다.</div>
									</div>
									<div class="pagination" v-if="totalCommunityPage > 1">
										<button class="page-btn"
											@click="fnChangePage('community', page.community - 1)">이전</button>

										<button v-for="n in communityPageNumbers" :key="'community-' + n"
											class="page-btn" :class="{ active: page.community === n }"
											@click="fnChangePage('community', n)">
											{{ n }}
										</button>

										<button class="page-btn"
											@click="fnChangePage('community', page.community + 1)">다음</button>
									</div>
								</div>
							</transition>

						</div>
					</template>
				</div>
				<button type="button" class="scroll-top-btn" v-show="showScrollTop" @click="fnScrollTop"
					aria-label="맨 위로 이동">
					<i class="ri-arrow-up-line"></i>
				</button>
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
									camp: 1,
									community: 1
								},
								pageSize: {
									product: 8,
									faq: 5,
									event: 5,
									camp: 5,
									community: 5
								},
								showScrollTop: false,
							};
						},
						computed: {
							orderedSectionKeys() {
								const defaultOrder = ['product', 'faq', 'event', 'camp', 'community'];

								const sections = [
									{
										key: 'product',
										count: Number(this.result.productCount || 0)
									},
									{
										key: 'faq',
										count: Number(this.result.faqCount || 0)
									},
									{
										key: 'event',
										count: Number(this.result.eventCount || 0)
									},
									{
										key: 'camp',
										count: Number(this.result.campCount || 0)
									},
									{
										key: 'community',
										count: Number(this.result.communityCount || 0)
									}
								];

								sections.sort((a, b) => {
									if (b.count !== a.count) {
										return b.count - a.count;
									}

									return defaultOrder.indexOf(a.key) - defaultOrder.indexOf(b.key);
								});

								return sections.map(section => section.key);
							},
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
							},
							pagedCommunityList() {
								const start = (this.page.community - 1) * this.pageSize.community;
								return this.result.communityList.slice(start, start + this.pageSize.community);
							},

							communityPageNumbers() {
								return this.getPageNumbers(this.page.community, this.totalCommunityPage);
							},

							totalCommunityPage() {
								return Math.ceil(this.result.communityList.length / this.pageSize.community) || 1;
							}
						},
						methods: {
							fnHandleScroll: function () {
								this.showScrollTop = window.scrollY > 350;
							},

							fnScrollTop: function () {
								window.scrollTo({
									top: 0,
									behavior: "smooth"
								});
							},
							fnSearch: function () {
								let self = this;

								if (!self.inputKeyword || !self.inputKeyword.trim()) {
									self.emptyKeyword = true;
									self.result = {
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
										self.page.community = 1;
										const newUrl = "/search/integrated.do?keyword=" + encodeURIComponent(requestKeyword);
										history.replaceState(null, "", newUrl);
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
								location.href = "/board/detail.do?boardId=" + encodeURIComponent(boardId);
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
								if (page < 1) {
									return;
								}

								const totalPageMap = {
									product: this.totalProductPage,
									faq: this.totalFaqPage,
									event: this.totalEventPage,
									camp: this.totalCampPage,
									community: this.totalCommunityPage
								};

								if (page > totalPageMap[type]) {
									return;
								}

								this.page[type] = page;

								this.$nextTick(() => {
									this.fnScrollToSection(type);
								});
							},
							fnScrollToSection: function (type) {
								const refName = "section-" + type;
								let section = this.$refs[refName];

								if (Array.isArray(section)) {
									section = section[0];
								}

								if (!section) {
									return;
								}

								const headerOffset = 90;
								const targetTop = section.getBoundingClientRect().top + window.pageYOffset - headerOffset;

								window.scrollTo({
									top: targetTop,
									behavior: "smooth"
								});
							},
							toggleAll() {
								const allOn = this.filter.product && this.filter.faq && this.filter.event && this.filter.camp;

								this.filter.product = !allOn;
								this.filter.faq = !allOn;
								this.filter.event = !allOn;
								this.filter.camp = !allOn;
							},
							fnRatingNumber: function (value) {
								const rating = Number(value || 0);
								return rating.toFixed(1);
							},

							fnStarPercent: function (ratingValue, starIndex) {
								const rating = Number(ratingValue || 0);

								if (rating <= starIndex - 1) {
									return "0%";
								}

								if (rating >= starIndex) {
									return "100%";
								}

								return ((rating - (starIndex - 1)) * 100) + "%";
							},

							fnCommunityImage: function (item) {
								if (!item) {
									return "";
								}

								const directImage =
									item.thumbImgUrl ||
									item.thumbUrl ||
									item.THUMB_IMG_URL ||
									item.THUMBIMGURL ||
									item.IMG_URL ||
									item.imgUrl ||
									"";

								if (directImage) {
									return directImage;
								}

								if (!item.content) {
									return "";
								}

								const temp = document.createElement("div");
								temp.innerHTML = item.content;

								const img = temp.querySelector("img");

								if (!img) {
									return "";
								}

								return img.getAttribute("src") || "";
							},

							fnRatingText: function (value) {
								return "평점 " + this.fnRatingNumber(value) + "점";
							},
							fnPlainText: function (text) {
								if (!text) {
									return "";
								}

								const temp = document.createElement("div");
								temp.innerHTML = text;

								return (temp.textContent || temp.innerText || "")
									.replace(/\n/g, " ")
									.replace(/\s+/g, " ")
									.trim();
							},

							fnCommunityCategoryLabel: function (category) {
								const map = {
									FREE: "자유",
									REVIEW: "후기",
									TIP: "꿀팁",
									QNA: "Q&A"
								};
								return map[category] || category || "커뮤니티";
							},

							fnFormatDate: function (value) {
								if (!value) {
									return "";
								}

								const date = new Date(value);
								if (isNaN(date.getTime())) {
									return String(value).slice(0, 10);
								}

								const now = new Date();
								const diff = Math.floor((now - date) / 1000);

								if (diff < 60) {
									return "방금 전";
								}

								if (diff < 3600) {
									return Math.floor(diff / 60) + "분 전";
								}

								if (diff < 86400) {
									return Math.floor(diff / 3600) + "시간 전";
								}

								return String(value).slice(0, 10);
							}, fnSectionOrder: function (type) {
								const index = this.orderedSectionKeys.indexOf(type);
								return index === -1 ? 99 : index + 1;
							}, fnCommunityWriter: function (item) {
								return item.userName
									|| item.USER_NAME
									|| item.nickname
									|| item.NICKNAME
									|| item.nickName
									|| item.userId
									|| item.USER_ID
									|| '알 수 없음';
							},
						},
						mounted() {
							if (this.inputKeyword && this.inputKeyword.trim()) {
								this.fnSearch();
							} else {
								this.emptyKeyword = true;
							}

							this.fnHandleScroll();
							window.addEventListener("scroll", this.fnHandleScroll);
						},
						beforeUnmount() {
							window.removeEventListener("scroll", this.fnHandleScroll);
						}
					});

					app.mount("#app");
				</script>
	</body>

	</html>