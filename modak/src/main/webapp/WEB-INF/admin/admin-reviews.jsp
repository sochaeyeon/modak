<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:directive.page deferredSyntaxAllowedAsLiteral="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 통합 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-reviews.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="review-page-container">
            <h2 style="color:#fff; margin-bottom:30px; font-weight:700;">🛒 리뷰 통합 관리</h2>

            <div class="member-search-bar" style="background:var(--r-card); padding:18px; border-radius:18px; margin-bottom:24px; display:flex; gap:12px; border:1px solid var(--r-border);">
                <input type="text" class="m-input" v-model="keyword" placeholder="상품명 또는 리뷰 내용으로 검색하세요..." @keyup.enter="fnLoad" style="flex:1; background:#262a3a; border:none; padding:12px 20px; border-radius:12px; color:#fff; outline:none;">
                <button class="p-btn" @click="fnLoad" style="min-width:120px;">검색하기</button>
            </div>

            <div class="review-table-card">
                <table class="r-table">
                    <thead>
                        <tr>
                            <th>번호</th><th>상품 정보</th><th>리뷰 요약</th><th>작성자</th><th>별점</th><th>등록일</th><th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in reviewList" :key="item.REVIEW_ID" @click="fnDetail(item)">
                            <td style="font-size:12px; color:#555;">{{ item.REVIEW_ID }}</td>
                            <td style="text-align:left;">
                                <div style="display:flex; align-items:center;">
                                    <img :src="item.PROD_IMG" class="prod-thumb" v-if="item.PROD_IMG">
                                    <div class="prod-thumb no-img" v-else>No Img</div>
                                    <div style="line-height:1.4;">
                                        <span class="review-camp-tag" style="color:#E8732A; font-size:10px; font-weight:bold;">PID: {{ item.PRODUCT_ID }}</span>
                                        <div style="color:#fff; font-weight:600;">{{ item.NAME }}</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align:left;">
                                <div style="color:#fff; font-weight:bold; font-size:13px; margin-bottom:3px;">{{ item.TITLE }}</div>
                                <div class="review-content" style="max-width:220px; color:#8a8f9d;">{{ item.CONTENT }}</div>
                            </td>
                            <td><span class="user-badge">{{ item.USER_ID }}</span></td>
                            <td><span class="star-rating" style="color:#f4d03f;">{{ '★'.repeat(item.RATING) }}{{ '☆'.repeat(5-item.RATING) }}</span></td>
                            <td style="font-size:12px; color:#8a8f9d;">{{ item.CREATED_AT }}</td>
                            <td>
                                <button class="p-btn-secondary btn-delete" @click.stop="fnDelete(item.REVIEW_ID)">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="modal-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 style="margin:0; color:#E8732A; font-weight:800;">REVIEW DETAILS</h3>
                    <span style="cursor:pointer; font-size:28px; color:#555;" @click="isModalOpen = false">&times;</span>
                </div>
                
                <div class="modal-body">
                    <div v-if="selectedReview.imgList && selectedReview.imgList.length > 0">
                        <span class="modal-info-tag">USER PHOTOS</span>
                        <div class="review-img-container">
                            <img v-for="(img, idx) in selectedReview.imgList" :key="idx" :src="img" class="review-img-item">
                        </div>
                    </div>

                    <div style="display:flex; gap:15px; margin-bottom:25px; background:rgba(255,255,255,0.03); padding:18px; border-radius:16px; border:1px solid rgba(255,255,255,0.05);">
                        <img :src="selectedReview.PROD_IMG" style="width:55px; height:55px; border-radius:10px; object-fit:cover;">
                        <div>
                            <span class="modal-info-tag">TARGET PRODUCT</span>
                            <div style="color:#fff; font-weight:bold; font-size:16px;">{{ selectedReview.NAME }}</div>
                            <div style="color:#555; font-size:12px; margin-top:2px;">
                                작성자: <span style="color:#8a8f9d;">{{ selectedReview.USER_ID }}</span> | 
                                날짜: <span style="color:#8a8f9d;">{{ selectedReview.CREATED_AT }}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-stars">{{ '★'.repeat(selectedReview.RATING) }}{{ '☆'.repeat(5-selectedReview.RATING) }}</div>
                    <div style="color:#fff; font-size:20px; font-weight:bold; margin-bottom:12px;">{{ selectedReview.TITLE }}</div>
                    <div style="white-space:pre-wrap; color:#bdc3c7; font-size:15px; line-height:1.7; background:rgba(0,0,0,0.2); padding:20px; border-radius:14px;">{{ selectedReview.CONTENT }}</div>
                </div>

                <div style="margin-top:30px; text-align:right;">
                    <button class="p-btn" @click="isModalOpen = false" style="background:#3d4255;">닫기</button>
                    <button class="p-btn" @click="fnDelete(selectedReview.REVIEW_ID)" style="margin-left:10px; background:#ff5f5f;">리뷰 삭제</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return { 
                    reviewList: [], 
                    keyword: '', 
                    isModalOpen: false, 
                    selectedReview: {} 
                };
            },
            methods: {
                fnLoad() {
                    const self = this;
                    $.ajax({
                        url: "/admin/review/list.dox", 
                        type: "POST", 
                        data: { keyword: self.keyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if(data.result === "success") self.reviewList = data.list;
                        }
                    });
                },
                fnDetail(review) {
                    // 쉼표로 구분된 REVIEW_IMAGES 문자열을 배열로 변환
                    if (review.REVIEW_IMAGES) {
                        review.imgList = review.REVIEW_IMAGES.split(',');
                    } else {
                        review.imgList = [];
                    }
                    this.selectedReview = review;
                    this.isModalOpen = true;
                },
                fnDelete(rId) {
                    if(!confirm("이 리뷰를 삭제하시겠습니까? 관련 데이터가 모두 삭제됩니다.")) return;
                    $.ajax({
                        url: "/admin/review/remove.dox", 
                        type: "POST", 
                        data: { reviewId: rId },
                        success: (res) => {
                            alert("삭제되었습니다.");
                            this.isModalOpen = false;
                            this.fnLoad();
                        }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>