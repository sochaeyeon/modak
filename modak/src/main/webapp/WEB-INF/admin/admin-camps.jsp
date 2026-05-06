<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                    <p style="color:var(--c-text-muted); font-size:14px;">캠핑장 추가, 수정, 삭제가 가능합니다.</p>
                </div>
                <button class="p-btn" @click="openAddModal">+ 새 캠핑장 등록</button>
            </div>

            <!-- 검색 -->
            <div style="background:var(--c-card); padding:18px; border-radius:18px; margin-bottom:24px; display:flex; gap:12px; border:1px solid var(--c-border);">
                <input type="text" class="m-input" v-model="keyword" placeholder="캠핑장명 또는 주소 검색" @keyup.enter="fnLoad"
                    style="flex:1; background:#262a3a; border:none; padding:12px; border-radius:10px; color:#fff; outline:none;">
                <button class="p-btn" @click="fnLoad">검색</button>
            </div>

            <!-- 테이블 -->
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
                        <tr v-if="campList.length === 0">
                            <td colspan="6" style="color:var(--c-text-muted); padding:40px;">검색 결과가 없습니다.</td>
                        </tr>
                        <tr v-for="item in campList" :key="item.CAMP_ID">
                            <td style="color:var(--c-text-muted); font-size:12px;">{{ item.CAMP_ID }}</td>
                            <td>
                                <img v-if="item.IMG_URL" :src="item.IMG_URL" class="camp-thumb">
                                <div v-else class="camp-thumb no-img">No Image</div>
                            </td>
                            <td style="cursor:pointer; font-weight:600; color:#fff; text-decoration:underline;"
                                @click="fnDetail(item.CAMP_ID)">{{ item.CAMP_NAME }}</td>
                            <td><span class="badge-induty">{{ item.INDUTY || '-' }}</span></td>
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

        <!-- ★ 수정 모달 -->
        <div class="modal-overlay" v-if="isEditOpen" @click.self="isEditOpen = false">
            <div class="modal-content">
                <h3 style="margin-top:0; color:var(--c-accent);">🛠️ 캠핑장 수정</h3>
                <div class="modal-body">
                    <img v-if="editCamp.IMG_URL" :src="editCamp.IMG_URL"
                        style="width:100%; height:160px; object-fit:cover; border-radius:12px; margin-bottom:12px;">
                    <label class="modal-label">이미지 URL</label>
                    <input type="text" class="modal-input" v-model="editCamp.IMG_URL" placeholder="https://...">

                    <label class="modal-label">캠핑장 이름</label>
                    <input type="text" class="modal-input" v-model="editCamp.CAMP_NAME">

                    <label class="modal-label">주소</label>
                    <input type="text" class="modal-input" v-model="editCamp.ADDRESS">

                    <label class="modal-label">구분(업종)</label>
                    <input type="text" class="modal-input" v-model="editCamp.INDUTY" placeholder="일반야영장, 글램핑 등">

                    <label class="modal-label">위도 (LATITUDE)</label>
                    <input type="number" class="modal-input" v-model="editCamp.LATITUDE" step="0.000001">

                    <label class="modal-label">경도 (LONGITUDE)</label>
                    <input type="number" class="modal-input" v-model="editCamp.LONGITUDE" step="0.000001">

                    <label class="modal-label">설명</label>
                    <textarea class="modal-input" v-model="editCamp.DESCRIPTION" rows="3"
                        style="resize:vertical;"></textarea>
                </div>
                <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                    <button class="p-btn-secondary" @click="isEditOpen = false">닫기</button>
                    <button class="p-btn" @click="fnSaveEdit">저장하기</button>
                </div>
            </div>
        </div>

        <!-- ★ 추가 모달 -->
        <div class="modal-overlay" v-if="isAddOpen" @click.self="isAddOpen = false">
            <div class="modal-content">
                <h3 style="margin-top:0; color:var(--c-accent);">➕ 새 캠핑장 등록</h3>
                <div class="modal-body">
                    <img v-if="newCamp.imgUrl" :src="newCamp.imgUrl"
                        style="width:100%; height:160px; object-fit:cover; border-radius:12px; margin-bottom:12px;">
                    <label class="modal-label">이미지 URL</label>
                    <input type="text" class="modal-input" v-model="newCamp.imgUrl" placeholder="https://...">

                    <label class="modal-label">캠핑장 이름 <span style="color:#ff5f5f">*</span></label>
                    <input type="text" class="modal-input" v-model="newCamp.campName" placeholder="캠핑장 이름 입력">

                    <label class="modal-label">주소 <span style="color:#ff5f5f">*</span></label>
                    <input type="text" class="modal-input" v-model="newCamp.address" placeholder="도로명 주소">

                    <label class="modal-label">구분(업종)</label>
                    <select class="modal-input" v-model="newCamp.induty"
                        style="background:#262a3a; color:#fff; cursor:pointer;">
                        <option value="">선택</option>
                        <option value="일반야영장">일반야영장</option>
                        <option value="자동차야영장">자동차야영장</option>
                        <option value="글램핑">글램핑</option>
                        <option value="카라반">카라반</option>
                        <option value="복합">복합</option>
                    </select>

                    <label class="modal-label">위도 (LATITUDE)</label>
                    <input type="number" class="modal-input" v-model="newCamp.latitude"
                        step="0.000001" placeholder="예: 37.566826">

                    <label class="modal-label">경도 (LONGITUDE)</label>
                    <input type="number" class="modal-input" v-model="newCamp.longitude"
                        step="0.000001" placeholder="예: 126.978657">

                    <label class="modal-label">설명</label>
                    <textarea class="modal-input" v-model="newCamp.description" rows="3"
                        style="resize:vertical;" placeholder="캠핑장 간단 설명"></textarea>
                </div>
                <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                    <button class="p-btn-secondary" @click="isAddOpen = false">닫기</button>
                    <button class="p-btn" @click="fnAddCamp">등록하기</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    campList: [],
                    keyword: '',
                    isEditOpen: false,
                    isAddOpen: false,
                    editCamp: {},
                    newCamp: { campName:'', address:'', induty:'', latitude:'', longitude:'', description:'', imgUrl:'' }
                };
            },
            methods: {
                fnLoad() {
                    $.ajax({
                        url: "/admin/camp/list.dox", type: "POST",
                        data: { keyword: this.keyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") this.campList = data.list;
                        }
                    });
                },
                fnDetail(cId) {
                    $.ajax({
                        url: "/admin/camp/detail.dox", type: "POST",
                        data: { campId: cId },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.editCamp = data.info;
                                this.isEditOpen = true;
                            }
                        }
                    });
                },
                fnSaveEdit() {
                    if (!this.editCamp.CAMP_NAME || !this.editCamp.ADDRESS) {
                        alert("캠핑장 이름과 주소는 필수입니다."); return;
                    }
                    if (!confirm("수정사항을 저장할까요?")) return;
                    $.ajax({
                        url: "/admin/camp/edit.dox", type: "POST",
                        data: {
                            campId:      this.editCamp.CAMP_ID,
                            campName:    this.editCamp.CAMP_NAME,
                            campAddress: this.editCamp.ADDRESS,
                            campType:    this.editCamp.INDUTY,
                            campContent: this.editCamp.DESCRIPTION,
                            latitude:    this.editCamp.LATITUDE,
                            longitude:   this.editCamp.LONGITUDE,
                            imgUrl:      this.editCamp.IMG_URL
                        },
                        success: () => {
                            alert("수정 완료!");
                            this.isEditOpen = false;
                            this.fnLoad();
                        }
                    });
                },
                fnDelete(cId) {
                    if (!confirm("이 캠핑장을 삭제하시겠습니까?\n관련 이미지도 함께 삭제됩니다.")) return;
                    $.ajax({
                        url: "/admin/camp/remove.dox", type: "POST",
                        data: { campId: cId },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                alert("삭제되었습니다.");
                                this.fnLoad();
                            } else {
                                alert("삭제 실패: " + (data.message || "오류 발생"));
                            }
                        }
                    });
                },
                openAddModal() {
                    this.newCamp = { campName:'', address:'', induty:'', latitude:'', longitude:'', description:'', imgUrl:'' };
                    this.isAddOpen = true;
                },
                fnAddCamp() {
                    if (!this.newCamp.campName || !this.newCamp.address) {
                        alert("캠핑장 이름과 주소는 필수입니다."); return;
                    }
                    $.ajax({
                        url: "/admin/camp/add.dox", type: "POST",
                        data: this.newCamp,
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                alert("캠핑장이 등록되었습니다!");
                                this.isAddOpen = false;
                                this.fnLoad();
                            } else {
                                alert("등록 실패: " + (data.message || "오류 발생"));
                            }
                        }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>