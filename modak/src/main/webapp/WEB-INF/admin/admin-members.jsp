<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-members.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main" v-cloak>
        <div class="member-page-container">

            <!-- ── 페이지 헤더 ── -->
            <div class="mem-page-header">
                <div class="mem-title-wrap">
                    <div class="mem-title-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <div>
                        <div class="mem-page-title">회원 관리</div>
                        <div class="mem-page-subtitle">총 {{ (summary.TOTAL || 0).toLocaleString() }}명의 회원</div>
                    </div>
                </div>
                <button class="mem-dashboard-btn" onclick="location.href='/admin/dashboard.do'">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                        <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                    </svg>
                    대시보드
                </button>
            </div>

            <!-- ── 요약 카드 ── -->
            <div class="mem-summary-grid">
                <div class="mem-summary-card">
                    <div class="sum-icon-wrap sum-total">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <div class="sum-body">
                        <div class="sum-label">전체 회원</div>
                        <div class="sum-value">{{ (summary.TOTAL || 0).toLocaleString() }}</div>
                    </div>
                    <div class="sum-accent-bar sum-bar-total"></div>
                </div>
                <div class="mem-summary-card">
                    <div class="sum-icon-wrap sum-active">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                            <polyline points="22 4 12 14.01 9 11.01"/>
                        </svg>
                    </div>
                    <div class="sum-body">
                        <div class="sum-label">정상 이용</div>
                        <div class="sum-value sum-v-active">{{ (summary.ACTIVE || 0).toLocaleString() }}</div>
                    </div>
                    <div class="sum-accent-bar sum-bar-active"></div>
                </div>
                <div class="mem-summary-card">
                    <div class="sum-icon-wrap sum-del">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
                        </svg>
                    </div>
                    <div class="sum-body">
                        <div class="sum-label">탈퇴 / 정지</div>
                        <div class="sum-value sum-v-del">{{ (summary.DELETED || 0).toLocaleString() }}</div>
                    </div>
                    <div class="sum-accent-bar sum-bar-del"></div>
                </div>
                <div class="mem-summary-card">
                    <div class="sum-icon-wrap sum-new">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
                            <polyline points="17 6 23 6 23 12"/>
                        </svg>
                    </div>
                    <div class="sum-body">
                        <div class="sum-label">신규 가입 (30일)</div>
                        <div class="sum-value sum-v-new">{{ (summary.NEW_MONTH || 0).toLocaleString() }}</div>
                    </div>
                    <div class="sum-accent-bar sum-bar-new"></div>
                </div>
            </div>

            <!-- ── 검색 / 필터 바 ── -->
            <div class="mem-search-card">
                <div class="mem-search-input-wrap">
                    <svg class="mem-search-ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="text" class="mem-search-input" v-model="keyword"
                           placeholder="아이디 또는 이름으로 검색" @keyup.enter="fnLoad(1)">
                    <button class="mem-clear-btn" v-if="keyword" @click="keyword=''; fnLoad(1)">✕</button>
                </div>
                <div class="mem-filter-group">
                    <button class="mem-ftab" :class="{active: statusFilter === ''}" @click="fnSetFilter('')">
                        <span class="mftab-dot mftab-all"></span> 전체
                        <span class="mftab-cnt">{{ (summary.TOTAL || 0) }}</span>
                    </button>
                    <button class="mem-ftab" :class="{active: statusFilter === 'ACTIVE'}" @click="fnSetFilter('ACTIVE')">
                        <span class="mftab-dot mftab-active"></span> 정상
                        <span class="mftab-cnt">{{ (summary.ACTIVE || 0) }}</span>
                    </button>
                    <button class="mem-ftab" :class="{active: statusFilter === 'DELETED'}" @click="fnSetFilter('DELETED')">
                        <span class="mftab-dot mftab-del"></span> 탈퇴/정지
                        <span class="mftab-cnt">{{ (summary.DELETED || 0) }}</span>
                    </button>
                </div>
                <button class="mem-search-btn" @click="fnLoad(1)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    검색
                </button>
            </div>

            <!-- ── 테이블 ── -->
            <div class="mem-table-card">
                <table class="mem-table">
                    <thead>
                        <tr>
                            <th style="width:6%"></th>
                            <th class="t-left" style="width:14%">아이디</th>
                            <th class="t-left" style="width:12%">이름</th>
                            <th class="t-left" style="width:26%">이메일</th>
                            <th style="width:13%">상태</th>
                            <th style="width:17%">가입일</th>
                            <th style="width:12%">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="mem-row" v-for="user in memberList" :key="user.USER_ID || user.userId">
                            <td>
                                <div class="mem-avatar"
                                     :class="(user.USER_STATUS || user.userStatus) === 'ACTIVE' ? 'av-active' : 'av-del'">
                                    {{ ((user.USER_ID || user.userId) || '?').charAt(0).toUpperCase() }}
                                </div>
                            </td>
                            <td class="t-left">
                                <span class="mem-id-text">{{ user.USER_ID || user.userId }}</span>
                            </td>
                            <td class="t-left">
                                <span class="mem-name-text">{{ user.USER_NAME || user.userName || '—' }}</span>
                            </td>
                            <td class="t-left">
                                <span class="mem-email-text">{{ user.EMAIL || user.email || '—' }}</span>
                            </td>
                            <td>
                                <span class="mem-sbadge"
                                      :class="(user.USER_STATUS || user.userStatus) === 'ACTIVE' ? 'sbadge-ok' : 'sbadge-del'">
                                    <span class="sbdot"></span>
                                    {{ (user.USER_STATUS || user.userStatus) === 'ACTIVE' ? '정상' : '탈퇴/정지' }}
                                </span>
                            </td>
                            <td class="mem-date-cell">{{ user.CREATED_AT || user.createdAt || '—' }}</td>
                            <td>
                                <button class="mem-action-btn"
                                        :class="(user.USER_STATUS || user.userStatus) === 'ACTIVE' ? 'mab-stop' : 'mab-release'"
                                        @click.stop="fnToggleStatus(user)">
                                    {{ (user.USER_STATUS || user.userStatus) === 'ACTIVE' ? '계정 정지' : '정지 해제' }}
                                </button>
                            </td>
                        </tr>
                        <tr v-if="memberList.length === 0 && !isLoading">
                            <td colspan="7" class="mem-empty-row">
                                <div class="mem-empty-icon">📭</div>
                                <div class="mem-empty-txt">조회된 회원이 없습니다</div>
                                <div class="mem-empty-sub">검색 조건을 변경해 보세요</div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="mem-pagination" v-if="totalPages > 1">
                    <button class="pg-btn" :disabled="currentPage === 1" @click="fnLoad(currentPage - 1)">&#8249;</button>
                    <button v-for="p in totalPages" :key="p" class="pg-btn"
                            :class="{active: currentPage === p}" @click="fnLoad(p)">{{ p }}</button>
                    <button class="pg-btn" :disabled="currentPage === totalPages" @click="fnLoad(currentPage + 1)">&#8250;</button>
                </div>
            </div>
        </div>

        <!-- ── 확인 모달 ── -->
        <div class="mem-confirm-overlay" :class="{open: confirmState.open}" @click.self="fnConfirmCancel">
            <div class="mem-confirm-box" :class="{open: confirmState.open}">
                <div class="mem-confirm-ico">{{ confirmState.type === 'danger' ? '🚫' : '✅' }}</div>
                <div class="mem-confirm-title">{{ confirmState.type === 'danger' ? '계정 정지' : '정지 해제' }}</div>
                <div class="mem-confirm-msg" v-html="confirmState.message"></div>
                <div class="mem-confirm-btns">
                    <button class="mem-cancel-btn" @click="fnConfirmCancel">취소</button>
                    <button class="mem-ok-btn"
                            :class="confirmState.type === 'danger' ? 'mem-ok-danger' : 'mem-ok-success'"
                            @click="fnConfirmOk">
                        {{ confirmState.type === 'danger' ? '정지하기' : '해제하기' }}
                    </button>
                </div>
            </div>
        </div>

        <!-- ── 토스트 ── -->
        <div class="mem-toast-container">
            <transition-group name="mem-toast-slide">
                <div v-for="t in toasts" :key="t.id" class="mem-toast-item" :class="'mem-toast-' + t.type">
                    <div class="mem-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
                    <div class="mem-toast-msg">{{ t.message }}</div>
                    <button class="mem-toast-close" @click="removeToast(t.id)">✕</button>
                    <div class="mem-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
                </div>
            </transition-group>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    memberList: [],
                    summary: {},
                    keyword: '',
                    statusFilter: '',
                    currentPage: 1,
                    totalPages: 1,
                    isLoading: false,
                    toasts: [],
                    confirmState: { open: false, message: '', resolve: null, type: 'danger' }
                };
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
                showConfirm(message, type = 'danger') {
                    return new Promise(resolve => {
                        this.confirmState = { open: true, message, resolve, type };
                    });
                },
                fnConfirmOk() {
                    if (this.confirmState.resolve) this.confirmState.resolve(true);
                    this.confirmState = { open: false, message: '', resolve: null, type: 'danger' };
                },
                fnConfirmCancel() {
                    if (this.confirmState.resolve) this.confirmState.resolve(false);
                    this.confirmState = { open: false, message: '', resolve: null, type: 'danger' };
                },

                /* ── 데이터 로드 ── */
                fnLoad(page) {
                    this.currentPage = page;
                    this.isLoading = true;
                    $.ajax({
                        url: "/admin/member/list.dox",
                        type: "POST",
                        data: { keyword: this.keyword, status: this.statusFilter, page, pageSize: 15 },
                        success: (res) => {
                            if (res.result === "success") {
                                this.memberList = res.list || [];
                                this.summary    = res.summary || {};
                                this.totalPages = res.totalPages || 1;
                            }
                        },
                        error: () => {
                            this.showToast('회원 목록을 불러오지 못했습니다.', 'error');
                        },
                        complete: () => { this.isLoading = false; }
                    });
                },
                fnSetFilter(status) {
                    this.statusFilter = status;
                    this.fnLoad(1);
                },

                /* ── 상태 변경 ── */
                async fnToggleStatus(user) {
                    const uId = user.USER_ID || user.userId;
                    const cur  = user.USER_STATUS || user.userStatus;
                    const next = cur === 'ACTIVE' ? 'DELETED' : 'ACTIVE';
                    const type = next === 'DELETED' ? 'danger' : 'success';
                    const msg  = next === 'DELETED'
                        ? '<b>' + uId + '</b> 회원의 계정을 정지하시겠습니까?<br><small>정지된 회원은 서비스 이용이 제한됩니다.</small>'
                        : '<b>' + uId + '</b> 회원의 계정 정지를 해제하시겠습니까?<br><small>해제 후 정상 이용이 가능합니다.</small>';

                    const ok = await this.showConfirm(msg, type);
                    if (!ok) return;

                    $.ajax({
                        url: "/admin/member/status.dox",
                        type: "POST",
                        data: { userId: uId, status: next },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                if (user.USER_STATUS !== undefined) user.USER_STATUS = next;
                                if (user.userStatus  !== undefined) user.userStatus  = next;
                                this.fnLoad(this.currentPage);
                                this.showToast(
                                    next === 'DELETED'
                                        ? uId + ' 계정이 정지되었습니다.'
                                        : uId + ' 계정 정지가 해제되었습니다.',
                                    next === 'DELETED' ? 'error' : 'success'
                                );
                            } else {
                                this.showToast('상태 변경 실패: ' + (data.message || '서버 오류'), 'error');
                            }
                        },
                        error: () => {
                            this.showToast('서버 통신 중 오류가 발생했습니다.', 'error');
                        }
                    });
                }
            },
            mounted() { this.fnLoad(1); }
        }).mount('#app');
    </script>
</body>
</html>
