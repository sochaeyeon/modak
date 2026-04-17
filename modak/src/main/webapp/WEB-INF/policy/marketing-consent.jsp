<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<title>마케팅정보 수신 약관</title>
		<style>
			.consent-container {
				max-width: 800px;
				margin: 20px auto;
				font-family: 'Pretendard', 'Malgun Gothic', sans-serif;
				color: #333;
				line-height: 1.6;
			}

			.consent-header {
				border-bottom: 2px solid #e67e22;
				/* 이미지의 오렌지 포인트 컬러 활용 */
				padding-bottom: 10px;
				margin-bottom: 20px;
			}

			.consent-table {
				width: 100%;
				border-collapse: collapse;
				margin: 15px 0;
				font-size: 0.9em;
			}

			.consent-table th {
				background-color: #f8f1eb;
				/* 이미지의 테이블 헤더 색상 참고 */
				border: 1px solid #ddd;
				padding: 12px;
				text-align: center;
			}

			.consent-table td {
				border: 1px solid #ddd;
				padding: 12px;
				text-align: left;
			}

			.highlight-box {
				background-color: #f0f7ff;
				padding: 15px;
				border-radius: 8px;
				font-size: 0.85em;
				margin-top: 10px;
			}

			.checkbox-wrapper {
				margin: 20px 0;
				padding: 15px;
				background: #fafafa;
				border: 1px solid #eee;
			}

			label {
				cursor: pointer;
				font-weight: bold;
			}
		</style>
	</head>

	<body>

		<div class="consent-container">
			<div class="consent-header">
				<h2>마케팅 정보 수신 동의 (선택)</h2>
			</div>

			<p>모닥모닥은 이용자에게 더욱 최적화된 서비스와 혜택을 제공하기 위해 아래와 같이 개인정보를 수집·이용합니다.</p>

			<table class="consent-table">
				<thead>
					<tr>
						<th>수집 항목</th>
						<th>수집 및 이용 목적</th>
						<th>보유 및 이용 기간</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><strong>이메일, 휴대전화 번호, 생년월일, 성별</strong></td>
						<td>
							* 맞춤형 캠핑 서비스 및 상품 추천<br>
							* 이벤트 홍보 및 마케팅 정보 발송<br>
							* 신규 서비스 안내 및 혜택 알림
						</td>
						<td><strong>회원 탈퇴 시 또는 동의 철회 시까지</strong></td>
					</tr>
				</tbody>
			</table>

			<div class="checkbox-wrapper">
				<input type="checkbox" id="marketing_agree" name="marketing_agree">
				<label for="marketing_agree">[선택] 마케팅 정보 수신에 동의하십니까?</label>
			</div>

			<div class="highlight-box">
				<strong>안내사항</strong>
				<ul style="margin: 5px 0 0 20px; padding: 0;">
					<li>귀하는 마케팅 정보 수신 동의를 거부할 권리가 있습니다.</li>
					<li>동의를 거부하더라도 회원 가입 및 서비스 이용(장비 예약/대여 등)은 가능하나, 맞춤형 혜택 및 이벤트 참여가 제한될 수 있습니다.</li>
					<li>수신 동의 여부는 [마이페이지 > 정보 수정]에서 언제든지 변경하실 수 있습니다.</li>
				</ul>
			</div>
		</div>

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
						url: "http://localhost:8080/marketingConsent.dox",
						dataType: "json",
						type: "POST",
						data: {}, // Sending empty object if no params needed
						success: function (data) {
							console.log("Server Response:", data);
							self.message = data.message;
						},
						terms: function (err) {
							console.terms("AJAX Terms:", terms);
						}
					});
				}
			},
			mounted() {
				this.fnTerms();
			}
		});
		app.mount('#app');
	</script>