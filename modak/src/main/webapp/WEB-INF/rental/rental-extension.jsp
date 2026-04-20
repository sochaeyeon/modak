<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대여 연장 - 모닥모닥</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Noto+Sans+KR:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg:      #faf6f0;
            --white:   #fffdf8;
            --border:  rgba(200,165,130,.45);
            --border2: rgba(200,165,130,.22);
            --orange:  #E8732A;
            --orange2: #C4621E;
            --brown:   #2C1E0F;
            --brown2:  #5C4230;
            --brown3:  #8B6B4A;
            --brown4:  #B89A7A;
            --cream2:  #EDE5D4;
            --cream3:  #E2D8C3;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex; flex-direction: column;
            color: var(--brown);
        }
        #app { flex: 1; }

        .ext-page {
            max-width: 960px; margin: 0 auto;
            padding: 40px 24px 72px;
            display: flex; flex-direction: column; gap: 24px;
            animation: fadeUp .5s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── 헤더 ── */
        .page-eyebrow { font-size: 11px; letter-spacing: 2px; color: var(--brown4); margin-bottom: 6px; }
        .page-title   { font-family: 'Nanum Myeongjo', serif; font-size: 26px; font-weight: 800; color: var(--brown); margin-bottom: 4px; }
        .page-desc    { font-size: 13px; color: var(--brown3); font-weight: 300; line-height: 1.7; }

        /* ── 섹션 카드 ── */
        .section-card { background: var(--white); border: 1px solid var(--border); border-radius: 20px; overflow: hidden; }
        .section-head {
            padding: 18px 24px 16px; border-bottom: 1px solid var(--border2);
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-head h3 { font-family: 'Nanum Myeongjo', serif; font-size: 16px; font-weight: 700; color: var(--brown); }
        .section-body { padding: 24px; }

        /* ── 대여 목록 (회원) ── */
        .rental-list { display: flex; flex-direction: column; gap: 12px; }
        .rental-card {
            border: 1px solid var(--border2); border-radius: 16px;
            background: var(--bg); padding: 18px 20px;
            display: flex; align-items: center; gap: 16px;
            cursor: pointer; transition: all .2s;
        }
        .rental-card:hover  { border-color: var(--orange); box-shadow: 0 4px 16px rgba(232,115,42,.1); }
        .rental-card.active { border-color: var(--orange); background: rgba(232,115,42,.04); }
        .rental-icon {
            width: 52px; height: 52px; border-radius: 12px;
            background: var(--cream2); border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; flex-shrink: 0;
        }
        .rental-info { flex: 1; min-width: 0; }
        .rental-name {
            font-size: 14px; font-weight: 600; color: var(--brown);
            margin-bottom: 4px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
        }
        .rental-dates { font-size: 12px; color: var(--brown4); margin-bottom: 4px; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: 500; }
        .st-RESERVED  { background: rgba(33,150,243,.12); color: #1565c0; }
        .st-RENTING   { background: rgba(232,115,42,.12); color: #c94f1e; }
        .st-RETURNED  { background: rgba(76,175,80,.12);  color: #2e7d32; }
        .st-CANCELLED { background: rgba(244,67,54,.12);  color: #c62828; }
        .rental-arrow { font-size: 18px; color: var(--brown4); flex-shrink: 0; transition: color .2s; }
        .rental-card.active .rental-arrow,
        .rental-card:hover  .rental-arrow { color: var(--orange); }

        /* ── 연장 패널 ── */
        .ext-panel { background: var(--white); border: 1px solid var(--border); border-radius: 20px; overflow: hidden; }
        .ext-panel-head {
            padding: 18px 24px; border-bottom: 1px solid var(--border2);
            display: flex; align-items: center; justify-content: space-between;
            background: rgba(232,115,42,.04);
        }
        .ext-panel-title    { font-family: 'Nanum Myeongjo', serif; font-size: 16px; font-weight: 700; color: var(--brown); }
        .ext-panel-subtitle { font-size: 12px; color: var(--brown4); margin-top: 2px; }
        .btn-close-panel {
            width: 32px; height: 32px; border-radius: 50%;
            background: var(--cream2); border: none; cursor: pointer;
            font-size: 16px; color: var(--brown3); transition: all .2s;
            display: flex; align-items: center; justify-content: center;
        }
        .btn-close-panel:hover { background: var(--cream3); color: var(--brown); }

        /* ── 연장 신청 폼 ── */
        .ext-form { padding: 24px; border-bottom: 1px solid var(--border2); }
        .ext-form-row { display: flex; align-items: flex-end; gap: 14px; flex-wrap: wrap; }
        .form-group   { display: flex; flex-direction: column; gap: 6px; }
        .form-label   { font-size: 12px; font-weight: 600; color: var(--brown2); }
        .form-input {
            padding: 11px 14px; border: 1.5px solid var(--border);
            border-radius: 10px; background: var(--white);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 14px; color: var(--brown); outline: none;
            transition: border-color .2s, box-shadow .2s; width: 120px;
        }
        .form-input:focus { border-color: var(--orange); box-shadow: 0 0 0 3px rgba(232,115,42,.1); }

        .price-preview       { display: flex; flex-direction: column; gap: 3px; }
        .price-preview-label { font-size: 11px; color: var(--brown4); }
        .price-preview-val   { font-family: 'Nanum Myeongjo', serif; font-size: 18px; font-weight: 700; color: var(--orange); }

        .btn-apply {
            padding: 11px 28px; background: var(--orange); color: #fff;
            border: none; border-radius: 10px; font-size: 14px; font-weight: 600;
            font-family: 'Noto Sans KR', sans-serif; cursor: pointer;
            transition: background .2s, transform .15s;
            box-shadow: 0 4px 14px rgba(232,115,42,.3); white-space: nowrap;
        }
        .btn-apply:hover    { background: var(--orange2); transform: translateY(-1px); }
        .btn-apply:disabled { opacity: .6; cursor: not-allowed; transform: none; }

        .ext-notice { margin-top: 12px; font-size: 11.5px; color: var(--brown4); line-height: 1.8; font-weight: 300; }

        /* ── 연장 내역 ── */
        .ext-history       { padding: 20px 24px; }
        .ext-history-title { font-size: 13px; font-weight: 600; color: var(--brown2); margin-bottom: 14px; }
        .ext-items { display: flex; flex-direction: column; gap: 10px; }
        .ext-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 16px; background: var(--bg);
            border: 1px solid var(--border2); border-radius: 12px;
        }
        .ext-item-icon {
            width: 36px; height: 36px; border-radius: 50%;
            background: rgba(76,175,80,.1); border: 1px solid rgba(76,175,80,.25);
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; flex-shrink: 0;
        }
        .ext-item-body  { flex: 1; }
        .ext-item-days  { font-size: 14px; font-weight: 600; color: var(--brown); margin-bottom: 2px; }
        .ext-item-date  { font-size: 11px; color: var(--brown4); }
        .ext-item-price { font-family: 'Nanum Myeongjo', serif; font-size: 15px; font-weight: 700; color: var(--brown); flex-shrink: 0; }
        .btn-ext-cancel {
            padding: 6px 14px; background: transparent;
            border: 1.5px solid rgba(201,79,30,.3); border-radius: 8px;
            color: var(--orange2); font-size: 12px; font-weight: 500;
            font-family: 'Noto Sans KR', sans-serif; cursor: pointer;
            transition: all .2s; flex-shrink: 0;
        }
        .btn-ext-cancel:hover { background: rgba(201,79,30,.06); border-color: var(--orange); }

        .ext-empty { text-align: center; padding: 24px 16px; color: var(--brown4); font-size: 13px; font-weight: 300; }

        /* ── 상태 박스 ── */
        .state-box {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            gap: 14px; padding: 60px 20px; text-align: center;
        }
        .spinner {
            width: 36px; height: 36px;
            border: 3px solid var(--cream3); border-top-color: var(--orange);
            border-radius: 50%; animation: spin .8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .state-box p { font-size: 13px; color: var(--brown3); line-height: 1.8; }

        /* ── 비회원 안내 카드 ── */
        .guest-info-card {
            background: var(--white); border: 1px solid var(--border);
            border-radius: 20px; padding: 32px; text-align: center;
        }
        .guest-info-card p { font-size: 14px; color: var(--brown3); line-height: 1.8; margin-bottom: 20px; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; color: var(--brown3); text-decoration: none;
            padding: 8px 16px; border: 1.5px solid var(--border);
            border-radius: 10px; background: var(--white); cursor: pointer; transition: all .2s;
        }
        .btn-back:hover { border-color: var(--brown4); color: var(--brown); }

        /* ── 토스트 ── */
        .toast {
            position: fixed; bottom: 80px; left: 50%;
            transform: translateX(-50%) translateY(60px);
            background: var(--brown); color: var(--white);
            padding: 12px 24px; border-radius: 50px;
            font-size: 13px; white-space: nowrap;
            box-shadow: 0 4px 20px rgba(0,0,0,.2);
            z-index: 700; opacity: 0; transition: all .3s;
        }
        .toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }

        /* ── 반응형 ── */
        @media (max-width: 640px) {
            .ext-page     { padding: 24px 16px 56px; }
            .ext-form-row { flex-direction: column; align-items: stretch; }
            .form-input   { width: 100%; }
            .btn-apply    { width: 100%; }
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app">
    <div class="ext-page">

        <!-- 페이지 헤더 -->
        <div>
            <p class="page-eyebrow">RENTAL EXTENSION</p>
            <h1 class="page-title">대여 연장 신청</h1>
            <p class="page-desc" v-if="isGuest">비회원 대여 연장 페이지입니다. 조회된 대여 건의 연장을 신청하실 수 있습니다.</p>
            <p class="page-desc" v-else>대여 중인 상품의 반납일을 연장할 수 있습니다. 연장할 대여 건을 선택해주세요.</p>
        </div>

        <!-- ══ 회원: 대여 목록 ══ -->
        <div class="section-card" v-if="!isGuest">
            <div class="section-head">
                <h3>내 대여 목록</h3>
                <span style="font-size:12px;color:var(--brown4)">{{ rentalList.length }}건</span>
            </div>
            <div class="section-body">
                <div class="state-box" v-if="isLoading">
                    <div class="spinner"></div>
                    <p>대여 목록을 불러오는 중입니다...</p>
                </div>
                <div class="state-box" v-else-if="rentalList.length === 0">
                    <div style="font-size:40px">📦</div>
                    <p>대여 내역이 없습니다.</p>
                </div>
                <div class="rental-list" v-else>
                    <div v-for="rental in rentalList" :key="rental.rentalId"
                         class="rental-card"
                         :class="{ active: selectedRental && selectedRental.rentalId === rental.rentalId }"
                         @click="fnSelectRental(rental)">
                        <div class="rental-icon">⛺</div>
                        <div class="rental-info">
                            <p class="rental-name">{{ rental.productName || '상품명 없음' }}</p>
                            <p class="rental-dates">{{ rental.startDate || '-' }} ~ {{ rental.returnDate || '-' }}</p>
                            <span class="status-badge" :class="'st-' + rental.rentalStatus">
                                {{ fnStatusText(rental.rentalStatus) }}
                            </span>
                        </div>
                        <span class="rental-arrow">›</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══ 연장 패널 (회원 선택 시 / 비회원 자동 표시) ══ -->
        <div class="ext-panel" v-if="selectedRental">
            <div class="ext-panel-head">
                <div>
                    <p class="ext-panel-title">{{ selectedRental.productName || '상품명 없음' }}</p>
                    <p class="ext-panel-subtitle">현재 반납 예정일: {{ selectedRental.returnDate || '-' }}</p>
                </div>
                <button class="btn-close-panel" v-if="!isGuest" @click="fnClosePanel">✕</button>
                <a href="/rental/extension/inquiry.do" class="btn-back" v-if="isGuest">← 다시 조회하기</a>
            </div>

            <!-- 연장 신청 폼 -->
            <div class="ext-form">
                <!-- RESERVED 상태만 연장 가능 -->
                <div v-if="selectedRental.rentalStatus === 'RESERVED'">
                    <div class="ext-form-row">
                        <div class="form-group">
                            <label class="form-label">연장 일수</label>
                            <input type="number" class="form-input"
                                   v-model.number="extensionDays"
                                   min="1" max="30" placeholder="1~30">
                        </div>
                        <div class="price-preview">
                            <span class="price-preview-label">예상 금액</span>
                            <span class="price-preview-val">{{ fnPrice(extensionDays * 5000) }}</span>
                        </div>
                        <button class="btn-apply"
                                :disabled="!extensionDays || extensionDays < 1 || extensionDays > 30 || isApplying"
                                @click="fnApply">
                            {{ isApplying ? '처리 중...' : '연장 신청' }}
                        </button>
                    </div>
                    <p class="ext-notice">
                        · 1일 연장 기준 5,000원이 부과됩니다.<br>
                        · 최대 30일까지 연장 가능합니다.<br>
                        · RESERVED(예약완료) 상태의 대여만 연장 가능합니다.
                    </p>
                </div>
                <!-- RESERVED 아닌 경우 안내 -->
                <div v-else style="padding:8px 0;font-size:13px;color:var(--brown4)">
                    ⚠ 예약완료(RESERVED) 상태의 대여만 연장 신청이 가능합니다.
                </div>
            </div>

            <!-- 연장 내역 -->
            <div class="ext-history">
                <p class="ext-history-title">연장 내역</p>
                <div class="state-box" v-if="isDetailLoading" style="padding:24px">
                    <div class="spinner"></div>
                </div>
                <div class="ext-empty" v-else-if="extensions.length === 0">
                    아직 연장 내역이 없습니다.
                </div>
                <div class="ext-items" v-else>
                    <div v-for="ext in extensions" :key="ext.extensionId" class="ext-item">
                        <div class="ext-item-icon">📅</div>
                        <div class="ext-item-body">
                            <p class="ext-item-days">{{ ext.extensionDays }}일 연장</p>
                            <p class="ext-item-date">신청일: {{ fnDateTime(ext.createdAt) }}</p>
                        </div>
                        <p class="ext-item-price">{{ fnPrice(ext.price) }}</p>
                        <button class="btn-ext-cancel" @click="fnCancelExtension(ext.extensionId)">취소</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 비회원 로딩 중 -->
        <div class="section-card" v-if="isGuest && isLoading">
            <div class="state-box">
                <div class="spinner"></div>
                <p>대여 정보를 불러오는 중입니다...</p>
            </div>
        </div>

    </div>

    <div class="toast" id="toast"></div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    var app = Vue.createApp({
        data: function() {
            return {
                isGuest        : false,
                guestRentalId  : null,
                guestToken     : null,
                isLoading      : false,
                isDetailLoading: false,
                isApplying     : false,
                rentalList     : [],
                selectedRental : null,
                extensions     : [],
                extensionDays  : 1
            };
        },

        methods: {
            /* ── 초기화: 회원 or 비회원 판별 ── */
            fnInit: function() {
                var self   = this;
                var params = new URLSearchParams(location.search);
                var rid    = params.get('rentalId');
                var token  = params.get('token');

                if (rid && token) {
                    /* 비회원 모드 */
                    self.isGuest       = true;
                    self.guestRentalId = rid;
                    self.guestToken    = token;
                    self.fnLoadGuestDetail();
                } else {
                    /* 회원 모드 */
                    self.fnLoadMemberList();
                }
            },

            /* ── 비회원: 연장 내역 로드 ── */
            fnLoadGuestDetail: function() {
                var self = this;
                self.isLoading = true;
                $.ajax({
                    url     : '/rental/extension/guest/detail.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : { rentalId: self.guestRentalId, token: self.guestToken },
                    success : function(res) {
                        self.isLoading = false;
                        if (res.result === 'success') {
                            self.selectedRental = res.rental;
                            self.extensions     = res.extensions || [];
                        } else {
                            self.showToast(res.message || '조회에 실패했습니다.');
                        }
                    },
                    error: function() {
                        self.isLoading = false;
                        self.showToast('서버 오류가 발생했습니다.');
                    }
                });
            },

            /* ── 회원: 대여 목록 로드 ── */
            fnLoadMemberList: function() {
                var self = this;
                self.isLoading = true;
                $.ajax({
                    url     : '/rental/extension/list.dox',
                    type    : 'POST',
                    dataType: 'json',
                    success : function(res) {
                        self.isLoading = false;
                        if (res.result === 'success') {
                            self.rentalList = res.list || [];
                        } else {
                            self.showToast(res.message || '목록을 불러오지 못했습니다.');
                        }
                    },
                    error: function() {
                        self.isLoading = false;
                        self.showToast('서버 오류가 발생했습니다.');
                    }
                });
            },

            /* ── 회원: 대여 선택 ── */
            fnSelectRental: function(rental) {
                var self = this;
                self.selectedRental  = rental;
                self.extensions      = [];
                self.extensionDays   = 1;
                self.isDetailLoading = true;
                $.ajax({
                    url     : '/rental/extension/detail.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : { rentalId: rental.rentalId },
                    success : function(res) {
                        self.isDetailLoading = false;
                        if (res.result === 'success') {
                            self.extensions     = res.extensions || [];
                            self.selectedRental = res.rental || rental;
                        }
                    },
                    error: function() {
                        self.isDetailLoading = false;
                        self.showToast('연장 내역을 불러오지 못했습니다.');
                    }
                });
            },

            /* ── 패널 닫기 ── */
            fnClosePanel: function() {
                this.selectedRental = null;
                this.extensions     = [];
                this.extensionDays  = 1;
            },

            /* ── 연장 신청 ── */
            fnApply: function() {
                var self = this;
                if (!self.extensionDays || self.extensionDays < 1 || self.extensionDays > 30) {
                    self.showToast('1일 이상 30일 이하로 입력해주세요.');
                    return;
                }
                if (!confirm(self.extensionDays + '일 연장하시겠습니까?\n예상 금액: ' + self.fnPrice(self.extensionDays * 5000))) return;

                self.isApplying = true;
                var data = {
                    rentalId     : self.selectedRental.rentalId,
                    extensionDays: self.extensionDays
                };
                if (self.isGuest) { data.token = self.guestToken; }

                $.ajax({
                    url     : '/rental/extension/apply.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : data,
                    success : function(res) {
                        self.isApplying = false;
                        if (res.result === 'success') {
                            self.showToast('✅ ' + res.message);
                            if (self.isGuest) {
                                self.fnLoadGuestDetail();
                            } else {
                                self.fnSelectRental(self.selectedRental);
                                self.fnLoadMemberList();
                            }
                        } else {
                            self.showToast(res.message || '연장 신청에 실패했습니다.');
                        }
                    },
                    error: function() {
                        self.isApplying = false;
                        self.showToast('서버 오류가 발생했습니다.');
                    }
                });
            },

            /* ── 연장 취소 ── */
            fnCancelExtension: function(extensionId) {
                var self = this;
                if (!confirm('이 연장 내역을 취소하시겠습니까?\n반납일이 원래대로 돌아갑니다.')) return;

                var data = { extensionId: extensionId, rentalId: self.selectedRental.rentalId };
                if (self.isGuest) { data.token = self.guestToken; }

                $.ajax({
                    url     : '/rental/extension/cancel.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : data,
                    success : function(res) {
                        if (res.result === 'success') {
                            self.showToast('연장이 취소되었습니다.');
                            if (self.isGuest) {
                                self.fnLoadGuestDetail();
                            } else {
                                self.fnSelectRental(self.selectedRental);
                                self.fnLoadMemberList();
                            }
                        } else {
                            self.showToast(res.message || '취소에 실패했습니다.');
                        }
                    },
                    error: function() { self.showToast('서버 오류가 발생했습니다.'); }
                });
            },

            /* ── 유틸 ── */
            showToast: function(msg) {
                var t = document.getElementById('toast');
                t.textContent = msg;
                t.classList.add('show');
                setTimeout(function() { t.classList.remove('show'); }, 2500);
            },
            fnStatusText: function(s) {
                var map = { RESERVED:'예약완료', RENTING:'대여중', RETURNED:'반납완료', CANCELLED:'취소' };
                return map[s] || s || '-';
            },
            fnPrice: function(v) { return Number(v || 0).toLocaleString() + '원'; },
            fnDateTime: function(v) {
                if (!v) return '-';
                var d = new Date(String(v).replace(' ', 'T'));
                if (isNaN(d.getTime())) return String(v);
                var pad = function(n) { return String(n).padStart(2, '0'); };
                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                     + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
            }
        },

        mounted: function() { this.fnInit(); }
    });

    app.mount('#app');
</script>
</body>
</html>
