<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>온라인 문의 - 모닥모닥</title>
			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
			<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/inquiry/inquiry-form.css">
			<script src="/js/page-change.js"></script>


		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<div id="app" v-cloak>

					<!-- 헤더 -->
					<div class="inquiry-hero">
						<h1>온라인 문의 접수</h1>
						<p>궁금하신 사항을 남겨주시면 빠르게 답변드리겠습니다.</p>
					</div>

					<main class="inquiry-main">

						<div class="section-title">문의 접수</div>

						<!-- ===================== 폼 ===================== -->
						<div class="form-card">

							<!-- 입력 화면 -->
							<div v-if="!isSuccess">
								<!-- 이름 + 이메일 -->
								<div class="form-row">
									<div class="form-group">
										<label>이름</label>
										<input type="text" v-model="userName" @input="fnCheckUserName"
											placeholder="이름을 입력해주세요">
										<div class="field-error" v-if="errors.userName">{{ errors.userName }}</div>
									</div>

									<div class="form-group">
										<label>이메일</label>
										<input type="email" v-model="userEmail" @input="fnCheckEmail"
											placeholder="example@email.com">
										<div class="field-error" v-if="errors.userEmail">{{ errors.userEmail }}</div>
									</div>
								</div>

								<!-- 제목 + 유형 -->
								<div class="form-row">
									<div class="form-group">
										<label>제목</label>
										<input type="text" v-model="title" @change="fnCheckTitle"
											placeholder="문의 제목을 입력해주세요">
										<div class="field-error" v-if="errors.title">{{ errors.title }}</div>
									</div>

									<div class="form-group">
										<label>문의 유형</label>
										<select v-model="inquiryType" @change="fnCheckInquiryType">
											<option value="">선택</option>
											<option value="ORDER">주문</option>
											<option value="DELIVERY">배송</option>
											<option value="PRODUCT">상품</option>
											<option value="RETURN">교환/반품</option>
											<option value="ACCOUNT">회원/계정</option>
											<option value="OTHER">기타</option>
										</select>
										<div class="field-error" v-if="errors.inquiryType">{{ errors.inquiryType }}
										</div>
									</div>
								</div>

								<!-- 내용 -->
								<div class="form-group">
									<label>내용</label>
									<textarea v-model="content" @change="fnCheckContent"
										placeholder="문의 내용을 10자 이상 입력해주세요"></textarea>
									<div class="field-error" v-if="errors.content">{{ errors.content }}</div>
								</div>
								<!-- 이미지 첨부 -->
								<div class="form-group">
									<label>이미지 첨부</label>

									<!-- 숨김 input -->
									<input type="file" id="fileInput" @change="fnFileChange" multiple hidden>

									<!-- 버튼 (이모지 제거) -->
									<label for="fileInput" class="file-upload-btn">
										사진 첨부하기
									</label>

									<!-- 썸네일 영역 -->
									<div class="file-preview">
										<div v-for="(file, index) in previewList" :key="index" class="preview-item">

											<!-- 이미지 -->
											<img :src="file.url" class="preview-img">

											<!-- 삭제 버튼 -->
											<button type="button" class="preview-remove" @click="fnRemoveFile(index)">
												×
											</button>

										</div>
									</div>
								</div>
								<button class="btn-inquiry-submit" @click="fnSubmit">
									문의 접수하기
								</button>
							</div>

							<!-- 성공 화면 -->
							<div v-else class="inquiry-success-box">
								<div class="success-icon">
									<svg viewBox="0 0 52 52" class="check-svg">
										<circle class="check-circle" cx="26" cy="26" r="25" fill="none" />
										<path class="check-path" fill="none" d="M14 27l7 7 16-16" />
									</svg>
								</div>
								<h3 class="success-title">문의가 접수되었습니다.</h3>
								<p class="success-desc">
									남겨주신 문의는 담당자가 확인 후<br>
									등록하신 정보 기준으로 빠르게 안내드리겠습니다.
								</p>

								<div class="success-btn-row">
									<a href="/main.do" class="btn-go-main">메인으로 이동하기</a>
									<a href="/user/inquiry/history.do" class="btn-go-history">내 문의 내역 보기</a>
								</div>
							</div>

						</div>

						<!-- 하단 안내 -->
						<div class="inquiry-steps">
							<div class="step-card">
								<div class="step-num">1</div>
								<h4>문의 접수</h4>
								<p>양식을 작성하여<br>문의를 접수합니다.</p>
							</div>
							<div class="step-card">
								<div class="step-num">2</div>
								<h4>검토 및 처리</h4>
								<p>담당자가 내용을 확인하고<br>처리합니다.</p>
							</div>
							<div class="step-card">
								<div class="step-num">3</div>
								<h4>빠른 답변</h4>
								<p>적어도 24시간 이내에<br>답변을 드립니다.</p>
							</div>
						</div>

					</main>
				</div>

				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<!-- ===================== Vue ===================== -->
					<script>
						const app = Vue.createApp({
							data() {
								return {
									userName: "",
									userEmail: "",
									title: "",
									inquiryType: "",
									content: "",

									errors: {},
									isSuccess: false,
									files: [],
									previewList: []
								};
							},

							methods: {
								fnRemoveFile(index) {
									this.previewList.splice(index, 1);
									this.files = this.previewList.map(item => item.file);
								},
								fnFileChange(e) {
									const selectedFiles = Array.from(e.target.files);

									selectedFiles.forEach(file => {
										const reader = new FileReader();

										reader.onload = (event) => {
											this.previewList.push({
												file: file,
												url: event.target.result
											});

											this.files = this.previewList.map(item => item.file);
										};

										reader.readAsDataURL(file);
									});

									// 🔥 input 초기화 (같은 파일 다시 선택 가능)
									e.target.value = '';
								},
								fnSubmit() {
									let self = this;

									// 에러 초기화
									self.errors = {};

									// 🔥 검증
									if (!self.userName) {
										self.errors.userName = "이름을 입력해주세요";
									}

									if (!self.userEmail) {
										self.errors.userEmail = "이메일을 입력해주세요";
									} else {
										const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
										if (!emailRegex.test(self.userEmail.trim())) {
											self.errors.userEmail = "올바른 이메일 형식이 아닙니다";
										}
									}

									if (!self.title) {
										self.errors.title = "제목을 입력해주세요";
									}

									if (!self.inquiryType) {
										self.errors.inquiryType = "문의 유형을 선택해주세요";
									}

									if (!self.content || self.content.length < 10) {
										self.errors.content = "내용을 10자 이상 입력해주세요";
									}

									// 하나라도 있으면 중단
									if (Object.keys(self.errors).length > 0) {
										return;
									}

									let formData = new FormData();

									formData.append("userName", self.userName);
									formData.append("userEmail", self.userEmail);
									formData.append("title", self.title);
									formData.append("inquiryType", self.inquiryType);
									formData.append("content", self.content);

									// 🔥 파일 추가
									for (let i = 0; i < self.files.length; i++) {
										formData.append("files", self.files[i]);
									}


									// 🔥 서버 호출
									$.ajax({
										url: "/inquiry/add.dox",
										type: "POST",
										dataType: "json",
										data: formData,
										processData: false,
										contentType: false,
										success: function (res) {
											if (res.result === "success") {
												self.isSuccess = true;
											} else {
												self.errors.content = "접수 실패";
											}
										},
										error: function () {
											self.errors.content = "서버 오류";
										}
									});
								},
								fnCheckEmail() {
									let self = this;
									const email = self.userEmail.trim();

									if (!email) {
										delete self.errors.userEmail;
										return;
									}

									const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

									if (emailRegex.test(email)) {
										delete self.errors.userEmail;
									} else {
										self.errors.userEmail = "올바른 이메일 형식이 아닙니다";
									}
								},
								fnCheckUserName() {
									const value = this.userName.trim();

									if (value) {
										delete this.errors.userName;
									}
								},

								fnCheckEmail() {
									const email = this.userEmail.trim();
									const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

									if (!email) {
										delete this.errors.userEmail;
										return;
									}

									if (emailRegex.test(email)) {
										delete this.errors.userEmail;
									} else {
										this.errors.userEmail = "올바른 이메일 형식이 아닙니다";
									}
								},

								fnCheckTitle() {
									const value = this.title.trim();

									if (value) {
										delete this.errors.title;
									}
								},

								fnCheckInquiryType() {
									if (this.inquiryType) {
										delete this.errors.inquiryType;
									}
								},

								fnCheckContent() {
									const value = this.content.trim();

									if (!value) {
										delete this.errors.content;
										return;
									}

									if (value.length >= 10) {
										delete this.errors.content;
									}
								},
								fnEditInquiry: function (inquiryId) {
									pageChange("/user/inquiry/edit.do", { inquiryId: inquiryId });
								}

							}
						});

						app.mount('#app');
					</script>

		</body>

		</html>