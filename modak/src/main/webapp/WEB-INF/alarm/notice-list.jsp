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
                    <h2 class="alarm-title-main">
                        <i class="fa-regular fa-bell"></i> 활동 알림
                    </h2>
                    <button v-if="alarmList.length > 0" @click="fnRemoveAll" class="all-remove-btn">전체 삭제</button>
                </div>

                <!-- 탭 -->
                <div class="alarm-tabs" ref="tabWrap">
                    <button ref="tabAll" @click="fnChangeTab('all')" :class="{ active: currentTab === 'all' }"
                        class="tab-btn">
                        전체 <span class="count-badge">{{ alarmList.length }}</span>
                    </button>
                    <button ref="tabUnread" @click="fnChangeTab('unread')" :class="{ active: currentTab === 'unread' }"
                        class="tab-btn">
                        안 읽음 <span class="count-badge unread-bg">{{ unreadCount }}</span>
                    </button>
                    <div class="tab-underline" :style="underlineStyle"></div>
                </div>

                <!-- 알림 목록 -->
                <div class="alarm-list-wrap">
                    <div v-for="item in filteredList" :key="item.ALARM_ID" class="alarm-item"
                        :class="{ unread: item.IS_READ === 'N', read: item.IS_READ === 'Y' }" @click="fnGoDetail(item)">

                        <!-- 아이콘 -->
                        <div class="alarm-icon" :class="fnIconBg(item.TYPE)">
                            <i class="fa-solid fa-comment" v-if="item.TYPE === 'BOARD_COMMENT'"></i>
                            <i class="fa-solid fa-reply" v-else-if="item.TYPE === 'BOARD_REPLY'"></i>
                            <i class="fa-solid fa-heart" v-else-if="item.TYPE === 'BOARD_LIKE'"></i>
                            <i class="fa-regular fa-heart" v-else-if="item.TYPE === 'COMMENT_LIKE'"></i>
                            <i class="fa-solid fa-truck" v-else-if="item.TYPE === 'DELIVERY'"></i>
                            <i class="fa-solid fa-gift" v-else-if="item.TYPE === 'EVENT'"></i>
                            <i class="fa-solid fa-bullhorn" v-else-if="item.TYPE === 'NOTICE'"></i>
                            <i class="fa-solid fa-bullhorn" v-else-if="item.TYPE === 'MARKETING'"></i>
                            <!-- ★ 채팅 관련 아이콘 -->
                            <i class="fa-solid fa-comment-dots" v-else-if="item.TYPE === 'CHAT_REQUEST'"></i>
                            <i class="fa-solid fa-check-circle" v-else-if="item.TYPE === 'CHAT_ACCEPTED'"></i>
                            <i class="fa-solid fa-times-circle" v-else-if="item.TYPE === 'CHAT_REJECTED'"></i>
                            <i class="fa-solid fa-bullhorn" v-else></i>
                        </div>

                        <div class="alarm-info">
                            <div class="alarm-subject">
                                <span v-if="item.IS_READ === 'N'" class="unread-dot"></span>
                                {{ item.TITLE }}
                            </div>
                            <div class="alarm-text">{{ item.CONTENT }}</div>
                            <div class="alarm-time">
                                <i class="fa-regular fa-clock"></i> {{ fnFormatTime(item.CREATED_AT) }}
                            </div>

                            <div class="chat-respond-wrap" v-if="item.TYPE === 'CHAT_REQUEST' && !item.respondDone"
                                @click.stop>
                                <button class="btn-respond accept" :disabled="item.responding"
                                    @click="fnRespond(item, 'ACCEPT')">
                                    <i class="fa-solid fa-check"></i>
                                    {{ item.responding ? '처리 중…' : '수락' }}
                                </button>
                                <button class="btn-respond reject" :disabled="item.responding"
                                    @click="fnRespond(item, 'REJECT')">
                                    <i class="fa-solid fa-xmark"></i>
                                    거절
                                </button>
                            </div>

                            <!-- ★ 처리 완료 결과 -->
                            <div class="chat-respond-result" v-if="item.TYPE === 'CHAT_REQUEST' && item.respondDone"
                                @click.stop>
                                <span class="result-chip accepted" v-if="item.respondAction === 'ACCEPT'">
                                    <i class="fa-solid fa-circle-check"></i> 수락했어요
                                </span>
                                <a class="btn-go-chat" v-if="item.respondAction === 'ACCEPT' && item.acceptedRoomId"
                                    :href="'/chat-room/room.do?roomId=' + item.acceptedRoomId" @click.stop>
                                    <i class="fa-solid fa-comments"></i> 채팅방 이동
                                </a>
                                <span class="result-chip rejected" v-if="item.respondAction === 'REJECT'">
                                    <i class="fa-solid fa-circle-xmark"></i> 거절했어요
                                </span>
                            </div>
                        </div>

                        <button class="remove-btn" @click.stop="fnRemove(item.ALARM_ID)">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                </div>

                <!-- 빈 상태 -->
                <div v-if="filteredList.length === 0" class="no-alarm">
                    <p class="no-alarm-text">아직 새로운 소식이 없다닥!</p>
                </div>

                <!-- 토스트 -->
                <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>

                <!-- 삭제 확인 모달 -->
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
                            <button type="button" class="delete-confirm-btn" @click="fnConfirmDelete">삭제</button>
                            <button type="button" class="delete-cancel-btn" @click="fnCloseDeleteModal">취소</button>
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
                                width: '0px', transform: 'translateX(0px)',
                            }
                        };
                    },

                    computed: {
                        unreadCount() { return this.alarmList.filter(i => i.IS_READ === 'N').length; },
                        filteredList() {
                            return this.currentTab === 'unread'
                                ? this.alarmList.filter(i => i.IS_READ === 'N')
                                : this.alarmList;
                        }
                    },

                    methods: {
                        // ── 목록 로드 ─────────────────────────────────
                        fnGetList() {
                            $.ajax({
                                url: '/alarm/getAlarmList.dox',
                                type: 'POST',
                                dataType: 'json',
                                success: (res) => {
                                    if (res.result === 'success') {

                                        this.alarmList = (res.list || []).map(a => ({
                                            ...a,
                                            responding: false,

                                            // DB에서 가져온 신청 상태 기준
                                            respondDone:
                                                a.TYPE === 'CHAT_REQUEST' &&
                                                (a.REQUEST_STATUS === 'ACCEPTED' || a.REQUEST_STATUS === 'REJECTED'),

                                            respondAction:
                                                a.REQUEST_STATUS === 'ACCEPTED'
                                                    ? 'ACCEPT'
                                                    : a.REQUEST_STATUS === 'REJECTED'
                                                        ? 'REJECT'
                                                        : null,

                                            // 수락된 채팅방 번호
                                            acceptedRoomId: a.CHAT_ROOM_ID || a.ROOM_ID || null
                                        }));
                                    }
                                }
                            });
                        },

                        // ── 알림 읽음 처리 (서버 반영용 공통 함수) ──────
                        fnMarkRead(item) {
                            if (item.IS_READ === 'Y') return; // 이미 읽음이면 호출 안 함
                            item.IS_READ = 'Y';
                            $.ajax({
                                url: '/alarm/read.dox',
                                type: 'POST',
                                data: { alarmId: item.ALARM_ID }
                                // 실패해도 화면 상태는 유지 (재시도는 다음 클릭에서)
                            });
                        },

                        // ── 알림 클릭 → 읽음 처리 + (이동할 곳이 있을 때만) 이동 ──
                        fnGoDetail(item) {
                            if (item.TYPE === 'CHAT_REQUEST') return;

                            // 1) 읽음 처리는 항상 먼저 수행 (페이지 이동 여부와 무관)
                            this.fnMarkRead(item);

                            const boardTypes = ['BOARD_COMMENT', 'BOARD_REPLY', 'BOARD_LIKE', 'COMMENT_LIKE'];
                            const orderTypes = [
                                'ORDER',
                                'PAYMENT',
                                'ORDER_COMPLETE',
                                'PAYMENT_COMPLETE',
                                'ORDER_PAID',
                                'PAYMENT_SUCCESS'
                            ];

                            // 2) 이동할 목적지가 명확히 있는 경우만 location.href 이동
                            if (boardTypes.includes(item.TYPE) && item.LINK_ID) {
                                location.href = '/board/detail.do?boardId=' + item.LINK_ID;

                            } else if (orderTypes.includes(item.TYPE) || item.TITLE.includes('결제') || item.TITLE.includes('주문')) {
                                if (item.LINK_ID) {
                                    location.href = '/order/detail.do?orderId=' + item.LINK_ID;
                                } else {
                                    location.href = '/order/history.do';
                                }

                            } else if (item.TYPE === 'CHAT_ACCEPTED' && item.LINK_ID) {
                                location.href = '/chat-room/room.do?roomId=' + item.LINK_ID;

                            } else if (
                                item.TITLE.includes('쿠폰') ||
                                item.CONTENT.includes('쿠폰')
                            ) {
                                location.href = '/user/mypage.do#coupon';

                            } else if (item.TYPE === 'EVENT') {
                                location.href = '/user/mypage.do#coupon';

                            }
                            // 3) 그 외(NOTICE, MARKETING 등 이동할 곳이 정해지지 않은 알림)는
                            //    읽음 처리만 하고 페이지 이동(새로고침)을 발생시키지 않음.
                            //    ※ 서버(AlarmController#noticeDetail)도 DELIVERY/EVENT 외에는
                            //      목록으로 되돌리기만 하므로, 여기서 이동시키지 않는 것이 맞음.
                        },

                        // ── ★ 채팅 신청 수락/거절 ─────────────────────
                        fnRespond(item, action) {
                            item.responding = true;

                            $.ajax({
                                url: '/chat-room/respond.dox', type: 'POST',
                                data: {
                                    requestId: item.LINK_ID,
                                    action: action
                                },
                                dataType: 'json',
                                success: (res) => {
                                    item.responding = false;

                                    if (res.result === 'success' && action === 'ACCEPT') {
                                        item.respondDone = true;
                                        item.respondAction = 'ACCEPT';
                                        item.acceptedRoomId = res.roomId;
                                        item.IS_READ = 'Y';
                                        this.showToast('✅ 대화를 수락했어요!');

                                    } else if (res.result === 'rejected') {
                                        item.respondDone = true;
                                        item.respondAction = 'REJECT';
                                        item.IS_READ = 'Y';
                                        this.showToast('대화 신청을 거절했어요.');

                                    } else {
                                        this.showToast('⚠️ ' + (res.message || '처리에 실패했어요.'));
                                    }
                                },
                                error: () => {
                                    item.responding = false;
                                    this.showToast('⚠️ 네트워크 오류가 발생했어요.');
                                }
                            });
                        },

                        // ── 아이콘 배경 클래스 ────────────────────────
                        fnIconBg(type) {
                            return {
                                'CHAT_REQUEST': 'icon-chat',
                                'CHAT_ACCEPTED': 'icon-accepted',
                                'CHAT_REJECTED': 'icon-rejected',
                                'BOARD_LIKE': 'icon-like',
                                'COMMENT_LIKE': 'icon-like',
                                'NOTICE': 'icon-notice',
                                'EVENT': 'icon-event',
                                'DELIVERY': 'icon-delivery',
                                'MARKETING': 'icon-marketing',
                            }[type] || '';
                        },

                        fnFormatTime(createdAt) {
                            if (!createdAt) { console.log('빈값 -> -'); return '-'; }
                            let dateStr = createdAt;
                            if (typeof dateStr === 'string' && dateStr.includes('T') && !dateStr.includes('+') && !dateStr.endsWith('Z')) {
                                dateStr += '+09:00';
                            }
                            const now = new Date();
                            const created = new Date(dateStr);
                            if (isNaN(created.getTime())) { console.log('파싱실패 -> -', createdAt); return '-'; }

                            // 12시간제 + 오전/오후 변환 헬퍼
                            const fnToAmPmHourMin = (d) => {
                                let h = d.getHours();
                                const mi = String(d.getMinutes()).padStart(2, '0');
                                const ampm = h < 12 ? '오전' : '오후';
                                h = h % 12;
                                if (h === 0) h = 12;
                                return ampm + ' ' + h + '시 ' + mi + '분';
                            };

                            const diffMs = now - created;
                            const diffMin = Math.floor(diffMs / 60000);
                            const diffHour = Math.floor(diffMin / 60);
                            const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                            const startOfCreated = new Date(created.getFullYear(), created.getMonth(), created.getDate());
                            const diffCalendarDay = Math.floor((startOfToday - startOfCreated) / 86400000);

                            let result;
                            if (diffMin < 1) result = '방금 전';
                            else if (diffMin < 60) result = diffMin + '분 전';
                            else if (diffHour < 24 && diffCalendarDay === 0) result = diffHour + '시간 전';
                            else if (diffCalendarDay === 1) result = '어제';
                            else if (diffCalendarDay === 2) result = '그저께';
                            else if (diffCalendarDay <= 3) {
                                result = diffCalendarDay + '일 전 ' + fnToAmPmHourMin(created);
                            } else {
                                const mm = String(created.getMonth() + 1);
                                const dd = String(created.getDate());
                                result = mm + '월 ' + dd + '일 ' + fnToAmPmHourMin(created);
                            }
                            console.log('createdAt:', createdAt, '-> result:', result, 'diffCalendarDay:', diffCalendarDay);
                            return result;
                        },

                        // ── 삭제 ─────────────────────────────────────
                        fnRemove(id) {
                            this.deleteMode = 'single'; this.deleteAlarmId = id;
                            this.deleteModalOpen = true;
                            this.$nextTick(() => { this.$refs.deleteModal.focus(); });
                        },
                        fnRemoveAll() {
                            this.deleteMode = 'all'; this.deleteAlarmId = null;
                            this.deleteModalOpen = true;
                            this.$nextTick(() => { this.$refs.deleteModal.focus(); });
                        },
                        fnCloseDeleteModal() { this.deleteModalOpen = false; this.deleteAlarmId = null; this.deleteMode = 'single'; },
                        fnConfirmDelete() {
                            const url = this.deleteMode === 'all' ? '/alarm/removeAllAlarms.dox' : '/alarm/removeAlarm.dox';
                            const param = this.deleteMode === 'all' ? {} : { alarmId: this.deleteAlarmId };
                            $.ajax({
                                url, type: 'POST', data: param,
                                success: (res) => {
                                    this.fnCloseDeleteModal();
                                    if (res.result === 'success') {
                                        this.fnGetList();
                                        this.showToast(this.deleteMode === 'all' ? '모든 알림이 삭제되었습니다.' : '알림이 삭제되었습니다.');
                                    } else {
                                        this.showToast('삭제에 실패했습니다.');
                                    }
                                },
                                error: () => { this.fnCloseDeleteModal(); this.showToast('서버 오류가 발생했습니다.'); }
                            });
                        },

                        // ── 탭 ───────────────────────────────────────
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
                        },

                        showToast(msg) {
                            this.toastMsg = msg; this.toastVisible = true;
                            setTimeout(() => { this.toastVisible = false; }, 2500);
                        }
                    },

                    mounted() {
                        this.fnGetList();
                        this.$nextTick(() => { this.moveUnderline(this.$refs.tabAll); });
                    }
                }).mount('#noticeApp');
            </script>
        </body>

        </html>