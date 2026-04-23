<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>온라인 문의 접수 - 모닥모닥</title>
			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/inquiry-form.css">
		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<div class="inquiry-hero">
					<h1>온라인 문의 접수</h1>
					<p>궁금하신 사항을 남겨주시면 빠르게 답변드리겠습니다.</p>
				</div>

				<main class="inquiry-main">

					<%-- Flash 메시지 --%>
						<c:if test="${not empty successMsg}">
							<div class="inquiry-alert success">✅ ${successMsg}</div>
						</c:if>
						<c:if test="${not empty errorMsg}">
							<div class="inquiry-alert error">⚠️ ${errorMsg}</div>
						</c:if>

						<div class="section-title">문의 접수</div>

						<div class="form-card">
							<form id="inquirySubmitForm" action="/inquiry/submit.do" method="post">
								<%-- Spring Security CSRF 토큰 (비활성화 시 제거) --%>
									<c:if test="${not empty _csrf}">
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
									</c:if>



									<%-- ── 이름 / 이메일 ─────────────────────────────────────── 로그인 상태: 세션값으로 자동 채워지고
										readonly 처리 비로그인 : 직접 입력
										─────────────────────────────────────────────────────────── --%>
										<div class="form-row">
											<div class="form-group">
												<label for="userName">이름 <span class="required">*</span></label>
												<c:choose>
													<c:when test="${not empty sessionScope.loginUser}">
														<input type="text" id="userName" name="userName"
															value="${sessionScope.loginUser.userName}"
															class="input-readonly" readonly>
													</c:when>
													<c:otherwise>
														<input type="text" id="userName" name="userName"
															placeholder="홍길동" value="${param.userName}" maxlength="50"
															required>
													</c:otherwise>
												</c:choose>
											</div>
											<div class="form-group">
												<label for="userEmail">이메일 <span class="required">*</span></label>
												<c:choose>
													<c:when test="${not empty sessionScope.loginUser}">
														<input type="email" id="userEmail" name="userEmail"
															value="${sessionScope.loginUser.userEmail}"
															class="input-readonly" readonly>
													</c:when>
													<c:otherwise>
														<input type="email" id="userEmail" name="userEmail"
															placeholder="example@mail.com" value="${param.userEmail}"
															maxlength="100" required>
													</c:otherwise>
												</c:choose>
											</div>
										</div>

										<div class="form-row">
											<div class="form-group">
												<label for="title">제목 <span class="required">*</span></label>
												<input type="text" id="title" name="title" placeholder="문의 제목을 입력해주세요"
													value="${param.title}" maxlength="100" required>
											</div>
											<div class="form-group">
												<label for="inquiryType">문의 유형 <span class="required">*</span></label>
												<select id="inquiryType" name="inquiryType" required>
													<option value="" disabled selected>선택해주세요</option>
													<option value="ORDER" ${param.inquiryType eq 'ORDER' ? 'selected'
														: '' }>주문/결제</option>
													<option value="DELIVERY" ${param.inquiryType eq 'DELIVERY'
														? 'selected' : '' }>배송 문의</option>
													<option value="RETURN" ${param.inquiryType eq 'RETURN' ? 'selected'
														: '' }>교환/반품</option>
													<option value="PRODUCT" ${param.inquiryType eq 'PRODUCT'
														? 'selected' : '' }>상품 문의</option>
													<option value="ACCOUNT" ${param.inquiryType eq 'ACCOUNT'
														? 'selected' : '' }>회원/계정</option>
													<option value="OTHER" ${param.inquiryType eq 'OTHER' ? 'selected'
														: '' }>기타</option>
												</select>
											</div>
										</div>

										<div class="form-row">
											<div class="form-group">
												<label for="content">문의 내용 <span class="required">*</span></label>
												<textarea id="content" name="content" placeholder="문의하실 내용을 상세히 입력해주세요."
													maxlength="2000" required>${param.content}</textarea>
											</div>
										</div>

										<div class="form-note">
											접수된 문의는 영업시간 내에 순차적으로 답변드립니다. 문의가 많을 경우 다소 지연될 수 있습니다.<br>
											개인정보는 문의 답변 목적으로만 사용되며, 답변 완료 후 즉시 파기됩니다.
										</div>

										<button type="submit" class="btn-inquiry-submit">문의 접수하기</button>
							</form>
						</div>

						<div class="inquiry-steps">
							<div class="step-card">
								<div class="step-num">1</div>
								<h4>문의 접수</h4>
								<p>양식을 작성하여<br>문의를 접수합니다.</p>
							</div>
							<div class="step-card">
								<div class="step-num">2</div>
								<h4>검토 및 처리</h4>
								<p>담당자가 내용을 확인하고<br>처리합니다.</p>
							</div>
							<div class="step-card">
								<div class="step-num">3</div>
								<h4>이메일 답변</h4>
								<p>등록하신 이메일로<br>답변을 드립니다.</p>
							</div>
						</div>

				</main>

				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<script>
						/* ──────────────────────────────────────────────────────────
						   jQuery $(document).ready 로 감싸서
						   header.jsp 의 jQuery 로드 완료 후 실행되도록 보장
						────────────────────────────────────────────────────────── */
						$(document).ready(function () {

							/* 문의 폼 유효성 검사 */
							$('#inquirySubmitForm').on('submit', function (e) {
								var userName = $.trim($('#userName').val());
								var userEmail = $.trim($('#userEmail').val());
								var title = $.trim($('#title').val());
								var type = $('#inquiryType').val();
								var content = $.trim($('#content').val());

								if (!userName) {
									e.preventDefault();
									alert('이름을 입력해주세요.');
									$('#userName').focus();
									return false;
								}
								if (!userEmail || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(userEmail)) {
									e.preventDefault();
									alert('올바른 이메일 주소를 입력해주세요.');
									$('#userEmail').focus();
									return false;
								}
								if (!title) {
									e.preventDefault();
									alert('제목을 입력해주세요.');
									$('#title').focus();
									return false;
								}
								if (!type) {
									e.preventDefault();
									alert('문의 유형을 선택해주세요.');
									$('#inquiryType').focus();
									return false;
								}
								if (content.length < 10) {
									e.preventDefault();
									alert('문의 내용을 10자 이상 입력해주세요.');
									$('#content').focus();
									return false;
								}
							});

						}); // end document.ready
					</script>

		</body>

		</html>