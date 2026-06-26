<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 문의 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-product-qna.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="qna-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="qna-page-header">
        <div class="qna-title-wrap">
            <div class="qna-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                    <line x1="9" y1="10" x2="15" y2="10"/>
                    <line x1="12" y1="7" x2="12" y2="13"/>
                </svg>
            </div>
            <div>
                <div class="qna-page-title">상품 문의 관리</div>
                <div class="qna-page-subtitle">상품별 고객 문의를 확인하고 답변합니다</div>
            </div>
        </div>
        <button class="qna-dashboard-btn" @click="location.href='/admin/dashboard.do'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── 통계 스트립 ── -->
    <div class="qna-stat-strip">
        <div class="qna-stat-item">
            <div class="qna-stat-icon-wrap qna-stat-total">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                </svg>
            </div>
            <div class="qna-stat-body">
                <div class="qna-stat-val">{{ qnaAll.length }}</div>
                <div class="qna-stat-lbl">전체 문의</div>
            </div>
        </div>
        <div class="qna-stat-divider"></div>
        <div class="qna-stat-item">
            <div class="qna-stat-icon-wrap qna-stat-wait">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12 6 12 12 16 14"/>
                </svg>
            </div>
            <div class="qna-stat-body">
                <div class="qna-stat-val qna-v-warn">{{ waitingCount }}</div>
                <div class="qna-stat-lbl">미답변</div>
            </div>
        </div>
        <div class="qna-stat-divider"></div>
        <div class="qna-stat-item">
            <div class="qna-stat-icon-wrap qna-stat-done">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
            </div>
            <div class="qna-stat-body">
                <div class="qna-stat-val qna-v-green">{{ completedCount }}</div>
                <div class="qna-stat-lbl">답변완료</div>
            </div>
        </div>
        <div class="qna-stat-spacer"></div>
        <div class="qna-sort-wrap">
            <svg class="qna-sort-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="15" y2="12"/><line x1="3" y1="18" x2="9" y2="18"/>
            </svg>
            <select class="qna-sort-select" v-model="sortOrder" @change="fnSort">
                <option value="desc">최신순</option>
                <option value="asc">과거순</option>
            </select>
        </div>
    </div>

    <!-- ── 필터 + 테이블 카드 ── -->
    <div class="qna-card">
        <div class="qna-filter-bar">
            <button class="qna-filter-btn" :class="{active: statusFilter === ''}"          @click="fnSetFilter('')">
                <span class="qfd-dot qfd-all"></span> 전체
                <span class="qfd-cnt">{{ qnaAll.length }}</span>
            </button>
            <button class="qna-filter-btn" :class="{active: statusFilter === 'WAITING'}"   @click="fnSetFilter('WAITING')">
                <span class="qfd-dot qfd-warn"></span> 미답변
                <span class="qfd-cnt">{{ waitingCount }}</span>
            </button>
            <button class="qna-filter-btn" :class="{active: statusFilter === 'COMPLETED'}" @click="fnSetFilter('COMPLETED')">
                <span class="qfd-dot qfd-green"></span> 답변완료
                <span class="qfd-cnt">{{ completedCount }}</span>
            </button>
        </div>

        <table class="qna-table">
            <thead>
                <tr>
                    <th style="width:6%">번호</th>
                    <th class="t-left" style="width:18%">상품명</th>
                    <th style="width:10%">작성자</th>
                    <th class="t-left">문의 내용</th>
                    <th style="width:13%">작성일</th>
                    <th style="width:10%">상태</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="pagedList.length === 0">
                    <td colspan="6" class="qna-empty-row">
                        <div class="qna-empty-icon">💬</div>
                        <div>문의 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="qna-row" v-for="item in pagedList" :key="item.qnaId" @click="fnDetail(item)">
                    <td><span class="qna-id-badge">#{{ item.qnaId }}</span></td>
                    <td class="qna-prod-td">
                        <span class="qna-prod-name">{{ item.productName }}</span>
                    </td>
                    <td><span class="qna-user-chip">{{ item.nickname }}</span></td>
                    <td class="qna-content-td">
                        <span v-if="item.optionName" class="qna-option-chip">{{ item.optionName }}</span>
                        <span v-if="item.secretYn === 'Y'" class="qna-secret-icon">🔒</span>
                        <span class="qna-content-text">{{ item.questionContent }}</span>
                    </td>
                    <td class="qna-date">{{ item.createdAt }}</td>
                    <td>
                        <span class="qna-sbadge" :class="item.status === 'COMPLETED' ? 'sbadge-done' : 'sbadge-wait'">
                            {{ item.status === 'COMPLETED' ? '답변완료' : '미답변' }}
                        </span>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="qna-pagination" v-if="totalPages > 1">
            <button class="qpg-btn" :disabled="currentPage === 1"          @click="currentPage--">&#8249;</button>
            <button class="qpg-btn" v-for="p in totalPages" :key="p"
                    :class="{active: currentPage === p}" @click="currentPage = p">{{ p }}</button>
            <button class="qpg-btn" :disabled="currentPage === totalPages" @click="currentPage++">&#8250;</button>
        </div>
    </div>

</div><!-- qna-container -->

<!-- ════════════════════════════════
     Q&A 상세 모달
