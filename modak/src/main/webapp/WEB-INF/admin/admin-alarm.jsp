<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="알람관리" />
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
    <style>[v-cloak] { display: none; }</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div class="admin-main">
    <div class="admin-topbar">
        <div class="topbar-title">🔔 알람 관리</div>
        <div class="topbar-right">
            <span style="font-size:12px;color:var(--text3)">회원에게 알람을 발송하고 내역을 관리합니다</span>
        </div>
    </div>

    <div class="admin-content" id="app" v-cloak>
        <div style="display:grid; grid-template-columns:1fr 400px; gap:20px; align-items:start">

            <!-- ── 왼쪽: 발송 폼 ── -->
            <div>
                <!-- STEP 1: 발송 대상 -->
                <div class="a-card" style="margin-bottom:20px">
                    <div class="a-card-title">📌 STEP 1 · 발송 대상 선택</div>
                    <div class="send-type-grid">
                        <div class="send-type-card" :class="{selected: sendType==='ALL'}" @click="fnSetType('ALL')">
                            <span class="send-type-icon">📢</span>
                            <div class="send-type-name">전체 발송</div>
                            <div class="send-type-desc">모든 활성 회원에게 발송</div>
                        </div>
                        <div class="send-type-card" :class="{selected: sendType==='SELECT'}" @click="fnSetType('SELECT')">
                            <span class="send-type-icon">☑️</span>
                            <div class="send-type-name">선택 발송</div>
                            <div class="send-type-desc">회원 직접 선택</div>
                        </div>
                        <div class="send-type-card" :class="{selected: sendType==='INDIVIDUAL'}" @click="fnSetType('INDIVIDUAL')">
                            <span class="send-type-icon">👤</span>
                            <div class="send-type-name">개별 발송</div>
                            <div class="send-type-desc">ID 직접 입력</div>
                        </div>
                    </div>

                    <!-- 선택 발송: 회원 리스트 -->
                    <div v-if="sendType==='SELECT'">
                        <input class="a-input" v-model="userSearchKw" placeholder="아이디·이름 검색"
                            @input="fnLoadUsers" style="margin-bottom:10px; width:100%">
                        <div class="user-select-wrap">
                            <div class="user-select-header">
                                <span style="font-size:12px; color:var(--text2)">회원 목록</span>
                                <span class="selected-count">{{ selectedUsers.length }}명 선택됨</span>
                            </div>
                            <div class="user-select-list">
                                <div v-for="u in userList" :key="u.userId"
                                    class="user-select-item"
                                    :class="{checked: selectedUsers.includes(u.userId)}"
                                    @click="fnToggleUser(u.userId)">
                                    <div class="user-checkbox"></div>
                                    <div>
                                        <div class="user-info-name">{{ u.userName }}</div>
                                        <div class="user-info-id">{{ u.userId }}
                                            <!-- 마케팅 동의 뱃지 -->
                                            <span v-if="u.marketingYn === 'Y'"
                                                style="margin-left:6px; background:rgba(232,115,42,.15);
                                                       color:#E8732A; font-size:10px; padding:1px 7px;
                                                       border-radius:6px; border:1px solid rgba(232,115,42,.3)">
                                                마케팅 동의
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div v-if="userList.length === 0"
                                    style="padding:24px; text-align:center; color:var(--text3); font-size:13px">
                                    검색 결과가 없습니다
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 개별 발송: ID 입력 -->
                    <div v-if="sendType==='INDIVIDUAL'" style="margin-top:12px">
                        <div style="display:flex; gap:8px">
                            <input class="a-input" v-model="individualId"
                                placeholder="회원 아이디를 입력하세요" style="flex:1">
                            <button class="btn-secondary" @click="fnFindUser"
                                style="padding:10px 18px; white-space:nowrap">확인</button>
                        </div>
                        <div v-if="foundUser" style="margin-top:10px; padding:12px 14px;
                            background:rgba(232,115,42,.07); border-radius:10px;
                            border:1px solid rgba(232,115,42,.2); display:flex; align-items:center; gap:10px">
                            <span style="font-size:20px">👤</span>
                            <div>
                                <div style="font-size:13px; font-weight:700; color:#fff">
                                    {{ foundUser.userName }}
                                    <span v-if="foundUser.marketingYn === 'Y'"
                                        style="margin-left:6px; background:rgba(232,115,42,.15);
                                               color:#E8732A; font-size:10px; padding:1px 7px;
                                               border-radius:6px; border:1px solid rgba(232,115,42,.3)">
                                        마케팅 동의
                                    </span>
                                </div>
                                <div style="font-size:11px; color:var(--text3)">{{ foundUser.userId }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- STEP 2: 알람 내용 -->
                <div class="a-card" style="margin-bottom:20px">
                    <div class="a-card-title">✏️ STEP 2 · 알람 내용 작성</div>

                    <!-- 알람 타입 버튼 -->
                    <div class="alarm-type-row">
                        <button v-for="t in alarmTypes" :key="t.value"
                            class="type-btn" :class="{active: form.type===t.value}"
                            @click="form.type = t.value">
                            {{ t.icon }} {{ t.label }}
                        </button>
                    </div>

                    <!-- ★ 마케팅 타입 선택 시 안내 배너 -->
                    <div v-if="form.type === 'MARKETING'"
                        style="margin-bottom:14px; padding:12px 16px;
                               background:rgba(232,115,42,.08); border-radius:10px;
                               border-left:3px solid #E8732A; display:flex; gap:10px; align-items:flex-start">
                        <span style="font-size:18px; flex-shrink:0">📣</span>
                        <div>
                            <div style="font-size:13px; font-weight:700; color:#E8732A; margin-bottom:2px">
                                마케팅 수신 동의 회원 전용
                            </div>
                            <div style="font-size:12px; color:var(--text2); line-height:1.6">
                                이 타입은 <b style="color:#fff">마케팅 정보 수신에 동의</b>한 회원에게만 발송됩니다.<br>
                                미동의 회원에게는 발송되지 않습니다.
                            </div>
                        </div>
                    </div>

                    <div style="display:grid; gap:12px">
                        <input class="a-input" v-model="form.title" placeholder="알람 제목">
                        <textarea class="a-input" v-model="form.content" placeholder="알람 내용"
                            style="min-height:100px; resize:vertical"></textarea>
                        <input class="a-input" v-model="form.linkUrl" placeholder="링크 URL (선택)">
                    </div>

                    <!-- 미리보기 -->
                    <div v-if="form.title || form.content" style="margin-top:14px">
                        <div style="font-size:11px; color:var(--text3); margin-bottom:6px">미리보기</div>
                        <div class="preview-alarm">
                            <div style="font-weight:700; color:#fff; margin-bottom:4px">
                                {{ fnTypeIcon(form.type) }} {{ form.title }}
                            </div>
                            <div style="font-size:12px; color:var(--text2)">{{ form.content }}</div>
                        </div>
                    </div>
                </div>

                <!-- 발송 버튼 -->
                <div class="a-card">
                    <div style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px">
                        <div>
                            <div style="font-size:13px; color:var(--text2)">
                                발송 대상: <b style="color:#fff">{{ fnGetTargetText() }}</b>
                            </div>
                            <div v-if="form.type === 'MARKETING' && sendType === 'ALL'"
                                style="font-size:11px; color:#E8732A; margin-top:3px">
                                ※ 마케팅 동의 회원에게만 발송됩니다
                            </div>
                        </div>
                        <button class="btn-primary"
                            :disabled="isSending || !fnCanSend()"
                            @click="fnSend"
                            style="padding:10px 30px">
                            {{ isSending ? '발송 중...' : '🔔 알람 발송' }}
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── 발송 확인 모달 ── -->
            <transition name="modal-fade">
                <div v-if="showConfirm" class="a-modal-overlay" @click.self="showConfirm=false">
                    <div class="a-modal-box">
                        <div class="a-modal-icon">🔔</div>
                        <div class="a-modal-title">알람 발송 확인</div>
                        <div class="a-modal-msg">
                            <b style="color:var(--white)">{{ fnGetTargetText() }}</b>에게<br>
                            <b style="color:var(--white)">「{{ form.title }}」</b><br>
                            알람을 발송하시겠습니까?
                        </div>
                        <div class="a-modal-btns">
                            <button class="a-modal-btn-cancel" @click="showConfirm=false">취소</button>
                            <button class="a-modal-btn-confirm" @click="fnDoSend">🔔 발송하기</button>
                        </div>
                    </div>
                </div>
            </transition>

            <!-- ── 오른쪽: 발송 내역 ── -->
            <div>
                <div class="a-card">
                    <div class="a-card-title">📋 최근 발송 내역</div>
                    <div class="a-tabs">
                        <button class="a-tab" :class="{active:logTab===''}"         @click="fnLogTab('')">전체</button>
                        <button class="a-tab" :class="{active:logTab==='NOTICE'}"   @click="fnLogTab('NOTICE')">공지</button>
                        <button class="a-tab" :class="{active:logTab==='EVENT'}"    @click="fnLogTab('EVENT')">이벤트</button>
                        <button class="a-tab" :class="{active:logTab==='DELIVERY'}" @click="fnLogTab('DELIVERY')">배송</button>
                        <button class="a-tab" :class="{active:logTab==='MARKETING'}" @click="fnLogTab('MARKETING')">마케팅</button>
                    </div>

                    <div v-if="alarmLogs.length === 0"
                        style="padding:32px; text-align:center; color:var(--text3); font-size:13px">
                        발송 내역이 없습니다
                    </div>
                    <div v-for="log in alarmLogs" :key="log.alarmId" class="alarm-log-item">
                        <div class="alarm-log-icon" :style="{background: fnTypeBg(log.type)}">
                            {{ fnTypeIcon(log.type) }}
                        </div>
                        <div class="alarm-log-body">
                            <div class="alarm-log-title">{{ log.title }}</div>
                            <div class="alarm-log-content">{{ log.content }}</div>
                            <div class="alarm-log-meta">
                                <span>{{ log.userId }}</span>
                                <span>{{ log.createdAt }}</span>
                            </div>
                        </div>
                        <div style="font-size:11px; color:var(--text3)">
                            {{ log.isRead === 'Y' ? '읽음' : '미읽음' }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="a-toast" id="aToast"></div>

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
            // ★ MARKETING 타입 추가
            alarmTypes: [
                { value: 'NOTICE',    icon: '📢', label: '공지'     },
                { value: 'EVENT',     icon: '🎁', label: '이벤트'   },
                { value: 'DELIVERY',  icon: '🚚', label: '배송'     },
                { value: 'MARKETING', icon: '📣', label: '마케팅'   }
            ],
            alarmLogs: [],
            logTab: '',
            isSending: false,
            showConfirm: false
        };
    },
    methods: {
        fnSetType(type) {
            this.sendType = type;
            this.foundUser = null;
            if (type === 'SELECT') this.fnLoadUsers();
        },

        // 회원 목록 로드 (marketingYn 포함)
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

        // 개별 회원 조회
        fnFindUser() {
            if (!this.individualId.trim()) { this.toast('아이디를 입력해주세요', 'error'); return; }
            $.ajax({
                url: '/admin/member/find.dox', type: 'POST',
                data: { userId: this.individualId },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.foundUser = data.user;
                    } else {
                        this.foundUser = null;
                        this.toast('존재하지 않는 회원입니다', 'error');
                    }
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
            if (this.sendType === 'ALL') {
                return this.form.type === 'MARKETING'
                    ? '마케팅 동의 회원 전체' : '전체 회원';
            }
            if (this.sendType === 'SELECT') return this.selectedUsers.length + '명';
            return this.foundUser ? this.foundUser.userName + ' (' + this.foundUser.userId + ')' : '미선택';
        },

        fnSend() {
            this.showConfirm = true;
        },

        fnDoSend() {
            this.showConfirm = false;
            this.isSending = true;

            const userId = this.sendType === 'INDIVIDUAL' && this.foundUser
                ? this.foundUser.userId : '';

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
                    userId:   userId
                },
                success: (res) => {
                    this.isSending = false;
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.toast('✅ 알람이 성공적으로 발송되었습니다', 'success');
                        this.form.title = '';
                        this.form.content = '';
                        this.form.linkUrl = '';
                        this.selectedUsers = [];
                        this.foundUser = null;
                        this.individualId = '';
                        this.fnLoadLogs();
                    } else {
                        this.toast('⚠️ 발송 실패: ' + (data.message || '오류'), 'error');
                    }
                },
                error: () => { this.isSending = false; this.toast('⚠️ 서버 오류가 발생했습니다', 'error'); }
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

        fnTypeIcon(t) {
            return { NOTICE:'📢', EVENT:'🎁', DELIVERY:'🚚', MARKETING:'📣' }[t] || '🔔';
        },
        fnTypeBg(t) {
            return {
                NOTICE:    'rgba(52,152,219,0.12)',
                EVENT:     'rgba(232,115,42,0.12)',
                DELIVERY:  'rgba(46,204,113,0.12)',
                MARKETING: 'rgba(155,89,182,0.12)'
            }[t] || 'rgba(255,255,255,0.05)';
        },

        toast(msg, type) {
            const t = document.getElementById('aToast');
            t.textContent = msg;
            t.className = 'a-toast ' + (type || '') + ' show';
            setTimeout(() => t.classList.remove('show'), 2200);
        }
    },
    mounted() { this.fnLoadLogs(); }
}).mount('#app');
</script>
</body>
</html>