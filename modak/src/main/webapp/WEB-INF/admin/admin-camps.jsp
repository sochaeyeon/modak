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
    <style>[v-cloak]{display:none}</style>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main" v-cloak>
        <div class="camp-page-container">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:32px;">
                <div>
                    <h2 style="color:#fff; margin:0;">⛺ 캠핑장 관리</h2>
                    <p style="color:var(--c-text-muted); font-size:14px; margin-top:6px;">캠핑장 추가, 수정, 삭제가 가능합니다.</p>
                </div>
                <button class="p-btn" @click="openAddModal">+ 새 캠핑장 등록</button>
            </div>

            <!-- 검색 -->
            <div class="search-bar">
                <input type="text" class="m-input" v-model="keyword" placeholder="캠핑장명 또는 주소 검색" @keyup.enter="fnLoad">
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
                        <tr v-for="item in campList" :key="item.CAMP_ID" class="c-table-row">
                            <td style="color:var(--c-text-muted); font-size:12px;">{{ item.CAMP_ID }}</td>
                            <td>
                                <img v-if="item.IMG_URL" :src="item.IMG_URL" class="camp-thumb">
                                <div v-else class="camp-thumb no-img">No Image</div>
                            </td>
                            <td class="camp-name-cell" @click="fnDetail(item.CAMP_ID)">{{ item.CAMP_NAME }}</td>
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

        <!-- ★ 확인 모달 -->
        <transition name="camp-modal-fade">
            <div v-if="showConfirm" class="camp-confirm-overlay" @click.self="showConfirm=false">
                <div class="camp-confirm-box">
                    <div class="camp-confirm-icon">{{ confirmConfig.icon }}</div>
                    <div class="camp-confirm-title">{{ confirmConfig.title }}</div>
                    <div class="camp-confirm-msg" v-html="confirmConfig.msg"></div>
                    <div class="camp-confirm-btns">
                        <button class="p-btn-secondary" @click="showConfirm=false">취소</button>
                        <button class="p-btn" :class="confirmConfig.danger ? 'p-btn-danger' : ''" @click="fnRunConfirm">
                            {{ confirmConfig.confirmText }}
                        </button>
                    </div>
                </div>
            </div>
        </transition>
    </div>

    <!-- 토스트 -->
    <div class="camp-toast" id="campToast"></div>

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
                    newCamp: { campName:'', address:'', induty:'', latitude:'', longitude:'', description:'', imgUrl:'' },
                    showConfirm: false,
                    confirmConfig: { title:'', msg:'', icon:'❓', confirmText:'확인', danger: false, onConfirm: null }
                };
            },
            methods: {
                toast(msg, type) {
                    const t = document.getElementById('campToast');
                    t.textContent = msg;
                    t.className = 'camp-toast ' + (type || '') + ' show';
                    setTimeout(() => t.classList.remove('show'), 2600);
                },

                fnShowConfirm(config) {
                    this.confirmConfig = Object.assign(
                        { icon:'❓', confirmText:'확인', danger: false, onConfirm: null },
                        config
                    );
                    this.showConfirm = true;
                },

                fnRunConfirm() {
                    this.showConfirm = false;
                    if (typeof this.confirmConfig.onConfirm === 'function') {
                        this.confirmConfig.onConfirm();
                    }
                },

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
                        this.toast('⚠️ 캠핑장 이름과 주소는 필수입니다', 'error');
                        return;
                    }
                    this.fnShowConfirm({
                        title: '수정 저장',
                        msg: '<b style="color:#fff">' + this.editCamp.CAMP_NAME + '</b><br>수정사항을 저장할까요?',
                        icon: '🛠️',
                        confirmText: '저장하기',
                        onConfirm: () => {
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
                                    this.toast('✅ 수정이 완료되었습니다', 'success');
                                    this.isEditOpen = false;
                                    this.fnLoad();
                                },
                                error: () => {
                                    this.toast('⚠️ 서버 오류가 발생했습니다', 'error');
                                }
                            });
                        }
                    });
                },

                fnDelete(cId) {
                    this.fnShowConfirm({
                        title: '캠핑장 삭제',
                        msg: '이 캠핑장을 삭제하시겠습니까?<br><span style="font-size:12px;color:#ff8080">관련 이미지도 함께 삭제됩니다.</span>',
                        icon: '🗑️',
                        confirmText: '삭제하기',
                        danger: true,
                        onConfirm: () => {
                            $.ajax({
                                url: "/admin/camp/remove.dox", type: "POST",
                                data: { campId: cId },
                                success: (res) => {
                                    const data = typeof res === "string" ? JSON.parse(res) : res;
                                    if (data.result === "success") {
                                        this.toast('🗑️ 삭제되었습니다', 'success');
                                        this.fnLoad();
                                    } else {
                                        this.toast('⚠️ 삭제 실패: ' + (data.message || '오류 발생'), 'error');
                                    }
                                },
                                error: () => {
                                    this.toast('⚠️ 서버 오류가 발생했습니다', 'error');
                                }
                            });
                        }
                    });
                },

                openAddModal() {
                    this.newCamp = { campName:'', address:'', induty:'', latitude:'', longitude:'', description:'', imgUrl:'' };
                    this.isAddOpen = true;
                },

                fnAddCamp() {
                    if (!this.newCamp.campName || !this.newCamp.address) {
                        this.toast('⚠️ 캠핑장 이름과 주소는 필수입니다', 'error');
                        return;
                    }
                    $.ajax({
                        url: "/admin/camp/add.dox", type: "POST",
                        data: this.newCamp,
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.toast('✅ 캠핑장이 등록되었습니다!', 'success');
                                this.isAddOpen = false;
                                this.fnLoad();
                            } else {
                                this.toast('⚠️ 등록 실패: ' + (data.message || '오류 발생'), 'error');
                            }
                        },
                        error: () => {
                            this.toast('⚠️ 서버 오류가 발생했습니다', 'error');
                        }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
