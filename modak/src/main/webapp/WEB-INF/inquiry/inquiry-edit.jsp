<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>문의 수정 - 모닥모닥</title>

			<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
			<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
			<script src="/js/page-change.js"></script>


			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/inquiry/inquiry-form.css">

			<style>
				.field-error {
					font-size: 12px;
					color: #e8562a;
					margin-top: 4px;
					margin-left: 2px;
				}

				.edit-btn-row {
					display: flex;
					gap: 12px;
					margin-top: 20px;
				}

				.btn-sub {
					flex: 1;
					padding: 15px;
					border-radius: 10px;
					font-size: 15px;
					font-weight: 700;
					cursor: pointer;
					text-align: center;
					text-decoration: none;
					border: 1px solid rgba(139, 107, 74, 0.18);
					background: var(--white);
					color: var(--brown2);
					transition: all 0.2s ease;
				}

				.btn-sub:hover {
					transform: translateY(-1px);
				}
			</style>
		</head>

		<body>

			<%@ include file="/WEB-INF/common/header.jsp" %>

				<div id="app" v-cloak>
					<div class="inquiry-hero">
						<h1>문의 수정</h1>
						<p>등록한 문의 내용을 수정할 수 있습니다.</p>
					</div>

					<main class="inquiry-main">
						<div class="section-title">문의 수정</div>

						<div class="form-card">
							<div class="form-row">
								<div class="form-group">
									<label>이름</label>
									<input type="text" v-model="userName" readonly class="input-readonly">
								</div>

								<div class="form-group">
									<label>이메일</label>
									<input type="email" v-model="userEmail" readonly class="input-readonly">
								</div>
							</div>
							<div class="form-row">
								<div class="form-group">
									<label>제목</label>
									<input type="text" v-model="title" @input="fnCheckTitle"
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
									<div class="field-error" v-if="errors.inquiryType">{{ errors.inquiryType }}</div>
								</div>
							</div>

							<div class="form-group">
								<label>내용</label>
								<textarea v-model="content" @input="fnCheckContent"
									placeholder="문의 내용을 10자 이상 입력해주세요"></textarea>
								<div class="field-error" v-if="errors.content">{{ errors.content }}</div>
							</div>
							<div class="form-group">
								<label>이미지 첨부</label>

								<input type="file" id="editFileInput" @change="fnFileChange" multiple hidden>

								<label for="editFileInput" class="file-upload-btn">
									사진 첨부하기
								</label>

								<div class="file-preview">

									<!-- 기존 이미지 -->
									<div v-for="(img, index) in oldImageList" :key="'old-' + img.inquiryImgId"
										class="preview-item">

										<img :src="img.imgUrl" class="preview-img">

										<button type="button" class="preview-remove"
											@click="fnRemoveOldImage(index)">×</button>
									</div>

									<!-- 새 이미지 -->
									<div v-for="(file, index) in newPreviewList" :key="'new-' + index"
										class="preview-item">

										<img :src="file.url" class="preview-img">

										<button type="button" class="preview-remove"
											@click="fnRemoveNewFile(index)">×</button>
									</div>

								</div>
							</div>
							<div class="edit-btn-row">
								<button class="btn-inquiry-submit" @click="fnUpdate">수정 완료</button>
								<a href="/user/inquiry/history.do" class="btn-sub">취소</a>
							</div>
						</div>
					</main>
					<div class="toast" :class="{ show: toastVisible }">
						{{ toastMsg }}
					</div>

					<div v-if="confirmModalOpen" class="delete-modal-backdrop" @click.self="fnCloseConfirmModal"
						@keydown.enter.prevent="fnConfirmModalOk" @keydown.esc.prevent="fnCloseConfirmModal"
						tabindex="0" ref="confirmModal">

						<div class="delete-modal-box">
							<div class="delete-modal-title">{{ confirmTitle }}</div>
							<div class="delete-modal-desc">{{ confirmDesc }}</div>

							<div class="delete-modal-actions single">
								<button type="button" class="delete-confirm-btn" @click="fnConfirmModalOk">
									확인
								</button>
							</div>
						</div>
					</div>
				</div>

				<%@ include file="/WEB-INF/common/footer.jsp" %>

					<script>
						const app = Vue.createApp({
							data() {
								return {
									inquiryId: "${inquiryId}",
									userName: "",
									userEmail: "",
									title: "",
									inquiryType: "",
									content: "",
									errors: {},

									oldImageList: [],
									deletedImageIdList: [],
									newFiles: [],
									newPreviewList: [],
									toastVisible: false,
									toastMsg: "",

									confirmModalOpen: false,
									confirmTitle: "",
									confirmDesc: "",
									confirmAction: null
								};
							},
							methods: {
								showToast(msg) {
									this.toastMsg = msg;
									this.toastVisible = true;

									setTimeout(() => {
										this.toastVisible = false;
									}, 2000);
								},

								fnOpenConfirmModal(title, desc, action) {
									this.confirmTitle = title;
									this.confirmDesc = desc;
									this.confirmAction = action || null;
									this.confirmModalOpen = true;

									this.$nextTick(() => {
										this.$refs.confirmModal.focus();
									});
								},

								fnCloseConfirmModal() {
									this.confirmModalOpen = false;
									this.confirmTitle = "";
									this.confirmDesc = "";
									this.confirmAction = null;
								},

								fnConfirmModalOk() {
									const action = this.confirmAction;
									this.fnCloseConfirmModal();

									if (typeof action === "function") {
										action();
									}
								},
								fnFileChange(e) {
									const selectedFiles = Array.from(e.target.files);

									selectedFiles.forEach(file => {
										const reader = new FileReader();

										reader.onload = (event) => {
											this.newPreviewList.push({
												file: file,
												url: event.target.result
											});
											this.newFiles = this.newPreviewList.map(item => item.file);
										};

										reader.readAsDataURL(file);
									});

									e.target.value = '';
								},

								fnRemoveOldImage(index) {
									const removed = this.oldImageList[index];
									if (removed && removed.inquiryImgId) {
										this.deletedImageIdList.push(removed.inquiryImgId);
									}
									this.oldImageList.splice(index, 1);
								},

								fnRemoveNewFile(index) {
									this.newPreviewList.splice(index, 1);
									this.newFiles = this.newPreviewList.map(item => item.file);
								},
								fnCheckTitle() {
									if (this.title.trim()) {
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
								fnUpdate() {
									let self = this;
									self.errors = {};

									if (!self.title.trim()) {
										self.errors.title = "제목을 입력해주세요";
									}

									if (!self.inquiryType) {
										self.errors.inquiryType = "문의 유형을 선택해주세요";
									}

									if (!self.content.trim() || self.content.trim().length < 10) {
										self.errors.content = "내용을 10자 이상 입력해주세요";
									}

									if (Object.keys(self.errors).length > 0) {
										return;
									}

									let formData = new FormData();
									formData.append("inquiryId", self.inquiryId);
									formData.append("title", self.title);
									formData.append("inquiryType", self.inquiryType);
									formData.append("content", self.content);

									for (let i = 0; i < self.newFiles.length; i++) {
										formData.append("files", self.newFiles[i]);
									}

									for (let i = 0; i < self.deletedImageIdList.length; i++) {
										formData.append("deletedImageIdList", self.deletedImageIdList[i]);
									}

									$.ajax({
										url: "/user/inquiry/edit.dox",
										type: "POST",
										dataType: "json",
										data: formData,
										processData: false,
										contentType: false,
										success: function (data) {
											if (data.result === "success") {
												self.showToast("문의가 수정되었습니다.");

												setTimeout(function () {
													location.href = "/user/inquiry/history.do";
												}, 900);

											} else if (data.result === "loginRequired") {
												self.fnOpenConfirmModal(
													"로그인이 필요한 서비스입니다",
													"로그인 페이지로 이동하시겠습니까?",
													function () {
														location.href = "/user/login.do";
													}
												);

											} else {
												self.showToast(data.message || "수정에 실패했습니다.");
											}
										},
										error: function () {
											self.showToast("서버 오류가 발생했습니다.");
										}
									});
								},
								fnGetInquiryDetail() {
									let self = this;

									$.ajax({
										url: "/user/inquiry/detail.dox",
										type: "POST",
										dataType: "json",
										data: {
											inquiryId: self.inquiryId
										},
										success: function (data) {
											if (data.result === "success") {
												const inquiry = data.inquiry;

												self.userName = inquiry.userName || "";
												self.userEmail = inquiry.userEmail || "";
												self.title = inquiry.title || "";
												self.inquiryType = (inquiry.inquiryType || "").trim();
												self.content = inquiry.content || "";

												self.oldImageList = inquiry.imageList || [];
												self.deletedImageIdList = [];
												self.newFiles = [];
												self.newPreviewList = [];
											} else {
												self.fnOpenConfirmModal(
													"문의 정보를 불러올 수 없습니다",
													data.message || "내 문의 내역으로 이동합니다.",
													function () {
														location.href = "/user/inquiry/history.do";
													}
												);
											}
										},
										error: function () {
											self.fnOpenConfirmModal(
												"서버 오류가 발생했습니다",
												"내 문의 내역으로 이동합니다.",
												function () {
													location.href = "/user/inquiry/history.do";
												}
											);
										}
									});
								},
							},
							mounted() {
								let self = this;
								console.log("inquiryId =", this.inquiryId);

								this.fnGetInquiryDetail();
							},
						});
						app.mount("#app");
					</script>

		</body>

		</html>