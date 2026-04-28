<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

			<!DOCTYPE html>
			<html lang="ko">

			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<title>공지사항 상세 - 모닥모닥</title>

				<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
				<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-detail.css">
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
			</head>

			<body>

				<%@ include file="/WEB-INF/common/header.jsp" %>

					<div class="notice-detail-page">

						<section class="detail-hero">
							<div class="detail-inner">
								<div class="detail-hero-box">
									<div>
										<div class="page-kicker">MODAK NOTICE</div>
										<h1 class="page-title">공지사항</h1>
										<p class="page-desc">모닥모닥의 서비스 안내, 점검, 이벤트 소식을 확인하세요.</p>
									</div>

								</div>
							</div>
						</section>

						<main class="detail-main">
							<div class="detail-inner">

								<c:choose>
									<c:when test="${not empty noti}">

										<article class="detail-card">

											<header class="article-head">
												<div class="article-meta-top">
													<span class="type-badge">${typeLabel}</span>
													<span class="notice-date">${fn:substring(noti.createdAt, 0,
														10)}</span>
												</div>

												<h2 class="article-title">
													<c:out value="${noti.title}" />
												</h2>

												<div class="article-info">
													<div class="info-item">
														<span>카테고리</span>
														<strong>${typeLabel}</strong>
													</div>
													<div class="info-item">
														<span>등록일자</span>
														<strong>${fn:substring(noti.createdAt, 0, 10)}</strong>
													</div>
													<div class="info-item">
														<span>조회수</span>
														<strong>${noti.viewCount}</strong>
													</div>

													<button type="button" class="print-btn" onclick="window.print()">
														인쇄하기
													</button>
												</div>
											</header>

											<div class="article-body">
												<p class="article-text">
													<c:out value="${noti.content}" />
												</p>
											</div>

										</article>

										<section class="article-nav">
											<c:choose>
												<c:when test="${not empty prevNoti}">
													<div class="nav-row"
														onclick="location.href='${pageContext.request.contextPath}/notification/detail.do?notificationId=${prevNoti.notificationId}'">
														<div class="nav-label">이전 글</div>
														<div class="nav-title">
															<c:out value="${prevNoti.title}" />
														</div>
														<div class="nav-date">${fn:substring(prevNoti.createdAt, 0, 10)}
														</div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="nav-row nav-disabled">
														<div class="nav-label">이전 글</div>
														<div class="nav-title">이전 글이 없습니다.</div>
														<div class="nav-date"></div>
													</div>
												</c:otherwise>
											</c:choose>

											<c:choose>
												<c:when test="${not empty nextNoti}">
													<div class="nav-row"
														onclick="location.href='${pageContext.request.contextPath}/notification/detail.do?notificationId=${nextNoti.notificationId}'">
														<div class="nav-label">다음 글</div>
														<div class="nav-title">
															<c:out value="${nextNoti.title}" />
														</div>
														<div class="nav-date">${fn:substring(nextNoti.createdAt, 0, 10)}
														</div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="nav-row nav-disabled">
														<div class="nav-label">다음 글</div>
														<div class="nav-title">다음 글이 없습니다.</div>
														<div class="nav-date"></div>
													</div>
												</c:otherwise>
											</c:choose>
										</section>

									</c:when>

									<c:otherwise>
										<div class="detail-card empty-card">
											<div class="empty-title">존재하지 않거나 삭제된 공지사항입니다.</div>
											<div class="empty-desc">목록으로 돌아가 다른 공지사항을 확인해 주세요.</div>
										</div>
									</c:otherwise>
								</c:choose>

								<div class="bottom-actions">
									<button type="button" class="back-btn"
										onclick="location.href='${pageContext.request.contextPath}/notification/list.do'">
										목록으로
									</button>
								</div>

							</div>
						</main>

					</div>

					<%@ include file="/WEB-INF/common/footer.jsp" %>

			</body>

			</html>