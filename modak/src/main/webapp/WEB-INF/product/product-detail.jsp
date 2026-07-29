<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>상품상세 - 모닥모닥</title>
		<link rel="stylesheet" href="/css/product/product-detail.css">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<link href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.2.0/remixicon.css" rel="stylesheet">
	</head>

	<body>
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div id="app" v-cloak>
				<div class="wrap">
					<div class="ptop">
						<div class="ptop-inner">
							<a href="/product/list.do" class="back-to-list">
								<i class="ri-arrow-left-line"></i>
							</a>
							<div class="gallery">
								<div class="gallery-sticky">
									<div class="gm product-main-gallery" @click="openImg(mainImgUrl)">
										<button type="button" class="gallery-arrow gallery-prev"
											@click.stop="changeMainImg(-1)" v-if="productImages.length > 1">
											<i class="ri-arrow-left-s-line"></i>
										</button>

										<div class="gem">
											<img v-if="mainImgUrl" :src="mainImgUrl" alt="상품 메인 이미지">
											<img v-else src="/img/product/default.jpg" alt="기본 이미지">
										</div>

										<button type="button" class="gallery-arrow gallery-next"
											@click.stop="changeMainImg(1)" v-if="productImages.length > 1">
											<i class="ri-arrow-right-s-line"></i>
										</button>
									</div>

									<div class="gthumbs">
										<div v-for="(img, idx) in productImages" :key="idx" class="gth"
											:class="{ on: mainImgUrl === img.imgUrl }"
											@click.stop="setMainImg(img.imgUrl)">
											<img :src="img.imgUrl">
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- INFO -->
						<div class="pinfo">
							<div class="product-head">
								<a class="product-brand-badge" :href="'/product/list.do?brandId=' + productInfo.brandId"
									style="text-decoration:none; cursor:pointer;">
									{{ productInfo.brandName }}
								</a>

								<h1 class="ptitle">{{ productInfo.productName }}</h1>

								<div class="product-review-line" @click="goReviewTab">
									<div class="stars top-stars">
										<span class="rating-stars" @click.stop="goReviewTab">
											<span v-for="i in 5" :key="i" class="rating-star">
												<span class="rating-star-fill"
													:style="{ width: getStarFill(avgRating, i) + '%' }">★</span>
												<span class="rating-star-empty">★</span>
											</span>
										</span>
									</div>

									<span class="top-rating">{{ Number(avgRating).toFixed(1) }}</span>
									<span class="top-review-count">리뷰 {{ reviewTotalCount }}개</span>
									<span class="top-order-count">구매·대여 {{ orderCount }}회</span>
								</div>
							</div>

							<!-- MODE TOGGLE 숨김 -->
							<div class="mtog" style="display:none;">
								<button class="mbtn on" id="mb-buy" onclick="setMode('buy')"
									:disabled="productType === 'RENTAL'">
									<i class="ri-shopping-bag-3-line"></i>
									구매하기
								</button>

								<button class="mbtn" id="mb-rent" onclick="setMode('rent')"
									:disabled="productType === 'PURCHASE'">
									<i class="ri-calendar-check-line"></i>
									대여하기
								</button>
							</div>

							<!-- BUY PRICE -->
							<div class="buy-only">
								<div class="pbox-buy">
									<div class="prow"><span class="pnow">{{ formatPrice(productInfo.price) }}</span>
									</div>
									<div class="pnote">
										<a v-if="couponLoaded && !isLogin" href="/user/register.do" class="pnote-link">
											{{ couponNoteText }}
										</a>
										<span v-else-if="couponLoaded">
											{{ couponNoteText }}
										</span>
									</div>
								</div>
							</div>

							<!-- RENT PRICE -->
							<div class="rent-only">
								<div class="pbox-rent">
									<div class="prow">
										<span class="rent-per">1박당</span>
										<span class="rent-num">{{ formatPrice(productInfo.price) }}</span>
										<span class="rent-unit"> / 박</span>
									</div>
									<div style="font-size:13px;color:var(--muted);margin-top:4px;">
										보증금 <strong style="color:#333;">{{ formatPrice(productInfo.deposit) }}</strong>
										<span style="font-size:11px;">(반납 후 환불)</span>
									</div>
								</div>
							</div>

							<!-- 옵션 선택 -->
							<div v-if="productOptions.length > 0" class="option-section">
								<div class="section-label option-required-label">
									옵션 선택
									<span class="required-mark">*</span>
								</div>

								<div v-for="(opts, optionName) in groupedOptions" :key="optionName"
									class="option-group">
									<div class="option-name">{{ optionName }}</div>

									<div class="option-chip-list">
										<button type="button" v-for="opt in opts" :key="opt.optionValueId"
											class="option-chip"
											:class="{ active: selectedOptions[optionName] && selectedOptions[optionName].optionValueId === opt.optionValueId }"
											@click="selectOption(optionName, opt)">
											{{ opt.optionValue }}
											<span v-if="opt.addPrice > 0">
												+{{ opt.addPrice.toLocaleString() }}원
											</span>
										</button>
									</div>
								</div>
							</div>

							<div v-if="productOptions.length === 0" class="osec">
								<div class="olabel" style="color:var(--muted);font-size:13px;">옵션 없음</div>
							</div>

							<div class="buy-only">
								<div class="qty-section">
									<div class="section-label">수량 선택</div>

									<div class="qty-box">
										<button type="button" class="qty-btn" @click="chgQty(-1)"
											:disabled="qtyLocked">−</button>
										<input type="number" class="qty-num" :value="qty" @input="onQtyInput($event)"
											@blur="onQtyBlur" min="1" :max="displayQty" :disabled="qtyLocked" />
										<button type="button" class="qty-btn" @click="chgQty(1)"
											:disabled="qtyLocked">+</button>

										<span v-if="optionStockLoading" class="stock-text" style="color:var(--muted)">재고
											확인 중...</span>
										<template v-else-if="productOptions.length > 0 && optionStock === null">
											<span class="stock-text" style="color:var(--muted)">옵션을 선택하면 재고가 표시돼요</span>
										</template>
										<template v-else>
											<span v-if="isLowStock" class="stock-urgent-badge">
												<i class="ri-fire-fill"></i> {{ displayQty }}개 남음 · 품절임박
											</span>
											<span v-else-if="remainQty > 0" class="stock-text">{{ remainQty }}개
												남음</span>
											<span v-else-if="remainQty === 0 && qty > 0" class="stock-text warn">잔여 재고
												없음</span>
											<span v-else class="stock-text soldout">품절</span>
										</template>
									</div>
								</div>
								<div class="booking-summary">
									<div v-if="Object.keys(selectedOptions).length > 0 || qty > 0">
										<div v-for="(opt, name) in selectedOptions" :key="name"
											style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--muted);">
											<span>{{ name }}</span><span style="color:#333;font-weight:500;">{{
												opt.optionValue }}</span>
										</div>
										<div v-if="totalAddPrice > 0"
											style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--orange);">
											<span>옵션 추가금</span><span>+{{ formatPrice(totalAddPrice) }}</span>
										</div>
										<div
											style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:4px;">
											<span style="color:var(--muted)">수량</span>
											<span>{{ formatPrice(unitPrice) }} × {{ qty }}개</span>
										</div>
										<hr style="border:none;border-top:1px solid #f0c8a0;margin:8px 0;">
										<div style="display:flex;justify-content:space-between;align-items:center;">
											<span style="font-size:14px;color:var(--muted)">총 상품금액</span>
											<span style="font-size:1.8rem;font-weight:bold;color:var(--orange);">{{
												totalPriceFormatted }}</span>
										</div>
									</div>
									<div v-else style="color:#bbb;">옵션과 수량을 선택해주세요.</div>
								</div>

								<div class="arow" style="margin-top:12px;">
									<button type="button" class="bwish" :class="{ on: isWished }"
										@click="fnWish($event)">
										<i :class="isWished ? 'ri-heart-fill' : 'ri-heart-line'"></i>
									</button>
									<button class="bcart" @click="fnAddToCart">장바구니 담기</button>
									<button class="btn-buy" @click="fnBuyNow">바로 구매하기</button>
								</div>
							</div>

							<!-- RENT CALENDAR -->
							<div class="rent-only" style="max-width:700px;">
								<div class="rent-date-row">
									<!-- 수량 추가/차감 (1) -->
									<div class="qty-box rent-qty-box">
										<button type="button" class="qty-btn" @click="chgQty(-1)"
											:disabled="qtyLocked">−</button>
										<input type="number" class="qty-num" :value="qty" @input="onQtyInput($event)"
											@blur="onQtyBlur" min="1" :max="displayQty" :disabled="qtyLocked" />
										<button type="button" class="qty-btn" @click="chgQty(1)"
											:disabled="qtyLocked">+</button>
									</div>

									<!-- 재고 뱃지 (2) -->
									<div class="rent-stock-box">
										<span v-if="optionStockLoading" class="stock-text" style="color:var(--muted);">
											<i class="ri-loader-4-line"></i><br>확인 중
										</span>
										<template v-else-if="productOptions.length > 0 && optionStock === null">
											<span class="rent-stock-num" style="color:var(--muted);">-</span>
											<span class="rent-stock-label" style="color:var(--muted);">재고</span>
										</template>
										<template v-else>
											<span v-if="isLowStock" class="rent-stock-num urgent">{{ remainQty }}</span>
											<span v-else-if="remainQty > 0" class="rent-stock-num">{{ remainQty
												}}</span>
											<span v-if="isLowStock" class="rent-stock-label urgent">품절임박</span>
											<span v-else-if="remainQty > 0" class="rent-stock-label">개 남음</span>
											<span v-else-if="remainQty === 0 && qty > 0" class="stock-text warn"
												style="font-size:11px;">재고<br>없음</span>
											<span v-else class="stock-text soldout" style="font-size:11px;">품절</span>
										</template>
									</div>

									<!-- 날짜 선택 버튼 (3) -->
									<button @click="openCalendar" class="rent-date-btn">
										<span>
											<i class="ri-calendar-line"></i>
											날짜 선택
											<span v-if="startDate && endDate"
												style="color:var(--orange);margin-left:8px;font-size:13px;">
												{{ startDate }} ~ {{ endDate }} ({{ rentDays }}박)
											</span>
											<span v-else-if="startDate"
												style="color:var(--orange);margin-left:8px;font-size:13px;">
												{{ startDate }} 선택됨
											</span>
											<span v-else style="color:var(--muted);margin-left:8px;font-size:13px;">
												날짜를 선택해주세요
											</span>
										</span>
										<i class="ri-arrow-down-s-line calendar-arrow-icon"></i>
									</button>
								</div>

								<div v-if="calOpen" style="position:fixed;top:0;left:0;width:100%;height:100%;
											background:rgba(0,0,0,0.5);z-index:9000;
											display:flex;align-items:center;justify-content:center;" @click.self="calOpen = false">
									<div
										style="background:#fff;border-radius:16px;padding:24px;width:360px;max-width:95vw;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
										<div
											style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
											<span style="font-size:16px;font-weight:700;">날짜 선택</span>
											<button @click="calOpen = false"
												style="background:none;border:none;font-size:20px;cursor:pointer;color:#999;">✕</button>
										</div>
										<div class="cal-nav" style="margin-bottom:8px;">
											<button @click="changeMonth(-1)">‹</button>
											<h2 style="font-weight:bold;font-size:15px;">{{ currentYear }}년 {{
												currentMonth + 1 }}월</h2>
											<button @click="changeMonth(1)">›</button>
										</div>
										<div class="cal-grid">
											<div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">
												{{w}}</div>
											<div v-for="(day, idx) in calendarDays" :key="idx"
												:data-date="day ? day.full : ''" :class="getDayClass(day)"
												@click="onDayClick(day)">
												<span v-if="day">{{ day.date }}</span>
											</div>
										</div>
										<div
											style="margin-top:16px;padding:12px;background:#fafafa;border-radius:8px;font-size:13px;min-height:44px;">
											<div v-if="startDate && endDate" style="color:#333;">
												{{ startDate }} ~ {{ endDate }}
												<strong style="color:var(--orange);margin-left:6px;">{{ rentDays
													}}박</strong>
											</div>
											<div v-else-if="startDate" style="color:var(--orange);font-weight:600;">종료일을
												선택해주세요.</div>
											<div v-else style="color:#bbb;">시작일을 선택해주세요.</div>
										</div>
										<div style="display:flex;gap:8px;margin-top:12px;">
											<button @click="startDate=null; endDate=null;"
												style="flex:1;padding:10px;border:1px solid #eee;border-radius:8px;background:#fff;cursor:pointer;font-size:13px;font-family:inherit;">초기화</button>
											<button @click="calOpen = false" :disabled="!startDate || !endDate"
												:style="(startDate && endDate)
													? 'flex:2;padding:10px;border:none;border-radius:8px;background:var(--orange);color:#fff;cursor:pointer;font-size:14px;font-weight:600;font-family:inherit;'
													: 'flex:2;padding:10px;border:none;border-radius:8px;background:#ddd;color:#999;cursor:not-allowed;font-size:14px;font-weight:600;font-family:inherit;'">확인</button>
										</div>
									</div>
								</div>

								<div class="booking-summary">
									<div v-if="startDate && endDate">
										<p style="font-size:0.9rem;color:#888;margin-bottom:8px;">{{ startDate }} ~ {{
											endDate }} ({{ rentDays }}박)</p>
										<div v-if="totalAddPrice > 0"
											style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--muted);">
											<span>기본가</span><span>{{ formatPrice(productInfo.price) }} / 박</span>
										</div>
										<div v-if="totalAddPrice > 0"
											style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--orange);">
											<span>옵션 추가금</span><span>+{{ formatPrice(totalAddPrice) }} / 박</span>
										</div>
										<div
											style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:4px;">
											<span style="color:var(--muted)">대여료 ({{ rentDays }}박 × {{ qty }}개)</span>
											<span>{{ formatPrice(rentSubtotal) }}</span>
										</div>
										<div
											style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:8px;">
											<span style="color:var(--muted)">보증금 <span style="font-size:11px;">(반납 후
													환불, {{ qty }}개)</span></span>
											<span>{{ formatPrice(rentDepositTotal) }}</span>
										</div>
										<hr style="border:none;border-top:1px solid #eee;margin:8px 0;">
										<div style="display:flex;justify-content:space-between;align-items:center;">
											<span style="font-size:14px;color:var(--muted)">결제 예정금액</span>
											<span style="font-size:1.8rem;font-weight:bold;color:var(--orange);">{{
												formatPrice(rentTotalPrice) }}</span>
										</div>
									</div>
									<div v-else style="color:#bbb;">캘린더에서 예약 날짜를 선택해주세요.</div>
								</div>

								<div class="arow" style="margin-top:12px;">
									<button class="bwish" id="wb2" :class="{ on: isWished }" @click="fnWish($event)">
										<i :class="isWished ? 'ri-heart-fill' : 'ri-heart-line'"></i>
									</button>
									<button class="bcart" @click="fnAddToCart">장바구니 담기</button>
									<button class="btn-rent" :disabled="!startDate || !endDate" @click="fnRent">
										{{ (startDate && endDate) ? '대여 신청하기' : '날짜를 선택하세요' }}
									</button>
								</div>
							</div>

							<!-- DELIVERY -->
							<div class="delbox">
								<div class="drow buy-only"><span class="dkey">배송</span><span
										class="dv"><strong>무료배송</strong> · 오늘 주문 시 내일 도착</span></div>
								<div class="drow rent-only"><span class="dkey">수령/반납</span><span
										class="dv"><strong>무료배송</strong> 또는 매장 직수령 · 반납일 오전 10시까지</span></div>
								<div class="drow"><span class="dkey">반품</span><span class="dv">구매 후 30일 이내 무료 반품</span>
								</div>
								<div class="drow">
									<span class="dkey">적립</span>
									<span class="dv buy-only">
										<strong>{{ rewardPoint }}포인트</strong> 적립
									</span>
									<span class="dv rent-only">
										대여 확정 시 <strong>{{ rewardPointPerNight }}포인트/박</strong> 적립
									</span>
								</div>
							</div>
							<div class="trust-strip">
								<div class="trust-item"><i class="ri-truck-line"></i><span>무료배송</span></div>
								<div class="trust-item"><i class="ri-shield-check-line"></i><span>정품보장</span></div>
								<div class="trust-item"><i class="ri-arrow-go-back-line"></i><span>30일 무료반품</span></div>
								<div class="trust-item"><i class="ri-lock-2-line"></i><span>안전결제</span></div>
							</div>
						</div>

					</div>

					<!-- TABS -->
					<div>
						<div class="tnav">
							<button class="tbtn on" @click="stab('det', $event)"><i class="ri-file-list-3-line"></i> 상품
								정보</button>
							<button class="tbtn" @click="stab('rev', $event)"><i class="ri-star-line"></i> 리뷰 ({{
								reviewTotalCount }})</button>
							<button class="tbtn" @click="stab('qna', $event)"><i class="ri-question-line"></i>
								Q&A</button>
							<button class="tbtn" @click="stab('shp', $event)"><i class="ri-truck-line"></i> 배송/대여
								안내</button>
							<div class="t-underline"></div>
						</div>

					</div>
					<div class="tcont">
						<div class="tpane on" id="tp-det">
							<div class="detail-image-wrap" v-if="detailImgUrl">
								<img :src="detailImgUrl" alt="상품 상세 이미지" class="detail-image">
							</div>
						</div>

						<div class="tpane" id="tp-rev">
							<div class="review-summary-ai" v-if="reviewSummaryLoading || reviewSummary">
								<div class="ai-title">
									<i class="ri-robot-2-line"></i> AI 리뷰 요약
								</div>

								<div v-if="reviewSummaryLoading" class="ai-loading">
									<span class="ai-spinner"></span>
									<span>리뷰를 정리하고 있어요...</span>
								</div>

								<div v-else class="ai-content">
									{{ reviewSummary }}
								</div>
							</div>
							<div class="rsum2">
								<div class="rbig">
									<div class="rn">{{ Number(avgRating).toFixed(1) }}</div>
									<div class="stars review-summary-stars">
										<span class="rating-stars">
											<span v-for="i in 5" :key="i" class="rating-star">
												<span class="rating-star-fill"
													:style="{ width: getStarFill(avgRating, i) + '%' }">★</span>
												<span class="rating-star-empty">★</span>
											</span>
										</span>
									</div>
									<div class="ro">{{ reviewTotalCount }}개 리뷰</div>
								</div>
								<div class="rbars">
									<div class="bbar" v-for="d in ratingDist" :key="d.score">
										<span class="blbl">{{ d.score }}점</span>
										<div class="btrk">
											<div class="bfil" :style="{ width: d.pct + '%' }"></div>
										</div>
										<span class="bcnt">{{ d.count }}</span>
									</div>
								</div>
							</div>
							<!-- 리뷰 필터 / 검색 -->
							<div class="review-control-box">
								<div class="review-filter-left">
									<label class="photo-review-check">
										<input type="checkbox" v-model="reviewOnlyPhoto" @change="applyReviewFilter">
										<span class="check-ui"></span>
										<span>사진 리뷰만 보기</span>
									</label>

									<select class="review-sort-select" v-model="reviewSort" @change="applyReviewFilter">
										<option value="latest">최신순</option>
										<option value="oldest">오래된순</option>
										<option value="helpful">추천순</option>
									</select>
								</div>

								<div class="review-search-box">
									<input type="text" v-model.trim="reviewKeyword" class="review-search-input"
										placeholder="리뷰 내용을 검색해보세요" @keyup.enter="applyReviewFilter">

									<button type="button" class="review-search-btn" @click="applyReviewFilter">
										<i class="ri-search-line"></i>
										검색
									</button>

								</div>
							</div>
							<div v-if="reviewList.length === 0" class="review-empty">
								조건에 맞는 리뷰가 없습니다.
							</div>

							<div class="rcard" v-for="review in reviewList" :key="review.reviewId">
								<div class="rhead">
									<div class="review-user">
										<img class="review-profile"
											:src="review.profileImgUrl || '/upload/profile/default-profile.png'">

										<div>
											<div class="rname">
												{{ review.nickname || review.userId }}
												<span v-if="review.gradeId >= 4" class="grade-badge vip">VIP</span>
												<span v-else-if="review.gradeId == 3"
													class="grade-badge gold">GOLD</span>
												<span v-else-if="review.gradeId == 2"
													class="grade-badge silver">SILVER</span>
											</div>

											<div class="review-date-line">
												<span v-if="review.updatedAt && review.updatedAt !== review.createdAt">
													{{ review.updatedAt }}
												</span>
												<span v-else>
													{{ review.createdAt }}
												</span>
											</div>

											<div class="stars" style="display:flex;gap:1px;margin-top:3px">
												<span v-for="(star, i) in getStars(review.rating)" :key="i" class="st"
													:style="{ fontSize:'12px', color: star === '★' ? '' : '#ddd' }">
													{{ star }}
												</span>
												<span style="font-size:12px;color:#999;margin-left:6px;">
													{{ formatRatingInt(review.rating) }}점
												</span>
											</div>
										</div>
									</div>

									<div class="review-menu-wrap">
										<button type="button" class="review-more-btn"
											@click.stop="toggleReviewMenu(review.reviewId)">
											<i class="ri-more-2-fill"></i>
										</button>

										<div class="review-dropdown" v-if="openReviewMenuId === review.reviewId">
											<button v-if="loginUserId && String(review.userId) === String(loginUserId)"
												type="button" @click="goReviewEdit(review.reviewId)">
												수정
											</button>

											<button v-if="loginUserId && String(review.userId) === String(loginUserId)"
												type="button" class="danger"
												@click="confirmDeleteReview(review.reviewId)">
												삭제
											</button>

											<button v-if="!loginUserId || String(review.userId) !== String(loginUserId)"
												type="button" class="danger" @click="reportReview(review.reviewId)">
												신고
											</button>
										</div>
									</div>
								</div>

								<div class="rtext" style="font-weight:600;margin-bottom:4px">
									{{ review.title }}
								</div>

								<div class="rtext">
									{{ review.content }}
								</div>

								<div v-if="review.imageList && review.imageList.length > 0" class="review-img-list">
									<img v-for="(img, idx) in review.imageList" :key="idx" :src="img.imgUrl"
										class="review-img-thumb"
										@click="openImg(img.imgUrl, reviewList.indexOf(review), idx)"
										@error="$event.target.style.display='none'">
								</div>

								<div class="rhelprow">
									<span>도움이 됐나요?</span>
									<button class="hbtn" :class="{ 
																	on: review.helpfulYn === 'Y',
																	disabled: String(review.userId) === String(loginUserId)
																}" :disabled="String(review.userId) === String(loginUserId)" @click="fnReviewHelpful(review)">
										<i
											:class="review.helpfulYn === 'Y' ? 'ri-thumb-up-fill' : 'ri-thumb-up-line'"></i>
										도움돼요 {{ review.helpfulCount || 0 }}
									</button>
								</div>
							</div>

							<div class="review-paging" v-if="reviewTotalPage > 1">
								<button type="button" class="review-page-btn" :disabled="reviewPage === 1"
									@click="changeReviewPage(reviewPage - 1)">
									이전
								</button>

								<button type="button" v-for="page in reviewTotalPage" :key="page"
									class="review-page-num" :class="{ active: reviewPage === page }"
									@click="changeReviewPage(page)">
									{{ page }}
								</button>

								<button type="button" class="review-page-btn" :disabled="reviewPage === reviewTotalPage"
									@click="changeReviewPage(reviewPage + 1)">
									다음
								</button>
							</div>
						</div>

						<div class="tpane" id="tp-qna">

							<!-- 헤더 -->
							<div class="qna-header-row">
								<h3 class="qna-section-title">상품 문의</h3>
								<button type="button" class="qna-write-btn" @click="openQnaModal('add')">
									<i class="ri-edit-line"></i> 문의하기
								</button>
							</div>

							<!-- 검색 -->
							<div class="qna-search-box">
								<div class="qna-input-wrap"> <!-- ← wrapper 추가 -->
									<input type="text" v-model.trim="qnaKeyword" class="qna-search-input"
										placeholder="문의 내용을 검색해보세요" @keyup.enter="applyQnaFilter">
									<button type="button" class="qna-input-clear" v-show="qnaKeyword"
										@click="qnaKeyword = ''; resetQnaFilter()">
										<i class="ri-close-line"></i>
									</button>
								</div>

								<button type="button" class="qna-search-btn" @click="applyQnaFilter">
									<i class="ri-search-line"></i> 검색
								</button>
							</div>

							<!-- 검색 결과 안내줄 -->
							<div v-if="qnaSearchKeyword" class="qna-search-result-row">
								<span>'<strong>{{ qnaSearchKeyword }}</strong>' {{ qnaTotalCount }}개의 검색결과가
									있습니다.</span>
								<button type="button" class="qna-search-clear-btn" @click="resetQnaFilter">
									<i class="ri-close-line"></i>
								</button>
							</div>

							<!-- 빈 상태 -->
							<div v-if="qnaList.length === 0" class="review-empty">
								<template v-if="qnaSearchKeyword">'{{ qnaSearchKeyword }}'에 대한 검색 결과가
									없습니다.</template>
								<template v-else>등록된 상품 문의가 없습니다. 상품에 대해 궁금한 점을 남겨주세요!</template>
							</div>

							<!-- 문의 목록 -->
							<div v-else class="qna-list">
								<div v-for="qna in qnaList" :key="qna.qnaId" class="qna-item">

									<!-- 질문 영역 -->
									<div class="qna-question-area">
										<div class="qna-meta-row">
											<div class="qna-badges">
												<span class="qna-badge completed"
													v-if="qna.status === 'COMPLETED'">답변완료</span>
												<span class="qna-badge waiting" v-else>답변대기</span>
												<span class="qna-secret-tag" v-if="qna.secretYn === 'Y'">
													<i class="ri-lock-2-line"></i> 비밀글
												</span>
												<span class="qna-option-tag" v-if="qna.optionName">{{ qna.optionName
													}}</span>
											</div>
											<div class="qna-author-info">
												<span class="qna-nickname">{{ qna.nickname }}</span>
												<span class="qna-divider">·</span>
												<span class="qna-date">{{ qna.createdAt }}</span>
											</div>
										</div>

										<div class="qna-content-row">
											<span class="qna-label-q">Q</span>
											<div class="qna-text">
												<template v-if="qna.secretYn === 'Y'">
													<span v-if="String(qna.userId) === String(loginUserId)">
														<i class="ri-lock-unlock-line qna-lock-icon"></i>{{
														qna.questionContent }}
													</span>
													<span v-else class="qna-secret-text">
														<i class="ri-lock-2-line"></i> 비밀글입니다.
													</span>
												</template>
												<template v-else>{{ qna.questionContent }}</template>
											</div>
										</div>

										<!-- 내 글 수정/삭제 버튼 -->
										<div v-if="String(qna.userId) === String(loginUserId)" class="qna-action-row">
											<button v-if="qna.status === 'WAITING'" type="button" class="qna-btn-edit"
												@click="openQnaModal('edit', qna)">수정</button>
											<button type="button" class="qna-btn-delete"
												@click="deleteQna(qna.qnaId)">삭제</button>
										</div>
									</div>

									<!-- 답변 영역 -->
									<div v-if="qna.status === 'COMPLETED'" class="qna-answer-area">
										<span class="qna-label-a">A</span>
										<div class="qna-answer-body">
											<div class="qna-answer-meta">
												<span class="qna-answer-title">판매자 답변</span>
												<span class="qna-answer-date">{{ qna.answeredAt }}</span>
											</div>
											<div class="qna-answer-text">
												<template
													v-if="qna.secretYn === 'Y' && String(qna.userId) !== String(loginUserId)">
													<i class="ri-lock-2-line"></i> 비밀글 답변입니다.
												</template>
												<template v-else>{{ qna.answerContent }}</template>
											</div>
										</div>
									</div>

								</div>
							</div>

							<!-- 페이징 -->
							<div class="review-paging" v-if="qnaTotalPage > 1">
								<button type="button" class="review-page-btn" :disabled="qnaPage === 1"
									@click="changeQnaPage(qnaPage - 1)">이전</button>
								<button type="button" v-for="page in qnaTotalPage" :key="'q'+page"
									class="review-page-num" :class="{ active: qnaPage === page }"
									@click="changeQnaPage(page)">
									{{ page }}
								</button>
								<button type="button" class="review-page-btn" :disabled="qnaPage === qnaTotalPage"
									@click="changeQnaPage(qnaPage + 1)">다음</button>
							</div>

						</div>

						<div class="tpane" id="tp-shp">
							<table class="spec">
								<tr>
									<th>배송 방법</th>
									<td>택배 (CJ 대한통운) 또는 매장 직수령</td>
								</tr>
								<tr>
									<th>배송비</th>
									<td>무료배송 (제주·도서산간 +3,000원)</td>
								</tr>
								<tr>
									<th>대여 반납</th>
									<td>반납일 오전 10시까지 · 택배 반납 가능</td>
								</tr>
								<tr>
									<th>연체 요금</th>
									<td>1일당 12,000원 (대여가의 150%)</td>
								</tr>
								<tr>
									<th>파손/분실</th>
									<td>수리 비용 또는 정가의 80% 배상</td>
								</tr>
								<tr>
									<th>반품/교환</th>
									<td>수령 후 30일 이내 (구매 상품)</td>
								</tr>
							</table>
						</div>
					</div>

					<!-- RELATED -->
					<div class="rel" v-if="relatedList.length > 0">
						<h2 class="sectl">같은 카테고리 상품</h2>
						<div class="rgrid">
							<div class="pcard" v-for="item in relatedList" :key="item.productId"
								:class="{ 'is-rental': item.productType === 'RENTAL' }"
								@click="goDetail(item.productId)">
								<div class="pcimg">
									<img v-if="item.imgUrl" :src="item.imgUrl"
										style="width:100%;height:100%;object-fit:cover;">
									<i v-else class="ri-image-line product-empty-icon"></i>

									<span class="pcbdg" :class="{ rental: item.productType === 'RENTAL' }">
										<i
											:class="item.productType === 'RENTAL' ? 'ri-calendar-check-line' : 'ri-shopping-bag-3-fill'"></i>
										{{ item.productType === 'RENTAL' ? '대여' : '구매' }}
									</span>

									<button type="button" class="pc-wish-btn" :class="{ on: item.isWished }"
										@click.stop="fnRelatedWish(item)">
										<i :class="item.isWished ? 'ri-heart-fill' : 'ri-heart-line'"></i>
									</button>
								</div>
								<div class="pcbody">
									<div class="pc-category-line">
										{{ item.categoryName }}
									</div>
									<div class="pc-title-line">
										<span class="pcnm">{{ item.productName }}</span>
										<span class="pc-dot" v-if="item.brandName">·</span>
										<span class="pcbr" v-if="item.brandName">{{ item.brandName }}</span>
									</div>

									<div class="pcs">
										<span class="pc-star-wrap">
											<span v-for="i in 5" :key="i" class="rating-star small">
												<span class="rating-star-fill"
													:style="{ width: getStarFill(item.rating, i) + '%' }">★</span>
												<span class="rating-star-empty">★</span>
											</span>
										</span>
										<span class="pc-rating-num">{{ formatRatingOne(item.rating) }}</span>
										<span class="pc-review-count">({{ item.rCount || 0 }})</span>
									</div>

									<div class="pcprice">{{ formatPrice(item.price) }}</div>
									<!-- pcacts(구매/대여 버튼) 영역 삭제됨 -->
								</div>
							</div>
						</div>

						<!-- 상품 이미지 확대 모달 -->
						<div v-if="reviewImgModal.open && reviewImgModal.reviewIndex === -1"
							class="modal-overlay zoom-mode" @click.self="reviewImgModal.open = false">

							<div class="zoom-content-wrapper product-zoom-modal">
								<button type="button" class="btn-close-out" @click="reviewImgModal.open = false">
									<i class="ri-close-line"></i>
								</button>

								<button type="button" class="btn-img-nav prev product-modal-nav"
									v-if="productImages.length > 1 && reviewImgModal.imgIndex > 0"
									@click.stop="modalImgMove(-1)">
									<i class="ri-arrow-left-s-line"></i>
								</button>

								<img :src="reviewImgModal.url" class="zoom-img-main">

								<button type="button" class="btn-img-nav next product-modal-nav"
									v-if="productImages.length > 1 && reviewImgModal.imgIndex < productImages.length - 1"
									@click.stop="modalImgMove(1)">
									<i class="ri-arrow-right-s-line"></i>
								</button>

								<div class="img-indicators product-modal-indicators" v-if="productImages.length > 1">
									<span v-for="(img, idx) in productImages" :key="idx" class="dot"
										:class="{ active: idx === reviewImgModal.imgIndex }"
										@click.stop="setProductModalImg(idx)">
									</span>
								</div>
							</div>
						</div>

						<!-- 2. 리뷰 이미지 상세 모달 (이미지 + 리뷰 내용) -->
						<div v-if="reviewImgModal.open && reviewImgModal.reviewIndex >= 0"
							class="modal-overlay detail-mode" @click.self="reviewImgModal.open = false">

							<div class="detail-modal-container">
								<div class="detail-main-body">

									<!-- 왼쪽 이미지 영역 -->
									<div class="detail-image-section">
										<img :src="reviewImgModal.url" class="img-display">

										<!-- 리뷰 이미지 이전 -->
										<button type="button" class="btn-img-nav prev"
											v-if="getCurrentReviewImages().length > 1 && reviewImgModal.imgIndex > 0"
											@click.stop="modalImgMove(-1)">
											<i class="ri-arrow-left-s-line"></i>
										</button>

										<!-- 리뷰 이미지 다음 -->
										<button type="button" class="btn-img-nav next"
											v-if="getCurrentReviewImages().length > 1 && reviewImgModal.imgIndex < getCurrentReviewImages().length - 1"
											@click.stop="modalImgMove(1)">
											<i class="ri-arrow-right-s-line"></i>
										</button>

										<!-- 이미지 순서 점 -->
										<div class="img-indicators" v-if="getCurrentReviewImages().length > 1">
											<span v-for="(img, idx) in getCurrentReviewImages()" :key="idx" class="dot"
												:class="{ active: idx === reviewImgModal.imgIndex }"
												@click.stop="setReviewModalImg(idx)">
											</span>
										</div>
									</div>

									<!-- 오른쪽 리뷰 내용 영역 -->
									<div class="detail-info-section">
										<button type="button" class="btn-close-in" @click="reviewImgModal.open = false">
											<i class="ri-close-line"></i>
										</button>

										<div class="user-header">
											<img :src="reviewList[reviewImgModal.reviewIndex]?.profileImgUrl || '/upload/profile/default-profile.png'"
												class="user-avatar">

											<div class="user-meta">
												<div class="name-row">
													<span class="nickname">
														{{ reviewList[reviewImgModal.reviewIndex]?.nickname }}
													</span>

													<span v-if="reviewList[reviewImgModal.reviewIndex]?.gradeId >= 4"
														class="badge vip">VIP</span>

													<span
														v-else-if="reviewList[reviewImgModal.reviewIndex]?.gradeId == 3"
														class="badge gold">GOLD</span>
												</div>

												<div class="star-row">
													<div class="stars">
														<span v-for="i in 5" :key="i" class="star"
															:class="{ filled: i <= reviewList[reviewImgModal.reviewIndex]?.rating }">
															★
														</span>
													</div>

													<span class="rating-num">
														{{ reviewList[reviewImgModal.reviewIndex]?.rating }}점
													</span>
												</div>
											</div>

											<span class="create-date">
												<template
													v-if="reviewList[reviewImgModal.reviewIndex]?.updatedAt 
        													&& reviewList[reviewImgModal.reviewIndex]?.updatedAt !== reviewList[reviewImgModal.reviewIndex]?.createdAt">
													{{ reviewList[reviewImgModal.reviewIndex]?.updatedAt }}
												</template>
												<template v-else>
													{{ reviewList[reviewImgModal.reviewIndex]?.createdAt }}
												</template>
											</span>
										</div>

										<div class="review-text-content custom-scroll">
											<h3 class="review-title">
												{{ reviewList[reviewImgModal.reviewIndex]?.title }}
											</h3>

											<p class="review-body">
												{{ reviewList[reviewImgModal.reviewIndex]?.content }}
											</p>
										</div>
									</div>

								</div>
							</div>
						</div>
					</div>
				</div>
				<div v-if="qnaModal.open" class="modal-overlay" @click.self="closeQnaModal" style="z-index: 100000;">
					<div class="confirm-box qna-modal-box">
						<div class="qna-header">
							<h3 class="qna-title">
								{{ qnaModal.mode === 'add' ? '상품 문의하기' : '문의 수정하기' }}
							</h3>
							<button type="button" class="qna-close-btn" @click="closeQnaModal">
								<i class="ri-close-line"></i>
							</button>
						</div>

						<div v-if="Object.keys(groupedOptions).length > 0" class="qna-option-group">
							<div v-for="(options, groupName) in groupedOptions" :key="groupName"
								class="qna-option-item">
								<label class="qna-label">{{ groupName }}</label>
								<select v-model="qnaModal.selectedOptionsMap[groupName]" class="report-select">
									<option value="" disabled>{{ groupName }}을(를) 선택해 주세요</option>
									<option v-for="opt in options" :key="opt.optionValue" :value="opt.optionValue">
										{{ opt.optionValue }}
									</option>
								</select>
							</div>
						</div>

						<div style="margin-bottom: 16px;">
							<label class="qna-label">문의 내용</label>
							<textarea v-model="qnaModal.content" class="report-textarea qna-textarea"
								placeholder="문의하실 내용을 입력해 주세요.&#13;&#10;(개인정보는 노출되지 않도록 주의해 주세요.)"></textarea>
						</div>

						<div class="qna-secret-wrap">
							<label class="photo-review-check">
								<input type="checkbox" v-model="qnaModal.secretYn" true-value="Y" false-value="N">
								<span class="check-ui"></span>
								<span>비밀글로 작성하기 (판매자와 작성자만 볼 수 있어요)</span>
							</label>
						</div>

						<div class="confirm-btns">
							<button class="confirm-cancel" @click="closeQnaModal">취소</button>
							<button class="confirm-ok" @click="submitQna">{{ qnaModal.mode === 'add' ? '등록하기' : '수정하기'
								}}</button>
						</div>
					</div>
				</div>
				<!-- 확인 모달 -->
				<div v-if="confirmModal.open" class="confirm-overlay" @click.self="confirmCancel">
					<div class="confirm-box">
						<div class="confirm-title">알림</div>
						<div class="confirm-message">{{ confirmModal.message }}</div>
						<div class="confirm-btns">
							<button class="confirm-ok" @click="confirmOk">
								{{ confirmModal.okText }}
							</button>
							<button class="confirm-cancel" @click="confirmCancel">
								{{ confirmModal.cancelText }}
							</button>
						</div>
					</div>
				</div>
				<div v-if="reportModal.open" class="report-modal-overlay" @click.self="closeReportModal">
					<div class="report-modal-box">
						<div class="report-modal-title">리뷰 신고</div>
						<div class="report-modal-desc">
							신고 사유를 선택해 주세요.
						</div>

						<select class="report-select" v-model="reportModal.reason">
							<option value="">신고 사유 선택</option>
							<option value="욕설/비방">욕설/비방</option>
							<option value="허위 정보">허위 정보</option>
							<option value="광고성 리뷰">광고성 리뷰</option>
							<option value="상품과 무관한 내용">상품과 무관한 내용</option>
							<option value="개인정보 노출">개인정보 노출</option>
							<option value="기타">직접 입력</option>
						</select>

						<div v-if="reportModal.reason === '기타'" class="report-custom-wrap">
							<textarea class="report-textarea" v-model="reportModal.content" maxlength="500"
								placeholder="신고 사유를 직접 입력해 주세요."></textarea>

							<div class="report-count">
								{{ reportModal.content.length }}/500
							</div>
						</div>

						<div class="report-modal-actions">
							<button type="button" class="report-cancel" @click="closeReportModal">
								취소
							</button>
							<button type="button" class="report-submit" @click="submitReport">
								신고하기
							</button>
						</div>
					</div>
				</div>
				<!-- TOP 버튼 -->
				<button type="button" class="scroll-top-btn" :class="{ show: showTopBtn }" @click="scrollToTop"
					aria-label="맨 위로 이동">
					<i class="ri-arrow-up-line"></i>
				</button>

				<!-- AI 추천 모달 -->
				<div v-if="showAiModal" class="ai-rec-overlay" @click.self="showAiModal=false">
					<div class="ai-rec-modal">
						<div class="ai-rec-header">
							<span><i class="ri-robot-2-line"></i> AI 추천 상품</span>
							<button type="button" @click="showAiModal=false">
								<i class="ri-close-line"></i>
							</button>
						</div>
						<p class="ai-rec-sub">이 상품과 함께하면 더 좋아요 ✨</p>

						<div v-if="aiRecommendLoading" class="ai-loading">
							<span class="ai-spinner"></span>
							<span>AI가 추천 상품을 분석 중이에요...</span>
						</div>

						<div v-else class="ai-rec-grid">
							<div v-for="item in aiRecommendList" :key="item.productId" class="ai-rec-card"
								@click="goDetail(item.productId)">

								<div class="ai-rec-img">
									<img :src="item.imgUrl || '/img/product/default.jpg'" :alt="item.productName">

									<span class="ai-rec-type-badge" :class="{ rental: item.productType === 'RENTAL' }">
										<i
											:class="item.productType === 'RENTAL' ? 'ri-calendar-check-line' : 'ri-shopping-bag-3-fill'"></i>
										{{ item.productType === 'RENTAL' ? '대여' : '구매' }}
									</span>

									<button type="button" class="ai-rec-wish-btn" :class="{ on: item.isWished }"
										@click.stop="fnRelatedWish(item)">
										<i :class="item.isWished ? 'ri-heart-fill' : 'ri-heart-line'"></i>
									</button>
								</div>

								<div class="ai-rec-info">
									<span class="ai-rec-cat-chip" v-if="item.categoryName">{{ item.categoryName
										}}</span>

									<div class="ai-rec-name">
										{{ item.productName }}
										<span class="ai-rec-brand-inline" v-if="item.brandName">· {{ item.brandName
											}}</span>
									</div>

									<div class="ai-rec-meta">
										<span class="ai-rec-star-wrap">
											<span v-for="i in 5" :key="i" class="rating-star small">
												<span class="rating-star-fill"
													:style="{ width: getStarFill(item.rating, i) + '%' }">★</span>
												<span class="rating-star-empty">★</span>
											</span>
										</span>
										<span class="ai-rec-rating-num">{{ formatRatingOne(item.rating) }}</span>
										<span class="ai-rec-review-count">({{ item.rCount || 0 }})</span>
									</div>

									<div class="ai-rec-price">
										{{ formatPrice(item.price) }}
										<span class="ai-rec-unit" v-if="item.productType !== 'PURCHASE'">/ 1박</span>
									</div>
								</div>
							</div>
						</div>
						<button type="button" class="ai-rec-skip-btn" v-if="!aiRecommendLoading"
							@click="showAiModal=false">
							괜찮아요
						</button>
					</div>
				</div>

			</div><!-- /#app -->

			<%@ include file="/WEB-INF/common/footer.jsp" %>
	</body>

	</html>

	<script>
		if ('scrollRestoration' in history) {
			history.scrollRestoration = 'manual';
		}

		function forceProductDetailTop() {
			window.scrollTo(0, 0);
			document.documentElement.scrollTop = 0;
			document.body.scrollTop = 0;
		}

		window.addEventListener('pageshow', function () {
			forceProductDetailTop();

			setTimeout(forceProductDetailTop, 50);
			setTimeout(forceProductDetailTop, 200);
			setTimeout(forceProductDetailTop, 500);
		});

		const BUY_NOW_KEY = 'checkout_items';
		const loginUserId = '${sessionScope.sessionId}' || '';
		const LS_KEY = 'modak_guest_cart'; // 장바구니 localStorage 키

		function showToast(msg) {
			var t = document.getElementById('toast');

			if (!t) {
				t = document.createElement('div');
				t.id = 'toast';
				t.className = 'toast';
				document.body.appendChild(t);
			}

			t.textContent = msg;
			t.classList.add('show');

			setTimeout(() => {
				t.classList.remove('show');
			}, 2000);
		}

		function setGem(e, el) {
			document.getElementById('gem').textContent = e;
			document.querySelectorAll('.gth').forEach(t => t.classList.remove('on'));
			el.classList.add('on');
		}

		function setMode(m) {
			const r = m === 'rent';
			document.getElementById('mb-buy').classList.toggle('on', !r);
			document.getElementById('mb-rent').classList.toggle('on', r);
			document.body.classList.toggle('rent', r);
			if (window.__vueApp) window.__vueApp.cartMode = r ? 'RENT' : 'BUY';
		}

		const app = Vue.createApp({
			data() {
				return {
					wishedIds: [],
					productId: '${productId}',
					productInfo: {},
					productImages: [],
					mainImgUrl: '',
					reviewList: [],
					orderCount: 0,
					productType: '',
					availableQty: 0,
					totalQty: 0,
					qty: 1,
					currentYear: new Date().getFullYear(),
					currentMonth: new Date().getMonth(),
					rentedRanges: [],
					startDate: null,
					endDate: null,
					isWished: false,
					relatedList: [],
					productSpec: {},
					productFeatures: [],
					faqList: [],
					openFaqIndex: [],
					calOpen: false,
					productOptions: [],
					selectedOptions: [],
					cartMode: 'RENT',
					isLogin: false,          // ← 추가: 로그인 여부
					bestCoupon: null,     // ← 추가: 최대혜택 쿠폰 정보
					couponLoaded: false,  // ← 추가: 쿠폰 조회 완료 여부
					confirmModal: { open: false, message: '', okText: '확인', cancelText: '취소', onOk: null },
					reviewImgModal: { open: false, url: '', reviewIndex: -1, imgIndex: 0 },
					reportModal: {
						open: false,
						reviewId: null,
						reason: '',
						content: ''
					},
					loginUserId: loginUserId,
					showTopBtn: false,

					reviewPage: 1,
					reviewPageSize: 10,

					// 전체 리뷰 통계용
					reviewTotalCount: 0,
					reviewAllList: [],

					// 현재 필터/검색 결과용
					filteredReviewCount: 0,

					reviewOnlyPhoto: false,
					reviewSort: 'latest',
					reviewKeyword: '',
					openReviewMenuId: null,
					reviewSummary: "",
					reviewSummaryLoading: false,
					// qna 문의
					qnaList: [],
					qnaPage: 1,
					qnaPageSize: 5,
					qnaTotalCount: 0,
					qnaKeyword: '',
					qnaSearchKeyword: '',
					qnaModal: {
						open: false,
						mode: 'add',
						qnaId: null,
						selectedOptionsMap: {}, // 여러 옵션을 담을 빈 객체
						content: '',
						secretYn: 'N'
					},
					// ai 제품 추천
					aiRecommendList: [],
					aiRecommendLoading: false,
					showAiModal: false,
					// 옵션별 재고 확인용
					optionStock: null, // 선택된 옵션 조합의 재고 (null = 미조회)
					optionStockLoading: false,
				};
			},

			computed: {
				isLowStock() {
					return this.displayQty > 0 && this.displayQty <= 5;
				},
				lowStockText() {
					if (this.displayQty <= 0) return '품절';
					if (this.displayQty <= 5) return '재고 ' + this.displayQty + '개 남음 · 품절임박';
					return '';
				},
				couponNoteText() {
					if (!this.couponLoaded) return '';
					if (!this.isLogin) return '🎁 지금 가입하면 쿠폰 할인받기 →';
					if (!this.bestCoupon) return '😊 사용 가능한 쿠폰이 없어요';
					if (this.bestCoupon.couponType === 'RATE') {
						return '🎉 쿠폰 적용 시 ' + this.bestCoupon.discountRate + '% 할인!';
					}
					var amt = Number(this.bestCoupon.discountAmt).toLocaleString('ko-KR');
					return '🎉 쿠폰 적용 시 최대 ' + amt + '원 할인!';
				},

				reviewTotalPage() {
					return Math.ceil(this.filteredReviewCount / this.reviewPageSize);
				},
				rewardPoint() {
					return Math.round(Number(this.totalPrice || 0) * 0.01);
				},

				rewardPointPerNight() {
					return Math.round(Number(this.unitPrice || 0) * 0.01);
				},
				detailImgUrl() {
					const desc = this.productInfo.description;

					if (!desc) {
						return '';
					}

					return desc;
				},


				displayQty() {
					// 옵션 재고가 있으면 옵션 재고 우선
					if (this.optionStock !== null) {
						return this.productType === 'PURCHASE'
							? this.optionStock.totalQty
							: this.optionStock.availableQty;
					}
					return this.productType === 'PURCHASE' ? this.totalQty : this.availableQty;
				},
				remainQty() { return this.displayQty - this.qty; },
				// 옵션 선택전에 수량 X
				qtyLocked() {
					return this.productOptions.length > 0 && this.optionStock === null;
				},

				calendarDays() {
					const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
					const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();

					const tomorrow = new Date();
					tomorrow.setDate(tomorrow.getDate() + 1);
					tomorrow.setHours(0, 0, 0, 0);

					const days = [];

					for (let i = 0; i < firstDay; i++) {
						days.push(null);
					}

					for (let d = 1; d <= lastDate; d++) {
						const dateObj = new Date(this.currentYear, this.currentMonth, d);
						dateObj.setHours(0, 0, 0, 0);

						const fullStr = this.formatDateCal(dateObj);

						days.push({
							date: d,
							full: fullStr,
							isRented: this.checkIsRented(fullStr),
							isPast: dateObj < tomorrow
						});
					}

					return days;
				},
				rentDays() {
					if (!this.startDate || !this.endDate) return 0;
					return Math.ceil((new Date(this.endDate) - new Date(this.startDate)) / (1000 * 60 * 60 * 24));
				},
				// 대여 수량 * 보증금
				rentSubtotal() {
					return this.unitPrice * this.rentDays * this.qty;
				},
				rentDepositTotal() {
					return (this.productInfo.deposit || 0) * this.qty;
				},
				rentTotalPrice() {
					return this.rentSubtotal + this.rentDepositTotal;
				},

				avgRating() {
					if (!this.reviewAllList.length) return 0;

					const sum = this.reviewAllList.reduce((acc, r) => {
						return acc + Number(r.rating || 0);
					}, 0);

					return sum / this.reviewAllList.length;
				},
				avgStars() {
					const num = parseFloat(this.avgRating);

					if (!num || num <= 0) {
						return ['☆', '☆', '☆', '☆', '☆'];
					}

					const rounded = Math.round(num);

					return Array.from({ length: 5 }, (_, i) => {
						return i < rounded ? '★' : '☆';
					});
				},
				ratingDist() {
					const dist = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };

					this.reviewAllList.forEach(r => {
						const s = Math.round(Number(r.rating || 0));
						if (dist[s] !== undefined) {
							dist[s]++;
						}
					});

					const total = this.reviewAllList.length || 1;

					return [5, 4, 3, 2, 1].map(score => ({
						score: score,
						count: dist[score],
						pct: Math.round((dist[score] / total) * 100)
					}));
				},
				groupedOptions() {
					const groups = {};
					this.productOptions.forEach(opt => {
						if (!groups[opt.optionName]) groups[opt.optionName] = [];
						groups[opt.optionName].push(opt);
					});
					return groups;
				},
				totalAddPrice() {
					return Object.values(this.selectedOptions).reduce((sum, opt) => sum + (opt.addPrice || 0), 0);
				},
				unitPrice() { return (this.productInfo.price || 0) + this.totalAddPrice; },
				totalPrice() { return this.unitPrice * this.qty; },
				totalPriceFormatted() { return this.totalPrice.toLocaleString('ko-KR') + '원'; },

				// qna 문의
				qnaTotalPage() {
					return Math.ceil(this.qnaTotalCount / this.qnaPageSize) || 1;
				},
			},

			methods: {
				openCalendar() {
					// 필수 옵션 선택 여부 검증
					if (this.productOptions.length > 0) {
						const optionGroupCount = Object.keys(this.groupedOptions).length;
						const selectedCount = Object.keys(this.selectedOptions).length;

						if (selectedCount < optionGroupCount) {
							showToast('옵션을 먼저 선택해주세요.');
							return; // 옵션을 모두 선택하지 않았다면 여기서 함수를 종료하여 캘린더를 열지 않음
						}
					}

					const tomorrow = new Date();
					tomorrow.setDate(tomorrow.getDate() + 1);

					this.currentYear = tomorrow.getFullYear();
					this.currentMonth = tomorrow.getMonth();
					this.calOpen = true;

					this.$nextTick(() => {
						const tomorrowStr = this.formatDateCal(tomorrow);
						const target = document.querySelector(`[data-date="${tomorrowStr}"]`);

						if (target) {
							target.classList.add('focus-day');
							target.scrollIntoView({
								block: 'center',
								behavior: 'smooth'
							});
						}
					});
				},
				/* ── 로그인 체크 ── */
				checkLogin() {
					let self = this;
					$.ajax({
						url: '/user/session-check.dox', type: 'POST', dataType: 'json',
						success(res) { self.isLogin = res.isLogin === true; },
						error() { self.isLogin = false; }
					});
				},
				// ↓ 추가 쿠폰
				fetchBestCoupon() {
					let self = this;
					$.ajax({
						url: '/coupon/bestCoupon.dox', type: 'POST', dataType: 'json',
						success(res) {
							self.isLogin = res.isLogin === true;
							self.bestCoupon = res.coupon || null;
							self.couponLoaded = true;
						},
						error() {
							self.couponLoaded = true;
						}
					});
				},

				/* ── localStorage 헬퍼 ── */
				loadGuestCart() {
					try { return JSON.parse(localStorage.getItem(LS_KEY)) || []; }
					catch (e) { return []; }
				},
				saveGuestCart(cart) {
					localStorage.setItem(LS_KEY, JSON.stringify(cart));
				},

				/* ── 상품 정보 로드 ── */
				fnDetail() {
					let self = this;
					$.ajax({
						url: '/product/detail.dox', type: 'POST',
						data: { productId: self.productId }, dataType: 'json',
						success(data) {
							if (!data || !data.info) {
								console.error('상품 정보 없음:', data);
								return;
							}
							self.productInfo = data.info;
							self.orderCount = data.orderCount || 0;
							self.availableQty = data.info.availableQty || 0;
							self.totalQty = data.info.totalQty || 0;
							self.productSpec = data.spec || {};
							self.productFeatures = data.features || [];
							self.faqList = data.faqList || [];
							self.productOptions = data.options || [];
							self.productType = data.info.productType || '';
							self.fetchRelatedProducts(data.info.categoryId);

							if (self.productType === 'RENTAL') { setMode('rent'); self.cartMode = 'RENT'; }
							else if (self.productType === 'PURCHASE') { setMode('buy'); self.cartMode = 'BUY'; }

							$.ajax({
								url: '/user/wishlist/list.dox', type: 'POST', dataType: 'json',
								success(wRes) {
									if (wRes.result === 'success' && wRes.list) {
										const wishedIds = wRes.list.map(w => w.productId);
										self.wishedIds = wishedIds; // ← 저장
										self.isWished = wishedIds.indexOf(parseInt(self.productId)) !== -1;
									}
								}
							});
						}
					});
				},
				fetchProductImages() {
					let self = this;
					$.ajax({
						url: '/product/detail.dox', type: 'POST',
						data: { productId: self.productId },
						success(data) {
							const imageList = data.img || [];
							self.productImages = imageList;
							if (imageList.length > 0) {
								const main = imageList.find(i => i.mainImg === 'Y');
								self.mainImgUrl = main ? main.imgUrl : imageList[0].imgUrl;
							} else {
								self.mainImgUrl = '/img/product/default.jpg';
							}
						},
						error() { self.productImages = []; self.mainImgUrl = '/img/product/default.jpg'; }
					});
				},
				setMainImg(imgUrl) { this.mainImgUrl = imgUrl; },
				changeMainImg(dir) {
					if (!this.productImages || this.productImages.length === 0) {
						return;
					}

					const currentIndex = this.productImages.findIndex(img => img.imgUrl === this.mainImgUrl);
					const safeIndex = currentIndex === -1 ? 0 : currentIndex;
					const nextIndex = (safeIndex + dir + this.productImages.length) % this.productImages.length;

					this.mainImgUrl = this.productImages[nextIndex].imgUrl;
				},
				fnGetReviews() {
					let self = this;

					$.ajax({
						url: '/review/list.dox',
						type: 'POST',
						data: {
							productId: self.productId,
							page: self.reviewPage,
							pageSize: self.reviewPageSize,
							loginUserId: self.loginUserId,

							onlyPhoto: self.reviewOnlyPhoto ? 'Y' : 'N',
							sort: self.reviewSort,
							keyword: self.reviewKeyword
						},
						dataType: 'json',
						success(data) {
							self.reviewList = data.list || [];
							self.filteredReviewCount = data.totalCount || 0;

							const isDefaultReviewView =
								!self.reviewOnlyPhoto &&
								!self.reviewKeyword &&
								self.reviewSort === 'latest';

							if (isDefaultReviewView && self.reviewPage === 1) {
								self.reviewAllList = data.list || [];
								self.reviewTotalCount = data.totalCount || 0;
							}
						},
						error() {
							self.reviewList = [];
							self.filteredReviewCount = 0;
						}
					});
				}, applyReviewFilter() {
					this.reviewPage = 1;
					this.fnGetReviews();
				},

				resetReviewFilter() {
					this.reviewOnlyPhoto = false;
					this.reviewSort = 'latest';
					this.reviewKeyword = '';
					this.reviewPage = 1;
					this.fnGetReviews();
				},

				/* ── 장바구니 담기 (회원/비회원 분기 핵심) ── */
				fnAddToCart() {
					let self = this;

					// 옵션 검증
					if (self.productOptions.length > 0) {
						const optionGroupCount = Object.keys(self.groupedOptions).length;
						const selectedCount = Object.keys(self.selectedOptions).length;
						if (selectedCount < optionGroupCount) { showToast('옵션을 선택해주세요.'); return; }
					}

					// 대여 날짜 검증
					if (self.productType === 'RENTAL' && (!self.startDate || !self.endDate)) {
						showToast('대여 날짜를 선택해주세요.'); return;
					}

					// 구매 수량 검증
					if (self.productType === 'PURCHASE') {
						if (self.qty < 1) { showToast('수량을 선택해주세요.'); return; }
						if (self.qty > self.totalQty) { showToast('재고가 부족합니다.'); return; }
					}

					const selectedOptionValues = Object.values(self.selectedOptions);

					const optionId = selectedOptionValues.map(opt => opt.optionValueId).join(',');
					const optionName = selectedOptionValues.map(opt => opt.optionValue).join(' / ');
					let optionItemId = '';

					if (optionId) {
						$.ajax({
							url: '/product/option/item/get.dox',
							type: 'POST',
							data: {
								productId: self.productId,
								optionValueIds: optionId
							},
							dataType: 'json',
							async: false,
							success(res) {
								if (res.result === 'success') {
									optionItemId = res.optionItemId;
									self.fetchAiRecommendations();
								}
							}
						});

						if (!optionItemId) {
							showToast('옵션 조합 정보를 찾을 수 없습니다.');
							return;
						}
					}

					/* ══ 비회원: localStorage 저장 ══ */
					if (!self.isLogin) {
						const cart = self.loadGuestCart();

						const newItem = {
							cartId: Date.now(),
							cartType: self.productType,
							productId: parseInt(self.productId),
							productName: self.productInfo.productName || '',
							price: self.unitPrice,
							quantity: self.qty,
							imgUrl: self.mainImgUrl || '',
							brandName: self.productInfo.brandName || '',

							optionValueIds: optionId,
							optionItemId: optionItemId,   // 🔥 이거 하나만
							optionName: optionName,

							rentalStart: self.productType === 'RENTAL' ? self.startDate : null,
							rentalEnd: self.productType === 'RENTAL' ? self.endDate : null,
							deposit: self.productInfo.deposit || 0
						};

						// 중복 체크
						const dup = cart.find(c =>
							c.productId === newItem.productId &&
							c.cartType === newItem.cartType &&
							c.optionValueIds === newItem.optionValueIds &&
							c.rentalStart === newItem.rentalStart &&
							c.rentalEnd === newItem.rentalEnd
						);

						if (dup) {
							dup.quantity += self.qty;
							self.saveGuestCart(cart);
							self.openConfirm('이미 같은 조건의 상품이 있어 수량을 추가했습니다. 장바구니로 이동할까요?', function () {
								location.href = '/cart/list.do?cartType=' + self.productType;
							}, '이동하기');
						} else {
							cart.push(newItem);
							self.fetchAiRecommendations();
							self.saveGuestCart(cart);
							self.openConfirm('장바구니에 담았습니다. 장바구니로 이동할까요?', function () {
								location.href = '/cart/list.do?cartType=' + self.productType;
							}, '이동하기');
						}
						if (typeof fnCheckCartCount === 'function') {
							fnCheckCartCount();
						}
						return;
					}

					/* ══ 회원: 서버 API 호출 ══ */
					const param = {
						productId: self.productId,
						quantity: self.qty,
						cartType: self.productType,
						optionValueIds: optionId,
						optionItemId: optionItemId,
						rentalStart: self.productType === 'RENTAL' ? self.startDate : '',
						rentalEnd: self.productType === 'RENTAL' ? self.endDate : ''
					};

					$.ajax({
						url: '/cart/add.dox', type: 'POST',
						data: param, dataType: 'json',
						success(res) {
							if (res.result === 'duplicate') {
								self.openConfirm('이미 같은 조건의 상품이 있습니다. 장바구니로 이동할까요?', function () {
									location.href = '/cart/list.do?cartType=' + self.productType;
								}, '이동하기');
							} else if (res.result === 'success') {
								self.openConfirm('장바구니에 담았습니다. 장바구니로 이동할까요?', function () {
									location.href = '/cart/list.do?cartType=' + self.productType;
								}, '이동하기');
							} else {
								showToast('장바구니 담기 실패');
							}
						},
						error() { showToast('장바구니 담기 중 오류가 발생했습니다.'); }
					});
				},

				/* ── 나머지 메서드 ── */
				getStars(rating) { return Array.from({ length: 5 }, (_, i) => i < rating ? '★' : '☆'); },
				formatDate(dateStr) { if (!dateStr) return ''; return dateStr.slice(0, 10).replace(/-/g, '.'); },
				stab(n, event) {
					const el = event.currentTarget;

					document.querySelectorAll('.tbtn').forEach(b => b.classList.remove('on'));
					document.querySelectorAll('.tpane').forEach(p => p.classList.remove('on'));

					el.classList.add('on');
					document.getElementById('tp-' + n).classList.add('on');

					this.moveUnderline(el);
					if (
						n === 'rev' &&
						!this.reviewSummary &&
						!this.reviewSummaryLoading
					) {
						this.fetchReviewSummary();
					}
				},
				moveUnderline(el) {
					const underline = document.querySelector('.t-underline');

					const left = el.offsetLeft;
					const width = el.offsetWidth;

					underline.style.left = left + 'px';
					underline.style.width = width + 'px';
				},
				openImg(url, reviewIndex, imgIndex) {
					if (!url) {
						return;
					}

					// 상품 이미지 모달
					if (reviewIndex === undefined) {
						const productIndex = this.productImages.findIndex(img => img.imgUrl === url);

						this.reviewImgModal = {
							open: true,
							url: url,
							reviewIndex: -1,
							imgIndex: productIndex >= 0 ? productIndex : 0
						};

						return;
					}

					// 리뷰 이미지 모달
					this.reviewImgModal = {
						open: true,
						url: url,
						reviewIndex: reviewIndex,
						imgIndex: imgIndex || 0
					};
				},

				getCurrentReviewImages() {
					const review = this.reviewList[this.reviewImgModal.reviewIndex];

					if (!review || !review.imageList) {
						return [];
					}

					return review.imageList;
				},

				setReviewModalImg(idx) {
					const imgs = this.getCurrentReviewImages();
					const img = imgs[idx];

					if (!img) {
						return;
					}

					this.reviewImgModal.imgIndex = idx;
					this.reviewImgModal.url = img.imgUrl;
				},

				modalImgMove(dir) {
					const m = this.reviewImgModal;

					// 상품 이미지 모달 이동
					if (m.reviewIndex === -1) {
						const imgs = this.productImages || [];
						const next = m.imgIndex + dir;

						if (next < 0 || next >= imgs.length) {
							return;
						}

						m.imgIndex = next;
						m.url = imgs[next].imgUrl;
						this.mainImgUrl = imgs[next].imgUrl;

						return;
					}

					// 리뷰 이미지 모달 이동
					const imgs = this.getCurrentReviewImages();
					const next = m.imgIndex + dir;

					if (next < 0 || next >= imgs.length) {
						return;
					}

					m.imgIndex = next;
					m.url = imgs[next].imgUrl;
				},
				setProductModalImg(idx) {
					const img = this.productImages[idx];

					if (!img) {
						return;
					}

					this.reviewImgModal.imgIndex = idx;
					this.reviewImgModal.url = img.imgUrl;
					this.mainImgUrl = img.imgUrl;
				},

				// 모달 내 리뷰 이동
				modalReviewMove(dir) {
					const m = this.reviewImgModal;
					// 리뷰 중 이미지 있는 것만
					const reviewsWithImg = this.reviewList
						.map((r, i) => ({ r, i }))
						.filter(({ r }) => r.imageList && r.imageList.length > 0);

					const curPos = reviewsWithImg.findIndex(({ i }) => i === m.reviewIndex);
					const nextPos = curPos + dir;
					if (nextPos < 0 || nextPos >= reviewsWithImg.length) return;

					const { r, i } = reviewsWithImg[nextPos];
					m.reviewIndex = i;
					m.imgIndex = 0;
					m.url = r.imageList[0].imgUrl;
				},
				formatPrice(price) { if (!price) return '0원'; return Number(price).toLocaleString('ko-KR') + '원'; },
				// 재고 수량 +, - 버튼
				chgQty(d) {
					if (this.qtyLocked) return;
					const max = this.displayQty;
					const next = this.qty + d;
					if (next < 1) return;
					if (next > max) { showToast('재고가 부족합니다. (최대 ' + max + '개)'); return; }
					this.qty = next;
				},
				// 재고 수량 직접 입력
				onQtyInput(event) {
					const raw = event.target.value;
					const max = this.displayQty;

					// 입력 중엔 건드리지 않음 (빈값, "0", "01" 등 중간 상태 허용)
					if (raw === '' || raw === '0') {
						this.qty = 0;  // 내부값만 0으로, input은 그대로
						return;
					}

					const val = parseInt(raw);
					if (isNaN(val)) return;  // 숫자가 아니면 무시

					if (val > max) {
						this.qty = max;
						event.target.value = max;  // 초과분만 보정
						showToast('재고가 부족합니다. (최대 ' + max + '개)');
					} else {
						this.qty = val;  // 정상 범위면 그냥 반영
					}
				},
				onQtyBlur(event) {
					// 포커스 벗어날 때 빈 값이면 1로 리셋
					if (!event.target.value || parseInt(event.target.value) < 1) {
						this.qty = 1;
						event.target.value = 1;
					}
				},
				formatDateCal(dateVal) {
					const d = new Date(dateVal);
					return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
				},
				checkIsRented(targetStr) {
					if (!this.rentedRanges || !this.rentedRanges.length) return false;
					return this.rentedRanges.some(range => {
						const s = this.formatDateCal(range.startDate || range.START_DATE);
						const e = this.formatDateCal(range.returnDate || range.RETURN_DATE);
						return targetStr >= s && targetStr <= e;
					});
				},
				getDayClass(day) {
					if (!day) return 'cal-day empty';
					if (day.isRented) return 'cal-day rented';
					if (day.isPast) return 'cal-day past';
					if (day.full === this.startDate || day.full === this.endDate) return 'cal-day selected';
					if (this.startDate && this.endDate && day.full > this.startDate && day.full < this.endDate) return 'cal-day in-range';
					return 'cal-day available';
				},
				onDayClick(day) {
					if (!day || day.isPast || day.isRented) return;

					if (!this.startDate || (this.startDate && this.endDate)) {
						this.startDate = day.full;
						this.endDate = null;
					} else {
						if (day.full < this.startDate) {
							this.startDate = day.full;
						} else if (day.full === this.startDate) {
							this.startDate = null;
						} else {
							// 대여 최대 기간 제한
							const start = new Date(this.startDate);
							const end = new Date(day.full);
							const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

							if (diffDays > 7) {
								showToast('최대 대여 가능 기간은 일주일(7박)입니다.');
								return; // 7일을 초과하면 endDate를 설정하지 않고 종료
							}

							this.endDate = day.full;
						}
					}
				},
				changeMonth(diff) {
					const d = new Date(this.currentYear, this.currentMonth + diff, 1);
					this.currentYear = d.getFullYear();
					this.currentMonth = d.getMonth();
				},
				fetchRentedDates() {
					let self = this;
					$.ajax({
						url: '/rental/calendar/dates.dox', type: 'POST',
						contentType: 'application/json',
						data: JSON.stringify({ itemId: self.productId }),
						success(res) { if (res.result === 'success') self.rentedRanges = res.rentedList; }
					});
				},
				fnRent() {
					if (!this.startDate || !this.endDate) {
						showToast('날짜를 선택해주세요.');
						return;
					}

					if (this.productOptions.length > 0) {
						const optionGroupCount = Object.keys(this.groupedOptions).length;
						const selectedCount = Object.keys(this.selectedOptions).length;

						if (selectedCount < optionGroupCount) {
							showToast('옵션을 선택해주세요.');
							return;
						}
					}

					const selectedOptionValues = Object.values(this.selectedOptions);
					const optionId = selectedOptionValues.map(opt => opt.optionValueId).join(',');
					const optionName = selectedOptionValues.map(opt => opt.optionValue).join(' / ');
					let optionItemId = '';

					if (optionId) {
						$.ajax({
							url: '/product/option/item/get.dox',
							type: 'POST',
							data: {
								productId: this.productId,
								optionValueIds: optionId
							},
							dataType: 'json',
							async: false,
							success(res) {
								if (res.result === 'success') {
									optionItemId = res.optionItemId;
								}
							}
						});

						if (!optionItemId) {
							showToast('옵션 조합 정보를 찾을 수 없습니다.');
							return;
						}
					}

					const buyNowItem = {
						cartId: Date.now(),
						cartType: 'RENTAL',
						productId: parseInt(this.productId),
						productName: this.productInfo.productName || '',
						price: this.unitPrice,
						quantity: 1,
						imgUrl: this.mainImgUrl || '',
						brandName: this.productInfo.brandName || '',
						optionValueIds: optionId,
						optionItemId: optionItemId,
						optionName: optionName,
						rentalStart: this.startDate,
						rentalEnd: this.endDate,
						deposit: this.productInfo.deposit || 0
					};

					localStorage.setItem(BUY_NOW_KEY, JSON.stringify([buyNowItem]));

					//location.href = '/payment/checkout.do?cartType=RENTAL&isGuest=true&buyNow=true';
					location.href = '/payment/checkout.do?cartType=RENTAL&isGuest='
						+ (!this.isLogin)
						+ '&buyNow=true';
				},
				fnWish(e) {
					e.stopPropagation();

					if (!this.isLogin) {
						this.openConfirm('찜하려면 로그인이 필요해요!🔥 \n 로그인하고 마음에 드는 상품을 저장해보세요!', function () {
							location.href = '/user/login.do';
						}, '로그인', '닫기');
						return;
					}

					let self = this;

					$.ajax({
						url: '/user/wishlist/toggle.dox',
						type: 'POST',
						data: { productId: self.productId },
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								self.isWished = !self.isWished;
								showToast(self.isWished ? '❤️ 위시리스트에 추가했어요!' : '위시리스트에서 제거했어요');
							} else {
								self.openConfirm('로그인이 필요한 기능입니다. 로그인 페이지로 이동하시겠습니까?', function () {
									location.href = '/user/login.do';
								}, '확인', '취소');
							}
						}
					});
				},
				fetchRelatedProducts(categoryId) {
					let self = this;
					$.ajax({
						url: '/product/related.dox', type: 'POST',
						data: { categoryId, productId: self.productId }, dataType: 'json',
						success(res) { if (res.result === 'success') self.relatedList = res.list || []; }
					});
				},
				goDetail(productId, mode) {
					let url = '/product/detail.do?productId=' + productId;
					if (mode) url += '&mode=' + mode;
					location.href = url;
				},
				fnInquiry() { location.href = '/inquiry.do'; },
				selectOption(optionName, opt) {
					// 옵션이 변경되면 대여 선택 날짜를 초기화하여 오류 방지
					this.startDate = null;
					this.endDate = null;

					const selected = this.selectedOptions[optionName];

					if (selected && selected.optionValueId === opt.optionValueId) {
						const copy = { ...this.selectedOptions };
						delete copy[optionName];
						this.selectedOptions = copy;
						this.optionStock = null; // ← 선택 해제 시 재고 초기화
						return;
					}

					this.selectedOptions = {
						...this.selectedOptions,
						[optionName]: opt
					};
					// 모든 옵션 선택 완료 시 옵션별 재고 조회
					const optionGroupCount = Object.keys(this.groupedOptions).length;
					const selectedCount = Object.keys(this.selectedOptions).length;
					if (selectedCount === optionGroupCount) {
						this.fetchOptionStock();
					} else {
						this.optionStock = null;
					}
				},
				fetchOptionStock() {
					const selectedOptionValues = Object.values(this.selectedOptions);
					const optionId = selectedOptionValues.map(opt => opt.optionValueId).join(',');
					if (!optionId) return;

					this.optionStockLoading = true;
					this.optionStock = null;

					$.ajax({
						url: '/product/option/stock.dox',
						type: 'POST',
						data: { productId: this.productId, optionValueIds: optionId },
						dataType: 'json',
						success: (res) => {
							if (res.result === 'success') {
								this.optionStock = res.stock; // { totalQty, availableQty }
							}
						},
						complete: () => { this.optionStockLoading = false; }
					});
				},
				reportReview(reviewId) {
					if (!this.loginUserId) {
						this.openConfirm(
							'로그인이 필요한 기능입니다. 로그인 페이지로 이동하시겠습니까?',
							function () {
								location.href = '/user/login.do';
							},
							'확인',
							'취소'
						);
						return;
					}

					this.reportModal.reviewId = reviewId;
					this.reportModal.reason = '';
					this.reportModal.content = '';
					this.reportModal.open = true;
				},
				closeReportModal() {
					this.reportModal.open = false;
					this.reportModal.reviewId = null;
					this.reportModal.reason = '';
					this.reportModal.content = '';
				},

				submitReport() {
					let self = this;
					const reason = self.reportModal.reason;
					const customContent = self.reportModal.content.trim();

					if (!reason) {
						showToast('신고 사유를 선택해주세요.');
						return;
					}

					if (reason === '기타' && !customContent) {
						showToast('신고 사유를 입력해주세요.');
						return;
					}

					const content = reason === '기타'
						? customContent
						: reason;
					$.ajax({
						url: '/review/report.dox',
						type: 'POST',
						data: {
							reviewId: self.reportModal.reviewId,
							content: content
						},
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								self.closeReportModal();
								showToast('리뷰가 신고되었습니다.');
							} else if (res.result === 'login') {
								self.closeReportModal();
								self.openConfirm('로그인이 필요합니다. 로그인하시겠습니까?', function () {
									location.href = '/user/login.do';
								}, '로그인하기');
							} else if (res.result === 'duplicate') {
								self.closeReportModal();
								showToast('이미 신고한 리뷰입니다.');
							} else {
								showToast('신고 처리에 실패했습니다.');
							}
						},
						error() {
							showToast('신고 처리 중 오류가 발생했습니다.');
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
					if (typeof this.confirmModal.onOk === 'function') this.confirmModal.onOk();
					this.confirmModal.open = false;
				},
				confirmCancel() { this.confirmModal.open = false; },
				formatRatingInt(rating) {
					return Math.round(Number(rating || 0));
				},



				formatRatingOne(value) {
					const num = Number(value);
					if (Number.isNaN(num)) {
						return '0.0';
					}
					return num.toFixed(1);
				},
				goReviewTab() {
					const btn = document.querySelector('.tbtn:nth-child(2)');
					if (btn) {
						btn.click();
						setTimeout(function () {
							const tnav = document.querySelector('.tnav');
							if (tnav) {
								const targetTop = tnav.getBoundingClientRect().top + window.scrollY - 90;
								window.scrollTo({
									top: targetTop,
									behavior: 'smooth'
								});
							}
						}, 50);
					}
				},
				fnBuyNow() {
					if (this.productOptions.length > 0) {
						const optionGroupCount = Object.keys(this.groupedOptions).length;
						const selectedCount = Object.keys(this.selectedOptions).length;

						if (selectedCount < optionGroupCount) {
							showToast('옵션을 선택해주세요.');
							return;
						}
					}

					if (this.qty < 1) {
						showToast('수량을 선택해주세요.');
						return;
					}

					if (this.qty > this.totalQty) {
						showToast('재고가 부족합니다.');
						return;
					}

					const selectedOptionValues = Object.values(this.selectedOptions);
					const optionId = selectedOptionValues.map(opt => opt.optionValueId).join(',');
					const optionName = selectedOptionValues.map(opt => opt.optionValue).join(' / ');
					let optionItemId = '';

					if (optionId) {
						$.ajax({
							url: '/product/option/item/get.dox',
							type: 'POST',
							data: {
								productId: this.productId,
								optionValueIds: optionId
							},
							dataType: 'json',
							async: false,
							success(res) {
								if (res.result === 'success') {
									optionItemId = res.optionItemId;
								}
							}
						});

						if (!optionItemId) {
							showToast('옵션 조합 정보를 찾을 수 없습니다.');
							return;
						}
					}

					const buyNowItem = {
						cartId: Date.now(),
						cartType: this.productType,
						productId: parseInt(this.productId),
						productName: this.productInfo.productName || '',
						price: this.unitPrice,
						quantity: this.qty,
						imgUrl: this.mainImgUrl || '',
						brandName: this.productInfo.brandName || '',
						optionValueIds: optionId,
						optionItemId: optionItemId,
						optionName: optionName,
						rentalStart: this.productType === 'RENTAL' ? this.startDate : null,
						rentalEnd: this.productType === 'RENTAL' ? this.endDate : null,
						deposit: this.productInfo.deposit || 0
					};

					localStorage.setItem(BUY_NOW_KEY, JSON.stringify([buyNowItem]));

					//location.href = '/payment/checkout.do?cartType=' + this.productType + '&isGuest=true&buyNow=true';
					location.href = '/payment/checkout.do?cartType='
						+ this.productType
						+ '&isGuest=' + (!this.isLogin)
						+ '&buyNow=true';
				},
				fnRelatedWish(item) {
					let self = this;
					if (!this.isLogin) {
						this.openConfirm('찜하려면 로그인이 필요해요!🔥 \n 로그인하고 마음에 드는 상품을 저장해보세요!', function () {
							location.href = '/user/login.do';
						}, '로그인', '닫기');
						return;
					}
					$.ajax({
						url: '/user/wishlist/toggle.dox',
						type: 'POST',
						data: { productId: item.productId },
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								const relIdx = self.relatedList.findIndex(r => r.productId === item.productId);
								if (relIdx !== -1) {
									self.relatedList[relIdx].isWished = !self.relatedList[relIdx].isWished;
								}
								const aiIdx = self.aiRecommendList.findIndex(r => r.productId === item.productId);
								if (aiIdx !== -1) {
									self.aiRecommendList[aiIdx] = {
										...self.aiRecommendList[aiIdx],
										isWished: !self.aiRecommendList[aiIdx].isWished
									};
								}
								showToast(item.isWished ? '위시리스트에서 제거했어요.' : '❤️ 위시리스트에 추가했어요!');
							} else {
								self.openConfirm('찜하려면 로그인이 필요해요!🔥', function () {
									location.href = '/user/login.do';
								}, '로그인하기');
							}
						},
						error() {
							showToast('찜 처리 중 오류가 발생했습니다.');
						}
					});
				},
				fnReviewHelpful(review) {

					if (String(review.userId) === String(this.loginUserId)) {
						showToast('내 리뷰에는 추천할 수 없습니다.');
						return;
					}

					let self = this;

					$.ajax({
						url: '/review/helpful.dox',
						type: 'POST',
						data: {
							reviewId: review.reviewId
						},
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								if (res.helpfulYn === 'Y') {
									review.helpfulYn = 'Y';
									review.helpfulCount = Number(review.helpfulCount || 0) + 1;
									showToast('도움돼요를 눌렀어요.');
								} else {
									review.helpfulYn = 'N';
									review.helpfulCount = Math.max(Number(review.helpfulCount || 0) - 1, 0);
									showToast('도움돼요를 취소했어요.');
								}
								return;
							}

							if (res.result === 'login') {
								self.openConfirm('로그인이 필요합니다. 로그인하시겠습니까?', function () {
									location.href = '/user/login.do';
								}, '로그인하기');
								return;
							}

							showToast('처리에 실패했습니다.');
						},
						error() {
							showToast('도움돼요 처리 중 오류가 발생했습니다.');
						}
					});
				},
				toggleReviewMenu(reviewId) {
					this.openReviewMenuId = this.openReviewMenuId === reviewId ? null : reviewId;
				},

				confirmDeleteReview(reviewId) {
					this.openReviewMenuId = null;

					this.openConfirm('리뷰를 삭제하시겠습니까?', () => {
						$.ajax({
							url: '/user/review/remove.dox',
							type: 'POST',
							data: { reviewId: reviewId },
							dataType: 'json',
							success: (res) => {
								if (res.result === 'success') {
									showToast('리뷰가 삭제되었습니다.');
									this.fnGetReviews();
								} else {
									showToast(res.message || '리뷰 삭제에 실패했습니다.');
								}
							},
							error: () => {
								showToast('리뷰 삭제 중 오류가 발생했습니다.');
							}
						});
					}, '삭제', '취소');
				},
				changeReviewPage(page) {
					if (page < 1 || page > this.reviewTotalPage) {
						return;
					}

					this.reviewPage = page;
					this.fnGetReviews();
				},
				getRatingStars(rating) {
					const num = Number(rating || 0);

					if (!num || num <= 0) {
						return ['☆', '☆', '☆', '☆', '☆'];
					}

					const rounded = Math.round(num);

					return Array.from({ length: 5 }, function (_, i) {
						return i < rounded ? '★' : '☆';
					});
				}, getFeatureIcon(feature, idx) {
					const title = String(feature.title || '');

					if (title.includes('방수') || title.includes('방풍')) {
						return 'ri-drop-line';
					}

					if (title.includes('무게') || title.includes('경량')) {
						return 'ri-feather-line';
					}

					if (title.includes('설치') || title.includes('조립')) {
						return 'ri-tools-line';
					}

					if (title.includes('보온') || title.includes('온도')) {
						return 'ri-sun-line';
					}

					const icons = [
						'ri-shield-check-line',
						'ri-tools-line',
						'ri-leaf-line',
						'ri-checkbox-circle-line'
					];

					return icons[idx % icons.length];
				},
				getStarFill(rating, starIndex) {
					const value = Number(rating || 0);
					const diff = value - (starIndex - 1);

					if (diff >= 1) return 100;
					if (diff <= 0) return 0;

					return Math.round(diff * 100);
				},
				goReviewEdit(reviewId) {
					location.href = '/user/review/edit.do?reviewId=' + reviewId;
				}, handleScroll() {
					this.showTopBtn = window.scrollY > 300;
				},

				scrollToTop() {
					window.scrollTo({
						top: 0,
						behavior: 'smooth'
					});
				},
				handleConfirmEnter(e) {
					if (!this.confirmModal.open) {
						return;
					}

					if (e.key === 'Enter') {
						e.preventDefault();
						this.confirmOk();
					}
				},
				toggleFaq(idx) {
					const i = this.openFaqIndex.indexOf(idx);

					if (i > -1) {
						this.openFaqIndex.splice(i, 1);
					} else {
						this.openFaqIndex.push(idx);
					}
				},
				fetchReviewSummary() {
					if (this.reviewSummaryLoading || this.reviewSummary) {
						return;
					}

					this.reviewSummaryLoading = true;

					$.ajax({
						url: "/api/review/summary",
						type: "POST",
						contentType: "application/json",
						data: JSON.stringify({
							productId: this.productId
						}),
						success: (res) => {
							this.reviewSummary = res.summary;
						},
						error: () => {
							this.reviewSummary = "리뷰를 정리하는 중이에요 😊\n조금 더 많은 리뷰가 쌓이면 더 정확한 요약을 제공해드릴게요";
						},
						complete: () => {
							this.reviewSummaryLoading = false;
						}
					});
				},

				// qna 문의
				getCombinedOptions() {
					if (!this.productOptions || this.productOptions.length === 0) return [];
					let opts = [];
					for (let g in this.groupedOptions) {
						this.groupedOptions[g].forEach(o => {
							opts.push(g + " : " + o.optionValue);
						});
					}
					return opts;
				},

				fnGetQnaList() {
					let self = this;
					$.ajax({
						url: '/product/qna/list.dox',
						type: 'POST',
						data: {
							productId: self.productId,
							page: self.qnaPage,
							pageSize: self.qnaPageSize,
							keyword: self.qnaSearchKeyword
						},
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								self.qnaList = res.list;
								self.qnaTotalCount = res.totalCount;
							}
						}
					});
				},

				applyQnaFilter() {
					this.qnaSearchKeyword = this.qnaKeyword;
					this.qnaPage = 1;
					this.fnGetQnaList();
				},

				resetQnaFilter() {
					this.qnaKeyword = '';
					this.qnaSearchKeyword = '';
					this.qnaPage = 1;
					this.fnGetQnaList();
				},

				changeQnaPage(page) {
					this.qnaPage = page;
					this.fnGetQnaList();
				},

				openQnaModal(mode, qna = null) {
					if (!this.isLogin) {
						this.openConfirm('문의를 작성하려면 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?', () => {
							location.href = '/user/login.do';
						}, '이동하기');
						return;
					}

					this.qnaModal.mode = mode;
					this.qnaModal.selectedOptionsMap = {}; // 열 때마다 선택값 싹 비우기
					for (let groupName in this.groupedOptions) {
						this.qnaModal.selectedOptionsMap[groupName] = '';
					}

					if (mode === 'add') {
						this.qnaModal.qnaId = null;
						this.qnaModal.content = '';
						this.qnaModal.secretYn = 'N';
					} else if (mode === 'edit') {
						this.qnaModal.qnaId = qna.qnaId;
						this.qnaModal.content = qna.questionContent;
						this.qnaModal.secretYn = qna.secretYn;

						// "사이즈 : L / 컬러 : 레드" 로 저장된 문자열을 쪼개서 다시 드롭다운에 세팅
						if (qna.optionName) {
							let parts = qna.optionName.split(' / ');
							parts.forEach(p => {
								let kv = p.split(' : ');
								if (kv.length === 2) {
									this.qnaModal.selectedOptionsMap[kv[0].trim()] = kv[1].trim();
								}
							});
						} 
					}
					this.qnaModal.open = true;
				},

				closeQnaModal() {
					this.qnaModal.open = false;
				},

				submitQna() {
					if (!this.qnaModal.content.trim()) {
						showToast('문의 내용을 입력해 주세요.');
						return;
					}

					// 선택된 객체들을 "그룹명 : 값 / 그룹명 : 값" 형태의 하나의 텍스트로 합치기
					let optionStrArr = [];
					for (let key in this.qnaModal.selectedOptionsMap) {
						let val = this.qnaModal.selectedOptionsMap[key];
						if (val) {
							optionStrArr.push(key + " : " + val);
						}
					}

					let self = this;
					let url = this.qnaModal.mode === 'add' ? '/product/qna/add.dox' : '/product/qna/edit.dox';

					let param = {
						productId: this.productId,
						qnaId: this.qnaModal.qnaId,
						optionName: optionStrArr.join(' / '), // 합쳐진 텍스트를 DB로 전송
						questionContent: this.qnaModal.content,
						secretYn: this.qnaModal.secretYn
					};

					$.ajax({
						url: url,
						type: 'POST',
						data: param,
						dataType: 'json',
						success(res) {
							if (res.result === 'success') {
								showToast(self.qnaModal.mode === 'add' ? '문의가 등록되었습니다.' : '문의가 수정되었습니다.');
								self.closeQnaModal();
								self.qnaPage = 1;
								self.fnGetQnaList(); // 문의 리스트 새로고침
							} else if (res.result === 'login') {
								showToast('로그인이 필요합니다.');
							} else {
								showToast(res.message || '처리 중 오류가 발생했습니다.');
							}
						},
						error() { showToast('서버 통신 중 오류가 발생했습니다.'); }
					});
				},

				deleteQna(qnaId) {
					let self = this;
					this.openConfirm('이 문의를 삭제하시겠습니까?', () => {
						$.ajax({
							url: '/product/qna/delete.dox',
							type: 'POST',
							data: { qnaId: qnaId },
							dataType: 'json',
							success(res) {
								if (res.result === 'success') {
									showToast('문의가 삭제되었습니다.');
									self.fnGetQnaList(); // 리스트 새로고침
								} else {
									showToast(res.message || '삭제 중 오류가 발생했습니다.');
								}
							}
						});
					}, '삭제하기');
				},
				fetchAiRecommendations() {
					this.aiRecommendList = [];
					this.aiRecommendLoading = true;
					this.showAiModal = true;
					$.ajax({
						url: '/product/ai/recommend.dox',
						type: 'POST',
						data: { productId: this.productId },
						dataType: 'json',
						success: (res) => {
							if (res.result === 'success') {
								// 최대 4개로 제한
								const list = (res.list || []).slice(0, 4);
								this.aiRecommendList = list.map(item => ({   // ← res.list가 아니라 list로 수정

									...item,
									isWished: this.wishedIds.includes(item.productId)
								}));
							}
						},
						error: () => { this.showAiModal = false; },
						complete: () => { this.aiRecommendLoading = false; }
					});
				},

			},

			mounted() {
				window.addEventListener('keydown', this.handleConfirmEnter);
				window.__vueApp = this;

				this.checkLogin();
				this.fnDetail();
				this.fetchBestCoupon(); // ← 추가
				this.fetchProductImages();
				this.fnGetReviews();

				this.$nextTick(() => {
					const active = document.querySelector('.tbtn.on');
					if (active) {
						this.moveUnderline(active);
					}

					forceProductDetailTop();
				});

				setTimeout(forceProductDetailTop, 300);
				setTimeout(forceProductDetailTop, 700);

				window.addEventListener('scroll', this.handleScroll, { passive: true });
				this.handleScroll();

				this.fnGetQnaList();
				
			},
			beforeUnmount() {
				window.removeEventListener('scroll', this.handleScroll);
				window.removeEventListener('keydown', this.handleConfirmEnter);
			},
		});

		app.mount('#app');
	</script>