<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="문의관리" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">
    <div class="admin-topbar">
        <div class="topbar-title">💬 문의 관리</div>
        <div class="topbar-right">
            <span style="font-size:12px;color:var(--text3)">미답변 문의를 처리합니다</span>
        </div>
    </div>

    <div class="admin-content" id="app">

        <!-- 탭 -->
        <div class="a-tabs">
            <button class="a-tab" :class="{active: tab==='WAITING'}" @click="fnTab('WAITING')">
                미답변 <span v-if="waitCount > 0" style="color:var(--amber)">({{ waitCount }})</span>
            </button>
            <button class="a-tab" :class="{active: tab==='DONE'}"    @click="fnTab('DONE')">답변완료</button>
            <button class="a-tab" :class="{active: tab==='ALL'}"     @click="fnTab('ALL')">전체</button>
        </div>

        <!-- 검색 -->
        <div class="search-bar">
            <input class="a-input" v-model="keyword" placeholder="제목·내용·회원ID 검색" @keyup.enter="fnSearch" style="max-width:280px">
            <button class="btn-sm btn-primary" @click="fnSearch">검색</button>
        </div>

        <!-- 목록 -->
        <div class="a-card">
            <div class="a-table-wrap">
                <table class="a-table">
                    <thead>
                        <tr>
                            <th style="width:60px">ID</th>
                            <th>제목</th>
                            <th style="width:100px">회원</th>
                            <th style="width:90px">상태</th>
                            <th style="width:130px">접수일</th>
                            <th style="width:80px">처리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="inq in list" :key="inq.inquiryId"
                            :style="inq.inquiryStatus === 'WAITING' ? 'background:rgba(245,166,35,.04)' : ''">
                            <td style="color:var(--text3)">#{{ inq.inquiryId }}</td>
                            <td>
                                <div style="font-weight:500">{{ inq.title }}</div>
                                <div style="font-size:11px;color:var(--text3);margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:300px">
                                    {{ inq.content }}
                                </div>
                            </td>
                            <td style="color:var(--text2)">{{ inq.userId }}</td>
                            <td>
                                <span class="badge" :class="inq.inquiryStatus === 'WAITING' ? 'badge-wait' : 'badge-done'">
                                    {{ inq.inquiryStatus === 'WAITING' ? '미답변' : '답변완료' }}
                                </span>
                            </td>
                            <td style="color:var(--text3);font-size:12px">{{ inq.createdAt }}</td>
                            <td>
                                <button class="btn-sm btn-primary" @click="fnOpenReply(inq)">
                                    {{ inq.inquiryStatus === 'WAITING' ? '답변하기' : '수정' }}
                                </button>
                            </td>
                        </tr>
                        <tr v-if="!list.length">
                            <td colspan="6" style="text-align:center;padding:32px;color:var(--text3)">문의가 없습니다</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="a-pagination">
                <button class="page-btn" :disabled="page <= 1" @click="fnPage(page-1)">‹</button>
                <button v-for="p in totalPages" :key="p" class="page-btn" :class="{active: page===p}" @click="fnPage(p)">{{ p }}</button>
                <button class="page-btn" :disabled="page >= totalPages" @click="fnPage(page+1)">›</button>
            </div>
        </div>

    </div>
</div>

<!-- 답변 모달 -->
<div class="a-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false" id="replyModal">
    <div class="a-modal">
        <div class="a-modal-title">
            {{ selectedInq ? '문의 #' + selectedInq.inquiryId + ' 답변' : '' }}
            <button class="a-modal-close" @click="modalOpen=false">✕</button>
        </div>
        <div v-if="selectedInq">
            <!-- 원문 -->
            <div style="background:var(--bg3);border-radius:10px;padding:16px;margin-bottom:16px">
                <div style="font-size:12px;color:var(--text3);margin-bottom:6px">{{ selectedInq.userId }} · {{ selectedInq.createdAt }}</div>
                <div style="font-size:14px;font-weight:600;margin-bottom:8px">{{ selectedInq.title }}</div>
                <div style="font-size:13px;color:var(--text2);line-height:1.7">{{ selectedInq.content }}</div>
            </div>
            <!-- 기존 답변 -->
            <div v-if="selectedInq.answer" style="background:rgba(232,115,42,.08);border-radius:10px;padding:14px;margin-bottom:16px;border-left:3px solid var(--orange)">
                <div style="font-size:11px;color:var(--orange);margin-bottom:6px">기존 답변</div>
                <div style="font-size:13px;color:var(--text2)">{{ selectedInq.answer }}</div>
            </div>
            <!-- 답변 입력 -->
            <div style="margin-bottom:16px">
                <label style="font-size:12px;color:var(--text3);display:block;margin-bottom:6px">답변 내용</label>
                <textarea class="a-textarea" v-model="replyContent" placeholder="회원에게 전달할 답변을 작성해주세요..."></textarea>
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end">
                <button class="btn-sm btn-ghost" @click="modalOpen=false">취소</button>
                <button class="btn-sm btn-primary" @click="fnSubmitReply" :disabled="isSubmitting">
                    {{ isSubmitting ? '처리중...' : '답변 등록' }}
                </button>
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
            list: [], tab: 'WAITING', keyword: '',
            page: 1, pageSize: 15, totalCount: 0,
            waitCount: 0,
            modalOpen: false, selectedInq: null,
            replyContent: '', isSubmitting: false
        };
    },
    computed: {
        totalPages() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        fnLoad() {
            $.ajax({
                url: '/admin/inquiry/list.dox', type: 'POST', dataType: 'json',
                data: { tab: this.tab, keyword: this.keyword, page: this.page, pageSize: this.pageSize },
                success: (res) => {
                    if (res.result === 'success') {
                        this.list = res.list || [];
                        this.totalCount = res.totalCount || 0;
                        this.waitCount  = res.waitCount  || 0;
                    }
                }
            });
        },
        fnTab(t)    { this.tab = t; this.page = 1; this.fnLoad(); },
        fnSearch()  { this.page = 1; this.fnLoad(); },
        fnPage(p)   { this.page = p; this.fnLoad(); },
        fnOpenReply(inq) {
            this.selectedInq  = inq;
            this.replyContent = inq.answer || '';
            this.modalOpen    = true;
        },
        fnSubmitReply() {
            if (!this.replyContent.trim()) { this.toast('답변 내용을 입력해주세요.', 'error'); return; }
            this.isSubmitting = true;
            $.ajax({
                url: '/admin/inquiry/reply.dox', type: 'POST', dataType: 'json',
                data: { inquiryId: this.selectedInq.inquiryId, content: this.replyContent },
                success: (res) => {
                    this.isSubmitting = false;
                    if (res.result === 'success') {
                        this.toast('✅ 답변이 등록되었습니다.', 'success');
                        this.modalOpen = false;
                        this.fnLoad();
                    } else {
                        this.toast(res.message || '오류가 발생했습니다.', 'error');
                    }
                },
                error: () => { this.isSubmitting = false; this.toast('서버 오류', 'error'); }
            });
        },
        toast(msg, type='info') {
            var t = document.getElementById('aToast');
            t.textContent = msg; t.className = 'a-toast ' + type;
            t.classList.add('show');
            setTimeout(() => t.classList.remove('show'), 2500);
        }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
