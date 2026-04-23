<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>모닥모닥 소식</title>
		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/event/event-list.css">
	</head>

	<body>

		<!-- ── Header ── -->
		<%@ include file="/WEB-INF/common/header.jsp" %>

			<!-- ── Main ── -->
			<main>
				<h1 class="page-title">모닥모닥 소식</h1>
				<p class="page-subtitle">특별한 혜택과 캠핑 소식을 가장 먼저 확인해보세요.</p>

				<!-- Tabs -->
				<div class="tabs">
					<button class="tab active" data-type="">전체</button>
					<button class="tab" data-type="ongoing">진행중인 이벤트</button>
					<button class="tab" data-type="ended">종료된 이벤트</button>
					<button class="tab" data-type="winner">당첨자 발표</button>
				</div>

				<!-- Cards -->
				<div class="cards-grid" id="cardGrid">
					<div class="state-box">
						<div class="spin"></div><span>불러오는 중...</span>
					</div>
				</div>

				<!-- Pagination -->
				<div class="pagination" id="pagination"></div>
			</main>

			<!-- Footer -->
			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					/* ════════════════════════════════════════════════════
					   상태
					════════════════════════════════════════════════════ */
					var currentTab = '';   // '' = 전체
					var currentPage = 1;
					var totalPages = 1;

					/* ════════════════════════════════════════════════════
					   fnGetList — POST /event/list.dox
					   응답: { result, list, totalCount, totalPages, currentPage }
					════════════════════════════════════════════════════ */
					function fnGetList() {
						$('#cardGrid').html('<div class="state-box"><div class="spin"></div><span>불러오는 중...</span></div>');
						$('#pagination').empty();

						$.ajax({
							url: '${pageContext.request.contextPath}/event/list.dox',
							type: 'POST',
							dataType: 'json',
							data: {
								tabType: currentTab,
								page: currentPage
							},
							success: function (data) {
								if (data.result === 'success') {
									totalPages = data.totalPages || 1;
									renderCards(data.list);
									renderPagination(data.totalPages, data.currentPage);
								} else {
									showError(data.message);
								}
							},
							error: function (xhr, status, err) {
								showError('서버 연결 오류(' + xhr.status + ')');
								console.error(err);
							}
						});
					}

					/* ════════════════════════════════════════════════════
					   카드 렌더링
					   DB 필드: eventId, title, content, startDate, endDate
					════════════════════════════════════════════════════ */
					function renderCards(list) {
						var $grid = $('#cardGrid');

						if (!list || list.length === 0) {
							$grid.html('<div class="state-box"><span>📭 등록된 이벤트가 없습니다.</span></div>');
							return;
						}

						var html = '';
						$.each(list, function (i, ev) {
							var now = new Date();
							var endDate = new Date(ev.endDate);
							var isEnded = endDate < now;
							var badgeClass, badgeText;

							if (currentTab === 'winner') {
								badgeClass = 'badge-winner'; badgeText = '당첨자 발표';
							} else if (isEnded) {
								badgeClass = 'badge-ended'; badgeText = '종료';
							} else {
								badgeClass = 'badge-ongoing'; badgeText = '진행중';
							}

							// 🖼️ 이미지 처리 로직 추가
							// DB에서 가져온 이미지 경로가 없으면 기본 '이미지 준비중' 사진이 나오게 방어 코드를 넣었습니다.
							var imgSrc = ev.img_path ? ev.img_path : '${pageContext.request.contextPath}/img/common/no-image.png';

							html += '<div class="card" onclick="goDetail(' + ev.eventId + ')">'
								+ '<div class="card-image">'
								+ '<span class="card-badge ' + badgeClass + '">' + badgeText + '</span>'
								// 👇 글자 대신 진짜 <img> 태그를 넣었습니다. 
								+ '<img src="' + imgSrc + '" alt="' + esc(ev.title) + '" style="width:100%; height:100%; object-fit:cover;">'
								+ '</div>'
								+ '<div class="card-body">'
								+ '<h3 class="card-title">' + esc(ev.title) + '</h3>'
								+ '<p class="card-desc">' + esc(ev.content) + '</p>'
								+ '<div class="card-date">' + esc(ev.startDate) + ' ~ ' + esc(ev.endDate) + '</div>'
								+ '</div>'
								+ '</div>';
						});

						$grid.html(html);
					}

					/* ════════════════════════════════════════════════════
					   페이지네이션 렌더링
					════════════════════════════════════════════════════ */
					function renderPagination(total, current) {
						var $pg = $('#pagination');
						if (total <= 1) return;

						var html = '';

						// 이전
						html += '<button class="page-btn" ' + (current <= 1 ? 'disabled' : '') + ' onclick="goPage(' + (current - 1) + ')">‹</button>';

						// 페이지 번호 (최대 5개 노출)
						var start = Math.max(1, current - 2);
						var end = Math.min(total, start + 4);
						if (end - start < 4) start = Math.max(1, end - 4);

						for (var p = start; p <= end; p++) {
							html += '<button class="page-btn ' + (p === current ? 'active' : '') + '" onclick="goPage(' + p + ')">' + p + '</button>';
						}

						// 다음
						html += '<button class="page-btn" ' + (current >= total ? 'disabled' : '') + ' onclick="goPage(' + (current + 1) + ')">›</button>';

						$pg.html(html);
					}

					/* ════════════════════════════════════════════════════
					   상세 페이지 이동 — /event/detail.do?eventId=1
					════════════════════════════════════════════════════ */
					function goDetail(eventId) {
						location.href = '${pageContext.request.contextPath}/event/detail.do?eventId=' + eventId;
					}

					/* ════════════════════════════════════════════════════
					   페이지 이동
					════════════════════════════════════════════════════ */
					function goPage(page) {
						if (page < 1 || page > totalPages) return;
						currentPage = page;
						fnGetList();
						window.scrollTo({ top: 0, behavior: 'smooth' });
					}

					/* ════════════════════════════════════════════════════
					   탭 클릭
					════════════════════════════════════════════════════ */
					$('.tabs').on('click', '.tab', function () {
						$('.tab').removeClass('active');
						$(this).addClass('active');
						currentTab = $(this).data('type');
						currentPage = 1;
						fnGetList();
					});

					/* ════════════════════════════════════════════════════
					   유틸
					════════════════════════════════════════════════════ */
					function showError(msg) {
						$('#cardGrid').html('<div class="state-box"><span>⚠️ ' + msg + '</span></div>');
					}
					function esc(str) {
						if (!str) return '';
						return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
					}

					/* ════════════════════════════════════════════════════
					   초기 실행
					════════════════════════════════════════════════════ */
					$(document).ready(function () {
						fnGetList();
					});
				</script>
	</body>

	</html>