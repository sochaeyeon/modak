<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 리뷰 작성</title>
    <link rel="stylesheet" href="/css/review/review-add.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
</head>
<body>
    <div id="app">
    <!-- HEADER -->
    <header>
        <div class="header-left">
        <button class="header-icon-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
        </button>
        <button class="header-icon-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        </button>
        <button class="header-icon-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
        </button>
        <button class="header-icon-btn cart-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            <span class="cart-badge">3</span>
        </button>
        <button class="logout-btn">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Log out
        </button>
        </div>
        <a href="#" class="header-logo">모닥모닥</a>
        <div class="header-right">
        <button class="category-btn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            카테고리
        </button>
        </div>
    </header>

    <!-- MAIN -->
    <main>
        <h1 class="page-title">리뷰 작성</h1>
        <p class="page-subtitle">✦ 솔직한 후기가 다른 캠버들에게 큰 도움이 됩니다 🔥</p>

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

        <!-- 별점 -->
        <div class="card">
        <div class="section-label">
            별점 <span class="required-badge">필수</span>
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
        <div class="card">
        <div class="section-label">이런 점이 좋아요</div>
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

        <!-- 리뷰 작성 -->
        <div class="card">
        <div class="section-label">
            리뷰 작성 <span class="required-badge">필수</span>
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
        <div class="card">
        <div class="section-label">사진 첨부 <span style="font-weight:400;color:var(--text-muted);font-size:0.75rem;">최대 5장</span></div>
        <div class="photo-area">
            <label class="photo-add-btn" style="cursor:pointer;">
            <input type="file" accept="image/*" multiple style="display:none" @change="addPhotos" />
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
            <span class="photo-add-label">사진 추가</span>
            </label>
            <div class="photo-wrapper" v-for="(photo, i) in photos" :key="i">
            <img class="photo-preview" :src="photo" alt="첨부 사진" />
            <button class="photo-remove" @click="removePhoto(i)">✕</button>
            </div>
        </div>
        <div class="photo-footer">{{ photos.length }} / 5장 · JPG, PNG, WEBP 가능</div>
        </div>

        <!-- 포인트 안내 -->
        <div class="point-box">
        <div class="point-row">
            <span class="point-icon">ℹ</span>
            <span>
            리뷰 작성 시 500 포인트가 적립됩니다.<br />
            사진 포함 리뷰 작성 시 추가 300 포인트가 적립됩니다.<br />
            비회원·부적절한 리뷰는 사전 고지 없이 삭제될 수 있습니다.
            </span>
        </div>
        </div>

        <!-- 버튼 -->
        <div class="btn-row">
        <button class="btn-cancel" @click="handleCancel">취소</button>
        <button class="btn-submit" @click="fnSave" :disabled="!canSubmit">
            ✓ 리뷰 등록하기
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

    <!-- Toast -->
    <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
    </div>
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            // 변수
            rating: 0,
            hoverRating: 0,
            reviewText: '',
            selectedTags: [],
            photos: [],
            toastVisible: false,
            toastMsg: '',
            goodTags: [
                '품질이 좋아요', '사진과 똑같아요', '배송이 빨라요',
                '가격이 합리적이에요', '포장이 훌륭해요',
                '재구매 의사 있어요', '사용이 편리해요', '내구성이 좋아요'
            ],
            ratingLabels: ['', '별로예요', '그럭저럭이에요', '보통이에요', '좋아요', '최고예요!'],
        };
    }, // data
    computed: {
        // 별점 레이블
        ratingLabel: function () {
            const val = this.hoverRating || this.rating;
            return val ? this.ratingLabels[val] : '별점을 선택하세요';
        },
        // 등록 버튼 활성화 여부
        canSubmit: function () {
            return this.rating > 0 && this.reviewText.trim().length >= 10;
        },
    }, // computed
    methods: {
        fnReviewAdd: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/user/review/add.do",
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
                reader.onload = ev => self.photos.push(ev.target.result);
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
        // 리뷰 등록
        fnSave: function () {
            let self = this;
            if (!self.canSubmit) return;
            let param = {
                rating: self.rating,
                tags: self.selectedTags,
                reviewText: self.reviewText,
            };
            $.ajax({
                url: "http://localhost:8080/review/insert.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function (data) {
                    self.showToast('🎉 리뷰가 등록되었습니다! 500 포인트가 적립됩니다.');
                }
            });
        },
        // 취소
        handleCancel: function () {
            let self = this;
            if (confirm('작성 중인 리뷰가 저장되지 않습니다. 취소하시겠어요?')) {
                self.rating = 0;
                self.reviewText = '';
                self.selectedTags = [];
                self.photos = [];
                self.showToast('취소되었습니다.');
            }
        },
    }, // methods
    mounted() {
        // 처음 시작할 때 실행되는 부분
        let self = this;
    }
});

app.mount('#app');
</script>