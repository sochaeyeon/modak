<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main">
        <div class="member-page-container">
            
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:32px;">
                <h2 style="color:#fff; margin:0;">👥 회원 관리 시스템</h2>
                <div class="header-buttons">
                    <button class="p-btn-secondary" onclick="location.href='/admin/dashboard.do'">🏠 대시보드</button>
                </div>
            </div>

            <div class="member-summary-grid">
                <div class="summary-item">
                    <div class="summary-label">전체 회원</div>
                    <div class="summary-value">{{ summary.TOTAL || 0 }}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">정상 이용</div>
                    <div class="summary-value" style="color:#58d68d">{{ summary.ACTIVE || 0 }}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">탈퇴/정지</div>
                    <div class="summary-value" style="color:#ec7063">{{ summary.DELETED || 0 }}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">신규 가입(30일)</div>
                    <div class="summary-value" style="color:var(--m-accent)">{{ summary.NEW_MONTH || 0 }}</div>
                </div>
            </div>

            <div class="member-search-bar">
                <input type="text" class="m-input" v-model="keyword" placeholder="아이디 또는 이름 입력" @keyup.enter="fnLoad(1)" style="flex:1">
                <select class="m-input" v-model="statusFilter" @change="fnLoad(1)">
                    <option value="">모든 상태</option>
                    <option value="ACTIVE">정상 회원</option>
                    <option value="DELETED">탈퇴/정지 회원</option>
                </select>
                <button class="p-btn" @click="fnLoad(1)">검색</button>
            </div>

            <div class="member-table-card">
                <table class="m-table">
                    <thead>
                        <tr>
                            <th>아이디</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>상태</th>
                            <th>가입일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="user in memberList" :key="user.USER_ID">
                            <td style="font-weight:700; color:var(--m-accent)">{{ user.USER_ID || user.userId }}</td>
                            <td>{{ user.USER_NAME || user.userName }}</td>
                            <td style="color:var(--m-text-muted)">{{ user.EMAIL || user.email }}</td>
                            <td>
                                <div style="display:flex; align-items:center; justify-content:center;">
                                    <span class="status-dot" :class="(user.USER_STATUS || user.userStatus) === 'ACTIVE' ? 'dot-active' : 'dot-deleted'"></span>
                                    <span :style="{color: (user.USER_STATUS || user.userStatus) === 'ACTIVE' ? '#58d68d' : '#ec7063', fontWeight:'bold'}">
                                        {{ (user.USER_STATUS || user.userStatus) === 'ACTIVE' ? '정상' : '탈퇴/정지' }}
                                    </span>
                                </div>
                            </td>
                            <td style="font-size:12px;">{{ user.CREATED_AT || user.createdAt }}</td>
                            <td>
                                <button class="p-btn-secondary" 
                                        :class="(user.USER_STATUS || user.userStatus) === 'ACTIVE' ? 'btn-stop' : 'btn-release'"
                                        @click="fnToggleStatus(user)">
                                    {{ (user.USER_STATUS || user.userStatus) === 'ACTIVE' ? '계정 정지' : '정지 해제' }}
                                </button>
                            </td>
                        </tr>
                        <tr v-if="memberList.length === 0">
                            <td colspan="6" style="padding:100px; color:var(--m-text-muted)">조회된 회원이 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
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
                    currentPage: 1
                };
            },
            methods: {
                // 데이터 불러오기 (검색/필터/상태변경 후 호출)
                fnLoad(page) {
                    this.currentPage = page;
                    const self = this;
                    $.ajax({
                        url: "/admin/member/list.dox",
                        type: "POST",
                        data: { 
                            keyword: self.keyword, 
                            status: self.statusFilter, 
                            page: page, 
                            pageSize: 15 
                        },
                        success: (res) => {
                            if(res.result === "success") {
                                self.memberList = res.list;
                                self.summary = res.summary; // 상단 요약 데이터 포함
                            }
                        }
                    });
                },
                // 회원 상태 변경 (정상 <-> 정지)
                fnToggleStatus(user) {
                    const self = this;
                    // 대소문자 이슈 방지를 위한 변수 처리
                    const uId = user.USER_ID || user.userId;
                    const currentStatus = user.USER_STATUS || user.userStatus;
                    const nextStatus = currentStatus === 'ACTIVE' ? 'DELETED' : 'ACTIVE';
                    
                    const msg = nextStatus === 'DELETED' ? "계정을 정지하시겠습니까?" : "계정 정지를 해제하시겠습니까?";
                    if(!confirm(msg)) return;
                    
                    $.ajax({
                        url: "/admin/member/status.dox",
                        type: "POST",
                        data: { 
                            userId: uId, 
                            status: nextStatus 
                        },
                        success: (res) => {
                            // JSON 파싱 (필요 시)
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            
                            if(data.result === "success") {
                                // 💡 [실시간 UI 갱신]
                                // 1. 현재 클릭한 객체의 상태값을 즉시 변경 (버튼/뱃지 즉각 반응)
                                if(user.USER_STATUS !== undefined) user.USER_STATUS = nextStatus;
                                if(user.userStatus !== undefined) user.userStatus = nextStatus;
                                
                                // 2. 상단 요약 카드의 통계 숫자 동기화를 위해 전체 리로드
                                self.fnLoad(self.currentPage);
                                
                                alert("성공적으로 변경되었습니다.");
                            } else {
                                alert("상태 변경 실패: " + data.message);
                            }
                        },
                        error: () => {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                }
            },
            mounted() {
                this.fnLoad(1);
            }
        }).mount('#app');
    </script>
</body>
</html>