<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<title>모닥모닥 - 리뷰 작성</title>
				<link rel="stylesheet" href="/css/review/review-add.css">
				<script src="https://code.jquery.com/jquery-3.7.1.js"
					integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
				<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
				<script src="/js/page-change.js"></script>
			</head>

			<body>
				<div id="app">
					<%@ include file="/WEB-INF/common/header.jsp" %>


						<!-- MAIN -->
						<main>
							<h1 class="page-title">리뷰 작성</h1>
							<p class="page-subtitle">✦ 솔직한 후기가 다른 캠버들에게 큰 도움이 됩니다 🔥</p>

							<!-- 상품 정보 -->
							<div class="card product-card" :class="{ 'is-open': isOrderDetailOpen }"
								@click="toggleOrderDetail" style="cursor:pointer;" ref="productCard">
								<div class="product-info">
									<div class="product-thumb">
										<img v-if="selectedItem && selectedItem.imageUrl" :src="selectedItem.imageUrl"
											:alt="selectedItem.productName"
											style="width:100%; height:100%; object-fit:cover;">
										<span v-else>🏕️</span>
									</div>
									<div>
										<div class="product-name">
											{{ selectedItem ? selectedItem.productName : '리뷰 작성 상품을 선택하세요' }}
										</div>
										<div class="product-meta">
											주문번호 {{ orderInfo.orderId || orderId }} · {{ selectedItem ?
											selectedItem.reviewStatusText : '' }}
										</div>
									</div>
								</div>

								<span class="badge-shipped">
									{{ selectedItem ? selectedItem.reviewStatusText : '' }}
								</span>
							</div>

							<transition name="expand-fade">
								<div class="order-expand-box review-order-expand-box" v-if="isOrderDetailOpen">
									<div class="expand-title">주문 상품 목록</div>

									<div v-for="item in orderItemList" :key="item.itemId"
										class="expand-item-row review-order-item" :class="{
        active: selectedItem && selectedItem.itemId == item.itemId,
        done: item.reviewWrittenYn === 'Y'
    }" @click.stop="item.reviewWrittenYn !== 'Y' && selectOrderItem(item)">

										<div class="expand-thumb review-order-thumb"
											@click.stop="fnGoProductDetail(item.productId)" style="cursor:pointer;">
											<img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.productName">
											<div v-else class="expand-thumb-fallback">📦</div>
										</div>

										<div class="expand-info review-order-text">
											<div class="expand-name review-order-name">{{ item.productName }}</div>
											<div class="expand-meta review-order-sub">
												{{ item.categoryName }} · {{ fnFormatPrice(item.price) }}
											</div>
										</div>

										<div class="review-item-status">
											{{ item.reviewStatusText }}
										</div>
										<button class="review-item-btn" :class="[
        item.reviewWrittenYn === 'Y' ? 'is-done' : 'is-select',
        selectedItem && selectedItem.itemId == item.itemId ? 'is-active' : ''
    ]" :disabled="item.reviewWrittenYn === 'Y'" @click.stop="selectOrderItem(item)">

											{{
											item.reviewWrittenYn === 'Y'
											? '작성완료'
											: (selectedItem && selectedItem.itemId == item.itemId ? '선택됨' : '선택')
											}}

										</button>
									</div>
								</div>
							</transition>

							<!-- 별점 -->
							<div class="card" ref="ratingCard">
								<div class="section-label">
									별점 <span class="required-badge">필수</span>
								</div>

								<div class="star-row">
									<button v-for="n in 5" :key="n" class="star-btn" @click="setRating(n)"
										@mouseover="hoverRating = n" @mouseleave="hoverRating = 0">
										<span
											:style="{ color: (hoverRating || rating) >= n ? 'var(--star-filled)' : 'var(--star-empty)' }">★</span>
									</button>

									<!-- 👉 오른쪽 유지 -->
									<span class="star-hint">{{ ratingLabel }}</span>
								</div>

								<!-- 👉 에러는 아래 -->
								<div v-if="ratingErrorMsg" class="review-error-msg">
									{{ ratingErrorMsg }}
								</div>
							</div>
							<div class="card" ref="titleCard">
								<div class="section-label">
									제목 <span class="required-badge">필수</span>
								</div>

								<input type="text" class="review-title-input" ref="titleInput" v-model="title"
									@input="titleErrorMsg = ''" placeholder="한 줄로 리뷰를 요약해보세요">

								<div v-if="titleErrorMsg" class="review-error-msg">
									{{ titleErrorMsg }}
								</div>
							</div>
							<!-- 리뷰 작성 -->
							<div class="card">
								<div class="section-label">
									리뷰 작성 <span class="required-badge">필수</span>
								</div>
								<textarea class="review-textarea" ref="reviewTextarea" v-model="reviewText"
									@input="reviewErrorMsg = ''" placeholder="상품에 대한 솔직한 후기를 남겨주세요.&#10;(최소 10자 이상)"
									maxlength="1000"></textarea>

								<div v-if="reviewErrorMsg" class="review-error-msg">
									{{ reviewErrorMsg }}
								</div>

								<div class="char-count"><span>{{ reviewText.length }}</span> / 1000</div>

							</div>

							<!-- 사진 첨부 -->
							<div class="card">
								<div class="section-label">사진 첨부 <span
										style="font-weight:400;color:var(--text-muted);font-size:0.75rem;">최대 5장</span>
								</div>
								<div class="photo-area">
									<label class="photo-add-btn" style="cursor:pointer;">
										<input type="file" accept="image/*" multiple style="display:none"
											@change="addPhotos" />
										<svg width="22" height="22" viewBox="0 0 24 24" fill="none"
											stroke="currentColor" stroke-width="1.5">
											<rect x="3" y="3" width="18" height="18" rx="2" />
											<circle cx="8.5" cy="8.5" r="1.5" />
											<polyline points="21 15 16 10 5 21" />
										</svg>
										<span class="photo-add-label">사진 추가</span>
									</label>
									<div class="photo-wrapper" v-for="(photo, i) in photos" :key="i">
										<img class="photo-preview" :src="photo" alt="첨부 사진" />
										<button class="photo-remove" @click="removePhoto(i)">✕</button>
									</div>
								</div>
								<div class="photo-footer">{{ photos.length }} / 5장 · JPG, PNG, WEBP 가능</div>
							</div>

							<!-- 포인트 안내 -->
							<div class="point-box">
								<div class="point-row">
									<span class="point-icon">ℹ</span>
									<span>
										리뷰 작성 시 <strong>500P</strong> 적립<br />
										사진 포함 시 <strong>+300P 추가</strong><br />
										비회원·부적절 리뷰는 삭제될 수 있습니다
									</span>
								</div>
							</div>

							<!-- 버튼 -->
							<div class="btn-row">
								<button class="btn-cancel" @click="handleCancel">취소</button>
								<button class="btn-submit" @click="fnSave">
									✓ 리뷰 등록하기
								</button>
							</div>
						</main>


						<!-- Toast -->
						<div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
				</div>
				<%@ include file="/WEB-INF/common/footer.jsp" %>
			</body>

			</html>

			<script>
				const app = Vue.createApp({
					data() {
						return {
							// 변수
							orderId: '${param.orderId}',
							productId: '',
							itemId: '',

							orderInfo: {},
							orderItemList: [],
							selectedItem: null,
							isOrderDetailOpen: true,

							title: '',
							rating: 0,
							hoverRating: 0,
							reviewText: '',
							selectedTags: [],
							photos: [],
							photoFiles: [],
							toastVisible: false,
							toastMsg: '',
							ratingLabels: ['', '별로예요', '그럭저럭이에요', '보통이에요', '좋아요', '최고예요!'],
							reviewErrorMsg: '',
							titleErrorMsg: '',
							ratingErrorMsg: '',
						};
					}, // data
					computed: {
						// 별점 레이블
						ratingLabel: function () {
							const val = this.hoverRating || this.rating;
							return val ? this.ratingLabels[val] : '별점을 선택하세요';
						},
						// 등록 버튼 활성화 여부
						canSubmit: function () {
							return this.rating > 0 && this.reviewText.trim().length >= 10;
						},
					}, // computed
					methods: {
						fnReviewAdd: function () {
							let self = this;
							let param = {};
							$.ajax({
								url: "/user/review/add.do",
								dataType: "json",
								type: "POST",
								data: param,
								success: function (data) {
									console.log(data);
								}
							});
						},
						// 별점 선택
						setRating: function (n) {
							let self = this;
							self.rating = n;
							self.ratingErrorMsg = '';
						},
						// 태그 토글
						toggleTag: function (tag) {
							let self = this;
							const idx = self.selectedTags.indexOf(tag);
							if (idx === -1) self.selectedTags.push(tag);
							else self.selectedTags.splice(idx, 1);
						},
						// 사진 추가
						addPhotos: function (e) {
							let self = this;
							const files = Array.from(e.target.files);
							const remaining = 5 - self.photos.length;

							files.slice(0, remaining).forEach(file => {
								self.photoFiles.push(file);

								const reader = new FileReader();
								reader.onload = function (ev) {
									self.photos.push(ev.target.result);
								};
								reader.readAsDataURL(file);
							});

							e.target.value = '';
						},
						// 사진 삭제
						removePhoto: function (i) {
							let self = this;
							self.photos.splice(i, 1);
							self.photoFiles.splice(i, 1);
						},
						// 토스트 알림
						showToast: function (msg) {
							let self = this;
							self.toastMsg = msg;
							self.toastVisible = true;
							setTimeout(function () {self.toastVisible = false;}, 2500);
						},
						// 리뷰 등록
						fnSave: function () {
							let self = this;

							self.titleErrorMsg = '';
							self.ratingErrorMsg = '';
							self.reviewErrorMsg = '';

							if (!self.selectedItem) {
								self.scrollToRef("productCard");
								return;
							}

							if (!self.title.trim()) {
								self.titleErrorMsg = "제목을 입력해주세요.";
								self.scrollToRef("titleInput");
								return;
							}
							if (self.rating <= 0) {
								self.ratingErrorMsg = "별점을 선택해주세요.";
								self.scrollToRef("ratingCard");
								return;
							}

							if (self.reviewText.trim().length < 10) {
								self.reviewErrorMsg = "리뷰 내용은 최소 10자 이상 입력해주세요.";
								self.scrollToRef("reviewTextarea");
								return;
							}

							let formData = new FormData();
							formData.append("orderId", self.orderId);
							formData.append("productId", self.productId);
							formData.append("itemId", self.itemId);
							formData.append("title", self.title || "리뷰");
							formData.append("rating", self.rating);
							formData.append("content", self.reviewText);

							for (let i = 0; i < self.photoFiles.length; i++) {
								formData.append("files", self.photoFiles[i]);
							}

							$.ajax({
								url: "/user/review/add.dox",
								type: "POST",
								data: formData,
								processData: false,
								contentType: false,
								dataType: "json",
								success: function (data) {
									if (data.result === "success") {
										self.showToast("리뷰가 등록되었습니다.");
										setTimeout(function () {
											pageChange("/user/review/history.do", {});
										}, 1000);
									} else {
										alert(data.message);
									}
								},
								error: function () {
									alert("리뷰 등록 중 오류가 발생했습니다.");
								}
							});
						},
						// 취소
						handleCancel: function () {
							let self = this;
							if (confirm('작성 중인 리뷰가 저장되지 않습니다. 취소하시겠어요?')) {
								self.rating = 0;
								self.reviewText = '';
								self.selectedTags = [];
								self.photos = [];
								self.showToast('취소되었습니다.');
							}
						}, fnGetOrderDetail: function () {
							let self = this;

							$.ajax({
								url: "/user/review/order-info.dox",
								type: "POST",
								dataType: "json",
								data: {
									orderId: self.orderId
								},
								success: function (data) {
									if (data.result === "success") {
										self.orderInfo = data.orderInfo;

										let list = data.orderItemList || [];

										// 작성 가능한 항목 먼저, 작성완료 항목은 아래로
										list.sort(function (a, b) {
											const aDone = a.reviewWrittenYn === 'Y' ? 1 : 0;
											const bDone = b.reviewWrittenYn === 'Y' ? 1 : 0;

											if (aDone !== bDone) {
												return aDone - bDone; // N 먼저, Y 나중
											}

											return Number(a.itemId) - Number(b.itemId);
										});

										self.orderItemList = list;

										if (self.orderItemList.length > 0) {
											// 작성 가능한 첫 상품을 기본 선택
											let firstWritable = self.orderItemList.find(function (item) {
												return item.reviewWrittenYn !== 'Y';
											});

											if (firstWritable) {
												self.selectOrderItem(firstWritable);
											} else {
												// 전부 작성완료면 자동 선택 안 하거나, 첫 번째만 보여주기
												self.selectedItem = self.orderItemList[0];
												self.productId = self.orderItemList[0].productId;
												self.itemId = self.orderItemList[0].itemId;
											}
										}
									} else {
										alert(data.message || "주문 정보를 불러오지 못했습니다.");
									}
								}
							});
						},

						toggleOrderDetail: function () {
							let self = this;
							self.isOrderDetailOpen = !self.isOrderDetailOpen;
						},

						selectOrderItem: function (item) {
							let self = this;
							self.selectedItem = item;
							self.productId = item.productId;
							self.itemId = item.itemId;
						},
						fnGoProductDetail: function (productId) {
							pageChange("/product/detail.do", {
								productId: productId
							});
						},
						fnFormatPrice: function (price) {
							return Number(price || 0).toLocaleString() + "원";
						},
						setRating: function (n) {
							let self = this;
							self.rating = n;
							self.reviewErrorMsg = '';
						},
						scrollToRef: function (refName) {
							let self = this;
							const el = self.$refs[refName];

							if (!el) return;

							el.scrollIntoView({
								behavior: "smooth",
								block: "center"
							});

							// input이면 포커스
							if (refName === "reviewTextarea" || refName === "titleInput") {
								setTimeout(function () {
									el.focus();
								}, 300);
							}
						}
					}, // methods
					mounted() {
						// 처음 시작할 때 실행되는 부분
						let self = this;
						self.fnGetOrderDetail();
					}
				});

				app.mount('#app');
			</script>