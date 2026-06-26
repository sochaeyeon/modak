<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>등급 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-membership.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="mship-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="mship-header">
        <div class="mship-title-wrap">
            <div class="mship-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                </svg>
            </div>
            <div>
                <div class="mship-page-title">등급 관리</div>
                <div class="mship-page-subtitle">회원 등급 혜택 및 조건을 설정합니다</div>
            </div>
        </div>
        <button class="mship-dashboard-btn" onclick="location.href='/admin/dashboard.do'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── 등급 플로우 바 ── -->
    <div class="mship-flow-card">
        <div class="mflow-label">등급 승급 경로</div>
        <div class="mflow-track">
            <div v-for="(g, i) in grades" :key="g.gradeId" class="mflow-item">
                <div class="mflow-icon" :style="{background: g.color + '22', borderColor: g.color + '55'}">
                    <span>{{ g.icon }}</span>
                </div>
                <div class="mflow-name" :style="{color: g.color}">{{ g.gradeName }}</div>
                <div class="mflow-cond">{{ g.minAmount > 0 ? fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}</div>
                <div class="mflow-discount" v-if="g.discountRate > 0">{{ g.discountRate }}% 할인</div>
                <div class="mflow-arrow" v-if="i < grades.length - 1">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                </div>
            </div>
        </div>
    </div>

    <!-- ── 등급 카드 그리드 ── -->
    <div class="mship-grade-grid">
        <div v-for="g in grades" :key="g.gradeId"
             class="mship-grade-card"
             :class="{ 'grade-selected': selectedGrade && selectedGrade.gradeId === g.gradeId }"
             :style="{'--gc': g.color}"
             @click="fnSelectGrade(g)">
            <div class="gc-glow"></div>
            <div class="gc-top">
                <span class="gc-icon">{{ g.icon }}</span>
                <span class="gc-edit-hint">클릭하여 수정</span>
            </div>
            <div class="gc-name">{{ g.gradeName }}</div>
            <div class="gc-count">
                <span class="gc-count-num" :style="{color: g.color}">{{ (g.memberCount || 0).toLocaleString() }}</span>
                <span class="gc-count-unit">명</span>
            </div>
            <div class="gc-divider"></div>
            <div class="gc-meta">
                <div class="gc-meta-row">
                    <span class="gc-meta-icon">💰</span>
                    {{ g.minAmount > 0 ? fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}
                </div>
                <div class="gc-meta-row" v-if="g.discountRate > 0">
                    <span class="gc-meta-icon">🏷️</span>
                    {{ g.discountRate }}% 할인
                </div>
            </div>
            <div class="gc-benefits" v-if="g.benefitText">
                <span v-for="b in g.benefitText.split(',')" :key="b" class="gc-benefit-tag">{{ b.trim() }}</span>
            </div>
            <div class="gc-selected-bar" v-if="selectedGrade && selectedGrade.gradeId === g.gradeId"></div>
        </div>
    </div>

    <!-- ── 등급 수정 패널 ── -->
    <transition name="edit-slide">
        <div class="mship-edit-panel" v-if="selectedGrade" :style="{'--ep-color': selectedGrade.color}">
            <div class="ep-header">
                <div class="ep-title-wrap">
                    <span class="ep-icon">{{ selectedGrade.icon }}</span>
                    <span class="ep-title" :style="{color: selectedGrade.color}">{{ selectedGrade.gradeName }}</span>
                    <span class="ep-title-suffix">등급 설정</span>
                </div>
                <button class="ep-close-btn" @click="selectedGrade = null">✕</button>
            </div>
            <div class="ep-body">
                <div class="ep-field">
                    <label class="ep-label">등급명</label>
                    <input class="ep-input" v-model="editForm.gradeName" placeholder="예: 브론즈">
                </div>
                <div class="ep-field">
                    <label class="ep-label">최소 누적 금액 (원)</label>
                    <input class="ep-input" v-model.number="editForm.minAmount" type="number" min="0" step="10000">
                </div>
                <div class="ep-field">
                    <label class="ep-label">할인율 (%)</label>
                    <input class="ep-input" v-model.number="editForm.discountRate" type="number" min="0" max="50">
                </div>
                <div class="ep-field ep-full">
                    <label class="ep-label">등급 설명</label>
                    <input class="ep-input" v-model="editForm.description" placeholder="등급에 대한 간단한 설명">
                </div>
                <div class="ep-field ep-full">
                    <label class="ep-label">혜택 <span class="ep-hint">쉼표로 구분</span></label>
                    <input class="ep-input" v-model="editForm.benefitText" placeholder="포인트 1% 적립, 생일 쿠폰 1장 등">
                </div>
            </div>
            <div class="ep-footer">
                <button class="ep-cancel-btn" @click="selectedGrade = null">취소</button>
                <button class="ep-save-btn" @click="fnSaveGrade" :disabled="isSaving">
                    <span v-if="isSaving" class="ep-spinner"></span>
                    {{ isSaving ? '저장 중...' : '💾 설정 저장' }}
                </button>
            </div>
        </div>
    </transition>

    <!-- ── 회원 목록 ── -->
    <div class="mship-table-card">
        <div class="mtable-header">
            <div class="mtable-title-wrap">
                <span class="mtable-dot" :style="selectedGrade ? {background: selectedGrade.color, boxShadow: '0 0 8px ' + selectedGrade.color} : {}"></span>
                <span class="mtable-title">
                    {{ selectedGrade ? selectedGrade.gradeName + ' 등급 회원' : '전체 회원 목록' }}
                </span>
                <span class="mtable-count">{{ totalCount.toLocaleString() }}명</span>
            </div>
            <div class="mtable-controls">
                <div class="mship-tabs">
                    <button class="mship-tab" :class="{active: filterGrade===''}" @click="fnFilterGrade('')">전체</button>
                    <button v-for="g in grades" :key="g.gradeId"
                            class="mship-tab"
                            :class="{active: filterGrade===g.gradeId}"
                            :style="filterGrade===g.gradeId ? {borderColor: g.color, color: g.color, background: g.color + '18'} : {}"
                            @click="fnFilterGrade(g.gradeId)">
                        {{ g.icon }} {{ g.gradeName }}
                    </button>
                </div>
                <div class="mship-search-wrap">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input class="mship-search-input" v-model="keyword" placeholder="아이디·이름 검색" @keyup.enter="fnSearch">
                </div>
                <button class="mship-search-btn" @click="fnSearch">검색</button>
            </div>
        </div>

        <table class="mship-table">
            <thead>
                <tr>
                    <th style="width:5%"></th>
                    <th class="t-left" style="width:12%">아이디</th>
                    <th class="t-left" style="width:10%">이름</th>
                    <th style="width:12%">현재 등급</th>
                    <th style="width:12%">누적 금액</th>
                    <th style="width:10%">포인트</th>
                    <th style="width:9%">상태</th>
                    <th style="width:13%">가입일</th>
                    <th style="width:17%">등급 변경</th>
                </tr>
            </thead>
            <tbody>
                <tr class="mship-row" v-for="u in memberList" :key="u.userId">
                    <td>
                        <div class="mship-avatar" :style="{background: fnGradeColor(u.gradeId) + '22', color: fnGradeColor(u.gradeId)}">
                            {{ (u.userId || '?').charAt(0).toUpperCase() }}
                        </div>
                    </td>
                    <td class="t-left"><span class="mship-userid">{{ u.userId }}</span></td>
                    <td class="t-left"><span class="mship-username">{{ u.userName || '—' }}</span></td>
                    <td>
                        <span class="mship-grade-badge"
                              :style="{background: fnGradeColor(u.gradeId) + '22', color: fnGradeColor(u.gradeId), borderColor: fnGradeColor(u.gradeId) + '44'}">
                            {{ fnGradeIcon(u.gradeId) }} {{ fnGradeName(u.gradeId) }}
                        </span>
                    </td>
                    <td class="mship-amount">{{ fnPrice(u.totalAmount) }}</td>
                    <td class="mship-point">{{ (u.point || 0).toLocaleString() }}P</td>
                    <td>
                        <span class="mship-status-badge"
                              :class="u.userStatus === 'ACTIVE' ? 'msbadge-ok' : 'msbadge-del'">
                            <span class="msb-dot"></span>
                            {{ u.userStatus === 'ACTIVE' ? '정상' : '정지' }}
                        </span>
                    </td>
                    <td class="mship-date">{{ u.createdAt || '—' }}</td>
                    <td>
                        <select class="mship-grade-select"
                                :value="u.gradeId"
                                @change="fnChangeGrade(u, $event.target.value)">
                            <option v-for="g in grades" :key="g.gradeId" :value="g.gradeId">
                                {{ g.icon }} {{ g.gradeName }}
                            </option>
                        </select>
                    </td>
                </tr>
                <tr v-if="!memberList.length">
                    <td colspan="9" class="mship-empty">
                        <div class="mship-empty-icon">📭</div>
                        <div class="mship-empty-txt">조회된 회원이 없습니다</div>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="mship-pagination" v-if="totalPages > 1">
            <button class="mpg-btn" :disabled="page <= 1" @click="fnPage(page - 1)">&#8249;</button>
            <button v-for="p in totalPages" :key="p" class="mpg-btn"
                    :class="{active: page === p}" @click="fnPage(p)">{{ p }}</button>
            <button class="mpg-btn" :disabled="page >= totalPages" @click="fnPage(page + 1)">&#8250;</button>
        </div>
    </div>

</div>

<!-- ── 확인 모달 ── -->
<div class="mship-confirm-overlay" :class="{open: confirmState.open}" @click.self="fnConfirmCancel">
    <div class="mship-confirm-box" :class="{open: confirmState.open}">
        <div class="mship-confirm-ico">🔄</div>
        <div class="mship-confirm-title">등급 변경</div>
        <div class="mship-confirm-msg" v-html="confirmState.message"></div>
        <div class="mship-confirm-btns">
            <button class="mship-cancel-btn" @click="fnConfirmCancel">취소</button>
            <button class="mship-ok-btn" @click="fnConfirmOk">변경하기</button>
        </div>
    </div>
</div>

<!-- ── 토스트 ── -->
<div class="mship-toast-container">
    <transition-group name="mship-toast-slide">
        <div v-for="t in toasts" :key="t.id" class="mship-toast-item" :class="'mship-toast-' + t.type">
            <div class="mship-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
            <div class="mship-toast-msg">{{ t.message }}</div>
            <button class="mship-toast-close" @click="removeToast(t.id)">✕</button>
            <div class="mship-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
        </div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
Vue.createApp({
    data() {
        return {
            grades: [
                { gradeId: 1, gradeName: '브론즈', icon: '🥉', color: '#C48250', minAmount: 0,      discountRate: 0,  memberCount: 0, benefitText: '', description: '' },
                { gradeId: 2, gradeName: '실버',   icon: '🥈', color: '#9DA8B5', minAmount: 30000,  discountRate: 5,  memberCount: 0, benefitText: '', description: '' },
                { gradeId: 3, gradeName: '골드',   icon: '🥇', color: '#D4932A', minAmount: 100000, discountRate: 10, memberCount: 0, benefitText: '', description: '' },
                { gradeId: 4, gradeName: 'VVIP',   icon: '👑', color: '#E8732A', minAmount: 300000, discountRate: 15, memberCount: 0, benefitText: '', description: '' }
            ],
            selectedGrade: null,
            editForm: {},
            isSaving: false,
            memberList: [],
            keyword: '',
            filterGrade: '',
            page: 1,
            pageSize: 12,
            totalCount: 0,
            toasts: [],
            confirmState: { open: false, message: '', resolve: null }
        };
    },
    computed: {
        totalPages() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        /* ── 토스트 ── */
        showToast(message, type = 'success', duration = 3000) {
            const id = Date.now() + Math.random();
            this.toasts.push({ id, message, type, duration });
            setTimeout(() => this.removeToast(id), duration);
        },
        removeToast(id) {
            this.toasts = this.toasts.filter(t => t.id !== id);
        },

        /* ── 확인 모달 (Promise) ── */
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

        /* ── 데이터 로드 ── */
        fnLoad() {
            $.ajax({
                url: '/admin/grade/list.dox', type: 'POST', dataType: 'json',
                success: (res) => {
                    if (res.result === 'success') {
                        (res.grades || []).forEach(dbG => {
                            const local = this.grades.find(g => g.gradeId === dbG.gradeId);
                            if (local) Object.assign(local, dbG);
                        });
                    }
                },
                error: () => { this.showToast('등급 정보를 불러오지 못했습니다.', 'error'); }
            });
            this.fnLoadMembers();
        },
        fnLoadMembers() {
            $.ajax({
                url: '/admin/member/list.dox', type: 'POST', dataType: 'json',
                data: { keyword: this.keyword, gradeId: this.filterGrade, page: this.page, pageSize: this.pageSize },
                success: (res) => {
                    if (res.result === 'success') {
                        this.memberList = res.list || [];
                        this.totalCount = res.totalCount || 0;
                    }
                },
                error: () => { this.showToast('회원 목록을 불러오지 못했습니다.', 'error'); }
            });
        },

        /* ── 등급 카드 선택 ── */
        fnSelectGrade(g) {
            if (this.selectedGrade && this.selectedGrade.gradeId === g.gradeId) {
                this.selectedGrade = null;
                this.filterGrade = '';
            } else {
                this.selectedGrade = g;
                this.editForm = { ...g };
                this.filterGrade = g.gradeId;
            }
            this.page = 1;
            this.fnLoadMembers();
        },

        /* ── 등급 저장 ── */
        fnSaveGrade() {
            if (!this.editForm.gradeName) { this.showToast('등급명을 입력하세요.', 'error'); return; }
            this.isSaving = true;
            $.ajax({
                url: '/admin/grade/save.dox', type: 'POST', dataType: 'json',
                data: this.editForm,
                success: (res) => {
                    this.isSaving = false;
                    if (res.result === 'success') {
                        const local = this.grades.find(g => g.gradeId === this.editForm.gradeId);
                        if (local) Object.assign(local, this.editForm);
                        this.showToast('등급 설정이 저장되었습니다.', 'success');
                        this.selectedGrade = null;
                    } else {
                        this.showToast('저장 실패: ' + (res.message || '서버 오류'), 'error');
                    }
                },
                error: () => { this.isSaving = false; this.showToast('저장 중 오류가 발생했습니다.', 'error'); }
            });
        },

        /* ── 등급 변경 ── */
        async fnChangeGrade(user, newGradeId) {
            const newGrade = this.grades.find(g => g.gradeId === parseInt(newGradeId));
            const msg = '<b>' + (user.userName || user.userId) + '</b>님의 등급을<br>'
                      + '<b style="color:' + (newGrade ? newGrade.color : '#fff') + '">'
                      + (newGrade ? newGrade.icon + ' ' + newGrade.gradeName : '') + '</b>(으)로 변경하시겠습니까?';

            const ok = await this.showConfirm(msg);
            if (!ok) { this.fnLoadMembers(); return; }

            $.ajax({
                url: '/admin/member/grade.dox', type: 'POST', dataType: 'json',
                data: { userId: user.userId, gradeId: newGradeId },
                success: (res) => {
                    if (res.result === 'success') {
                        user.gradeId = parseInt(newGradeId);
                        this.showToast('등급이 변경되었습니다.', 'success');
                        this.fnLoad();
                    } else {
                        this.showToast('변경 실패: ' + (res.message || '서버 오류'), 'error');
                        this.fnLoadMembers();
                    }
                },
                error: () => { this.showToast('서버 오류가 발생했습니다.', 'error'); this.fnLoadMembers(); }
            });
        },

        /* ── 필터 / 검색 / 페이지 ── */
        fnFilterGrade(id) { this.filterGrade = id; this.page = 1; this.fnLoadMembers(); },
        fnSearch()        { this.page = 1; this.fnLoadMembers(); },
        fnPage(p)         { this.page = p; this.fnLoadMembers(); },

        /* ── 헬퍼 ── */
        fnGradeColor(id) {
            const g = this.grades.find(g => g.gradeId === id);
            return g ? g.color : '#888';
        },
        fnGradeName(id) {
            const g = this.grades.find(g => g.gradeId === id);
            return g ? g.gradeName : '—';
        },
        fnGradeIcon(id) {
            const g = this.grades.find(g => g.gradeId === id);
            return g ? g.icon : '';
        },
        fnPrice(v) { return Number(v || 0).toLocaleString() + '원'; }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
