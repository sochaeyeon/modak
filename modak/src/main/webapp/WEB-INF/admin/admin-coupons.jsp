<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쿠폰 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-coupons.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
<div class="cp-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="cp-header">
        <div class="cp-title-wrap">
            <div class="cp-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
            </div>
            <div>
                <div class="cp-page-title">쿠폰 관리</div>
                <div class="cp-page-sub">쿠폰 등록, 발급 및 사용 현황을 관리합니다</div>
            </div>
        </div>
        <div class="cp-header-actions">
            <button class="cp-add-btn" @click="fnOpenAddModal">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                쿠폰 추가
            </button>
            <button class="cp-back-btn" onclick="location.href='/admin/dashboard.do'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="7" height="7" rx="1"/>
                    <rect x="14" y="3" width="7" height="7" rx="1"/>
                    <rect x="3" y="14" width="7" height="7" rx="1"/>
                    <rect x="14" y="14" width="7" height="7" rx="1"/>
                </svg>
                대시보드
            </button>
        </div>
    </div>

    <!-- ── KPI 카드 ── -->
    <div class="cp-kpi-grid">
        <div class="cp-kpi-card" style="--kc:#E8732A;--kcb:rgba(232,115,42,.18)">
            <div class="cp-kpi-glow"></div>
            <div class="cp-kpi-top">
                <span class="cp-kpi-label">전체 쿠폰</span>
                <div class="cp-kpi-icon" style="background:rgba(232,115,42,.15);color:#E8732A">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                        <line x1="7" y1="7" x2="7.01" y2="7"/>
                    </svg>
                </div>
            </div>
            <div class="cp-kpi-val">{{ couponList.length }}<span class="cp-kpi-unit">종</span></div>
            <div class="cp-kpi-sub">등록된 쿠폰</div>
            <div class="cp-kpi-bar"></div>
        </div>
        <div class="cp-kpi-card" style="--kc:#2ECC71;--kcb:rgba(46,204,113,.18)">
            <div class="cp-kpi-glow"></div>
            <div class="cp-kpi-top">
                <span class="cp-kpi-label">활성 쿠폰</span>
                <div class="cp-kpi-icon" style="background:rgba(46,204,113,.15);color:#2ECC71">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </div>
            </div>
            <div class="cp-kpi-val">{{ activeCoupons }}<span class="cp-kpi-unit">종</span></div>
            <div class="cp-kpi-sub">사용 가능</div>
            <div class="cp-kpi-bar"></div>
        </div>
        <div class="cp-kpi-card" style="--kc:#3498DB;--kcb:rgba(52,152,219,.18)">
            <div class="cp-kpi-glow"></div>
            <div class="cp-kpi-top">
                <span class="cp-kpi-label">발급 총계</span>
                <div class="cp-kpi-icon" style="background:rgba(52,152,219,.15);color:#3498DB">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </div>
            </div>
            <div class="cp-kpi-val">{{ userCouponList.length }}<span class="cp-kpi-unit">장</span></div>
            <div class="cp-kpi-sub">회원 보유 쿠폰</div>
            <div class="cp-kpi-bar"></div>
        </div>
        <div class="cp-kpi-card" style="--kc:#F5A623;--kcb:rgba(245,166,35,.18)">
            <div class="cp-kpi-glow"></div>
            <div class="cp-kpi-top">
                <span class="cp-kpi-label">사용된 쿠폰</span>
                <div class="cp-kpi-icon" style="background:rgba(245,166,35,.15);color:#F5A623">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12 6 12 12 16 14"/>
                    </svg>
                </div>
            </div>
            <div class="cp-kpi-val">{{ usedCoupons }}<span class="cp-kpi-unit">장</span></div>
            <div class="cp-kpi-sub">{{ usedPct }}% 사용률</div>
            <div class="cp-kpi-bar"></div>
        </div>
    </div>

    <!-- ── 탭 ── -->
    <div class="cp-tabs">
        <button class="cp-tab" :class="{active: activeTab==='master'}" @click="activeTab='master'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                <line x1="7" y1="7" x2="7.01" y2="7"/>
            </svg>
            쿠폰 목록
            <span class="cp-tab-cnt">{{ couponList.length }}</span>
        </button>
        <button class="cp-tab" :class="{active: activeTab==='user'}" @click="activeTab='user'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
            발급 내역
            <span class="cp-tab-cnt">{{ userCouponList.length }}</span>
        </button>
    </div>

    <!-- ── 쿠폰 목록 탭 ── -->
    <div v-show="activeTab==='master'" class="cp-card">
        <div class="cp-card-header">
            <div class="cp-card-title">
                <div class="cp-title-dot" style="background:#E8732A"></div>
                등록 쿠폰 목록
            </div>
            <button class="cp-give-all-btn" @click="fnGiveAll">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:13px;height:13px">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/>
                </svg>
                전체 회원 발급
            </button>
        </div>
        <div class="cp-table-wrap">
            <table class="cp-table">
                <thead>
                    <tr>
                        <th>쿠폰명</th>
                        <th style="width:90px">타입</th>
                        <th style="width:110px">할인</th>
                        <th style="width:80px">상태</th>
                        <th style="width:140px">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="couponList.length===0">
                        <td colspan="5" class="cp-empty-td">등록된 쿠폰이 없습니다</td>
                    </tr>
                    <tr v-for="c in couponList" :key="c.COUPON_ID" class="cp-row">
                        <td class="cp-name-cell">
                            <div class="cp-coupon-name">{{ c.COUPON_NAME }}</div>
                            <div class="cp-coupon-id">#{{ c.COUPON_ID }}</div>
                        </td>
                        <td>
                            <span class="cp-type-badge" :class="c.COUPON_TYPE==='RATE'?'type-rate':'type-amt'">
                                {{ c.COUPON_TYPE==='RATE' ? '정률' : '정액' }}
                            </span>
                        </td>
                        <td class="cp-discount">
                            <span v-if="c.COUPON_TYPE==='RATE'">{{ c.DISCOUNT_RATE }}%</span>
                            <span v-else>{{ Number(c.DISCOUNT_AMT).toLocaleString() }}원</span>
                        </td>
                        <td>
                            <span class="cp-status-dot" :class="c.IS_ACTIVE==='Y'?'active':'inactive'">
                                {{ c.IS_ACTIVE==='Y' ? '활성' : '비활성' }}
                            </span>
                        </td>
                        <td>
                            <div class="cp-action-row">
                                <button class="cp-btn-toggle"
                                    :class="c.IS_ACTIVE==='Y'?'deactivate':'activate'"
                                    @click="fnToggleStatus(c)">
                                    {{ c.IS_ACTIVE==='Y' ? '비활성화' : '활성화' }}
                                </button>
                                <button class="cp-btn-give" @click="fnOpenGiveModal(c)">발급</button>
                                <button class="cp-btn-del" @click="fnDeleteConfirm(c)">삭제</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ── 발급 내역 탭 ── -->
    <div v-show="activeTab==='user'" class="cp-card">
        <div class="cp-card-header">
            <div class="cp-card-title">
                <div class="cp-title-dot" style="background:#3498DB"></div>
                회원 쿠폰 발급 내역
            </div>
            <span class="cp-card-sub">{{ userCouponList.length }}장</span>
        </div>
        <div class="cp-table-wrap">
            <table class="cp-table">
                <thead>
                    <tr>
                        <th>회원</th>
                        <th>쿠폰명</th>
                        <th style="width:120px">발급일</th>
                        <th style="width:80px">사용 여부</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="userCouponList.length===0">
                        <td colspan="4" class="cp-empty-td">발급 내역이 없습니다</td>
                    </tr>
                    <tr v-for="uc in userCouponList" :key="uc.USER_COUPON_ID" class="cp-row">
                        <td>
                            <div class="cp-coupon-name">{{ uc.USER_NAME }}</div>
                            <div class="cp-coupon-id">{{ uc.USER_ID }}</div>
                        </td>
                        <td class="cp-name-cell">
                            <div class="cp-coupon-name">{{ uc.COUPON_NAME }}</div>
                        </td>
                        <td class="cp-date">{{ fnFormatDate(uc.ISSUED_AT) }}</td>
                        <td>
                            <span class="cp-used-badge" :class="uc.USED_YN==='Y'?'used':'unused'">
                                {{ uc.USED_YN==='Y' ? '사용됨' : '미사용' }}
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div><!-- cp-container -->

