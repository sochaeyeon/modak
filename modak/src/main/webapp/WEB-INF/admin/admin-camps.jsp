<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:directive.page deferredSyntaxAllowedAsLiteral="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캠핑장 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-camps.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main" v-cloak>
    <div class="cc-container">

        <!-- ── 페이지 헤더 ── -->
        <div class="cc-header">
            <div class="cc-title-wrap">
                <div class="cc-title-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M3 17l4-8 4 4 3-6 4 10H3z"/>
                        <path d="M3 21h18"/>
                    </svg>
                </div>
                <div>
                    <div class="cc-page-title">캠핑장 관리</div>
                    <div class="cc-page-sub">캠핑장 추가, 수정, 삭제가 가능합니다</div>
                </div>
            </div>
            <div class="cc-header-actions">
                <button class="cc-add-btn" @click="openAddModal">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    새 캠핑장 등록
                </button>
                <button class="cc-back-btn" onclick="location.href='/admin/dashboard.do'">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7" rx="1"/>
                        <rect x="14" y="3" width="7" height="7" rx="1"/>
                        <rect x="3" y="14" width="7" height="7" rx="1"/>
                        <rect x="14" y="14" width="7" height="7" rx="1"/>
                    </svg>
                    대시보드
                </button>
            </div>
        </div>

        <!-- ── 검색 ── -->
        <div class="cc-card cc-search-card">
            <div class="cc-search-row">
                <div class="cc-search-box">
                    <svg class="cc-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="text" class="cc-search-input" v-model="keyword"
                        placeholder="캠핑장명 또는 주소 검색" @keyup.enter="fnLoad">
                </div>
                <button class="cc-search-btn" @click="fnLoad">검색</button>
            </div>
        </div>

        <!-- ── 통계 스트립 ── -->
        <div class="cc-stat-strip">
            <div class="cc-stat-item">
                <div class="cc-stat-val">{{ campList.length }}</div>
                <div class="cc-stat-label">전체 캠핑장</div>
            </div>
            <div class="cc-stat-div"></div>
            <div class="cc-stat-item">
                <div class="cc-stat-val cc-cnt-gm">{{ countByType('글램핑') }}</div>
                <div class="cc-stat-label">글램핑</div>
            </div>
            <div class="cc-stat-div"></div>
            <div class="cc-stat-item">
                <div class="cc-stat-val cc-cnt-or">{{ countByType('일반야영장') }}</div>
                <div class="cc-stat-label">일반야영장</div>
            </div>
            <div class="cc-stat-div"></div>
            <div class="cc-stat-item">
                <div class="cc-stat-val cc-cnt-bl">{{ countByType('카라반') }}</div>
                <div class="cc-stat-label">카라반</div>
            </div>
        </div>

        <!-- ── 테이블 ── -->
        <div class="cc-card cc-table-card">
            <div class="cc-card-header">
                <div class="cc-card-title">
                    <div class="cc-title-dot" style="background:#E8732A"></div>
                    캠핑장 목록
                </div>
                <span class="cc-card-sub">{{ campList.length }}개 등록</span>
            </div>
            <div class="cc-table-wrap">
                <table class="cc-table">
                    <thead>
                        <tr>
                            <th style="width:52px">이미지</th>
                            <th style="text-align:left">캠핑장명</th>
                            <th style="width:90px">구분</th>
                            <th style="text-align:left;width:240px">주소</th>
                            <th style="width:120px">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="campList.length === 0">
                            <td colspan="5" class="cc-empty-td">검색 결과가 없습니다</td>
                        </tr>
                        <tr v-for="item in campList" :key="item.CAMP_ID" class="cc-row">
                            <td>
                                <div class="cc-thumb">
                                    <img v-if="item.IMG_URL" :src="item.IMG_URL" :alt="item.CAMP_NAME">
                                    <span v-else class="cc-thumb-ph">⛺</span>
                                </div>
                            </td>
                            <td class="cc-name-cell" @click="fnDetail(item.CAMP_ID)">
                                <div class="cc-camp-name">{{ item.CAMP_NAME }}</div>
                                <div class="cc-camp-id">#{{ item.CAMP_ID }}</div>
                            </td>
                            <td>
                                <span class="cc-induty-badge">{{ item.INDUTY || '-' }}</span>
                            </td>
                            <td class="cc-address">{{ item.ADDRESS }}</td>
                            <td>
                                <div class="cc-action-row">
                                    <button class="cc-btn-edit" @click="fnDetail(item.CAMP_ID)">수정</button>
                                    <button class="cc-btn-del"  @click="fnDelete(item.CAMP_ID)">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div><!-- cc-container -->

    <!-- ── 수정 모달 ── -->
    <transition name="cc-fade">
    <div v-if="isEditOpen" class="cc-overlay" @click.self="isEditOpen=false">
        <div class="cc-modal">
            <div class="cc-modal-header">
                <div class="cc-modal-title">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:17px;height:17px;color:#E8732A">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                    캠핑장 수정
                </div>
                <button class="cc-modal-close" @click="isEditOpen=false">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            </div>
            <div class="cc-modal-body">
                <img v-if="editCamp.IMG_URL" :src="editCamp.IMG_URL" class="cc-modal-thumb">
                <div class="cc-field">
                    <label class="cc-label">이미지 URL</label>
                    <input type="text" class="cc-input" v-model="editCamp.IMG_URL" placeholder="https://...">
                </div>
                <div class="cc-field">
                    <label class="cc-label">캠핑장 이름</label>
                    <input type="text" class="cc-input" v-model="editCamp.CAMP_NAME">
                </div>
                <div class="cc-field">
                    <label class="cc-label">주소</label>
                    <input type="text" class="cc-input" v-model="editCamp.ADDRESS">
                </div>
                <div class="cc-field">
                    <label class="cc-label">구분(업종)</label>
                    <input type="text" class="cc-input" v-model="editCamp.INDUTY" placeholder="일반야영장, 글램핑 등">
                </div>
                <div class="cc-field-row">
                    <div class="cc-field">
                        <label class="cc-label">위도</label>
                        <input type="number" class="cc-input" v-model="editCamp.LATITUDE" step="0.000001">
                    </div>
                    <div class="cc-field">
                        <label class="cc-label">경도</label>
                        <input type="number" class="cc-input" v-model="editCamp.LONGITUDE" step="0.000001">
                    </div>
                </div>
                <div class="cc-field">
                    <label class="cc-label">설명</label>
                    <textarea class="cc-input cc-textarea" v-model="editCamp.DESCRIPTION" rows="3"></textarea>
                </div>
            </div>
            <div class="cc-modal-footer">
                <button class="cc-btn-cancel" @click="isEditOpen=false">닫기</button>
                <button class="cc-btn-primary" @click="fnSaveEdit">저장하기</button>
            </div>
        </div>
    </div>
    </transition>

    <!-- ── 추가 모달 ── -->
    <transition name="cc-fade">
    <div v-if="isAddOpen" class="cc-overlay" @click.self="isAddOpen=false">
        <div class="cc-modal">
            <div class="cc-modal-header">
                <div class="cc-modal-title">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:17px;height:17px;color:#E8732A">
                        <path d="M3 17l4-8 4 4 3-6 4 10H3z"/><path d="M3 21h18"/>
                    </svg>
                    새 캠핑장 등록
                </div>
                <button class="cc-modal-close" @click="isAddOpen=false">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            </div>
            <div class="cc-modal-body">
                <img v-if="newCamp.imgUrl" :src="newCamp.imgUrl" class="cc-modal-thumb">
                <div class="cc-field">
                    <label class="cc-label">이미지 URL</label>
                    <input type="text" class="cc-input" v-model="newCamp.imgUrl" placeholder="https://...">
                </div>
                <div class="cc-field">
                    <label class="cc-label">캠핑장 이름 <span class="cc-req">*</span></label>
                    <input type="text" class="cc-input" v-model="newCamp.campName" placeholder="캠핑장 이름 입력">
                </div>
                <div class="cc-field">
                    <label class="cc-label">주소 <span class="cc-req">*</span></label>
                    <input type="text" class="cc-input" v-model="newCamp.address" placeholder="도로명 주소">
                </div>
                <div class="cc-field">
                    <label class="cc-label">구분(업종)</label>
                    <select class="cc-input cc-select" v-model="newCamp.induty">
                        <option value="">선택</option>
                        <option value="일반야영장">일반야영장</option>
                        <option value="자동차야영장">자동차야영장</option>
                        <option value="글램핑">글램핑</option>
                        <option value="카라반">카라반</option>
                        <option value="복합">복합</option>
                    </select>
                </div>
                <div class="cc-field-row">
                    <div class="cc-field">
                        <label class="cc-label">위도</label>
                        <input type="number" class="cc-input" v-model="newCamp.latitude" step="0.000001" placeholder="37.566826">
                    </div>
                    <div class="cc-field">
                        <label class="cc-label">경도</label>
                        <input type="number" class="cc-input" v-model="newCamp.longitude" step="0.000001" placeholder="126.978657">
                    </div>
                </div>
                <div class="cc-field">
                    <label class="cc-label">설명</label>
                    <textarea class="cc-input cc-textarea" v-model="newCamp.description" rows="3" placeholder="캠핑장 간단 설명"></textarea>
                </div>
            </div>
            <div class="cc-modal-footer">
                <button class="cc-btn-cancel" @click="isAddOpen=false">닫기</button>
                <button class="cc-btn-primary" @click="fnAddCamp">등록하기</button>
            </div>
        </div>
    </div>
    </transition>

    <!-- ── 확인 모달 ── -->
    <transition name="cc-fade">
    <div v-if="showConfirm" class="cc-overlay" @click.self="showConfirm=false">
        <div class="cc-confirm-box">
            <div class="cc-confirm-icon">{{ confirmConfig.icon }}</div>
            <div class="cc-confirm-title">{{ confirmConfig.title }}</div>
            <div class="cc-confirm-msg" v-html="confirmConfig.msg"></div>
            <div class="cc-confirm-btns">
                <button class="cc-btn-cancel" @click="showConfirm=false">취소</button>
                <button class="cc-btn-primary" :class="confirmConfig.danger?'cc-btn-danger':''" @click="fnRunConfirm">
                    {{ confirmConfig.confirmText }}
                </button>
            </div>
        </div>
    </div>
    </transition>

    <!-- ── 토스트 ── -->
    <div class="cc-toast-wrap">
        <transition-group name="cc-toast">
            <div v-for="t in toasts" :key="t.id" class="cc-toast" :class="t.type">{{ t.msg }}</div>
        </transition-group>
    </div>

    </div><!-- #app -->

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
                    confirmConfig: { title:'', msg:'', icon:'❓', confirmText:'확인', danger:false, onConfirm:null },
                    toasts: []
                };
            },
            methods: {
                toast(msg, type) {
                    const id = Date.now() + Math.random();
                    this.toasts.push({ id, msg, type: type || 'success' });
                    setTimeout(() => { this.toasts = this.toasts.filter(t => t.id !== id); }, 2800);
                },
                fnShowConfirm(config) {
                    this.confirmConfig = Object.assign({ icon:'❓', confirmText:'확인', danger:false, onConfirm:null }, config);
                    this.showConfirm = true;
                },
                fnRunConfirm() {
                    this.showConfirm = false;
                    if (typeof this.confirmConfig.onConfirm === 'function') this.confirmConfig.onConfirm();
                },
                countByType(type) {
                    return this.campList.filter(c => (c.INDUTY || '').includes(type)).length;
                },
                fnLoad() {
                    $.ajax({
                        url: '/admin/camp/list.dox', type: 'POST',
                        data: { keyword: this.keyword },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') this.campList = data.list;
                        }
                    });
                },
                fnDetail(cId) {
                    $.ajax({
                        url: '/admin/camp/detail.dox', type: 'POST',
                        data: { campId: cId },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') { this.editCamp = data.info; this.isEditOpen = true; }
                        }
                    });
                },
                fnSaveEdit() {
                    if (!this.editCamp.CAMP_NAME || !this.editCamp.ADDRESS) {
                        this.toast('캠핑장 이름과 주소는 필수입니다', 'error'); return;
                    }
                    this.fnShowConfirm({
                        title: '수정 저장',
                        msg: '<b style="color:#fff">' + this.editCamp.CAMP_NAME + '</b><br>수정사항을 저장할까요?',
                        icon: '✏️', confirmText: '저장하기',
                        onConfirm: () => {
                            $.ajax({
                                url: '/admin/camp/edit.dox', type: 'POST',
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
                                success: () => { this.toast('수정이 완료되었습니다', 'success'); this.isEditOpen = false; this.fnLoad(); },
                                error:   () => { this.toast('서버 오류가 발생했습니다', 'error'); }
                            });
                        }
                    });
                },
                fnDelete(cId) {
                    this.fnShowConfirm({
                        title: '캠핑장 삭제',
                        msg: '이 캠핑장을 삭제하시겠습니까?<br><span style="font-size:12px;color:#ff8080">관련 이미지도 함께 삭제됩니다.</span>',
                        icon: '🗑️', confirmText: '삭제하기', danger: true,
                        onConfirm: () => {
                            $.ajax({
                                url: '/admin/camp/remove.dox', type: 'POST',
                                data: { campId: cId },
                                success: (res) => {
                                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                                    if (data.result === 'success') { this.toast('삭제되었습니다', 'success'); this.fnLoad(); }
                                    else this.toast('삭제 실패: ' + (data.message || '오류 발생'), 'error');
                                },
                                error: () => { this.toast('서버 오류가 발생했습니다', 'error'); }
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
                        this.toast('캠핑장 이름과 주소는 필수입니다', 'error'); return;
                    }
                    $.ajax({
                        url: '/admin/camp/add.dox', type: 'POST',
                        data: this.newCamp,
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                this.toast('캠핑장이 등록되었습니다!', 'success');
                                this.isAddOpen = false; this.fnLoad();
                            } else { this.toast('등록 실패: ' + (data.message || '오류 발생'), 'error'); }
                        },
                        error: () => { this.toast('서버 오류가 발생했습니다', 'error'); }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
