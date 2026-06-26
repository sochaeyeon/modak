<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-reviews.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="rv-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="rv-header">
        <div class="rv-title-wrap">
            <div class="rv-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
            </div>
            <div>
                <div class="rv-page-title">리뷰 관리</div>
                <div class="rv-page-sub">고객 리뷰를 확인하고 관리합니다</div>
            </div>
        </div>
        <button class="rv-back-btn" onclick="location.href='/admin/dashboard.do'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/>
                <rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/>
                <rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── KPI 카드 ── -->
    <div class="rv-kpi-grid">
        <div class="rv-kpi-card" style="--kc:#E8732A;--kcb:rgba(232,115,42,.18)">
            <div class="rv-kpi-glow"></div>
            <div class="rv-kpi-top">
                <span class="rv-kpi-label">전체 리뷰</span>
                <div class="rv-kpi-icon" style="background:rgba(232,115,42,.15);color:#E8732A">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                    </svg>
                </div>
            </div>
            <div class="rv-kpi-val">{{ reviewList.length }}<span class="rv-kpi-unit">개</span></div>
            <div class="rv-kpi-sub">총 리뷰 수</div>
            <div class="rv-kpi-bar"></div>
        </div>
        <div class="rv-kpi-card" style="--kc:#F5A623;--kcb:rgba(245,166,35,.18)">
            <div class="rv-kpi-glow"></div>
            <div class="rv-kpi-top">
                <span class="rv-kpi-label">평균 별점</span>
                <div class="rv-kpi-icon" style="background:rgba(245,166,35,.15);color:#F5A623">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                    </svg>
                </div>
            </div>
            <div class="rv-kpi-val">{{ avgRating }}<span class="rv-kpi-unit">점</span></div>
            <div class="rv-kpi-sub">5점 만점</div>
            <div class="rv-kpi-bar"></div>
        </div>
        <div class="rv-kpi-card" style="--kc:#2ECC71;--kcb:rgba(46,204,113,.18)">
            <div class="rv-kpi-glow"></div>
            <div class="rv-kpi-top">
                <span class="rv-kpi-label">5점 리뷰</span>
                <div class="rv-kpi-icon" style="background:rgba(46,204,113,.15);color:#2ECC71">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </div>
            </div>
            <div class="rv-kpi-val">{{ fiveStarCount }}<span class="rv-kpi-unit">개</span></div>
            <div class="rv-kpi-sub">{{ fiveStarPct }}% 비율</div>
            <div class="rv-kpi-bar"></div>
        </div>
        <div class="rv-kpi-card" style="--kc:#E74C3C;--kcb:rgba(231,76,60,.18)">
            <div class="rv-kpi-glow"></div>
            <div class="rv-kpi-top">
                <span class="rv-kpi-label">저점 리뷰</span>
                <div class="rv-kpi-icon" style="background:rgba(231,76,60,.15);color:#E74C3C">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                </div>
            </div>
            <div class="rv-kpi-val">{{ lowRatingCount }}<span class="rv-kpi-unit">개</span></div>
            <div class="rv-kpi-sub">2점 이하</div>
            <div class="rv-kpi-bar"></div>
        </div>
    </div>

    <!-- ── 검색 ── -->
    <div class="rv-card rv-search-card">
        <div class="rv-search-row">
            <div class="rv-search-box">
                <svg class="rv-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"/>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
                <input type="text" class="rv-search-input" v-model="keyword"
                    placeholder="리뷰어 이름, 제목 검색..." @keyup.enter="fnLoad">
            </div>
            <div class="rv-filter-row">
                <select class="rv-select" v-model="filterRating">
                    <option value="">전체 별점</option>
                    <option value="5">★★★★★ 5점</option>
                    <option value="4">★★★★ 4점</option>
                    <option value="3">★★★ 3점</option>
                    <option value="2">★★ 2점</option>
                    <option value="1">★ 1점</option>
                </select>
                <button class="rv-search-btn" @click="fnLoad">검색</button>
            </div>
        </div>
    </div>

    <!-- ── 테이블 ── -->
    <div class="rv-card rv-table-card">
        <div class="rv-card-header">
            <div class="rv-card-title">
                <div class="rv-title-dot" style="background:#E8732A"></div>
                리뷰 목록
            </div>
            <span class="rv-card-sub">{{ filteredList.length }}개 리뷰</span>
        </div>
        <div class="rv-table-wrap">
            <table class="rv-table">
                <thead>
                    <tr>
                        <th style="width:52px">이미지</th>
                        <th style="text-align:left">상품 / 리뷰</th>
                        <th style="width:100px">리뷰어</th>
                        <th style="width:100px">별점</th>
                        <th style="width:110px">작성일</th>
                        <th style="width:80px">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredList.length === 0">
                        <td colspan="6" class="rv-empty-td">리뷰가 없습니다</td>
                    </tr>
                    <tr v-for="item in filteredList" :key="item.REVIEW_ID"
                        class="rv-row" @click="fnOpenDetail(item)">
                        <td>
                            <div class="rv-prod-img">
                                <img v-if="item.PROD_IMG" :src="item.PROD_IMG" :alt="item.TITLE">
                                <span v-else class="rv-img-ph">⛺</span>
                            </div>
                        </td>
                        <td class="rv-info-cell">
                            <div class="rv-review-title">{{ item.TITLE }}</div>
                            <div class="rv-review-excerpt">{{ (item.CONTENT||'').slice(0,55) }}{{ (item.CONTENT||'').length>55?'…':'' }}</div>
                            <div class="rv-prod-id">#{{ item.PRODUCT_ID }}</div>
                        </td>
                        <td>
                            <div class="rv-user-name">{{ item.NAME }}</div>
                            <div class="rv-user-id">{{ item.USER_ID }}</div>
                        </td>
                        <td>
                            <div class="rv-stars">
                                <span v-for="n in 5" :key="n"
                                    :class="n <= item.RATING ? 'rv-star-on' : 'rv-star-off'">★</span>
                            </div>
                            <div class="rv-rating-num">{{ item.RATING }}.0</div>
                        </td>
                        <td class="rv-date">{{ fnFormatDate(item.CREATED_AT) }}</td>
                        <td @click.stop>
                            <button class="rv-del-btn" @click="fnDeleteConfirm(item)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="3 6 5 6 21 6"/>
                                    <path d="M19 6l-1 14H6L5 6"/>
                                    <path d="M10 11v6M14 11v6M9 6V4h6v2"/>
                                </svg>
                                삭제
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div><!-- rv-container -->

