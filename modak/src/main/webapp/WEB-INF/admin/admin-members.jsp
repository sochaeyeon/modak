<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="회원관리" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">
    <div class="admin-topbar">
        <div class="topbar-title">👥 회원 관리</div>
    </div>

    <div class="admin-content" id="app">

        <!-- 요약 카드 -->
        <div class="stat-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:24px">
            <div class="stat-card" style="--accent:var(--blue)">
                <span class="stat-icon">👥</span>
                <div class="stat-label">전체 회원</div>
                <div class="stat-value">{{ summary.total.toLocaleString() }}</div>
            </div>
            <div class="stat-card" style="--accent:var(--green)">
                <span class="stat-icon">✅</span>
                <div class="stat-label">정상</div>
                <div class="stat-value">{{ summary.active.toLocaleString() }}</div>
            </div>
            <div class="stat-card" style="--accent:var(--red)">
                <span class="stat-icon">🚫</span>
                <div class="stat-label">정지</div>
                <div class="stat-value">{{ summary.blocked }}</div>
            </div>
            <div class="stat-card" style="--accent:var(--amber)">
                <span class="stat-icon">⭐</span>
                <div class="stat-label">VVIP</div>
                <div class="stat-value">{{ summary.vvip }}</div>
            </div>
        </div>

        <!-- 검색 & 필터 -->
        <div class="search-bar">
            <input class="a-input" v-model="keyword" placeholder="아이디·이름·이메일 검색" @keyup.enter="fnSearch">
            <select class="a-input" v-model="gradeFilter" @change="fnSearch" style="max-width:130px">
                <option value="">전체 등급</option>
                <option value="1">브론즈</option>
                <option value="2">실버</option>
                <option value="3">골드</option>
                <option value="4">VVIP</option>
            </select>
            <select class="a-input" v-model="statusFilter" @change="fnSearch" style="max-width:120px">
                <option value="">전체 상태</option>
                <option value="ACTIVE">정상</option>
                <option value="BLOCKED">정지</option>
            </select>
            <button class="btn-sm btn-primary" @click="fnSearch">검색</button>
        </div>

        <div class="a-card">
            <div class="a-table-wrap">
                <table class="a-table">
                    <thead>
                        <tr>
                            <th>아이디</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th style="width:80px">등급</th>
                            <th style="width:90px">누적금액</th>
                            <th style="width:80px">포인트</th>
                            <th style="width:80px">상태</th>
                            <th style="width:120px">가입일</th>
                            <th style="width:100px">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="u in list" :key="u.userId">
                            <td style="font-weight:600">{{ u.userId }}</td>
                            <td>{{ u.userName }}</td>
                            <td style="color:var(--text2);font-size:12px">{{ u.email }}</td>
                            <td>
                                <span class="badge"
                                      :style="fnGradeBadgeStyle(u.gradeId)">
                                    {{ fnGradeName(u.gradeId) }}
                                </span>
                            </td>
                            <td style="color:var(--orange)">{{ fnPrice(u.totalAmount) }}</td>
                            <td style="color:var(--text2)">{{ (u.point||0).toLocaleString() }}P</td>
                            <td>
                                <span class="badge" :class="u.userStatus === 'ACTIVE' ? 'badge-done' : 'badge-cancel'">
                                    {{ u.userStatus === 'ACTIVE' ? '정상' : '정지' }}
                                </span>
                            </td>
                            <td style="color:var(--text3);font-size:12px">{{ u.createdAt }}</td>
                            <td>
                                <div style="display:flex;gap:6px">
                                    <button class="btn-sm btn-ghost" @click="fnViewUser(u)" style="font-size:11px">상세</button>
                                    <button class="btn-sm"
                                            :class="u.userStatus === 'ACTIVE' ? 'btn-danger' : 'btn-success'"
                                            @click="fnToggleStatus(u)" style="font-size:11px">
                                        {{ u.userStatus === 'ACTIVE' ? '정지' : '해제' }}
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="!list.length">
                            <td colspan="9" style="text-align:center;padding:32px;color:var(--text3)">회원이 없습니다</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="a-pagination">
                <button class="page-btn" :disabled="page<=1" @click="fnPage(page-1)">‹</button>
                <button v-for="p in totalPages" :key="p" class="page-btn" :class="{active:page===p}" @click="fnPage(p)">{{ p }}</button>
                <button class="page-btn" :disabled="page>=totalPages" @click="fnPage(page+1)">›</button>
            </div>
        </div>
    </div>