════════════════════════════════ -->
<transition name="qna-modal-fade">
    <div class="qna-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
        <div class="qna-modal">
            <div class="qna-modal-header">
                <div class="qna-modal-title-wrap">
                    <div class="qna-modal-icon">💬</div>
                    <div>
                        <div class="qna-modal-title">상품 문의 상세</div>
                        <div class="qna-modal-subtitle">{{ selected.productName }}</div>
                    </div>
                </div>
                <button class="qna-modal-close" @click="isModalOpen = false">✕</button>
            </div>

            <div class="qna-modal-body">
                <!-- 문의 정보 메타 -->
                <div class="qna-meta-row">
                    <div class="qna-meta-item">
                        <span class="qna-meta-lbl">작성자</span>
                        <span class="qna-meta-val">{{ selected.nickname }}</span>
                    </div>
                    <div class="qna-meta-item">
                        <span class="qna-meta-lbl">작성일</span>
                        <span class="qna-meta-val">{{ selected.createdAt }}</span>
                    </div>
                    <div class="qna-meta-item" v-if="selected.optionName">
                        <span class="qna-meta-lbl">옵션</span>
                        <span class="qna-meta-val">{{ selected.optionName }}</span>
                    </div>
                    <div class="qna-meta-item">
                        <span class="qna-meta-lbl">비밀글</span>
                        <span class="qna-meta-val" :style="{color: selected.secretYn === 'Y' ? '#F1C40F' : '#8890a8'}">
                            {{ selected.secretYn === 'Y' ? '🔒 비밀글' : '공개' }}
                        </span>
                    </div>
                </div>

                <!-- 질문 -->
                <div class="qna-section-label qna-lbl-q">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    USER QUESTION
                </div>
                <div class="qna-q-box">{{ selected.questionContent }}</div>

                <!-- 답변: 완료 상태 + 수정 아님 -->
                <div v-if="selected.status === 'COMPLETED' && !isEditMode">
                    <div class="qna-section-label qna-lbl-a">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                        ADMIN REPLY
                    </div>
                    <div class="qna-a-box">{{ selected.answerContent }}</div>
                    <div class="qna-answer-actions">
                        <button class="qna-edit-btn" @click="isEditMode = true">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            답변 수정하기
                        </button>
                    </div>
                </div>

                <!-- 답변 입력 -->
                <div v-else>
                    <div class="qna-section-label qna-lbl-write">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                        {{ isEditMode ? 'EDIT ANSWER' : 'WRITE ANSWER' }}
                    </div>
                    <textarea class="qna-answer-textarea"
                              v-model="answerText"
                              placeholder="고객에게 전달할 답변을 입력하세요..."
                              rows="5"></textarea>
                    <div class="qna-answer-actions">
                        <button v-if="isEditMode" class="qna-cancel-btn" @click="isEditMode = false">취소</button>
                        <button class="qna-save-btn" @click="fnSaveAnswer" :disabled="isSaving">
                            <span v-if="isSaving" class="qna-spinner"></span>
                            {{ isSaving ? '저장중...' : '💾 답변 저장' }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</transition>

<!-- ── 토스트 ── -->
<div class="qna-toast-container">
    <transition-group name="qna-toast-slide">
        <div v-for="t in toasts" :key="t.id" class="qna-toast-item" :class="'qna-toast-' + t.type">
            <div class="qna-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
            <div class="qna-toast-msg">{{ t.message }}</div>
            <button class="qna-toast-close" @click="removeToast(t.id)">✕</button>
            <div class="qna-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
        </div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                qnaAll: [], qnaList: [],
                statusFilter: '', sortOrder: 'desc',
                isModalOpen: false,
                selected: {}, answerText: '', isEditMode: false,
                currentPage: 1, pageSize: 12,
                isSaving: false,
                toasts: []
            };
        },
        computed: {
            waitingCount()   { return this.qnaAll.filter(q => q.status !== 'COMPLETED').length; },
            completedCount() { return this.qnaAll.filter(q => q.status === 'COMPLETED').length; },
            pagedList() {
                const start = (this.currentPage - 1) * this.pageSize;
                return this.qnaList.slice(start, start + this.pageSize);
            },
            totalPages() { return Math.ceil(this.qnaList.length / this.pageSize) || 1; }
        },
        methods: {
            /* ── 토스트 ── */
            toast(msg, type = 'success', duration = 3000) {
                const id = Date.now() + Math.random();
                this.toasts.push({ id, message: msg, type, duration });
                setTimeout(() => this.removeToast(id), duration);
            },
            removeToast(id) { this.toasts = this.toasts.filter(t => t.id !== id); },

            /* ── 데이터 로드 ── */
            fnLoad() {
                $.ajax({
                    url: 'product-qna/list.dox', type: 'POST',
                    data: { status: this.statusFilter },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') {
                            this.qnaList = data.list || [];
                            this.qnaAll  = data.list || [];
                            this.fnSort();
                            this.currentPage = 1;
                        }
                    },
                    error: () => this.toast('문의 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnSort() {
                this.qnaList.sort((a, b) =>
                    this.sortOrder === 'desc' ? b.qnaId - a.qnaId : a.qnaId - b.qnaId
                );
            },
            fnSetFilter(s) { this.statusFilter = s; this.fnLoad(); },

            /* ── 상세 모달 ── */
            fnDetail(item) {
                this.selected    = { ...item };
                this.answerText  = item.answerContent || '';
                this.isEditMode  = false;
                this.isModalOpen = true;
            },

            /* ── 답변 저장 ── */
            fnSaveAnswer() {
                if (!this.answerText.trim()) {
                    this.toast('답변 내용을 입력해주세요.', 'error');
                    return;
                }
                this.isSaving = true;
                $.ajax({
                    url: 'product-qna/answer.dox', type: 'POST',
                    data: { qnaId: this.selected.qnaId, answer: this.answerText },
                    success: (res) => {
                        this.isSaving = false;
                        this.isModalOpen = false;
                        this.toast('답변이 저장되었습니다.', 'success');
                        this.fnLoad();
                    },
                    error: () => {
                        this.isSaving = false;
                        this.toast('저장 중 오류가 발생했습니다.', 'error');
                    }
                });
            }
        },
        mounted() { this.fnLoad(); }
    }).mount('#app');
</script>
</body>
</html>
