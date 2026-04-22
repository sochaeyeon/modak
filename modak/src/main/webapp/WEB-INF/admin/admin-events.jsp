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
                <button class="filter-btn" :class="{active: filterStatus === 'ALL'}" @click="fnChangeFilter('ALL')">전체</button>
                <button class="filter-btn" :class="{active: filterStatus === 'READY'}" @click="fnChangeFilter('READY')">대기 중 ⏳</button>
                <button class="filter-btn" :class="{active: filterStatus === 'ING'}" @click="fnChangeFilter('ING')">진행 중 🔥</button>
                <button class="filter-btn" :class="{active: filterStatus === 'END'}" @click="fnChangeFilter('END')">종료됨</button>
            </div>

            <div class="event-card-wrap">
                <div class="event-item" v-for="item in pagedList" :key="item.EVENT_ID">
                    <div class="event-img-box">
                        <img :src="item.THUMBNAIL || '/img/no-image.png'">
                    </div>
                    <div class="event-info">
                        <span class="ev-badge" :class="{
                            'ev-ready': item.STATUS_CODE === 'READY',
                            'ev-ing': item.STATUS_CODE === 'ING',
                            'ev-end': item.STATUS_CODE === 'END'
                        }">
                            {{ item.STATUS_CODE === 'READY' ? '대기 중 ⏳' : 
                               item.STATUS_CODE === 'ING' ? '진행 중 🔥' : '종료됨' }}
                        </span>
                        <div class="event-name">{{ item.TITLE }}</div>
                        <div class="event-date">📅 {{ item.START_DATE }} ~ {{ item.END_DATE }}</div>
                        <div style="display:flex; gap:10px; margin-top:10px;">
                            <button class="p-btn-secondary" style="flex:1; padding:8px;" @click="fnOpenEdit(item)">수정</button>
                            <button class="p-btn-secondary" style="flex:1; padding:8px; color:#ec7063;" @click="fnDelete(item.EVENT_ID)">삭제</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ev-pagination" v-if="totalPages > 1">
                <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">&lt;</button>
                <button v-for="p in totalPages" :key="p" 
                        class="page-btn" :class="{active: currentPage === p}"
                        @click="currentPage = p">{{ p }}</button>
                <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">&gt;</button>
            </div>

            <div v-if="filteredList.length === 0" style="text-align:center; padding:120px 0; color:var(--ev-text-muted);">
                조건에 맞는 이벤트가 없습니다.
            </div>
        </div>

        <div class="ev-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="ev-modal">
                <div style="font-size:22px; font-weight:700; margin-bottom:30px; color:#fff">
                    {{ isEdit ? '🛠️ 이벤트 정보 수정' : '🆕 신규 프로모션 등록' }}
                </div>
                <label style="font-size:11px; color:var(--ev-text-muted); margin-bottom:5px; display:block;">제목</label>
                <input class="ev-input" v-model="form.title">
                
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px">
                    <div>
                        <label style="font-size:11px; color:var(--ev-text-muted); margin-bottom:5px; display:block;">시작일</label>
                        <input type="date" class="ev-input" v-model="form.startDate">
                    </div>
                    <div>
                        <label style="font-size:11px; color:var(--ev-text-muted); margin-bottom:5px; display:block;">종료일</label>
                        <input type="date" class="ev-input" v-model="form.endDate">
                    </div>
                </div>
                <label style="font-size:11px; color:var(--ev-text-muted); margin-bottom:5px; display:block;">이미지 경로</label>
                <input class="ev-input" v-model="form.thumbnail">

                <div style="display:flex; justify-content:flex-end; gap:15px; margin-top:30px">
                    <button @click="modalOpen=false" style="background:transparent; color:var(--ev-text-muted); border:none; cursor:pointer;">닫기</button>
                    <button class="p-btn" @click="fnSave">저장하기</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    eventList: [],
                    filterStatus: 'ALL',
                    currentPage: 1,
                    pageSize: 12,
                    modalOpen: false, isEdit: false,
                    form: { eventId: '', title: '', startDate: '', endDate: '', thumbnail: '' }
                };
            },
            computed: {
                filteredList() {
                    let list = [...this.eventList];
                    
                    // 1. 상태 필터링
                    if (this.filterStatus !== 'ALL') {
                        list = list.filter(i => i.STATUS_CODE === this.filterStatus);
                    }
                    
                    // 2. 정렬 로직 (진행중 1순위 -> 대기중 2순위 -> 종료됨 3순위)
                    const order = { 'ING': 1, 'READY': 2, 'END': 3 };
                    return list.sort((a, b) => {
                        if (a.STATUS_CODE !== b.STATUS_CODE) {
                            return order[a.STATUS_CODE] - order[b.STATUS_CODE];
                        }
                        return new Date(a.START_DATE) - new Date(b.START_DATE);
                    });
                },
                pagedList() {
                    const start = (this.currentPage - 1) * this.pageSize;
                    return this.filteredList.slice(start, start + this.pageSize);
                },
                totalPages() {
                    return Math.ceil(this.filteredList.length / this.pageSize);
                }
            },
            methods: {
                fnLoad() {
                    $.ajax({
                        url: "/admin/event/list.dox",
                        type: "POST",
                        data: { page: 1, pageSize: 100 },
                        success: (res) => { if(res.result === "success") this.eventList = res.list; }
                    });
                },
                fnChangeFilter(status) {
                    this.filterStatus = status;
                    this.currentPage = 1;
                },
                fnOpenAdd() {
                    this.isEdit = false;
                    this.form = { title: '', startDate: '', endDate: '', thumbnail: '' };
                    this.modalOpen = true;
                },
                fnOpenEdit(item) {
                    this.isEdit = true;
                    this.form = { eventId: item.EVENT_ID, title: item.TITLE, startDate: item.START_DATE, endDate: item.END_DATE, thumbnail: item.THUMBNAIL };
                    this.modalOpen = true;
                },
                fnSave() {
                    $.ajax({
                        url: "/admin/event/save.dox",
                        type: "POST",
                        data: this.form,
                        success: (res) => { if(res.result === "success") { this.modalOpen = false; this.fnLoad(); } }
                    });
                },
                fnDelete(id) {
                    if(!confirm("삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/event/delete.dox",
                        type: "POST",
                        data: { eventId: id },
                        success: (res) => { if(res.result === "success") this.fnLoad(); }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>