<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="리뷰관리" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">
    <div class="admin-topbar">
        <div class="topbar-title">⭐ 리뷰 관리</div>
    </div>

    <div class="admin-content" id="app">

        <div class="a-tabs">
            <button class="a-tab" :class="{active:tab==='REPORTED'}" @click="fnTab('REPORTED')">
                신고된 리뷰 <span v-if="reportedCount>0" style="color:var(--red)">({{ reportedCount }})</span>
            </button>
            <button class="a-tab" :class="{active:tab==='ALL'}" @click="fnTab('ALL')">전체 리뷰</button>
        </div>

        <div class="search-bar">
            <input class="a-input" v-model="keyword" placeholder="캠핑장명·작성자 검색" @keyup.enter="fnSearch">
            <select class="a-input" v-model="ratingFilter" @change="fnSearch" style="max-width:110px">
                <option value="">전체 별점</option>
                <option v-for="r in [1,2,3,4,5]" :key="r" :value="r">{{ r }}점</option>
            </select>
            <button class="btn-sm btn-primary" @click="fnSearch">검색</button>
        </div>

        <div class="a-card">
            <div class="a-table-wrap">
                <table class="a-table">
                    <thead>
                        <tr>
                            <th style="width:60px">ID</th>
                            <th>캠핑장</th>
                            <th>내용</th>
                            <th style="width:80px">작성자</th>
                            <th style="width:70px">별점</th>
                            <th style="width:80px">신고수</th>
                            <th style="width:120px">작성일</th>
                            <th style="width:100px">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="rev in list" :key="rev.campReviewId"
                            :style="rev.reportCount > 0 ? 'background:rgba(231,76,60,.04)' : ''">
                            <td style="color:var(--text3)">#{{ rev.campReviewId }}</td>
                            <td>
                                <div style="font-size:13px;font-weight:500">{{ rev.campName }}</div>
                            </td>
                            <td>
                                <div style="font-size:13px;max-width:280px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                                    {{ rev.content }}
                                </div>
                            </td>
                            <td style="color:var(--text2)">{{ rev.userId }}</td>
                            <td>
                                <span style="color:var(--amber)">{{ fnStars(rev.rating) }}</span>
                                <span style="font-size:11px;color:var(--text3)"> {{ rev.rating }}</span>
                            </td>
                            <td>
                                <span v-if="rev.reportCount > 0" class="badge badge-cancel">{{ rev.reportCount }}건</span>
                                <span v-else style="color:var(--text3);font-size:12px">-</span>
                            </td>
                            <td style="color:var(--text3);font-size:12px">{{ rev.createdAt }}</td>
                            <td>
                                <div style="display:flex;gap:6px">
                                    <button class="btn-sm btn-ghost" @click="fnView(rev)" style="font-size:11px">상세</button>
                                    <button class="btn-sm btn-danger" @click="fnDelete(rev)" style="font-size:11px">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="!list.length">
                            <td colspan="8" style="text-align:center;padding:32px;color:var(--text3)">
                                {{ tab === 'REPORTED' ? '✅ 신고된 리뷰가 없습니다' : '리뷰가 없습니다' }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="a-pagination">
                <button class="page-btn" :disabled="page<=1" @click="fnPage(page-1)">‹</button>
                <button v-for="p in totalPages" :key="p" class="page-btn" :class="{active:page===p}" @click="fnPage(p)">{{ p }}</button>
                <button class="page-btn" :disabled="page>=totalPages" @click="fnPage(page+1)">›</button>
            </div>
        </div>
    </div>
</div>

<!-- 리뷰 상세 모달 -->
<div class="a-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
    <div class="a-modal">
        <div class="a-modal-title">
            리뷰 상세 #{{ selectedRev ? selectedRev.campReviewId : '' }}
            <button class="a-modal-close" @click="modalOpen=false">✕</button>
        </div>
        <div v-if="selectedRev">
            <div style="display:flex;justify-content:space-between;margin-bottom:12px">
                <div>
                    <div style="font-weight:600;margin-bottom:4px">{{ selectedRev.campName }}</div>
                    <div style="font-size:12px;color:var(--text3)">{{ selectedRev.userId }} · {{ selectedRev.createdAt }}</div>
                </div>
                <div style="font-size:22px;color:var(--amber)">{{ fnStars(selectedRev.rating) }}</div>
            </div>
            <div style="background:var(--bg3);border-radius:10px;padding:16px;margin-bottom:16px;font-size:14px;line-height:1.7;color:var(--text2)">
                {{ selectedRev.content }}
            </div>
            <div v-if="selectedRev.reportCount > 0"
                 style="background:rgba(231,76,60,.08);border:1px solid rgba(231,76,60,.2);border-radius:10px;padding:12px;margin-bottom:16px">
                <div style="color:var(--red);font-size:13px;font-weight:600">⚠ 신고 {{ selectedRev.reportCount }}건</div>
                <div style="font-size:12px;color:var(--text3);margin-top:4px">신고된 리뷰입니다. 내용을 검토 후 삭제 여부를 결정해주세요.</div>
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end">
                <button class="btn-sm btn-ghost" @click="modalOpen=false">닫기</button>
                <button class="btn-sm btn-danger" @click="fnDelete(selectedRev); modalOpen=false">리뷰 삭제</button>
            </div>
        </div>
    </div>
</div>

<div class="a-toast" id="aToast"></div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            list: [], tab: 'REPORTED', keyword: '', ratingFilter: '',
            page: 1, pageSize: 15, totalCount: 0, reportedCount: 0,
            modalOpen: false, selectedRev: null
        };
    },
    computed: {
        totalPages() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        fnLoad() {
            $.ajax({
                url: '/admin/review/list.dox', type: 'POST', dataType: 'json',
                data: { tab: this.tab, keyword: this.keyword, rating: this.ratingFilter, page: this.page, pageSize: this.pageSize },
                success: (res) => {
                    if (res.result === 'success') {
                        this.list          = res.list    || [];
                        this.totalCount    = res.totalCount || 0;
                        this.reportedCount = res.reportedCount || 0;
                    }
                }
            });
        },
        fnTab(t) { this.tab = t; this.page = 1; this.fnLoad(); },
        fnSearch() { this.page = 1; this.fnLoad(); },
        fnPage(p)  { this.page = p; this.fnLoad(); },
        fnView(rev) { this.selectedRev = rev; this.modalOpen = true; },
        fnDelete(rev) {
            if (!confirm('리뷰를 삭제하시겠습니까?')) return;
            $.ajax({
                url: '/admin/review/delete.dox', type: 'POST', dataType: 'json',
                data: { campReviewId: rev.campReviewId },
                success: (res) => {
                    if (res.result === 'success') {
                        this.list = this.list.filter(r => r.campReviewId !== rev.campReviewId);
                        this.toast('리뷰가 삭제되었습니다.', 'success');
                    }
                }
            });
        },
        fnStars(r) { return '★'.repeat(Math.round(r||0)) + '☆'.repeat(5-Math.round(r||0)); },
        toast(msg, type='info') {
            var t = document.getElementById('aToast');
            t.textContent = msg; t.className = 'a-toast ' + type; t.classList.add('show');
            setTimeout(() => t.classList.remove('show'), 2500);
        }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
