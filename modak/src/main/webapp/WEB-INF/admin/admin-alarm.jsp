<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알람 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-alarm.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="al-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="al-header">
        <div class="al-title-wrap">
            <div class="al-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                </svg>
            </div>
            <div>
                <div class="al-page-title">알람 관리</div>
                <div class="al-page-sub">회원에게 알람을 발송하고 내역을 관리합니다</div>
            </div>
        </div>
        <button class="al-back-btn" onclick="location.href='/admin/dashboard.do'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/>
                <rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/>
                <rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── 2-컬럼 레이아웃 ── -->
    <div class="al-layout">

        <!-- ── 왼쪽: 발송 폼 ── -->
        <div class="al-left">

            <!-- STEP 1 -->
            <div class="al-card" style="margin-bottom:14px">
                <div class="al-card-title">
                    <div class="al-step-badge">1</div>
                    발송 대상 선택
                </div>
                <div class="al-type-grid">
                    <div class="al-type-card" :class="{active: sendType==='ALL'}" @click="fnSetType('ALL')">
                        <div class="al-type-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                <circle cx="9" cy="7" r="4"/>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                            </svg>
                        </div>
                        <div class="al-type-name">전체 발송</div>
                        <div class="al-type-desc">모든 활성 회원</div>
                    </div>
                    <div class="al-type-card" :class="{active: sendType==='SELECT'}" @click="fnSetType('SELECT')">
                        <div class="al-type-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="9 11 12 14 22 4"/>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                            </svg>
                        </div>
                        <div class="al-type-name">선택 발송</div>
                        <div class="al-type-desc">회원 직접 선택</div>
                    </div>
                    <div class="al-type-card" :class="{active: sendType==='INDIVIDUAL'}" @click="fnSetType('INDIVIDUAL')">
                        <div class="al-type-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div class="al-type-name">개별 발송</div>
                        <div class="al-type-desc">ID 직접 입력</div>
                    </div>
                </div>

                <!-- 선택 발송 -->
                <div v-if="sendType==='SELECT'" class="al-select-panel">
                    <input class="al-input" v-model="userSearchKw" placeholder="아이디·이름 검색"
                        @input="fnLoadUsers" style="margin-bottom:10px">
                    <div class="al-user-list-header">
                        <span style="font-size:12px;color:var(--sub)">회원 목록</span>
                        <span class="al-selected-cnt">{{ selectedUsers.length }}명 선택됨</span>
                    </div>
                    <div class="al-user-list">
                        <div v-for="u in userList" :key="u.userId"
                            class="al-user-item" :class="{checked: selectedUsers.includes(u.userId)}"
                            @click="fnToggleUser(u.userId)">
                            <div class="al-user-check" :class="{on: selectedUsers.includes(u.userId)}">
                                <svg v-if="selectedUsers.includes(u.userId)" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                    <polyline points="20 6 9 17 4 12"/>
                                </svg>
                            </div>
                            <div>
                                <div class="al-user-name">{{ u.userName }}
                                    <span v-if="u.marketingYn==='Y'" class="al-mkt-badge">마케팅 동의</span>
                                </div>
                                <div class="al-user-id">{{ u.userId }}</div>
                            </div>
                        </div>
                        <div v-if="userList.length===0" class="al-list-empty">검색 결과가 없습니다</div>
                    </div>
                </div>

                <!-- 개별 발송 -->
                <div v-if="sendType==='INDIVIDUAL'" class="al-individual-panel">
                    <div style="display:flex;gap:8px">
                        <input class="al-input" v-model="individualId"
                            placeholder="회원 아이디를 입력하세요" style="flex:1" @keyup.enter="fnFindUser">
                        <button class="al-find-btn" @click="fnFindUser">확인</button>
                    </div>
                    <div v-if="foundUser" class="al-found-user">
                        <div class="al-found-avatar">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div>
                            <div class="al-found-name">{{ foundUser.userName }}
                                <span v-if="foundUser.marketingYn==='Y'" class="al-mkt-badge">마케팅 동의</span>
                            </div>
                            <div class="al-found-id">{{ foundUser.userId }}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 2 -->
            <div class="al-card" style="margin-bottom:14px">
                <div class="al-card-title">
                    <div class="al-step-badge">2</div>
                    알람 내용 작성
                </div>

                <div class="al-alarm-types">
                    <button v-for="t in alarmTypes" :key="t.value"
                        class="al-atype-btn" :class="{active: form.type===t.value}"
                        @click="form.type=t.value">
                        {{ t.icon }} {{ t.label }}
                    </button>
                </div>

                <div v-if="form.type==='MARKETING'" class="al-mkt-notice">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;color:#E8732A">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <div>
                        <div style="font-size:12px;font-weight:700;color:#E8732A;margin-bottom:2px">마케팅 수신 동의 회원 전용</div>
                        <div style="font-size:11px;color:var(--text2)">마케팅 정보 수신에 동의한 회원에게만 발송됩니다.</div>
                    </div>
                </div>

                <div class="al-form-fields">
                    <input class="al-input" v-model="form.title" placeholder="알람 제목">
                    <textarea class="al-input al-textarea" v-model="form.content" placeholder="알람 내용" rows="4"></textarea>
                    <input class="al-input" v-model="form.linkUrl" placeholder="링크 URL (선택)">
                </div>

                <div v-if="form.title||form.content" class="al-preview">
                    <div class="al-preview-label">미리보기</div>
                    <div class="al-preview-box">
                        <div class="al-preview-title">{{ fnTypeIcon(form.type) }} {{ form.title }}</div>
                        <div class="al-preview-content">{{ form.content }}</div>
                    </div>
                </div>
            </div>

            <!-- 발송 버튼 -->
            <div class="al-card al-send-card">
                <div class="al-send-info">
                    <div class="al-send-target-label">발송 대상</div>
                    <div class="al-send-target-val">{{ fnGetTargetText() }}</div>
                    <div v-if="form.type==='MARKETING'&&sendType==='ALL'" class="al-send-mkt-note">
                        ※ 마케팅 동의 회원에게만 발송됩니다
                    </div>
                </div>
                <button class="al-send-btn"
                    :disabled="isSending || !fnCanSend()"
                    :class="{disabled: isSending || !fnCanSend()}"
                    @click="fnSend">
                    <svg v-if="!isSending" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                    </svg>
                    {{ isSending ? '발송 중...' : '알람 발송' }}
                </button>
            </div>
        </div>

        <!-- ── 오른쪽: 발송 내역 ── -->
        <div class="al-right">
            <div class="al-card al-log-card">
                <div class="al-card-title" style="margin-bottom:12px">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:15px;height:15px;color:#E8732A">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>
                    </svg>
                    최근 발송 내역
                </div>
                <div class="al-log-tabs">
                    <button class="al-log-tab" :class="{active:logTab===''}"         @click="fnLogTab('')">전체</button>
                    <button class="al-log-tab" :class="{active:logTab==='NOTICE'}"   @click="fnLogTab('NOTICE')">공지</button>
                    <button class="al-log-tab" :class="{active:logTab==='EVENT'}"    @click="fnLogTab('EVENT')">이벤트</button>
                    <button class="al-log-tab" :class="{active:logTab==='DELIVERY'}" @click="fnLogTab('DELIVERY')">배송</button>
                    <button class="al-log-tab" :class="{active:logTab==='MARKETING'}" @click="fnLogTab('MARKETING')">마케팅</button>
                </div>
                <div class="al-log-list">
                    <div v-if="alarmLogs.length===0" class="al-log-empty">발송 내역이 없습니다</div>
                    <div v-for="log in alarmLogs" :key="log.alarmId" class="al-log-item">
                        <div class="al-log-icon-wrap" :style="{background: fnTypeBg(log.type)}">
                            <span style="font-size:14px">{{ fnTypeIcon(log.type) }}</span>
                        </div>
                        <div class="al-log-body">
                            <div class="al-log-title">{{ log.title }}</div>
                            <div class="al-log-content">{{ log.content }}</div>
                            <div class="al-log-meta">
                                <span>{{ log.userId }}</span>
                                <span style="margin-left:auto">{{ log.createdAt }}</span>
                            </div>
                        </div>
                        <div class="al-log-read" :class="log.isRead==='Y'?'read':'unread'">
                            {{ log.isRead==='Y' ? '읽음' : '미읽음' }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div><!-- al-container -->

<!-- ── 발송 확인 모달 ── -->
<transition name="al-fade">
<div v-if="showConfirm" class="al-overlay" @click.self="showConfirm=false">
    <div class="al-confirm-box">
        <div class="al-confirm-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:32px;height:32px;color:#E8732A">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
            </svg>
        </div>
        <div class="al-confirm-title">알람 발송 확인</div>
        <div class="al-confirm-msg">
            <b style="color:#fff">{{ fnGetTargetText() }}</b>에게<br>
            <b style="color:#E8732A">「{{ form.title }}」</b><br>
            알람을 발송하시겠습니까?
        </div>
        <div class="al-confirm-btns">
            <button class="al-confirm-cancel" @click="showConfirm=false">취소</button>
            <button class="al-confirm-ok" @click="fnDoSend">발송하기</button>
        </div>
    </div>
</div>
</transition>

<!-- ── 토스트 ── -->
<div class="al-toast-wrap">
    <transition-group name="al-toast">
        <div v-for="t in toasts" :key="t.id" class="al-toast" :class="t.type">{{ t.msg }}</div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
Vue.createApp({
    data() {
        return {
            sendType: 'ALL',
            selectedUsers: [],
            userList: [],
            userSearchKw: '',
            individualId: '',
            foundUser: null,
            form: { type: 'NOTICE', title: '', content: '', linkUrl: '' },
            alarmTypes: [
                { value: 'NOTICE',    icon: '📢', label: '공지'   },
                { value: 'EVENT',     icon: '🎁', label: '이벤트' },
                { value: 'DELIVERY',  icon: '🚚', label: '배송'   },
                { value: 'MARKETING', icon: '📣', label: '마케팅' }
            ],
            alarmLogs: [],
            logTab: '',
            isSending: false,
            showConfirm: false,
            toasts: []
        };
    },
    methods: {
        toast(msg, type) {
            const id = Date.now() + Math.random();
            this.toasts.push({ id, msg, type: type || 'success' });
            setTimeout(() => { this.toasts = this.toasts.filter(t => t.id !== id); }, 2800);
        },
        fnSetType(type) {
            this.sendType = type;
            this.foundUser = null;
            if (type === 'SELECT') this.fnLoadUsers();
        },
        fnLoadUsers() {
            $.ajax({
                url: '/admin/member/list.dox', type: 'POST',
                data: { keyword: this.userSearchKw, page: 1, pageSize: 50 },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    this.userList = data.list || [];
                }
            });
        },
        fnToggleUser(id) {
            const idx = this.selectedUsers.indexOf(id);
            if (idx > -1) this.selectedUsers.splice(idx, 1);
            else this.selectedUsers.push(id);
        },
        fnFindUser() {
            if (!this.individualId.trim()) { this.toast('아이디를 입력해주세요', 'error'); return; }
            $.ajax({
                url: '/admin/member/find.dox', type: 'POST',
                data: { userId: this.individualId },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') this.foundUser = data.user;
                    else { this.foundUser = null; this.toast('존재하지 않는 회원입니다', 'error'); }
                }
            });
        },
        fnCanSend() {
            if (!this.form.title || !this.form.content) return false;
            if (this.sendType === 'SELECT' && this.selectedUsers.length === 0) return false;
            if (this.sendType === 'INDIVIDUAL' && !this.foundUser) return false;
            return true;
        },
        fnGetTargetText() {
            if (this.sendType === 'ALL') return this.form.type === 'MARKETING' ? '마케팅 동의 회원 전체' : '전체 회원';
            if (this.sendType === 'SELECT') return this.selectedUsers.length + '명';
            return this.foundUser ? this.foundUser.userName + ' (' + this.foundUser.userId + ')' : '미선택';
        },
        fnSend() { this.showConfirm = true; },
        fnDoSend() {
            this.showConfirm = false;
            this.isSending = true;
            $.ajax({
                url: '/admin/alarm/send.dox', type: 'POST',
                data: {
                    sendType: this.sendType,
                    type:     this.form.type,
                    title:    this.form.title,
                    content:  this.form.content,
                    linkUrl:  this.form.linkUrl || '',
                    linkId:   '',
                    userIds:  this.selectedUsers.join(','),
                    userId:   this.sendType === 'INDIVIDUAL' && this.foundUser ? this.foundUser.userId : ''
                },
                success: (res) => {
                    this.isSending = false;
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.toast('알람이 성공적으로 발송되었습니다', 'success');
                        this.form.title = ''; this.form.content = ''; this.form.linkUrl = '';
                        this.selectedUsers = []; this.foundUser = null; this.individualId = '';
                        this.fnLoadLogs();
                    } else { this.toast('발송 실패: ' + (data.message || '오류'), 'error'); }
                },
                error: () => { this.isSending = false; this.toast('서버 오류가 발생했습니다', 'error'); }
            });
        },
        fnLoadLogs() {
            $.ajax({
                url: '/admin/alarm/logs.dox', type: 'POST',
                data: { type: this.logTab, page: 1, pageSize: 30 },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    this.alarmLogs = data.list || [];
                }
            });
        },
        fnLogTab(tab) { this.logTab = tab; this.fnLoadLogs(); },
        fnTypeIcon(t) { return { NOTICE:'📢', EVENT:'🎁', DELIVERY:'🚚', MARKETING:'📣' }[t] || '🔔'; },
        fnTypeBg(t) {
            return {
                NOTICE:    'rgba(52,152,219,.12)',
                EVENT:     'rgba(232,115,42,.12)',
                DELIVERY:  'rgba(46,204,113,.12)',
                MARKETING: 'rgba(155,89,182,.12)'
            }[t] || 'rgba(255,255,255,.05)';
        }
    },
    mounted() { this.fnLoadLogs(); }
}).mount('#app');
</script>
</body>
</html>
