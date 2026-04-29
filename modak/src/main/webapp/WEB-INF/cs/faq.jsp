<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ page isELIgnored="false" deferredSyntaxAllowedAsLiteral="true" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>자주 묻는 질문 - 모닥모닥</title>

			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/faq.css">
			<link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<div class="faq-hero">
					<div class="faq-hero-inner">
						<div class="faq-hero-icon">
							<i class="ri-question-answer-line"></i>
						</div>

						<div class="faq-hero-text">
							<div class="faq-eyebrow">FAQ</div>
							<h1>자주 묻는 질문</h1>
							<p>모닥모닥 이용 중 궁금한 내용을 빠르게 찾아보세요.</p>
						</div>

						<div class="faq-search-wrap">
							<input type="text" id="searchInput" placeholder="궁금한 내용을 검색해보세요"
								onkeydown="if(event.key === 'Enter') fnSearch()">
							<button type="button" onclick="fnSearch()">검색</button>
						</div>

						<div class="faq-quick-links">
							<a href="${pageContext.request.contextPath}/notification/list.do">공지사항</a>
							<span></span>
							<a href="${pageContext.request.contextPath}/inquiry.do">1:1 문의</a>
							<span></span>
							<a href="${pageContext.request.contextPath}/chat/bot.do">챗봇 상담</a>
						</div>
					</div>
				</div>

				<main class="faq-page">

					<section class="faq-content-card">

						<div class="faq-section-header">
							<div>
								<div class="section-eyebrow">HELP LIST</div>
								<h2>FAQ 목록</h2>
							</div>

							<button type="button" class="reset-btn" onclick="fnResetFaq()">
								<i class="ri-refresh-line"></i>
								초기화
							</button>
						</div>

						<div class="faq-layout">

							<aside class="faq-sidebar">
								<div class="sidebar-title">분류</div>
								<ul id="sidebarList">
									<li class="active" data-cat="전체"><i class="ri-apps-line"></i>전체</li>
									<li data-cat="대여"><i class="ri-calendar-check-line"></i>대여</li>
									<li data-cat="리뷰"><i class="ri-star-line"></i>리뷰</li>
									<li data-cat="결제"><i class="ri-bank-card-line"></i>결제</li>
									<li data-cat="회원"><i class="ri-user-line"></i>회원</li>
									<li data-cat="캠핑장"><i class="ri-map-pin-line"></i>캠핑장</li>
									<li data-cat="기타"><i class="ri-more-line"></i>기타</li>
								</ul>
							</aside>

							<div class="faq-main">
								<div class="faq-tabs" id="tabList">
									<div class="faq-tab active" data-tab="전체">전체</div>
								</div>

								<div class="faq-result-info" id="faqResultInfo">
									전체 FAQ를 확인하고 있어요.
								</div>

								<div id="faqList">
									<div class="faq-loading">
										<span class="spin"></span>
										불러오는 중...
									</div>
								</div>

								<div id="faqPaging"></div>
							</div>

						</div>
					</section>

					<section class="faq-help-box">
						<div>
							<strong>원하는 답변을 찾지 못했나요?</strong>
							<p>1:1 문의를 남겨주시면 확인 후 답변드릴게요.</p>
						</div>
						<button type="button" onclick="location.href='${pageContext.request.contextPath}/inquiry.do'">
							문의하기
						</button>
					</section>

				</main>

				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<script>
						var CTX = '<%=request.getContextPath()%>';

						var SUB_TABS = {
							'전체': ['전체'],
							'대여': ['전체', '예약', '반납', '연장', '취소'],
							'리뷰': ['전체', '작성', '수정', '삭제'],
							'결제': ['전체', '결제수단', '환불', '영수증'],
							'회원': ['전체', '가입', '탈퇴', '정보수정', '비밀번호'],
							'캠핑장': ['전체', '시설', '예약', '이용안내'],
							'기타': ['전체']
						};

						var currentCategory = '전체';
						var currentSubTab = '전체';
						var currentKeyword = '';

						var currentPage = 1;
						var pageSize = 10;
						var totalList = [];

						$(document).ready(function () {
							fnGetList();

							$('#sidebarList').on('click', 'li', function () {
								$('#sidebarList li').removeClass('active');
								$(this).addClass('active');

								currentCategory = $(this).data('cat');
								currentSubTab = '전체';
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

							$('.summary-card').on('click', function () {
								var cat = $(this).data('cat');

								$('#sidebarList li').removeClass('active');
								$('#sidebarList li[data-cat="' + cat + '"]').addClass('active');

								currentCategory = cat;
								currentSubTab = '전체';
								currentKeyword = '';

								$('#searchInput').val('');
								renderSubTabs(cat);
								fnGetList();

								$('html, body').animate({
									scrollTop: $('.faq-content-card').offset().top - 80
								}, 250);
							});
						});

						function fnGetList() {
							$('#faqList').html('<div class="faq-loading"><span class="spin"></span>불러오는 중...</div>');
							$('#faqPaging').html('');

							var sendCategory = '';
							var excludeCategory = '';

							if (currentCategory === '기타' && currentSubTab === '전체') {
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

								excludeCategory = knownSubs.join(',');

							} else if (currentCategory !== '전체') {
								if (currentSubTab !== '전체') {
									sendCategory = currentSubTab;
								} else {
									var subTabs = SUB_TABS[currentCategory] || [];
									var subs = subTabs.filter(function (t) {
										return t !== '전체';
									});
									sendCategory = subs.join(',');
								}
							}

							$.ajax({
								url: CTX + '/faq.dox',
								type: 'POST',
								dataType: 'json',
								data: {
									category: sendCategory,
									excludeCategory: excludeCategory,
									searchKeyword: currentKeyword
								},
								success: function (data) {
									if (data.result === 'success') {
										totalList = data.list || [];
										currentPage = 1;
										renderPage();
										renderResultInfo();
									} else {
										showError(data.message || '데이터를 불러오지 못했습니다.');
									}
								},
								error: function (xhr) {
									showError('서버 연결 오류 (' + xhr.status + ')');
								}
							});
						}

						function renderSubTabs(mainCat) {
							var tabs = SUB_TABS[mainCat] || ['전체'];
							var html = '';

							$.each(tabs, function (i, tab) {
								html += '<div class="faq-tab' + (i === 0 ? ' active' : '') + '" data-tab="' + tab + '">' + tab + '</div>';
							});

							$('#tabList').html(html);
							currentSubTab = '전체';
						}

						function renderPage() {
							var start = (currentPage - 1) * pageSize;
							var pageList = totalList.slice(start, start + pageSize);

							renderFaqList(pageList);
							renderPaging();
						}

						function renderFaqList(list) {
							var $wrap = $('#faqList');

							if (!list || list.length === 0) {
								$wrap.html(
									'<div class="faq-empty">' +
									'<i class="ri-inbox-line"></i>' +
									'<strong>등록된 FAQ가 없습니다.</strong>' +
									'<p>다른 분류를 선택하거나 검색어를 변경해보세요.</p>' +
									'</div>'
								);
								return;
							}

							var html = '';

							$.each(list, function (i, f) {
								html += ''
									+ '<div class="faq-item" data-id="' + esc(f.faqId) + '">'
									+ '	<div class="faq-question">'
									+ '		<div class="q-left">'
									+ '			<span class="q-badge">Q</span>'
									+ '			<span class="q-text">' + esc(f.question) + '</span>'
									+ '		</div>'
									+ '		<span class="q-arrow"><i class="ri-arrow-down-s-line"></i></span>'
									+ '	</div>'
									+ '	<div class="faq-answer" style="display:none;">'
									+ '		<div class="faq-answer-inner">'
									+ '			<span class="a-badge">A</span>'
									+ '			<div class="a-text">' + esc(f.answer) + '</div>'
									+ '		</div>'
									+ '	</div>'
									+ '</div>';
							});

							$wrap.html(html);

							$wrap.find('.faq-question').off('click').on('click', function () {
								var $item = $(this).closest('.faq-item');
								var $answer = $item.find('.faq-answer');

								if ($item.hasClass('open')) {
									$item.removeClass('open');
									$answer.stop(true, true).slideUp(160);
								} else {
									$item.addClass('open');
									$answer.stop(true, true).slideDown(160);
								}
							});
						}

						function renderPaging() {
							var totalPage = Math.ceil(totalList.length / pageSize);

							if (totalPage <= 1) {
								$('#faqPaging').html('');
								return;
							}

							var html = '';

							html += '<button class="page-btn" onclick="fnChangePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '><i class="ri-skip-left-line"></i></button>';
							html += '<button class="page-btn" onclick="fnChangePage(' + (currentPage - 1) + ')" ' + (currentPage === 1 ? 'disabled' : '') + '><i class="ri-arrow-left-s-line"></i></button>';

							for (var i = 1; i <= totalPage; i++) {
								html += '<button class="page-btn' + (i === currentPage ? ' active' : '') + '" onclick="fnChangePage(' + i + ')">' + i + '</button>';
							}

							html += '<button class="page-btn" onclick="fnChangePage(' + (currentPage + 1) + ')" ' + (currentPage === totalPage ? 'disabled' : '') + '><i class="ri-arrow-right-s-line"></i></button>';
							html += '<button class="page-btn" onclick="fnChangePage(' + totalPage + ')" ' + (currentPage === totalPage ? 'disabled' : '') + '><i class="ri-skip-right-line"></i></button>';

							$('#faqPaging').html(html);
						}

						function fnChangePage(page) {
							var totalPage = Math.ceil(totalList.length / pageSize);

							if (page < 1 || page > totalPage) {
								return;
							}

							currentPage = page;
							renderPage();

							$('html, body').animate({
								scrollTop: $('.faq-content-card').offset().top - 80
							}, 250);
						}

						function fnSearch() {
							currentKeyword = $('#searchInput').val().trim();
							currentCategory = '전체';
							currentSubTab = '전체';

							$('#sidebarList li').removeClass('active');
							$('#sidebarList li[data-cat="전체"]').addClass('active');

							renderSubTabs('전체');
							fnGetList();
						}

						function fnResetFaq() {
							currentCategory = '전체';
							currentSubTab = '전체';
							currentKeyword = '';
							currentPage = 1;

							$('#searchInput').val('');
							$('#sidebarList li').removeClass('active');
							$('#sidebarList li[data-cat="전체"]').addClass('active');

							renderSubTabs('전체');
							fnGetList();
						}

						function renderResultInfo() {
							var text = '';

							if (currentKeyword) {
								text = '"' + currentKeyword + '" 검색 결과 ' + totalList.length + '개';
							} else if (currentCategory === '전체') {
								text = '전체 FAQ ' + totalList.length + '개';
							} else if (currentSubTab === '전체') {
								text = currentCategory + ' 관련 FAQ ' + totalList.length + '개';
							} else {
								text = currentCategory + ' > ' + currentSubTab + ' FAQ ' + totalList.length + '개';
							}

							$('#faqResultInfo').text(text);
						}

						function showError(msg) {
							$('#faqList').html(
								'<div class="faq-error">' +
								'<i class="ri-error-warning-line"></i>' +
								'<span>' + esc(msg) + '</span>' +
								'</div>'
							);
						}

						function esc(str) {
							if (str === null || str === undefined) {
								return '';
							}

							return String(str)
								.replace(/&/g, '&amp;')
								.replace(/</g, '&lt;')
								.replace(/>/g, '&gt;')
								.replace(/"/g, '&quot;')
								.replace(/'/g, '&#039;');
						}
					</script>

		</body>

		</html>