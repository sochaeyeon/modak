<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>마케팅 정보 수신 동의 - 모닥모닥</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
			rel="stylesheet">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/marketing-consent.css">
	</head>

	<body>

		<div class="container">
			<div class="sidebar">
				<a href="/terms.do" class="tab-item">서비스 이용약관</a>
				<a href="/privacyPolicy.do" class="tab-item">개인정보처리방침</a>
				<a href="/marketingConsent.do" class="tab-item active">마케팅 정보 수신 동의</a>
				<div class="sidebar-info">
					최종 업데이트<br>
					2026년 4월 1일
				</div>
			</div>

			<div class="content">
				<div class="content-header">
					<div class="badge">선택 약관</div>
					<h1>마케팅 정보 수신 동의</h1>
					<div class="version-info">
						<span>시행일 2026년 4월 1일</span>
						<span>버전 v1.2</span>
					</div>
				</div>

				<div class="policy-section">
					<div class="section-intro">
						모닥모닥은 이용자에게 더욱 최적화된 서비스와 혜택을 제공하기 위해 아래와 같이 개인정보를 수집·이용합니다.
					</div>

					<div class="section-title"><span>|</span> 마케팅 정보 수집 및 이용 내역</div>

					<table class="policy-table">
						<colgroup>
							<col style="width: 25%;">
							<col style="width: 45%;">
							<col style="width: 30%;">
						</colgroup>
						<thead>
							<tr>
								<th>수집 항목</th>
								<th>수집 및 이용 목적</th>
								<th>보유 및 이용 기간</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style="text-align: center; font-weight: 500;">
									이메일, 휴대전화 번호,<br>생년월일, 성별
								</td>
								<td>
									<ul>
										<li>맞춤형 캠핑 서비스 및 상품 추천</li>
										<li>이벤트 홍보 및 마케팅 정보 발송</li>
										<li>신규 서비스 안내 및 혜택 알림</li>
									</ul>
								</td>
								<td style="text-align: center; color: var(--accent); font-weight: 500;">
									회원 탈퇴 시 또는<br>동의 철회 시까지
								</td>
							</tr>
						</tbody>
					</table>

					<div class="notice-card">
						<h4>안내사항</h4>
						<ul>
							<li>귀하는 마케팅 정보 수신 동의를 거부할 권리가 있습니다.</li>
							<li>동의를 거부하더라도 회원 가입 및 서비스 이용(장비 예약/대여 등)은 가능하나, 맞춤형 혜택 및 이벤트 참여가 제한될 수 있습니다.</li>
							<li>수신 동의 여부는 [마이페이지 > 정보 수정]에서 언제든지 변경하실 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</body>

	</html>