<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대여 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-rentals.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="rental-page-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="r-page-header">
        <div class="r-title-wrap">
            <div class="r-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
            </div>
            <div>
                <div class="r-page-title">대여 현황 관리</div>
                <div class="r-page-subtitle">진행 중인 대여 일정과 반납 상태를 관리합니다</div>
            </div>
        </div>
        <button class="r-dashboard-btn" @click="fnGoDashboard">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── 통계 스트립 ── -->
    <div class="r-stat-strip">
        <div class="r-stat-item">
            <div class="r-stat-icon-wrap r-stat-total">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                </svg>
            </div>
            <div class="r-stat-body">
                <div class="r-stat-val">{{ rentalList.length }}</div>
                <div class="r-stat-lbl">전체 대여</div>
            </div>
        </div>
        <div class="r-stat-divider"></div>
        <div class="r-stat-item">
            <div class="r-stat-icon-wrap r-stat-inuse">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                </svg>
            </div>
            <div class="r-stat-body">
                <div class="r-stat-val r-v-orange">{{ inUseCount }}</div>
                <div class="r-stat-lbl">대여중</div>
            </div>
        </div>
        <div class="r-stat-divider"></div>
        <div class="r-stat-item">
            <div class="r-stat-icon-wrap r-stat-return">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-3.75"/>
                </svg>
            </div>
            <div class="r-stat-body">
                <div class="r-stat-val r-v-warn">{{ returnRequestCount }}</div>
                <div class="r-stat-lbl">반납 요청</div>
            </div>
        </div>
        <div class="r-stat-divider"></div>
        <div class="r-stat-item">
            <div class="r-stat-icon-wrap r-stat-done">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
            </div>
            <div class="r-stat-body">
                <div class="r-stat-val r-v-green">{{ completedCount }}</div>
                <div class="r-stat-lbl">반납완료</div>
            </div>
        </div>
        <div class="r-stat-spacer"></div>
        <!-- 필터 탭 -->
        <div class="r-filter-tabs">
            <button class="r-filter-tab" :class="{active: statusFilter === ''}"                 @click="statusFilter = ''">전체</button>
            <button class="r-filter-tab" :class="{active: statusFilter === 'RESERVED'}"         @click="statusFilter = 'RESERVED'">예약</button>
            <button class="r-filter-tab" :class="{active: statusFilter === 'IN_USE'}"           @click="statusFilter = 'IN_USE'">대여중</button>
            <button class="r-filter-tab" :class="{active: statusFilter === 'RETURN_REQUESTED'}" @click="statusFilter = 'RETURN_REQUESTED'">반납요청</button>
            <button class="r-filter-tab" :class="{active: statusFilter === 'RETURN_COMPLETED'}" @click="statusFilter = 'RETURN_COMPLETED'">반납완료</button>
        </div>
    </div>

    <!-- ── 테이블 카드 ── -->
    <div class="r-card">
        <table class="r-table">
            <thead>
                <tr>
                    <th style="width:7%">번호</th>
                    <th style="width:11%">대여자</th>
                    <th class="t-left">대여 상품</th>
                    <th style="width:12%">대여 시작일</th>
                    <th style="width:14%">반납 예정일</th>
                    <th style="width:11%">현재 상태</th>
                    <th style="width:13%">상태 변경</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="filteredList.length === 0">
                    <td colspan="7" class="r-empty-row">
                        <div class="r-empty-icon">🏕️</div>
                        <div>대여 데이터가 없습니다.</div>
                    </td>
                </tr>
                <tr class="r-row" v-for="item in filteredList" :key="item.RENTAL_ID">
                    <td><span class="r-id-badge">#{{ item.RENTAL_ID }}</span></td>
                    <td><span class="r-user-chip">{{ item.USER_ID }}</span></td>
                    <td class="r-prod-td">
                        <div class="r-img-box">
                            <img v-if="item.IMG_URL" :src="item.IMG_URL">
                            <span v-else class="r-img-placeholder">⛺</span>
                        </div>
                        <span class="r-prod-name">{{ item.PRODUCT_NAME }}</span>
                    </td>
                    <td class="r-date">{{ item.START_DATE }}</td>
                    <td>
                        <input type="date" class="r-date-input"
                               v-model="item.END_DATE"
                               @change="fnUpdateReturnDate(item)">
                    </td>
                    <td>
                        <span class="r-status-badge" :class="'rs-' + item.RENTAL_STATUS">
                            <span class="rs-dot" v-if="item.RENTAL_STATUS === 'IN_USE'"></span>
                            {{ fnStatusText(item.RENTAL_STATUS) }}
                        </span>
                    </td>
                    <td>
                        <select class="r-select" v-model="item.RENTAL_STATUS"
                                :class="'sel-' + item.RENTAL_STATUS"
                                @change="fnUpdateStatus(item)">
                            <option value="RESERVED">예약완료</option>
                            <option value="IN_USE">대여중</option>
                            <option value="RETURN_REQUESTED">반납요청</option>
                            <option value="RETURN_PICKED">수거중</option>
                            <option value="RETURN_COMPLETED">반납완료</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

</div><!-- rental-page-container -->

