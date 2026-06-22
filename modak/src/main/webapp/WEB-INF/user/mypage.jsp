<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
			<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
				<!DOCTYPE html>
				<html lang="ko">

				<head>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<title>마이페이지 - 모닥모닥</title>
					<script src="https://code.jquery.com/jquery-3.7.1.js"
						integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
						crossorigin="anonymous"></script>
					<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
					<script src="/js/page-change.js"></script>
					<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<link rel="stylesheet" href="/css/user/mypage.css">
					<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
					<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
				</head>

				<body>
					<%@ include file="/WEB-INF/common/header.jsp" %>
						<div id="app" v-cloak>
							<!-- PAGE -->
							<div class="page-wrap">

								<!-- SIDEBAR -->
								<aside class="sidebar">
									<div class="profile-card profile-card-new">

										<div class="profile-top-label">
											MY CAMPING PROFILE
										</div>

										<div class="avatar-wrap profile-avatar-wrap">
											<div class="avatar-ring profile-avatar-new" @click="fnTriggerProfileFile">
												<img :src="profileImageSrc" alt="프로필 이미지" class="profile-avatar-img">

												<div class="profile-overlay">
													<div class="overlay-content">
														<span class="overlay-icon" aria-hidden="true"><svg width="18"
																height="18" viewBox="0 0 24 24" fill="none">
																<path
																	d="M4 8.5A2.5 2.5 0 0 1 6.5 6H8l1.4-1.8A2 2 0 0 1 11 3.5h2a2 2 0 0 1 1.6.7L16 6h1.5A2.5 2.5 0 0 1 20 8.5v8A2.5 2.5 0 0 1 17.5 19h-11A2.5 2.5 0 0 1 4 16.5v-8Z"
																	stroke="currentColor" stroke-width="1.6"
																	stroke-linejoin="round" />
																<circle cx="12" cy="12.5" r="3" stroke="currentColor"
																	stroke-width="1.6" />
															</svg></span>
														<span>사진 변경</span>
													</div>
												</div>
											</div>

											<input type="file" ref="profileFileInput" accept="image/*"
												style="display:none;" @change="fnProfileImageChange">
										</div>

										<div class="profile-user-block">
											<div class="profile-name">
												{{ displayUser.userName }}
											</div>

											<div class="profile-nick">
												@{{ displayUser.nickName }}
											</div>
										</div>

										<div class="level-badge 
                                            grade-${empty user.gradeName ? 'default' : fn:toLowerCase(user.gradeName)}"
											@click="fnGoMembershipInfo">
											<svg width="12" height="12" viewBox="0 0 12 12" fill="none">
												<path
													d="M6 1L7.5 4.5H11L8.5 7L9.5 10.5L6 8.5L2.5 10.5L3.5 7L1 4.5H4.5Z" />
											</svg>
											${empty user.gradeName ? '일반 회원' : user.gradeName}
										</div>

										<div class="profile-action-row">
											<button type="button" class="profile-action-btn change"
												@click="fnTriggerProfileFile">
												사진 변경
											</button>
											<button type="button" class="profile-action-btn delete"
												@click="fnDeleteProfile">
												삭제
											</button>
										</div>

									</div>

									<div class="nav-card">
										<div class="nav-section-title">쇼핑</div>

										<div class="nav-item active" onclick="switchTab('orders', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<rect x="2" y="4" width="11" height="9" rx="2" stroke="#c94f1e"
													stroke-width="1.3" />
												<path d="M5 4V3a2.5 2.5 0 0 1 5 0v1" stroke="#c94f1e" stroke-width="1.3"
													stroke-linecap="round" />
											</svg>
											주문내역
										</div>

										<div class="nav-item" onclick="switchTab('address', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<path d="M7.5 13S3 9.3 3 6.5A4.5 4.5 0 0 1 12 6.5C12 9.3 7.5 13 7.5 13Z"
													stroke="#7a5c3e" stroke-width="1.3" />
												<circle cx="7.5" cy="6.5" r="1.6" stroke="#7a5c3e" stroke-width="1.2" />
											</svg>
											배송지 목록
										</div>

										<div class="nav-item" onclick="switchTab('wishlist', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<path
													d="M7.5 12.5S1.5 8.5 1.5 5A3 3 0 0 1 7.5 4 3 3 0 0 1 13.5 5c0 3.5-6 7.5-6 7.5Z"
													stroke="#7a5c3e" stroke-width="1.3" />
											</svg>
											찜한 상품
										</div>

										<div class="nav-item" onclick="switchTab('recent', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<circle cx="7.5" cy="7.5" r="5.5" stroke="#7a5c3e" stroke-width="1.3" />
												<path d="M7.5 4.5V7.5l2 2" stroke="#7a5c3e" stroke-width="1.3"
													stroke-linecap="round" />
											</svg>
											최근 본 상품
										</div>

										<div class="nav-divider"></div>

										<div class="nav-section-title">혜택</div>
										<div class="nav-item" onclick="switchTab('benefits', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<circle cx="7.5" cy="7.5" r="5.5" stroke="#7a5c3e" stroke-width="1.3" />
												<path d="M5.5 8.5A2.5 2.5 0 0 0 10 7.5M10 6.5A2.5 2.5 0 0 0 5.5 7.5"
													stroke="#7a5c3e" stroke-width="1.2" stroke-linecap="round" />
											</svg>
											포인트 · 쿠폰
										</div>

										<div class="nav-divider"></div>

										<div class="nav-section-title">활동</div>

										<div class="nav-item" onclick="switchTab('reviews', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<path d="M2 2.5h11v7.5H8.5L6 12.5V10H2Z" stroke="#7a5c3e"
													stroke-width="1.3" stroke-linejoin="round" />
											</svg>
											내 리뷰
										</div>
										<div class="nav-item" onclick="switchTab('bookmarks', this)">
											<i class="ri-bookmark-line nav-ri-icon"></i>
											스크랩한 글
										</div>
										<div class="nav-item" onclick="switchTab('chatRooms', this)">
											<i class="ri-chat-1-line nav-ri-icon"></i>
											채팅방 목록
										</div>
										<div class="nav-item" onclick="switchTab('chatbot', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<rect x="2" y="3" width="11" height="8" rx="2" stroke="#7a5c3e"
													stroke-width="1.2" />
												<path d="M5 6.5h5M5 8.5h3" stroke="#7a5c3e" stroke-width="1.2"
													stroke-linecap="round" />
												<path d="M6 11v2l2-2" stroke="#7a5c3e" stroke-width="1.2"
													stroke-linejoin="round" />
											</svg>
											챗봇 기록
										</div>
										<div class="nav-item" onclick="switchTab('inquiries', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<path d="M2.5 3.5h10v8h-10z" stroke="#7a5c3e" stroke-width="1.2" />
												<path d="M4.5 6h6M4.5 8h4" stroke="#7a5c3e" stroke-width="1.2"
													stroke-linecap="round" />
											</svg>
											내 문의 목록
										</div>

										<div class="nav-divider"></div>

										<div class="nav-section-title">계정</div>
										<div class="nav-item" onclick="switchTab('settings', this)">
											<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
												<circle cx="7.5" cy="7.5" r="2" stroke="#7a5c3e" stroke-width="1.3" />
												<path
													d="M7.5 1v1.5M7.5 12.5V14M14 7.5h-1.5M2.5 7.5H1M12 3L11 4M4 11L3 12M12 12l-1-1M4 4L3 3"
													stroke="#7a5c3e" stroke-width="1.3" stroke-linecap="round" />
											</svg>
											계정 설정
										</div>
									</div>
								</aside>

								<!-- MAIN -->
								<main class="main">

									<!-- 요약 카드 (항상 표시) -->
									<div class="stats-grid">
										<div class="stat-card"
											onclick="switchTab('orders', document.querySelector('.nav-item'))">
											<div class="stat-label">총 주문</div>
											<div class="stat-value">${summary.orderCount}<span>건</span></div>
										</div>

										<div class="stat-card accent" onclick="switchTab('benefits', null)">
											<div class="stat-label">보유 포인트</div>
											<div class="stat-value">
												<fmt:formatNumber value="${summary.pointAmount}" pattern="#,###" />
												<span>P</span>
											</div>
										</div>

										<div class="stat-card" onclick="switchTab('benefits', null)">
											<div class="stat-label">사용 가능 쿠폰</div>
											<div class="stat-value">${summary.couponCount}<span>장</span></div>
										</div>

										<div class="stat-card" onclick="switchTab('wishlist', null)">
											<div class="stat-label">찜한 상품</div>
											<div class="stat-value">${summary.wishlistCount}<span>개</span></div>
										</div>
									</div>

									<!-- ── 주문내역 탭 ── -->
									<div class="tab-panel active" id="tab-orders">
										<div class="section-card">
											<div class="section-head">
												<h3>주문 현황</h3>
											</div>
											<div class="order-flow">
												<div class="flow-step"
													:class="{ 'has-count': statusSummary.paid > 0, 'is-selected': selectedOrderStatus === 'PAID' }"
													@click="fnFilterByStatus('PAID')">
													<div class="flow-circle">
														<svg width="20" height="20" viewBox="0 0 20 20" fill="none">
															<rect x="4" y="3" width="12" height="14" rx="2"
																stroke="#c94f1e" stroke-width="1.5" />
															<path d="M7 7h6M7 10h4" stroke="#c94f1e" stroke-width="1.3"
																stroke-linecap="round" />
														</svg>
													</div>
													<div class="flow-count">{{ statusSummary.paid }}</div>
													<div class="flow-name">결제완료</div>
												</div>

												<div class="flow-arrow">›</div>

												<div class="flow-step"
													:class="{ 'has-count': statusSummary.ready > 0, 'is-selected': selectedOrderStatus === 'READY' }"
													@click="fnFilterByStatus('READY')">
													<div class="flow-circle">
														<svg width="20" height="20" viewBox="0 0 20 20" fill="none">
															<rect x="3" y="5" width="14" height="10" rx="2"
																stroke="#b09070" stroke-width="1.4" />
															<path d="M3 9h14" stroke="#b09070" stroke-width="1.3" />
														</svg>
													</div>
													<div class="flow-count">{{ statusSummary.ready }}</div>
													<div class="flow-name">배송준비</div>
												</div>

												<div class="flow-arrow">›</div>

												<div class="flow-step"
													:class="{ 'has-count': statusSummary.shipping > 0, 'is-selected': selectedOrderStatus === 'SHIPPING' }"
													@click="fnFilterByStatus('SHIPPING')">
													<div class="flow-circle">
														<svg width="20" height="20" viewBox="0 0 20 20" fill="none">
															<path d="M2 11l4-6h8l4 4v4H2v-2Z" stroke="#c94f1e"
																stroke-width="1.4" stroke-linejoin="round" />
															<circle cx="6" cy="15" r="1.5" stroke="#c94f1e"
																stroke-width="1.3" />
															<circle cx="14" cy="15" r="1.5" stroke="#c94f1e"
																stroke-width="1.3" />
														</svg>
													</div>
													<div class="flow-count">{{ statusSummary.shipping }}</div>
													<div class="flow-name">배송중</div>
												</div>

												<div class="flow-arrow">›</div>

												<div class="flow-step"
													:class="{ 'has-count': statusSummary.done > 0, 'is-selected': selectedOrderStatus === 'DONE' }"
													@click="fnFilterByStatus('DONE')">
													<div class="flow-circle">
														<svg width="20" height="20" viewBox="0 0 20 20" fill="none">
															<path d="M5 10l3.5 3.5L15 7" stroke="#b09070"
																stroke-width="1.6" stroke-linecap="round"
																stroke-linejoin="round" />
														</svg>
													</div>
													<div class="flow-count">{{ statusSummary.done }}</div>
													<div class="flow-name">배송/반납 완료</div>
												</div>
												<div class="flow-arrow">›</div>

												<div class="flow-step"
													:class="{ 'has-count': statusSummary.cancelled > 0, 'is-selected': selectedOrderStatus === 'CANCELLED' }"
													@click="fnFilterByStatus('CANCELLED')">
													<div class="flow-circle">
														<svg width="20" height="20" viewBox="0 0 20 20" fill="none">
															<path d="M7 7l6 6M13 7l-6 6" stroke="#b09070"
																stroke-width="1.4" stroke-linecap="round" />
														</svg>
													</div>
													<div class="flow-count">{{ statusSummary.cancelled }}</div>
													<div class="flow-name">취소/반품</div>
												</div>
											</div>
										</div>

										<div class="section-card">
											<div class="section-head">
												<h3>최근 주문내역</h3>
												<div class="order-head-actions">
													<a href="/order/history.do">전체보기 →</a>
												</div>
											</div>
											<div class="order-list">
												<div v-if="filteredOrderList.length === 0" class="empty-state">
													<p>해당 상태의 주문내역이 없습니다.</p>
												</div>

												<div v-for="item in limitedOrderList" :key="item.orderId"
													class="order-item order-item-clickable"
													@click="fnGoOrderDetail(item.orderId)">
													<div class="order-thumb">
														<img v-if="item.itemList && item.itemList.length > 0 && item.itemList[0].imgUrl"
															:src="item.itemList[0].imgUrl"
															:alt="item.itemList[0].productName" class="order-thumb-img">
														<span v-else-if="item.orderType === 'PURCHASE'">🛒</span>
														<span v-else-if="item.orderType === 'RENTAL'">⛺</span>
														<span v-else>📦</span>
													</div>

													<div class="order-info">
														<div class="order-name">
															{{ item.itemList && item.itemList.length > 0 ?
															item.itemList[0].productName : '상품명 없음' }}
															{{ item.itemList && item.itemList.length > 1 ? ' 외 ' +
															(item.itemList.length - 1) + '건' : '' }}
														</div>

														<div class="order-meta">
															<span class="order-number">주문번호 {{ item.orderId }}</span>
															<span class="dot">·</span>
															<span class="order-date">{{ item.createdAt }}</span>
															<span class="dot">·</span>
															<span class="order-type-badge"
																:class="item.orderType === 'PURCHASE' ? 'purchase' : 'rental'">
																{{ item.orderType === 'PURCHASE' ? '구매' : '대여' }}
															</span>
														</div>
													</div>

													<div class="order-side">
														<div class="order-status" :class="'status-' + item.orderStatus">
															{{ fnGetStatusText(item.orderStatus) }}
														</div>

														<div class="order-price">
															{{ Number(item.totalPrice || 0).toLocaleString() }}원
														</div>

														<div class="order-action-wrap"
															v-if="fnGetOrderActions(item).length > 0">
															<button type="button" class="btn-order-action"
																:class="fnGetActionClass(action)"
																v-for="action in fnGetOrderActions(item)" :key="action"
																@click.stop="fnHandleOrderAction(item, action)">
																{{ action }}
															</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<!-- ── 찜한 상품 탭 ── -->
									<div class="tab-panel" id="tab-wishlist">
										<div class="section-card">
											<div class="section-head">
												<h3>찜한 상품</h3><a href="javascript:;" @click="fnGoWishlistHistory">전체보기
													→</a>
											</div>
											<div class="wish-grid">
												<div v-if="wishlist.length === 0" class="empty-state">
													<p>찜한 상품이 없습니다.</p>
												</div>

												<div class="wish-item" v-for="item in limitedWishlist"
													:key="item.productId" @click="fnGoProductDetail(item.productId)">

													<div class="wish-thumb">
														<img v-if="item.imgUrl" :src="item.imgUrl"
															style="width:100%; height:100%; object-fit:cover;">
														<span v-else>🛒</span>
													</div>

													<button type="button" class="wish-remove-icon on" title="찜 해제"
														@click.stop="fnRemoveWishlist(item.wishId)">
														<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
															stroke-width="2">
															<path
																d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
														</svg>
													</button>

													<div class="wish-body">
														<div class="wish-name-wrap">
															<span class="wish-name">
																{{ item.productName }}
																<span v-if="item.brandName" class="wish-brand-inline">
																	· {{ item.brandName }}
																</span>
															</span>
														</div>

														<div v-if="item.categoryName" class="wish-category-pill">
															{{ item.categoryName }}
														</div>

														<div class="wish-rating-row">
															<span class="wish-stars-fill"
																:style="{ '--rating-width': fnRatingWidth(item.avgRating) }">
																<span class="star-base">★★★★★</span>
																<span class="star-fill">★★★★★</span>
															</span>

															<span class="wish-rating-text">
																{{ Number(item.avgRating || 0).toFixed(1) }}
																({{ item.reviewCount || 0 }})
															</span>
														</div>
														<div class="wish-price">
															{{ Number(item.price || 0).toLocaleString() }}원
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<!-- ── 최근 본 상품 탭 ── -->
									<div class="tab-panel" id="tab-recent">
										<div class="section-card">
											<div class="section-head">
												<h3>최근 본 상품</h3>
												<a href="javascript:;" @click="fnGoRecentHistory">전체보기 →</a>
											</div>
											<div class="wish-grid">
												<div v-if="recentList.length === 0" class="empty-state">
													<p>최근 본 상품이 없습니다.</p>
												</div>

												<div class="wish-item" v-for="item in recentList" :key="item.productId"
													@click="fnGoProductDetail(item.productId)">

													<div class="wish-thumb">
														<img v-if="item.imgUrl" :src="item.imgUrl"
															style="width:100%; height:100%; object-fit:cover;">
														<span v-else>🛒</span>
													</div>

													<button type="button" class="wish-remove-icon"
														:class="{ on: fnIsWished(item.productId) }" title="찜하기"
														@click.stop="fnToggleWishlist(item)">
														<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
															stroke-width="2">
															<path
																d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
														</svg>
													</button>

													<div class="wish-body">
														<div class="wish-name-wrap">
															<span class="wish-name">
																{{ item.productName }}
																<span v-if="item.brandName" class="wish-brand-inline">
																	· {{ item.brandName }}
																</span>
															</span>
														</div>

														<div v-if="item.categoryName" class="wish-category-pill">
															{{ item.categoryName }}
														</div>
														<div class="wish-rating-row">
															<span class="wish-stars-fill"
																:style="{ '--rating-width': fnRatingWidth(item.avgRating) }">
																<span class="star-base">★★★★★</span>
																<span class="star-fill">★★★★★</span>
															</span>

															<span class="wish-rating-text">
																{{ Number(item.avgRating || 0).toFixed(1) }}
																({{ item.reviewCount || 0 }})
															</span>
														</div>
														<div class="wish-price">
															{{ Number(item.price || 0).toLocaleString() }}원
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<!-- ── 배송지 목록 탭 ── -->
									<div class="tab-panel" id="tab-address">
										<div class="section-card">
											<div class="section-head address-head">
												<div class="title-wrap">
													<h3>배송지 목록</h3>
													<span class="address-limit-text">
														최대 7개 ({{ addressList.length }}/7)
													</span>
												</div>
												<button class="btn-save" @click="fnShowAddressForm">배송지 추가</button>
											</div>

											<div v-if="addressMsg" class="address-msg" :class="addressMsgType">
												{{ addressMsg }}
											</div>

											<!-- 추가/수정 폼 -->
											<div class="address-form-box" v-if="showAddressForm">
												<div class="address-form-title">
													{{ isEditMode ? '배송지 수정' : '새 배송지 입력' }}
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>수령인 이름</label>
														<input type="text" v-model="addressForm.receiverName"
															placeholder="홍길동">
													</div>
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>연락처</label>
														<input type="text" v-model="addressForm.receiverPhone"
															placeholder="01012345678" maxlength="11"
															@input="addressForm.receiverPhone = addressForm.receiverPhone.replace(/[^0-9]/g, '')">
													</div>
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>배송지 별칭</label>
														<input type="text" v-model="addressForm.addressAlias"
															placeholder="예: 집, 회사, 본가">
													</div>
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>우편번호</label>
														<div class="zipcode-wrap">
															<input type="text" v-model="addressForm.zipCode"
																placeholder="우편번호" readonly>
															<button type="button" class="btn-outline"
																@click="fnSearchAddress">
																주소 검색
															</button>
														</div>
													</div>
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>주소</label>
														<input type="text" v-model="addressForm.address"
															placeholder="주소 검색 버튼을 눌러주세요" readonly>
													</div>
												</div>

												<div class="address-form-row">
													<div class="setting-field">
														<label>상세주소</label>
														<input type="text" v-model="addressForm.detailedAddress"
															placeholder="상세주소를 입력하세요" ref="detailAddressInput">
													</div>
												</div>

												<div class="address-form-check">
													<label>
														<input type="checkbox" v-model="addressForm.defaultYn">
														기본 배송지로 설정
													</label>
												</div>

												<div class="settings-actions">
													<button type="button" class="btn-save" @click="fnSaveAddress">
														{{ isEditMode ? '수정' : '저장' }}
													</button>
													<button type="button" class="btn-outline"
														@click="fnCancelAddressForm">취소</button>
												</div>
											</div>

											<!-- 배송지 목록 -->
											<div class="address-list">
												<div class="address-item" v-for="addr in addressList"
													:key="addr.addressId">
													<div class="address-top">
														<div class="address-left">
															<div class="address-badge" v-if="addr.defaultYn === 'Y'">기본
																배송지</div>
															<div class="address-name">{{ addr.addressAlias }}</div>
														</div>
														<div class="address-actions">
															<button type="button" class="btn-outline btn-sm"
																@click="fnEditAddress(addr)">수정</button>
															<button type="button" class="btn-outline btn-sm danger"
																@click="fnDeleteAddress(addr.addressId)">삭제</button>
														</div>
													</div>

													<div class="address-receiver"
														v-if="addr.receiverName || addr.receiverPhone">
														<span v-if="addr.receiverName">{{ addr.receiverName }}</span>
														<span class="addr-meta-divider"
															v-if="addr.receiverName && addr.receiverPhone"> · </span>
														<span v-if="addr.receiverPhone">{{ addr.receiverPhone }}</span>
													</div>

													<div class="address-detail">
														({{ addr.zipCode }}) {{ addr.address }} {{ addr.detailedAddress
														}}
													</div>
												</div>

												<div v-if="addressList.length === 0" class="empty-state">
													<p>등록된 배송지가 없습니다.</p>
												</div>
											</div>

										</div><!-- /section-card -->
									</div><!-- /tab-address -->

									<!-- ── 포인트·쿠폰 탭 ── -->
									<div class="tab-panel" id="tab-benefits">
										<div class="section-card">
											<div class="section-head">
												<h3>포인트 · 쿠폰</h3>
											</div>
											<div class="benefit-grid">
												<div class="benefit-card">
													<div class="benefit-title">보유 포인트</div>
													<div class="benefit-amount">
														<fmt:formatNumber value="${summary.pointAmount}"
															pattern="#,###" />
														<span>P</span>
													</div>
													<div class="benefit-sub">1,000P 이상 사용 가능</div>
												</div>

												<div class="benefit-card">
													<div class="benefit-title">사용 가능 쿠폰</div>
													<div class="benefit-amount">
														${summary.couponCount}<span>장</span>
													</div>
													<div class="benefit-sub">
														<c:choose>
															<c:when test="${summary.expiringCouponCount > 0}">
																만료 임박 쿠폰 ${summary.expiringCouponCount}장
															</c:when>
															<c:otherwise>
																만료 임박 쿠폰 없음
															</c:otherwise>
														</c:choose>
													</div>
												</div>
											</div>
										</div>
										<div class="section-card">
											<div class="section-head benefits-history-head">
												<h3>포인트 · 쿠폰 내역</h3>
												<a href="javascript:;" @click="fnGoBenefitHistory">전체보기 →</a>
											</div>

											<div class="benefits-history-split">

												<!-- 왼쪽 : 포인트 내역 -->
												<div class="benefits-history-col">
													<div class="benefits-sub-head">
														<h4>포인트 내역</h4>
													</div>

													<div class="point-history mini-history">
														<c:choose>
															<c:when test="${not empty pointHistoryList}">
																<c:forEach var="item" items="${pointHistoryList}">
																	<div class="ph-item">
																		<div>
																			<div class="ph-desc">${item.description}
																			</div>
																			<div class="ph-date">${item.createdAt}</div>
																		</div>

																		<div
																			style="display:flex; flex-direction:column; align-items:flex-end; gap:4px;">
																			<!-- <div
                                                                                class="ph-point ${item.amount >= 0 ? 'plus' : 'minus'}">
                                                                                <c:if test="${item.amount >= 0}">+
                                                                                </c:if>
                                                                                <c:if test="${item.amount < 0}">-</c:if>
                                                                                <fmt:formatNumber
                                                                                    value="${item.amount < 0 ? item.amount * -1 : item.amount}"
                                                                                    pattern="#,###" />P
                                                                            </div> -->
																			<div
																				class="ph-point ${item.type == 'EARN' || item.type == 'RESTORE' ? 'plus' : 'minus'}">
																				<c:choose>
																					<c:when
																						test="${item.type == 'EARN' || item.type == 'RESTORE'}">
																						+</c:when>
																					<c:otherwise>-</c:otherwise>
																				</c:choose>
																				<fmt:formatNumber value="${item.amount}"
																					pattern="#,###" />P
																			</div>
																			<div class="ph-balance">
																				잔액
																				<fmt:formatNumber
																					value="${item.balanceAfter}"
																					pattern="#,###" />P
																			</div>
																		</div>
																	</div>
																</c:forEach>
															</c:when>

															<c:otherwise>
																<div class="empty-state small-empty">
																	<p>포인트 내역이 없습니다.</p>
																</div>
															</c:otherwise>
														</c:choose>
													</div>
												</div>

												<!-- 오른쪽 : 쿠폰 리스트 -->
												<div class="benefits-history-col">
													<div class="benefits-sub-head">
														<h4>쿠폰 리스트</h4>
													</div>

													<div class="coupon-history mini-history">
														<div v-if="couponList.length === 0"
															class="empty-state small-empty">
															<p>보유 쿠폰이 없습니다.</p>
														</div>

														<template v-for="(item, index) in couponList"
															:key="item.userCouponId">
															<div v-if="index < 3" class="coupon-ticket"
																:class="fnCouponStatusClass(item)">
																<div class="coupon-ticket-left">
																	<div class="coupon-ticket-label">MODAK</div>

																	<div class="coupon-ticket-name">
																		{{ item.couponName }}
																	</div>

																	<div class="coupon-ticket-benefit">
																		{{ fnCouponBenefitText(item) }}

																		<span class="coupon-ticket-condition-inline">
																			{{ fnCouponConditionText(item) }}
																		</span>
																	</div>

																	<div class="coupon-ticket-date">
																		~ {{ item.expiredAt }}
																	</div>
																</div>

																<div class="coupon-ticket-right">
																	<div class="coupon-status"
																		:class="fnCouponStatusClass(item)">
																		{{ fnCouponStatusText(item) }}
																	</div>
																</div>

															</div>

														</template>
													</div>
												</div>

											</div>
										</div>
									</div>

									<!-- ── 내 리뷰 탭 ── -->
									<div class="tab-panel" id="tab-reviews">
										<div class="section-card">
											<div class="section-head">
												<h3>내가 쓴 리뷰</h3>
												<a href="/user/review/history.do">전체보기 →</a>
											</div>

											<div class="review-list">
												<c:choose>
													<c:when test="${not empty reviewList}">
														<c:forEach var="item" items="${reviewList}">
															<div class="review-item">

																<div class="review-head">
																	<span class="review-product clickable"
																		@click="fnGoProductDetail(${item.productId})">
																		${ item.productName }
																	</span>

																	<div class="review-stars">
																		<c:forEach begin="1" end="5" var="i">
																			<svg class="star" viewBox="0 0 13 13"
																				fill="${i <= item.rating ? '#e0621a' : '#ccc'}">
																				<path
																					d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
																			</svg>
																		</c:forEach>
																	</div>
																</div>

																<div class="review-title">
																	${item.title}
																</div>

																<div class="review-body">
																	${item.content}
																</div>
																<c:if test="${not empty item.imageList}">
																	<div class="review-image-wrap">

																		<div class="review-image-grid">
																			<c:forEach var="img"
																				items="${item.imageList}"
																				varStatus="status">
																				<c:if test="${status.index < 4}">
																					<div class="review-image-thumb">

																						<img src="${img.imgUrl}"
																							alt="리뷰 이미지">

																						<c:if
																							test="${status.index == 3 && item.imageCount > 4}">
																							<div
																								class="review-image-overlay">
																								+${item.imageCount - 4}
																							</div>
																						</c:if>

																					</div>
																				</c:if>
																			</c:forEach>
																		</div>
																		<c:if test="${item.imageCount > 4}">

																		</c:if>

																	</div>
																</c:if>

																<div class="review-bottom">
																	<div class="review-date">
																		${item.createdAt}
																	</div>

																	<div class="review-actions">
																		<button type="button" class="btn-outline btn-sm"
																			@click="fnEditReview('${item.reviewId}')">수정</button>
																		<button type="button"
																			class="btn-outline btn-sm danger"
																			@click="fnRemoveReview('${item.reviewId}')">삭제</button>
																	</div>
																</div>

															</div>
														</c:forEach>
													</c:when>

													<c:otherwise>
														<div class="empty-state">
															<p>작성한 리뷰가 없습니다.</p>
														</div>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</div>

									<div class="tab-panel" id="tab-bookmarks">
										<div class="section-card bookmark-section-card">
											<div class="section-head bookmark-section-head">
												<div>
													<h3>스크랩한 글</h3>
													<p class="bookmark-section-sub">나중에 다시 보고 싶은 커뮤니티 글을 모아봤어요.</p>
												</div>
											</div>

											<div class="bookmark-card-list">
												<div v-if="bookmarkList.length === 0" class="empty-state">
													<p>스크랩한 게시글이 없습니다.</p>
												</div>
												<div class="bookmark-community-card" v-for="item in bookmarkList"
													:key="item.boardId" @click="fnGoBoardDetail(item.boardId)">
													<div class="bookmark-community-body">
														<div class="bookmark-category-pill">
															{{ fnBoardCategoryText(item.category) }}
														</div>

														<div class="bookmark-community-title">
															{{ item.title }}
														</div>

														<div class="bookmark-community-content" v-if="item.content">
															{{ fnPlainText(item.content) }}
														</div>

														<div class="bookmark-community-meta">
															<span class="bookmark-writer">
																{{ fnBookmarkWriter(item) }}
															</span>
															<span class="bookmark-dot">·</span>

															<span>{{ item.createdAt }}</span>

															<span class="bookmark-dot">·</span>

															<span class="bookmark-meta-icon">
																<i class="ri-eye-line"></i>
																{{ item.viewCount || 0 }}
															</span>

															<span class="bookmark-meta-icon like">
																<i class="ri-heart-3-fill"></i>
																{{ item.likeCount || 0 }}
															</span>

															<span class="bookmark-meta-icon">
																<i class="ri-chat-3-line"></i>
																{{ item.commentCount || 0 }}
															</span>
														</div>
													</div>

													<div class="bookmark-thumb-wrap" v-if="fnBookmarkThumb(item)">
														<img :src="fnBookmarkThumb(item)" alt="게시글 이미지">
													</div>
												</div>
											</div>
										</div>
									</div>
									<!-- ── 내 문의 목록 탭 ── -->
									<div class="tab-panel" id="tab-inquiries">
										<div class="section-card">
											<div class="section-head">
												<h3>내 문의 목록</h3>
												<a href="/user/inquiry/history.do">전체보기 →</a>
											</div>

											<div class="review-list inquiry-review-list">
												<div v-if="inquiryList.length === 0" class="empty-state">
													<p>문의 내역이 없습니다.</p>
												</div>

												<div class="review-item inquiry-review-item" v-for="item in inquiryList"
													:key="item.inquiryId">

													<div class="review-head inquiry-head"
														@click="fnToggleInquiry(item)">
														<div class="inquiry-head-left">
															<div class="review-title inquiry-main-title">
																{{ item.title }}
															</div>

															<div class="review-date inquiry-meta">
																{{ item.createdAt }}
															</div>
														</div>

														<div class="inquiry-head-right">
															<div class="inquiry-status"
																:class="fnInquiryStatusClass(item)">
																{{ fnInquiryStatusText(item) }}
															</div>

															<div class="review-actions" v-if="!item.replyId">
																<button type="button" class="btn-outline btn-sm"
																	@click.stop="fnEditInquiry(item.inquiryId)">
																	수정
																</button>
																<button type="button" class="btn-outline btn-sm danger"
																	@click.stop="fnDeleteInquiry(item.inquiryId)">
																	삭제
																</button>
															</div>

															<div class="inquiry-toggle-icon"
																:class="{ open: openInquiryId === item.inquiryId }">
																▼
															</div>
														</div>
													</div>

													<div v-if="openInquiryId === item.inquiryId"
														class="inquiry-expand-area">
														<div class="inquiry-detail-box">
															<div class="inquiry-detail-section">
																<div class="detail-label">문의 내용</div>
																<div class="detail-value detail-content">
																	{{ item.content }}
																</div>
															</div>

															<div class="inquiry-detail-divider"
																v-if="item.imageList && item.imageList.length > 0">
															</div>

															<div class="inquiry-detail-section"
																v-if="item.imageList && item.imageList.length > 0">
																<div class="detail-label">첨부 이미지</div>
																<div class="detail-value">
																	<div class="inquiry-image-list">
																		<img v-for="img in item.imageList"
																			:key="img.inquiryImgId" :src="img.imgUrl"
																			class="inquiry-detail-img" alt="문의 이미지">
																	</div>
																</div>
															</div>
														</div>

														<div class="inquiry-detail-box answer-box">
															<div class="inquiry-detail-section">
																<div class="detail-label">문의 답변</div>
																<div class="detail-value detail-content"
																	v-if="item.answer">
																	{{ item.answer }}
																</div>
																<div class="detail-value" v-else>
																	아직 답변이 등록되지 않았습니다.
																</div>
															</div>
														</div>
													</div>

												</div>
											</div>
										</div>
									</div>
									<!-- ── 채팅방 목록 탭 ── -->
									<div class="tab-panel" id="tab-chatRooms">
										<div class="section-card chat-room-section-card">
											<div class="section-head chat-room-section-head">
												<div>
													<h3>채팅방 목록</h3>
													<p class="chat-room-section-sub">최근 대화한 채팅방을 확인할 수 있습니다.</p>
												</div>

												<a href="/chat-room/list.do">전체보기 →</a>
											</div>

											<div class="mypage-chat-room-list">
												<div v-if="limitedChatRoomList.length === 0" class="empty-state">
													<p>진행 중인 채팅방이 없습니다.</p>
												</div>

												<div class="mypage-chat-room-item" v-for="room in limitedChatRoomList"
													:key="room.ROOM_ID || room.roomId" @click="fnGoChatRoom(room)">
													<div class="mypage-chat-avatar">
														<img v-if="room.OTHER_IMG || room.otherImg"
															:src="room.OTHER_IMG || room.otherImg" alt="상대방 프로필">
														<div v-else class="mypage-chat-avatar-fallback">
															{{ fnChatInitial(room) }}
														</div>

														<span
															v-if="Number(room.UNREAD_COUNT || room.unreadCount || 0) > 0"
															class="mypage-chat-unread-dot"></span>
													</div>

													<div class="mypage-chat-info">
														<div class="mypage-chat-name">
															{{ room.OTHER_NICK || room.otherNick || room.OTHER_ID ||
															room.otherId ||
															'상대방' }}
														</div>

														<div class="mypage-chat-last">
															{{ fnChatPreview(room.LAST_MSG || room.lastMsg) }}
														</div>
													</div>

													<div class="mypage-chat-meta">
														<span class="mypage-chat-time">
															{{ fnChatTime(room.LAST_AT || room.lastAt) }}
														</span>

														<span
															v-if="Number(room.UNREAD_COUNT || room.unreadCount || 0) > 0"
															class="mypage-chat-unread-badge">
															{{ Number(room.UNREAD_COUNT || room.unreadCount || 0) > 99 ?
															'99+' :
															Number(room.UNREAD_COUNT || room.unreadCount || 0) }}
														</span>
													</div>
												</div>
											</div>
										</div>
									</div>
									<!-- ── 챗봇 기록 탭 ── -->
									<div class="tab-panel" id="tab-chatbot">
										<div class="section-card">
											<div class="section-head">
												<h3>챗봇 기록</h3>
												<a href="javascript:;" @click="fnGoChatbotHistory">전체보기 →</a>
											</div>

											<div class="review-list chatbot-review-list">
												<div v-if="chatbotList.length === 0" class="empty-state">
													<p>챗봇 기록이 없습니다.</p>
												</div>

												<div class="review-item chatbot-review-item"
													v-for="chat in limitedChatbotList" :key="chat.roomId"
													@click="fnGoChatbotRoom(chat.roomId)">

													<div class="review-head chatbot-head">
														<div class="chatbot-head-left">
															<div class="chatbot-icon-wrap">💬</div>

															<div class="chatbot-head-text">
																<div class="review-title chatbot-title">
																	{{ chat.title && chat.title.trim() ? chat.title :
																	'대화' }}
																</div>

																<div class="chatbot-preview" v-if="chat.lastMessage">
																	{{ chat.lastMessage }}
																</div>
															</div>
														</div>

														<div class="chatbot-arrow">→</div>
													</div>

													<div class="review-bottom chatbot-bottom">
														<div class="review-date chatbot-date">
															{{ chat.lastRegDate }}
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<!-- ── 계정설정 탭 ── -->
									<div class="tab-panel" id="tab-settings">

										<!-- 일반 회원 -->
										<template v-if="!settingsForm.socialType">
											<!-- 기본 정보 -->
											<div class="section-card account-settings-card">
												<div class="account-settings-hero">
													<div>
														<div class="account-kicker">ACCOUNT SETTINGS</div>
														<h3>계정 설정</h3>
														<p>아이디, 이름, 닉네임, 연락처 정보를 관리할 수 있습니다.</p>
													</div>

													<div class="account-status-chip"
														:class="settingsForm.phoneVerifyYn === 'Y' ? 'verified' : 'not-verified'">
														{{ settingsForm.phoneVerifyYn === 'Y' ? "휴대폰 인증 완료" : "휴대폰 인증 필요" }}
													</div>
												</div>

												<div class="settings-form account-settings-form">
													<div v-if="settingsMsg" class="settings-msg account-settings-msg"
														:class="settingsMsgType">
														{{ settingsMsg }}
													</div>

													<div class="account-form-grid">
														<div class="setting-field account-field">
															<label>아이디</label>
															<input type="text" v-model="settingsForm.userId"
																placeholder="아이디를 입력하세요">
															<div class="account-field-help">
																영문, 숫자 조합을 권장합니다. 변경 후 다시 로그인해야 할 수 있습니다.
															</div>
														</div>

														<div class="setting-field account-field">
															<label>이메일</label>
															<input type="text" v-model="settingsForm.email" readonly>
															<div class="account-field-help muted">
																이메일은 계정 확인용으로 사용됩니다.
															</div>
														</div>

														<div class="setting-field account-field">
															<label>이름</label>
															<input type="text" v-model="settingsForm.userName"
																placeholder="이름">
														</div>

														<div class="setting-field account-field">
															<label>닉네임</label>
															<input type="text" v-model="settingsForm.nickName"
																placeholder="닉네임">
														</div>

													</div>

													<div class="account-settings-bottom">
														<div class="account-save-desc">
															아이디, 이름, 닉네임 변경사항을 저장하면 프로필 정보에도 반영됩니다.
														</div>

														<div class="settings-actions account-actions">
															<button type="button" class="btn-save account-save-btn"
																@click="fnSaveSettings" :disabled="!isSettingsChanged">
																변경사항 저장
															</button>

															<button type="button" class="btn-outline account-reset-btn"
																@click="fnResetSettings">
																되돌리기
															</button>
														</div>
													</div>
												</div>
											</div>

											<!-- 비밀번호 변경 -->
											<div class="section-card">
												<div class="section-head">
													<h3>비밀번호 변경</h3>
												</div>

												<div class="settings-lock-box"
													v-if="settingsForm.phoneVerifyYn !== 'Y'">
													<div class="settings-lock-title">휴대폰 인증 후 비밀번호 변경 가능</div>
													<div class="settings-lock-desc">
														계정 보안을 위해 휴대폰 인증을 완료한 뒤 비밀번호를 변경할 수 있습니다.
													</div>
												</div>

												<div class="settings-form" v-else>
													<div v-if="passwordMsg" class="settings-msg"
														:class="passwordMsgType">
														{{ passwordMsg }}
													</div>

													<div class="setting-row">
														<div class="setting-field">
															<label>현재 비밀번호</label>
															<input type="password" v-model="passwordForm.currentPwd"
																placeholder="현재 비밀번호">
														</div>

														<div class="password-pair-row">
															<div class="setting-field" style="flex:1">
																<label>새 비밀번호</label>
																<input type="password" v-model="passwordForm.newPwd"
																	placeholder="새 비밀번호">

																<div class="password-guide"
																	:class="passwordStrengthClass">
																	{{ passwordStrengthText }}
																</div>
															</div>

															<div class="setting-field" style="flex:1">
																<label>확인</label>
																<input type="password"
																	v-model="passwordForm.newPwdConfirm"
																	placeholder="비밀번호 확인">

																<div class="password-guide"
																	v-if="passwordForm.newPwdConfirm"
																	:class="passwordMatch ? 'match-ok' : 'match-fail'">
																	{{ passwordMatch ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다." }}
																</div>
															</div>
														</div>
													</div>

													<div class="settings-actions">
														<button type="button" class="btn-save"
															@click="fnChangePassword">변경하기</button>
													</div>
												</div>

											</div>
										</template>
										</template>

										<!-- 소셜 로그인 회원 -->
										<div class="section-card social-only-box" v-else>
											<div class="social-message">
												소셜 로그인 회원은 아이디, 비밀번호 등 기본 계정 정보는 수정할 수 없습니다.<br>
												휴대폰 인증은 아래에서 진행할 수 있습니다.
											</div>
										</div>

										<!-- 휴대폰 인증 : 일반/소셜 회원 공통 -->
										<div class="section-card account-phone-verify-card">
											<div class="section-head">
												<h3>휴대폰 인증</h3>
											</div>

											<div class="settings-form account-settings-form">
												<div class="account-status-chip phone-card-chip"
													:class="settingsForm.phoneVerifyYn === 'Y' ? 'verified' : 'not-verified'">
													{{ settingsForm.phoneVerifyYn === 'Y' ? "휴대폰 인증 완료" : "휴대폰 인증 필요" }}
												</div>

												<div class="setting-field account-field account-phone-field">
													<label>연락처</label>

													<div class="phone-verify-wrap account-phone-wrap">
														<div class="phone-input-row account-phone-row">
															<input type="text" v-model="settingsForm.userPhone"
																placeholder="01012345678" maxlength="11">

															<button type="button" class="btn-outline account-mini-btn"
																@click="fnSendSmsCode"
																:disabled="!settingsForm.userPhone">
																인증요청
															</button>
														</div>

														<div class="phone-input-row account-phone-row"
															v-if="smsInputVisible">
															<input type="text" v-model="smsAuthCode"
																placeholder="인증번호 입력">

															<button type="button" class="btn-save account-mini-btn"
																@click="fnVerifySmsCode" :disabled="smsExpired">
																확인
															</button>
														</div>

														<div class="phone-timer-wrap" v-if="smsInputVisible">
															<span v-if="!smsExpired" class="phone-timer-text">
																남은 시간 {{ formattedSmsTime }}
															</span>
															<span v-else class="phone-timer-expired">
																인증 시간이 만료되었습니다.
															</span>
														</div>

														<div class="phone-verify-status">
															<span v-if="settingsForm.phoneVerifyYn === 'Y'"
																class="verify-success">
																인증된 연락처입니다.
															</span>
															<span v-else class="verify-fail">
																회원탈퇴 및 보안 설정을 위해 휴대폰 인증이 필요합니다.
															</span>
														</div>
													</div>
												</div>
											</div>
										</div>

										<!-- 계정 관리 / 회원탈퇴 : 일반/소셜 공통 -->
										<div class="section-card">
											<div class="settings-divider"></div>

											<div class="danger-zone withdraw-zone">
												<div class="danger-title">계정 관리</div>

												<div class="withdraw-guide-box">
													<div class="withdraw-guide-title">
														<i class="ri-error-warning-line"></i>
														회원탈퇴 전 꼭 확인해주세요
													</div>

													<ul class="withdraw-guide-list">
														<li>탈퇴 후에는 같은 계정으로 로그인할 수 없습니다.</li>
														<li>작성한 게시글, 리뷰, 문의 내역은 서비스 운영 정책에 따라 남아 있을 수 있습니다.</li>
														<li>보유 포인트와 쿠폰은 탈퇴 즉시 사용할 수 없습니다.</li>
														<li>진행 중인 주문, 대여, 환불, 교환이 있는 경우 처리 완료 후 탈퇴를 권장합니다.</li>
													</ul>
												</div>

												<div class="settings-lock-box"
													v-if="settingsForm.phoneVerifyYn !== 'Y'">
													<div class="settings-lock-title">휴대폰 인증 후 회원탈퇴 가능</div>
													<div class="settings-lock-desc">
														계정 보호를 위해 휴대폰 인증을 완료한 뒤 회원탈퇴를 진행할 수 있습니다.
													</div>
												</div>

												<button v-else type="button" class="btn-danger withdraw-btn"
													@click="fnDeleteUser">
													회원탈퇴
												</button>
											</div>
										</div>


									</div>
								</main>
							</div><!-- /page-wrap -->

							<div class="toast" id="toast"></div>

							<!-- 모달은 반드시 #app 안에 있어야 함 -->
							<div v-if="modal.show" class="delete-modal-backdrop" @click.self="fnCloseModal">
								<div class="delete-modal-box" ref="confirmModal" tabindex="0"
									@keydown.enter.prevent="fnModalConfirm" @keydown.esc.prevent="fnCloseModal">
									<div class="delete-modal-title">{{ modal.title }}</div>
									<div class="delete-modal-desc" v-html="modal.message"></div>
									<div class="delete-modal-actions">
										<button type="button" class="delete-confirm-btn" @click="fnModalConfirm">
											{{ modal.confirmText }}
										</button>
										<button type="button" class="delete-cancel-btn" @click="fnCloseModal">
											취소
										</button>
									</div>
								</div>
							</div>

						</div> <!-- id="app" 끝 -->
						<%@ include file="/WEB-INF/common/footer.jsp" %>
				</body>

				</html>

				<script>
					function switchTab(tabName, el) {
						// 모든 탭 숨김
						document.querySelectorAll('.tab-panel').forEach(function (panel) {
							panel.classList.remove('active');
						});

						// 선택 탭 표시
						const target = document.getElementById('tab-' + tabName);
						if (target) {
							target.classList.add('active');
						}

						// 사이드바 active 처리
						document.querySelectorAll('.nav-card .nav-item').forEach(function (item) {
							item.classList.remove('active');
						});

						if (el) {
							el.classList.add('active');
						} else {
							const navItems = document.querySelectorAll('.nav-card .nav-item');
							navItems.forEach(function (item) {
								const onclickText = item.getAttribute('onclick') || '';
								if (onclickText.indexOf("'" + tabName + "'") > -1 || onclickText.indexOf('"' + tabName + '"') > -1) {
									item.classList.add('active');
								}
							});
						}

						// 현재 탭 저장
						sessionStorage.setItem('activeTab', tabName);
					}

					const app = Vue.createApp({
						data() {
							return {
								// 변수 - (key : value)
								orderList: [],
								selectedOrderStatus: 'ALL',

								addressList: [],
								showAddressForm: false,

								addressForm: {
									addressAlias: "",
									zipCode: "",
									address: "",
									detailedAddress: "",
									defaultYn: false
								},
								addressMsg: "",
								addressMsgType: "",

								isEditMode: false,
								editAddressId: "",

								wishlist: [],
								recentList: [],
								chatbotList: [],
								bookmarkList: [],
								settingsForm: {
									userId: "${user.userId}",
									userName: "",
									nickName: "",
									email: "",
									userPhone: "",
									phoneVerifyYn: "N",
									phoneVerifiedAt: "",
									socialType: ""
								},
								originalPhone: "",
								verifiedPhone: "",
								smsAuthCode: "",
								settingsMsg: "",
								settingsMsgType: "",

								passwordForm: {
									currentPwd: "",
									newPwd: "",
									newPwdConfirm: ""
								},
								smsTimer: null,
								smsTimeLeft: 0,
								smsExpired: false,

								smsInputVisible: false,
								passwordMsg: "",
								passwordMsgType: "",
								inquiryList: [],
								openInquiryId: null,

								displayUser: {
									userName: "${user.userName}",
									nickName: "${user.nickName}",
									profileImgUrl: "${empty user.profileImgUrl ? '' : user.profileImgUrl}"
								},
								profileImageVersion: Date.now(),
								modal: {
									show: false,
									title: '',
									message: '',
									confirmText: '확인',
									onConfirm: null
								},
								originalSettingsForm: {
									userId: "",
									userName: "",
									nickName: "",
									userPhone: ""
								},
								couponList: [],
								chatRoomList: [],
							};
						},
						computed: {
							limitedChatRoomList() {
								return this.chatRoomList.slice(0, 5);
							},
							isSettingsChanged() {
								return this.settingsForm.userId !== this.originalSettingsForm.userId
									|| this.settingsForm.userName !== this.originalSettingsForm.userName
									|| this.settingsForm.nickName !== this.originalSettingsForm.nickName;
							},
							limitedOrderList() {
								return this.filteredOrderList.slice(0, 5);
							},
							passwordStrengthScore() {
								let pwd = this.passwordForm.newPwd || "";
								let score = 0;

								if (pwd.length >= 8) score++;
								if (/[A-Za-z]/.test(pwd)) score++;
								if (/[0-9]/.test(pwd)) score++;
								if (/[^A-Za-z0-9]/.test(pwd)) score++;

								return score;
							},
							profileImageSrc() {
								let url = this.displayUser.profileImgUrl;

								if (!url || url === "null" || url === "undefined") {
									return "/img/profile/default-profile.png";
								}

								url = String(url).trim();

								if (
									!url.startsWith("/img/profile/") &&
									!url.startsWith("/upload/profile/")
								) {
									return "/img/profile/default-profile.png";
								}

								return url + "?v=" + this.profileImageVersion;
							},
							passwordStrengthText() {
								let pwd = this.passwordForm.newPwd || "";

								if (!pwd) {
									return "영문, 숫자를 조합해 8자 이상 입력해주세요.";
								}

								if (this.passwordStrengthScore <= 1) {
									return "비밀번호 강도: 약함";
								} else if (this.passwordStrengthScore <= 3) {
									return "비밀번호 강도: 보통";
								} else {
									return "비밀번호 강도: 강함";
								}
							},
							passwordStrengthClass() {
								if (!this.passwordForm.newPwd) {
									return "";
								}

								if (this.passwordStrengthScore <= 1) {
									return "strength-weak";
								} else if (this.passwordStrengthScore <= 3) {
									return "strength-medium";
								} else {
									return "strength-strong";
								}
							},
							passwordMatch() {
								return this.passwordForm.newPwd &&
									this.passwordForm.newPwdConfirm &&
									this.passwordForm.newPwd === this.passwordForm.newPwdConfirm;
							},
							statusSummary() {
								const summary = {
									paid: 0,
									ready: 0,
									shipping: 0,
									done: 0,
									cancelled: 0
								};

								this.orderList.forEach(function (item) {
									const status = (item.orderStatus || "").toUpperCase();
									const orderType = (item.orderType || "").toUpperCase();

									if (status === "PAID") {
										summary.paid++;
									} else if (status === "READY") {
										summary.ready++;
									} else if (status === "SHIPPING") {
										summary.shipping++;
									} else if (status === "DONE" || status === "RETURNED") {
										summary.done++;
									} else if (
										status === "CANCELLED" ||
										status === "CANCEL_REQUESTED" ||
										status === "REFUND_REQUESTED" ||
										status === "REFUND_APPROVED" ||
										status === "REFUNDED" ||
										status === "RETURN_REQUESTED" ||
										status === "RETURN_APPROVED" ||
										status === "RETURN_COMPLETED" ||
										status === "EXCHANGE_REQUESTED" ||
										status === "EXCHANGE_APPROVED" ||
										status === "EXCHANGE_COMPLETED"
									) {
										summary.cancelled++;
									}
								});

								return summary;
							},
							formattedSmsTime() {
								const minutes = Math.floor(this.smsTimeLeft / 60);
								const seconds = this.smsTimeLeft % 60;
								return minutes + ":" + String(seconds).padStart(2, "0");
							},
							limitedChatbotList() {
								return this.chatbotList.slice(0, 6);
							},


							limitedWishlist() {
								return this.wishlist.slice(0, 9);
							},
							filteredOrderList() {
								if (this.selectedOrderStatus === "ALL") {
									return this.orderList;
								}

								return this.orderList.filter(item => {
									const status = (item.orderStatus || "").toUpperCase();
									const orderType = (item.orderType || "").toUpperCase();

									if (this.selectedOrderStatus === "DONE") {
										return status === "DONE" || status === "RETURNED";
									}

									if (this.selectedOrderStatus === "READY") {
										return status === "READY";
									}
									if (this.selectedOrderStatus === "CANCELLED") {
										return status === "CANCELLED"
											|| status === "CANCEL_REQUESTED"
											|| status === "REFUND_REQUESTED"
											|| status === "REFUND_APPROVED"
											|| status === "REFUNDED"
											|| status === "RETURN_REQUESTED"
											|| status === "RETURN_APPROVED"
											|| status === "RETURN_COMPLETED"
											|| status === "EXCHANGE_REQUESTED"
											|| status === "EXCHANGE_APPROVED"
											|| status === "EXCHANGE_COMPLETED";
									}

									return status === this.selectedOrderStatus;
								});
							},
						},
						methods: {
							showToast: function (msg) {
								var t = document.getElementById("toast");
								if (!t) return;

								t.textContent = msg;
								t.classList.add("show");

								setTimeout(function () {
									t.classList.remove("show");
								}, 2300);
							},

							fnOpenModal: function (option) {
								var self = this;

								self.modal.show = true;
								self.modal.title = option.title || "확인";
								self.modal.message = option.message || "";
								self.modal.confirmText = option.confirmText || "확인";
								self.modal.onConfirm = option.onConfirm || null;

								self.$nextTick(function () {
									if (self.$refs.confirmModal) {
										self.$refs.confirmModal.focus();
									}
								});
							},

							fnCloseModal: function () {
								this.modal.show = false;
								this.modal.onConfirm = null;
							},
							fnGetBookmarkList: function () {
								let self = this;

								$.ajax({
									url: "/bookmark/list.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										console.log("스크랩 응답 전체:", data);
										console.log("스크랩 첫 번째:", data.list && data.list.length > 0 ? data.list[0] : null);
										if (data.result === "success") {
											self.bookmarkList = data.list || [];
										} else {
											self.bookmarkList = [];
										}
									},
									error: function () {
										self.bookmarkList = [];
									}
								});
							},

							fnGoBoardDetail: function (boardId) {
								location.href = "/board/detail.do?boardId=" + boardId;
							},
							fnModalConfirm: function () {
								var callback = this.modal.onConfirm;
								this.fnCloseModal();

								if (typeof callback === "function") {
									callback();
								}
							},
							// 함수(메소드) - (key : function())
							fnGetOrderList: function () {
								let self = this;
								let param = {};
								$.ajax({
									url: "http://localhost:8080/order/list.dox",
									dataType: "json",
									type: "POST",
									data: param,
									success: function (data) {
										if (data.result === "success") {
											self.orderList = data.list;
											console.log(self.orderList);
											data.list.forEach(function (item) {
												if (item.orderStatus === "SHIPPING" || item.orderStatus === "READY" || item.orderStatus === "DONE") {
													console.log("주문번호:", item.orderId);
													console.log("전체 item:", item);
													console.log("deliveryId:", item.deliveryId);
													console.log("deliveryStatus:", item.deliveryStatus);
												}
											});
										} else {
											self.orderList = [];
										}
										console.log(data);
									}
								});
							},
							fnGetStatusText: function (status) {
								status = (status || "").toUpperCase();

								if (status === "PAID") return "결제완료";
								if (status === "READY") return "배송준비";
								if (status === "SHIPPING") return "배송중";
								if (status === "DONE") return "배송완료";
								if (status === "RETURNED") return "반납완료";

								if (status === "CANCEL_REQUESTED") return "취소요청";
								if (status === "CANCELLED") return "취소완료";

								if (status === "REFUND_REQUESTED") return "환불요청";
								if (status === "REFUND_APPROVED") return "환불승인";
								if (status === "REFUNDED") return "환불완료";

								if (status === "RETURN_REQUESTED") return "반품요청";
								if (status === "RETURN_APPROVED") return "반품승인";
								if (status === "RETURN_COMPLETED") return "반품완료";

								if (status === "EXCHANGE_REQUESTED") return "교환요청";
								if (status === "EXCHANGE_APPROVED") return "교환승인";
								if (status === "EXCHANGE_COMPLETED") return "교환완료";

								return status || "-";
							},
							fnFilterByStatus: function (status) {
								if (this.selectedOrderStatus === status) {
									// 같은 거 다시 누르면 전체로
									this.selectedOrderStatus = "ALL";
								} else {
									this.selectedOrderStatus = status;
								}
							},

							fnShowAddressForm: function () {
								this.addressMsg = "";
								this.addressMsgType = "";

								if (this.addressList.length >= 7) {
									this.showAddressForm = false;
									this.addressMsg = "배송지는 최대 7개까지 등록할 수 있습니다.";
									this.addressMsgType = "error";
									return;
								}

								this.isEditMode = false;
								this.editAddressId = "";
								this.showAddressForm = true;

								this.addressForm = {
									addressAlias: "",
									receiverName: "",
									receiverPhone: "",
									zipCode: "",
									address: "",
									detailedAddress: "",
									defaultYn: false
								};
							},
							fnCancelAddressForm: function () {
								this.showAddressForm = false;
								this.isEditMode = false;
								this.editAddressId = "";
								this.addressMsg = "";

								this.addressForm = {
									addressAlias: "",
									receiverName: "",
									receiverPhone: "",
									zipCode: "",
									address: "",
									detailedAddress: "",
									defaultYn: false
								};
							},

							// 배송지 관련 함수
							fnSaveAddress: function () {
								let self = this;

								self.addressMsg = "";

								if (!self.addressForm.addressAlias.trim()) {
									self.addressMsg = "배송지 별칭을 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}
								// 기존 유효성 검사 블록 아래에 추가
								if (!self.addressForm.receiverName.trim()) {
									self.addressMsg = "수령인 이름을 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}

								if (!self.addressForm.receiverPhone.trim()) {
									self.addressMsg = "연락처를 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}

								if (!/^010\d{8}$/.test(self.addressForm.receiverPhone)) {
									self.addressMsg = "연락처는 010으로 시작하는 11자리 숫자로 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}


								if (!self.addressForm.zipCode.trim()) {
									self.addressMsg = "주소 검색을 통해 우편번호를 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}

								if (!self.addressForm.address.trim()) {
									self.addressMsg = "주소를 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}

								if (!self.addressForm.detailedAddress.trim()) {
									self.addressMsg = "상세주소를 입력해주세요.";
									self.addressMsgType = "error";
									return;
								}

								let param = {
									addressId: self.editAddressId,
									addressAlias: self.addressForm.addressAlias,
									receiverName: self.addressForm.receiverName,
									receiverPhone: self.addressForm.receiverPhone,
									zipCode: self.addressForm.zipCode,
									address: self.addressForm.address,
									detailedAddress: self.addressForm.detailedAddress,
									defaultYn: self.addressForm.defaultYn ? "Y" : "N"
								};

								let url = self.isEditMode ? "/user/address/edit.dox" : "/user/address/add.dox";

								$.ajax({
									url: url,
									type: "POST",
									dataType: "json",
									data: param,
									success: function (data) {
										if (data.result === "success") {
											self.fnCancelAddressForm();
											self.fnGetAddressList();
										} else {
											self.addressMsg = data.message || "처리에 실패했습니다.";
											self.addressMsgType = "error";
										}
									},
									error: function () {
										self.addressMsg = "서버 오류가 발생했습니다.";
										self.addressMsgType = "error";
									}
								});
							},

							fnGetAddressList: function () {
								let self = this;

								$.ajax({
									url: "http://localhost:8080/user/address/list.dox",
									dataType: "json",
									type: "POST",
									data: {},
									success: function (data) {
										if (data.result === "success") {
											self.addressList = data.list;
										} else {
											self.addressList = [];
										}
									}
								});
							},
							fnSearchAddress: function () {
								let self = this;

								new kakao.Postcode({
									oncomplete: function (data) {
										let addr = "";

										if (data.userSelectedType === "R") {
											addr = data.roadAddress;   // 도로명 주소
										} else {
											addr = data.jibunAddress;  // 지번 주소
										}

										self.addressForm.zipCode = data.zonecode;
										self.addressForm.address = addr;

										self.$nextTick(function () {
											if (self.$refs.detailAddressInput) {
												self.$refs.detailAddressInput.focus();
											}
										});
									}
								}).open();
							},
							fnEditAddress: function (addr) {
								this.showAddressForm = true;
								this.isEditMode = true;
								this.editAddressId = addr.addressId;
								this.addressMsg = "";

								this.addressForm = {
									addressAlias: addr.addressAlias || "",
									receiverName: addr.receiverName || "",
									receiverPhone: addr.receiverPhone || "",
									zipCode: addr.zipCode || "",
									address: addr.address || "",
									detailedAddress: addr.detailedAddress || "",
									defaultYn: addr.defaultYn === "Y"
								};
							},

							fnDeleteAddress: function (addressId) {
								let self = this;

								// ✅ 기존 바로 ajax 호출 → 모달 확인 후 삭제로 변경
								self.fnOpenModal({
									title: "배송지를 삭제하시겠습니까?",
									message: "삭제한 배송지는 복구할 수 없습니다.",
									confirmText: "삭제",
									onConfirm: function () {
										$.ajax({
											url: "/user/address/remove.dox",
											type: "POST",
											dataType: "json",
											data: { addressId: addressId },
											success: function (data) {
												if (data.result === "success") {
													self.fnGetAddressList();
													self.showToast("배송지가 삭제됐어요.");
													if (self.editAddressId == addressId) {
														self.fnCancelAddressForm();
													}
												} else {
													self.addressMsg = data.message || "삭제에 실패했습니다.";
													self.addressMsgType = "error";
												}
											},
											error: function () {
												self.addressMsg = "서버 오류가 발생했습니다.";
												self.addressMsgType = "error";
											}
										});
									}
								});
							},
							fnGetWishlist: function () {
								let self = this;

								$.ajax({
									url: "http://localhost:8080/user/wishlist/list.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										if (data.result === "success") {
											self.wishlist = data.list;
										} else {
											self.wishlist = [];
										}
									}
								});
							},
							fnGoProductDetail: function (productId) {
								pageChange("/product/detail.do", {
									productId: productId
								});
							},
							fnGoWishlistHistory: function () {
								pageChange("/user/wishlist/history.do", {});
							},
							fnGetRecentList: function () {
								let self = this;

								$.ajax({
									url: "/user/recent/list.dox",
									type: "POST",
									dataType: "json",
									data: {
										page: 1,
										pageSize: 9
									},
									success: function (data) {
										console.log("마이페이지 최근 본 상품 응답:", data);

										if (data.result === "success") {
											self.recentList = data.list || [];
										} else {
											self.recentList = [];
										}
									},
									error: function () {
										self.recentList = [];
									}
								});
							},
							fnGoRecentHistory: function () {
								pageChange("/user/recent/history.do", {});
							},

							fnEditReview: function (reviewId) {
								pageChange("/user/review/edit.do", { reviewId: reviewId });
							},

							fnChangePassword: function () {
								let self = this;
								self.passwordMsg = "";
								self.passwordMsgType = "";

								if (!(self.passwordForm.currentPwd || "").trim()) {
									self.passwordMsg = "현재 비밀번호를 입력해주세요.";
									self.passwordMsgType = "error";
									return;
								}

								if (!(self.passwordForm.newPwd || "").trim()) {
									self.passwordMsg = "새 비밀번호를 입력해주세요.";
									self.passwordMsgType = "error";
									return;
								}

								if ((self.passwordForm.newPwd || "").length < 8) {
									self.passwordMsg = "새 비밀번호는 8자 이상이어야 합니다.";
									self.passwordMsgType = "error";
									return;
								}

								if (!(self.passwordForm.newPwdConfirm || "").trim()) {
									self.passwordMsg = "비밀번호 확인을 입력해주세요.";
									self.passwordMsgType = "error";
									return;
								}

								if (self.passwordForm.newPwd !== self.passwordForm.newPwdConfirm) {
									self.passwordMsg = "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
									self.passwordMsgType = "error";
									return;
								}

								$.ajax({
									url: "/user/settings/password/update.dox",
									type: "POST",
									dataType: "json",
									data: {
										currentPwd: self.passwordForm.currentPwd,
										newPwd: self.passwordForm.newPwd
									},
									success: function (data) {
										if (data.result === "success") {
											self.showToast(data.message || "비밀번호가 변경되었습니다.");

											self.passwordForm.currentPwd = "";
											self.passwordForm.newPwd = "";
											self.passwordForm.newPwdConfirm = "";
										} else {
											self.showToast(data.message || "비밀번호 변경에 실패했습니다.");
										}
									},
									error: function () {
										self.showToast("서버 오류가 발생했습니다.");
									}
								});
							},
							fnDeleteUser: function () {
								let self = this;

								if (self.settingsForm.phoneVerifyYn !== "Y") {
									self.showToast("휴대폰 인증 후 회원탈퇴를 진행할 수 있습니다.");
									return;
								}

								self.fnOpenModal({
									title: "정말 회원탈퇴를 진행하시겠습니까?",
									message:
										"<div class='withdraw-modal-content'>" +
										"<p class='withdraw-modal-main'>" +
										"회원탈퇴 시 계정은 비활성화되며, 다시 로그인할 수 없습니다." +
										"</p>" +

										"<div class='withdraw-notice-box'>" +
										"<div class='withdraw-notice-title'>탈퇴 전 안내사항</div>" +
										"<ul>" +
										"<li>보유 포인트와 쿠폰은 더 이상 사용할 수 없습니다.</li>" +
										"<li>작성한 게시글, 리뷰, 문의는 운영 정책에 따라 보관될 수 있습니다.</li>" +
										"<li>진행 중인 주문, 대여, 교환, 환불이 있다면 먼저 처리를 완료해주세요.</li>" +
										"<li>탈퇴 후 계정 정보는 복구할 수 없습니다.</li>" +
										"</ul>" +
										"</div>" +

										"<p class='withdraw-modal-question'>" +
										"위 내용을 확인하셨다면 탈퇴를 계속 진행해주세요." +
										"</p>" +
										"</div>",
									confirmText: "계속 진행",
									onConfirm: function () {
										self.fnOpenModal({
											title: "마지막 확인",
											message:
												"<div class='withdraw-modal-content'>" +
												"<p class='withdraw-modal-main strong'>" +
												"정말로 탈퇴하시겠습니까?" +
												"</p>" +
												"<p class='withdraw-modal-sub'>" +
												"이 작업은 취소할 수 없으며, 탈퇴 후에는 현재 계정으로 로그인할 수 없습니다." +
												"</p>" +
												"</div>",
											confirmText: "회원탈퇴",
											onConfirm: function () {
												$.ajax({
													url: "/user/settings/delete.dox",
													type: "POST",
													dataType: "json",
													data: {},
													success: function (data) {
														if (data.result === "success") {
															self.showToast(data.message || "회원탈퇴가 완료되었습니다.");

															setTimeout(function () {
																location.href = "/user/login.do";
															}, 900);
														} else {
															self.showToast(data.message || "탈퇴에 실패했습니다.");
														}
													},
													error: function () {
														self.showToast("서버 오류가 발생했습니다.");
													}
												});
											}
										});
									}
								});
							},
							fnRemoveReview: function (reviewId) {
								let self = this;

								self.fnOpenModal({
									title: "리뷰를 삭제하시겠습니까?",
									message: "삭제한 리뷰는 다시 복구할 수 없습니다.",
									confirmText: "삭제",
									onConfirm: function () {
										$.ajax({
											url: "/user/review/remove.dox",
											type: "POST",
											dataType: "json",
											data: { reviewId: reviewId },
											success: function (data) {
												if (data.result === "success") {
													self.showToast("리뷰가 삭제되었습니다.");
													sessionStorage.setItem("activeTab", "reviews");

													setTimeout(function () {
														location.reload();
													}, 700);
												} else {
													self.showToast(data.message || "삭제에 실패했습니다.");
												}
											},
											error: function () {
												self.showToast("서버 오류가 발생했습니다.");
											}
										});
									}
								});
							},
							fnGetChatbotList: function () {
								let self = this;

								$.ajax({
									url: "/user/chatbot/list.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										if (data.result === "success") {
											self.chatbotList = data.list || [];
										} else {
											self.chatbotList = [];
										}
									},
									error: function () {
										self.chatbotList = [];
									}
								});
							},
							fnGoChatbotRoom: function (roomId) {
								pageChange("/chat/bot.do", { roomId: roomId });
							},
							fnGoChatbotHistory: function () {
								pageChange("/user/chatbot/history.do", {});
							},

							fnGetUserSettings: function () {
								let self = this;

								$.ajax({
									url: "/user/settings/info.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										if (data.result === "success") {

											let info = data.info || {};

											self.settingsForm.userId = info.userId || "${user.userId}";
											self.settingsForm.userName = info.userName || "";
											self.settingsForm.nickName = info.nickName || "";
											let profileImgUrl = info.profileImgUrl || "";
											profileImgUrl = String(profileImgUrl).trim();

											if (
												!profileImgUrl.startsWith("/img/profile/") &&
												!profileImgUrl.startsWith("/upload/profile/")
											) {
												profileImgUrl = "";
											}

											self.displayUser.profileImgUrl = profileImgUrl;
											self.settingsForm.email = info.email || "";
											self.settingsForm.userPhone = info.userPhone || "";
											self.settingsForm.phoneVerifyYn = info.phoneVerifyYn || "N";
											self.settingsForm.phoneVerifiedAt = info.phoneVerifiedAt || "";
											self.settingsForm.socialType = info.socialType || "";
											self.originalSettingsForm = {
												userId: self.settingsForm.userId,
												userName: self.settingsForm.userName,
												nickName: self.settingsForm.nickName,
												userPhone: self.settingsForm.userPhone
											};

											self.displayUser.userName = info.userName || "";
											self.displayUser.nickName = info.nickName || "";

											self.originalPhone = info.userPhone || "";
											self.verifiedPhone = (info.phoneVerifyYn === "Y") ? (info.userPhone || "") : "";
											self.smsAuthCode = "";

											self.fnStopSmsTimer();
											self.smsExpired = false;
											self.smsTimeLeft = 0;
											self.smsInputVisible = false;
										} else {
											self.settingsMsg = data.message || "계정정보 조회에 실패했습니다.";
											self.settingsMsgType = "error";
										}
									},
									error: function () {
										self.settingsMsg = "서버 오류가 발생했습니다.";
										self.settingsMsgType = "error";
									}
								});
							},

							fnSendSmsCode: function () {
								let self = this;
								self.settingsMsg = "";

								let phone = (self.settingsForm.userPhone || "").replace(/[^0-9]/g, "");

								if (!phone) {
									self.settingsMsg = "휴대폰 번호를 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (self.settingsForm.phoneVerifyYn === "Y" && phone === self.verifiedPhone) {
									self.settingsMsg = "이미 인증이 완료된 번호입니다.";
									self.settingsMsgType = "error";
									self.smsInputVisible = false;
									self.fnStopSmsTimer();
									self.smsTimeLeft = 0;
									self.smsExpired = false;
									return;
								}

								$.ajax({
									url: "/user/sms/send-code.dox",
									type: "POST",
									dataType: "json",
									data: {
										userName: self.settingsForm.userName,
										userPhone: phone,
										authPurpose: "USER_SETTINGS"
									},
									success: function (data) {
										if (data.result === "success") {
											self.settingsMsg = data.message || "인증번호가 발송되었습니다.";
											self.settingsMsgType = "success";
											self.smsAuthCode = "";
											self.smsInputVisible = true;
											self.fnStartSmsTimer();
										} else {
											self.settingsMsg = data.message || "인증번호 발송에 실패했습니다.";
											self.settingsMsgType = "error";
										}
									},
									error: function () {
										self.settingsMsg = "서버 오류가 발생했습니다.";
										self.settingsMsgType = "error";
									}
								});
							},
							fnStartSmsTimer: function () {
								let self = this;

								self.fnStopSmsTimer();
								self.smsTimeLeft = 180; // 3분
								self.smsExpired = false;

								self.smsTimer = setInterval(function () {
									if (self.smsTimeLeft > 0) {
										self.smsTimeLeft--;
									} else {
										self.fnStopSmsTimer();
										self.smsExpired = true;
										self.settingsMsg = "인증번호가 만료되었습니다. 다시 발급해주세요.";
										self.settingsMsgType = "error";
									}
								}, 1000);
							},
							beforeUnmount() {
								this.fnStopSmsTimer();
							},

							fnStopSmsTimer: function () {
								if (this.smsTimer) {
									clearInterval(this.smsTimer);
									this.smsTimer = null;
								}
							},

							fnHandlePhoneChanged: function () {
								let phone = (this.settingsForm.userPhone || "").replace(/[^0-9]/g, "");
								this.settingsForm.userPhone = phone;

								// 이미 인증된 번호와 같으면 인증 유지
								if (phone && phone === this.verifiedPhone) {
									this.settingsForm.phoneVerifyYn = "Y";
									this.smsAuthCode = "";
									this.smsExpired = false;
									this.fnStopSmsTimer();
									this.smsTimeLeft = 0;
									this.smsInputVisible = false;
								} else {
									// 인증된 번호와 다르면 미인증 처리
									this.settingsForm.phoneVerifyYn = "N";
									this.settingsForm.phoneVerifiedAt = "";
									this.smsAuthCode = "";
									this.smsExpired = false;
									this.fnStopSmsTimer();
									this.smsTimeLeft = 0;
									this.smsInputVisible = false;
								}

								this.fnClearSettingsMsg();
							},

							fnVerifySmsCode: function () {
								let self = this;
								self.settingsMsg = "";

								let phone = (self.settingsForm.userPhone || "").replace(/[^0-9]/g, "");
								let authCode = (self.smsAuthCode || "").trim();

								if (!phone) {
									self.settingsMsg = "휴대폰 번호를 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (!authCode) {
									self.settingsMsg = "인증번호를 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (self.smsExpired || self.smsTimeLeft <= 0) {
									self.settingsMsg = "인증번호가 만료되었습니다. 다시 발급해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								$.ajax({
									url: "/user/sms/verify-code.dox",
									type: "POST",
									dataType: "json",
									data: {
										userPhone: phone,
										authCode: authCode,
										authPurpose: "USER_SETTINGS"
									},
									success: function (data) {
										if (data.result === "success") {
											self.settingsMsg = data.message || "휴대폰 인증이 완료되었습니다.";
											self.settingsMsgType = "success";

											self.settingsForm.phoneVerifyYn = "Y";
											self.settingsForm.phoneVerifiedAt = data.phoneVerifiedAt || "";
											self.originalPhone = phone;
											self.verifiedPhone = phone;

											self.fnStopSmsTimer();
											self.smsExpired = false;
											self.smsTimeLeft = 0;
											self.smsInputVisible = false;
											self.smsAuthCode = "";
										} else {
											self.settingsMsg = data.message || "인증번호가 올바르지 않거나 만료되었습니다.";
											self.settingsMsgType = "error";
										}
									},
									error: function () {
										self.settingsMsg = "서버 오류가 발생했습니다.";
										self.settingsMsgType = "error";
									}
								});
							},
							fnSaveSettings: function () {
								let self = this;
								self.settingsMsg = "";
								self.settingsMsgType = "";

								let userId = (self.settingsForm.userId || "").trim();
								let userName = (self.settingsForm.userName || "").trim();
								let nickName = (self.settingsForm.nickName || "").trim();
								let userPhone = (self.settingsForm.userPhone || "").replace(/[^0-9]/g, "");

								if (!userId) {
									self.settingsMsg = "아이디를 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (!/^[a-zA-Z0-9_]{4,20}$/.test(userId)) {
									self.settingsMsg = "아이디는 영문, 숫자, 밑줄(_) 조합 4~20자로 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (!userName) {
									self.settingsMsg = "이름을 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (!nickName) {
									self.settingsMsg = "닉네임을 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								if (!userPhone) {
									self.settingsMsg = "연락처를 입력해주세요.";
									self.settingsMsgType = "error";
									return;
								}

								$.ajax({
									url: "/user/settings/update.dox",
									type: "POST",
									dataType: "json",
									data: {
										userId: userId,
										userName: userName,
										nickName: nickName,
										userPhone: userPhone,
										originalPhone: self.originalPhone
									},
									success: function (data) {
										if (data.result === "success") {
											self.showToast(data.message || "회원정보가 수정되었습니다.");

											self.settingsForm.userId = data.userId || userId;
											self.settingsForm.userName = userName;
											self.settingsForm.nickName = nickName;
											self.settingsForm.userPhone = userPhone;

											self.displayUser.userName = userName;
											self.displayUser.nickName = nickName;

											self.originalPhone = userPhone;
											self.verifiedPhone = userPhone;

											self.originalSettingsForm = {
												userId: self.settingsForm.userId,
												userName: self.settingsForm.userName,
												nickName: self.settingsForm.nickName,
												userPhone: self.settingsForm.userPhone
											};

											self.settingsMsg = data.message || "회원정보가 수정되었습니다.";
											self.settingsMsgType = "success";

											self.fnGetUserSettings();
										} else {
											self.settingsMsg = data.message || "저장에 실패했습니다.";
											self.settingsMsgType = "error";
										}
									},
									error: function () {
										self.settingsMsg = "서버 오류가 발생했습니다.";
										self.settingsMsgType = "error";
									}
								});
							},
							fnResetSettings: function () {
								this.settingsForm.userId = this.originalSettingsForm.userId;
								this.settingsForm.userName = this.originalSettingsForm.userName;
								this.settingsForm.nickName = this.originalSettingsForm.nickName;
								this.settingsForm.userPhone = this.originalSettingsForm.userPhone;

								this.settingsMsg = "";
								this.settingsMsgType = "";
								this.smsInputVisible = false;
								this.smsAuthCode = "";
								this.smsExpired = false;
								this.smsTimeLeft = 0;

								this.fnStopSmsTimer();
							},

							fnResetSettingsForm: function () {
								this.fnResetSettings();
							},
							fnClearSettingsMsg: function () {
								this.settingsMsg = "";
								this.settingsMsgType = "";
							},
							fnGetInquiryList: function () {
								let self = this;

								$.ajax({
									url: "/user/inquiry/list.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										if (data.result === "success") {
											self.inquiryList = (data.list || []).map(function (item) {
												item.imageList = item.imageList || [];
												return item;
											});
										} else {
											self.inquiryList = [];
										}
									},
									error: function () {
										self.inquiryList = [];
									}
								});
							},
							fnToggleInquiry: function (item) {
								let self = this;

								if (self.openInquiryId === item.inquiryId) {
									self.openInquiryId = null;
									return;
								}

								self.openInquiryId = item.inquiryId;

								// 🔥 조건 수정 (핵심)
								if (item.imageList && item.imageList.length > 0 && item._loaded) {
									return;
								}

								$.ajax({
									url: "/user/inquiry/img/list.dox",
									type: "POST",
									dataType: "json",
									data: {
										inquiryId: item.inquiryId
									},
									success: function (data) {
										if (data.result === "success") {
											item.imageList = data.list || [];
											item._loaded = true; // 🔥 추가
										}
									}
								});
							},
							fnInquiryStatusText: function (item) {
								return item.replyId ? "답변완료" : "답변대기";
							},
							fnInquiryStatusClass: function (item) {
								return item.replyId ? "answered" : "waiting";
							},
							fnEditInquiry: function (inquiryId) {
								pageChange("/user/inquiry/edit.do", { inquiryId: inquiryId });
							},

							fnDeleteInquiry: function (inquiryId) {
								let self = this;

								self.fnOpenModal({
									title: "문의글을 삭제하시겠습니까?",
									message: "삭제한 문의는 다시 복구할 수 없습니다.",
									confirmText: "삭제",
									onConfirm: function () {
										$.ajax({
											url: "/user/inquiry/remove.dox",
											type: "POST",
											dataType: "json",
											data: { inquiryId: inquiryId },
											success: function (data) {
												if (data.result === "success") {
													self.showToast("문의가 삭제되었습니다.");
													self.fnGetInquiryList();
													self.openInquiryId = null;
												} else {
													self.showToast(data.message || "삭제에 실패했습니다.");
												}
											},
											error: function () {
												self.showToast("서버 오류가 발생했습니다.");
											}
										});
									}
								});
							},
							fnGoBenefitHistory: function () {
								pageChange("/user/benefit/history.do", {});
							},
							fnTriggerProfileFile: function () {
								this.$refs.profileFileInput.click();
							},
							fnDeleteProfile: function () {
								let self = this;
								self.fnOpenModal({
									title: "프로필 사진을 삭제하시겠습니까?",
									message: "삭제한 프로필 사진은 다시 복구할 수 없습니다.",
									confirmText: "삭제",
									onConfirm: function () {
										$.ajax({
											url: "/user/profile/delete.dox",
											type: "POST",
											dataType: "json",
											data: {},
											success: function (data) {
												if (data.result === "success") {
													self.displayUser.profileImgUrl = "";
													self.$refs.profileFileInput.value = "";
													self.showToast("프로필 사진이 삭제되었습니다.");

													setTimeout(function () {
														location.reload();
													}, 700);
												} else {
													self.showToast(data.message || "삭제에 실패했습니다.");
												}
											},
											error: function () {
												self.showToast("서버 오류가 발생했습니다.");
											}
										});
									}
								});
							},

							fnProfileImageChange: function (event) {
								let self = this;
								let file = event.target.files[0];

								if (!file) {
									return;
								}

								let formData = new FormData();
								formData.append("profileImage", file);

								$.ajax({
									url: "/user/profile/upload.dox",
									type: "POST",
									data: formData,
									processData: false,
									contentType: false,
									dataType: "json",
									success: function (data) {
										self.$refs.profileFileInput.value = "";

										if (data.result === "success") {
											location.href = location.pathname + "?profileRefresh=" + new Date().getTime();
										} else {
											alert(data.message || "프로필 사진 변경에 실패했습니다.");
										}
									},
									error: function () {
										self.$refs.profileFileInput.value = "";
										alert("서버 오류가 발생했습니다.");
									}
								});
							},
							fnGetChatRoomList: function () {
								let self = this;

								$.ajax({
									url: "/chat-room/rooms.dox",
									type: "POST",
									dataType: "json",
									data: {},
									success: function (data) {
										if (data.result === "success") {
											self.chatRoomList = data.list || [];
										} else {
											self.chatRoomList = [];
										}
									},
									error: function () {
										self.chatRoomList = [];
									}
								});
							},

							fnGoChatRoom: function (room) {
								const roomId = room.ROOM_ID || room.roomId;
								const otherId = room.OTHER_ID || room.otherId;

								if (!roomId) {
									this.showToast("채팅방 정보를 불러올 수 없습니다.");
									return;
								}

								location.href = "/chat-room/room.do?roomId=" + encodeURIComponent(roomId || "")
									+ "&otherId=" + encodeURIComponent(otherId || "");
							},

							fnChatInitial: function (room) {
								const name = room.OTHER_NICK || room.otherNick || room.OTHER_ID || room.otherId || "?";
								return String(name).charAt(0);
							},

							fnChatPreview: function (message) {
								if (!message) {
									return "대화를 시작해보세요";
								}

								const text = String(message).trim();

								const isImage =
									text.startsWith("/upload/") ||
									text.startsWith("/img/") ||
									text.includes("/chat/") ||
									/\.(jpg|jpeg|png|gif|webp|bmp)$/i.test(text);

								if (isImage) {
									return "사진을 보냈습니다";
								}

								return text;
							},

							fnChatTime: function (dateStr) {
								if (!dateStr) {
									return "";
								}

								const d = new Date(String(dateStr).replace(" ", "T"));
								const now = new Date();
								const diff = (now - d) / 1000;

								if (isNaN(d.getTime())) {
									return "";
								}

								if (diff < 60) {
									return "방금";
								}

								if (diff < 3600) {
									return Math.floor(diff / 60) + "분 전";
								}

								if (diff < 86400) {
									return Math.floor(diff / 3600) + "시간 전";
								}

								const mm = String(d.getMonth() + 1).padStart(2, "0");
								const dd = String(d.getDate()).padStart(2, "0");

								return mm + "/" + dd;
							},
							fnGetOrderActions: function (item) {
								const actions = [];
								const status = (item.orderStatus || "").toUpperCase();
								const type = (item.orderType || "").toUpperCase();

								actions.push("주문상세");

								if (status === "SHIPPING") {
									actions.push("배송조회");
								}

								if (type === "PURCHASE") {
									if (status === "DONE") {
										actions.push("환불 신청");
										actions.push("리뷰 작성");
									}
								}

								if (type === "RENTAL") {
									if (status === "IN_USE") {
										actions.push("반납 신청");
										actions.push("연장 신청");
									}

									if (
										status === "DONE" ||
										status === "RETURNED" ||
										status === "RETURN_COMPLETED" ||
										status === "COMPLETED"
									) {
										actions.push("리뷰 작성");
									}
								}

								return actions;
							},
							fnHandleOrderAction: function (item, action) {

								if (action === "환불 신청") {
									pageChange("/refund/request.do", {
										orderId: item.orderId
									});
									return;
								}
								if (action === "주문상세") {
									this.fnGoOrderDetail(item.orderId);
									return;
								}
								if (action === "배송조회") {
									if (!item.deliveryId) {
										alert("배송 정보가 없습니다.");
										return;
									}

									pageChange("/user/delivery/detail.do", {
										deliveryId: item.deliveryId
									});
									return;
								}

								// 수정 후 — 둘 다 연장/반납 통합 페이지로 이동
								if (action === "반납 신청") {
									location.href = "/rental/extension/main.do?tab=return";
									return;
								}

								if (action === "연장 신청") {
									location.href = "/rental/extension/main.do?tab=extension";
									return;
								}

								if (action === "리뷰 작성") {
									pageChange("/user/review/add.do", {
										orderId: item.orderId
									});
									return;
								}
							},
							fnGoTracking: function (item) {
								// trackingNo, carrierCode가 있다고 가정
								pageChange("/order/tracking.do", {
									orderId: item.orderId,
									trackingNo: item.trackingNo,
									carrierCode: item.carrierCode
								});
							},

							fnGoRefund: function (item) {
								pageChange("/refund/request.do", {
									orderId: item.orderId
								});
							},

							fnGoWriteReview: function (item) {
								pageChange("/user/review/edit.do", {
									orderId: item.orderId,
									productId: item.productId,
									itemId: item.itemId
								});
							},

							fnGoMyReview: function (item) {
								pageChange("/user/review/history.do", {
									orderId: item.orderId,
									reviewId: item.reviewId
								});
							},

							fnGoReturnRequest: function (item) {
								pageChange("/rental/return/request.do", {
									orderId: item.orderId,
									rentalId: item.rentalId
								});
							},
							fnGoMembershipInfo: function () {
								pageChange("/user/membership/info.do", {});
							},
							fnGetActionClass: function (action) {
								if (action === "환불 신청") return "refund";
								if (action === "배송조회") return "tracking";
								if (action === "반납 신청") return "return";
								if (action === "연장 신청") return "extend";
								if (action === "리뷰 작성") return "review";
								return "";
							},
							fnGoOrderDetail: function (orderId) {
								pageChange("/order/detail.do", { orderId: orderId });
							},
							fnRemoveWishlist: function (wishId) {
								let self = this;

								$.ajax({
									url: "/user/wishlist/remove.dox",
									type: "POST",
									dataType: "json",
									data: { wishId: wishId },
									success: function (data) {
										if (data.result === "success") {
											self.wishlist = self.wishlist.filter(function (wish) {
												return Number(wish.wishId) !== Number(wishId);
											});

											self.showToast("위시리스트에서 제거되었어요");
										} else {
											self.showToast(data.message || "찜 해제에 실패했습니다.");
										}
									},
									error: function () {
										self.showToast("서버 오류가 발생했습니다.");
									}
								});
							},
							fnFindWish: function (productId) {
								return this.wishlist.find(function (wish) {
									return Number(wish.productId) === Number(productId);
								});
							},
							fnBookmarkWriter: function (item) {
								return item.nickName
									|| item.nickname
									|| item.NICKNAME
									|| item.userName
									|| item.USER_NAME
									|| item.userId
									|| item.USER_ID
									|| "알 수 없음";
							},
							fnIsWished: function (productId) {
								return !!this.fnFindWish(productId);
							},

							fnToggleWishlist: function (item) {
								let self = this;

								$.ajax({
									url: "/user/wishlist/toggle.dox",
									type: "POST",
									dataType: "json",
									data: {
										productId: item.productId
									},
									success: function (data) {
										if (data.result === "success") {

											if (data.action === "added") {
												self.showToast("❤️ 위시리스트에 추가했어요! ");
											}

											if (data.action === "removed") {
												self.showToast("위시리스트에서 제거했어요");
											}

											self.fnGetWishlist();
											return;
										}

										self.showToast(data.message || "찜 처리에 실패했습니다.");
									},
									error: function () {
										self.showToast("서버 오류가 발생했습니다.");
									}
								});
							},
							fnGetCouponList: function () {
								let self = this;

								$.ajax({
									url: "/user/coupon/list.dox",
									type: "POST",
									dataType: "json",
									data: {
										page: 1,
										pageSize: 5
									},
									success: function (data) {
										if (data.result === "success") {
											self.couponList = data.list || [];
										} else {
											self.couponList = [];
										}
									},
									error: function () {
										self.couponList = [];
									}
								});
							},

							fnCouponBenefitText: function (item) {
								if (item.couponType === "AMOUNT") {
									return Number(item.discountAmt || 0).toLocaleString() + "원 할인";
								}

								if (item.couponType === "RATE") {
									let text = Number(item.discountRate || 0) + "% 할인";

									if (Number(item.maxDiscountAmt || 0) > 0) {
										text += " · 최대 " + Number(item.maxDiscountAmt).toLocaleString() + "원";
									}

									return text;
								}

								return "할인 쿠폰";
							},

							fnCouponConditionText: function (item) {
								if (Number(item.minOrderAmt || 0) > 0) {
									return "최소 주문금액 " + Number(item.minOrderAmt).toLocaleString() + "원";
								}

								return "최소 주문금액 없이 사용 가능";
							},

							fnGetCouponActualStatus: function (item) {
								// 이미 사용한 쿠폰이면 그대로
								if (item.status === "USED") {
									return "USED";
								}

								// 만료일이 지났으면 status 값과 무관하게 만료 처리
								if (item.expiredAt) {
									const expDate = new Date(String(item.expiredAt).replace(" ", "T"));
									const now = new Date();

									if (!isNaN(expDate.getTime())) {
										expDate.setHours(23, 59, 59, 999); // 만료일 자정까지는 유효
										if (now > expDate) {
											return "EXPIRED";
										}
									}
								}

								return item.status === "EXPIRED" ? "EXPIRED" : "AVAILABLE";
							},

							fnCouponStatusText: function (item) {
								const status = this.fnGetCouponActualStatus(item);

								if (status === "AVAILABLE") return "사용 가능";
								if (status === "USED") return "사용 완료";
								if (status === "EXPIRED") return "만료됨";
								return status || "-";
							},

							fnCouponStatusClass: function (item) {
								return this.fnGetCouponActualStatus(item).toLowerCase();
							},

							fnBoardCategoryText: function (category) {
								const map = {
									FREE: "자유",
									REVIEW: "후기",
									TIP: "꿀팁",
									QNA: "Q&A"
								};

								return map[category] || category || "커뮤니티";
							},

							fnPlainText: function (text) {
								if (!text) {
									return "";
								}

								// HTML 문자열을 실제 DOM으로 변환해서 태그 제거
								const temp = document.createElement("div");
								temp.innerHTML = String(text)
									.replace(/<br\s*\/?>/gi, " ")
									.replace(/<\/p>/gi, " ");

								let plainText = temp.textContent || temp.innerText || "";

								return plainText
									.replace(/\u00a0/g, " ")
									.replace(/&nbsp;/g, " ")
									.replace(/\s+/g, " ")
									.trim();
							},

							fnBookmarkThumb: function (item) {
								return item.thumbImgUrl || "";
							},
							fnRatingWidth: function (rating) {
								const value = Number(rating || 0);

								if (value <= 0) {
									return "0%";
								}

								if (value >= 5) {
									return "100%";
								}

								return (value / 5 * 100) + "%";
							},
						}, // methods
						mounted() {
							let profileUrl = String(this.displayUser.profileImgUrl || "").trim();

							if (
								!profileUrl ||
								(
									!profileUrl.startsWith("/img/profile/") &&
									!profileUrl.startsWith("/upload/profile/")
								)
							) {
								this.displayUser.profileImgUrl = "";
							}
							let self = this;
							this.fnGetOrderList();
							this.fnGetAddressList();
							this.fnGetWishlist();
							this.fnGetRecentList();
							this.fnGetChatbotList();
							this.fnGetUserSettings();
							this.fnGetInquiryList();
							this.fnGetCouponList();
							this.fnGetBookmarkList();
							this.fnGetChatRoomList();

							const savedTab = sessionStorage.getItem("activeTab");

							this.$nextTick(function () {
								switchTab(savedTab || "orders", null);

								this.showDeleteModal = false;
								this.deleteTargetId = null;
							});
						}
					});

					app.mount('#app');
				</script>