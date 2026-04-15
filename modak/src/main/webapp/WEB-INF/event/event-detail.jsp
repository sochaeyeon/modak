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
			<div>
				번호 : {{info.eventId}}
			</div>
			<div>
				제목 : {{info.title}}
			</div>
			<div>
				내용 : {{info.content}}
			</div>
			<div>
				시작일 : {{info.startDate}}
			</div>
			<div>
				중료일 : {{info.endDate}}
			</div>
		</div>
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					eventId: "${map.eventId}",
					info: {}
				};
			},
			methods: {
				// 함수(메소드) - (key : function())

				fnGetInfo: function () {
					let self = this;
					let param = {
						eventId: self.eventId
					};
					$.ajax({
						url: "http://localhost:8080/event/detail.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							console.log(data);
							self.info = data.info;
						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnGetInfo();
			}
		});

		app.mount('#app');
	</script>