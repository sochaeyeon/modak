<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 리뷰수정</title>
    <link rel="stylesheet" href="/css/review/review-edit.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>
    <div id="app">
        <!-- MAIN -->
        <main>
            <!-- 페이지 헤더 -->
            <div class="page-header">
            <div>
                <h1 class="page-title">리뷰 수정</h1>
                <p class="page-subtitle">작성일 2026.03.28 · 수정은 1회만 가능합니다</p>
            </div>
            <button class="btn-delete-review" @click="showDeleteModal = true">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                리뷰 삭제
            </button>
            </div>
        
            <!-- 수정됨 배너 -->
            <div class="changed-banner" v-if="hasChanges">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            수정된 내용이 있습니다. 저장 전에 확인해 주세요.
            </div>
        
            <!-- 상품 정보 -->
            <div class="card product-card">
            <div class="product-info">
                <div class="product-thumb">🏕️</div>
                <div>
                <div class="product-name">모닥모닥 화로대 미니 스탠드형</div>
                <div class="product-meta">주문번호 2026.07.34 · 배송완료</div>
                </div>
            </div>
            <span class="badge-shipped">배송완료</span>
            </div>
        
            <!-- 기존 리뷰 미리보기 -->
            <div class="original-box">
            <div class="original-label">기존 리뷰</div>
            <div class="original-stars">
                <span v-for="n in 5" :key="n" class="original-star"
                :style="{ color: n <= original.rating ? 'var(--star-filled)' : 'var(--star-empty)' }">★</span>
            </div>
            <div class="original-tags">
                <span class="original-tag-pill" v-for="tag in original.tags" :key="tag">{{ tag }}</span>
            </div>
            <div class="original-text">{{ original.text }}</div>
            <div class="original-date">작성일 2026.03.28</div>
            </div>
        
            <!-- 별점 -->
            <div class="card" :class="{ modified: ratingModified }">
            <div class="section-label">
                별점 <span class="required-badge">필수</span>
                <span class="modified-dot" v-if="ratingModified" title="수정됨"></span>
            </div>
            <div class="star-row">
                <button
                v-for="n in 5" :key="n"
                class="star-btn"
                @click="setRating(n)"
                @mouseover="hoverRating = n"
                @mouseleave="hoverRating = 0"
                :aria-label="n + '점'"
                >
                <span :style="{ color: (hoverRating || rating) >= n ? 'var(--star-filled)' : 'var(--star-empty)' }">★</span>
                </button>
                <span class="star-hint">{{ ratingLabel }}</span>
            </div>
            </div>
        
            <!-- 좋은 점 태그 -->
            <div class="card" :class="{ modified: tagsModified }">
            <div class="section-label">
                이런 점이 좋아요
                <span class="modified-dot" v-if="tagsModified" title="수정됨"></span>
            </div>
            <div class="tags-grid">
                <button
                v-for="tag in goodTags"
                :key="tag"
                class="tag-btn"
                :class="{ active: selectedTags.includes(tag) }"
                @click="toggleTag(tag)"
                >{{ tag }}</button>
            </div>
            </div>
        
            <!-- 리뷰 텍스트 -->
            <div class="card" :class="{ modified: textModified }">
            <div class="section-label">
                리뷰 작성 <span class="required-badge">필수</span>
                <span class="modified-dot" v-if="textModified" title="수정됨"></span>
            </div>
            <textarea
                class="review-textarea"
                v-model="reviewText"
                placeholder="상품에 대한 솔직한 후기를 남겨주세요.&#10;(최소 10자 이상)"
                maxlength="1000"
            ></textarea>
            <div class="char-count"><span>{{ reviewText.length }}</span> / 1000</div>
            </div>
        
            <!-- 사진 첨부 -->
            <div class="card" :class="{ modified: photosModified }">
            <div class="section-label">
                사진 첨부
                <span style="font-weight:400;color:var(--text-muted);font-size:0.75rem;">최대 5장</span>
                <span class="modified-dot" v-if="photosModified" title="수정됨"></span>
            </div>
            <div class="photo-area">
                <label class="photo-add-btn" style="cursor:pointer;" v-if="photos.length < 5">
                <input type="file" accept="image/*" multiple style="display:none" @change="addPhotos" />
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                <span class="photo-add-label">사진 추가</span>
                </label>
                <div class="photo-wrapper" v-for="(photo, i) in photos" :key="photo.id">
                <img class="photo-preview" :class="photo.isNew ? 'new-photo' : 'existing'" :src="photo.src" alt="첨부 사진" />
                <span class="photo-new-badge" v-if="photo.isNew">NEW</span>
                <button class="photo-remove" @click="removePhoto(i)">✕</button>
                </div>
            </div>
            <div class="photo-footer">{{ photos.length }} / 5장 · JPG, PNG, WEBP 가능</div>
            </div>
        
            <!-- 수정 안내 -->
            <div class="notice-box">
            <div class="notice-row">
                <span class="notice-icon">ℹ</span>
                <span>
                리뷰 수정은 1회만 가능합니다.<br />
                수정 후 추가 포인트는 지급되지 않습니다.<br />
                비회원·부적절한 리뷰는 사전 고지 없이 삭제될 수 있습니다.
                </span>
            </div>
            </div>
        
            <!-- 버튼 -->
            <div class="btn-row">
            <button class="btn-cancel" @click="handleCancel">취소</button>
            <button class="btn-submit" @click="handleSubmit" :disabled="!canSubmit">
                ✓ 수정 저장하기
            </button>
            </div>
        </main>
        
        <!-- FOOTER -->
        <footer>
            <div class="footer-inner">
            <div>
                <div class="footer-brand-name">🏕️ 모닥모닥</div>
                <div class="footer-brand-desc">자연과 함께하는 특별한 순간을<br/>모닥모닥이 함께합니다.</div>
            </div>
            <div class="footer-col">
                <div class="footer-col-title">서비스</div>
                <ul>
                <li><a href="#">대하여</a></li>
                <li><a href="#">구매하기</a></li>
                <li><a href="#">캠핑장 찾기</a></li>
                <li><a href="#">인상품</a></li>
                <li><a href="#">베스트</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <div class="footer-col-title">고객지원</div>
                <ul>
                <li><a href="#">공지사항</a></li>
                <li><a href="#">자주 묻는 질문</a></li>
                <li><a href="#">1:1 문의</a></li>
                <li><a href="#">배송 조회</a></li>
                <li><a href="#">반품/교환</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <div class="footer-col-title">문의</div>
                <div class="footer-contact-detail">고객센터</div>
                <div class="footer-contact-num">1588-0000</div>
                <div class="footer-contact-detail">운영시간<br/>평일 09:00 ~ 18:00</div>
                <div style="margin-top:6px;"><a class="footer-contact-email" href="mailto:hello@modakmodak.kr">hello@modakmodak.kr</a></div>
            </div>
            </div>
            <div class="footer-bottom">
            <span class="footer-copy">© 2026 MODAK MODAK. All rights reserved.</span>
            <div class="footer-links">
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">환불정책</a>
            </div>
            </div>
        </footer>
        
        <!-- 삭제 확인 모달 -->
        <div class="modal-overlay" v-if="showDeleteModal" @click.self="showDeleteModal = false">
            <div class="modal-box">
            <div class="modal-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
            </div>
            <div class="modal-title">리뷰를 삭제할까요?</div>
            <div class="modal-desc">
                삭제된 리뷰는 복구할 수 없습니다.<br />
                적립된 포인트도 함께 회수될 수 있습니다.
            </div>
            <div class="modal-btn-row">
                <button class="modal-btn-cancel" @click="showDeleteModal = false">취소</button>
                <button class="modal-btn-delete" @click="handleDelete">삭제하기</button>
            </div>
            </div>
        </div>
        
        <!-- Toast -->
        <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
        </div>
    </div>
