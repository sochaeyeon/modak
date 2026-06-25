<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <h2 class="inq-page-title">🙋 1:1 문의 관리</h2>
                <div class="inq-header-controls">
                    <select v-model="sortOrder" @change="fnSort" class="inq-sort-select">
                        <option value="desc">🔥 최신순</option>
                        <option value="asc">⏳ 과거순</option>
                    </select>
                    <div class="filter-tab-container">
                        <button class="filter-tab" :class="{active: statusFilter === ''}"         @click="fnSetFilter('')">전체</button>
                        <button class="filter-tab" :class="{active: statusFilter === 'WAITING'}"  @click="fnSetFilter('WAITING')">미답변</button>
                        <button class="filter-tab" :class="{active: statusFilter === 'ANSWERED'}" @click="fnSetFilter('ANSWERED')">답변완료</button>
                    </div>
                </div>
            </div>

            <!-- ── 상태 바 ── -->
            <div class="status-bar">
                <span class="status-bar-dot"></span>
                조회된 문의: <strong>{{ inquiryList.length }}건</strong>
                &nbsp;|&nbsp; {{ currentPage }} / {{ Math.max(totalPages, 1) }} 페이지
            </div>

            <!-- ── 테이블 ── -->
            <div class="review-table-card">
                <table class="r-table">
                    <thead>
                        <tr>
                            <th style="width:8%">번호</th>
                            <th class="left-align" style="width:14%">작성자</th>
                            <th class="left-align" style="width:46%">문의 내용</th>
                            <th style="width:16%">작성일자</th>
                            <th style="width:16%">진행상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="r-table-row" v-for="item in pagedList" :key="item.inquiry_id" @click="fnDetail(item)">
                            <td class="inq-id-cell">#{{ item.inquiry_id }}</td>
                            <td class="left-align"><span class="user-badge">{{ item.user_id }}</span></td>
                            <td class="left-align">
                                <div class="inq-title">
                                    {{ item.title }}
                                    <span class="inq-img-badge" v-if="item.img_list && item.img_list.length > 0">📷</span>
                                </div>
                                <div class="text-ellipsis">{{ item.content }}</div>
                            </td>
                            <td class="inq-date-cell">{{ item.created_at }}</td>
                            <td>
                                <span :class="['status-badge', item.status === 'ANSWERED' ? 'status-y' : 'status-n']">
                                    {{ item.status === 'ANSWERED' ? '답변완료' : '미답변' }}
                                </span>
                            </td>
                        </tr>
                        <tr v-if="!pagedList.length">
                            <td colspan="5" class="inq-empty">문의 내역이 없습니다</td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination" v-if="totalPages > 1">
                    <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">이전</button>
                    <button v-for="page in totalPages" :key="page"
                            class="page-btn" :class="{active: currentPage === page}"
                            @click="currentPage = page">{{ page }}</button>
                    <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">다음</button>
                </div>
            </div>
        </div>

        <!-- ── 문의 상세 모달 ── -->
        <transition name="inq-modal-fade">
            <div class="modal-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
                <div class="modal-content">
                    <div class="inq-modal-header">
                        <span class="inq-modal-badge">INQUIRY DETAIL</span>
                        <button class="inq-modal-close" @click="isModalOpen = false">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="q-box">
                            <span class="section-tag tag-question">USER QUESTION</span>
                            <div class="inq-modal-title">{{ selected.title }}</div>
                            <div class="inq-modal-content">{{ selected.content }}</div>
                            <div v-if="selected.img_list && selected.img_list.length > 0" class="img-container">
                                <img v-for="url in selected.img_list" :key="url" :src="url" class="inquiry-img" @click.stop="zoomImg = url">
                            </div>
                        </div>

                        <div v-if="selected.status === 'ANSWERED' && !isEditMode">
                            <span class="section-tag tag-answer">ADMIN REPLY</span>
                            <div class="a-box">{{ selected.answer }}</div>
                            <div class="inq-action-row">
                                <button class="p-btn-secondary" @click="isEditMode = true">내용 수정하기</button>
                            </div>
                        </div>
                        <div v-else>
                            <span class="section-tag tag-write">WRITE ANSWER</span>
                            <textarea class="answer-area" v-model="answerText" placeholder="고객에게 전달할 답변 내용을 입력하세요..."></textarea>
                            <div class="inq-action-row">
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
            <div class="inq-confirm-overlay" v-if="showConfirm">
                <div class="inq-confirm-box">
                    <div class="inq-confirm-icon">{{ confirmConfig.icon || '💬' }}</div>
                    <div class="inq-confirm-title">{{ confirmConfig.title }}</div>
                    <div class="inq-confirm-msg" v-html="confirmConfig.msg"></div>
                    <div class="inq-confirm-btns">
                        <button class="p-btn-secondary inq-confirm-cancel" @click="showConfirm = false">취소</button>
                        <button class="p-btn" :class="confirmConfig.danger ? 'p-btn-danger' : ''"
                                @click="fnRunConfirm">{{ confirmConfig.okLabel || '확인' }}</button>
                    </div>
                </div>
            </div>
        </transition>
    </div>

    <div class="inq-toast" id="inqToast"></div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    inquiryList: [], statusFilter: '', isModalOpen: false,
                    selected: { img_list: [] }, answerText: '', isEditMode: false,
                    currentPage: 1, pageSize: 10, sortOrder: 'desc', zoomImg: null,
                    showConfirm: false,
                    confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, onConfirm: null }
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
                toast(msg, type = 'success') {
                    const el = document.getElementById('inqToast');
                    el.textContent = msg;
                    el.className = 'inq-toast show ' + type;
                    clearTimeout(el._t);
                    el._t = setTimeout(() => { el.className = 'inq-toast'; }, 3000);
                },
                fnShowConfirm(cfg) { this.confirmConfig = cfg; this.showConfirm = true; },
                fnRunConfirm() {
                    this.showConfirm = false;
                    if (this.confirmConfig.onConfirm) this.confirmConfig.onConfirm();
                },
                fnLoad() {
                    $.ajax({
                        url: "inquiry/list.dox", type: "POST", data: { status: this.statusFilter },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.inquiryList = data.list.map(item => {
                                    const lowerItem = {};
                                    for (let key in item) { lowerItem[key.toLowerCase()] = item[key]; }
                                    lowerItem.img_list = lowerItem.img_urls ? lowerItem.img_urls.split(',') : [];
                                    return lowerItem;
                                });
                                this.fnSort();
                                this.currentPage = 1;
                            }
                        }
                    });
                },
                fnSort() {
                    this.inquiryList.sort((a, b) =>
                        this.sortOrder === 'desc' ? b.inquiry_id - a.inquiry_id : a.inquiry_id - b.inquiry_id
                    );
                },
                fnSetFilter(s) { this.statusFilter = s; this.fnLoad(); },
                fnDetail(item) {
                    this.selected = item;
                    this.answerText = item.answer || '';
                    this.isEditMode = false;
                    this.isModalOpen = true;
                },
                fnSaveAnswer() {
                    if (!this.answerText.trim()) {
                        this.toast('⚠️ 답변 내용을 입력해주세요', 'error');
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
                        url: "inquiry/answer.dox", type: "POST",
                        data: { inquiryId: this.selected.inquiry_id, answer: this.answerText },
                        success: () => {
                            this.toast('✅ 답변이 저장되었습니다', 'success');
                            this.isModalOpen = false;
                            this.fnLoad();
                        },
                        error: () => {
                            this.toast('⚠️ 저장에 실패했습니다. 다시 시도해주세요', 'error');
                        }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
