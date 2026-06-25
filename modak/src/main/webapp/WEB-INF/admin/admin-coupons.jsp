<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>쿠폰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-coupons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
    <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

    <div id="app" class="admin-main" v-cloak>
        <div class="coupon-page-container">
            <div class="event-header">
                <div class="event-title">🎫 쿠폰 관리 시스템</div>
                <div class="header-buttons">
                    <button class="p-btn-secondary" onclick="location.href='/admin/dashboard.do'">🏠 대시보드</button>
                    <button class="p-btn" @click="fnOpenAdd">+ 신규 쿠폰 발행</button>
                </div>
            </div>

            <div class="ev-filter-bar" style="border-bottom:1px solid var(--border); margin-bottom:20px; gap:20px;">
                <span :class="['tab-item', {active: currentTab === 'master'}]"
                    @click="currentTab = 'master'; fnLoad();" style="cursor:pointer; padding:10px;">쿠폰 마스터 관리</span>
                <span :class="['tab-item', {active: currentTab === 'user'}]"
                    @click="currentTab = 'user'; fnLoadUserCoupons();"
                    style="cursor:pointer; padding:10px;">유저 발급/사용 현황</span>
            </div>

            <!-- 마스터 탭 -->
            <div v-if="currentTab === 'master'">
                <div class="ev-filter-bar">
                    <input type="text" class="ev-input" v-model="keyword" @keyup.enter="fnLoad"
                        placeholder="쿠폰명을 입력하세요..." style="margin-bottom:0; width:300px; padding:8px 16px;">
                    <button class="filter-btn" @click="fnLoad">검색</button>
                </div>
                <div class="camp-table-card">
                    <table class="c-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>쿠폰명</th>
                                <th>할인 혜택</th>
                                <th>상태</th>
                                <th>지급 관리</th>
                                <th>마스터 관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in couponList" :key="item.COUPON_ID" class="c-table-row">
                                <td>{{ item.COUPON_ID }}</td>
                                <td style="text-align:left; font-weight:600; color:#fff;">{{ item.COUPON_NAME }}</td>
                                <td>
                                    <span v-if="item.COUPON_TYPE === 'AMOUNT'" class="benefit-amount">
                                        {{ (item.DISCOUNT_AMT || 0).toLocaleString() }}원
                                    </span>
                                    <span v-else class="benefit-rate">
                                        {{ item.DISCOUNT_RATE || 0 }}%
                                    </span>
                                </td>
                                <td>
                                    <span :class="item.IS_ACTIVE === 'Y' ? 'status-dot active-dot' : 'status-dot inactive-dot'"></span>
                                    <span :style="{color: item.IS_ACTIVE === 'Y' ? '#58d68d' : '#ec7063'}">
                                        {{ item.IS_ACTIVE === 'Y' ? '사용가능' : '정지됨' }}
                                    </span>
                                </td>
                                <td>
                                    <div style="display:flex; gap:5px; justify-content:center;">
                                        <button class="btn-sm btn-sm-orange" @click="fnGiveAll(item.COUPON_ID)">전체발급</button>
                                        <button class="btn-sm btn-sm-blue"   @click="fnOpenGiveUser(item)">개별지급</button>
                                    </div>
                                </td>
                                <td>
                                    <div style="display:flex; gap:8px; justify-content:center;">
                                        <button class="p-btn-secondary" @click="fnToggle(item)">
                                            {{ item.IS_ACTIVE === 'Y' ? '중지' : '해제' }}
                                        </button>
                                        <button class="p-btn-secondary btn-delete-text" @click="fnDelete(item.COUPON_ID)">삭제</button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 유저 탭 -->
            <div v-else>
                <div class="ev-filter-bar">
                    <input type="text" class="ev-input" v-model="userKeyword"
                        @keyup.enter="fnLoadUserCoupons" placeholder="유저 ID 또는 쿠폰명 검색..."
                        style="margin-bottom:0; width:300px; padding:8px 16px;">
                    <button class="filter-btn" @click="fnLoadUserCoupons">조회</button>
                </div>
                <div class="camp-table-card">
                    <table class="c-table">
                        <thead>
                            <tr>
                                <th>유저ID</th>
                                <th>이름</th>
                                <th>쿠폰명</th>
                                <th>발급일</th>
                                <th>사용여부</th>
                                <th>상태변경</th>
                                <th>회수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="uc in userCouponList" :key="uc.USER_COUPON_ID" class="c-table-row">
                                <td>{{ uc.USER_ID }}</td>
                                <td>{{ uc.USER_NAME }}</td>
                                <td>{{ uc.COUPON_NAME }}</td>
                                <td>{{ uc.ISSUED_AT }}</td>
                                <td>
                                    <span class="badge" :class="uc.USED_YN === 'Y' ? 'badge-done' : 'badge-active'">
                                        {{ uc.USED_YN === 'Y' ? '사용완료' : '미사용' }}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn-sm btn-sm-neutral" @click="fnToggleUsed(uc)">
                                        {{ uc.USED_YN === 'Y' ? '미사용으로' : '사용처리' }}
                                    </button>
                                </td>
                                <td>
                                    <button class="p-btn-secondary btn-delete-text"
                                        @click="fnRemoveUserCoupon(uc.USER_COUPON_ID)">회수</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 쿠폰 발행 모달 -->
        <div class="ev-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="ev-modal">
                <div class="modal-header">🎫 신규 쿠폰 발행</div>
                <div class="modal-body">
                    <label class="modal-label">쿠폰 이름</label>
                    <input class="ev-input" v-model="form.couponName" placeholder="예: 오픈기념 5천원 할인">

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px">
                        <div>
                            <label class="modal-label">할인 방식</label>
                            <select class="ev-input" v-model="form.couponType">
                                <option value="AMOUNT">금액 할인(원)</option>
                                <option value="RATE">비율 할인(%)</option>
                            </select>
                        </div>
                        <div>
                            <label class="modal-label">할인 값</label>
                            <input type="number" class="ev-input" v-model="form.discountAmt"
                                v-if="form.couponType === 'AMOUNT'" placeholder="할인 금액(원)">
                            <input type="number" class="ev-input" v-model="form.discountRate"
                                v-if="form.couponType === 'RATE'" placeholder="할인율(%)">
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px">
                        <div>
                            <label class="modal-label">최소 주문금액</label>
                            <input type="number" class="ev-input" v-model="form.minOrderAmt">
                        </div>
                        <div>
                            <label class="modal-label">발급 시작일</label>
                            <input type="date" class="ev-input" v-model="form.startDate">
                        </div>
                    </div>

                    <div>
                        <label class="modal-label">발급 종료일</label>
                        <input type="date" class="ev-input" v-model="form.endDate">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-close-btn" @click="modalOpen=false">취소</button>
                    <button class="p-btn" @click="fnSave" :disabled="isSubmitting">발행하기</button>
                </div>
            </div>
        </div>

        <!-- 개인 지급 모달 -->
        <div class="ev-modal-overlay" :class="{open: userModalOpen}" @click.self="userModalOpen=false">
            <div class="ev-modal">
                <div class="modal-header">👤 개인 쿠폰 지급</div>
                <div class="modal-body">
                    <div class="selected-coupon-banner">
                        선택된 쿠폰: <strong style="color:var(--orange)">{{ selectedCouponName }}</strong>
                    </div>
                    <label class="modal-label">지급할 유저 ID</label>
                    <input class="ev-input" v-model="targetUserId" placeholder="지급할 유저 아이디를 정확히 입력하세요">
                    <p class="modal-hint">* 해당 유저의 보유 쿠폰함으로 즉시 발송됩니다.</p>
                </div>
                <div class="modal-footer">
                    <button class="modal-close-btn" @click="userModalOpen=false">취소</button>
                    <button class="p-btn" @click="fnGiveUser">쿠폰 지급하기</button>
                </div>
            </div>
        </div>

        <!-- 확인 모달 -->
        <transition name="coupon-modal-fade">
            <div v-if="showConfirm" class="coupon-confirm-overlay" @click.self="showConfirm=false">
                <div class="coupon-confirm-box">
                    <div class="coupon-confirm-icon">{{ confirmConfig.icon }}</div>
                    <div class="coupon-confirm-title">{{ confirmConfig.title }}</div>
                    <div class="coupon-confirm-msg" v-html="confirmConfig.msg"></div>
                    <div class="coupon-confirm-btns">
                        <button class="modal-close-btn" @click="showConfirm=false">취소</button>
                        <button class="p-btn" :class="confirmConfig.danger ? 'p-btn-danger' : ''" @click="fnRunConfirm">
                            {{ confirmConfig.confirmText }}
                        </button>
                    </div>
                </div>
            </div>
        </transition>
    </div>

    <!-- 토스트 -->
    <div class="coupon-toast" id="couponToast"></div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    currentTab: 'master',
                    couponList: [], userCouponList: [],
                    keyword: '', userKeyword: '',
                    modalOpen: false, userModalOpen: false, isSubmitting: false,
                    selectedCouponId: '', selectedCouponName: '', targetUserId: '',
                    form: {
                        couponId: '', couponName: '', couponType: 'AMOUNT',
                        discountAmt: 0, discountRate: 0, minOrderAmt: 0,
                        issueTarget: 'ALL', startDate: '', endDate: ''
                    },
                    showConfirm: false,
                    confirmConfig: { title:'', msg:'', icon:'❓', confirmText:'확인', danger: false, onConfirm: null }
                };
            },
            methods: {
                toast(msg, type) {
                    const t = document.getElementById('couponToast');
                    t.textContent = msg;
                    t.className = 'coupon-toast ' + (type || '') + ' show';
                    setTimeout(() => t.classList.remove('show'), 2600);
                },

                fnShowConfirm(config) {
                    this.confirmConfig = Object.assign(
                        { icon:'❓', confirmText:'확인', danger: false, onConfirm: null },
                        config
                    );
                    this.showConfirm = true;
                },

                fnRunConfirm() {
                    this.showConfirm = false;
                    if (typeof this.confirmConfig.onConfirm === 'function') {
                        this.confirmConfig.onConfirm();
                    }
                },

                fnLoad() {
                    $.ajax({
                        url: "/admin/coupon/list.dox", type: "POST", data: { keyword: this.keyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") this.couponList = data.list || [];
                        }
                    });
                },

                fnLoadUserCoupons() {
                    $.ajax({
                        url: "/admin/userCoupon/list.dox", type: "POST", data: { keyword: this.userKeyword },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") this.userCouponList = data.list || [];
                        }
                    });
                },

                fnGiveAll(id) {
                    this.fnShowConfirm({
                        title: '전체 발급',
                        msg: '전체 활동 유저에게<br>쿠폰을 발송하시겠습니까?',
                        icon: '📢',
                        confirmText: '전체 발송',
                        onConfirm: () => {
                            $.ajax({
                                url: "/admin/userCoupon/giveAll.dox", type: "POST", data: { couponId: id },
                                success: () => { this.toast('✅ 전체 발송이 완료되었습니다', 'success'); },
                                error:   () => { this.toast('⚠️ 발송 중 오류가 발생했습니다', 'error'); }
                            });
                        }
                    });
                },

                fnOpenGiveUser(item) {
                    this.selectedCouponId = item.COUPON_ID;
                    this.selectedCouponName = item.COUPON_NAME;
                    this.targetUserId = '';
                    this.userModalOpen = true;
                },

                fnGiveUser() {
                    if (!this.targetUserId.trim()) {
                        this.toast('⚠️ 유저 아이디를 입력하세요', 'error');
                        return;
                    }
                    $.ajax({
                        url: "/admin/userCoupon/give.dox", type: "POST",
                        data: { couponId: this.selectedCouponId, userId: this.targetUserId },
                        success: (res) => {
                            const data = typeof res === "string" ? JSON.parse(res) : res;
                            if (data.result === "success") {
                                this.toast('✅ ' + this.targetUserId + '님에게 쿠폰이 지급되었습니다', 'success');
                                this.userModalOpen = false;
                            } else {
                                this.toast('⚠️ 지급 실패: 유저 아이디를 확인하세요', 'error');
                            }
                        },
                        error: () => { this.toast('⚠️ 서버 오류가 발생했습니다', 'error'); }
                    });
                },

                fnToggleUsed(uc) {
                    const next = uc.USED_YN === 'Y' ? 'N' : 'Y';
                    $.ajax({
                        url: "/admin/userCoupon/updateStatus.dox", type: "POST",
                        data: { userCouponId: uc.USER_COUPON_ID, usedYn: next },
                        success: () => {
                            this.toast('✅ 상태가 변경되었습니다', 'success');
                            this.fnLoadUserCoupons();
                        }
                    });
                },

                fnRemoveUserCoupon(id) {
                    this.fnShowConfirm({
                        title: '쿠폰 회수',
                        msg: '이 쿠폰을 회수하시겠습니까?<br><span style="font-size:12px;color:#ff8080">회수 후 복구가 불가합니다.</span>',
                        icon: '↩️',
                        confirmText: '회수하기',
                        danger: true,
                        onConfirm: () => {
                            $.ajax({
                                url: "/admin/userCoupon/delete.dox", type: "POST", data: { userCouponId: id },
                                success: () => {
                                    this.toast('✅ 쿠폰이 회수되었습니다', 'success');
                                    this.fnLoadUserCoupons();
                                },
                                error: () => { this.toast('⚠️ 서버 오류가 발생했습니다', 'error'); }
                            });
                        }
                    });
                },

                fnSave() {
                    if (!this.form.couponName.trim()) {
                        this.toast('⚠️ 쿠폰 이름을 입력해주세요', 'error');
                        return;
                    }
                    this.isSubmitting = true;
                    $.ajax({
                        url: "/admin/coupon/save.dox", type: "POST", data: this.form,
                        success: () => {
                            this.toast('✅ 쿠폰이 발행되었습니다', 'success');
                            this.modalOpen = false;
                            this.fnLoad();
                        },
                        error:    () => { this.toast('⚠️ 발행 중 오류가 발생했습니다', 'error'); },
                        complete: () => { this.isSubmitting = false; }
                    });
                },

                fnToggle(item) {
                    const next = item.IS_ACTIVE === 'Y' ? 'N' : 'Y';
                    $.ajax({
                        url: "/admin/coupon/status.dox", type: "POST",
                        data: { couponId: item.COUPON_ID, isActive: next },
                        success: () => {
                            this.toast(next === 'Y' ? '✅ 쿠폰이 활성화되었습니다' : '쿠폰이 중지되었습니다',
                                       next === 'Y' ? 'success' : '');
                            this.fnLoad();
                        }
                    });
                },

                fnDelete(id) {
                    this.fnShowConfirm({
                        title: '쿠폰 삭제',
                        msg: '이 쿠폰을 삭제하시겠습니까?<br><span style="font-size:12px;color:#ff8080">삭제 후 복구가 불가합니다.</span>',
                        icon: '🗑️',
                        confirmText: '삭제하기',
                        danger: true,
                        onConfirm: () => {
                            $.ajax({
                                url: "/admin/coupon/delete.dox", type: "POST", data: { couponId: id },
                                success: () => {
                                    this.toast('🗑️ 쿠폰이 삭제되었습니다', 'success');
                                    this.fnLoad();
                                },
                                error: () => { this.toast('⚠️ 서버 오류가 발생했습니다', 'error'); }
                            });
                        }
                    });
                },

                fnOpenAdd() {
                    this.form = {
                        couponId: '', couponName: '', couponType: 'AMOUNT',
                        discountAmt: 0, discountRate: 0, minOrderAmt: 0,
                        issueTarget: 'ALL', startDate: '', endDate: ''
                    };
                    this.modalOpen = true;
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>
