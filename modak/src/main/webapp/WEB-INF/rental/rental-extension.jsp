<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대여 연장 - 모닥모닥</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rental/rental-extension.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

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
                        <div class="rental-icon">
                            <img v-if="rental.imgUrl"
                                 :src="rental.imgUrl"
                                 style="width:100%;height:100%;object-fit:cover;border-radius:12px;"
                                 @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                            <span :style="rental.imgUrl ? 'display:none' : 'display:flex'"
                                  style="width:100%;height:100%;align-items:center;justify-content:center;font-size:22px;">⛺</span>
                        </div>
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
                <div v-if="['RESERVED','IN_USE'].includes(selectedRental.rentalStatus)">
                    <div class="ext-form-row">
                        <div class="form-group">
                            <label class="form-label">연장 일수</label>
                            <div class="days-stepper">
                                <button class="stepper-btn" @click="extensionDays = Math.max(1, extensionDays - 1)" type="button">−</button>
                                <input type="number" class="stepper-input"
                                       v-model.number="extensionDays"
                                       min="1" max="30"
                                       @input="extensionDays = Math.min(30, Math.max(1, extensionDays || 1))">
                                <button class="stepper-btn" @click="extensionDays = Math.min(30, extensionDays + 1)" type="button">+</button>
                            </div>
                        </div>
                        <div class="price-preview">
                            <span class="price-preview-label">예상 금액</span>
                            <span class="price-preview-val">{{ fnPrice(extensionDays * (selectedRental.pricePerDay || 5000)) }}</span>
                        </div>
                        <button class="btn-apply"
                                :disabled="!extensionDays || extensionDays < 1 || extensionDays > 30 || isApplying"
                                @click="fnApply">
                            {{ isApplying ? '처리 중...' : '연장 신청' }}
                        </button>
                    </div>
                    <p class="ext-notice">
                        · 1일 연장 기준 {{ fnPrice(selectedRental.pricePerDay || 5000) }}이 부과됩니다.<br>
                        · 최대 30일까지 연장 가능합니다.<br>
                        · 예약완료(RESERVED) 또는 대여중(IN_USE) 상태의 대여만 연장 가능합니다.
                    </p>
                </div>
                <!-- RESERVED 아닌 경우 안내 -->
                <div v-else style="padding:8px 0;font-size:13px;color:var(--brown4)">
                    ⚠ 대여중(IN_USE) 또는 예약완료(RESERVED) 상태의 대여만 연장 신청이 가능합니다.
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
                var expectedPrice = self.fnPrice(self.extensionDays * (self.selectedRental.pricePerDay || 5000));
                if (!confirm(self.extensionDays + '일 연장하시겠습니까?\n예상 금액: ' + expectedPrice)) return;

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
