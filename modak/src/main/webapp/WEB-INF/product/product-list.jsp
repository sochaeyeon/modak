<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>상품 - 모닥모닥</title>

		<link rel="stylesheet" href="/css/product/product-list.css">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.2.0/remixicon.min.css" rel="stylesheet">
	</head>

	<body>
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div id="app" class="product-page" v-cloak>
				<!-- ── 메인 컨텐츠 영역 ── -->
				<div class="page-wrap">
					<div class="main-banner event-code-banner" @click="fnGoEvent">
						<div class="event-banner-content">
							<div class="event-banner-left">
								<div class="event-banner-badge">
									<i class="ri-gift-line"></i>
									진행 중인 이벤트
								</div>

								<h2 class="event-banner-title">
									모닥모닥 회원 혜택 모아보기
								</h2>

								<p class="event-banner-desc">
									리뷰 이벤트, 쿠폰 혜택, 시즌 프로모션까지<br>
									지금 참여 가능한 이벤트를 확인해보세요.
								</p>

								<div class="event-banner-link">
									이벤트 보러가기
									<i class="ri-arrow-right-line"></i>
								</div>
							</div>

							<div class="event-banner-right">
								<div class="event-circle main">
									<i class="ri-coupon-3-line"></i>
								</div>
								<div class="event-circle sub">
									<i class="ri-chat-smile-2-line"></i>
								</div>
								<div class="event-circle small">
									<i class="ri-heart-3-line"></i>
								</div>
							</div>
						</div>
					</div>
					<div class="top-row">
						<div class="result-info">
							<div class="result-label">{{ getSortLabel() }}</div>
							<div>
								<span class="result-title">{{ getCurrentCategoryName() }}</span>
								<span class="result-count">총 {{ products.length }}개</span>
							</div>
						</div>
						<!-- 검색창 -->
						<div class="search-box">
							<input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요" @keyup.enter="fnSearch">
							<button type="button" class="search-clear" v-show="searchKeyword" @click="searchKeyword = ''; fnSearch()">
								<i class="ri-close-line"></i>
							</button>
							<button type="button" @click="fnSearch">검색</button>
						</div>
						<div class="controls">
							<button class="filter-toggle" :class="{ active: sidebarVisible }"
								@click="sidebarVisible = !sidebarVisible">
								<i class="ri-filter-3-line"></i>
								필터
							</button>
							<select class="sort-select" v-model="sortKey" @change="fnSearch">
								<option value="popular">인기순</option>
								<option value="newest">최신순</option>
								<option value="review-count">리뷰 많은순</option>
								<option value="price-low">가격 낮은순</option>
								<option value="price-high">가격 높은순</option>
								<option value="rating">별점순</option>
							</select>
							<div class="view-toggle" :class="currentView">
								<button class="vbtn" type="button" :class="{ active: currentView === 'grid' }"
									@click="currentView = 'grid'" title="그리드 보기">
									<i class="ri-layout-grid-line"></i>
								</button>

								<button class="vbtn" type="button" :class="{ active: currentView === 'list' }"
									@click="currentView = 'list'" title="리스트 보기">
									<i class="ri-list-check"></i>
								</button>
							</div>
						</div>
					</div>
					<div class="active-filter-bar" v-if="activeFilters.length > 0">
						<div class="active-filter-chip" v-for="f in activeFilters" :key="f.key">
							{{ f.label }}
							<i class="ri-close-line" @click="removeFilter(f)"></i>
						</div>
						<button type="button" class="active-filter-clear" @click="resetFilter">
							전체 초기화
						</button>
					</div>
					<div class="content-wrap" :class="{ 'no-sidebar': !sidebarVisible }">

						<div class="sidebar" v-show="sidebarVisible">
							<div class="filter-section">
								<div class="fs-header" @click="filterOpen.type = !filterOpen.type">
									<span class="fs-title">대여 / 구매</span>
									<i class="ri-arrow-down-s-line fs-toggle" :class="{ open: filterOpen.type }"></i>
								</div>

								<div class="filter-opts filter-panel" :class="{ open: filterOpen.type }">
									<label class="type-chip">
										<input type="checkbox" v-model="filter.rentable" @change="fnSearch">
										<span class="chip-check"><i class="ri-check-line"></i></span>
										<span class="chip-text">대여 가능</span>
									</label>

									<label class="type-chip">
										<input type="checkbox" v-model="filter.buyable" @change="fnSearch">
										<span class="chip-check"><i class="ri-check-line"></i></span>
										<span class="chip-text">구매 가능</span>
									</label>
								</div>
							</div>

							<div class="filter-section category-section">
								<div class="fs-header" @click="filterOpen.category = !filterOpen.category">
									<span class="fs-title">카테고리</span>
									<i class="ri-arrow-down-s-line fs-toggle"
										:class="{ open: filterOpen.category }"></i>
								</div>

								<div class="category-tree filter-panel" :class="{ open: filterOpen.category }">
									<div v-for="parent in category" :key="parent.categoryId">
										<button type="button" class="category-parent"
											:class="{ open: openParent === parent.categoryId }"
											@click.stop="clickParent(parent.categoryId)">
											{{ parent.categoryName }}
											<svg class="arrow" viewBox="0 0 24 24">
												<polyline points="6 9 12 15 18 9"></polyline>
											</svg>
										</button>

										<div v-show="openParent === parent.categoryId" class="child-wrap">
											<label class="fopt child" v-for="child in parent.childList"
												:key="child.categoryId">
												<input type="radio" :value="child.categoryId" v-model="currentChild"
													@change="selectChild(parent.categoryId, child.categoryId)">
												{{ child.categoryName }}
											</label>
										</div>
									</div>
								</div>
							</div>

							<div class="filter-section">
								<div class="fs-header" @click="filterOpen.brand = !filterOpen.brand">
									<span class="fs-title">브랜드</span>
									<i class="ri-arrow-down-s-line fs-toggle" :class="{ open: filterOpen.brand }"></i>
								</div>

								<div class="filter-opts filter-panel" :class="{ open: filterOpen.brand }">
									<div class="brand-all" v-if="filter.brandId.length === 0">
										전체 브랜드
									</div>

									<label class="fopt" v-for="brand in brandList" :key="brand.brandId">
										<input type="checkbox" :value="brand.brandId" v-model="filter.brandId"
											@change="fnSearch">
										{{ brand.brandName }}
									</label>
								</div>
							</div>
							<div class="filter-section price-filter">
								<div class="fs-header" @click="filterOpen.price = !filterOpen.price">
									<span class="fs-title">가격</span>

									<div class="fs-right">
										<span class="range-value">{{ priceText }}</span>
										<i class="ri-arrow-down-s-line fs-toggle"
											:class="{ open: filterOpen.price }"></i>
									</div>
								</div>

								<div class="filter-panel" :class="{ open: filterOpen.price }">

									<div class="price-guide-row">
										<span>0원</span>
										<span>5만원</span>
										<span>10만원</span>
									</div>

									<div class="price-slider-box">
										<input type="range" min="0" max="100000" step="5000"
											v-model.number="filter.priceMax"
											:style="{ '--range-percent': pricePercent + '%' }" @input="fnPriceInput"
											class="price-range">
									</div>
								</div>
							</div>

							<div class="sidebar-bottom-sticky">
								<button class="filter-reset" type="button" @click="resetFilter">
									<i class="ri-refresh-line"></i>
									필터 초기화
								</button>
							</div>
						</div>

						<div class="grid-wrap">

							<div v-if="loading" class="empty">
								<div>
									<div class="empty-icon loading-icon">
										<i class="ri-loader-4-line"></i>
									</div>
									<div class="empty-msg">장비를 불러오는 중입니다...</div>
								</div>
							</div>
							<div v-else-if="pagedProducts.length === 0" class="empty">
								<div>
									<div class="empty-icon">
										<i class="ri-search-eye-line"></i>
									</div>
									<div class="empty-msg">해당 조건의 장비가 없습니다</div>
								</div>
							</div>

							<div v-else :class="['product-grid', currentView === 'list' ? 'view-list' : '']">
								<div v-for="product in pagedProducts" :key="product.productId" class="pcard"
									:class="{ 'list-card': currentView === 'list' }" @click="fnView(product.productId)">

									<div class="pcard-img">
										<img :src="product.imgUrl || '/img/product/default.jpg'" class="pcard-photo"
											alt="상품 이미지">

										<div class="type-badge"
											:class="product.productType === 'RENTAL' ? 'type-rent' : 'type-buy'">
											<i :class="product.productType === 'RENTAL' ? 'ri-calendar-check-line' : 'ri-shopping-bag-3-fill'"></i>
											<span>{{ product.productType === 'RENTAL' ? '대여' : '구매' }}</span>
										</div>
									</div>
									<button class="wish-btn" type="button"
										:class="{ on: wishedIds.has(product.productId) }"
										@click.stop="fnWishVue($event, product.productId)">
										<i
											:class="wishedIds.has(product.productId) ? 'ri-heart-fill' : 'ri-heart-line'"></i>
									</button>

									<div class="pcard-body">
										<div class="pcard-top">
											<template v-if="currentView === 'list'">
												<div class="pcard-main">
													<div class="social-badge"
														v-if="product.rCount >= 10 && product.rating >= 4.5">
														<i class="ri-fire-fill"></i> 리뷰 {{ product.rCount }}개
													</div>
													<div class="pcard-cat">{{ product.categoryName }}</div>
													<div class="pcard-name">
														{{ product.productName }}
														<span class="brand">· {{ product.brandName }}</span>
													</div>

													<div class="stars">
														<span v-html="starsHTML(product.rating)"></span>
														<span class="star-count">
															{{ formatRating(product.rating) }} ({{ product.rCount || 0
															}})
														</span>
													</div>
												</div>

												<div class="pcard-price-wrap">
													<div class="price-row" style="justify-content:flex-end">
														<span class="price-main">{{ (product.price ||
															0).toLocaleString() }}원</span>
														<span class="price-unit"
															v-if="product.productType !== 'PURCHASE'">/ 1박</span>
													</div>
												</div>
											</template>

											<template v-else>
												<div class="social-badge"
													v-if="product.rCount >= 10 && product.rating >= 4.5">
													<i class="ri-fire-fill"></i> 리뷰 {{ product.rCount }}개
												</div>
												<div class="pcard-cat">{{ product.categoryName }}</div>
												<div class="pcard-name">
													{{ product.productName }}
													<span v-if="product.brandName" class="pcard-brand">· {{
														product.brandName }}</span>
												</div>

												<div class="stars">
													<span v-html="starsHTML(product.rating)"></span>
													<span class="star-count">
														{{ formatRating(product.rating) }} ({{ product.rCount || 0 }})
													</span>
												</div>

												<div class="price-row">
													<span class="price-main">{{ (product.price || 0).toLocaleString()
														}}원</span>
													<span class="price-unit" v-if="product.productType !== 'PURCHASE'">/
														1박</span>
												</div>
											</template>
										</div>										
									</div>
								</div>
							</div>


						</div>
					</div>

					<div class="recent-sidebar" v-if="recentList.length > 0"
						:class="{ 'is-expanded': recentExpanded }"
						:style="{ left: recentLeft + 'px' }">
						<div class="recent-head">
							<h3><i class="ri-history-line"></i> 최근 본</h3>
						</div>
						<div class="recent-scroll">
							<div class="recent-mini-card" v-for="item in visibleRecentList" :key="item.productId"
								@click="fnView(item.productId)" :title="item.productName">
								<img :src="item.imgUrl || '/img/product/default.jpg'" :alt="item.productName">
							</div>
						</div>
						<div class="recent-scroll recent-extra" v-show="recentExpanded">
							<div class="recent-mini-card" v-for="item in extraRecentList" :key="item.productId"
								@click="fnView(item.productId)" :title="item.productName">
								<img :src="item.imgUrl || '/img/product/default.jpg'" :alt="item.productName">
							</div>
						</div>
						<button type="button" class="recent-toggle" v-if="recentList.length > 4"
							@click="recentExpanded = !recentExpanded">
							{{ recentExpanded ? '접기' : '더보기' }}
							<i class="ri-arrow-down-s-line" :class="{ open: recentExpanded }"></i>
						</button>
					</div>

					<div v-if="confirmModal.open" class="confirm-overlay" @click.self="confirmCancel">
						<div class="confirm-box">
							<div class="confirm-title">알림</div>
							<div class="confirm-message">{{ confirmModal.message }}</div>

							<div class="confirm-btns">
								<button type="button" class="confirm-cancel" @click="confirmCancel">
									{{ confirmModal.cancelText }}
								</button>
								<button type="button" class="confirm-ok" @click="confirmOk">
									{{ confirmModal.okText }}
								</button>
							</div>
						</div>
					</div>

					<button class="floating-top-btn" type="button" :class="{ show: showTopBtn }" @click="fnMoveTop">
						<i class="ri-arrow-up-line"></i>
					</button>
				</div>
			</div>
			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					if ('scrollRestoration' in history) {
						history.scrollRestoration = 'manual';
					}

					// ── 토스트 ──
					function showToast(msg) {
						var t = document.getElementById('toast');
						if (!t) {
							t = document.createElement('div');
							t.id = 'toast';
							t.style.cssText = 'position:fixed;bottom:30px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:10px 20px;border-radius:8px;font-size:13px;z-index:9999;display:none;';
							document.body.appendChild(t);
						}
						t.textContent = msg;
						t.style.display = 'block';
						setTimeout(function () { t.style.display = 'none'; }, 2200);
					}

					// ── 위시 토글 ──
					function fnWish(e, btn, no) {
						e.stopPropagation();
						$.ajax({
							url: '/user/wishlist/toggle.dox',
							type: 'POST',
							data: { productId: no },
							dataType: 'json',
							success: function (res) {
								if (res.result === 'success') {
									btn.classList.toggle('on');
									var isOn = btn.classList.contains('on');
									showToast(isOn ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
								} else {
									showToast('로그인이 필요합니다.');
								}
							}
						});
					}
					const { createApp } = Vue;

					createApp({

						data() {
							return {
								products: [],
								brandList: [],
								loading: false,

								category: [],    // 부모 카테고리 (pill 바)
								childCategory: [],    // 자식 카테고리 (사이드바) ← 추가
								currentCat: null,  // null = 전체  ← 'null' 문자열에서 수정
								currentChild: null,  // 선택된 자식 카테고리 ← 추가

								currentView: 'grid',
								sortKey: 'popular',
								currentPage: 1,
								perPage: 12,
								sidebarVisible: true,
								wishedIds: new Set(),
								recentList: [],
								recentLeft: 9999,
								recentExpanded: false,
								searchKeyword: '', // 검색어 변수
								priceRange: null, // 가격 필터링
								confirmModal: {
									open: false,
									message: '',
									okText: '확인',
									cancelText: '취소',
									onOk: null
								},
								openParent: null,
								filter: {
									rentable: true,
									buyable: true,
									brandId: [],
									priceMax: 100000
								},
								filterOpen: {
									type: true,
									category: true,
									brand: true,
									price: true
								},
								showTopBtn: false,
								filterTimer: null,
							};

						},

						computed: {
							pricePercent() {
								return (Number(this.filter.priceMax) / 100000) * 100;
							},
							priceText() {
								if (!this.filter.priceMax || this.filter.priceMax >= 100000) return '전체';
								return this.filter.priceMax.toLocaleString() + '원 이하';
							},
							pagedProducts() {
								return this.products;
							},

							totalPages() {
								return Math.ceil(this.products.length / this.perPage);
							},

							priceRangeLabel() {
								const v = Math.round(this.filter.priceRange * 500);
								return v >= 50000 ? '50,000원+' : v.toLocaleString() + '원';
							},
							activeFilters() {
								const list = [];

								if (this.currentChild !== null) {
									const parent = this.category.find(c => c.categoryId === this.currentCat);
									const child = parent ? parent.childList.find(c => c.categoryId === this.currentChild) : null;
									if (child) list.push({ key: 'category', label: child.categoryName });
								} else if (this.currentCat !== null) {
									const parent = this.category.find(c => c.categoryId === this.currentCat);
									if (parent) list.push({ key: 'category', label: parent.categoryName });
								}

								if (this.filter.rentable && !this.filter.buyable) {
									list.push({ key: 'rentable', label: '대여 가능' });
								}
								if (this.filter.buyable && !this.filter.rentable) {
									list.push({ key: 'buyable', label: '구매 가능' });
								}

								this.filter.brandId.forEach(bid => {
									const brand = this.brandList.find(b => b.brandId === bid);
									if (brand) list.push({ key: 'brand', value: bid, label: brand.brandName });
								});

								if (this.filter.priceMax < 100000) {
									list.push({ key: 'price', label: this.filter.priceMax.toLocaleString() + '원 이하' });
								}

								if (this.searchKeyword) {
									list.push({ key: 'keyword', label: '"' + this.searchKeyword + '"' });
								}

								return list;
							},
							// 최근 본 상품 - 앞 4개는 항상 노출
							visibleRecentList() {
								return this.recentList.slice(0, 4);
							},
							// 5~10번째는 '더보기' 클릭 시에만 노출
							extraRecentList() {
								return this.recentList.slice(4, 10);
							},
						},

						methods: {

							getSortLabel() {
								if (this.sortKey === 'popular') return '인기 장비';
								if (this.sortKey === 'newest') return '최신 장비';
								if (this.sortKey === 'review-count') return '리뷰 많은 순';
								if (this.sortKey === 'price-low') return '가격 낮은 순';
								if (this.sortKey === 'price-high') return '가격 높은 순';
								if (this.sortKey === 'rating') return '평점 높은 순';
								return '장비 목록';
							},

							// 별점 - 소수점 비율만큼 채우기
							starsHTML(rating) {
								let score = Number(rating) || 0;

								if (score < 0) {
									score = 0;
								}

								if (score > 5) {
									score = 5;
								}

								const percent = (score / 5) * 100;

								return ''
									+ '<span class="star-layer-wrap" aria-label="' + score.toFixed(1) + '점">'
									+ '  <span class="star-layer star-base">★★★★★</span>'
									+ '  <span class="star-layer star-fill" style="width:' + percent + '%">★★★★★</span>'
									+ '</span>';
							},
							formatRating(rating) {
								return (Number(rating) || 0).toFixed(1);
							},

							// ── 상품 목록 조회 ──
							fnList() {
								let self = this;
								if (self.products.length === 0) {
									self.loading = true;
								}

								let minP = null;
								let maxP = null;

								if (Number(self.filter.priceMax) < 100000) {
									maxP = Number(self.filter.priceMax);
								}

								let param = {
									categoryId: self.currentCat,
									childCatId: self.currentChild,
									sortKey: self.sortKey,
									rentable: self.filter.rentable,
									buyable: self.filter.buyable,
									brandId: self.filter.brandId.length > 0 ? self.filter.brandId : null,
									priceMin: minP,
									priceMax: maxP,
									searchKeyword: self.searchKeyword,
									searchKeywordNoSpace: (self.searchKeyword || '').replace(/\s+/g, '')
								};

								$.ajax({
									url: "/product/list.dox",
									dataType: "json",
									type: "POST",
									data: param,
									traditional: true,
									success: function (data) {
										self.products = Array.isArray(data.list) ? data.list : [];
										self.loading = false;

										$.ajax({
											url: "/user/wishlist/list.dox",
											type: "POST",
											dataType: "json",
											success: function (wRes) {
												if (wRes && wRes.result === "success" && Array.isArray(wRes.list)) {
													self.wishedIds = new Set(
														wRes.list.map(function (w) {
															return w.productId;
														})
													);
												} else {
													self.wishedIds = new Set();
												}
											},
											error: function () {
												self.wishedIds = new Set();
											}
										});
									},
									error: function () {
										self.products = [];
										self.loading = false;
									}
								});
							},

							fnSearch(keepScroll = true) {
								const scrollY = keepScroll ? window.scrollY : 0;

								this.currentPage = 1;
								clearTimeout(this.filterTimer);

								this.filterTimer = setTimeout(() => {
									this.fnList();

									this.$nextTick(() => {
										if (keepScroll) {
											window.scrollTo(0, scrollY);
										}
									});
								}, 120);
							},
							// ── 부모 카테고리 조회 (pill 바) ──
							fetchCategory() {
								let self = this;

								$.ajax({
									url: "/category/allList.dox",
									type: "POST",
									dataType: "json",
									success: function (data) {

										const map = {};
										const parents = [];

										data.list.forEach(c => {
											if (!c.parentId) {
												map[c.categoryId] = { ...c, childList: [] };
												parents.push(map[c.categoryId]);
											}
										});

										data.list.forEach(c => {
											if (c.parentId) {
												map[c.parentId]?.childList.push(c);
											}
										});

										self.category = parents;
									}
								});
							},
							// ── 현재 카테고리명 반환 ──
							getCurrentCategoryName() {
								if (this.currentCat === null) return '전체 장비';

								const parent = this.category.find(function (c) {
									return c.categoryId === this.currentCat;
								}, this);

								if (!parent) return '장비 목록';

								if (this.currentChild !== null) {
									const child = parent.childList.find(function (c) {
										return c.categoryId === this.currentChild;
									}, this);

									return child ? child.categoryName : parent.categoryName;
								}

								return parent.categoryName;
							},
							removeFilter(f) {
								if (f.key === 'category') {
									this.currentCat = null;
									this.currentChild = null;
									this.openParent = null;
								} else if (f.key === 'rentable') {
									this.filter.rentable = true;
									this.filter.buyable = true;
								} else if (f.key === 'buyable') {
									this.filter.rentable = true;
									this.filter.buyable = true;
								} else if (f.key === 'brand') {
									this.filter.brandId = this.filter.brandId.filter(id => id !== f.value);
								} else if (f.key === 'price') {
									this.filter.priceMax = 100000;
								} else if (f.key === 'keyword') {
									this.searchKeyword = '';
								}

								this.currentPage = 1;
								this.fnSearch(false);
							},
							resetFilter() {
								clearTimeout(this.filterTimer);

								this.filter = {
									rentable: true,
									buyable: true,
									brandId: [],
									priceMax: 100000
								};

								this.currentCat = null;
								this.currentChild = null;
								this.openParent = null;
								this.childCategory = [];
								this.currentPage = 1;
								this.searchKeyword = '';

								// 1. 전체 페이지 스크롤 맨 위로
								window.scrollTo({
									top: 0,
									behavior: 'smooth'
								});
								// 2. 사이드바 스크롤 맨 위로 (추가된 코드)
								const sidebar = document.querySelector('.sidebar');
								if (sidebar) {
									sidebar.scrollTo({
										top: 0,
										behavior: 'smooth'
									});
								}

								setTimeout(() => {
									this.fnSearch(false);
								}, 120);
							},
							fnView: function (productId) {
								location.href = "/product/detail.do?productId=" + productId;
							},

							fnGetRecentList: function () {
								let self = this;
								$.ajax({
									url: "/user/recent/list.dox",
									type: "POST",
									dataType: "json",
									data: { page: 1, pageSize: 10 },
									success: function (data) {
										self.recentList = (data.result === "success") ? (data.list || []).slice(0, 10) : [];
										self.fnUpdateRecentRight();
									},
									error: function () {
										self.recentList = [];
									}
								});
							},
							fnUpdateRecentRight: function () {
								this.$nextTick(() => {
									var gridEl = document.querySelector('.grid-wrap');
									if (!gridEl) return;
									var rect = gridEl.getBoundingClientRect();
									var gap = 16;
									// grid-wrap 우측 끝 + 간격 = 패널이 시작되어야 할 left 좌표
									this.recentLeft = rect.right + gap;
								});
							},
							fetchBrandList() {
								let self = this;
								$.ajax({
									url: "/product/brandList.dox", // 브랜드 목록 조회를 위한 URL
									dataType: "json",
									type: "POST",
									data: {}, // 필요 시 조건 전달
									success: function (data) {
										if (data.result === 'success') {
											self.brandList = data.list; // 서버에서 받은 리스트를 할당
										}
									},
									error: function (err) {
										console.error("브랜드 조회 실패:", err);
									}
								});
							},
							clearBrands() {
								this.filter.brandId = []; // 배열을 비워서 다른 체크를 모두 해제
								this.fnSearch();
							},
							fnWishVue(e, productId) {
								e.stopPropagation();

								let self = this;

								$.ajax({
									url: '/user/wishlist/toggle.dox',
									type: 'POST',
									data: { productId: productId },
									dataType: 'json',
									success: function (res) {
										if (!res || res.result !== 'success') {
											self.openConfirm(
												'찜하려면 로그인이 필요해요!🔥 \n 로그인하고 마음에 드는 상품을 저장해보세요!',
												function () {
													location.href = '/user/login.do';
												},
												'로그인하기',
												'취소'
											);
											return;
										}

										let newSet = new Set(self.wishedIds);

										if (newSet.has(productId)) {
											newSet.delete(productId);
											showToast('위시리스트에서 제거했어요');
										} else {
											newSet.add(productId);
											showToast('❤️ 위시리스트에 추가했어요!');
										}

										self.wishedIds = newSet;
									},
									error: function (xhr) {
										self.openConfirm(
											'찜하려면 로그인이 필요해요!🔥 \n 로그인하고 마음에 드는 상품을 저장해보세요!',
											function () {
												location.href = '/user/login.do';
											},
											'로그인하기',
											'취소'
										);
									}
								});
							},
							openConfirm(message, onOk, okText = '확인', cancelText = '취소') {
								this.confirmModal.message = message;
								this.confirmModal.onOk = onOk;
								this.confirmModal.okText = okText;
								this.confirmModal.cancelText = cancelText;
								this.confirmModal.open = true;
							},

							confirmOk() {
								if (typeof this.confirmModal.onOk === 'function') {
									this.confirmModal.onOk();
								}
								this.confirmModal.open = false;
							},

							confirmCancel() {
								this.confirmModal.open = false;
							},
							toggleParent(parentId) {
								this.openParent = this.openParent === parentId ? null : parentId;
							},

							clickParent(id) {
								// 이미 열린 상태 → 전체로 초기화
								if (this.openParent === id) {
									this.openParent = null;
									this.currentCat = null;
									this.currentChild = null;
									this.currentPage = 1;
									this.fnSearch();
									return;
								}

								// 새 카테고리 선택
								this.openParent = id;
								this.currentCat = id;
								this.currentChild = null;
								this.currentPage = 1;
								this.fnSearch();
							},

							selectCategory(id) {
								this.currentCat = id;
								this.currentChild = null;
								this.openParent = null;
								this.currentPage = 1;
								this.fnSearch();
							},

							selectChild(parentId, childId) {
								this.currentCat = parentId;
								this.currentChild = childId;
								this.currentPage = 1;
								this.fnSearch();
							},
							updateRange(e) {
								const val = e.target.value;
								const percent = val / 100000 * 100;

								e.target.style.background =
									`linear-gradient(to right, #E8732A ${percent}%, #ddd ${percent}%)`;
							},
							fnMoveTop() {
								window.scrollTo({
									top: 0,
									behavior: 'smooth'
								});
							},

							fnHandleScroll() {
								this.showTopBtn = window.scrollY > 420;
							},
							fnGoEvent() {
								location.href = "/event/list.do";
							},
							fnPriceInput() {
								clearTimeout(this.filterTimer);

								this.filterTimer = setTimeout(() => {
									this.currentPage = 1;

									const contentTop = document.querySelector('.content-wrap').offsetTop - 90;

									this.fnList();

									this.$nextTick(() => {
										if (window.scrollY > contentTop) {
											window.scrollTo({
												top: contentTop,
												behavior: 'auto'
											});
										}
									});
								}, 250);
							}

						}, // methods

						mounted() {
							this.fetchCategory();
							this.fetchBrandList();
							this.fnGetRecentList();
							this.fnUpdateRecentRight();
							window.addEventListener('keydown', this.fnKeyEnter);

							var self = this;
							var params = new URLSearchParams(window.location.search);

							var catId = params.get('categoryId');
							var parId = params.get('parentId');
							var hasCategoryParam = catId || parId;
							var rentalParam = params.get('rental') || '${param.rental}';
							var purchaseParam = params.get('purchase') || '${param.purchase}';

							if (rentalParam === 'Y') {
								self.filter.rentable = true;
								self.filter.buyable = false;
							}

							if (purchaseParam === 'Y') {
								self.filter.rentable = false;
								self.filter.buyable = true;
							}
							if (catId && parId) {
								self.currentCat = parseInt(parId);
								self.currentChild = parseInt(catId);
								self.openParent = parseInt(parId);
								self.fnList();
							} else if (catId) {
								self.selectCategory(parseInt(catId));
							} else {
								self.fnList();
							}

							/* URL 카테고리 파라미터는 첫 진입에만 쓰고 바로 제거 */
							if (hasCategoryParam) {
								window.history.replaceState({}, document.title, window.location.pathname);
							}
							window.addEventListener('scroll', this.fnHandleScroll);
							window.addEventListener('resize', this.fnUpdateRecentRight);
						},
						unmounted() {
							window.removeEventListener('scroll', this.fnHandleScroll);
							window.removeEventListener('resize', this.fnUpdateRecentRight);
						}

					}).mount('#app');
				</script>
	</body>

	</html>