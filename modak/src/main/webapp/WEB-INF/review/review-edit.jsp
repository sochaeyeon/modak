<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>모닥모닥 - 리뷰 수정</title>
                <link rel="stylesheet" href="/css/review/review-edit.css">
                <script src="https://code.jquery.com/jquery-3.7.1.js"
                    integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
                <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                <script src="/js/page-change.js"></script>
            </head>

            <body>
                <div id="app">
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <main>
                            <h1 class="page-title">리뷰 수정</h1>
                            <p class="page-subtitle">✦ 작성한 후기를 수정하고 다시 저장할 수 있어요 🔥</p>

                            <!-- 상품 정보 -->
                            <div class="card product-card review-edit-card">
                                <div class="product-info">
                                    <div class="product-thumb">
                                        <img v-if="reviewInfo.imageUrl"
                                            :src="reviewInfo.imageUrl.startsWith('/') ? reviewInfo.imageUrl : '/' + reviewInfo.imageUrl"
                                            :alt="reviewInfo.productName"
                                            style="width:100%; height:100%; object-fit:cover;">
                                        <span v-else>🏕️</span>
                                    </div>

                                    <div>
                                        <div class="product-name">
                                            {{ reviewInfo.productName || '상품명' }}
                                        </div>
                                        <div class="product-meta">
                                            리뷰번호 {{ reviewId }} · 수정일 {{ reviewInfo.updatedAt || reviewInfo.createdAt ||
                                            '-' }}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 별점 -->
                            <div class="card" ref="ratingCard">
                                <div class="section-label">
                                    별점 <span class="required-badge">필수</span>
                                </div>

                                <div class="star-row">
                                    <button v-for="n in 5" :key="n" class="star-btn" @click="setRating(n)"
                                        @mouseover="hoverRating = n" @mouseleave="hoverRating = 0"
                                        :aria-label="n + '점'">
                                        <span
                                            :style="{ color: (hoverRating || rating) >= n ? 'var(--star-filled)' : 'var(--star-empty)' }">★</span>
                                    </button>

                                    <span class="star-hint">{{ ratingLabel }}</span>
                                </div>

                                <div v-if="ratingErrorMsg" class="review-error-msg">
                                    {{ ratingErrorMsg }}
                                </div>
                            </div>

                            <!-- 제목 -->
                            <div class="card" ref="titleCard">
                                <div class="section-label">
                                    제목 <span class="required-badge">필수</span>
                                </div>

                                <input type="text" class="review-title-input" ref="titleInput" v-model="title"
                                    @input="titleErrorMsg = ''" placeholder="한 줄로 리뷰를 요약해보세요">

                                <div v-if="titleErrorMsg" class="review-error-msg">
                                    {{ titleErrorMsg }}
                                </div>
                            </div>

                            <!-- 리뷰 작성 -->
                            <div class="card">
                                <div class="section-label">
                                    리뷰 작성 <span class="required-badge">필수</span>
                                </div>

                                <textarea class="review-textarea" ref="reviewTextarea" v-model="reviewText"
                                    @input="reviewErrorMsg = ''" placeholder="상품에 대한 솔직한 후기를 남겨주세요.&#10;(최소 10자 이상)"
                                    maxlength="1000"></textarea>

                                <div v-if="reviewErrorMsg" class="review-error-msg">
                                    {{ reviewErrorMsg }}
                                </div>

                                <div class="char-count">
                                    <span>{{ reviewText.length }}</span> / 1000
                                </div>
                            </div>

                            <div class="card">
                                <div class="section-label">
                                    사진 첨부
                                    <span style="font-weight:400;color:var(--text-muted);font-size:0.75rem;">최대
                                        5장</span>
                                </div>

                                <div class="photo-area">
                                    <label class="photo-add-btn" style="cursor:pointer;" v-if="mergedPhotos.length < 5">
                                        <input type="file" accept="image/*" multiple style="display:none"
                                            @change="addPhotos" />
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="1.5">
                                            <rect x="3" y="3" width="18" height="18" rx="2" />
                                            <circle cx="8.5" cy="8.5" r="1.5" />
                                            <polyline points="21 15 16 10 5 21" />
                                        </svg>
                                        <span class="photo-add-label">사진 추가</span>
                                    </label>

                                    <div class="photo-wrapper" v-for="(photo, i) in mergedPhotos" :key="photo.key">
                                        <img class="photo-preview" :src="photo.imgUrl" alt="리뷰 사진" />
                                        <button class="photo-remove" @click="removeMergedPhoto(photo)">✕</button>
                                    </div>
                                </div>

                                <div class="photo-footer">
                                    {{ mergedPhotos.length }} / 5장 · JPG, PNG, WEBP 가능
                                </div>
                            </div>

                            <!-- 안내 -->
                            <div class="point-box review-edit-guide">
                                <div class="point-row">
                                    <span class="point-icon">ℹ</span>
                                    <span>
                                        리뷰 수정 시 포인트는 추가 적립되지 않습니다.<br />
                                        새 사진을 업로드하면 기존 사진은 교체됩니다.
                                    </span>
                                </div>
                            </div>

                            <!-- 버튼 -->
                            <div class="btn-row">
                                <button class="btn-cancel" @click="handleCancel">취소</button>
                                <button class="btn-submit" @click="fnEdit">
                                    ✓ 리뷰 수정하기
                                </button>
                            </div>
                        </main>

                        <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>
            </body>

            </html>

            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            reviewId: '${param.reviewId}',

                            reviewInfo: {
                                reviewId: '',
                                productId: '',
                                itemId: '',
                                productName: '',
                                imageUrl: '',
                                createdAt: '',
                                updatedAt: '',
                                title: '',
                                rating: 0,
                                content: '',
                                imageList: []
                            },

                            title: '',
                            rating: 0,
                            hoverRating: 0,
                            reviewText: '',

                            existingPhotos: [],
                            photos: [],
                            photoFiles: [],

                            toastVisible: false,
                            toastMsg: '',

                            titleErrorMsg: '',
                            ratingErrorMsg: '',
                            reviewErrorMsg: '',

                            ratingLabels: ['', '별로예요', '그럭저럭이에요', '보통이에요', '좋아요', '최고예요!'],
                        };
                    },
                    computed: {
                        ratingLabel: function () {
                            const val = this.hoverRating || this.rating;
                            return val ? this.ratingLabels[val] : '별점을 선택하세요';
                        },
                        mergedPhotos: function () {
                            const oldList = this.existingPhotos.map(function (photo) {
                                return {
                                    key: 'old-' + photo.imgId,
                                    imgId: photo.imgId,
                                    imgUrl: photo.imgUrl,
                                    type: 'existing'
                                };
                            });

                            const newList = this.photos.map(function (photo, idx) {
                                return {
                                    key: 'new-' + idx,
                                    imgUrl: photo,
                                    newIndex: idx,
                                    type: 'new'
                                };
                            });

                            return oldList.concat(newList);
                        }
                    },
                    methods: {
                        fnGetReviewInfo: function () {
                            let self = this;

                            $.ajax({
                                url: "/user/review/info.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    reviewId: self.reviewId
                                },
                                success: function (data) {
                                    if (data.result === "success") {
                                        const info = data.info || {};

                                        self.reviewInfo = info;

                                        self.title = info.title || '';
                                        self.rating = Number(info.rating || 0);
                                        self.reviewText = info.content || '';

                                        // 🔥 여기에서 세팅해야 정상
                                        self.existingPhotos = (info.imageList || []).map(function (img) {
                                            return {
                                                imgId: img.imgId,
                                                imgUrl: img.imgUrl
                                            };
                                        });

                                    } else {
                                        alert(data.message || "리뷰 정보를 불러오지 못했습니다.");
                                        pageChange("/user/review/history.do", {});
                                    }
                                },
                                error: function () {
                                    alert("리뷰 정보를 불러오는 중 오류가 발생했습니다.");
                                }
                            });
                        },

                        setRating: function (n) {
                            let self = this;
                            self.rating = n;
                            self.ratingErrorMsg = '';
                        },

                        addPhotos: function (e) {
                            let self = this;
                            const files = Array.from(e.target.files);
                            const remaining = 5 - self.mergedPhotos.length;

                            files.slice(0, remaining).forEach(function (file) {
                                self.photoFiles.push(file);

                                const reader = new FileReader();
                                reader.onload = function (ev) {
                                    self.photos.push(ev.target.result);
                                };
                                reader.readAsDataURL(file);
                            });

                            e.target.value = '';
                        },

                        removeMergedPhoto: function (photo) {
                            let self = this;

                            if (photo.type === 'existing') {
                                self.existingPhotos = self.existingPhotos.filter(function (item) {
                                    return item.imgId !== photo.imgId;
                                });
                            } else {
                                self.photos.splice(photo.newIndex, 1);
                                self.photoFiles.splice(photo.newIndex, 1);
                            }
                        },

                        showToast: function (msg) {
                            let self = this;
                            self.toastMsg = msg;
                            self.toastVisible = true;
                            setTimeout(function () {
                                self.toastVisible = false;
                            }, 2500);
                        },

                        scrollToRef: function (refName) {
                            let self = this;
                            const el = self.$refs[refName];
                            if (!el) return;

                            el.scrollIntoView({
                                behavior: "smooth",
                                block: "center"
                            });

                            if (refName === "reviewTextarea" || refName === "titleInput") {
                                setTimeout(function () {
                                    el.focus();
                                }, 300);
                            }
                        },

                        fnEdit: function () {
                            let self = this;

                            self.titleErrorMsg = '';
                            self.ratingErrorMsg = '';
                            self.reviewErrorMsg = '';

                            if (!self.title.trim()) {
                                self.titleErrorMsg = "제목을 입력해주세요.";
                                self.scrollToRef("titleInput");
                                return;
                            }

                            if (self.rating <= 0) {
                                self.ratingErrorMsg = "별점을 선택해주세요.";
                                self.scrollToRef("ratingCard");
                                return;
                            }

                            if (self.reviewText.trim().length < 10) {
                                if (self.reviewText.trim() !== (self.reviewInfo.content || '').trim()) {
                                    self.reviewErrorMsg = "리뷰 내용은 최소 10자 이상 입력해주세요.";
                                    self.scrollToRef("reviewTextarea");
                                    return;
                                }
                            }

                            let formData = new FormData();
                            formData.append("reviewId", self.reviewId);
                            formData.append("title", self.title);
                            formData.append("rating", self.rating);
                            formData.append("content", self.reviewText);

                            let keepIds = self.existingPhotos.map(function (photo) {
                                return photo.imgId;
                            });

                            formData.append("keepImgIds", JSON.stringify(keepIds));
                            
                            for (let i = 0; i < self.photoFiles.length; i++) {
                                formData.append("files", self.photoFiles[i]);
                            }

                            $.ajax({
                                url: "/user/review/edit.dox",
                                type: "POST",
                                data: formData,
                                processData: false,
                                contentType: false,
                                dataType: "json",
                                success: function (data) {
                                    if (data.result === "success") {
                                        self.showToast("리뷰가 수정되었습니다.");
                                        setTimeout(function () {
                                            pageChange("/user/review/history.do", {});
                                        }, 1000);
                                    } else {
                                        alert(data.message || "리뷰 수정에 실패했습니다.");
                                    }
                                },
                                error: function () {
                                    alert("리뷰 수정 중 오류가 발생했습니다.");
                                }
                            });
                        },

                        handleCancel: function () {
                            if (confirm("수정 중인 내용이 저장되지 않습니다. 취소하시겠어요?")) {
                                pageChange("/user/review/history.do", {});
                            }
                        }
                    },
                    mounted() {
                        this.fnGetReviewInfo();
                    }
                });

                app.mount('#app');
            </script>