</body>
</html>

<script>


    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                // 기존 리뷰 데이터 (API에서 받아온 값)
                original: {
                    rating: 4,
                    tags: ['품질이 좋아요', '사진과 똑같아요', '포장이 훌륭해요'],
                    text: '캠핑 갔다가 처음 써봤는데 정말 만족스러워요! 크기가 작아서 가방에 쏙 들어가고, 불이 잘 붙어서 좋았습니다. 디자인도 예쁘고 튼튼해 보여요. 다음에도 구매할 것 같아요.',
                    photos: [
                        { id: 'e1', src: 'https://via.placeholder.com/72x72/f0e9de/9c7b6b?text=📸', isNew: false },
                    ]
                },
                // 수정 상태 변수
                rating: 4,
                hoverRating: 0,
                reviewText: '캠핑 갔다가 처음 써봤는데 정말 만족스러워요! 크기가 작아서 가방에 쏙 들어가고, 불이 잘 붙어서 좋았습니다. 디자인도 예쁘고 튼튼해 보여요. 다음에도 구매할 것 같아요.',
                selectedTags: ['품질이 좋아요', '사진과 똑같아요', '포장이 훌륭해요'],
                photos: [
                    { id: 'e1', src: 'https://via.placeholder.com/72x72/f0e9de/9c7b6b?text=📸', isNew: false },
                ],
                showDeleteModal: false,
                toastVisible: false,
                toastMsg: '',
                // 태그 목록
                goodTags: [
                    '품질이 좋아요', '사진과 똑같아요', '배송이 빨라요',
                    '가격이 합리적이에요', '포장이 훌륭해요',
                    '재구매 의사 있어요', '사용이 편리해요', '내구성이 좋아요'
                ],
                ratingLabels: ['', '별로예요', '그럭저럭이에요', '보통이에요', '좋아요', '최고예요!'],
            };
        },// data
        computed: {
            // 별점 레이블
            ratingLabel: function () {
                const val = this.hoverRating || this.rating;
                return val ? this.ratingLabels[val] : '별점을 선택하세요';
            },
            // 변경 감지
            ratingModified: function () {
                return this.rating !== this.original.rating;
            },
            textModified: function () {
                return this.reviewText.trim() !== this.original.text.trim();
            },
            tagsModified: function () {
                const a = [...this.selectedTags].sort().join(',');
                const b = [...this.original.tags].sort().join(',');
                return a !== b;
            },
            photosModified: function () {
                if (this.photos.length !== this.original.photos.length) return true;
                return this.photos.some(p => p.isNew);
            },
            hasChanges: function () {
                return this.ratingModified || this.textModified || this.tagsModified || this.photosModified;
            },
            canSubmit: function () {
                return this.rating > 0 && this.reviewText.trim().length >= 10 && this.hasChanges;
            },
        }, // computed
        methods: {
            // 함수(메소드) - (key : function())
            fnReviewEdit: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/user/review/edit.do",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                    }
                });
            },
            // 별점 선택
            setRating: function (n) {
                let self = this;
                self.rating = n;
            },
            // 태그 토글
            toggleTag: function (tag) {
                let self = this;
                const idx = self.selectedTags.indexOf(tag);
                if (idx === -1) self.selectedTags.push(tag);
                else self.selectedTags.splice(idx, 1);
            },
            // 사진 추가
            addPhotos: function (e) {
                let self = this;
                const files = Array.from(e.target.files);
                const remaining = 5 - self.photos.length;
                files.slice(0, remaining).forEach(file => {
                    const reader = new FileReader();
                    reader.onload = ev => {
                        self.photos.push({ id: 'new_' + Date.now(), src: ev.target.result, isNew: true });
                    };
                    reader.readAsDataURL(file);
                });
                e.target.value = '';
            },
            // 사진 삭제
            removePhoto: function (i) {
                let self = this;
                self.photos.splice(i, 1);
            },
            // 토스트 알림
            showToast: function (msg) {
                let self = this;
                self.toastMsg = msg;
                self.toastVisible = true;
                setTimeout(function () { self.toastVisible = false; }, 2500);
            },
            // 수정 저장
            fnSave: function () {
                let self = this;
                if (!self.canSubmit) return;
                let param = {
                    rating: self.rating,
                    tags: self.selectedTags,
                    reviewText: self.reviewText,
                    photos: self.photos.filter(p => !p.isNew).map(p => p.id),
                };
                $.ajax({
                    url: "http://localhost:8080/review/update.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.showToast('✓ 리뷰가 수정되었습니다.');
                    }
                });
            },
            // 취소
            handleCancel: function () {
                let self = this;
                if (self.hasChanges) {
                    if (!confirm('수정 중인 내용이 저장되지 않습니다. 취소하시겠어요?')) return;
                }
                self.rating = self.original.rating;
                self.reviewText = self.original.text;
                self.selectedTags = [...self.original.tags];
                self.photos = self.original.photos.map(p => ({ ...p }));
                self.showToast('수정이 취소되었습니다.');
            },
            // 리뷰 삭제
            fnDelete: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/review/delete.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.showDeleteModal = false;
                        self.showToast('🗑️ 리뷰가 삭제되었습니다.');
                    }
                });
            },
            
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            
        }
    });

    app.mount('#app');
</script>