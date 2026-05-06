<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="등급관리" />
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
    <style>
        [v-cloak] { display: none; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">
    <div class="admin-topbar">
        <div class="topbar-title">⭐ 등급 관리</div>
        <div class="topbar-right">
            <span style="font-size:12px;color:var(--text3)">회원 등급 혜택 및 조건을 관리합니다</span>
        </div>
    </div>

    <div class="admin-content" id="app" v-cloak>

        <div class="grade-flow">
            <div v-for="(g, i) in grades" :key="g.gradeId" class="grade-flow-item" :style="{'border-top': '3px solid ' + g.color}">
                <span class="grade-flow-arrow" v-if="i < grades.length - 1">›</span>
                <div class="grade-flow-name" :style="{color: g.color}">{{ g.gradeName }}</div>
                <div class="grade-flow-amount">{{ g.minAmount > 0 ? fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}</div>
            </div>
        </div>

        <div class="grade-grid">
            <div v-for="g in grades" :key="g.gradeId"
                 class="grade-card"
                 :class="{ selected: selectedGrade && selectedGrade.gradeId === g.gradeId }"
                 :style="{'--grade-color': g.color}"
                 @click="fnSelectGrade(g)">
                <span class="grade-icon">{{ g.icon }}</span>
                <div class="grade-name">{{ g.gradeName }}</div>
                <div class="grade-range">
                    {{ g.minAmount > 0 ? fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}
                    {{ g.discountRate > 0 ? ' · ' + g.discountRate + '% 할인' : '' }}
                </div>
                <div class="grade-member-count">{{ (g.memberCount || 0).toLocaleString() }}</div>
                <div class="grade-member-label">명의 회원</div>
                <div class="grade-benefits" v-if="g.benefitText">
                    <span v-for="b in g.benefitText.split(',')" :key="b" class="benefit-tag">{{ b.trim() }}</span>
                </div>
            </div>
        </div>

        <div class="edit-panel" v-if="selectedGrade">
            <div class="edit-panel-title">
                <span :style="{color: selectedGrade.color}">{{ selectedGrade.icon }} {{ selectedGrade.gradeName }}</span>
                등급 설정 수정
            </div>
            <div class="edit-grid">
                <div class="edit-field">
                    <label>등급명</label>
                    <input class="a-input" v-model="editForm.gradeName" placeholder="예: 브론즈">
                </div>
                <div class="edit-field">
                    <label>최소 누적 금액 (원)</label>
                    <input class="a-input" v-model.number="editForm.minAmount" type="number" min="0" step="10000">
                </div>
                <div class="edit-field">
                    <label>할인율 (%)</label>
                    <input class="a-input" v-model.number="editForm.discountRate" type="number" min="0" max="50">
                </div>
                <div class="edit-field" style="grid-column: 1/-1">
                    <label>등급 설명</label>
                    <input class="a-input" v-model="editForm.description" placeholder="등급에 대한 간단한 설명">
                </div>
                <div class="edit-field" style="grid-column: 1/-1">
                    <label>혜택 (쉼표로 구분)</label>
                    <input class="a-input" v-model="editForm.benefitText" placeholder="포인트 1% 적립, 생일 쿠폰 1장 등">
                </div>
            </div>
            <div style="display:flex; gap:10px; justify-content:flex-end">
                <button class="btn-ghost" @click="selectedGrade=null" style="padding: 8px 18px; border-radius: 10px; cursor:pointer;">취소</button>
                <button class="btn-primary" @click="fnSaveGrade" :disabled="isSaving">
                    {{ isSaving ? '저장중...' : '💾 설정 저장' }}
                </button>
            </div>
        </div>

        <div class="a-card">
            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; flex-wrap: wrap; gap: 15px;">
                <div class="member-section-title">
                    <span class="grade-dot" :style="selectedGrade ? {'background': selectedGrade.color} : {}"></span>
                    {{ selectedGrade ? selectedGrade.gradeName + ' 등급 회원' : '전체 회원 목록' }}
                    <span style="color:var(--text3); font-size:12px; font-weight:400; margin-left:5px;">({{ totalCount.toLocaleString() }}명)</span>
                </div>
                
                <div style="display:flex; gap:12px; align-items:center;">
                    <div class="a-tabs">
                        <button class="a-tab" :class="{active: filterGrade===''}" @click="fnFilterGrade('')">전체</button>
                        <button v-for="g in grades" :key="g.gradeId"
                                class="a-tab" :class="{active: filterGrade===g.gradeId}"
                                @click="fnFilterGrade(g.gradeId)"
                                :style="filterGrade===g.gradeId ? {borderColor: g.color, color: g.color} : {}">
                            {{ g.gradeName }}
                        </button>
                    </div>
                    
                    <div style="display:flex; gap:6px;">
                        <input class="a-input" v-model="keyword" placeholder="아이디·이름 검색" @keyup.enter="fnSearch" style="width:160px">
                        <button class="btn-primary" @click="fnSearch">검색</button>
                    </div>
                </div>
            </div>

            <div class="a-table-wrap">
                <table class="a-table">
                    <thead>
                        <tr>
                            <th>아이디</th>
                            <th>이름</th>
                            <th style="width:100px">현재등급</th>
                            <th style="width:120px">누적금액</th>
                            <th style="width:100px">포인트</th>
                            <th style="width:80px">상태</th>
                            <th style="width:110px">가입일</th>
                            <th style="width:130px">등급 변경</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="u in memberList" :key="u.userId">
                            <td style="font-weight:600">{{ u.userId }}</td>
                            <td>{{ u.userName }}</td>
                            <td>
                                <span class="badge" :style="fnGradeBadgeStyle(u.gradeId)">
                                    {{ fnGradeIcon(u.gradeId) }} {{ fnGradeName(u.gradeId) }}
                                </span>
                            </td>
                            <td style="color:var(--orange); font-weight:600">{{ fnPrice(u.totalAmount) }}</td>
                            <td style="color:var(--blue)">{{ (u.point||0).toLocaleString() }}P</td>
                            <td>
                                <span class="badge" :class="u.userStatus==='ACTIVE' ? 'badge-done' : 'badge-cancel'">
                                    {{ u.userStatus==='ACTIVE' ? '정상' : '정지' }}
                                </span>
                            </td>
                            <td style="color:var(--text3); font-size:12px">{{ u.createdAt }}</td>
                            <td>
                                <select class="a-input" style="padding:4px 8px; font-size:12px; cursor:pointer;"
                                        :value="u.gradeId"
                                        @change="fnChangeGrade(u, $event.target.value)">
                                    <option v-for="g in grades" :key="g.gradeId" :value="g.gradeId">
                                        {{ g.icon }} {{ g.gradeName }}
                                    </option>
                                </select>
                            </td>
                        </tr>
                        <tr v-if="!memberList.length">
                            <td colspan="8" style="text-align:center; padding:40px; color:var(--text3)">회원이 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="a-pagination" v-if="totalPages > 1">
                <button class="page-btn" :disabled="page<=1" @click="fnPage(page-1)">‹</button>
                <button v-for="p in totalPages" :key="p" class="page-btn" :class="{active:page===p}" @click="fnPage(p)">{{ p }}</button>
                <button class="page-btn" :disabled="page>=totalPages" @click="fnPage(page+1)">›</button>
            </div>
        </div>

    </div>
</div>

<div class="a-toast" id="aToast"></div>

<script>
var app = Vue.createApp({
    data: function() {
        return {
            grades: [
                { gradeId: 1, gradeName: '브론즈', icon: '🥉', color: '#C48250', minAmount: 0, discountRate: 0, memberCount: 0, benefitText: '', description: '' },
                { gradeId: 2, gradeName: '실버',   icon: '🥈', color: '#A0A0B0', minAmount: 30000, discountRate: 5, memberCount: 0, benefitText: '', description: '' },
                { gradeId: 3, gradeName: '골드',   icon: '🥇', color: '#D4932A', minAmount: 100000, discountRate: 10, memberCount: 0, benefitText: '', description: '' },
                { gradeId: 4, gradeName: 'VVIP',   icon: '👑', color: '#E8732A', minAmount: 300000, discountRate: 15, memberCount: 0, benefitText: '', description: '' }
            ],
            selectedGrade : null, editForm : {}, isSaving : false,
            memberList : [], keyword : '', filterGrade : '', page : 1, pageSize : 12, totalCount : 0
        };
    },
    computed: {
        totalPages: function() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        fnLoad: function() {
            var self = this;
            $.ajax({
                url: '/admin/grade/list.dox', type: 'POST', dataType: 'json',
                success: function(res) {
                    if (res.result === 'success') {
                        (res.grades || []).forEach(function(dbGrade) {
                            var local = self.grades.find(function(g) { return g.gradeId === dbGrade.gradeId; });
                            if (local) Object.assign(local, dbGrade);
                        });
                    }
                }
            });
            self.fnLoadMembers();
        },
        fnLoadMembers: function() {
            var self = this;
            $.ajax({
                url: '/admin/member/list.dox', type: 'POST', dataType: 'json',
                data: { keyword: self.keyword, gradeId: self.filterGrade, page: self.page, pageSize: self.pageSize },
                success: function(res) {
                    if (res.result === 'success') {
                        self.memberList = res.list || [];
                        self.totalCount = res.totalCount || 0;
                    }
                }
            });
        },
        fnSelectGrade: function(g) {
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
        fnSaveGrade: function() {
            var self = this;
            if (!self.editForm.gradeName) { self.toast('등급명을 입력하세요.', 'error'); return; }
            self.isSaving = true;
            $.ajax({
                url: '/admin/grade/save.dox', type: 'POST', dataType: 'json',
                data: self.editForm,
                success: function(res) {
                    self.isSaving = false;
                    if (res.result === 'success') {
                        var local = self.grades.find(function(g) { return g.gradeId === self.editForm.gradeId; });
                        if (local) Object.assign(local, self.editForm);
                        self.toast('✅ 등급 설정이 저장되었습니다.', 'success');
                        self.selectedGrade = null;
                    }
                }
            });
        },
        fnChangeGrade: function(user, newGradeId) {
            var self = this;
            if (!confirm(user.userName + '님의 등급을 변경하시겠습니까?')) { self.fnLoadMembers(); return; }
            $.ajax({
                url: '/admin/member/grade.dox', type: 'POST', dataType: 'json',
                data: { userId: user.userId, gradeId: newGradeId },
                success: function(res) {
                    if (res.result === 'success') {
                        user.gradeId = parseInt(newGradeId);
                        self.toast('✅ 등급 변경 완료', 'success');
                        self.fnLoad();
                    }
                }
            });
        },
        fnFilterGrade: function(id) { this.filterGrade = id; this.page = 1; this.fnLoadMembers(); },
        fnSearch: function() { this.page = 1; this.fnLoadMembers(); },
        fnPage: function(p) { this.page = p; this.fnLoadMembers(); },
        fnGradeName: function(id) { var g = this.grades.find(function(g) { return g.gradeId === id; }); return g ? g.gradeName : '-'; },
        fnGradeIcon: function(id) { var g = this.grades.find(function(g) { return g.gradeId === id; }); return g ? g.icon : ''; },
        fnGradeBadgeStyle: function(id) {
            var colors = { 1:'rgba(196,130,80,.15);color:#C48250', 2:'rgba(160,160,176,.15);color:#A0A0B0', 3:'rgba(212,147,42,.15);color:#D4932A', 4:'rgba(232,115,42,.15);color:#E8732A' };
            return 'background:' + (colors[id] || 'rgba(255,255,255,.1);color:#fff');
        },
        fnPrice: function(v) { return Number(v||0).toLocaleString() + '원'; },
        toast: function(msg, type) {
            var t = document.getElementById('aToast');
            t.textContent = msg;
            t.className = 'a-toast ' + (type||'info') + ' show';
            setTimeout(function() { t.classList.remove('show'); }, 2500);
        }
    },
    mounted: function() { this.fnLoad(); }
});
app.mount('#app');
</script>
</body>
</html>