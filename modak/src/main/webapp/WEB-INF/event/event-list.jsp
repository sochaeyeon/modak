<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Document</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<style>

		</style>
	</head>

	<body>
		<div id="app">
			<!-- html 코드는 id가 app인 태그 안에서 작업 -->
		</div>
		<div>
			<table>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>내용</th>
					<th>이벤트 시작일</th>
					<th>이벤트 종료일</th>
					<div class="event-period">
						<label>이벤트 기간:</label>
						<span>${event.startDate}</span> ~ <span>${event.endDate}</span>
					</div>
				</tr>
				<tr v-for="item in list">
					<td>{{item.eventId}}</td>
					<td>{{item.title}}</td>
					<td>{{item.content}}</td>
					<td>{{item.startDate}}</td>
					<td>{{item.endDate}}</td>
				</tr>
			</table>
		</div>
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					// 변수 - (키 : 값)
					list: []
				};
			},
			methods: {
				// 함수(메소드) - (key : function())
				fnList: function () {
					let self = this;
					let param = {
						// 백엔드로 전달할 데이터
					};
					$.ajax({
						url: "http://localhost:8080/event/list.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							console.log(data);
							self.list = data.list;
						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnList();
			}
		});

		app.mount('#app');
	</script>