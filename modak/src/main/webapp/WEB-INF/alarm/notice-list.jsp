<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알림 센터 - 모닥모닥</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/alarm/alarm.css">
    <style>
        [v-cloak] { display: none; }
        body { background-color: #faf6f0 !important; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <div id="noticeApp" class="alarm-page" v-cloak>
        <div class="alarm-header-flex">
            <h2 class="alarm-title-main">🔔 활동 알림</h2>
            <button v-if="alarmList.length > 0" @click="fnRemoveAll" class="all-remove-btn">전체 삭제</button>
        </div>

        <div class="alarm-tabs">
            <button @click="currentTab = 'all'" :class="{ active: currentTab === 'all' }" class="tab-btn">
                전체 <span class="count-badge">{{ alarmList.length }}</span>
            </button>
            <button @click="currentTab = 'unread'" :class="{ active: currentTab === 'unread' }" class="tab-btn">
                안 읽음 <span class="count-badge unread-bg">{{ unreadCount }}</span>
            </button>
        </div>
        
        <div class="alarm-list-wrap">
            <div v-for="item in filteredList" :key="item.ALARM_ID" 
                 class="alarm-item" 
                 :class="{ unread: item.IS_READ === 'N', read: item.IS_READ === 'Y' }"
                 @click="fnGoDetail(item.ALARM_ID)">
                
                <div class="alarm-icon">
                    <span v-if="item.TYPE === 'DELIVERY'">🚚</span>
                    <span v-else-if="item.TYPE === 'EVENT'">🎁</span>
                    <span v-else>📢</span>
                </div>
                
                <div class="alarm-info">
                    <div class="alarm-subject">
                        <span v-if="item.IS_READ === 'N'" class="unread-dot">●</span>
                        {{ item.TITLE }}
                    </div>
                    <div class="alarm-text">{{ item.CONTENT }}</div>
                    <div class="alarm-time">
                        <i class="fa-regular fa-clock"></i> {{ item.CREATED_AT }}
                    </div>
                </div>

                <button class="remove-btn" @click.stop="fnRemove(item.ALARM_ID)">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
        </div>

        <div v-if="filteredList.length === 0" class="no-alarm">
            <div class="no-alarm-icon">⛺</div>
            <p class="no-alarm-text">아직 새로운 소식이 없다닥!</p>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() { 
                return { 
                    alarmList: [],
                    currentTab: 'all'
                }; 
            },
            computed: {
                unreadCount() {
                    return this.alarmList.filter(item => item.IS_READ === 'N').length;
                },
                filteredList() {
                    if (this.currentTab === 'unread') {
                        return this.alarmList.filter(item => item.IS_READ === 'N');
                    }
                    return this.alarmList;
                }
            },
            methods: {
                fnGetList() {
                    $.ajax({
                        url: "/alarm/getAlarmList.dox",
                        type: "POST",
                        dataType: "json",
                        success: (res) => { 
                            if(res.result === 'success') this.alarmList = res.list; 
                        }
                    });
                },
                fnGoDetail(id) { location.href = "/alarm/notice-detail.do?alarmId=" + id; },
                fnRemove(id) {
                    if(!confirm("이 알림을 삭제하시겠닥?")) return;
                    $.ajax({
                        url: "/alarm/removeAlarm.dox",
                        type: "POST",
                        data: { alarmId: id },
                        success: (res) => { if(res.result === 'success') this.fnGetList(); }
                    });
                },
                fnRemoveAll() {
                    if(!confirm("모든 알림을 지우시겠닥? 정말이냐닥! 🔥")) return;
                    $.ajax({
                        url: "/alarm/removeAllAlarms.dox",
                        type: "POST",
                        success: (res) => { if(res.result === 'success') this.fnGetList(); }
                    });
                }
            },
            mounted() { this.fnGetList(); }
        }).mount('#noticeApp');
    </script>
</body>
</html>