<!-- ── 상세 모달 ── -->
<transition name="rv-fade">
<div v-if="showDetail" class="rv-overlay" @click.self="showDetail=false">
    <div class="rv-modal">
        <div class="rv-modal-header">
            <div class="rv-modal-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;color:#E8732A">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
                리뷰 상세
            </div>
            <button class="rv-modal-close" @click="showDetail=false">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>
        <div class="rv-modal-body" v-if="detailItem">
            <img v-if="detailItem.PROD_IMG" :src="detailItem.PROD_IMG" class="rv-modal-prod-img">
            <div v-else class="rv-modal-prod-ph">⛺ No Image</div>

            <div class="rv-modal-meta">
                <div class="rv-meta-row">
                    <span class="rv-meta-label">상품 ID</span>
                    <span class="rv-meta-val">#{{ detailItem.PRODUCT_ID }}</span>
                </div>
                <div class="rv-meta-row">
                    <span class="rv-meta-label">리뷰어</span>
                    <span class="rv-meta-val">{{ detailItem.NAME }} ({{ detailItem.USER_ID }})</span>
                </div>
                <div class="rv-meta-row">
                    <span class="rv-meta-label">별점</span>
                    <span class="rv-meta-val rv-stars">
                        <span v-for="n in 5" :key="n"
                            :class="n <= detailItem.RATING ? 'rv-star-on' : 'rv-star-off'">★</span>
                        &nbsp;{{ detailItem.RATING }}.0
                    </span>
                </div>
                <div class="rv-meta-row">
                    <span class="rv-meta-label">작성일</span>
                    <span class="rv-meta-val">{{ fnFormatDate(detailItem.CREATED_AT) }}</span>
                </div>
            </div>

            <div class="rv-modal-section-label">제목</div>
            <div class="rv-modal-review-title">{{ detailItem.TITLE }}</div>

            <div class="rv-modal-section-label" style="margin-top:14px">리뷰 내용</div>
            <div class="rv-modal-content">{{ detailItem.CONTENT }}</div>

            <div v-if="reviewImages.length" style="margin-top:16px">
                <div class="rv-modal-section-label">리뷰 이미지 ({{ reviewImages.length }}장)</div>
                <div class="rv-img-grid">
                    <div v-for="(img, i) in reviewImages" :key="i" class="rv-img-thumb">
                        <img :src="img" :alt="'리뷰이미지'+(i+1)">
                    </div>
                </div>
            </div>
        </div>
        <div class="rv-modal-footer">
            <button class="rv-modal-cancel" @click="showDetail=false">닫기</button>
            <button class="rv-modal-delete" @click="fnDeleteConfirm(detailItem); showDetail=false">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px">
                    <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/>
                </svg>
                리뷰 삭제
            </button>
        </div>
    </div>
