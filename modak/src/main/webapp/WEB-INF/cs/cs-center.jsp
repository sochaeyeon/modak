<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>모닥모닥 고객센터 - Frame</title>
			<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
				rel="stylesheet">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/cs-center.css">
			<!-- jQuery ($ is not defined 에러 해결) -->
			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<!-- HERO -->
				<div class="hero">
					<span class="hero-icon">🔥</span>
					<h1>모닥모닥 고객센터에</h1>
					<p>오신 것을 환영합니다</p>
					<div class="hero-search-wrap">
						<input type="text" id="heroSearchInput" placeholder="궁금한 것을 검색해보세요"
							onkeydown="if(event.key==='Enter') doHeroSearch()">
						<button onclick="doHeroSearch()">🔍</button>
					</div>
					<div class="search-result-box" id="searchResultBox" style="display:none;">
						<div class="search-result-inner" id="searchResultInner"></div>
					</div>
					<div class="hero-links">
						<a href="/faq.do">자주 묻는 질문</a>
						<span>|</span>
						<a href="/notification/list.do">공지사항</a>
						<span>|</span>
						<a href="/inquiry.do">1:1 문의</a>
						<span>|</span>
						<a href="/terms.do">이용약관</a>
						<span>|</span>
						<a href="/privacyPolicy.do">개인정보처리방침</a>
					</div>
				</div>

				<!-- MAIN -->
				<div class="main">

					<!-- CATEGORY -->
					<div class="cat-section">
						<div class="sec-eyebrow">HELP CENTER</div>
						<div class="sec-title">어떤 도움이 필요하세요?</div>
						<div class="cat-grid">
							<div class="cat-card" onclick="moveFaqTab('서비스')">
								<div class="ci">🏠</div>
								<div class="cn">서비스 안내</div>
								<div class="cd">이용방법</div>
							</div>
							<div class="cat-card" onclick="moveFaqTab('요금')">
								<div class="ci">📧</div>
								<div class="cn">청구 / 요금</div>
								<div class="cd">결제 문의</div>
							</div>
							<div class="cat-card" onclick="location.href='/notification/list.do'">
								<div class="ci">📋</div>
								<div class="cn">공지 / 이벤트</div>
								<div class="cd">최신 소식</div>
							</div>
							<div class="cat-card" onclick="moveFaqTab('계정')">
								<div class="ci">🔧</div>
								<div class="cn">계약 / 설정</div>
								<div class="cd">계정 관리</div>
							</div>
							<div class="cat-card" onclick="moveFaqTab('계정')">
								<div class="ci">👤</div>
								<div class="cn">회원 / 계정</div>
								<div class="cd">회원정보</div>
							</div>
						</div>
					</div>

					<!-- NOTICE STRIP -->
					<div class="notice-strip">
						<div class="notice-strip-left">
							<div class="ns-dot">!</div>
							<div class="ns-text">
								<strong>도움이 필요하신가요?</strong><br>
								전문 상담사가 빠르게 도와드리겠습니다. 평일 09:00 ~ 18:00 운영중입니다.
							</div>
						</div>
						<button class="ns-btn" onclick="openChatbot()">상담 신청하기 →</button>
					</div>

					<!-- FAQ -->
					<div class="faq-section">
						<div class="faq-section-header">
							<div>
								<div class="sec-eyebrow">FAQ</div>
								<div class="sec-title">자주 묻는 질문</div>
							</div>
							<a href="/faq.do" class="faq-more-btn">더보기 →</a>
						</div>
						<div class="faq-layout">
							<!-- 사이드바: 대분류 -->
							<div class="faq-sidebar">
								<ul id="faqSidebarList">
									<li class="active" data-cat="전체">전체</li>
									<li data-cat="서비스">서비스 안내</li>
									<li data-cat="요금">요금 / 결제</li>
									<li data-cat="계정">회원 / 계정</li>
									<li data-cat="기타">기타 문의</li>
								</ul>
							</div>
							<div class="faq-main">
								<!-- 소분류 탭 -->
								<div class="faq-tabs" id="faqTabList">
									<div class="faq-tab active" data-tab="전체">전체</div>
								</div>
								<!-- FAQ 목록 -->
								<div id="faqListWrap">
									<c:choose>
										<c:when test="${not empty faqList}">
											<c:forEach var="faq" items="${faqList}">
												<div class="faq-item" data-cat="${faq.category}"
													data-subcat="${faq.subCategory}">
													<div class="faq-question">
														<span class="q-text">
															<c:out value="${faq.question}" />
														</span>
														<span class="q-arrow">›</span>
													</div>
													<div class="faq-answer">
														<div class="faq-answer-inner">
															<c:out value="${faq.answer}" />
														</div>
													</div>
												</div>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<div class="faq-empty">등록된 FAQ가 없습니다.</div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</div>

					<div class="section-divider"></div>



					<!-- CONSULT -->
					<div class="consult-section">
						<div class="sec-eyebrow">CONTACT</div>
						<div class="sec-title">직접 문의하기</div>
						<div style="font-size:10px;color:var(--text-light);margin-bottom:14px;">평일 09:00 ~ 18:00
							(주말/공휴일
							제외)</div>
						<div class="consult-layout">
							<div class="consult-left">

								<!-- 1) 전화 상담 -->
								<div class="consult-card">
									<div class="c-avatar">전</div>
									<div class="c-info">
										<div class="c-name">전화 상담</div>
										<div class="c-desc">전화를 통해 빠르게 상담받으실 수 있습니다.<br>대기 시간이 발생할 수 있습니다.</div>
										<button class="c-btn" onclick="callPhone()">전화 연결</button>
									</div>
								</div>

								<!-- 2) 채팅 상담 (챗봇) -->
								<div class="consult-card">
									<div class="c-avatar blue">채</div>
									<div class="c-info">
										<div class="c-name">채팅 상담</div>
										<div class="c-desc">AI 챗봇을 통해 24시간 상담이 가능합니다.<br>빠른 답변을 받아보실 수 있습니다.
										</div>
										<button class="c-btn blue" onclick="openChatbot()">챗봇 시작</button>
									</div>
								</div>

								<!-- 3) 이메일 문의 -->
								<div class="consult-card">
									<div class="c-avatar gray">이</div>
									<div class="c-info">
										<div class="c-name">이메일 문의</div>
										<div class="c-desc">help@modakmodak.com으로 문의해주세요.<br>1~2 영업일 내 답변드립니다.
										</div>
										<button class="c-btn gray" onclick="sendEmail()">이메일 보내기</button>
									</div>
								</div>

								<!-- 4) 온라인 문의접수 - 초록색 계열 -->
								<div class="consult-card">
									<div class="c-avatar green">온</div>
									<div class="c-info">
										<div class="c-name">온라인 문의 접수</div>
										<div class="c-desc">궁금하신 사항을 남겨주시면 빠르게 답변드리겠습니다.<br>1:1 문의를 통해 접수해주세요.
										</div>
										<button class="c-btn green" onclick="location.href='/inquiry.do'">바로가기</button>
									</div>
								</div>

							</div>
						</div>
					</div>

					<div class="section-divider"></div>

					<!-- HOW TO USE -->
					<div class="howto-section">
						<div class="sec-eyebrow">GUIDE</div>
						<div class="sec-title">서비스 이용 방법</div>
						<div class="howto-grid">
							<div class="howto-card">
								<div class="hw-num">01</div>
								<div class="hw-title">회원 가입</div>
								<div class="hw-desc">이메일 또는 소셜 계정으로 간편하게 회원가입 하세요.</div>
							</div>
							<div class="howto-card">
								<div class="hw-num">02</div>
								<div class="hw-title">요금제 선택</div>
								<div class="hw-desc">다양한 요금제 중 원하시는 플랜을 선택하세요.</div>
							</div>
							<div class="howto-card">
								<div class="hw-num">03</div>
								<div class="hw-title">No.1 선택</div>
								<div class="hw-desc">결제 수단 등록 후 원하는 서비스 옵션을 선택하세요.</div>
							</div>
							<div class="howto-card">
								<div class="hw-num">04</div>
								<div class="hw-title">이용 완료</div>
								<div class="hw-desc">모든 준비 완료! 지금 바로 서비스를 이용하실 수 있습니다.</div>
							</div>
						</div>
					</div>

					<div class="section-divider"></div>

					<!-- NOTICE LIST -->
					<div class="notice-section">
						<div class="notice-header">
							<div>
								<div class="sec-eyebrow">NOTICE</div>
								<div class="sec-title" style="margin-bottom:0">공지사항</div>
							</div>
							<a href="/notification/list.do" class="notice-more">더보기 →</a>
						</div>
						<div class="n-row">
							<span class="n-badge">공지</span>
							<span class="n-text">2024년 상반기 서비스 업데이트 안내 및 새로운 기능 추가 예정에 대해 안내드립니다</span>
							<span class="n-date">2024.03.15</span>
						</div>
						<div class="n-row">
							<span class="n-badge blue">이벤트</span>
							<span class="n-text">서비스 3주년 기념 특별 이벤트 - 요금제 50% 할인 프로모션 안내</span>
							<span class="n-date">2024.03.10</span>
						</div>
						<div class="n-row">
							<span class="n-badge gray">일반</span>
							<span class="n-text">정기 서버 점검 안내 (3월 20일 새벽 2시 ~ 4시)</span>
							<span class="n-date">2024.03.08</span>
						</div>
						<div class="n-row">
							<span class="n-badge gray">일반</span>
							<span class="n-text">개인정보처리방침 변경 안내 - 시행일: 2024년 4월 1일부터 적용</span>
							<span class="n-date">2024.03.05</span>
						</div>
					</div>

				</div><!-- /main -->

				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<!-- 챗봇 모달 -->
					<div id="chatbotModal" class="chatbot-modal" style="display:none;">
						<div class="chatbot-wrap">
							<div class="chatbot-header">
								<span>🔥 모닥모닥 AI 상담</span>
								<button class="chatbot-close" onclick="closeChatbot()">✕</button>
							</div>
							<div class="chatbot-body" id="chatbotBody">
								<div class="chat-msg bot">안녕하세요! 모닥모닥 고객센터입니다. 무엇을 도와드릴까요?</div>
							</div>
							<div class="chatbot-input-wrap">
								<input type="text" id="chatbotInput" placeholder="메시지를 입력하세요..."
									onkeydown="if(event.key==='Enter') sendChat()">
								<button onclick="sendChat()">전송</button>
							</div>
						</div>
					</div>


					<script>
						var CTX = '<%=request.getContextPath()%>';

						/* ── 소분류 탭 매핑 ── */
						var SUB_TABS = {
							'전체': ['전체'],
							'서비스': ['전체', '이용방법', '기능안내'],
							'요금': ['전체', '결제수단', '환불', '영수증'],
							'계정': ['전체', '가입', '탈퇴', '정보수정', '비밀번호'],
							'기타': ['전체']
						};

						var currentCat = '전체';
						var currentSubTab = '전체';

						/* ── 소분류 탭 렌더링 ── */
						function renderSubTabs(mainCat) {
							var tabs = SUB_TABS[mainCat] || ['전체'];
							var html = '';
							$.each(tabs, function (i, tab) {
								html += '<div class="faq-tab' + (i === 0 ? ' active' : '') + '" data-tab="' + tab + '">' + tab + '</div>';
							});
							$('#faqTabList').html(html);
							currentSubTab = '전체';
						}

						/* ── FAQ 필터링 ── */
						function filterFaq() {
							$('#faqListWrap .faq-item').each(function () {
								var itemCat = $(this).data('cat') || '';
								var itemSubcat = $(this).data('subcat') || '';
								var catMatch = (currentCat === '전체') || (itemCat === currentCat);
								var subMatch = (currentSubTab === '전체') || (itemSubcat === currentSubTab);
								$(this).toggle(catMatch && subMatch);
							});
							$('#faqListWrap .faq-empty-dynamic').remove();
							if ($('#faqListWrap .faq-item:visible').length === 0) {
								$('#faqListWrap').append('<div class="faq-empty faq-empty-dynamic">등록된 FAQ가 없습니다.</div>');
							}
						}

						/* ── 사이드바 (대분류) 클릭 ── */
						$('#faqSidebarList').on('click', 'li', function () {
							$('#faqSidebarList li').removeClass('active');
							$(this).addClass('active');
							currentCat = $(this).data('cat');
							renderSubTabs(currentCat);
							filterFaq();
						});

						/* ── 소분류 탭 클릭 ── */
						$('#faqTabList').on('click', '.faq-tab', function () {
							$('#faqTabList .faq-tab').removeClass('active');
							$(this).addClass('active');
							currentSubTab = $(this).data('tab');
							filterFaq();
						});

						/* ── 카테고리 카드 클릭 → FAQ로 이동 ── */
						function moveFaqTab(cat) {
							$('#faqSidebarList li').removeClass('active');
							$('#faqSidebarList li[data-cat="' + cat + '"]').addClass('active');
							currentCat = cat;
							renderSubTabs(cat);
							filterFaq();
							$('html, body').animate({scrollTop: $('.faq-section').offset().top - 80}, 400);
						}

						/* ── FAQ 아이템 토글 ── */
						$('#faqListWrap').on('click', '.faq-question', function () {
							var $item = $(this).closest('.faq-item');
							var wasOpen = $item.hasClass('open');
							$('#faqListWrap .faq-item').removeClass('open').find('.faq-answer').slideUp(180);
							if (!wasOpen) $item.addClass('open').find('.faq-answer').slideDown(180);
						});

						/* ── Hero 검색 ── */
						function doHeroSearch() {
							var keyword = $('#heroSearchInput').val().trim();
							if (!keyword) {$('#searchResultBox').hide(); return;}

							var results = [];
							$('#faqListWrap .faq-item').each(function () {
								var q = $(this).find('.q-text').text().trim();
								var a = $(this).find('.faq-answer-inner').text().trim();
								if (q.indexOf(keyword) >= 0 || a.indexOf(keyword) >= 0) results.push({question: q, el: this});
							});

							var html = '';
							if (results.length === 0) {
								html = '<div class="search-no-result">검색 결과가 없습니다.</div>';
							} else {
								$.each(results, function (i, r) {
									var hl = r.question.replace(new RegExp('(' + escapeRegex(keyword) + ')', 'gi'), '<mark>$1</mark>');
									html += '<div class="search-result-item" data-idx="' + i + '"><span class="search-result-q">' + hl + '</span></div>';
								});
							}
							$('#searchResultInner').html(html);
							$('#searchResultBox').show();

							$('#searchResultInner').off('click', '.search-result-item').on('click', '.search-result-item', function () {
								var target = results[$(this).data('idx')].el;
								$('html, body').animate({scrollTop: $(target).offset().top - 100}, 400);
								$('#faqListWrap .faq-item').removeClass('open').find('.faq-answer').slideUp(180);
								$(target).addClass('open').find('.faq-answer').slideDown(180);
								$('#searchResultBox').hide();
								$('#heroSearchInput').val('');
								currentCat = '전체'; currentSubTab = '전체';
								$('#faqSidebarList li').removeClass('active').filter('[data-cat="전체"]').addClass('active');
								renderSubTabs('전체');
								$('#faqListWrap .faq-item').show();
								$('#faqListWrap .faq-empty-dynamic').remove();
							});
						}

						$('#heroSearchInput').on('input', doHeroSearch);
						$('#heroSearchInput').on('keydown', function (e) {if (e.key === 'Escape') $('#searchResultBox').hide();});
						$(document).on('click', function (e) {
							if (!$(e.target).closest('.hero-search-wrap, .search-result-box').length) $('#searchResultBox').hide();
						});

						// ✅ 수정: $& 대신 함수 방식 사용
						function escapeRegex(str) {
							var SPECIAL = /[.*+?^$()|[\]\\]/g;  // { } 제거
							return str.replace(SPECIAL, function (match) {
								return '\\' + match;
							});
						}

						/* ── 전화 상담 ── */
						function callPhone() {
							if (confirm('1588-0000으로 전화 연결하시겠습니까?\n(평일 09:00 ~ 18:00)')) location.href = 'tel:15880000';
						}

						/* ── 이메일 문의 ── */
						function sendEmail() {
							location.href = 'mailto:help@modakmodak.com?subject=[문의]&body=문의 내용을 입력해주세요.';
						}

						/* ── 챗봇 ── */
						var chatBotAnswers = {
							'환불': '환불은 결제일로부터 7일 이내 신청 가능합니다. 고객센터로 연락해주세요.',
							'비밀번호': '비밀번호 찾기는 로그인 화면 하단 [비밀번호 찾기]를 클릭하세요.',
							'탈퇴': '회원 탈퇴는 마이페이지 > 계정 설정에서 진행하실 수 있습니다.',
							'결제': '결제 수단 변경은 마이페이지 > 결제 관리에서 가능합니다.',
							'예약': '예약 관련 문의는 예약 내역에서 확인하실 수 있습니다.',
							'대여': '대여 관련 문의는 예약 내역 > 대여 현황에서 확인하실 수 있습니다.'
						};

						function openChatbot() {$('#chatbotModal').fadeIn(200); $('#chatbotInput').focus();}
						function closeChatbot() {$('#chatbotModal').fadeOut(200);}

						function sendChat() {
							var msg = $('#chatbotInput').val().trim();
							if (!msg) return;
							$('#chatbotInput').val('');
							$('#chatbotBody').append('<div class="chat-msg user">' + escHtml(msg) + '</div>');

							var reply = '죄송합니다. 해당 내용은 1:1 문의나 전화 상담을 이용해주세요.';
							$.each(chatBotAnswers, function (keyword, answer) {
								if (msg.indexOf(keyword) >= 0) {reply = answer; return false;}
							});

							setTimeout(function () {
								$('#chatbotBody').append('<div class="chat-msg bot">' + reply + '</div>');
								var $body = $('#chatbotBody');
								$body.scrollTop($body[0].scrollHeight);
							}, 500);
							$('#chatbotBody').scrollTop($('#chatbotBody')[0].scrollHeight);
						}

						function escHtml(str) {
							return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
						}

						/* ── 초기화 ── */
						$(document).ready(function () {
							renderSubTabs('전체');
							filterFaq();
						});
					</script>

		</body>

		</html>