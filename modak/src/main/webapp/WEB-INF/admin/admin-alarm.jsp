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

            <div>
                <div class="a-card" style="margin-bottom:20px">
                    <div class="a-card-title">📌 STEP 1 · 발송 대상 선택</div>
                    <div class="send-type-grid">
                        <div class="send-type-card" :class="{selected: sendType==='ALL'}" @click="fnSetType('ALL')">
                            <span class="send-type-icon">📢</span>
                            <div class="send-type-name">전체 발송</div>
                            <div class="send-type-desc">모든 회원에게 발송</div>
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

                    <div v-if="sendType==='SELECT'">
                        <input class="a-input" v-model="userSearchKw" placeholder="아이디·이름 검색" @input="fnSearchUsers" style="margin-bottom:10px; width:100%">
                        <div class="user-select-wrap">
                            <div class="user-select-header">
                                <span style="font-size:12px; color:var(--text2)">회원 목록</span>
                                <span class="selected-count">{{ selectedUsers.length }}명 선택됨</span>
                            </div>
                            <div class="user-select-list">
                                <div v-for="u in userList" :key="u.userId" class="user-select-item" :class="{checked: selectedUsers.includes(u.userId)}" @click="fnToggleUser(u.userId)">
                                    <div class="user-checkbox"></div>
                                    <div>
                                        <div class="user-info-name">{{ u.userName }}</div>
                                        <div class="user-info-id">{{ u.userId }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="a-card" style="margin-bottom:20px">
                    <div class="a-card-title">✏️ STEP 2 · 알람 내용 작성</div>
                    <div class="alarm-type-row">
                        <button v-for="t in alarmTypes" :key="t.value" class="type-btn" :class="{active: form.type===t.value}" @click="form.type=t.value">
                            {{ t.icon }} {{ t.label }}
                        </button>
                    </div>
                    <div style="display:grid; gap:12px">
                        <input class="a-input" v-model="form.title" placeholder="알람 제목">
                        <textarea class="a-input" v-model="form.content" placeholder="알람 내용" style="min-height:100px; resize:vertical"></textarea>
                    </div>
                    <div class="preview-card" v-if="form.title || form.content">
                        <div class="preview-alarm">
                            <div style="font-weight:700; color:#fff; margin-bottom:4px">{{ fnTypeIcon(form.type) }} {{ form.title }}</div>
                            <div style="font-size:12px; color:var(--text2)">{{ form.content }}</div>
                        </div>
                    </div>
                </div>

                <div class="a-card">
                    <div style="display:flex; align-items:center; justify-content:space-between">
                        <span style="font-size:13px; color:var(--text2)">발송 대상: <b>{{ fnGetTargetText() }}</b></span>
                        <button class="btn-primary" :disabled="isSending || !fnCanSend()" @click="fnSend" style="padding:10px 30px">
                            {{ isSending ? '발송 중...' : '🔔 알람 발송' }}
                        </button>
                    </div>
                </div>
            </div>

            <div>
                <div class="a-card">
                    <div class="a-card-title">📋 최근 발송 내역</div>
                    <div class="a-tabs">
                        <button class="a-tab" :class="{active:logTab===''}" @click="fnLogTab('')">전체</button>
                        <button class="a-tab" :class="{active:logTab==='NOTICE'}" @click="fnLogTab('NOTICE')">공지</button>
                        <button class="a-tab" :class="{active:logTab==='EVENT'}" @click="fnLogTab('EVENT')">이벤트</button>
                        <button class="a-tab" :class="{active:logTab==='DELIVERY'}" @click="fnLogTab('DELIVERY')">배송</button>
                    </div>

                    <div v-for="log in alarmLogs" :key="log.alarmId" class="alarm-log-item">
                        <div class="alarm-log-icon" :style="{background: fnTypeBg(log.type)}">{{ fnTypeIcon(log.type) }}</div>
                        <div class="alarm-log-body">
                            <div class="alarm-log-title">{{ log.title }}</div>
                            <div class="alarm-log-content">{{ log.content }}</div>
                            <div class="alarm-log-meta">
                                <span>{{ log.userId }}</span>
                                <span>{{ log.createdAt }}</span>
                            </div>
                        </div>
                        <div style="font-size:11px; color:var(--text3)">{{ log.isRead === 'Y' ? '읽음' : '미읽음' }}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="a-toast" id="aToast"></div>

<script>
var app = Vue.createApp({
    data: function() {
        return {
            sendType: 'ALL', selectedUsers: [], userList: [], userSearchKw: '',
            form: { type:'NOTICE', title:'', content:'', linkUrl:'' },
            alarmTypes: [
                { value:'NOTICE', icon:'📢', label:'공지' },
                { value:'EVENT', icon:'🎁', label:'이벤트' },
                { value:'DELIVERY', icon:'🚚', label:'배송' }
            ],
            alarmLogs: [], logTab: '', logPage: 1, isSending: false
        };
    },
    methods: {
        fnSetType: function(type) { this.sendType = type; if(type==='SELECT') this.fnLoadUsers(); },
        fnLoadUsers: function() {
            var self = this;
            $.ajax({ url: '/admin/member/list.dox', type:'POST', data: { keyword: self.userSearchKw }, success: function(res) { self.userList = res.list; } });
        },
        fnToggleUser: function(id) { var idx = this.selectedUsers.indexOf(id); if(idx>-1) this.selectedUsers.splice(idx,1); else this.selectedUsers.push(id); },
        fnCanSend: function() { return this.form.title && this.form.content; },
        fnGetTargetText: function() {
            if(this.sendType==='ALL') return '전체 회원';
            if(this.sendType==='SELECT') return this.selectedUsers.length + '명';
            return '개별 회원';
        },
        fnSend: function() {
            var self = this;
            if(!confirm('발송하시겠습니까?')) return;
            self.isSending = true;
            $.ajax({
                url: '/admin/alarm/send.dox', type:'POST', data: { ...self.form, sendType: self.sendType, userIds: self.selectedUsers.join(',') },
                success: function(res) { self.isSending = false; self.toast('발송 완료', 'success'); self.fnLoadLogs(); }
            });
        },
        fnLoadLogs: function() {
            var self = this;
            $.ajax({ url: '/admin/alarm/logs.dox', type:'POST', data: { type: self.logTab }, success: function(res) { self.alarmLogs = res.list; } });
        },
        fnLogTab: function(tab) { this.logTab = tab; this.fnLoadLogs(); },
        fnTypeIcon: function(t) { var m = { NOTICE:'📢', EVENT:'🎁', DELIVERY:'🚚' }; return m[t] || '🔔'; },
        fnTypeBg: function(t) { var m = { NOTICE:'rgba(52,152,219,0.1)', EVENT:'rgba(232,115,42,0.1)', DELIVERY:'rgba(46,204,113,0.1)' }; return m[t] || '#333'; },
        toast: function(msg, type) { var t = document.getElementById('aToast'); t.textContent = msg; t.className = 'a-toast ' + type + ' show'; setTimeout(()=>t.classList.remove('show'), 2000); }
    },
    mounted: function() { this.fnLoadLogs(); }
}).mount('#app');
</script>
</body>
</html>