<!-- ── 쿠폰 추가 모달 ── -->
<transition name="cp-fade">
<div v-if="showAddModal" class="cp-overlay" @click.self="showAddModal=false">
    <div class="cp-modal">
        <div class="cp-modal-header">
            <div class="cp-modal-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;color:#E8732A">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
                새 쿠폰 추가
            </div>
            <button class="cp-modal-close" @click="showAddModal=false">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>
        <div class="cp-modal-body">
            <div class="cp-field">
                <label class="cp-label">쿠폰명 <span class="cp-req">*</span></label>
                <input class="cp-input" v-model="newCoupon.couponName" placeholder="쿠폰 이름 입력">
            </div>
            <div class="cp-field">
                <label class="cp-label">할인 타입</label>
                <div class="cp-type-btns">
                    <button class="cp-type-sel" :class="{active: newCoupon.couponType==='RATE'}"
                        @click="newCoupon.couponType='RATE'">정률 (%)</button>
                    <button class="cp-type-sel" :class="{active: newCoupon.couponType==='AMT'}"
                        @click="newCoupon.couponType='AMT'">정액 (원)</button>
                </div>
            </div>
            <div class="cp-field" v-if="newCoupon.couponType==='RATE'">
                <label class="cp-label">할인율 (%)</label>
                <input class="cp-input" type="number" v-model="newCoupon.discountRate" min="1" max="100" placeholder="예: 10">
            </div>
            <div class="cp-field" v-if="newCoupon.couponType==='AMT'">
                <label class="cp-label">할인금액 (원)</label>
                <input class="cp-input" type="number" v-model="newCoupon.discountAmt" min="0" placeholder="예: 5000">
            </div>
        </div>
        <div class="cp-modal-footer">
            <button class="cp-btn-cancel" @click="showAddModal=false">취소</button>
            <button class="cp-btn-primary" @click="fnAddCoupon">등록하기</button>
        </div>
    </div>
