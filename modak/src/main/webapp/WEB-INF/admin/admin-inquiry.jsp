<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1:1 문의 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-inquiry.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main" v-cloak>
        <div class="inquiry-container">

            <!-- ── 페이지 헤더 ── -->
            <div class="inq-page-header">
                <div class="inq-title-wrap">
                    <div class="inq-title-icon">🙋</div>
                    <div>
                        <div class="inq-page-title">1:1 문의 관리</div>
                        <div class="inq-page-subtitle">총 {{ inquiryList.length }}건의 문의</div>
                    </div>
                </div>
                <div class="inq-header-controls">
                    <select v-model="sortOrder" @change="fnSort" class="inq-sort-select">
                        <option value="desc">🔥 최신순</option>
                        <option value="asc">⏳ 과거순</option>
                    </select>
                    <div class="filter-tab-container">
                        <button class="filter-tab" :class="{active: statusFilter === ''}"         @click="fnSetFilter('')">
                            <span class="ftab-dot ftab-dot-all"></span> 전체
                        </button>
                        <button class="filter-tab" :class="{active: statusFilter === 'WAITING'}"  @click="fnSetFilter('WAITING')">
                            <span class="ftab-dot ftab-dot-wait"></span> 미답변
                        </button>
                        <button class="filter-tab" :class="{active: statusFilter === 'ANSWERED'}" @click="fnSetFilter('ANSWERED')">
                            <span class="ftab-dot ftab-dot-done"></span> 답변완료
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── 상태 바 ── -->
            <div class="status-bar">
                <span class="status-bar-dot"></span>
                조회된 문의 <strong>{{ inquiryList.length }}건</strong>
                <span class="status-divider">|</span>
                {{ currentPage }} / {{ Math.max(totalPages, 1) }} 페이지
            </div>

            <!-- ── 테이블 ── -->
            <div class="review-table-card">
                <table class="r-table">
                    <thead>
                        <tr>
                            <th style="width:7%">번호</th>
                            <th class="left-align" style="width:13%">작성자</th>
                            <th class="left-align" style="width:47%">문의 내용</th>
                            <th style="width:16%">작성일자</th>
                            <th style="width:17%">진행상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="r-table-row" v-for="item in pagedList" :key="item.inquiry_id" @click="fnDetail(item)">
                            <td class="inq-id-cell">#{{ item.inquiry_id }}</td>
                            <td class="left-align"><span class="user-badge">{{ item.user_id }}</span></td>
                            <td class="left-align">
                                <div class="inq-title-cell">
                                    {{ item.title }}
                                    <span class="inq-img-badge" v-if="item.img_list && item.img_list.length > 0">📷 사진</span>
                                </div>
                                <div class="text-ellipsis">{{ item.content }}</div>
                            </td>
                            <td class="inq-date-cell">{{ item.created_at }}</td>
                            <td>
                                <span :class="['status-badge', item.status === 'ANSWERED' ? 'status-y' : 'status-n']">
                                    <span class="sbadge-dot"></span>
                                    {{ item.status === 'ANSWERED' ? '답변완료' : '미답변' }}
                                </span>
                            </td>
                        </tr>
                        <tr v-if="!pagedList.length">
                            <td colspan="5" class="inq-empty">
                                <div class="inq-empty-icon">📭</div>
                                <div>문의 내역이 없습니다</div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination" v-if="totalPages > 1">
                    <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">&#8249;</button>
                    <button v-for="page in totalPages" :key="page"
                            class="page-btn" :class="{active: currentPage === page}"
                            @click="currentPage = page">{{ page }}</button>
                    <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">&#8250;</button>
                </div>
            </div>
        </div>

        <!-- ── 문의 상세 모달 ── -->
        <transition name="inq-modal-fade">
            <div class="modal-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
                <div class="modal-content">
                    <div class="inq-modal-header">
                        <div class="inq-modal-header-left">
                            <span class="inq-modal-badge">INQUIRY DETAIL</span>
                            <span class="inq-modal-status" :class="selected.status === 'ANSWERED' ? 'mstatus-done' : 'mstatus-wait'">
                                {{ selected.status === 'ANSWERED' ? '✅ 답변완료' : '⏳ 미답변' }}
                            </span>
                        </div>
                        <button class="inq-modal-close" @click="isModalOpen = false">✕</button>
                    </div>
                    <div class="modal-body">
                        <!-- 질문 -->
                        <div class="q-box">
                            <span class="section-tag tag-question">USER QUESTION</span>
                            <div class="inq-modal-title">{{ selected.title }}</div>
                            <div class="inq-modal-content">{{ selected.content }}</div>
                            <div v-if="selected.img_list && selected.img_list.length > 0" class="img-container">
                                <img v-for="url in selected.img_list" :key="url" :src="url"
                                     class="inquiry-img" @click.stop="zoomImg = url">
                            </div>
                        </div>

                        <!-- 기존 답변 보기 -->
                        <div v-if="selected.status === 'ANSWERED' && !isEditMode">
                            <span class="section-tag tag-answer">ADMIN REPLY</span>
                            <div class="a-box">{{ selected.answer }}</div>
                            <div class="inq-action-row">
                                <button class="p-btn-secondary" @click="isEditMode = true">✏️ 답변 수정하기</button>
                            </div>
                        </div>

                        <!-- 답변 작성/수정 -->
                        <div v-else>
                            <span class="section-tag tag-write">{{ isEditMode ? 'EDIT ANSWER' : 'WRITE ANSWER' }}</span>
                            <textarea class="answer-area" v-model="answerText"
                                      placeholder="고객에게 전달할 답변 내용을 입력하세요..."></textarea>
                            <div class="inq-action-row">
                                <button class="p-btn-secondary" v-if="isEditMode" @click="isEditMode = false" style="margin-right:10px">취소</button>
                                <button class="p-btn" @click="fnSaveAnswer">✅ 답변 저장하기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </transition>

        <!-- ── 이미지 확대 ── -->
        <div v-if="zoomImg" class="modal-overlay zoom-overlay" @click="zoomImg = null">
            <img :src="zoomImg" class="zoom-img">
        </div>

        <!-- ── 확인 모달 ── -->
        <transition name="inq-modal-fade">
            <div class="inq-confirm-overlay" v-if="showConfirm" @click.self="showConfirm = false">
                <div class="inq-confirm-box">
                    <div class="inq-confirm-icon">{{ confirmConfig.icon || '💬' }}</div>
                    <div class="inq-confirm-title">{{ confirmConfig.title }}</div>
                    <div class="inq-confirm-msg" v-html="confirmConfig.msg"></div>
                    <div class="inq-confirm-btns">
                        <button class="inq-cancel-btn" @click="showConfirm = false">취소</button>
                        <button class="p-btn" :class="confirmConfig.danger ? 'p-btn-danger' : ''"
                                @click="fnRunConfirm">{{ confirmConfig.okLabel || '확인' }}</button>
                    </div>
                </div>
            </div>
        </transition>

        <!-- ── 토스트 알림 (Vue 기반) ── -->
        <div class="inq-toast-container">
            <transition-group name="inq-toast-slide">
                <div v-for="t in toasts" :key="t.id" class="inq-toast-item" :class="'inq-toast-' + t.type">
                    <div class="inq-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
                    <div class="inq-toast-msg">{{ t.message }}</div>
                    <button class="inq-toast-close" @click="removeToast(t.id)">✕</button>
                    <div class="inq-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
                </div>
            </transition-group>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    inquiryList: [],
                    statusFilter: '',
                    isModalOpen: false,
                    selected: { img_list: [] },
                    answerText: '',
                    isEditMode: false,
                    currentPage: 1,
                    pageSize: 10,
                    sortOrder: 'desc',
                    zoomImg: null,
                    showConfirm: false,
                    confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, onConfirm: null },
                    toasts: []
                };
            },
            computed: {
                pagedList() {
                    const start = (this.currentPage - 1) * this.pageSize;
                    return this.inquiryList.slice(start, start + this.pageSize);
                },
                totalPages() { return Math.ceil(this.inquiryList.length / this.pageSize); }
            },
            methods: {
                /* ── 토스트 ── */
                toast(msg, type = 'success', duration = 3000) {
                    const id = Date.now() + Math.random();
                    this.toasts.push({ id, message: msg, type, duration });
                    setTimeout(() => this.removeToast(id), duration);
                },
                removeToast(id) {
                    this.toasts = this.toasts.filter(t => t.id !== id);
                },

                /* ── 확인 모달 ── */
                fnShowConfirm(cfg) { this.confirmConfig = cfg; this.showConfirm = true; },
                fnRunConfirm() {
                    this.showConfirm = false;
                    if (this.confirmConfig.onConfirm) this.confirmConfig.onConfirm();
                },

                /* ── 데이터 로드 ── */
                fnLoad() {
                    $.ajax({
                        url: "inquiry/list.dox",
                        type: "POST",
                        data: { status: this.statusFilter },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.inquiryList = data.list.map(item => {
                                    const lower = {};
                                    for (let key in item) { lower[key.toLowerCase()] = item[key]; }
                                    lower.img_list = lower.img_urls ? lower.img_urls.split(',') : [];
                                    return lower;
                                });
                                this.fnSort();
                                this.currentPage = 1;
                            }
                        },
                        error: () => {
                            this.toast('문의 목록을 불러오지 못했습니다.', 'error');
                        }
                    });
                },
                fnSort() {
                    this.inquiryList.sort((a, b) =>
                        this.sortOrder === 'desc' ? b.inquiry_id - a.inquiry_id : a.inquiry_id - b.inquiry_id
                    );
                },
                fnSetFilter(s) { this.statusFilter = s; this.fnLoad(); },

                /* ── 상세 보기 ── */
                fnDetail(item) {
                    this.selected = item;
                    this.answerText = item.answer || '';
                    this.isEditMode = false;
                    this.isModalOpen = true;
                },

                /* ── 답변 저장 ── */
                fnSaveAnswer() {
                    if (!this.answerText.trim()) {
                        this.toast('답변 내용을 입력해주세요.', 'error');
                        return;
                    }
                    this.fnShowConfirm({
                        icon: '💬',
                        title: '답변을 저장할까요?',
                        msg: '<b>' + this.selected.title + '</b><br>작성한 답변이 고객에게 전달됩니다.',
                        okLabel: '저장하기',
                        onConfirm: () => this.fnDoSaveAnswer()
                    });
                },
                fnDoSaveAnswer() {
                    $.ajax({
                        url: "inquiry/answer.dox",
                        type: "POST",
                        data: { inquiryId: this.selected.inquiry_id, answer: this.answerText },
                        success: () => {
                            this.toast('답변이 성공적으로 저장되었습니다.', 'success');
                            this.isModalOpen = false;
                            this.fnLoad();
                        },
                        error: () => {
                            this.toast('저장에 실패했습니다. 다시 시도해주세요.', 'error');
                        }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
