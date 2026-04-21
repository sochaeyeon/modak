<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>이벤트 상세 - 모닥모닥</title>
		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/event/event-detail.css">
	</head>

	<body>

		<!-- ── Header ── -->
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<!-- Breadcrumb -->
			<div class="breadcrumb">
				<a href="${pageContext.request.contextPath}">홈</a>
				<span>›</span>
				<a href="${pageContext.request.contextPath}/event/list.do">이벤트</a>
				<span>›</span>
				<span class="cur" id="bcTitle">상세보기</span>
			</div>

			<!-- Main -->
			<main>
				<div id="detailWrap">
					<div class="loading-box">
						<div class="spin"></div><span>불러오는 중...</span>
					</div>
				</div>
				<a href="${pageContext.request.contextPath}/event/list.do" class="btn-back">목록으로 돌아가기</a>
			</main>

			<!-- Footer -->
			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					/* URL 파라미터에서 eventId 추출 */
					var eventId = "${map.eventId}";

					/* ── 상세 데이터 조회 ─────────────────────────────────
					   POST /event/info.dox  { eventId: N }
					   응답: { result, info: { eventId, title, content, startDate, endDate } }
					─────────────────────────────────────────────────── */
					function fnGetInfo() {
						if (!eventId) {
							$('#detailWrap').html('<div class="error-box">⚠️ 잘못된 접근입니다. eventId가 없습니다.</div>');
							return;
						}

						$.ajax({
							url: '${pageContext.request.contextPath}/event/info.dox',
							type: 'POST',
							dataType: 'json',
							data: {eventId: eventId},
							success: function (data) {
								if (data.result === 'success' && data.info) {
									renderDetail(data.info);
								} else {
									$('#detailWrap').html('<div class="error-box">⚠️ ' + (data.message || '데이터를 불러오지 못했습니다.') + '</div>');
								}
							},
							error: function (xhr, status, err) {
								$('#detailWrap').html('<div class="error-box">⚠️ 서버 연결 오류(' + xhr.status + ')</div>');
								console.error(err);
							}
						});
					}

					/* ── 상세 HTML 렌더링 ─────────────────────────────── */
					function renderDetail(ev) {
						var now = new Date();
						var endDate = new Date(ev.endDate);
						var isEnded = endDate < now;

						var badgeClass = isEnded ? 'badge-ended' : 'badge-ongoing';
						var badgeText = isEnded ? '종료된 이벤트' : '진행중인 이벤트';

						/* 브레드크럼 타이틀 업데이트 */
						$('#bcTitle').text(ev.title);
						document.title = ev.title + ' - 모닥모닥';

						var html = '<div class="detail-card">'
							+ '<div class="detail-image">'
							+ '<span class="detail-badge ' + badgeClass + '">' + badgeText + '</span>'
							+ '<div style="text-align:center">이벤트 대표 이미지 영역</div>'
							+ '</div>'
							+ '<div class="detail-body">'
							+ '<div class="detail-meta">'
							+ '<span class="meta-date">' + esc(ev.startDate) + ' ~ ' + esc(ev.endDate) + '</span>'
							+ '</div>'
							+ '<h1 class="detail-title">' + esc(ev.title) + '</h1>'
							+ '<div class="detail-divider"></div>'
							+ '<div class="detail-content">' + esc(ev.content) + '</div>'
							+ '</div>'
							+ '</div>';

						$('#detailWrap').html(html);
					}

					/* ── 유틸 ── */
					function esc(str) {
						if (!str) return '';
						return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
					}

					/* ── 초기 실행 ── */
					$(document).ready(function () {
						fnGetInfo();
					});
				</script>
	</body>

	</html>