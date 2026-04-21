<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>자주 묻는 질문 - 모닥모닥</title>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>

		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs/faq.css">
	</head>

	<body>

		<div id="app" class="faq-wrap">
			<div class="eyebrow">FAQ</div>
			<h1 class="faq-title">자주 묻는 질문</h1>

			<div class="faq-layout">
				<aside class="faq-sidebar">
					<ul>
						<li v-for="menu in sideMenus" :class="{active: selectSide === menu}"
							@click="fnChangeSide(menu)">{{ menu }}</li>
					</ul>
				</aside>

				<main class="faq-main">
					<div class="faq-tabs">
						<div v-for="tab in topTabs" class="faq-tab" :class="{active: selectTab === tab}"
							@click="fnChangeTab(tab)">{{ tab }}</div>
					</div>

					<div class="faq-list">
						<div v-for="(item, index) in faqList" :key="item.faqId" class="faq-item"
							:class="{active: activeIndex === index}">

							<div class="faq-question" @click="fnToggle(index)">
								<span class="q-text">{{ item.question }}</span>
								<span class="q-arrow"></span>
							</div>

							<div class="faq-answer">
								<div class="answer-inner" v-html="item.anwser"></div>
							</div>
						</div>

						<div v-if="faqList.length == 0" style="padding: 100px; text-align: center; color: #ccc;">
							등록된 질문이 없습니다.
						</div>
					</div>
				</main>
			</div>
		</div>

		<script>
			var app = new Vue({
				el: '#app',
				data: {
					sideMenus: ['전체', '서비스 안내', '요금 / 결제', '회원 / 계정', '기타 문의'],
					topTabs: ['전체', '서비스', '요금', '계정'],
					selectSide: '전체',
					selectTab: '전체',
					faqList: [],
					activeIndex: null
				},
				methods: {
					fnGetList: function () {
						var self = this;
						// 이미지의 Controller 주소인 /faq.dox 사용
						$.ajax({
							url: "/faq.dox",
							type: "POST",
							dataType: "json",
							// Mapper에서 사용하는 category 파라미터 전송
							data: {category: self.selectTab === '전체' ? '' : self.selectTab},
							success: function (data) {
								// FaqService에서 반환한 resultMap의 "list" 매핑
								self.faqList = data.list;
								self.activeIndex = null;
							}
						});
					},
					fnToggle: function (index) {
						this.activeIndex = (this.activeIndex === index) ? null : index;
					},
					fnChangeSide: function (menu) {
						this.selectSide = menu;
						this.fnGetList();
					},
					fnChangeTab: function (tab) {
						this.selectTab = tab;
						this.fnGetList();
					}
				},
				mounted: function () {
					this.fnGetList();
				}
			});
		</script>

	</body>

	</html>