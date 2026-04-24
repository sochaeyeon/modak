<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                [v-cloak] {
                    display: none;
                }

                body {
                    background-color: #faf6f0 !important;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/WEB-INF/common/header.jsp" />

            <div id="noticeApp" class="alarm-page" v-cloak>
                <div class="alarm-header-flex">
                    <h2 class="alarm-title-main">🔔 활동 알림</h2>
                    <button v-if="alarmList.length > 0" @click="fnRemoveAll" class="all-remove-btn">전체 삭제</button>
                </div>

                <div class="alarm-tabs" ref="tabWrap">
                    <button ref="tabAll" @click="fnChangeTab('all')" :class="{ active: currentTab === 'all' }"
                        class="tab-btn">
                        전체 <span class="count-badge">{{ alarmList.length }}</span>
                    </button>

                    <button ref="tabUnread" @click="fnChangeTab('unread')" :class="{ active: currentTab === 'unread' }"
                        class="tab-btn">
                        안 읽음 <span class="count-badge unread-bg">{{ unreadCount }}</span>
                    </button>

                    <!-- ⭐ 이동하는 밑줄 -->
                    <div class="tab-underline" :style="underlineStyle"></div>
                </div>

                <div class="alarm-list-wrap">
                    <div v-for="item in filteredList" :key="item.ALARM_ID" class="alarm-item"
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

                <div class="toast" :class="{ show: toastVisible }">
                    {{ toastMsg }}
                </div>

                <div v-if="deleteModalOpen" class="delete-modal-backdrop" @click.self="fnCloseDeleteModal"
                    @keydown.enter.prevent="fnConfirmDelete" @keydown.esc.prevent="fnCloseDeleteModal" tabindex="0"
                    ref="deleteModal">

                    <div class="delete-modal-box">
                        <div class="delete-modal-title">
                            {{ deleteMode === 'all' ? '모든 알림을 삭제하시겠습니까?' : '알림을 삭제하시겠습니까?' }}
                        </div>

                        <div class="delete-modal-desc">
                            {{ deleteMode === 'all' ? '삭제한 알림은 다시 복구할 수 없습니다.' : '이 알림은 삭제 후 다시 복구할 수 없습니다.' }}
                        </div>

                        <div class="delete-modal-actions">
                            <button type="button" class="delete-confirm-btn" @click="fnConfirmDelete">
                                삭제
                            </button>
                            <button type="button" class="delete-cancel-btn" @click="fnCloseDeleteModal">
                                취소
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                const { createApp } = Vue;
                createApp({
                    data() {
                        return {
                            alarmList: [],
                            currentTab: 'all',

                            toastVisible: false,
                            toastMsg: '',

                            deleteModalOpen: false,
                            deleteAlarmId: null,
                            deleteMode: 'single',
                            underlineStyle: {
                                width: '0px',
                                transform: 'translateX(0px)'
                            }
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
                                    if (res.result === 'success') this.alarmList = res.list;
                                }
                            });
                        },
                        fnGoDetail(id) { location.href = "/alarm/notice-detail.do?alarmId=" + id; },
                        fnRemove(id) {
                            this.deleteMode = 'single';
                            this.deleteAlarmId = id;
                            this.deleteModalOpen = true;

                            this.$nextTick(() => {
                                this.$refs.deleteModal.focus();
                            });
                        },

                        fnRemoveAll() {
                            this.deleteMode = 'all';
                            this.deleteAlarmId = null;
                            this.deleteModalOpen = true;

                            this.$nextTick(() => {
                                this.$refs.deleteModal.focus();
                            });
                        },

                        fnCloseDeleteModal() {
                            this.deleteModalOpen = false;
                            this.deleteAlarmId = null;
                            this.deleteMode = 'single';
                        },

                        fnConfirmDelete() {
                            const url = this.deleteMode === 'all'
                                ? "/alarm/removeAllAlarms.dox"
                                : "/alarm/removeAlarm.dox";

                            const param = this.deleteMode === 'all'
                                ? {}
                                : { alarmId: this.deleteAlarmId };

                            $.ajax({
                                url: url,
                                type: "POST",
                                data: param,
                                success: (res) => {
                                    if (res.result === 'success') {
                                        const msg = this.deleteMode === 'all'
                                            ? "모든 알림이 삭제되었습니다."
                                            : "알림이 삭제되었습니다.";

                                        this.fnCloseDeleteModal();
                                        this.fnGetList();
                                        this.showToast(msg);
                                    } else {
                                        this.fnCloseDeleteModal();
                                        this.showToast("삭제에 실패했습니다.");
                                    }
                                },
                                error: () => {
                                    this.fnCloseDeleteModal();
                                    this.showToast("서버 오류가 발생했습니다.");
                                }
                            });
                        },

                        showToast(msg) {
                            this.toastMsg = msg;
                            this.toastVisible = true;

                            setTimeout(() => {
                                this.toastVisible = false;
                            }, 2000);
                        },
                        fnChangeTab(tab) {
                            this.currentTab = tab;

                            this.$nextTick(() => {
                                const el = tab === 'all' ? this.$refs.tabAll : this.$refs.tabUnread;
                                this.moveUnderline(el);
                            });
                        },

                        moveUnderline(el) {
                            const rect = el.getBoundingClientRect();
                            const parentRect = this.$refs.tabWrap.getBoundingClientRect();

                            this.underlineStyle = {
                                width: rect.width + 'px',
                                transform: 'translateX(' + (rect.left - parentRect.left) + 'px)'
                            };
                        }
                    },
                    mounted() {
                        this.fnGetList();

                        this.$nextTick(() => {
                            const el = this.$refs.tabAll;
                            this.moveUnderline(el);
                        });
                    }
                }).mount('#noticeApp');
            </script>
        </body>

        </html>