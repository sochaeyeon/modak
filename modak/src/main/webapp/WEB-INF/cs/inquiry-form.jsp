<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>문의하기</title>
		<style>
			body {
				font-family: 'Malgun Gothic', sans-serif;
				background-color: #f4f7f6;
				display: flex;
				justify-content: center;
				padding: 50px;
			}

			.container {
				background: white;
				padding: 30px;
				border-radius: 8px;
				box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
				width: 400px;
			}

			h2 {
				text-align: center;
				color: #333;
			}

			.form-group {
				margin-bottom: 15px;
			}

			label {
				display: block;
				margin-bottom: 5px;
				font-weight: bold;
			}

			input[type="text"],
			input[type="email"],
			textarea {
				width: 100%;
				padding: 10px;
				border: 1px solid #ddd;
				border-radius: 4px;
				box-sizing: border-box;
			}

			textarea {
				height: 100px;
				resize: none;
			}

			button {
				width: 100%;
				padding: 10px;
				background-color: #2ecc71;
				border: none;
				color: white;
				font-size: 16px;
				border-radius: 4px;
				cursor: pointer;
			}

			button:hover {
				background-color: #27ae60;
			}

			.result {
				margin-top: 20px;
				padding: 15px;
				background-color: #e8f5e9;
				border-left: 5px solid #2ecc71;
			}
		</style>
	</head>

	<body>

		<div class="container">
			<h2>Inquiry Form</h2>

			<%-- 폼 제출 여부 확인 및 데이터 처리 --%>
				<% request.setCharacterEncoding("UTF-8"); String name=request.getParameter("name"); String
					email=request.getParameter("email"); String subject=request.getParameter("subject"); String
					content=request.getParameter("content"); if (name !=null && !name.isEmpty()) { %>
					<div class="result">
						<strong>문의가 성공적으로 접수되었습니다!</strong><br>
						<p>보낸 사람: <%= name %> (<%= email %>)</p>
						<p>제목: <%= subject %>
						</p>
					</div>
					<% } %>

						<form action="inquiry-form.jsp" method="post">
							<div class="form-group">
								<label for="name">이름</label>
								<input type="text" id="name" name="name" required>
							</div>

							<div class="form-group">
								<label for="email">이메일</label>
								<input type="email" id="email" name="email" required>
							</div>

							<div class="form-group">
								<label for="subject">제목</label>
								<input type="text" id="subject" name="subject" required>
							</div>

							<div class="form-group">
								<label for="content">문의 내용</label>
								<textarea id="content" name="content" required></textarea>
							</div>

							<button type="submit">문의하기 제출</button>
						</form>
		</div>

	</body>

	</html>