<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>개인정보 처리 방침</title>

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

		<style>
			* {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			body {
				font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif;
				background: #f5f0e8;
				color: #1a1a18;
			}

			/* LAYOUT */
			.layout {
				display: flex;
				max-width: 1060px;
				margin: 0 auto;
				padding: 36px 24px 80px;
				gap: 28px;
				align-items: flex-start;
			}

			/* 본문 */
			.content {
				flex: 1;
				min-width: 0;
			}

			.doc-header {
				background: #fff;
				border-radius: 16px;
				border: 1px solid #ede8de;
				padding: 28px 32px;
				margin-bottom: 20px;
			}

			.doc-header .badge {
				display: inline-block;
				padding: 4px 12px;
				border-radius: 20px;
				font-size: 11px;
				font-weight: 700;
				margin-bottom: 12px;
			}

			.doc-header h1 {
				font-size: 22px;
				font-weight: 800;
				color: #1a1a18;
				margin-bottom: 8px;
			}

			.doc-header .meta {
				font-size: 12px;
				color: #aaa;
				display: flex;
				gap: 16px;
				flex-wrap: wrap;
			}

			.doc-header .meta span {
				display: flex;
				align-items: center;
				gap: 4px;
			}

			/* 섹션 */
			.doc-section {
				background: #fff;
				border-radius: 14px;
				border: 1px solid #ede8de;
				padding: 24px 28px;
				margin-bottom: 14px;
			}

			.doc-section h2 {
				font-size: 15px;
				font-weight: 700;
				color: #1a1a18;
				margin-bottom: 14px;
				display: flex;
				align-items: center;
				gap: 8px;
			}

			.doc-section h2::before {
				content: '';
				display: block;
				width: 4px;
				height: 16px;
				background: #e8610a;
				border-radius: 2px;
				flex-shrink: 0;
			}

			.doc-section p {
				font-size: 13px;
				color: #555;
				line-height: 1.85;
				margin-bottom: 10px;
			}

			.doc-section p:last-child {
				margin-bottom: 0;
			}

			.doc-section ul,
			.doc-section ol {
				padding-left: 18px;
				margin-bottom: 10px;
			}

			.doc-section li {
				font-size: 13px;
				color: #555;
				line-height: 1.85;
				margin-bottom: 4px;
			}

			.doc-section strong {
				font-weight: 700;
				color: #1a1a18;
			}

			/* 표 */
			.doc-table {
				width: 100%;
				border-collapse: collapse;
				font-size: 13px;
				margin: 12px 0;
			}

			.doc-table th {
				background: #f5f0e8;
				padding: 10px 14px;
				text-align: left;
				font-weight: 700;
				color: #555;
				border-bottom: 1px solid #ede8de;
			}

			.doc-table td {
				padding: 10px 14px;
				border-bottom: 1px solid #f5f0e8;
				color: #555;
				vertical-align: top;
				line-height: 1.7;
			}

			.doc-table tr:last-child td {
				border-bottom: none;
			}

			.doc-table tr:hover td {
				background: #fafaf8;
			}

			/* 강조 박스 */
			.notice-box {
				border-radius: 10px;
				padding: 14px 16px;
				margin: 14px 0;
				font-size: 13px;
				line-height: 1.7;
			}



			.notice-box.blue {
				background: #ddeeff;
				color: #0c447c;
				border-left: 3px solid #185fa5;
			}

			/* 인쇄 버튼 */
			.doc-actions {
				display: flex;
				gap: 8px;
				margin-top: 20px;
			}

			.btn-print {
				padding: 9px 20px;
				background: #fff;
				border: 1px solid #e2dcd2;
				border-radius: 8px;
				font-size: 13px;
				font-weight: 600;
				color: #555;
				cursor: pointer;
				transition: background 0.12s;
			}

			.btn-print:hover {
				background: #f5f0e8;
			}

			.btn-download {
				padding: 9px 20px;
				background: #1a1a18;
				border: none;
				border-radius: 8px;
				font-size: 13px;
				font-weight: 600;
				color: #fff;
				cursor: pointer;
				transition: background 0.12s;
			}

			.btn-download:hover {
				background: #333;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div class="layout">

				<!-- 본문 -->
				<div class="content">

					<!-- ② 개인정보처리방침 -->
					<div class="doc" id="doc-privacy">
						<div class="doc-header">
							<div class="badge" style="background:#ddeeff;color:#0c447c;">🔒 개인정보처리방침</div>
							<h1>개인정보처리방침</h1>
							<div class="meta">
								<span>📅 시행일 2026년 4월 1일</span>
								<span>📄 버전 v2.5</span>
							</div>
						</div>

						<div class="doc-section">
							<div class="notice-box blue">모닥모닥은 개인정보보호법 등 관련 법령을 준수하며, 이용자의 개인정보를 소중히 보호합니다.</div>
							<h2>제1조 수집하는 개인정보 항목</h2>
							<table class="doc-table">
								<thead>
									<tr>
										<th>구분</th>
										<th>수집 항목</th>
										<th>수집 목적</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><strong>필수</strong></td>
										<td>이름, 이메일, 휴대폰 번호, 생년월일</td>
										<td>회원 가입 및 본인 확인</td>
									</tr>
									<tr>
										<td><strong>필수</strong></td>
										<td>결제 정보 (카드번호 마지막 4자리)</td>
										<td>서비스 결제 처리</td>
									</tr>
									<tr>
										<td><strong>필수</strong></td>
										<td>배송지 주소</td>
										<td>장비 배송 및 수령</td>
									</tr>
									<tr>
										<td>선택</td>
										<td>프로필 사진, 캠핑 스타일 정보</td>
										<td>맞춤 추천 서비스</td>
									</tr>
									<tr>
										<td>자동 수집</td>
										<td>접속 IP, 쿠키, 기기 정보, 서비스 이용 기록</td>
										<td>서비스 개선 및 보안</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="doc-section">
							<h2>제2조 개인정보 보유 및 이용 기간</h2>
							<table class="doc-table">
								<thead>
									<tr>
										<th>보유 항목</th>
										<th>보유 기간</th>
										<th>근거</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>회원 정보</td>
										<td>탈퇴 후 30일</td>
										<td>내부 정책</td>
									</tr>
									<tr>
										<td>계약·청약철회 기록</td>
										<td>5년</td>
										<td>전자상거래법</td>
									</tr>
									<tr>
										<td>결제 및 공급 기록</td>
										<td>5년</td>
										<td>전자상거래법</td>
									</tr>
									<tr>
										<td>소비자 불만·분쟁 기록</td>
										<td>3년</td>
										<td>전자상거래법</td>
									</tr>
									<tr>
										<td>접속 로그</td>
										<td>3개월</td>
										<td>통신비밀보호법</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="doc-section">
							<h2>제3조 개인정보의 제3자 제공</h2>
							<p>회사는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 단, 아래의 경우는 예외로 합니다.</p>
							<ul>
								<li>이용자가 사전에 동의한 경우</li>
								<li>법령의 규정에 의거하거나 수사 목적으로 법령에서 정한 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
								<li>장비 배송을 위한 택배사 제공 (이름, 연락처, 주소에 한함)</li>
							</ul>
						</div>

						<div class="doc-section">
							<h2>제4조 개인정보의 안전성 확보 조치</h2>
							<ul>
								<li><strong>관리적 조치:</strong> 내부 관리계획 수립·시행, 정기적 직원 교육</li>
								<li><strong>기술적 조치:</strong> 비밀번호 암호화 저장, SSL/TLS 암호화 통신, 접근권한 관리</li>
								<li><strong>물리적 조치:</strong> 전산실 및 자료보관실 접근 통제</li>
							</ul>
						</div>

						<div class="doc-section">
							<h2>제5조 이용자의 권리와 행사 방법</h2>
							<p>이용자는 언제든지 아래 권리를 행사할 수 있습니다.</p>
							<ul>
								<li>개인정보 열람 요청</li>
								<li>개인정보 정정·삭제 요청</li>
								<li>개인정보 처리정지 요청</li>
								<li>동의 철회 (단, 필수 항목 철회 시 서비스 이용 불가)</li>
							</ul>
							<div class="notice-box blue">권리 행사는 마이페이지 → 개인정보 관리 또는 고객센터(privacy@modakmodak.kr)로 요청할 수
								있으며,
								10일 이내에 처리합니다.</div>
						</div>

						<div class="doc-section">
							<h2>제6조 개인정보 보호책임자</h2>
							<table class="doc-table">
								<thead>
									<tr>
										<th>구분</th>
										<th>내용</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>책임자 성명</td>
										<td>홍길동</td>
									</tr>
									<tr>
										<td>직책</td>
										<td>개인정보 보호책임자 (CPO)</td>
									</tr>
									<tr>
										<td>이메일</td>
										<td>privacy@modakmodak.kr</td>
									</tr>
									<tr>
										<td>전화</td>
										<td>1588-0000 (평일 09:00~18:00)</td>
									</tr>
								</tbody>
							</table>
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
				fnTerms() {
					let self = this;
					$.ajax({
						url: "http://localhost:8080/privacyPolicy.dox",
						dataType: "json",
						type: "POST",
						success: function (data) {
							self.message = data.message;
						},
						error: function (err) {
							console.error("데이터 로드 실패:", err);
						}
					});
				},
				downloadPDF() {
					const element = document.getElementById('doc-privacy');

					if (!element) return;

					const options = {
						margin: [10, 10, 10, 10], // top, left, bottom, right
						filename: '모닥모닥_개인정보처리방침.pdf',
						image: {type: 'jpeg', quality: 0.98},
						html2canvas: {
							scale: 2,
							scrollY: 0, // Force scroll to top during capture
							useCORS: true
						},
						jsPDF: {unit: 'mm', format: 'a4', orientation: 'portrait'},
						pagebreak: {mode: 'avoid-all'}
					};

					html2pdf().from(element).set(options).save();
				}
			},
			mounted() {
				this.fnTerms();
			}
		});

		app.mount('#app');
	</script>