</div>

<!-- 회원 상세 모달 -->
<div class="a-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
    <div class="a-modal">
        <div class="a-modal-title">
            회원 상세 — {{ selectedUser ? selectedUser.userId : '' }}
            <button class="a-modal-close" @click="modalOpen=false">✕</button>
        </div>
        <div v-if="selectedUser">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:16px">
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">아이디</div>
                    <div style="font-size:14px;font-weight:600">{{ selectedUser.userId }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">이름</div>
                    <div>{{ selectedUser.userName }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">이메일</div>
                    <div style="font-size:13px">{{ selectedUser.email }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">전화번호</div>
                    <div>{{ selectedUser.userPhone }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">누적 금액</div>
                    <div style="color:var(--orange);font-weight:600">{{ fnPrice(selectedUser.totalAmount) }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">보유 포인트</div>
                    <div style="color:var(--blue);font-weight:600">{{ (selectedUser.point||0).toLocaleString() }}P</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">등급</div>
                    <div>{{ fnGradeName(selectedUser.gradeId) }}</div>
                </div>
                <div>
                    <div style="font-size:11px;color:var(--text3);margin-bottom:4px">가입일</div>
                    <div style="font-size:12px">{{ selectedUser.createdAt }}</div>
                </div>
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end">
                <button class="btn-sm btn-ghost" @click="modalOpen=false">닫기</button>
                <button class="btn-sm"
                        :class="selectedUser.userStatus==='ACTIVE' ? 'btn-danger' : 'btn-success'"
                        @click="fnToggleStatus(selectedUser); modalOpen=false">
                    {{ selectedUser.userStatus === 'ACTIVE' ? '계정 정지' : '정지 해제' }}
                </button>
            </div>
        </div>
    </div>
</div>

<div class="a-toast" id="aToast"></div>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            list: [], keyword: '', gradeFilter: '', statusFilter: '',
            page: 1, pageSize: 15, totalCount: 0,
            summary: { total:0, active:0, blocked:0, vvip:0 },
            modalOpen: false, selectedUser: null
        };
    },
    computed: {
        totalPages() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        fnLoad() {
            $.ajax({
                url: '/admin/member/list.dox', type: 'POST', dataType: 'json',
                data: { keyword: this.keyword, gradeId: this.gradeFilter, userStatus: this.statusFilter, page: this.page, pageSize: this.pageSize },
                success: (res) => {
                    if (res.result === 'success') {
                        this.list       = res.list    || [];
                        this.totalCount = res.totalCount || 0;
                        this.summary    = res.summary || this.summary;
                    }
                }
            });
        },
        fnSearch() { this.page = 1; this.fnLoad(); },
        fnPage(p)  { this.page = p; this.fnLoad(); },
        fnViewUser(u) { this.selectedUser = u; this.modalOpen = true; },
        fnToggleStatus(u) {
            var newStatus = u.userStatus === 'ACTIVE' ? 'BLOCKED' : 'ACTIVE';
            if (!confirm((newStatus === 'BLOCKED' ? '정지' : '해제') + ' 하시겠습니까?')) return;
            $.ajax({
                url: '/admin/member/status.dox', type: 'POST', dataType: 'json',
                data: { userId: u.userId, userStatus: newStatus },
                success: (res) => {
                    if (res.result === 'success') {
                        u.userStatus = newStatus;
                        this.toast(newStatus === 'BLOCKED' ? '계정이 정지되었습니다.' : '계정이 정상화되었습니다.', 'success');
                    }
                }
            });
        },
        fnGradeName(id) { return ['','브론즈','실버','골드','VVIP'][id] || '-'; },
        fnGradeBadgeStyle(id) {
            var styles = ['','background:rgba(196,130,80,.2);color:#C48250','background:rgba(180,180,180,.2);color:#aaa','background:rgba(212,147,42,.2);color:#D4932A','background:rgba(232,115,42,.2);color:#E8732A'];
            return styles[id] || '';
        },
        fnPrice(v) { return Number(v||0).toLocaleString() + '원'; },
        toast(msg, type='info') {
            var t = document.getElementById('aToast');
            t.textContent = msg; t.className = 'a-toast ' + type; t.classList.add('show');
            setTimeout(() => t.classList.remove('show'), 2500);
        }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
