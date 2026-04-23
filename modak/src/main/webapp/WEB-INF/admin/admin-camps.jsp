<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JasperException (#{...} 에러) 방지 설정 --%>
<jsp:directive.page deferredSyntaxAllowedAsLiteral="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>캠핑장 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-camps.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="camp-page-container">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:32px;">
                <div>
                    <h2 style="color:#fff; margin:0;">⛺ 캠핑장 관리</h2>
                    <p style="color:var(--c-text-muted); font-size:14px;">중복 제거 및 이미지 연동이 완료된 목록입니다.</p>
                </div>
                <button class="p-btn" @click="location.href='/admin/camp-add.do'">+ 새 캠핑장 등록</button>
            </div>

            <div class="member-search-bar" style="background:var(--c-card); padding:18px; border-radius:18px; margin-bottom:24px; display:flex; gap:12px; border:1px solid var(--c-border);">
                <input type="text" class="m-input" v-model="keyword" placeholder="캠핑장명 또는 주소 검색" @keyup.enter="fnLoad" style="flex:1; background:#262a3a; border:none; padding:12px; border-radius:10px; color:#fff; outline:none;">
                <button class="p-btn" @click="fnLoad">검색</button>
            </div>

            <div class="camp-table-card">
                <table class="c-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>대표이미지</th>
                            <th>캠핑장명</th>
                            <th>구분</th>
                            <th>주소</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in campList" :key="item.CAMP_ID">
                            <%-- #{...} 대신 Vue 문법 {{...}} 사용으로 에러 해결 --%>
                            <td style="color:var(--c-text-muted); font-size:12px;">ID: {{ item.CAMP_ID }}</td>
                            <td>
                                <img v-if="item.IMG_URL" :src="item.IMG_URL" class="camp-thumb">
                                <div v-else class="camp-thumb no-img">No Image</div>
                            </td>
                            <td @click="fnDetail(item.CAMP_ID)" style="cursor:pointer; font-weight:600; color:#fff; text-decoration:underline;">
                                {{ item.CAMP_NAME }}
                            </td>
                            <td><span class="badge-induty">{{ item.INDUTY }}</span></td>
                            <td style="text-align:left; font-size:13px; color:var(--c-text-muted)">{{ item.ADDRESS }}</td>
                            <td>
                                <div style="display:flex; gap:8px; justify-content:center;">
                                    <button class="p-btn-secondary" @click="fnDetail(item.CAMP_ID)">수정</button>
                                    <button class="p-btn-secondary btn-delete" @click="fnDelete(item.CAMP_ID)">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="modal-overlay" v-if="isModalOpen" @click.self="isModalOpen = false">
            <div class="modal-content">
                <h3 style="margin-top:0; color:var(--c-accent);">🛠️ 정보 수정</h3>
                <div class="modal-body">
                    <img v-if="selectedCamp.IMG_URL" :src="selectedCamp.IMG_URL" class="modal-img-preview">
                    <label style="color:var(--c-text-muted); font-size:11px;">이미지 URL</label>
                    <input type="text" class="modal-input" v-model="selectedCamp.IMG_URL">
                    
                    <label style="color:var(--c-text-muted); font-size:11px;">캠핑장 이름</label>
                    <input type="text" class="modal-input" v-model="selectedCamp.CAMP_NAME">
                    
                    <label style="color:var(--c-text-muted); font-size:11px;">주소 (ADDRESS)</label>
                    <input type="text" class="modal-input" v-model="selectedCamp.ADDRESS">
                </div>
                <div style="display:flex; justify-content:flex-end; gap:10px;">
                    <button class="p-btn-secondary" @click="isModalOpen = false">닫기</button>
                    <button class="p-btn" @click="fnSaveEdit">저장하기</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() { return { campList: [], keyword: '', isModalOpen: false, selectedCamp: {} }; },
            methods: {
                fnLoad() {
                    const self = this;
                    $.ajax({
                        url: "/admin/camp/list.dox",
                        type: "POST",
                        data: { keyword: self.keyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if(data.result === "success") self.campList = data.list;
                        }
                    });
                },
                fnDetail(cId) {
                    const self = this;
                    $.ajax({
                        url: "/admin/camp/detail.dox",
                        type: "POST",
                        data: { campId: cId },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                self.selectedCamp = data.info;
                                self.isModalOpen = true;
                            }
                        }
                    });
                },
                fnSaveEdit() {
                    if(!confirm("수정사항을 저장할까요?")) return;
                    $.ajax({
                        url: "/admin/camp/edit.dox",
                        type: "POST",
                        data: this.selectedCamp,
                        success: (res) => {
                            alert("수정 완료!");
                            this.isModalOpen = false;
                            this.fnLoad();
                        }
                    });
                },
                fnDelete(cId) {
                    if(!confirm("이 캠핑장 정보를 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/camp/remove.dox",
                        type: "POST",
                        data: { campId: cId },
                        success: (res) => {
                            alert("삭제되었습니다.");
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