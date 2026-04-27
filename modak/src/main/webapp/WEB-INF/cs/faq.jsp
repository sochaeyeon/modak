<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ page isELIgnored="false" deferredSyntaxAllowedAsLiteral="true" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>자주 묻는 질문 - 모닥모닥</title>
			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/faq.css">
			<link rel="stylesheet" href="/css/common/font.css">
		</head>

		<body>

			<%-- 헤더 include --%>
				<%@ include file="/WEB-INF/common/header.jsp" %>

					<div class="faq-page">

						<div class="eyebrow">FAQ</div>
						<div class="page-title">자주 묻는 질문</div>

						<!-- 검색바 -->
						<div class="search-bar">
							<input type="text" class="search-input" id="searchInput" placeholder="궁금한 내용을 검색해보세요."
								onkeydown="if(event.key==='Enter') fnSearch()">
							<button class="search-btn" onclick="fnSearch()">검색</button>
						</div>

						<div class="faq-layout">

							<!-- 사이드바 - 대분류 -->
							<div class="faq-sidebar">
								<div class="sidebar-label">분류</div>
								<ul id="sidebarList">
									<li class="active" data-cat="전체">전체</li>
									<li data-cat="대여">대여</li>
									<li data-cat="리뷰">리뷰</li>
									<li data-cat="결제">결제</li>
									<li data-cat="회원">회원</li>
									<li data-cat="캠핑장">캠핑장</li>
									<li data-cat="기타">기타</li>
								</ul>
							</div>

							<!-- 메인 - 소분류 탭 + 목록 -->
							<div class="faq-main">
								<div class="faq-tabs" id="tabList">
									<div class="faq-tab active" data-tab="전체">전체</div>
								</div>
								<div id="faqList">
									<div class="faq-loading"><span class="spin"></span>불러오는 중...</div>
								</div>
								<div id="faqPaging" style="text-align:center; margin-top:20px;"></div>
							</div>

						</div>
						<div class="faq-bottom-line"></div>
					</div>

					<%-- 푸터 include --%>
						<%@ include file="/WEB-INF/common/footer.jsp" %>

							<script>


								/* ════════════════════════════════════════════════════
								   ★ 핵심: 환경 변수 설정
								════════════════════════════════════════════════════ */
								var CTX = '<%=request.getContextPath()%>';

								/* ════════════════════════════════════════════════════
								   대분류 → 소분류 탭 매핑 데이터 (꼭 포함되어야 함!)
								════════════════════════════════════════════════════ */
								var SUB_TABS = {
									'전체': ['전체'],
									'대여': ['전체', '예약', '반납', '연장', '취소'],
									'리뷰': ['전체', '작성', '수정', '삭제'],
									'결제': ['전체', '결제수단', '환불', '영수증'],
									'회원': ['전체', '가입', '탈퇴', '정보수정', '비밀번호'],
									'캠핑장': ['전체', '시설', '예약', '이용안내'],
									'기타': ['전체']
								};


								/* ════════════════════════════════════════════════════
								   상태 변수
								════════════════════════════════════════════════════ */
								var currentCategory = '전체';
								var currentSubTab = '전체';
								var currentKeyword = '';

								/* ════════════════════════════════════════════════════
								   목록 불러오기 (Ajax)
								════════════════════════════════════════════════════ */
								/* 페이징 상태 */
								var currentPage = 1;
								var pageSize = 10;  // 한 페이지당 항목 수
								var totalList = []; // 전체 FAQ 목록 캐시


								/* 페이지 렌더링 */
								function renderPage() {
									var start = (currentPage - 1) * pageSize;
									var pageList = totalList.slice(start, start + pageSize);
									render(pageList);
									renderPaging();
								}

								/* 페이지 버튼 렌더링 */
								function renderPaging() {
									var totalPage = Math.ceil(totalList.length / pageSize);
									if (totalPage <= 1) {
										$('#faqPaging').html('');
										return;
									}
									var html = '';
									// 맨 처음
									html += '<button class="page-btn" onclick="fnChangePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>«</button>';
									// 이전
									html += '<button class="page-btn" onclick="fnChangePage(' + (currentPage - 1) + ')" ' + (currentPage === 1 ? 'disabled' : '') + '>‹</button>';
									// 페이지 번호
									for (var i = 1; i <= totalPage; i++) {
										html += '<button class="page-btn' + (i === currentPage ? ' active' : '') + '" onclick="fnChangePage(' + i + ')">' + i + '</button>';
									}
									// 다음
									html += '<button class="page-btn" onclick="fnChangePage(' + (currentPage + 1) + ')" ' + (currentPage === totalPage ? 'disabled' : '') + '>›</button>';
									// 맨 끝
									html += '<button class="page-btn" onclick="fnChangePage(' + totalPage + ')" ' + (currentPage === totalPage ? 'disabled' : '') + '>»</button>';
									$('#faqPaging').html(html);
								}

								function fnChangePage(page) {
									var totalPage = Math.ceil(totalList.length / pageSize);
									if (page < 1 || page > totalPage) return;
									currentPage = page;
									renderPage();
									$('html, body').animate({scrollTop: $('.faq-layout').offset().top - 80}, 300);
								}

								function fnGetList() {
									$('#faqList').html('<div class="faq-loading"><span class="spin"></span>불러오는 중...</div>');

									var sendCategory = '';
									var excludeCategory = '';

									if (currentCategory === '기타' && currentSubTab === '전체') {
										// 기타 > 전체: 알려진 소분류 전부 제외
										var knownSubs = [];
										$.each(SUB_TABS, function (cat, tabs) {
											if (cat !== '전체' && cat !== '기타') {
												$.each(tabs, function (i, tab) {
													if (tab !== '전체' && $.inArray(tab, knownSubs) === -1) {
														knownSubs.push(tab);
													}
												});
											}
										});
										excludeCategory = knownSubs.join(',');  // 서버에 제외 목록 전송

									} else if (currentCategory !== '전체') {
										if (currentSubTab !== '전체') {
											sendCategory = currentSubTab;
										} else {
											var subTabs = SUB_TABS[currentCategory] || [];
											var subs = subTabs.filter(function (t) {return t !== '전체';});
											sendCategory = subs.join(',');
										}
									}

									$.ajax({
										url: CTX + '/faq.dox',
										type: 'POST',
										dataType: 'json',
										data: {
											category: sendCategory,
											excludeCategory: excludeCategory,  // 추가
											searchKeyword: currentKeyword
										},
										success: function (data) {
											if (data.result === 'success') {
												totalList = data.list || [];
												currentPage = 1;
												renderPage();
											} else {
												showError(data.message || '데이터를 불러오지 못했습니다.');
											}
										},
										error: function (xhr, status, err) {
											showError('서버 연결 오류 (' + xhr.status + ')');
										}
									});
								}
								/* ════════════════════════════════════════════════════
								   소분류 탭 렌더링
								════════════════════════════════════════════════════ */
								function renderSubTabs(mainCat) {
									var tabs = SUB_TABS[mainCat] || ['전체'];
									var html = '';
									$.each(tabs, function (i, tab) {
										var cls = (i === 0) ? 'faq-tab active' : 'faq-tab';
										html += '<div class="' + cls + '" data-tab="' + tab + '">' + tab + '</div>';
									});
									$('#tabList').html(html);
									currentSubTab = '전체';
								}

								/* ════════════════════════════════════════════════════
								   FAQ 목록 렌더링
								════════════════════════════════════════════════════ */
								function render(list) {
									var $wrap = $('#faqList');
									if (!list || list.length === 0) {
										$wrap.html('<div class="faq-empty">📭 등록된 FAQ가 없습니다.</div>');
										return;
									}
									var html = '';
									$.each(list, function (i, f) {
										html += '<div class="faq-item" data-id="' + f.faqId + '">'
											+ '<div class="faq-question">'
											+ '<span class="q-text">' + esc(f.question) + '</span>'
											+ '<span class="q-arrow">›</span>'
											+ '</div>'
											+ '<div class="faq-answer">'
											+ '<div class="faq-answer-inner">' + esc(f.answer) + '</div>'
											+ '</div>'
											+ '</div>';
									});
									$wrap.html(html);

									$wrap.find('.faq-question').on('click', function () {
										var $item = $(this).closest('.faq-item');
										var wasOpen = $item.hasClass('open');
										$(this).closest('.faq-item').toggleClass('open');
										if (!wasOpen) $item.addClass('open');
									});
								}

								/* ════════════════════════════════════════════════════
								   검색 및 클릭 이벤트
								════════════════════════════════════════════════════ */
								function fnSearch() {
									currentKeyword = $('#searchInput').val().trim();
									currentCategory = '전체';
									currentSubTab = '전체';
									$('#sidebarList li').removeClass('active');
									$('#sidebarList li[data-cat="전체"]').addClass('active');
									renderSubTabs('전체');
									fnGetList();
								}

								$('#sidebarList').on('click', 'li', function () {
									$('#sidebarList li').removeClass('active');
									$(this).addClass('active');
									currentCategory = $(this).data('cat');
									currentKeyword = '';
									$('#searchInput').val('');
									renderSubTabs(currentCategory);
									fnGetList();
								});

								$('#tabList').on('click', '.faq-tab', function () {
									$('#tabList .faq-tab').removeClass('active');
									$(this).addClass('active');
									currentSubTab = $(this).data('tab');
									currentKeyword = '';
									$('#searchInput').val('');
									fnGetList();
								});

								function showError(msg) {
									$('#faqList').html('<div class="faq-error">⚠️ ' + msg + '</div>');
								}

								function esc(str) {
									if (!str) return '';
									return String(str)
										.replace(/&/g, '&amp;').replace(/</g, '&lt;')
										.replace(/>/g, '&gt;').replace(/"/g, '&quot;');
								}

								$(document).ready(function () {
									fnGetList();
								});
							</script>