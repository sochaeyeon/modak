<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>이벤트 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-events.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="event-page-container">
            <div class="event-header">
                <div class="event-title">🎁 프로모션 및 이벤트 관리</div>
                <div class="header-buttons">
                    <button class="p-btn-secondary" onclick="location.href='/admin/dashboard.do'">🏠 대시보드</button>
                    <button class="p-btn" @click="fnOpenAdd">+ 새 이벤트 등록</button>
                </div>
            </div>

            <div class="ev-filter-bar">
                <button v-for="st in ['ALL', 'READY', 'ING', 'END']" :key="st" 
                        class="filter-btn" :class="{active: filterStatus === st}" 
                        @click="fnChangeFilter(st)">
                    {{ st === 'ALL' ? '전체' : st === 'READY' ? '대기 중 ⏳' : st === 'ING' ? '진행 중 🔥' : '종료됨' }}
                </button>
            </div>

            <div class="event-card-wrap">
                <div class="event-item" v-for="item in pagedList" :key="item.EVENT_ID">
                    <div class="event-img-box">
                        <img :src="item.THUMBNAIL || '${pageContext.request.contextPath}/img/no-image.png'" @error="imgError">
                    </div>
                    <div class="event-info">
                        <span class="ev-badge" :class="'ev-' + (item.STATUS_CODE ? item.STATUS_CODE.toLowerCase() : 'ready')">
                            {{ item.STATUS_CODE === 'READY' ? '대기 중' : item.STATUS_CODE === 'ING' ? '진행 중' : '종료됨' }}
                        </span>
                        <div class="event-name">{{ item.TITLE }}</div>
                        <div class="event-date">📅 {{ item.START_DATE }} ~ {{ item.END_DATE }}</div>
                        <div class="ev-btn-group">
                            <button class="p-btn-secondary" @click="fnOpenEdit(item)">수정</button>
                            <button class="p-btn-secondary" style="color:#ec7063;" @click="fnDelete(item.EVENT_ID)">삭제</button>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="filteredList.length === 0" style="text-align:center; padding:100px 0; color:#8a8f9d;">
                등록된 이벤트가 없거나 데이터를 불러오는 중입니다.
            </div>

            <div class="ev-pagination" v-if="totalPages > 1">
                <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">&lt;</button>
                <button v-for="p in totalPages" :key="p" class="page-btn" :class="{active: currentPage === p}" @click="currentPage = p">{{ p }}</button>
                <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">&gt;</button>
            </div>
        </div>

        <div class="ev-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="ev-modal">
                <div class="modal-header">{{ isEdit ? '🛠️ 이벤트 정보 수정' : '🆕 신규 프로모션 등록' }}</div>
                
                <label class="modal-label">제목</label>
                <input class="ev-input" v-model="form.title" placeholder="이벤트 제목">
                
                <label class="modal-label">내용</label>
                <textarea class="ev-input" v-model="form.content" style="height:100px; resize:none;"></textarea>

                <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px">
                    <div><label class="modal-label">시작일</label><input type="date" class="ev-input" v-model="form.startDate"></div>
                    <div><label class="modal-label">종료일</label><input type="date" class="ev-input" v-model="form.endDate"></div>
                </div>

                <label class="modal-label">이미지 파일명</label>
                <div style="display:flex; gap:10px; align-items:center;">
                    <div class="event-img-box" style="width:50px; height:50px; margin:0;"><img :src="previewPath" @error="imgError"></div>
                    <input class="ev-input" v-model="form.img_path" placeholder="banner.png" style="margin:0;">
                </div>

                <div class="modal-footer">
                    <button class="modal-close-btn" @click="modalOpen=false">취소</button>
                    <button class="p-btn" @click="fnSave" :disabled="isSubmitting">
                        {{ isSubmitting ? '처리 중...' : (isEdit ? '수정 완료' : '등록하기') }}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    eventList: [], filterStatus: 'ALL', currentPage: 1, pageSize: 8,
                    modalOpen: false, isEdit: false, isSubmitting: false,
                    form: { eventId: '', title: '', content: '', startDate: '', endDate: '', img_path: '' }
                };
            },
            computed: {
                filteredList() {
                    const list = this.eventList || [];
                    if (this.filterStatus === 'ALL') return list;
                    return list.filter(i => i.STATUS_CODE === this.filterStatus);
                },
                pagedList() {
                    const start = (this.currentPage - 1) * this.pageSize;
                    return this.filteredList.slice(start, start + this.pageSize);
                },
                totalPages() { return Math.ceil(this.filteredList.length / this.pageSize) || 1; },
                previewPath() {
                    if(!this.form.img_path) return '${pageContext.request.contextPath}/img/no-image.png';
                    return this.form.img_path.includes('/') ? this.form.img_path : '/img/event/' + this.form.img_path;
                }
            },
            methods: {
                fnLoad() {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/event/list.dox",
                        type: "POST",
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                this.eventList = data.list || [];
                            }
                        },
                        error: () => { console.error("데이터 로드 실패"); }
                    });
                },
                fnSave() {
                    if(!this.form.title) return alert("제목을 입력하세요.");
                    if(this.isSubmitting) return;
                    this.isSubmitting = true;
                    
                    const saveData = {
                        eventId: this.form.eventId,
                        title: this.form.title,
                        content: this.form.content,
                        start_date: this.form.startDate,
                        end_date: this.form.endDate,
                        img_path: this.form.img_path.includes('/') ? this.form.img_path : '/img/event/' + this.form.img_path
                    };

                    const url = this.isEdit ? "/admin/event/update.dox" : "/admin/event/insert.dox";

                    $.ajax({
                        url: "${pageContext.request.contextPath}" + url,
                        type: "POST",
                        data: saveData,
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                alert("저장되었습니다.");
                                this.modalOpen = false;
                                this.fnLoad();
                            }
                        },
                        complete: () => { this.isSubmitting = false; }
                    });
                },
                fnDelete(id) {
                    if(!confirm("삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/event/delete.dox",
                        type: "POST",
                        data: { eventId: id },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                alert("삭제 완료");
                                this.fnLoad();
                            }
                        }
                    });
                },
                fnOpenAdd() {
                    this.isEdit = false;
                    this.form = { eventId: '', title: '', content: '', startDate: '', endDate: '', img_path: '' };
                    this.modalOpen = true;
                },
                fnOpenEdit(item) {
                    this.isEdit = true;
                    this.form = { 
                        eventId: item.EVENT_ID, title: item.TITLE, content: item.CONTENT, 
                        startDate: item.START_DATE, endDate: item.END_DATE,
                        img_path: item.THUMBNAIL ? item.THUMBNAIL.replace('/img/event/', '') : ''
                    };
                    this.modalOpen = true;
                },
                fnChangeFilter(s) { this.filterStatus = s; this.currentPage = 1; },
                imgError(e) {
                    if (e.target.dataset.error) return;
                    e.target.dataset.error = true;
                    e.target.src = '${pageContext.request.contextPath}/img/no-image.png';
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>