<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 문의 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-inquiry.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="inquiry-container">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:35px;">
                <h2 style="color:#fff; margin:0; font-weight:800; font-size:30px;">❓ 상품 문의 관리</h2>
                <div style="display:flex; gap:15px; align-items:center;">
                    <select v-model="sortOrder" @change="fnSort" class="sort-select" style="background:#1e1e2d; color:#fff; border:1px solid #444; padding:10px; border-radius:12px; cursor:pointer;">
                        <option value="desc">🔥 최신순 정렬</option>
                        <option value="asc">⏳ 과거순 정렬</option>
                    </select>
                    <div class="filter-tab-container">
                        <button class="filter-tab" :class="{active: statusFilter === ''}" @click="fnSetFilter('')">전체</button>
                        <button class="filter-tab" :class="{active: statusFilter === 'WAITING'}" @click="fnSetFilter('WAITING')">미답변</button>
                        <button class="filter-tab" :class="{active: statusFilter === 'COMPLETED'}" @click="fnSetFilter('COMPLETED')">답변완료</button>
                    </div>
                </div>
            </div>

            <div class="status-bar">조회된 데이터: {{ qnaList.length }}건 (현재 {{ currentPage }} / {{ totalPages }} 페이지)</div>

            <div class="review-table-card">
                <table class="r-table">
                    <thead>
                        <tr>
                            <th style="width:7%; color:#8a8f9d;">번호</th>
                            <th class="left-align" style="width:18%; color:#8a8f9d;">상품명</th>
                            <th class="left-align" style="width:12%; color:#8a8f9d;">작성자</th>
                            <th class="left-align" style="width:38%; color:#8a8f9d;">문의 상세내용</th>
                            <th style="width:13%; color:#8a8f9d;">작성일자</th>
                            <th style="width:12%; color:#8a8f9d;">진행상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in pagedList" :key="item.qnaId" @click="fnDetail(item)" style="cursor:pointer;">
                            <td>{{ item.qnaId }}</td>
                            <td class="left-align" style="color:#fff; font-weight:600;">{{ item.productName }}</td>
                            <td class="left-align"><span class="user-badge">{{ item.nickname }}</span></td>
                            <td class="left-align">
                                <div v-if="item.optionName" style="font-size:12px; color:#8a8f9d; margin-bottom:4px;">{{ item.optionName }}</div>
                                <div class="text-ellipsis">
                                    <span v-if="item.secretYn === 'Y'" style="color:#f1c40f; margin-right:4px;">🔒</span>{{ item.questionContent }}
                                </div>
                            </td>
                            <td style="font-size:13px;">{{ item.createdAt }}</td>
                            <td><span :class="['status-badge', item.status === 'COMPLETED' ? 'status-y' : 'status-n']">{{ item.status === 'COMPLETED' ? '답변완료' : '미답변' }}</span></td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination" v-if="totalPages > 0">
                    <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">이전</button>
                    <button v-for="page in totalPages" :key="page" class="page-btn" :class="{active: currentPage === page}" @click="currentPage = page">{{ page }}</button>
                    <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">다음</button>
                </div>
            </div>
        </div>

        <div class="modal-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
            <div class="modal-content">
                <div class="modal-header" style="padding:30px 40px; border-bottom:1px solid rgba(255,255,255,0.05); display:flex; justify-content:space-between; align-items:center;">
                    <h3 style="margin:0; color:#E8732A; font-weight:800;">PRODUCT Q&amp;A DETAIL</h3>
                    <span style="cursor:pointer; color:#fff; font-size:35px;" @click="isModalOpen = false">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="q-box">
                        <span class="modal-info-tag" style="font-size:11px; font-weight:900; color:#E8732A; background:rgba(232,115,42,0.15); padding:5px 12px; border-radius:7px; margin-bottom:12px; display:inline-block;">USER QUESTION</span>

                        <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:12px;">
                            <span style="color:#fff; font-size:18px; font-weight:800;">{{ selected.productName }}</span>
                            <span v-if="selected.optionName" style="font-size:12px; color:#8a8f9d; background:rgba(255,255,255,0.05); padding:4px 10px; border-radius:6px;">{{ selected.optionName }}</span>
                            <span v-if="selected.secretYn === 'Y'" style="font-size:12px; color:#f1c40f; font-weight:700;">🔒 비밀글</span>
                        </div>

                        <div style="color:#bdc3c7; line-height:1.8; white-space:pre-wrap; font-size:15px;">{{ selected.questionContent }}</div>
                    </div>

                    <div v-if="selected.status === 'COMPLETED' && !isEditMode">
                        <span class="modal-info-tag" style="font-size:11px; font-weight:900; color:#2ecc71; background:rgba(46,204,113,0.15); padding:5px 12px; border-radius:7px; margin-bottom:12px; display:inline-block;">ADMIN REPLY</span>
                        <div class="a-box">{{ selected.answerContent }}</div>
                        <div style="text-align:right; margin-top:30px;"><button class="p-btn-secondary" @click="isEditMode = true" style="background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:#bdc3c7; padding:12px 25px; border-radius:12px; cursor:pointer;">내용 수정하기</button></div>
                    </div>
                    <div v-else>
                        <span class="modal-info-tag" style="font-size:11px; font-weight:900; color:#E8732A; background:rgba(232,115,42,0.15); padding:5px 12px; border-radius:7px; margin-bottom:12px; display:inline-block;">WRITE ANSWER</span>
                        <textarea class="answer-area" v-model="answerText" placeholder="고객에게 전달할 답변 내용을 입력하세요..."></textarea>
                        <div style="text-align:right; margin-top:30px;"><button class="p-btn" @click="fnSaveAnswer">답변 저장하기</button></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    qnaList: [], statusFilter: '', isModalOpen: false,
                    selected: {}, answerText: '', isEditMode: false,
                    currentPage: 1, pageSize: 10, sortOrder: 'desc'
                };
            },
            computed: {
                pagedList() {
                    const start = (this.currentPage - 1) * this.pageSize;
                    return this.qnaList.slice(start, start + this.pageSize);
                },
                totalPages() { return Math.ceil(this.qnaList.length / this.pageSize) || 1; }
            },
            methods: {
                fnLoad() {
                    const self = this;
                    $.ajax({
                        url: "product-qna/list.dox", type: "POST", data: { status: self.statusFilter },
                        success: function(res) {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                self.qnaList = data.list || [];
                                self.fnSort(); self.currentPage = 1;
                            }
                        }
                    });
                },
                fnSort() {
                    this.qnaList.sort((a, b) => {
                        return this.sortOrder === 'desc' ? b.qnaId - a.qnaId : a.qnaId - b.qnaId;
                    });
                },
                fnSetFilter(s) { this.statusFilter = s; this.fnLoad(); },
                fnDetail(item) { this.selected = item; this.answerText = item.answerContent || ''; this.isEditMode = false; this.isModalOpen = true; },
                fnSaveAnswer() {
                    if (!this.answerText.trim()) return;
                    $.ajax({
                        url: "product-qna/answer.dox", type: "POST",
                        data: { qnaId: this.selected.qnaId, answer: this.answerText },
                        success: (res) => { alert("저장되었습니다."); this.isModalOpen = false; this.fnLoad(); }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