</div>
</transition>

<!-- ── 개별 발급 모달 ── -->
<transition name="cp-fade">
<div v-if="showGiveModal" class="cp-overlay" @click.self="showGiveModal=false">
    <div class="cp-modal">
        <div class="cp-modal-header">
            <div class="cp-modal-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;color:#E8732A">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/>
                </svg>
                쿠폰 발급
            </div>
            <button class="cp-modal-close" @click="showGiveModal=false">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>
        <div class="cp-modal-body">
            <div class="cp-give-coupon-info" v-if="giveCoupon">
                <span class="cp-type-badge" :class="giveCoupon.COUPON_TYPE==='RATE'?'type-rate':'type-amt'">
                    {{ giveCoupon.COUPON_TYPE==='RATE' ? '정률' : '정액' }}
                </span>
                <span class="cp-give-coupon-name">{{ giveCoupon.COUPON_NAME }}</span>
                <span class="cp-discount">
                    {{ giveCoupon.COUPON_TYPE==='RATE' ? giveCoupon.DISCOUNT_RATE+'%' : Number(giveCoupon.DISCOUNT_AMT).toLocaleString()+'원' }}
                </span>
            </div>
            <div class="cp-field">
                <label class="cp-label">발급 대상 회원 ID <span class="cp-req">*</span></label>
                <input class="cp-input" v-model="giveUserId" placeholder="회원 아이디 입력" @keyup.enter="fnGiveUser">
            </div>
        </div>
        <div class="cp-modal-footer">
            <button class="cp-btn-cancel" @click="showGiveModal=false">취소</button>
            <button class="cp-btn-primary" @click="fnGiveUser">발급하기</button>
        </div>
    </div>
</div>
</transition>

<!-- ── 삭제 확인 모달 ── -->
<transition name="cp-fade">
<div v-if="showConfirm" class="cp-overlay" @click.self="showConfirm=false">
    <div class="cp-confirm-box">
        <div class="cp-confirm-icon">🗑️</div>
        <div class="cp-confirm-title">쿠폰 삭제</div>
        <div class="cp-confirm-msg" v-html="confirmMsg"></div>
        <div class="cp-confirm-btns">
            <button class="cp-btn-cancel" @click="showConfirm=false">취소</button>
            <button class="cp-btn-danger" @click="fnDoConfirm">{{ confirmBtnTxt }}</button>
        </div>
    </div>
</div>
</transition>

