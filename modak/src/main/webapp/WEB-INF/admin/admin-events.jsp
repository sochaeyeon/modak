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

            <!-- 헤더 -->
            <div class="event-header">
                <div class="event-title-wrap">
                    <div class="event-title-icon"><i class="ev-icon-gift">🎁</i></div>
                    <div>
                        <div class="event-title">프로모션 &amp; 이벤트 관리</div>
                        <div class="event-subtitle">등록된 이벤트 {{ eventList.length }}건</div>
                    </div>
                </div>
                <div class="header-buttons">
                    <button class="p-btn-secondary" onclick="location.href='/admin/dashboard.do'">
                        <span>🏠</span> 대시보드
                    </button>
                    <button class="p-btn" @click="fnOpenAdd">
                        <span>+</span> 새 이벤트 등록
                    </button>
                </div>
            </div>

            <!-- 필터 바 -->
            <div class="ev-filter-bar">
                <button v-for="st in ['ALL', 'READY', 'ING', 'END']" :key="st"
                        class="filter-btn" :class="{active: filterStatus === st}"
                        @click="fnChangeFilter(st)">
                    <span class="filter-dot" :class="'dot-' + st.toLowerCase()"></span>
                    {{ st === 'ALL' ? '전체' : st === 'READY' ? '대기 중' : st === 'ING' ? '진행 중' : '종료됨' }}
                    <span class="filter-count">{{ fnCountStatus(st) }}</span>
                </button>
            </div>

            <!-- 이벤트 카드 그리드 -->
            <div class="event-card-wrap" v-if="pagedList.length > 0">
                <div class="event-item" v-for="item in pagedList" :key="item.EVENT_ID">
                    <div class="event-img-box">
                        <img :src="fnGetImgPath(item.THUMBNAIL)" @error="imgError">
                        <div class="img-overlay"></div>
                    </div>
                    <div class="event-info">
                        <span class="ev-badge" :class="'ev-' + (item.STATUS_CODE ? item.STATUS_CODE.toLowerCase() : 'ready')">
                            <span class="badge-dot"></span>
                            {{ item.STATUS_CODE === 'READY' ? '대기 중' : item.STATUS_CODE === 'ING' ? '진행 중' : '종료됨' }}
                        </span>
                        <div class="event-name">{{ item.TITLE }}</div>
                        <div class="event-date">
                            <span class="date-icon">📅</span>
                            {{ item.START_DATE }} ~ {{ item.END_DATE }}
                        </div>
                        <div class="ev-btn-group">
                            <button class="ev-action-btn ev-edit-btn" @click="fnOpenEdit(item)">
                                <span>✏️</span> 수정
                            </button>
                            <button class="ev-action-btn ev-delete-btn" @click="fnDelete(item.EVENT_ID)">
                                <span>🗑️</span> 삭제
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 빈 상태 -->
            <div class="ev-empty" v-if="filteredList.length === 0">
                <div class="ev-empty-icon">📭</div>
                <div class="ev-empty-title">등록된 이벤트가 없습니다</div>
                <div class="ev-empty-sub">새 이벤트를 등록해 프로모션을 시작해보세요</div>
                <button class="p-btn" style="margin-top:20px" @click="fnOpenAdd">+ 이벤트 등록하기</button>
            </div>

            <!-- 페이지네이션 -->
            <div class="ev-pagination" v-if="totalPages > 1">
                <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">
                    <span>&#8249;</span>
                </button>
                <button v-for="p in totalPages" :key="p" class="page-btn"
                        :class="{active: currentPage === p}" @click="currentPage = p">{{ p }}</button>
                <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">
                    <span>&#8250;</span>
                </button>
            </div>
        </div>

        <!-- ── 등록/수정 모달 ── -->
        <div class="ev-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="ev-modal" :class="{open: modalOpen}">
                <div class="modal-header">
                    <div class="modal-header-icon">{{ isEdit ? '✏️' : '🆕' }}</div>
                    <div class="modal-header-text">{{ isEdit ? '이벤트 정보 수정' : '신규 이벤트 등록' }}</div>
                </div>

                <div class="form-group">
                    <label class="modal-label">제목 <span class="label-req">*</span></label>
                    <input class="ev-input" v-model="form.title" placeholder="이벤트 제목을 입력하세요">
                </div>

                <div class="form-group">
                    <label class="modal-label">내용</label>
                    <textarea class="ev-input ev-textarea" v-model="form.content" placeholder="이벤트 내용을 입력하세요"></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="modal-label">시작일</label>
                        <input type="date" class="ev-input" v-model="form.startDate">
                    </div>
                    <div class="form-group">
                        <label class="modal-label">종료일</label>
                        <input type="date" class="ev-input" v-model="form.endDate">
                    </div>
                </div>

                <div class="form-group">
                    <label class="modal-label">이미지 파일명</label>
                    <div class="img-preview-row">
                        <div class="modal-img-preview">
                            <img :src="fnGetImgPath(form.img_path)" @error="imgError">
                        </div>
                        <input class="ev-input" v-model="form.img_path" placeholder="예: banner.png">
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="modal-close-btn" @click="modalOpen=false">취소</button>
                    <button class="p-btn" @click="fnSave" :disabled="isSubmitting">
                        <span v-if="isSubmitting" class="spinner"></span>
                        {{ isSubmitting ? '저장 중...' : '저장하기' }}
                    </button>
                </div>
            </div>
        </div>

        <!-- ── 확인 모달 (confirm 대체) ── -->
        <div class="ev-confirm-overlay" :class="{open: confirmState.open}" @click.self="fnConfirmCancel">
            <div class="ev-confirm-box" :class="{open: confirmState.open}">
                <div class="confirm-icon">🗑️</div>
                <div class="confirm-title">삭제 확인</div>
                <div class="confirm-msg">{{ confirmState.message }}</div>
                <div class="confirm-btns">
                    <button class="modal-close-btn" @click="fnConfirmCancel">취소</button>
                    <button class="p-btn-danger" @click="fnConfirmOk">삭제하기</button>
                </div>
            </div>
        </div>

        <!-- ── 토스트 알림 ── -->
        <div class="toast-container">
            <transition-group name="toast-slide">
                <div v-for="t in toasts" :key="t.id" class="toast-item" :class="'toast-' + t.type">
                    <div class="toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
                    <div class="toast-msg">{{ t.message }}</div>
                    <button class="toast-close" @click="removeToast(t.id)">✕</button>
                    <div class="toast-progress" :style="{animationDuration: t.duration + 'ms'}"></div>
                </div>
            </transition-group>
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
                    pageSize: 8,
                    modalOpen: false,
                    isEdit: false,
                    isSubmitting: false,
                    form: { eventId: '', title: '', content: '', startDate: '', endDate: '', img_path: '' },
                    toasts: [],
                    confirmState: { open: false, message: '', resolve: null }
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
                totalPages() { return Math.ceil(this.filteredList.length / this.pageSize) || 1; }
            },
            methods: {
                /* ── 토스트 ── */
                showToast(message, type = 'info', duration = 3000) {
                    const id = Date.now() + Math.random();
                    this.toasts.push({ id, message, type, duration });
                    setTimeout(() => this.removeToast(id), duration);
                },
                removeToast(id) {
                    this.toasts = this.toasts.filter(t => t.id !== id);
                },

                /* ── 확인 모달 ── */
                showConfirm(message) {
                    return new Promise(resolve => {
                        this.confirmState = { open: true, message, resolve };
                    });
                },
                fnConfirmOk() {
                    if (this.confirmState.resolve) this.confirmState.resolve(true);
                    this.confirmState = { open: false, message: '', resolve: null };
                },
                fnConfirmCancel() {
                    if (this.confirmState.resolve) this.confirmState.resolve(false);
                    this.confirmState = { open: false, message: '', resolve: null };
                },

                /* ── 데이터 ── */
                fnLoad() {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/event/list.dox",
                        type: "POST",
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === "success") this.eventList = data.list || [];
                        },
                        error: () => {
                            this.showToast("이벤트 목록을 불러오지 못했습니다.", "error");
                        }
                    });
                },
                fnCountStatus(st) {
                    if (st === 'ALL') return this.eventList.length;
                    return this.eventList.filter(i => i.STATUS_CODE === st).length;
                },
                fnGetImgPath(path) {
                    if (!path) return '${pageContext.request.contextPath}/img/no-image.png';
                    if (path.startsWith('/') || path.startsWith('http'))
                        return path.startsWith('/') ? '${pageContext.request.contextPath}' + path : path;
                    return '${pageContext.request.contextPath}/img/event/' + path;
                },

                /* ── 저장 ── */
                fnSave() {
                    if (!this.form.title.trim()) {
                        this.showToast("제목을 입력해주세요.", "error");
                        return;
                    }
                    if (this.isSubmitting) return;
                    this.isSubmitting = true;

                    const saveData = {
                        eventId: this.form.eventId,
                        title: this.form.title,
                        content: this.form.content,
                        start_date: this.form.startDate,
                        end_date: this.form.endDate,
                        img_path: this.form.img_path.includes('/')
                            ? this.form.img_path
                            : '/img/event/' + this.form.img_path
                    };

                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/event/save.dox",
                        type: "POST",
                        data: saveData,
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.showToast(this.isEdit ? "이벤트가 수정되었습니다." : "새 이벤트가 등록되었습니다.", "success");
                                this.modalOpen = false;
                                this.fnLoad();
                            } else {
                                this.showToast("저장 실패: " + (data.message || "서버 오류"), "error");
                            }
                        },
                        error: (xhr) => {
                            this.showToast("통신 오류가 발생했습니다. (" + xhr.status + ")", "error");
                            console.error(xhr.responseText);
                        },
                        complete: () => { this.isSubmitting = false; }
                    });
                },

                /* ── 삭제 ── */
                async fnDelete(id) {
                    const ok = await this.showConfirm("이 이벤트를 정말 삭제하시겠습니까?\n삭제된 이벤트는 복구할 수 없습니다.");
                    if (!ok) return;

                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/event/delete.dox",
                        type: "POST",
                        data: { eventId: id },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.showToast("이벤트가 삭제되었습니다.", "success");
                                this.fnLoad();
                            } else {
                                this.showToast("삭제 실패: " + (data.message || "서버 오류"), "error");
                            }
                        },
                        error: () => {
                            this.showToast("삭제 중 오류가 발생했습니다.", "error");
                        }
                    });
                },

                /* ── 모달 열기 ── */
                fnOpenAdd() {
                    this.isEdit = false;
                    this.form = { eventId: '', title: '', content: '', startDate: '', endDate: '', img_path: '' };
                    this.modalOpen = true;
                },
                fnOpenEdit(item) {
                    this.isEdit = true;
                    let fileName = item.THUMBNAIL || '';
                    if (fileName.includes('/')) {
                        const parts = fileName.split('/');
                        fileName = parts[parts.length - 1];
                    }
                    this.form = {
                        eventId: item.EVENT_ID,
                        title: item.TITLE,
                        content: item.CONTENT,
                        startDate: item.START_DATE,
                        endDate: item.END_DATE,
                        img_path: fileName
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
