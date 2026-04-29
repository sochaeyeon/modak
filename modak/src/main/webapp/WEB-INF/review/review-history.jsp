<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
			<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
				<!DOCTYPE html>
				<html lang="ko">

				<head>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<title>내 리뷰 전체보기</title>

					<script src="https://code.jquery.com/jquery-3.7.1.js"
						integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
						crossorigin="anonymous"></script>
					<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
					<script src="/js/page-change.js"></script>


					<link rel="stylesheet" href="/css/review/review-history.css">
				</head>

				<body>
					<%@ include file="/WEB-INF/common/header.jsp" %>

						<div id="app">
							<div class="wishlist-history-page">
								<div class="wishlist-history-wrap">

									<div class="page-hero">
										<div>
											<div class="page-eyebrow">MY REVIEW</div>
											<h2 class="page-title">내 리뷰 전체보기</h2>
											<p class="page-desc">
												내가 작성한 리뷰를 최신순으로 확인할 수 있어요.
											</p>
										</div>

										<div class="hero-summary-card">
											<div class="hero-summary-label">내 리뷰</div>
											<div class="hero-summary-value">
												<transition name="count-rise" mode="out-in">
													<span class="result-count-number" :key="totalCount">{{ totalCount
														}}</span>
												</transition>
												<span class="result-count-unit">개</span>
											</div>
										</div>
									</div>

									<div class="section-card">
										<div class="section-head">
											<div class="section-head-left">
												<h3>전체 리뷰</h3>
												<p class="recent-guide-text">리뷰는 10개씩 확인할 수 있습니다.</p>
											</div>
										</div>

										<transition name="list-rise" mode="out-in">
											<div class="wishlist-content" :key="'review-' + listAnimateKey">
												<div v-if="reviewList.length === 0" class="empty-state">
													<p>작성한 리뷰가 없습니다.</p>
												</div>

												<div v-else class="review-list">
													<div class="review-item" v-for="item in reviewList"
														:key="item.reviewId">

														<div class="review-head">
															<span class="review-product clickable"
																@click="fnGoProductDetail(item.productId)">
																{{ item.productName }}
															</span>

															<div class="review-stars">
																<span v-for="i in 5" :key="i" class="star-text">
																	{{ i <= item.rating ? '★' : '☆' }} </span>
															</div>
														</div>

														<div class="review-title-row">
															<div class="review-title">
																{{ item.title || '제목 없음' }}
															</div>

															<button type="button" class="review-toggle-btn"
																@click="fnToggleReview(item.reviewId)">
																<span>
																	{{ expandedReviewId === item.reviewId ? '접기' : '펼치기'
																	}}
																</span>
																<span class="arrow"
																	:class="{ open: expandedReviewId === item.reviewId }">▾</span>
															</button>
														</div>

														<div v-if="expandedReviewId === item.reviewId"
															class="review-body">
															{{ item.content }}
														</div>

														<div v-if="item.imageList && item.imageList.length > 0"
															class="review-image-wrap">
															<div class="review-image-grid">
																<div class="review-image-thumb"
																	v-for="(img, index) in item.imageList.slice(0, 6)"
																	:key="index"
																	@click="fnOpenImageModal(item.imageList, index)">

																	<img :src="img.imgUrl" alt="리뷰 이미지"
																		@error="$event.target.style.display='none'">

																	<div v-if="index === 5 && item.imageList.length > 6"
																		class="review-image-overlay">
																		+{{ item.imageList.length - 6 }}
																	</div>
																</div>
															</div>
														</div>
														<div class="review-bottom">
															<div class="review-date">
																{{ item.createdAt }}
															</div>

															<div class="review-actions">
																<button class="btn-outline btn-sm"
																	@click="fnEditReview(item.reviewId)">
																	수정
																</button>

																<button class="btn-outline btn-sm danger"
																	@click="fnRemoveReview(item.reviewId)">
																	삭제
																</button>
															</div>
														</div>

													</div>
												</div>

												<div v-if="totalPages > 1" class="pagination-wrap">
													<button class="page-btn" :disabled="page === 1"
														@click="fnChangePage(page - 1)">이전</button>

													<button class="page-btn" :disabled="page === 1"
														@click="fnChangePage(1)">«</button>

													<button v-for="num in visiblePages" :key="num" class="page-btn"
														:class="{ active: page === num }" @click="fnChangePage(num)">
														{{ num }}
													</button>

													<button class="page-btn" :disabled="page === totalPages"
														@click="fnChangePage(totalPages)">»</button>

													<button class="page-btn" :disabled="page === totalPages"
														@click="fnChangePage(page + 1)">다음</button>
												</div>
											</div>
										</transition>
									</div>

								</div>
							</div>
							<div v-if="isImageModalOpen" class="image-modal" @click="fnCloseImageModal">
								<div class="image-modal-content" @click.stop>
									<button class="image-modal-close" @click="fnCloseImageModal">×</button>

									<button class="image-modal-nav prev" v-if="modalImageList.length > 1"
										@click="fnPrevImage">
										‹
									</button>

									<img :src="modalImageList[currentImageIndex].imgUrl" alt="확대 이미지"
										class="image-modal-img">

									<button class="image-modal-nav next" v-if="modalImageList.length > 1"
										@click="fnNextImage">
										›
									</button>
								</div>
							</div>
						</div>

						<%@ include file="/WEB-INF/common/footer.jsp" %>
				</body>

				</html>

				<script>
					const app = Vue.createApp({
						data() {
							return {
								reviewList: [],
								totalCount: 0,
								page: 1,
								pageSize: 10,
								totalPages: 1,
								listAnimateKey: 0,
								isImageModalOpen: false,
								modalImageList: [],
								currentImageIndex: 0,
								expandedReviewId: null,
								listAnimateKey: 0
							};
						},
						computed: {
							visiblePages() {
								const range = 5;
								const half = Math.floor(range / 2);
								let start = Math.max(1, this.page - half);
								let end = Math.min(this.totalPages, start + range - 1);
								if (end - start < range - 1) {
									start = Math.max(1, end - range + 1);
								}
								const pages = [];
								for (let i = start; i <= end; i++) pages.push(i);
								return pages;
							}
						},
						methods: {
							fnGetReviewList: function (moveTop = false) {
								let self = this;

								$.ajax({
									url: "/user/review/list.dox",
									type: "POST",
									dataType: "json",
									data: {
										page: self.page,
										pageSize: self.pageSize
									},
									success: function (data) {
										if (data.result === "success") {
											self.reviewList = data.list || [];
											self.totalCount = data.totalCount || 0;
											self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;
											self.listAnimateKey++;
											self.expandedReviewId = null;

											if (moveTop) {
												window.scrollTo({
													top: 0,
													behavior: "smooth"
												});
											}
										} else {
											self.reviewList = [];
											self.totalCount = 0;
											self.totalPages = 1;
										}
									},
									error: function () {
										self.reviewList = [];
										self.totalCount = 0;
										self.totalPages = 1;
										self.expandedReviewId = null;
									}
								});
							},

							fnChangePage: function (num) {
								if (num < 1 || num > this.totalPages || num === this.page) {
									return;
								}

								this.page = num;
								this.fnGetReviewList(true);
							},

							fnEditReview: function (reviewId) {
								pageChange("/user/review/edit.do", {reviewId: reviewId});
							},

							fnRemoveReview: function (reviewId) {
								let self = this;

								if (!confirm("리뷰를 삭제하시겠습니까?")) {
									return;
								}

								$.ajax({
									url: "/user/review/remove.dox",
									type: "POST",
									dataType: "json",
									data: {reviewId: reviewId},
									success: function (data) {
										if (data.result === "success") {
											alert("리뷰가 삭제되었습니다.");

											// 🔥 핵심: 리스트 다시 조회
											self.fnGetReviewList();
										} else {
											alert(data.message || "삭제 실패");
										}
									},
									error: function () {
										alert("서버 오류");
									}
								});
							},
							fnOpenImageModal: function (imageList, index) {
								this.modalImageList = imageList;
								this.currentImageIndex = index;
								this.isImageModalOpen = true;
								document.body.style.overflow = "hidden";
							},

							fnCloseImageModal: function () {
								this.isImageModalOpen = false;
								this.modalImageList = [];
								this.currentImageIndex = 0;
								document.body.style.overflow = "";
							},

							fnPrevImage: function () {
								if (this.currentImageIndex > 0) {
									this.currentImageIndex--;
								} else {
									this.currentImageIndex = this.modalImageList.length - 1;
								}
							},

							fnNextImage: function () {
								if (this.currentImageIndex < this.modalImageList.length - 1) {
									this.currentImageIndex++;
								} else {
									this.currentImageIndex = 0;
								}
							},
							fnToggleReview: function (reviewId) {
								if (this.expandedReviewId === reviewId) {
									this.expandedReviewId = null;
								} else {
									this.expandedReviewId = reviewId;
								}
							},

							fnGoProductDetail: function (productId) {
								pageChange("/product/detail.do", {
									productId: productId
								});
							},
						},
						mounted() {
							this.fnGetReviewList();
						}
					});

					app.mount("#app");
				</script>