<!-- ── 토스트 ── -->
<div class="cp-toast-wrap">
    <transition-group name="cp-toast">
        <div v-for="t in toasts" :key="t.id" class="cp-toast" :class="t.type">{{ t.msg }}</div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            activeTab: 'master',
            couponList: [],
            userCouponList: [],
            showAddModal: false,
            showGiveModal: false,
            showConfirm: false,
            confirmMsg: '',
            confirmBtnTxt: '확인',
            confirmAction: null,
            newCoupon: { couponName:'', couponType:'RATE', discountRate:'', discountAmt:'' },
            giveCoupon: null,
            giveUserId: '',
            toasts: []
        };
    },
    computed: {
        activeCoupons() { return this.couponList.filter(c => c.IS_ACTIVE === 'Y').length; },
        usedCoupons()   { return this.userCouponList.filter(u => u.USED_YN === 'Y').length; },
        usedPct() {
            if (!this.userCouponList.length) return 0;
            return Math.round(this.usedCoupons / this.userCouponList.length * 100);
        }
    },
    methods: {
        toast(msg, type) {
            const id = Date.now() + Math.random();
            this.toasts.push({ id, msg, type: type || 'success' });
            setTimeout(() => { this.toasts = this.toasts.filter(t => t.id !== id); }, 2800);
        },
        confirm(msg, btnTxt, action) {
            this.confirmMsg = msg;
            this.confirmBtnTxt = btnTxt || '확인';
            this.confirmAction = action;
            this.showConfirm = true;
        },
        fnDoConfirm() {
            this.showConfirm = false;
            if (typeof this.confirmAction === 'function') this.confirmAction();
        },
        fnLoad() {
            $.ajax({
                url: '/admin/coupon/list.dox', type: 'POST',
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') this.couponList = data.list || [];
                }
            });
            $.ajax({
                url: '/admin/userCoupon/list.dox', type: 'POST',
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') this.userCouponList = data.list || [];
                }
            });
        },
        fnOpenAddModal() {
            this.newCoupon = { couponName:'', couponType:'RATE', discountRate:'', discountAmt:'' };
            this.showAddModal = true;
        },
        fnAddCoupon() {
            if (!this.newCoupon.couponName.trim()) { this.toast('쿠폰명을 입력해주세요', 'error'); return; }
            $.ajax({
                url: '/admin/coupon/add.dox', type: 'POST',
                data: this.newCoupon,
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.toast('쿠폰이 등록되었습니다', 'success');
                        this.showAddModal = false;
                        this.fnLoad();
                    } else {
                        this.toast('등록 실패: ' + (data.message || '오류'), 'error');
                    }
                },
                error: () => { this.toast('서버 오류가 발생했습니다', 'error'); }
            });
        },
        fnToggleStatus(c) {
            const next = c.IS_ACTIVE === 'Y' ? 'N' : 'Y';
            const label = next === 'Y' ? '활성화' : '비활성화';
            this.confirm(
                `<b style="color:#fff">${c.COUPON_NAME}</b> 쿠폰을<br>${label}하시겠습니까?`,
                label,
                () => {
                    $.ajax({
                        url: '/admin/coupon/status.dox', type: 'POST',
                        data: { couponId: c.COUPON_ID, isActive: next },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                this.toast(`쿠폰이 ${label}되었습니다`, 'success');
                                this.fnLoad();
                            } else {
                                this.toast('상태 변경 실패', 'error');
                            }
                        }
                    });
                }
            );
        },
        fnOpenGiveModal(c) { this.giveCoupon = c; this.giveUserId = ''; this.showGiveModal = true; },
        fnGiveUser() {
            if (!this.giveUserId.trim()) { this.toast('회원 아이디를 입력해주세요', 'error'); return; }
            $.ajax({
                url: '/admin/userCoupon/give.dox', type: 'POST',
                data: { couponId: this.giveCoupon.COUPON_ID, userId: this.giveUserId },
                success: (res) => {
                    const data = typeof res === 'string' ? JSON.parse(res) : res;
                    if (data.result === 'success') {
                        this.toast(this.giveUserId + ' 에게 쿠폰 발급 완료', 'success');
                        this.showGiveModal = false;
                        this.fnLoad();
                    } else {
                        this.toast('발급 실패: ' + (data.message || '오류'), 'error');
                    }
                },
                error: () => { this.toast('서버 오류가 발생했습니다', 'error'); }
            });
        },
        fnGiveAll() {
            this.confirm(
                '모든 활성 회원에게<br>쿠폰을 일괄 발급하시겠습니까?',
                '전체 발급',
                () => {
                    $.ajax({
                        url: '/admin/userCoupon/giveAll.dox', type: 'POST',
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                this.toast('전체 회원에게 쿠폰이 발급되었습니다', 'success');
                                this.fnLoad();
                            } else {
                                this.toast('일괄 발급 실패', 'error');
                            }
                        }
                    });
                }
            );
        },
        fnDeleteConfirm(c) {
            this.confirm(
                `<b style="color:#fff">${c.COUPON_NAME}</b> 쿠폰을<br>삭제하시겠습니까?<br><span style="font-size:12px;color:#ff8080">삭제 후 복구할 수 없습니다.</span>`,
                '삭제하기',
                () => {
                    $.ajax({
                        url: '/admin/coupon/delete.dox', type: 'POST',
                        data: { couponId: c.COUPON_ID },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                this.toast('쿠폰이 삭제되었습니다', 'success');
                                this.fnLoad();
                            } else {
                                this.toast('삭제 실패: ' + (data.message || '오류'), 'error');
                            }
                        }
                    });
                }
            );
        },
        fnFormatDate(dt) { return dt ? String(dt).slice(0, 10) : '-'; }
    },
    mounted() { this.fnLoad(); }
}).mount('#app');
</script>
</body>
</html>
