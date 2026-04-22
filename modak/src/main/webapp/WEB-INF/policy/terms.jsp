<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>이용약관 · 환불정책 — 모닥모닥</title>

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/terms.css">
	</head>

	<body>
		<div id="app">
			<div class="nav">

				<div class="nav-crumb">
					<a class="btn" href="/main.do"><span>홈</span></a> › <span class="cur">약관 및 정책</span>
				</div>
			</div>

			<div class="layout">

				<!-- 사이드 탭 -->
				<div class="side-nav">
					<div class="side-nav-inner">
						<div class="side-tab active" onclick="showDoc('terms')">
							<span class="icon">📋</span> 이용약관
						</div>

						<div class="side-tab" onclick="showDoc('refund')">
							<span class="icon">💰</span> 환불정책
						</div>
						<div class="side-updated">최종 업데이트<br>2026년 4월 1일</div>
					</div>
				</div>

				<!-- 본문 -->
				<div class="content">

					<!-- ① 이용약관 -->
					<div class="doc active" id="doc-terms">
						<div class="doc-header">
							<div class="badge" style="background:#fde8d8;color:#993c1d;">📋 이용약관</div>
							<h1>서비스 이용약관</h1>
							<div class="meta">
								<span>📅 시행일 2026년 4월 1일</span>
								<span>📄 버전 v3.2</span>
							</div>
						</div>

						<div class="doc-section">
							<h2>제1조 목적</h2>
							<p>이 약관은 모닥모닥(이하 "회사")이 운영하는 캠핑 장비 대여 서비스(이하 "서비스")의 이용 조건 및 절차, 회사와 회원 간의 권리·의무 및 책임사항을
								규정함을
								목적으로 합니다.</p>
						</div>

						<div class="doc-section">
							<h2>제2조 용어 정의</h2>
							<ul>
								<li><strong>"서비스"</strong>란 회사가 제공하는 캠핑 장비 대여 플랫폼 및 관련 부가 서비스를 말합니다.</li>
								<li><strong>"회원"</strong>이란 본 약관에 동의하고 회원 가입을 완료한 개인 또는 법인을 말합니다.</li>
								<li><strong>"대여 계약"</strong>이란 회원이 특정 장비를 일정 기간 동안 사용하기 위해 회사와 체결하는 계약을 말합니다.</li>
								<li><strong>"포인트"</strong>란 회원이 서비스 이용을 통해 적립하거나 지급받는 가상의 재화로, 현금으로 환급되지 않습니다.</li>
							</ul>
						</div>

						<div class="doc-section">
							<h2>제3조 약관의 효력 및 변경</h2>
							<p>① 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.</p>
							<p>② 회사는 관련 법령에 위배되지 않는 범위에서 약관을 개정할 수 있으며, 개정 시 적용일자 및 개정 사유를 명시하여 현행 약관과 함께 서비스 초기 화면에 그
								적용일자
								7일 이전부터 공지합니다.</p>
							<div class="notice-box orange">중요 사항이 변경되는 경우 최소 30일 전 사전 공지하며, 회원이 명시적으로 거부하지 않는 경우 변경에 동의한
								것으로
								간주합니다.</div>
						</div>

						<div class="doc-section">
							<h2>제4조 회원 가입 및 탈퇴</h2>
							<p>① 서비스 이용을 위해 회원 가입이 필요하며, 만 14세 미만은 가입이 불가합니다.</p>
							<p>② 회원 탈퇴 신청은 마이페이지 → 설정 → 탈퇴하기를 통해 진행할 수 있습니다.</p>
							<p>③ 탈퇴 시 보유 포인트 및 쿠폰은 즉시 소멸되며, 진행 중인 대여 계약이 있는 경우 반납 완료 후 탈퇴가 가능합니다.</p>
						</div>

						<div class="doc-section">
							<h2>제5조 장비 대여 및 반납</h2>
							<p>① 회원은 예약 완료 후 지정된 장소 및 시간에 장비를 수령하여야 합니다.</p>
							<p>② 반납 기한은 대여 종료일 당일 오전 11시이며, 초과 시 1일 단위로 추가 요금이 부과됩니다.</p>
							<p>③ 장비 수령 시 상태를 확인하고 파손이 발견된 경우 즉시 고객센터에 신고하여야 합니다. 신고 없이 반납 시 해당 파손에 대한 책임은 회원에게 있습니다.</p>
							<table class="doc-table">
								<thead>
									<tr>
										<th>연체 기간</th>
										<th>추가 요금</th>
										<th>처리 방법</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1일 이내</td>
										<td>일 대여료의 50%</td>
										<td>자동 결제</td>
									</tr>
									<tr>
										<td>2~3일</td>
										<td>일 대여료의 100%</td>
										<td>자동 결제 + 안내 문자</td>
									</tr>
									<tr>
										<td>4일 이상</td>
										<td>일 대여료의 150% + 분실 처리</td>
										<td>법적 절차 검토</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="doc-section">
							<h2>제6조 금지 행위</h2>
							<ul>
								<li>장비의 무단 전대 또는 제3자 양도</li>
								<li>장비를 이용한 불법 행위 또는 타인에게 피해를 주는 행위</li>
								<li>고의적 파손, 개조 또는 임의 수리</li>
								<li>허위 정보로 회원가입 또는 예약하는 행위</li>
								<li>서비스의 운영을 방해하거나 회사의 명예를 훼손하는 행위</li>
							</ul>
						</div>

						<div class="doc-section">
							<h2>제7조 면책 조항</h2>
							<p>회사는 천재지변, 전쟁, 폭동, 파업 등 불가항력으로 인해 서비스를 제공할 수 없는 경우에는 책임이 면제됩니다. 또한 회원의 귀책 사유로 인한 서비스 장애에
								대해서는
								책임을 지지 않습니다.</p>
							<div class="notice-box gray">서비스 이용 중 발생하는 회원 간 또는 회원과 제3자 간의 분쟁에 대해 회사는 개입 의무가 없으며, 이로 인한
								손해를
								배상할 책임이 없습니다.</div>
						</div>

						<div class="doc-section">
							<h2>제8조 준거법 및 분쟁 해결</h2>
							<p>본 약관은 대한민국 법률에 따라 규율되며, 서비스 이용과 관련하여 분쟁이 발생한 경우 회사 본사 소재지를 관할하는 법원을 전속 관할 법원으로 합니다.</p>
						</div>

						<div class="doc-actions">
							<button class="btn-print" onclick="window.print()">🖨 인쇄하기</button>
							<button class="btn-download" @click="downloadPDF">⬇ PDF 저장</button>
						</div>
					</div>



					<!-- ③ 환불정책 -->
					<div class="doc" id="doc-refund">
						<div class="doc-header">
							<div class="badge" style="background:#dff0e4;color:#27500a;">💰 환불정책</div>
							<h1>환불 및 취소 정책</h1>
							<div class="meta">
								<span>📅 시행일 2026년 4월 1일</span>
								<span>📄 버전 v2.1</span>
							</div>
						</div>

						<div class="doc-section">
							<div class="notice-box green">모닥모닥은 소비자기본법 및 전자상거래법에 따라 공정한 환불 정책을 운영합니다.</div>
							<h2>대여 취소 환불 기준</h2>
							<div class="refund-timeline">
								<div class="rt-item">
									<div class="rt-left">
										<div class="rt-dot" style="background:#3b6d11;"></div>
										<div class="rt-line"></div>
									</div>
									<div class="rt-body">
										<div class="rt-period">대여 시작 7일 전 이상</div>
										<div class="rt-rate" style="color:#3b6d11;">100% 환불</div>
										<div class="rt-desc">결제 수단으로 전액 환불 (영업일 3~5일 소요)</div>
									</div>
								</div>
								<div class="rt-item">
									<div class="rt-left">
										<div class="rt-dot" style="background:#639922;"></div>
										<div class="rt-line"></div>
									</div>
									<div class="rt-body">
										<div class="rt-period">대여 시작 3~6일 전</div>
										<div class="rt-rate" style="color:#639922;">70% 환불</div>
										<div class="rt-desc">결제금액의 30% 취소 수수료 발생</div>
									</div>
								</div>
								<div class="rt-item">
									<div class="rt-left">
										<div class="rt-dot" style="background:#e8610a;"></div>
										<div class="rt-line"></div>
									</div>
									<div class="rt-body">
										<div class="rt-period">대여 시작 1~2일 전</div>
										<div class="rt-rate" style="color:#e8610a;">50% 환불</div>
										<div class="rt-desc">결제금액의 50% 취소 수수료 발생</div>
									</div>
								</div>
								<div class="rt-item">
									<div class="rt-left">
										<div class="rt-dot" style="background:#e24b4a;"></div>
										<div class="rt-line"></div>
									</div>
									<div class="rt-body">
										<div class="rt-period">대여 당일 취소</div>
										<div class="rt-rate" style="color:#e24b4a;">환불 불가</div>
										<div class="rt-desc">당일 취소는 환불이 불가합니다 (장비 수령 전 포함)</div>
									</div>
								</div>
								<div class="rt-item">
									<div class="rt-left">
										<div class="rt-dot" style="background:#a32d2d;"></div>
									</div>
									<div class="rt-body">
										<div class="rt-period">대여 시작 이후</div>
										<div class="rt-rate" style="color:#a32d2d;">환불 불가</div>
										<div class="rt-desc">장비 수령 후에는 조기 반납 시에도 잔여 기간 환불 불가</div>
									</div>
								</div>
							</div>
						</div>

						<div class="doc-section">
							<h2>구매 상품 환불 기준</h2>
							<table class="doc-table">
								<thead>
									<tr>
										<th>상황</th>
										<th>환불 가능 여부</th>
										<th>조건</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>단순 변심</td>
										<td>수령 후 7일 이내</td>
										<td>미개봉, 상품 원상태 유지</td>
									</tr>
									<tr>
										<td>상품 불량·파손</td>
										<td>수령 후 30일 이내</td>
										<td>사진 증빙 첨부 필수</td>
									</tr>
									<tr>
										<td>오배송</td>
										<td>즉시 처리</td>
										<td>고객센터 신고 후 무료 회수</td>
									</tr>
									<tr>
										<td>개봉 후 단순 변심</td>
										<td>불가</td>
										<td>위생·안전 문제로 교환·환불 불가</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="doc-section">
							<h2>장비 파손·분실 배상 기준</h2>
							<p>장비 반납 시 파손 또는 분실이 확인되는 경우 아래 기준에 따라 배상금이 청구됩니다.</p>
							<table class="doc-table">
								<thead>
									<tr>
										<th>유형</th>
										<th>배상 기준</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>경미한 스크래치</td>
										<td>수리비 실비 청구</td>
										<td>일반 마모는 제외</td>
									</tr>
									<tr>
										<td>기능 이상·부품 파손</td>
										<td>수리비 또는 부품 교체비</td>
										<td>견적서 기준</td>
									</tr>
									<tr>
										<td>전파 파손 (사용 불가)</td>
										<td>장비 시가의 70%</td>
										<td>감가상각 적용</td>
									</tr>
									<tr>
										<td>분실</td>
										<td>장비 시가의 100%</td>
										<td>신품 기준</td>
									</tr>
								</tbody>
							</table>
							<div class="notice-box orange">파손·분실 배상은 반납일로부터 7일 이내에 등록된 결제 수단으로 자동 청구됩니다. 이의가 있는 경우
								청구일로부터
								14일 이내에 고객센터에 이의신청 하시기 바랍니다.</div>
						</div>

						<div class="doc-section">
							<h2>환불 처리 방법 및 소요 시간</h2>
							<table class="doc-table">
								<thead>
									<tr>
										<th>결제 수단</th>
										<th>환불 방법</th>
										<th>소요 시간</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>신용·체크카드</td>
										<td>카드사 취소</td>
										<td>영업일 3~5일</td>
									</tr>
									<tr>
										<td>계좌이체</td>
										<td>원계좌 환불</td>
										<td>영업일 1~3일</td>
									</tr>
									<tr>
										<td>포인트 결제</td>
										<td>포인트 재적립</td>
										<td>즉시</td>
									</tr>
									<tr>
										<td>쿠폰 사용분</td>
										<td>쿠폰 재발급</td>
										<td>영업일 1일</td>
									</tr>
									<tr>
										<td>간편결제 (카카오·네이버)</td>
										<td>해당 플랫폼 환불</td>
										<td>영업일 3~7일</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="doc-section">
							<h2>환불·취소 신청 방법</h2>
							<ol>
								<li>마이페이지 → 예약 내역 → 해당 예약 선택 → <strong>취소 신청</strong></li>
								<li>고객센터 채팅 또는 전화(1588-0000) 접수</li>
								<li>이메일 접수: support@modakmodak.kr</li>
							</ol>
							<div class="notice-box green">영업시간(평일 09:00~18:00) 이후 접수된 취소 신청은 다음 영업일 기준으로 처리됩니다.</div>
						</div>

						<div class="doc-actions">
							<button class="btn-print" onclick="window.print()">🖨 인쇄하기</button>
							<button class="btn-download" @click="downloadPDF">⬇ PDF 저장</button>
						</div>
					</div>

				</div>
			</div>
		</div>
		<script>
			function showDoc(id) {
				document.querySelectorAll('.doc').forEach(d => d.classList.remove('active'));
				document.querySelectorAll('.side-tab').forEach(t => t.classList.remove('active'));
				document.getElementById('doc-' + id).classList.add('active');
				event.currentTarget.classList.add('active');
				window.scrollTo({top: 0, behavior: 'smooth'});
			}
		</script>
	</body>

	</html>


	<script>
		const app = Vue.createApp({
			data() {
				return {
					message: ""
				};
			},
			methods: {
				fnTerms: function () {
					let self = this;
					$.ajax({
						url: "http://localhost:8080/terms.dox",
						dataType: "json",
						type: "POST",
						success: function (data) {
							self.message = data.message;
						},
						error: function (err) {
							console.error("AJAX 에러:", err);
						}
					});
				},
				downloadPDF() {
					// 1. 현재 화면에 보이고 있는(active 클래스가 있는) 문서 영역을 찾습니다.
					const element = document.querySelector('.doc.active');

					if (!element) {
						alert('저장할 문서 영역을 찾을 수 없습니다.');
						return;
					}

					// 2. 문서 제목을 파일명으로 쓰기 위해 가져옵니다.
					const docTitle = element.querySelector('h1').innerText;

					const options = {
						margin: 10,
						filename: '모닥모닥_이용약관.pdf',
						image: {type: 'jpeg', quality: 0.98},
						html2canvas: {
							scale: 2,
							scrollY: 0, // Force scroll to top during capture
							useCORS: true
						},
						jsPDF: {unit: 'mm', format: 'a4', orientation: 'portrait'}
					};

					if (typeof html2pdf === 'undefined') {
						alert('라이브러리를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
						return;
					}

					html2pdf().set(options).from(element).save();
				}
			},
			mounted() {
				this.fnTerms();
			}
		});

		app.mount('#app');
	</script>