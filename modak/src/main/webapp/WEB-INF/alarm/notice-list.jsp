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
        <div class="alarm-header-flex" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h2 class="alarm-title-main" style="margin: 0;">🔔 활동 알림</h2>
            <button v-if="alarmList.length > 0" @click="fnRemoveAll" class="all-remove-btn">전체 삭제</button>
        </div>
        
        <div v-for="item in alarmList" :key="item.ALARM_ID" 
             class="alarm-item" 
             :class="{ unread: item.IS_READ === 'N' }"
             @click="fnGoDetail(item.ALARM_ID)"
             style="position: relative;"> <div class="alarm-icon">
                <span v-if="item.TYPE === 'DELIVERY'">🚚</span>
                <span v-else-if="item.TYPE === 'EVENT'">🎁</span>
                <span v-else>📢</span>
            </div>
            
            <div class="alarm-info">
                <div class="alarm-subject">
                    <span v-if="item.IS_READ === 'N'" style="color: #E8732A; font-size: 12px; margin-right: 5px;">●</span>
                    {{ item.TITLE }}
                </div>
                <div class="alarm-text">{{ item.CONTENT }}</div>
                <div class="alarm-time"><i class="fa-regular fa-clock"></i> {{ item.CREATED_AT }}</div>
            </div>

            <button class="remove-btn" @click.stop="fnRemove(item.ALARM_ID)">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div v-if="alarmList.length === 0" class="no-alarm">
            <div class="no-alarm-icon">⛺</div>
            <p class="no-alarm-text">아직 새로운 소식이 없다닥!</p>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() { return { alarmList: [] }; },
            methods: {
                fnGetList() {
                    $.ajax({
                        url: "/alarm/getAlarmList.dox",
                        type: "POST",
                        dataType: "json",
                        success: (res) => { if(res.result === 'success') this.alarmList = res.list; }
                    });
                },
                fnGoDetail(id) { location.href = "/alarm/notice-detail.do?alarmId=" + id; },
                // 단건 삭제
                fnRemove(id) {
                    if(!confirm("이 알림을 삭제하시겠닥? ⛺")) return;
                    $.ajax({
                        url: "/alarm/removeAlarm.dox",
                        type: "POST",
                        data: { alarmId: id },
                        success: (res) => { if(res.result === 'success') this.fnGetList(); }
                    });
                },
                // 전체 삭제
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