<!-- ── 확인 모달 ── -->
<transition name="r-modal-fade">
    <div class="r-confirm-overlay" v-if="showConfirmModal" @click.self="fnCancelConfirm">
        <div class="r-confirm-box">
            <div class="r-confirm-ico">{{ confirmConfig.icon || '❓' }}</div>
            <div class="r-confirm-title">{{ confirmConfig.title }}</div>
            <div class="r-confirm-msg" v-html="confirmConfig.msg"></div>
            <div class="r-confirm-btns">
                <button class="r-confirm-cancel" @click="fnCancelConfirm">취소</button>
                <button class="r-confirm-ok" :class="confirmConfig.danger ? 'ok-danger' : 'ok-primary'" @click="fnRunConfirm">{{ confirmConfig.okLabel || '확인' }}</button>
            </div>
        </div>
    </div>
</transition>

<!-- ── 토스트 ── -->
<div class="r-toast-container">
    <transition-group name="r-toast-slide">
        <div v-for="t in toasts" :key="t.id" class="r-toast-item" :class="'r-toast-' + t.type">
            <div class="r-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
            <div class="r-toast-msg">{{ t.message }}</div>
            <button class="r-toast-close" @click="removeToast(t.id)">✕</button>
            <div class="r-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
        </div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                rentalList: [],
                statusFilter: '',
                showConfirmModal: false,
                confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, resolve: null },
                toasts: []
            };
        },
        computed: {
            inUseCount()        { return this.rentalList.filter(r => r.RENTAL_STATUS === 'IN_USE').length; },
            returnRequestCount(){ return this.rentalList.filter(r => r.RENTAL_STATUS === 'RETURN_REQUESTED').length; },
            completedCount()    { return this.rentalList.filter(r => r.RENTAL_STATUS === 'RETURN_COMPLETED').length; },
            filteredList() {
                if (!this.statusFilter) return this.rentalList;
                return this.rentalList.filter(r => r.RENTAL_STATUS === this.statusFilter);
            }
        },
        methods: {
            /* ── 토스트 ── */
            toast(msg, type = 'success', duration = 3000) {
                const id = Date.now() + Math.random();
                this.toasts.push({ id, message: msg, type, duration });
                setTimeout(() => this.removeToast(id), duration);
            },
            removeToast(id) { this.toasts = this.toasts.filter(t => t.id !== id); },

            /* ── 확인 모달 (Promise 기반) ── */
            showConfirm(cfg) {
                return new Promise(resolve => {
                    this.confirmConfig = { ...cfg, resolve };
                    this.showConfirmModal = true;
                });
            },
            fnRunConfirm()    { this.showConfirmModal = false; if (this.confirmConfig.resolve) this.confirmConfig.resolve(true); },
            fnCancelConfirm() { this.showConfirmModal = false; if (this.confirmConfig.resolve) this.confirmConfig.resolve(false); },

            /* ── 상태 텍스트 ── */
            fnStatusText(s) {
                return { RESERVED: '예약완료', IN_USE: '대여중', RETURN_REQUESTED: '반납요청', RETURN_PICKED: '수거중', RETURN_COMPLETED: '반납완료' }[s] || s;
            },

            /* ── 데이터 로드 ── */
            fnGetList() {
                $.ajax({
                    url: '/admin/rental/list.dox', type: 'POST',
                    success: (data) => {
                        if (data.result === 'success') this.rentalList = data.list;
                        else this.toast('목록을 불러오지 못했습니다.', 'error');
                    },
                    error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                });
            },

            /* ── 상태 변경 ── */
            fnUpdateStatus(item) {
                $.ajax({
                    url: '/admin/rental/update-status.dox', type: 'POST',
                    data: { rentalId: item.RENTAL_ID, status: item.RENTAL_STATUS },
                    success: (data) => {
                        if (data.result === 'success') this.toast('대여 상태가 변경되었습니다.', 'success');
                        else { this.toast('상태 변경 실패: ' + (data.message || '오류'), 'error'); this.fnGetList(); }
                    },
                    error: () => { this.toast('서버 오류가 발생했습니다.', 'error'); this.fnGetList(); }
                });
            },

            /* ── 반납일 변경 ── */
            async fnUpdateReturnDate(item) {
                const ok = await this.showConfirm({
                    icon: '📅', title: '반납 예정일 변경',
                    msg: `반납 예정일을 <b>${item.END_DATE}</b>로 변경하시겠습니까?`,
                    okLabel: '변경', danger: false
                });
                if (!ok) { this.fnGetList(); return; }
                $.ajax({
                    url: '/admin/rental/update-date.dox', type: 'POST',
                    data: { rentalId: item.RENTAL_ID, returnDate: item.END_DATE },
                    success: (res) => {
                        if (res.result === 'success') this.toast('반납 예정일이 변경되었습니다.', 'success');
                        else { this.toast('수정 실패: ' + (res.message || '오류'), 'error'); this.fnGetList(); }
                    },
                    error: () => { this.toast('서버 오류가 발생했습니다.', 'error'); this.fnGetList(); }
                });
            },

            fnGoDashboard() { location.href = '/admin/dashboard.do'; }
        },
        mounted() { this.fnGetList(); }
    }).mount('#app');
</script>
</body>
</html>
