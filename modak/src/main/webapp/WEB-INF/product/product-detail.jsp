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
										:class="{ on: mainImgUrl === img.imgUrl }" @click.stop="setMainImg(img.imgUrl)">
										<img :src="img.imgUrl">
									</div>
								</div>
							</div>
						</div>

						<!-- INFO -->
						<div class="pinfo">
							<div class="product-head">
								<div class="product-brand-badge">{{ productInfo.brandName }}</div>

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
									:disabled="productType === 'RENTAL'">🛒 구매하기</button>
								<button class="mbtn" id="mb-rent" onclick="setMode('rent')"
									:disabled="productType === 'PURCHASE'">📅 대여하기</button>
							</div>

							<!-- BUY PRICE -->
							<div class="buy-only">
								<div class="pbox-buy">
									<div class="prow"><span class="pnow">{{ formatPrice(productInfo.price) }}</span>
									</div>
									<div class="porig">23,150,000원</div>
									<div class="pnote">쿠폰 적용시 최대 10% 할인</div>
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

							<hr class="div">

							<!-- 옵션 선택 -->
							<div v-if="productOptions.length > 0" class="option-section">
								<div class="section-label">옵션 선택</div>

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

							<!-- BUY OPTIONS -->
							<div class="buy-only">

								<div class="qty-section">
									<div class="section-label">수량 선택</div>

									<div class="qty-box">
										<button type="button" class="qty-btn" @click="chgQty(-1)">−</button>
										<div class="qty-num">{{ qty }}</div>
										<button type="button" class="qty-btn" @click="chgQty(1)">+</button>

										<span v-if="remainQty > 0" class="stock-text">{{ remainQty }}개 남음</span>
										<span v-else-if="remainQty === 0 && qty > 0" class="stock-text warn">잔여 재고
											없음</span>
										<span v-else class="stock-text soldout">품절</span>
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
								<button @click="calOpen = true" style="width:100%;display:flex;justify-content:space-between;align-items:center;
                               padding:12px 16px;background:#f9f9f9;border:1px solid #eee;
                               border-radius:8px;cursor:pointer;font-size:14px;font-weight:600;
                               font-family:inherit;margin-bottom:8px;">
									<span>📅 날짜 선택
										<span v-if="startDate && endDate"
											style="color:var(--orange);margin-left:8px;font-size:13px;">{{ startDate }}
											~ {{ endDate }} ({{ rentDays }}박)</span>
										<span v-else-if="startDate"
											style="color:var(--orange);margin-left:8px;font-size:13px;">{{ startDate }}
											선택됨</span>
										<span v-else style="color:var(--muted);margin-left:8px;font-size:13px;">날짜를
											선택해주세요</span>
									</span>
									<span style="color:var(--orange);">▼</span>
								</button>

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
											<div v-for="(day, idx) in calendarDays" :key="idx" :class="getDayClass(day)"
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
											<span style="color:var(--muted)">대여료 ({{ rentDays }}박)</span>
											<span>{{ formatPrice(unitPrice * rentDays) }}</span>
										</div>
										<div
											style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:8px;">
											<span style="color:var(--muted)">보증금 <span style="font-size:11px;">(반납 후
													환불)</span></span>
											<span>{{ formatPrice(productInfo.deposit) }}</span>
										</div>
										<hr style="border:none;border-top:1px solid #eee;margin:8px 0;">
										<div style="display:flex;justify-content:space-between;align-items:center;">
											<span style="font-size:14px;color:var(--muted)">결제 예정금액</span>
											<span style="font-size:1.8rem;font-weight:bold;color:var(--orange);">{{
												formatPrice(unitPrice * rentDays + productInfo.deposit) }}</span>
										</div>
									</div>
									<div v-else style="color:#bbb;">캘린더에서 예약 날짜를 선택해주세요.</div>
								</div>

								<div class="arow" style="margin-top:12px;">
									<button class="bwish" id="wb2" :class="{ on: isWished }" @click="fnWish($event)">{{
										isWished ? '❤️' : '🤍' }}</button>
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
						</div>
					</div>

					<!-- TABS -->
					<div>
						<div class="tnav">
							<button class="tbtn on" @click="stab('det', $event)">상품 정보</button>
							<button class="tbtn" @click="stab('rev', $event)">리뷰 ({{ reviewTotalCount }})</button>
							<button class="tbtn" @click="stab('qna', $event)">Q&A</button>
							<button class="tbtn" @click="stab('shp', $event)">배송/대여 안내</button>

							<div class="t-underline"></div>

						</div>
						<div class="tcont">
							<div class="tpane on" id="tp-det">
								<div class="detail-image-wrap" v-if="detailImgUrl">
									<img :src="detailImgUrl" alt="상품 상세 이미지" class="detail-image">
								</div>

								<hr class="div" style="margin:24px 0">

								<h3 style="font-size:15px;font-weight:700;margin:18px 0 12px">제품 특징</h3>
								<div class="flist">
									<div class="fi" v-for="f in productFeatures" :key="f.featureId">
										<div class="fic">{{ f.icon }}</div>
										<div class="fit">
											<h4>{{ f.title }}</h4>
											<p>{{ f.content }}</p>
										</div>
									</div>
								</div>

								<hr class="div" style="margin:18px 0">

								<h3 style="font-size:15px;font-weight:700;margin-bottom:12px">상품 스펙</h3>
								<table class="spec">
									<tr v-if="productSpec.capacity">
										<th>수용 인원</th>
										<td>{{ productSpec.capacity }}</td>
									</tr>
									<tr v-if="productSpec.size">
										<th>전개 사이즈</th>
										<td>{{ productSpec.size }}</td>
									</tr>
									<tr v-if="productSpec.weight">
										<th>총 중량</th>
										<td>{{ productSpec.weight }}</td>
									</tr>
									<tr v-if="productSpec.material">
										<th>소재 (외피)</th>
										<td>{{ productSpec.material }}</td>
									</tr>
									<tr v-if="productSpec.origin">
										<th>원산지</th>
										<td>{{ productSpec.origin }}</td>
									</tr>

									<tr v-if="!productSpec.capacity && !productSpec.size">
										<td colspan="2" style="text-align:center;color:var(--muted);padding:20px">
											등록된 스펙 정보가 없습니다.
										</td>
									</tr>
								</table>

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
								<div v-if="reviewList.length === 0"
									style="text-align:center;padding:36px 0;color:var(--muted);font-size:14px">아직 작성된
									리뷰가 없습니다.</div>
								<div class="rcard" v-for="review in reviewList" :key="review.reviewId">
									<div class="rhead">
										<div class="review-user">
											<img class="review-profile"
												:src="review.profileImgUrl || '/img/profile/default-profile.png'">
											<div>
												<div class="rname">
													{{ review.nickname || review.userId }}
													<span v-if="review.gradeId >= 4" class="grade-badge vip">VIP</span>
													<span v-else-if="review.gradeId == 3"
														class="grade-badge gold">GOLD</span>
													<span v-else-if="review.gradeId == 2"
														class="grade-badge silver">SILVER</span>
												</div>
												<div class="stars" style="display:flex;gap:1px;margin-top:3px">
													<span v-for="(star, i) in getStars(review.rating)" :key="i"
														class="st"
														:style="{ fontSize:'12px', color: star === '★' ? '' : '#ddd' }">{{
														star }}</span>
													<span style="font-size:12px;color:#999;margin-left:6px;">{{
														formatRatingInt(review.rating) }}점</span>
												</div>
											</div>
										</div>
										<div class="review-menu-wrap">
											<button type="button" class="review-more-btn"
												@click.stop="toggleReviewMenu(review.reviewId)">
												<i class="ri-more-2-fill"></i>
											</button>

											<div class="review-dropdown" v-if="openReviewMenuId === review.reviewId">
												<button
													v-if="loginUserId && String(review.userId) === String(loginUserId)"
													type="button" @click="goReviewEdit(review.reviewId)">
													수정
												</button>

												<button
													v-if="loginUserId && String(review.userId) === String(loginUserId)"
													type="button" class="danger"
													@click="confirmDeleteReview(review.reviewId)">
													삭제
												</button>

												<button
													v-if="!loginUserId || String(review.userId) !== String(loginUserId)"
													type="button" class="danger" @click="reportReview(review.reviewId)">
													신고
												</button>
											</div>
										</div>
									</div>
									<div class="rtext" style="font-weight:600;margin-bottom:4px">{{ review.title }}
									</div>
									<div class="rtext">{{ review.content }}</div>
									<!-- 변경 코드 (최대 5장 표시) -->
									<div v-if="review.imageList && review.imageList.length > 0" class="review-img-list">
										<img v-for="(img, idx) in review.imageList" :key="idx" :src="img.imgUrl"
											class="review-img-thumb" @click="openImg(img.imgUrl)"
											@error="$event.target.style.display='none'">
									</div>
									<div class="rhelprow">
										<span>도움이 됐나요?</span>
										<button class="hbtn" :class="{ 
                                                on: review.helpfulYn === 'Y',
                                                disabled: String(review.userId) === String(loginUserId)
                                            }" :disabled="String(review.userId) === String(loginUserId)"
											@click="fnReviewHelpful(review)">
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

									<button type="button" class="review-page-btn"
										:disabled="reviewPage === reviewTotalPage"
										@click="changeReviewPage(reviewPage + 1)">
										다음
									</button>
								</div>
							</div>

							<div class="tpane" id="tp-qna">
								<div class="qna-list" v-if="faqList.length > 0">
									<div class="qna-item" v-for="(f, idx) in faqList" :key="f.faqId || idx">
										<button type="button" class="qna-question" @click="toggleFaq(idx)">

											<span><b>Q.</b> {{ f.question }}</span>
											<i
												:class="openFaqIndex.includes(idx) ? 'ri-subtract-line' : 'ri-add-line'"></i>
										</button>

										<transition name="qna-slide">
											<div v-show="openFaqIndex.includes(idx)" class="qna-answer"> <span>A.</span>
												<p>{{ f.answer }}</p>
											</div>
										</transition>
									</div>
								</div>

								<div v-else class="empty-qna">등록된 FAQ가 없습니다.</div>

								<div class="qna-inquiry-box">
									<p>원하는 답변을 찾지 못하셨나요?<br>평균 24시간 내 답변드립니다.</p>
									<button type="button" class="btn-inquiry" @click="fnInquiry">1:1 문의하기</button>
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
					</div>

					<!-- RELATED -->
					<div class="rel" v-if="relatedList.length > 0">
						<h2 class="sectl">같은 카테고리 상품</h2>
						<div class="rgrid">
							<div class="pcard" v-for="item in relatedList" :key="item.productId"
								@click="goDetail(item.productId)">
								<div class="pcimg">
									<img v-if="item.imgUrl" :src="item.imgUrl"
										style="width:100%;height:100%;object-fit:cover;">
									<span v-else style="font-size:48px;">🏕️</span>

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
									<div class="pcacts">
										<button class="pca-rent" v-if="item.productType === 'RENTAL'"
											@click.stop="goDetail(item.productId, 'rent')">
											대여하기
										</button>

										<button class="pca-buy" v-if="item.productType === 'PURCHASE'"
											@click.stop="goDetail(item.productId, 'buy')">
											구매하기
										</button>
									</div>
								</div>
							</div>
						</div>

						<!-- 리뷰 이미지 모달 -->
						<div v-if="reviewImgModal.open" class="img-modal-overlay"
							@click.self="reviewImgModal.open = false">
							<div class="img-modal-box">
								<button class="img-modal-close" @click="reviewImgModal.open = false">✕</button>
								<img :src="reviewImgModal.url" class="img-modal-photo">
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
									신고 사유를 입력해 주세요.
								</div>

								<textarea class="report-textarea" v-model="reportModal.content" maxlength="500"
									placeholder="예: 욕설, 허위 정보, 광고성 리뷰 등"></textarea>

								<div class="report-count">
									{{ reportModal.content.length }}/500
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
					</div>
				</div>
				<!-- TOP 버튼 -->
				<button v-show="showTopBtn" class="scroll-top-btn" @click="scrollToTop">
					<i class="ri-arrow-up-line"></i>
				</button>
			</div><!-- /#app -->
			<script>
				const BUY_NOW_KEY = 'modak_guest_buy_now';
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
							selectedOptions: {},
							cartMode: 'RENT',
							isLogin: false,          // ← 추가: 로그인 여부
							confirmModal: { open: false, message: '', okText: '확인', cancelText: '취소', onOk: null },
							reviewImgModal: { open: false, url: '' },
							reportModal: {
								open: false,
								reviewId: null,
								content: ''
							},
							loginUserId: loginUserId,
							showTopBtn: false,
							reviewPage: 1,
							reviewPageSize: 10,
							reviewTotalCount: 0,
							openReviewMenuId: null,
							reviewSummary: "",
							reviewSummaryLoading: false
						};
					},

					computed: {
						reviewTotalPage() {
							return Math.ceil(this.reviewTotalCount / this.reviewPageSize);
						},
						rewardPoint() {
							return Math.round(Number(this.totalPrice || 0) * 0.01);
						},

						rewardPointPerNight() {
							return Math.round(Number(this.unitPrice || 0) * 0.01);
						},
						detailImgUrl() {
							const desc = this.productInfo.description;

							console.log('description:', desc);

							if (!desc) {
								return '';
							}

							return desc;
						},


						displayQty() {
							return this.productType === 'PURCHASE' ? this.totalQty : this.availableQty;
						},
						remainQty() { return this.displayQty - this.qty; },
						calendarDays() {
							const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
							const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
							const days = [];
							for (let i = 0; i < firstDay; i++) days.push(null);
							for (let d = 1; d <= lastDate; d++) {
								const dateObj = new Date(this.currentYear, this.currentMonth, d);
								const fullStr = this.formatDateCal(dateObj);
								days.push({ date: d, full: fullStr, isRented: this.checkIsRented(fullStr), isPast: dateObj < new Date().setHours(0, 0, 0, 0) });
							}
							return days;
						},
						rentDays() {
							if (!this.startDate || !this.endDate) return 0;
							return Math.ceil((new Date(this.endDate) - new Date(this.startDate)) / (1000 * 60 * 60 * 24));
						},
						avgRating() {
							if (!this.reviewList.length) return 0;

							const sum = this.reviewList.reduce((acc, r) => {
								return acc + Number(r.rating || 0);
							}, 0);

							return sum / this.reviewList.length;
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
							this.reviewList.forEach(r => { const s = Math.round(r.rating); if (dist[s] !== undefined) dist[s]++; });
							const total = this.reviewList.length || 1;
							return [5, 4, 3, 2, 1].map(score => ({ score, count: dist[score], pct: Math.round((dist[score] / total) * 100) }));
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
					},

					methods: {
						/* ── 로그인 체크 ── */
						checkLogin() {
							let self = this;
							$.ajax({
								url: '/user/session-check.dox', type: 'POST', dataType: 'json',
								success(res) { self.isLogin = res.isLogin === true; },
								error() { self.isLogin = false; }
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

									// 위시 상태
									$.ajax({
										url: '/user/wishlist/list.dox', type: 'POST', dataType: 'json',
										success(wRes) {
											if (wRes.result === 'success' && wRes.list) {
												const wishedIds = wRes.list.map(w => w.productId);
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
									loginUserId: self.loginUserId
								},
								dataType: 'json',
								success(data) {
									self.reviewList = data.list || [];
									self.reviewTotalCount = data.totalCount || 0;

								},
								error() {
									self.reviewList = [];
								}
							});
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
										}
									}
								});

								if (!optionItemId) {
									showToast('옵션 조합 정보를 찾을 수 없습니다.');
									return;
								}
							}
							console.log("선택 옵션:", selectedOptionValues);
							console.log("optionValueIds:", optionId);

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
											location.href = '/cart/list.do';
										}, '이동하기');
									} else if (res.result === 'success') {
										self.openConfirm('장바구니에 담았습니다. 장바구니로 이동할까요?', function () {
											location.href = '/cart/list.do';
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
						openImg(url) { this.reviewImgModal.open = true; this.reviewImgModal.url = url; },
						formatPrice(price) { if (!price) return '0원'; return Number(price).toLocaleString('ko-KR') + '원'; },
						chgQty(d) {
							const max = this.displayQty;
							const next = this.qty + d;
							if (next < 1) return;
							if (next > max) { showToast('재고가 부족합니다. (최대 ' + max + '개)'); return; }
							this.qty = next;
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
								this.startDate = day.full; this.endDate = null;
							} else {
								if (day.full < this.startDate) this.startDate = day.full;
								else if (day.full === this.startDate) this.startDate = null;
								else this.endDate = day.full;
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
							const selected = this.selectedOptions[optionName];

							if (selected && selected.optionValueId === opt.optionValueId) {
								const copy = { ...this.selectedOptions };
								delete copy[optionName];
								this.selectedOptions = copy;
								return;
							}

							this.selectedOptions = {
								...this.selectedOptions,
								[optionName]: opt
							};
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
							this.reportModal.content = '';
							this.reportModal.open = true;

							this.$nextTick(() => {
								const textarea = document.querySelector('.report-textarea');
								if (textarea) textarea.focus();
							});
						},

						closeReportModal() {
							this.reportModal.open = false;
							this.reportModal.reviewId = null;
							this.reportModal.content = '';
						},

						submitReport() {
							let self = this;
							const content = self.reportModal.content.trim();

							if (!content) {
								showToast('신고 사유를 입력해주세요.');
								return;
							}

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

						openImg(url) {
							if (!url) return;
							this.reviewImgModal.url = url;
							this.reviewImgModal.open = true;
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
									document.getElementById('tp-rev')?.scrollIntoView({
										behavior: 'smooth',
										block: 'start'
									});
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
										item.isWished = !item.isWished;
										showToast(item.isWished ? '❤️ 위시리스트에 추가했어요!' : '위시리스트에서 제거했어요.');
									} else {
										self.openConfirm('찜하려면 로그인이 필요해요!🔥 \n 로그인하고 마음에 드는 상품을 저장해보세요!', function () {
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
							this.$nextTick(() => {
								document.getElementById('tp-rev')?.scrollIntoView({
									behavior: 'smooth',
									block: 'start'
								});
							});
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
						}

					},

					mounted() {
						window.addEventListener('keydown', this.handleConfirmEnter);
						window.scrollTo(0, 0);
						window.__vueApp = this;
						this.checkLogin();      // ← 로그인 체크 먼저
						this.fnDetail();
						this.fetchProductImages();
						this.fnGetReviews();
						this.$nextTick(() => {
							const active = document.querySelector('.tbtn.on');
							if (active) this.moveUnderline(active);
						});
						window.addEventListener('scroll', this.handleScroll);

					},
					beforeUnmount() {
						window.removeEventListener('scroll', this.handleScroll);
						window.removeEventListener('keydown', this.handleConfirmEnter);
					},
				});

				app.mount('#app');
			</script>
			<%@ include file="/WEB-INF/common/footer.jsp" %>
	</body>

	</html>