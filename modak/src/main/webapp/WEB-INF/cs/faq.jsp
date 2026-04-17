<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>자주 묻는 질문 (FAQ)</title>
		<style>
			/* 기본 스타일 */
			body {
				font-family: 'Arial', sans-serif;
				line-height: 1.6;
				background-color: #f9f9f9;
				padding: 20px;
			}

			.faq-container {
				max-width: 800px;
				margin: 0 auto;
				background: #fff;
				padding: 30px;
				border-radius: 8px;
				box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
			}

			h2 {
				text-align: center;
				color: #333;
				margin-bottom: 30px;
			}

			/* FAQ 아이템 스타일 */
			.faq-item {
				border-bottom: 1px solid #eee;
			}

			.faq-item:last-child {
				border-bottom: none;
			}

			/* 질문 버튼 */
			.faq-question {
				width: 100%;
				padding: 20px;
				text-align: left;
				background: none;
				border: none;
				outline: none;
				cursor: pointer;
				font-size: 18px;
				font-weight: bold;
				display: flex;
				justify-content: space-between;
				align-items: center;
				transition: background 0.3s;
			}

			.faq-question:hover {
				background-color: #f1f1f1;
			}

			/* 답변 스타일 (기본은 숨김) */
			.faq-answer {
				max-height: 0;
				overflow: hidden;
				transition: max-height 0.3s ease-out;
				background-color: #fafafa;
			}

			.faq-answer p {
				padding: 20px;
				color: #666;
				margin: 0;
			}

			/* 화살표 아이콘 */
			.arrow {
				transition: transform 0.3s;
				display: inline-block;
			}

			.active .arrow {
				transform: rotate(180deg);
			}
		</style>
	</head>

	<body>

		<div class="faq-container">
			<h2>자주 묻는 질문 (FAQ)</h2>

			<%-- 실제 개발 시에는 이 부분을 DB에서 가져온 리스트로 반복문(c:forEach 등)을 돌립니다 --%>
				<div class="faq-item">
					<button class="faq-question">
						Q1. 비밀번호를 잊어버렸어요. 어떻게 하나요?
						<span class="arrow">▼</span>
					</button>
					<div class="faq-answer">
						<p>로그인 화면 하단의 '비밀번호 찾기'를 클릭하신 후, 가입하신 이메일을 통해 임시 비밀번호를 발급받으실 수 있습니다.</p>
					</div>
				</div>

				<div class="faq-item">
					<button class="faq-question">
						Q2. 배송 기간은 얼마나 걸리나요?
						<span class="arrow">▼</span>
					</button>
					<div class="faq-answer">
						<p>결제 완료 후 평균 2~3일(영업일 기준) 이내에 배송이 시작됩니다. 도서 산간 지역은 추가 시일이 소요될 수 있습니다.</p>
					</div>
				</div>

				<div class="faq-item">
					<button class="faq-question">
						Q3. 환불 규정이 궁금합니다.
						<span class="arrow">▼</span>
					</button>
					<div class="faq-answer">
						<p>상품 수령 후 7일 이내에 고객센터나 마이페이지를 통해 반품 접수가 가능합니다. 단, 상품 가치가 훼손된 경우 환불이 어려울 수 있습니다.</p>
					</div>
				</div>
		</div>

		<script>
			document.querySelectorAll('.faq-question').forEach(button => {
				button.addEventListener('click', () => {
					const faqItem = button.parentElement;
					const answer = button.nextElementSibling;

					// 이미 열려있는 항목을 닫고 싶지 않다면 아래 '다른 항목 닫기' 로직은 제거하세요.
					// --- 다른 항목 닫기 시작 ---
					document.querySelectorAll('.faq-answer').forEach(item => {
						if (item !== answer) {
							item.style.maxHeight = null;
							item.parentElement.classList.remove('active');
						}
					});
					// --- 다른 항목 닫기 끝 ---

					// 현재 클릭한 항목 토글
					faqItem.classList.toggle('active');
					if (faqItem.classList.contains('active')) {
						answer.style.maxHeight = answer.scrollHeight + "px";
					} else {
						answer.style.maxHeight = null;
					}
				});
			});
		</script>

	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					// 변수 - (key : value)
				};
			},
			methods: {
				// 함수(메소드) - (key : function())
				fnList: function () {
					let self = this;
					let param = {};
					$.ajax({
						url: "http://localhost:8080/faq.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {

						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
			}
		});

		app.mount('#app');
	</script>