</div>
</transition>

<!-- ── 삭제 확인 모달 ── -->
<transition name="rv-fade">
<div v-if="showConfirm" class="rv-overlay" @click.self="showConfirm=false">
    <div class="rv-confirm-box">
        <div class="rv-confirm-icon">🗑️</div>
        <div class="rv-confirm-title">리뷰 삭제</div>
        <div class="rv-confirm-msg">이 리뷰를 삭제하시겠습니까?<br><span style="color:#ff8080;font-size:12px">삭제 후 복구할 수 없습니다.</span></div>
        <div class="rv-confirm-btns">
            <button class="rv-confirm-cancel" @click="showConfirm=false">취소</button>
            <button class="rv-confirm-ok" @click="fnDoDelete">삭제하기</button>
        </div>
    </div>
</div>
</transition>

<!-- ── 토스트 ── -->
<div class="rv-toast-wrap">
    <transition-group name="rv-toast">
        <div v-for="t in toasts" :key="t.id" class="rv-toast" :class="t.type">{{ t.msg }}</div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            reviewList: [],
            keyword: '',
            filterRating: '',
            showDetail: false,
            detailItem: null,
            showConfirm: false,
            deleteTarget: null,
            toasts: []
        };
    },
    computed: {
        filteredList() {
            let list = this.reviewList;
            if (this.keyword) {
                const kw = this.keyword.toLowerCase();
                list = list.filter(r =>
                    (r.NAME||'').toLowerCase().includes(kw) ||
                    (r.TITLE||'').toLowerCase().includes(kw) ||
                    (r.USER_ID||'').toLowerCase().includes(kw)
                );
            }
            if (this.filterRating) {
                list = list.filter(r => String(r.RATING) === String(this.filterRating));
            }
            return list;
        },
        avgRating() {
            if (!this.reviewList.length) return '0.0';
            const avg = this.reviewList.reduce((s, r) => s + Number(r.RATING||0), 0) / this.reviewList.length;
            return avg.toFixed(1);
        },
        fiveStarCount() { return this.reviewList.filter(r => Number(r.RATING) === 5).length; },
        fiveStarPct() {
            if (!this.reviewList.length) return 0;
            return Math.round(this.fiveStarCount / this.reviewList.length * 100);
        },
        lowRatingCount() { return this.reviewList.filter(r => Number(r.RATING) <= 2).length; },
        reviewImages() {
            if (!this.detailItem || !this.detailItem.REVIEW_IMAGES) return [];
            return this.detailItem.REVIEW_IMAGES.split(',').map(s => s.trim()).filter(Boolean);
        }
    },
    methods: {
        toast(msg, type) {
            const id = Date.now() + Math.random();
            this.toasts.push({ id, msg, type: type || 'success' });
            setTimeout(() => { this.toasts = this.toasts.filter(t => t.id !== id); }, 2800);
        },
        fnLoad() {
            $.ajax({
                url: '/admin/review/list.dox', type: 'POST',
                data: { keyword: this.keyword },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') this.reviewList = data.list || [];
                }
            });
        },
        fnOpenDetail(item) { this.detailItem = item; this.showDetail = true; },
        fnDeleteConfirm(item) { this.deleteTarget = item; this.showConfirm = true; },
        fnDoDelete() {
            this.showConfirm = false;
            if (!this.deleteTarget) return;
            $.ajax({
                url: '/admin/review/remove.dox', type: 'POST',
                data: { reviewId: this.deleteTarget.REVIEW_ID },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.toast('리뷰가 삭제되었습니다', 'success');
                        this.fnLoad();
                    } else {
                        this.toast('삭제에 실패했습니다', 'error');
                    }
                },
                error: () => { this.toast('서버 오류가 발생했습니다', 'error'); }
            });
        },
        fnFormatDate(dt) { return dt ? String(dt).slice(0, 10) : '-'; }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
