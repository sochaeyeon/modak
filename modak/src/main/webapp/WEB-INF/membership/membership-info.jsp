<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<title>멤버십 등급 안내 - 모닥모닥</title>
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/membership/membership-info.css">
			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
			<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
			<script src="/js/page-change.js"></script>

		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<div id="app" v-cloak>
					<div class="wrap">

						<!-- HERO -->
						<section class="hero">
							<div class="hero-badge">
								<i class="ri-vip-crown-line"></i>
								모닥모닥 멤버십
							</div>
							<h1>대여할수록 커지는<br><span>나만의 캠핑 혜택</span></h1>
							<p>등급이 올라갈수록 더 큰 할인, 더 많은 포인트,<br>더 빠른 예약을 누려보세요.</p>
						</section>

						<!-- 내 등급 (로그인 시) -->
						<section class="my-grade" v-if="isLoggedIn && myInfo && myInfo.gradeId">
							<div class="grade-icon" :class="fnGradeClass(myInfo.gradeName)">
								<i :class="fnGradeIcon(myInfo.gradeName)"></i>
							</div>
							<div class="grade-meta">
								<div class="label">현재 나의 등급</div>
								<div class="name">{{ myInfo.gradeName }} 회원</div>
							</div>
							<div class="progress-wrap">
								<div class="progress-label">
									<span>{{ nextGrade ? nextGrade.gradeName + '까지' : '최고 등급 달성!' }}</span>
									<span v-if="nextGrade">
										누적 {{ fnPrice(myInfo.totalAmount) }} / {{ fnPrice(nextGrade.minAmount) }}
									</span>
									<span v-else>누적 {{ fnPrice(myInfo.totalAmount) }}</span>
								</div>
								<div class="progress-bar">
									<div class="progress-fill"
										:style="{width: progressReady ? progressPercent + '%' : '0%'}"></div>
								</div>
							</div>
							<div class="grade-points">
								<div class="pts">{{ fnPoint(myInfo.point) }}</div>
								<div class="pts-label">보유 포인트</div>
							</div>
						</section>

						<!-- 등급 안내 -->
						<h3 class="section-title">멤버십 등급 안내</h3>
						<section class="grade-grid">
							<div v-for="g in grades" :key="g.gradeId" class="grade-card"
								:class="[fnGradeClass(g.gradeName), {current: myInfo && Number(myInfo.gradeId) === Number(g.gradeId)}]">
								<span class="shine-box"></span>
								<div v-if="myInfo && Number(myInfo.gradeId) === Number(g.gradeId)"
									class="current-label">
									현재 등급
								</div>
								<div class="grade-symbol">
									<i :class="fnGradeIcon(g.gradeName)"></i>
								</div>
								<div class="grade-name">{{ g.gradeName }}</div>
								<div class="grade-cond">
									{{ Number(g.minAmount) > 0 ? '누적 ' + fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}
								</div>
								<div class="grade-perks" v-if="g.benefitText">
									<div class="perk" v-for="b in fnSplitBenefits(g.benefitText)" :key="b">
										<span class="perk-dot"></span>
										<span>{{ b }}</span>
									</div>
								</div>
							</div>
						</section>

						<!-- 혜택 비교 테이블 — DB 데이터 기반 -->
						<h3 class="section-title">등급별 혜택 비교</h3>
						<section class="benefit-table-wrap">
							<table class="benefit-table">
								<thead>
									<tr>
										<th>혜택 항목</th>
										<th v-for="g in grades" :key="g.gradeId"
											:class="myInfo && Number(myInfo.gradeId) === Number(g.gradeId) ? 'highlight-col' : ''">
											<i :class="fnGradeIcon(g.gradeName)"></i>
											{{ g.gradeName }}
										</th>
									</tr>
								</thead>
								<tbody>
									<!-- 혜택 행 — benefitMatrix 에서 동적 생성 -->
									<tr v-for="row in benefitMatrix" :key="row.label">
										<td>{{ row.label }}</td>
										<td v-for="(val, i) in row.values" :key="i">{{ val }}</td>
									</tr>
								</tbody>
							</table>
						</section>

						<!-- 포인트 적립 방법 -->
						<h3 class="section-title">포인트 적립 방법</h3>
						<section class="point-section">
							<div class="point-grid">
								<div class="point-card" v-for="pt in pointMethods" :key="pt.icon">
									<div class="point-icon">
										<i :class="pt.icon"></i>
									</div>
									<div>
										<h4>{{ pt.title }}</h4>
										<p>{{ pt.desc }}</p>
										<div class="rate">{{ pt.rate }}</div>
									</div>
								</div>
							</div>
						</section>

						<!-- FAQ -->
						<h3 class="section-title">자주 묻는 질문</h3>
						<section>
							<div class="faq-list" v-if="faqs.length > 0">
								<div class="faq-item" v-for="(f, idx) in faqs" :key="f.faqId || idx"
									:class="{open: openFaq === idx}">
									<div class="faq-q" @click="fnToggleFaq(idx)">
										<span>{{ f.question }}</span>
										<span class="arrow">
											<i class="ri-arrow-down-s-line"></i>
										</span>
									</div>
									<div class="faq-a">{{ f.answer }}</div>
								</div>
							</div>
							<div class="faq-empty" v-else>등록된 FAQ가 없습니다.</div>
						</section>

						<!-- CTA -->
						<section class="cta">
							<div class="cta-text">
								<h3>지금 바로 시작하세요</h3>
								<p>가입만 해도 브론즈 혜택 즉시 적용, 첫 대여 시 추가 5% 할인</p>
							</div>
							<div class="cta-btns">
								<button class="btn-join" v-if="!isLoggedIn" @click="fnGoSignUp">회원가입하고 혜택 받기</button>
								<button class="btn-login" @click="fnGoProductList">장비 둘러보기</button>
							</div>
						</section>

					</div>

				</div>
				<button type="button" id="topBtn" class="top-btn">
					<i class="ri-arrow-up-line"></i>
				</button>
				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<script>
						var app = Vue.createApp({
							data: function () {
								return {
									isLoggedIn: false,
									myInfo: {},
									grades: [],
									faqs: [],
									openFaq: null,
									progressReady: false,

									/* 포인트 적립 방법 — 변경 가능성 낮아 정적 유지 */
									pointMethods: [
										{icon: 'ri-box-3-line', title: '장비 대여', desc: '대여 금액에 따라 포인트 적립', rate: '최대 5%'},
										{icon: 'ri-star-smile-line', title: '리뷰 작성', desc: '사진 리뷰 작성 시 포인트 지급', rate: '+200P'},
										{icon: 'ri-user-shared-line', title: '친구 초대', desc: '친구 가입 완료 시 포인트 지급', rate: '+1,000P'},
										{icon: 'ri-cake-2-line', title: '생일 보너스', desc: '생일 달에 쿠폰 또는 포인트 지급', rate: '+500P'},
										{icon: 'ri-calendar-check-line', title: '출석 혜택', desc: '매일 출석 시 포인트 적립', rate: '+10P / 일'}
									]
								};
							},

							computed: {
								/* 다음 등급 */
								nextGrade: function () {
									if (!this.myInfo || !this.grades.length) return null;
									var total = Number(this.myInfo.totalAmount || 0);
									for (var i = 0; i < this.grades.length; i++) {
										if (Number(this.grades[i].minAmount || 0) > total) return this.grades[i];
									}
									return null;
								},

								/* 프로그레스 % */
								progressPercent: function () {
									if (!this.myInfo || !this.grades.length) return 0;
									if (!this.nextGrade) return 100;
									var total = Number(this.myInfo.totalAmount || 0);
									var prev = 0;
									for (var i = 0; i < this.grades.length; i++) {
										if (Number(this.grades[i].gradeId) === Number(this.myInfo.gradeId)) {
											prev = Number(this.grades[i].minAmount || 0); break;
										}
									}
									var next = Number(this.nextGrade.minAmount || 0);
									var range = next - prev;
									if (range <= 0) return 0;
									var pct = ((total - prev) / range) * 100;
									return Math.min(100, Math.max(0, pct));
								},

								/* 혜택 비교 테이블 — benefitText 를 파싱해서 매트릭스 생성 */
								benefitMatrix: function () {
									if (!this.grades.length) return [];

									/* 각 등급의 혜택 배열 */
									var benefitArrays = this.grades.map(function (g) {
										return (g.benefitText || '').split(',').map(function (v) {return v.trim();}).filter(Boolean);
									});

									/* 최대 항목 수 */
									var maxLen = 0;
									benefitArrays.forEach(function (arr) {if (arr.length > maxLen) maxLen = arr.length;});

									/* 행 구성 */
									var rows = [];

									/* 할인율 행은 별도로 (discountRate 컬럼 활용) */
									var hasDiscount = this.grades.some(function (g) {return Number(g.discountRate) > 0;});
									if (hasDiscount) {
										rows.push({
											label: '대여 상시 할인',
											values: this.grades.map(function (g) {
												return Number(g.discountRate) > 0 ? Number(g.discountRate) + '%' : '—';
											})
										});
									}

									/* benefitText 항목들을 행으로 */
									for (var i = 0; i < maxLen; i++) {
										var idx = i;
										/* 라벨: 가장 마지막 등급(VVIP) 기준으로 라벨 추출 시도 */
										var label = '';
										for (var g = this.grades.length - 1; g >= 0; g--) {
											if (benefitArrays[g][idx]) {label = benefitArrays[g][idx]; break;}
										}
										/* 라벨에서 숫자/단위 제거해서 항목명만 추출 */
										var cleanLabel = label.replace(/\d+(%|P|장|회|배|일|개|만원|원)/g, '').replace(/\s+/g, '').trim();
										if (!cleanLabel) cleanLabel = '혜택 ' + (i + 1);

										rows.push({
											label: cleanLabel,
											values: this.grades.map(function (g, gi) {
												return benefitArrays[gi][idx] || '—';
											})
										});
									}
									return rows;
								}
							},

							methods: {
								/* 멤버십 정보 로드 (내 정보 + 전체 등급) */
								fnLoadInfo: function () {
									var self = this;
									$.ajax({
										url: '/membership/info.dox', type: 'POST', dataType: 'json',
										success: function (res) {
											if (res.result === 'success' && res.info && res.info.gradeId) {
												/* ★ 로그인 성공 */
												self.isLoggedIn = true;
												self.myInfo = res.info || {};
												/* allGrades 포함 여부에 따라 분기 */
												if (res.allGrades && res.allGrades.length) {
													self.grades = res.allGrades.map(function (g) {
														g.gradeId = Number(g.gradeId);
														g.minAmount = Number(g.minAmount || 0);
														g.discountRate = Number(g.discountRate || 0);
														return g;
													}); self.progressReady = false;

													setTimeout(function () {
														self.progressReady = true;
													}, 150);
												} else {
													self.fnLoadGrades();
												}
											} else {
												/* ★ 비로그인 또는 정보 없음 — 등급 목록만 */
												self.isLoggedIn = false;
												self.fnLoadGrades();
											}
										},
										error: function () {
											self.isLoggedIn = false;
											self.fnLoadGrades();
										}
									});
								},

								/* 등급 목록 단독 로드 */
								fnLoadGrades: function (animateProgress) {
									var self = this;
									$.ajax({
										url: '/membership/grade/list.dox',
										type: 'POST',
										dataType: 'json',
										success: function (res) {
											if (res.result === 'success') {
												self.grades = (res.grades || []).map(function (g) {
													g.gradeId = Number(g.gradeId);
													g.minAmount = Number(g.minAmount || 0);
													g.discountRate = Number(g.discountRate || 0);
													return g;
												});

												if (animateProgress) {
													self.progressReady = false;
													setTimeout(function () {
														self.progressReady = true;
													}, 200);
												}
											}
										}
									});
								},

								/* FAQ 로드 */
								fnLoadFaq: function () {
									var self = this;
									$.ajax({
										url: '/membership/faq/list.dox', type: 'POST', dataType: 'json',
										success: function (res) {
											if (res.result === 'success') self.faqs = res.faqs || [];
										}
									});
								},

								fnToggleFaq: function (idx) {
									this.openFaq = this.openFaq === idx ? null : idx;
								},

								fnSplitBenefits: function (text) {
									if (!text) return [];
									return text.split(',').map(function (v) {return v.trim();}).filter(Boolean);
								},

								fnGradeIcon: function (name) {
									var m = {
										'브론즈': 'ri-medal-line',
										'실버': 'ri-award-line',
										'골드': 'ri-vip-crown-line',
										'VVIP': 'ri-vip-diamond-line'
									};
									return m[name] || 'ri-tent-line';
								},
								fnGradeClass: function (name) {
									var m = {'브론즈': 'bronze', '실버': 'silver', '골드': 'gold', 'VVIP': 'vvip'};
									return m[name] || '';
								},
								fnPrice: function (v) {return Number(v || 0).toLocaleString() + '원';},
								fnPoint: function (v) {return Number(v || 0).toLocaleString() + 'P';},
								fnGoSignUp: function () {
									window.location.href = '/user/sign-up.do';
								},
								fnGoProductList: function () {
									window.location.href = '/product/list.do';
								}
							},

							mounted: function () {
								this.fnLoadInfo();
								this.fnLoadFaq();
							}
						});
						app.mount('#app');
					</script>
		</body>

		</html>