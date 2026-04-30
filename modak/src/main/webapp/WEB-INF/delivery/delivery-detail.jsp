<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<title>배송조회</title>
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/delivery/delivery-detail.css">
		</head>

		<body>
			<%@ include file="/WEB-INF/common/header.jsp" %>
				<div id="app">

					<div class="delivery-page">

						<div class="delivery-top">
							<div>
								<p class="delivery-sub-title">주문번호 #${delivery.orderId}</p>
								<h2 class="delivery-title">배송조회</h2>
							</div>
							<div class="delivery-badge ${delivery.returnFlow ? 'return' : 'normal'}">
								${delivery.statusLabel}
							</div>
						</div>

						<div class="delivery-status-card">
							<p class="status-main">${delivery.statusLabel}</p>
							<p class="status-desc">${delivery.statusMessage}</p>

							<c:choose>
								<c:when test="${delivery.returnFlow}">
									<div class="progress-area">
										<div class="progress-line">
											<div class="progress-fill" style="width:${delivery.progressPercent}%;">
											</div>
										</div>

										<div class="step-list step-list-3">
											<div class="step ${delivery.stepNo >= 1 ? 'active' : ''}">
												<div class="circle">1</div>
												<p>반품 신청</p>
											</div>
											<div class="step ${delivery.stepNo >= 2 ? 'active' : ''}">
												<div class="circle">2</div>
												<p>회수 완료</p>
											</div>
											<div class="step ${delivery.stepNo >= 3 ? 'active' : ''}">
												<div class="circle">3</div>
												<p>반품 완료</p>
											</div>
										</div>
									</div>
								</c:when>

								<c:otherwise>
									<div class="progress-area">
										<div class="progress-line">
											<div class="progress-fill" style="width:${delivery.progressPercent}%;">
											</div>
										</div>

										<div class="step-list step-list-4">
											<div class="step ${delivery.stepNo >= 1 ? 'active' : ''}">
												<div class="circle">1</div>
												<p>준비중</p>
											</div>

											<div class="step ${delivery.stepNo >= 2 ? 'active' : ''}">
												<div class="circle">2</div>
												<p>출고완료</p>
											</div>

											<div class="step ${delivery.stepNo >= 3 ? 'active' : ''}">
												<div class="circle">3</div>
												<p>배송중</p>
											</div>

											<div class="step ${delivery.stepNo >= 4 ? 'active' : ''}">
												<div class="circle">4</div>
												<p>배송완료</p>
											</div>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>

						<div class="delivery-info-grid">
							<div class="info-card">
								<h3>배송 정보</h3>
								<table class="info-table">
									<tr>
										<th>주문유형</th>
										<td>${delivery.orderTypeLabel}</td>
									</tr>
									<tr>
										<th>주문상태</th>
										<td>${delivery.orderStatusLabel}</td>
									</tr>
									<tr>
										<th>택배사명</th>
										<td>${delivery.carrierName}</td>
									</tr>
									<tr>
										<th>주소</th>
										<td>${delivery.displayAddress}</td>
									</tr>
									<tr>
										<th>배송완료일시</th>
										<td>${delivery.deliveredAtLabel}</td>
									</tr>
								</table>
							</div>

							<div class="info-card">
								<h3>주문 상품</h3>

								<c:choose>
									<c:when test="${not empty delivery.itemList}">
										<div class="item-list">
											<c:forEach var="item" items="${delivery.itemList}">
												<div class="item-row item-row-detail"
													onclick="location.href='/product/detail.do?productId=${item.productId}'">
													<div class="item-thumb">
														<c:choose>
															<c:when test="${not empty item.imgUrl}">
																<img src="${item.imgUrl}" alt="${item.productName}">
															</c:when>
															<c:otherwise>
																<span>상품</span>
															</c:otherwise>
														</c:choose>
													</div>

													<div class="item-content">
														<div class="item-tags">
															<span>
																<c:choose>
																	<c:when test="${item.productType eq 'RENTAL'}">대여
																	</c:when>
																	<c:when test="${item.productType eq 'PURCHASE'}">구매
																	</c:when>
																	<c:otherwise>${item.productType}</c:otherwise>
																</c:choose>
															</span>
														</div>
														<p class="item-name">
															${item.productName}

															<c:if test="${not empty item.brandName}">
																<span class="name-divider">·</span>
																<span class="brand-name">${item.brandName}</span>
															</c:if>
														</p>

														<p class="item-meta">
															수량 ${item.quantity}개 · ${item.unitPrice}원
														</p>

														<c:if
															test="${not empty item.startDate or not empty item.endDate}">
															<p class="item-date">대여기간 : ${item.startDate} ~
																${item.endDate}</p>
														</c:if>
													</div>
												</div>
											</c:forEach>
										</div>
									</c:when>
									<c:otherwise>
										<p class="empty-text">주문 상품 정보가 없습니다.</p>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="tracking-card">
							<div class="tracking-header">
								<h3>실시간 배송추적</h3>

								<c:if test="${not empty delivery 
                     and not empty delivery.trackingResult 
                     and not empty delivery.trackingResult.trackingLinkUrl}">
									<a class="tracking-link-btn" href="${delivery.trackingResult.trackingLinkUrl}"
										target="_blank">
										공식 배송조회
									</a>
								</c:if>
							</div>

							<c:choose>
								<c:when test="${not empty delivery 
                       and not empty delivery.trackingResult 
                       and delivery.trackingResult.success}">

									<div class="tracking-summary">
										<p class="tracking-summary-title">
											<c:out value="${delivery.trackingResult.lastStatus}" default="배송 상태 확인중" />
										</p>

										<p class="tracking-summary-desc">
											<c:choose>
												<c:when test="${not empty delivery.trackingResult.lastLocation 
                                       and not empty delivery.trackingResult.lastDescription}">
													<c:out value="${delivery.trackingResult.lastLocation}" /> ·
													<c:out value="${delivery.trackingResult.lastDescription}" />
												</c:when>

												<c:when test="${not empty delivery.trackingResult.lastLocation}">
													<c:out value="${delivery.trackingResult.lastLocation}" />
												</c:when>

												<c:when test="${not empty delivery.trackingResult.lastDescription}">
													<c:out value="${delivery.trackingResult.lastDescription}" />
												</c:when>

												<c:otherwise>
													배송 상세 정보가 없습니다.
												</c:otherwise>
											</c:choose>
										</p>

										<p class="tracking-summary-time">
											<c:out value="${delivery.trackingResult.lastTime}" default="" />
										</p>
									</div>

									<c:choose>
										<c:when test="${not empty delivery.trackingResult.eventList}">
											<div class="tracking-timeline">
												<c:forEach var="event" items="${delivery.trackingResult.eventList}">
													<div class="timeline-item">
														<div class="timeline-dot"></div>

														<div class="timeline-content">
															<p class="timeline-status">
																<c:out value="${event.status}" default="상태 확인중" />
															</p>

															<p class="timeline-meta">
																<c:choose>
																	<c:when test="${not empty event.location 
                                                           and not empty event.description}">
																		<c:out value="${event.location}" /> ·
																		<c:out value="${event.description}" />
																	</c:when>

																	<c:when test="${not empty event.location}">
																		<c:out value="${event.location}" />
																	</c:when>

																	<c:when test="${not empty event.description}">
																		<c:out value="${event.description}" />
																	</c:when>

																	<c:otherwise>
																		상세 정보 없음
																	</c:otherwise>
																</c:choose>
															</p>

															<p class="timeline-time">
																<c:out value="${event.time}" default="" />
															</p>
														</div>
													</div>
												</c:forEach>
											</div>
										</c:when>

										<c:otherwise>
											<div class="tracking-empty">
												<p>배송 이벤트 정보가 없습니다.</p>
											</div>
										</c:otherwise>
									</c:choose>
								</c:when>

								<c:otherwise>
									<div class="tracking-empty">
										<p>
											<c:choose>
												<c:when test="${not empty delivery 
                                       and not empty delivery.trackingResult 
                                       and not empty delivery.trackingResult.errorMessage}">
													<c:out value="${delivery.trackingResult.errorMessage}" />
												</c:when>
												<c:otherwise>
													실시간 배송추적 정보를 불러오지 못했습니다.
												</c:otherwise>
											</c:choose>
										</p>
									</div>
								</c:otherwise>
							</c:choose>
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

					};
				},
				methods: {
					fnGetRecentList: function (moveTop = false) {
						let self = this;

						$.ajax({
							url: "/user/recent/list.dox",
							type: "POST",
							dataType: "json",
							data: {
								page: self.page,
								pageSize: self.pageSize
							},
							success: function (data) {
							},
							error: function () {
							}
						});
					},

				},
				mounted() {
				}
			});

			app.mount("#app");
		</script>