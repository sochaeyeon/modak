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
							data: { eventId: eventId },
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
					/* ── 상세 HTML 렌더링 ─────────────────────────────── */
					/* ── 상세 HTML 렌더링 ─────────────────────────────── */
					/* ── 상세 HTML 렌더링 ─────────────────────────────── */
					function renderDetail(ev) {
						// 1. 콘솔에서 ev.imgPath가 출력되는지 꼭 확인하세요!
						console.log("DB에서 넘어온 실제 데이터:", ev);

						var now = new Date();
						var endDate = new Date(ev.endDate);
						var isEnded = endDate < now;

						var badgeClass = isEnded ? 'badge-ended' : 'badge-ongoing';
						var badgeText = isEnded ? '종료된 이벤트' : '진행중인 이벤트';

						$('#bcTitle').text(ev.title || ev.TITLE);

						// 2. DB 경로 매핑 (대소문자 완벽 대응)
						var dbPath = ev.imgPath || ev.IMGPATH || ev.img_path;
						var contextPath = '${pageContext.request.contextPath}';

						var finalImgSrc = "";
						if (dbPath) {
							// DB에 데이터가 있으면 해당 경로 사용
							finalImgSrc = contextPath + dbPath;
						} else {
							// DB에 정말 없을 때만 대체 이미지 (이미지 폴더에 실제 있는 파일명으로!)
							finalImgSrc = contextPath + '/img/event/fireEvent.png';
						}

						var html = '<div class="detail-card">'
							+ '<div class="detail-image">'
							+ '<span class="detail-badge ' + badgeClass + '">' + badgeText + '</span>'
							// 🖼️ DB에서 가져온 주소 적용
							+ '<img src="' + finalImgSrc + '" '
							+ '     onerror="this.src=\'' + contextPath + '/img/event/fireEvent.png\'" '
							+ '     style="width:100%; max-height:500px; object-fit:cover; border-radius:12px 12px 0 0;">'
							+ '</div>'
							+ '<div class="detail-body">'
							+ '<div class="detail-meta">'
							+ '<span class="meta-date">📅 ' + (ev.startDate || ev.START_DATE) + ' ~ ' + (ev.endDate || ev.END_DATE) + '</span>'
							+ '</div>'
							+ '<h1 class="detail-title">' + esc(ev.title || ev.TITLE) + '</h1>'
							+ '<div class="detail-divider"></div>'
							// white-space: pre-wrap으로 본문 줄바꿈 유지
							+ '<div class="detail-content" style="white-space:pre-wrap; line-height:1.8; color:#333;">' + (ev.content || ev.CONTENT) + '</div>'
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