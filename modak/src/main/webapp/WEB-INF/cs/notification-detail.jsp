<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
			<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
			<!DOCTYPE html>
			<html lang="ko">

			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<title>공지사항 상세 - 모닥모닥</title>
				<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/notification-detail.css">
			</head>

			<body>

				<%@ include file="/WEB-INF/common/header.jsp" %>

					<div class="browser-bar">
						<div class="b-dots">
							<div class="b-dot"></div>
							<div class="b-dot"></div>
							<div class="b-dot"></div>
						</div>

						<div class="page">
							<div class="content">

								<!-- BREADCRUMB -->
								<div class="breadcrumb">
									<a href="${pageContext.request.contextPath}/">홈</a>
									<span>›</span>
									<a href="${pageContext.request.contextPath}/cs/center.do">고객센터</a>
									<span>›</span>
									<a href="${pageContext.request.contextPath}/notification/list.do">공지사항</a>
									<span>›</span>
									<span class="cur">상세</span>
								</div>

								<div class="page-title">공지사항</div>
								<div class="page-desc">서비스 관련 안내 및 업데이트 소식을 확인하세요.</div>

								<c:choose>
									<c:when test="${not empty noti}">

										<!-- ARTICLE HEADER -->
										<div class="article-header">
											<div class="ah-badges">
												<span class="ah-badge">${typeLabel}</span>
											</div>
											<div class="ah-title">
												<c:out value="${noti.title}" />
											</div>
										</div>

										<!-- META ROW -->
										<div class="meta-row">
											<div class="meta-left">
												<div class="meta-item"><strong>카테고리</strong>&nbsp;${typeLabel}</div>
												<div class="meta-item">
													<strong>등록일자</strong>&nbsp;${fn:substring(noti.createdAt, 0, 10)}
												</div>
												<div class="meta-item"><strong>조회수</strong>&nbsp;${noti.viewCount}</div>
											</div>
											<div class="meta-actions">
												<button class="meta-btn" onclick="window.print()">인쇄하기</button>
											</div>
										</div>

										<!-- ARTICLE BODY -->
										<div class="article-body">
											<div class="a-section">
												<p class="a-text" style="white-space:pre-line;">
													<c:out value="${noti.content}" />
												</p>
											</div>
										</div>

										<!-- PREV / NEXT NAV -->
										<div class="article-nav">
											<c:choose>
												<c:when test="${not empty prevNoti}">
													<div class="nav-row"
														onclick="location.href='${pageContext.request.contextPath}/notification/detail.do?notificationId=${prevNoti.notificationId}'"
														style="cursor:pointer;">
														<span class="nav-label">이전 글</span>
														<span class="nav-arrow">∧</span>
														<span class="nav-title">
															<c:out value="${prevNoti.title}" />
														</span>
														<span class="nav-date">${fn:substring(prevNoti.createdAt, 0,
															10)}</span>
													</div>
												</c:when>
												<c:otherwise>
													<div class="nav-row nav-disabled">
														<span class="nav-label">이전 글</span>
														<span class="nav-arrow">∧</span>
														<span class="nav-title" style="color:#bbb;">이전 글이 없습니다.</span>
													</div>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${not empty nextNoti}">
													<div class="nav-row"
														onclick="location.href='${pageContext.request.contextPath}/notification/detail.do?notificationId=${nextNoti.notificationId}'"
														style="cursor:pointer;">
														<span class="nav-label">다음 글</span>
														<span class="nav-arrow">∨</span>
														<span class="nav-title">
															<c:out value="${nextNoti.title}" />
														</span>
														<span class="nav-date">${fn:substring(nextNoti.createdAt, 0,
															10)}</span>
													</div>
												</c:when>
												<c:otherwise>
													<div class="nav-row nav-disabled">
														<span class="nav-label">다음 글</span>
														<span class="nav-arrow">∨</span>
														<span class="nav-title" style="color:#bbb;">다음 글이 없습니다.</span>
													</div>
												</c:otherwise>
											</c:choose>
										</div>

									</c:when>
									<c:otherwise>
										<div style="text-align:center;padding:60px;color:#999;">
											존재하지 않거나 삭제된 공지사항입니다.
										</div>
									</c:otherwise>
								</c:choose>

								<!-- BACK BUTTON -->
								<div class="back-wrap">
									<button class="back-btn"
										onclick="location.href='${pageContext.request.contextPath}/notification/list.do'">목록으로
										↑</button>
								</div>

							</div><!-- /content -->
						</div><!-- /page -->
					</div><!-- /browser-bar -->

					<%@ include file="/WEB-INF/common/footer.jsp" %>

			</body>

			</html>