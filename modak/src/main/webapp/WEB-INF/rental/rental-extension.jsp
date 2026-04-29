<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>대여 연장 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rental/rental-extension.css">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css" rel="stylesheet">
    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app" v-cloak>
                <div class="ext-page">
                    <div>
                        <p class="page-eyebrow">RENTAL EXTENSION / RETURN</p>
                        <h1 class="page-title">대여 연장 / 반납 신청</h1>
                        <p class="page-desc" v-if="isGuest">
                            비회원 대여 관리 페이지입니다. 조회된 대여 건의 연장 또는 반납을 신청하실 수 있습니다.
                        </p>
                        <p class="page-desc" v-else>
                            대여 중인 상품을 선택해 연장 또는 반납 신청을 할 수 있습니다.
                        </p>

                        <!-- ══ 회원 대여 목록 ══ -->
                        <div class="section-card" v-if="!isGuest || guestOrderId || guestRentalId">
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
                                    <div class="empty-icon"><i class="ri-archive-2-line"></i></div>
                                    <p>대여 내역이 없습니다.</p>
                                </div>
                                <div class="rental-list" v-else>
                                    <div v-for="rental in rentalList" :key="rental.rentalId" class="rental-card"
                                        :class="{ active: selectedRental && selectedRental.rentalId === rental.rentalId }"
                                        @click="isGuest ? fnSelectGuestRental(rental) : fnSelectRental(rental)">
                                        <div class="rental-icon">
                                            <img v-if="rental.imgUrl" :src="rental.imgUrl"
                                                style="width:100%;height:100%;object-fit:cover;border-radius:12px;"
                                                @error="$event.target.style.display='none'; $event.target.nextElementSibling.style.display='flex'">
                                            <span :style="rental.imgUrl ? 'display:none' : 'display:flex'"
                                                class="fallback-product-icon">
                                                <i class="ri-tent-line"></i>
                                            </span>
                                        </div>
                                        <div class="rental-info">
                                            <p class="rental-name">{{ rental.productName || '상품명 없음' }}</p>
                                            <p class="rental-dates">{{ rental.startDate || '-' }} ~ {{ rental.returnDate
                                                || '-' }}</p>
                                            <span class="status-badge" :class="'st-' + rental.rentalStatus">
                                                {{ fnStatusText(rental.rentalStatus) }}
                                            </span>
                                        </div>
                                        <div class="rental-card-actions">
                                            <button type="button" class="mini-action-btn"
                                                v-if="['RESERVED','IN_USE'].includes(rental.rentalStatus)"
                                                @click.stop="isGuest ? (activeTab = 'extension', fnSelectGuestRental(rental)) : fnOpenExtension(rental)">연장
                                                신청</button>
                                            <button type="button" class="mini-action-btn return"
                                                v-if="['RESERVED','IN_USE'].includes(rental.rentalStatus)"
                                                @click.stop="isGuest ? (activeTab = 'return', fnSelectGuestRental(rental)) : fnOpenReturn(rental)">반납
                                                신청</button>
                                            <button type="button" class="mini-action-btn return-cancel"
                                                v-if="rental.rentalStatus === 'RETURN_REQUESTED'"
                                                @click.stop="isGuest ? (activeTab = 'return', fnSelectGuestRental(rental)) : fnOpenReturn(rental)">반납
                                                요청 취소</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ══ 선택 대여 모달 ══ -->
                        <div class="ext-modal-backdrop" v-if="selectedRental" @click.self="fnClosePanel">
                            <div class="ext-panel ext-modal-panel">

                                <!-- 패널 헤더 -->
                                <div class="ext-panel-head">
                                    <div class="ext-panel-img">
                                        <img v-if="selectedRental.imgUrl" :src="selectedRental.imgUrl"
                                            @error="$event.target.style.display='none'"
                                            style="width:100%;height:100%;object-fit:cover;border-radius:12px;">
                                        <span v-else class="fallback-panel-icon">
                                            <i class="ri-tent-line"></i>
                                        </span>
                                    </div>
                                    <div style="flex:1;">
                                        <p class="ext-panel-title">{{ selectedRental.productName || '상품명 없음' }}</p>
                                        <p class="ext-panel-subtitle">현재 반납 예정일: {{ selectedRental.returnDate || '-' }}
                                        </p>
                                        <p class="ext-panel-subtitle">
                                            남은 시간: <strong>{{ fnRemainText(selectedRental.returnDate) }}</strong>
                                        </p>
                                    </div>
                                    <!-- <button type="button" class="btn-close-panel" v-if="!isGuest"
                                    @click="fnClosePanel">✕</button> -->
                                    <button type="button" class="btn-close-panel" @click="fnClosePanel">✕</button>
                                </div>

                                <!-- ★ 탭 바 -->
                                <div class="ext-tab-bar" :class="activeTab === 'return' ? 'is-return' : 'is-extension'">

                                    <button type="button" class="ext-tab-btn"
                                        :class="{ active: activeTab === 'extension' }" @click="activeTab = 'extension'">
                                        <i class="ri-calendar-check-line"></i>
                                        대여 연장
                                    </button>

                                    <button type="button" class="ext-tab-btn"
                                        :class="{ active: activeTab === 'return' }" @click="activeTab = 'return'">
                                        <i class="ri-inbox-unarchive-line"></i>
                                        반납 신청
                                    </button>

                                </div>

                                <!-- ══ 연장 탭 ══ -->
                                <div v-if="activeTab === 'extension'">
                                    <div class="ext-form">
                                        <div v-if="['RESERVED','IN_USE'].includes(selectedRental.rentalStatus)">
                                            <div class="ext-form-row">
                                                <div class="form-group">
                                                    <label class="form-label">연장 일수</label>
                                                    <div class="days-stepper">
                                                        <button class="stepper-btn"
                                                            @click="extensionDays = Math.max(1, extensionDays - 1)"
                                                            type="button">−</button>
                                                        <input type="number" class="stepper-input"
                                                            v-model.number="extensionDays" min="1" max="30"
                                                            @input="extensionDays = Math.min(30, Math.max(1, extensionDays || 1))">
                                                        <button class="stepper-btn"
                                                            @click="extensionDays = Math.min(30, extensionDays + 1)"
                                                            type="button">+</button>
                                                    </div>
                                                </div>
                                                <div class="price-preview">
                                                    <span class="price-preview-label">예상 금액</span>
                                                    <span class="price-preview-val">
                                                        {{ fnPrice(extensionDays * (selectedRental.pricePerDay || 5000))
                                                        }}
                                                    </span>
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
                                                · 예약완료 또는 대여중 상태의 대여만 연장 가능합니다.
                                            </p>
                                        </div>
                                        <div v-else style="padding:8px 0;font-size:13px;color:var(--brown4)">
                                            ⚠ 예약완료 또는 대여중 상태의 대여만 연장 신청이 가능합니다.
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
                                                <div class="ext-item-icon">
                                                    <i class="ri-calendar-check-line"></i>
                                                </div>
                                                <div class="ext-item-body">
                                                    <p class="ext-item-days">{{ ext.extensionDays }}일 연장</p>
                                                    <p class="ext-item-date">신청일: {{ fnDateTime(ext.createdAt) }}</p>
                                                </div>
                                                <p class="ext-item-price">{{ fnPrice(ext.price) }}</p>
                                                <button class="btn-ext-cancel"
                                                    @click="fnCancelExtension(ext.extensionId)">취소</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- ══ 반납 탭 ══ -->
                                <div v-if="activeTab === 'return'">
                                    <div class="ext-form">

                                        <!-- 회수 주소 -->
                                        <div class="return-info-box"
                                            v-if="selectedRental.rentalStatus !== 'RETURN_REQUESTED'">
                                            <div class="form-group" style="margin-bottom:10px;">
                                                <label class="form-label">회수 우편번호</label>
                                                <div style="display:flex;gap:8px;">
                                                    <input type="text" class="form-input" v-model="pickup.zipcode"
                                                        style="width:160px;" readonly>
                                                    <button type="button" class="btn-back"
                                                        @click="fnSearchPickupAddress">주소
                                                        검색</button>
                                                </div>
                                            </div>
                                            <div class="form-group" style="margin-bottom:10px;">
                                                <label class="form-label">회수 주소</label>
                                                <input type="text" class="form-input" v-model="pickup.address"
                                                    style="width:100%;" readonly>
                                            </div>
                                            <div class="form-group" style="margin-bottom:14px;">
                                                <label class="form-label">상세 주소</label>
                                                <input type="text" class="form-input" v-model="pickup.detailedAddress"
                                                    ref="pickupDetailAddressInput" style="width:100%;">
                                            </div>
                                        </div>

                                        <!-- 반납 신청 버튼 -->
                                        <div v-if="['RESERVED','IN_USE'].includes(selectedRental.rentalStatus)">
                                            <p class="ext-notice" style="margin-top:0;margin-bottom:14px;">
                                                · 반납 신청 후 상태가 반납 요청 상태로 변경됩니다.<br>
                                                · 관리자 확인 후 최종 반납 처리가 진행됩니다.
                                            </p>
                                            <button type="button" class="btn-return" :disabled="isApplying"
                                                @click="fnApplyReturn(selectedRental)">
                                                {{ isApplying ? '처리 중...' : '반납 신청' }}
                                            </button>
                                        </div>

                                        <!-- 반납 취소 버튼 -->
                                        <div v-else-if="selectedRental.rentalStatus === 'RETURN_REQUESTED'">
                                            <p class="ext-notice" style="margin-top:0;margin-bottom:14px;">
                                                · 현재 반납 요청 상태입니다.<br>
                                                · 관리자가 처리하기 전까지 반납 요청을 취소할 수 있습니다.
                                            </p>
                                            <button type="button" class="btn-return" :disabled="isApplying"
                                                @click="fnCancelReturn(selectedRental)">
                                                {{ isApplying ? '처리 중...' : '반납 요청 취소' }}
                                            </button>
                                        </div>

                                        <div v-else style="padding:8px 0;font-size:13px;color:var(--brown4)">
                                            ⚠ 현재 상태에서는 반납 신청 또는 취소가 불가능합니다.
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /ext-panel -->
                        </div><!-- /ext-modal-backdrop -->

                        <!-- 비회원 로딩 -->
                        <div class="section-card" v-if="isGuest && isLoading">
                            <div class="state-box">
                                <div class="spinner"></div>
                                <p>대여 정보를 불러오는 중입니다...</p>
                            </div>
                        </div>
                    </div>

                    <div class="toast" id="toast"></div>
                </div>

                <!-- 확인 모달 -->
                <div v-if="modal.show" class="delete-modal-backdrop" @click.self="fnCloseModal">
                    <div class="delete-modal-box">
                        <div class="delete-modal-title">{{ modal.title }}</div>
                        <div class="delete-modal-desc" v-html="modal.message"></div>
                        <div class="delete-modal-actions">
                            <button type="button" class="delete-confirm-btn" @click="fnModalConfirm">{{
                                modal.confirmText }}</button>
                            <button type="button" class="delete-cancel-btn" @click="fnCloseModal">취소</button>
                        </div>
                    </div>
                </div>

            </div><!-- /#app -->

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    var app = Vue.createApp({
                        data: function () {
                            return {
                                activeTab: 'extension',
                                isGuest: false,
                                guestRentalId: null,
                                guestToken: null,
                                isLoading: false,
                                isDetailLoading: false,
                                isApplying: false,
                                rentalList: [],
                                selectedRental: null,
                                extensions: [],
                                extensionDays: 1,
                                returnHistory: [],   // ← 반납 신청 내역
                                pickup: { zipcode: '', address: '', detailedAddress: '' },
                                modal: { show: false, eyebrow: '', title: '', message: '', confirmText: '확인', onConfirm: null },
                                guestOrderId: null,
                            };
                        },

                        methods: {
                            fnInit: function () {
                                var self = this;
                                var params = new URLSearchParams(location.search);
                                var rid = params.get('rentalId');
                                var orderId = params.get('orderId');
                                var token = params.get('token');
                                var tab = params.get('tab');
                                console.log('orderId=', orderId);
                                console.log('token=', token);
                                console.log('rid=', rid);
                                // ★ 이 줄이 빠져 있었음
                                if (tab === 'return' || tab === 'extension') {
                                    self.activeTab = tab;
                                }

                                if (orderId && token) {
                                    self.isGuest = true;
                                    self.guestOrderId = orderId;
                                    self.guestToken = token;
                                    self.fnLoadGuestOrderRentals();
                                } else if (rid && token) {
                                    self.isGuest = true;
                                    self.guestRentalId = rid;
                                    self.guestToken = token;
                                    self.fnLoadGuestDetail();
                                    self.fnLoadPickupAddress();
                                } else {
                                    self.fnLoadMemberList();
                                    self.fnLoadPickupAddress();
                                }
                            },

                            fnOpenExtension: function (rental) { this.activeTab = 'extension'; this.fnSelectRental(rental); },
                            fnOpenReturn: function (rental) { this.activeTab = 'return'; this.fnSelectRental(rental); },

                            fnSearchPickupAddress: function () {
                                var self = this;
                                new daum.Postcode({
                                    oncomplete: function (data) {
                                        var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                                        self.pickup.zipcode = data.zonecode;
                                        self.pickup.address = addr;
                                        self.$nextTick(function () {
                                            if (self.$refs.pickupDetailAddressInput) self.$refs.pickupDetailAddressInput.focus();
                                        });
                                    }
                                }).open();
                            },

                            fnLoadPickupAddress: function () {
                                if (this.isGuest) this.fnLoadGuestAddress(); else this.fnLoadAddress();
                            },

                            fnLoadAddress: function () {
                                var self = this;
                                $.ajax({
                                    url: '/rental/extension/return/address.dox', type: 'POST', dataType: 'json',
                                    success: function (res) {
                                        if (res.result === 'success' && res.address) {
                                            self.pickup.zipcode = res.address.zipcode || '';
                                            self.pickup.address = res.address.address || '';
                                            self.pickup.detailedAddress = res.address.detailedAddress || '';
                                        }
                                    }
                                });
                            },

                            fnLoadGuestAddress: function () {
                                var self = this;
                                $.ajax({
                                    url: '/rental/extension/return/guest/address.dox', type: 'POST', dataType: 'json',
                                    data: { rentalId: self.guestRentalId },
                                    success: function (res) {
                                        if (res.result === 'success' && res.address) {
                                            self.pickup.zipcode = res.address.zipcode || '';
                                            self.pickup.address = res.address.address || '';
                                            self.pickup.detailedAddress = res.address.detailedAddress || '';
                                        }
                                    }
                                });
                            },

                            fnLoadGuestDetail: function () {
                                var self = this;
                                self.isLoading = true;
                                $.ajax({
                                    url: '/rental/extension/guest/detail.dox', type: 'POST', dataType: 'json',
                                    data: { rentalId: self.guestRentalId, token: self.guestToken },
                                    success: function (res) {
                                        self.isLoading = false;
                                        if (res.result === 'success') {
                                            self.selectedRental = res.rental;
                                            self.rentalList = res.rental ? [res.rental] : [];
                                            self.extensions = res.extensions || [];
                                            self.returnHistory = res.returnHistory || [];
                                        } else { self.showToast(res.message || '조회에 실패했습니다.'); }
                                    },
                                    error: function () { self.isLoading = false; self.showToast('서버 오류가 발생했습니다.'); }
                                });
                            },

                            fnLoadMemberList: function () {
                                var self = this;
                                self.isLoading = true;
                                $.ajax({
                                    url: '/rental/extension/list.dox', type: 'POST', dataType: 'json',
                                    success: function (res) {
                                        self.isLoading = false;
                                        if (res.result === 'success') self.rentalList = res.list || [];
                                        else self.showToast(res.message || '목록을 불러오지 못했습니다.');
                                    },
                                    error: function () { self.isLoading = false; self.showToast('서버 오류가 발생했습니다.'); }
                                });
                            },

                            fnSelectRental: function (rental) {
                                var self = this;
                                self.selectedRental = rental;
                                self.extensions = [];
                                self.returnHistory = [];
                                self.extensionDays = 1;
                                self.isDetailLoading = true;
                                $.ajax({
                                    url: '/rental/extension/detail.dox', type: 'POST', dataType: 'json',
                                    data: { rentalId: rental.rentalId },
                                    success: function (res) {
                                        self.isDetailLoading = false;
                                        if (res.result === 'success') {
                                            self.extensions = res.extensions || [];
                                            self.selectedRental = res.rental || rental;
                                            self.returnHistory = res.returnHistory || []; // ← 추가
                                        }
                                    },
                                    error: function () { self.isDetailLoading = false; self.showToast('내역을 불러오지 못했습니다.'); }
                                });
                            },

                            fnClosePanel: function () {
                                this.selectedRental = null; this.extensions = []; this.returnHistory = []; this.extensionDays = 1;
                            },

                            fnApply: function () {
                                var self = this;
                                if (!self.selectedRental) { self.showToast('대여 건을 선택해주세요.'); return; }
                                if (!self.extensionDays || self.extensionDays < 1 || self.extensionDays > 30) {
                                    self.showToast('1일 이상 30일 이하로 입력해주세요.'); return;
                                }

                                var expectedPrice = self.fnPrice(self.extensionDays * (self.selectedRental.pricePerDay || 5000));
                                self.fnOpenModal({
                                    title: '대여를 연장하시겠습니까?',
                                    message: '<strong>' + self.extensionDays + '일</strong> 연장됩니다.<br>결제 금액: <strong>' + expectedPrice + '</strong>',
                                    confirmText: '결제하기',
                                    onConfirm: function () {
                                        self.isApplying = true;
                                        $.ajax({
                                            url: '/rental/extension/payment/ready.dox',
                                            type: 'POST',
                                            dataType: 'json',
                                            data: {
                                                rentalId: self.selectedRental.rentalId,
                                                extensionDays: self.extensionDays,
                                                pricePerDay: self.selectedRental.pricePerDay || 5000,
                                                token: self.isGuest ? (self.guestToken || '') : ''  // 비회원 토큰
                                            },
                                            success: function (res) {
                                                self.isApplying = false;
                                                if (res.result === 'success') {
                                                    if (self.isGuest) {
                                                        sessionStorage.setItem('extGuestToken', self.guestToken || '');
                                                        sessionStorage.setItem('extGuestOrderId', self.guestOrderId || '');
                                                        sessionStorage.setItem('extGuestRentalId', self.selectedRental.rentalId || '');
                                                    }
                                                    // 결제 페이지로 이동
                                                    location.href = '/rental/extension/payment.do'
                                                        + '?extensionOrderId=' + res.extensionOrderId
                                                        + '&amount=' + res.amount
                                                        + '&days=' + self.extensionDays
                                                        + '&productName=' + encodeURIComponent(self.selectedRental.productName || '대여 상품')
                                                        + '&imgUrl=' + encodeURIComponent(self.selectedRental.imgUrl || '')
                                                        + '&token=' + encodeURIComponent(self.isGuest ? (self.guestToken || '') : '')
                                                        + '&orderId=' + encodeURIComponent(self.isGuest ? (self.guestOrderId || '') : '')
                                                        + '&rentalId=' + encodeURIComponent(self.isGuest ? (self.selectedRental.rentalId || '') : '');
                                                } else {
                                                    self.showToast(res.message || '결제 준비에 실패했습니다.');
                                                }
                                            },
                                            error: function () {
                                                self.isApplying = false;
                                                self.showToast('서버 오류가 발생했습니다.');
                                            }
                                        });
                                    }
                                });
                            },
                            fnCancelExtension: function (extensionId) {
                                var self = this;
                                self.fnOpenModal({
                                    title: '연장 신청을 취소하시겠습니까?',
                                    message: '선택한 연장 내역이 취소되고<br>반납일이 이전 상태로 돌아갑니다.',
                                    confirmText: '취소하기',
                                    onConfirm: function () {
                                        var data = { extensionId: extensionId, rentalId: self.selectedRental.rentalId };
                                        if (self.isGuest) data.token = self.guestToken;
                                        $.ajax({
                                            url: '/rental/extension/cancel.dox', type: 'POST', dataType: 'json', data: data,
                                            success: function (res) {
                                                if (res.result === 'success') {
                                                    self.showToast('연장이 취소되었습니다.');
                                                    if (self.isGuest) self.fnLoadGuestDetail();
                                                    else { self.fnSelectRental(self.selectedRental); self.fnLoadMemberList(); }
                                                } else { self.showToast(res.message || '취소에 실패했습니다.'); }
                                            },
                                            error: function () { self.showToast('서버 오류가 발생했습니다.'); }
                                        });
                                    }
                                });
                            },

                            fnApplyReturn: function (rental) {
                                var self = this;
                                if (!rental) { self.showToast('대여 건을 선택해주세요.'); return; }
                                if (!['RESERVED', 'IN_USE'].includes(rental.rentalStatus)) {
                                    self.showToast('예약완료 또는 대여중 상태만 반납 신청 가능합니다.'); return;
                                }
                                if (!self.pickup.address) { self.showToast('회수 주소를 입력해주세요.'); return; }
                                self.fnOpenModal({
                                    title: '반납 신청하시겠습니까?',
                                    message: '선택한 상품의 상태가<br><strong>반납 요청</strong>으로 변경됩니다.',
                                    confirmText: '반납 신청',
                                    onConfirm: function () {
                                        self.isApplying = true;
                                        var url = self.isGuest ? '/rental/extension/return/guest/apply.dox' : '/rental/extension/return/apply.dox';
                                        var data = { rentalId: rental.rentalId, zipcode: self.pickup.zipcode, address: self.pickup.address, detailedAddress: self.pickup.detailedAddress };
                                        if (self.isGuest) { data.token = self.guestToken; data.guestName = rental.guestName; data.guestPhone = rental.guestPhone; }
                                        $.ajax({
                                            url: url, type: 'POST', dataType: 'json', data: data,
                                            success: function (res) {
                                                self.isApplying = false;
                                                if (res.result === 'success') {
                                                    self.showToast(res.message || '반납 신청이 완료되었습니다.');

                                                    self.fnClosePanel();

                                                    if (self.isGuest) {
                                                        self.fnLoadGuestOrderRentals();
                                                    } else {
                                                        self.fnLoadMemberList();
                                                    }
                                                } else { self.showToast(res.message || '반납 신청에 실패했습니다.'); }
                                            },
                                            error: function () { self.isApplying = false; self.showToast('서버 오류가 발생했습니다.'); }
                                        });
                                    }
                                });
                            },
                            fnCancelReturn: function (rental) {
                                var self = this;

                                if (!rental) {
                                    self.showToast('대여 건을 선택해주세요.');
                                    return;
                                }

                                if (rental.rentalStatus !== 'RETURN_REQUESTED') {
                                    self.showToast('반납 요청 상태에서만 취소할 수 있습니다.');
                                    return;
                                }

                                self.isApplying = true;

                                var url = self.isGuest
                                    ? '/rental/extension/return/guest/cancel.dox'
                                    : '/rental/extension/return/cancel.dox';

                                var data = {
                                    rentalId: rental.rentalId
                                };

                                if (self.isGuest) {
                                    data.token = self.guestToken;
                                    data.guestName = rental.guestName;
                                    data.guestPhone = rental.guestPhone;
                                }

                                $.ajax({
                                    url: url,
                                    type: 'POST',
                                    dataType: 'json',
                                    data: data,
                                    success: function (res) {
                                        self.isApplying = false;

                                        if (res.result === 'success') {
                                            self.showToast(res.message || '반납 요청이 취소되었습니다.');

                                            // 선택 모달 닫기
                                            self.fnClosePanel();

                                            if (self.isGuest) {
                                                self.fnLoadGuestOrderRentals();
                                            } else {
                                                self.fnLoadMemberList();
                                            }
                                        } else {
                                            self.showToast(res.message || '반납 요청 취소에 실패했습니다.');
                                        }
                                    },
                                    error: function () {
                                        self.isApplying = false;
                                        self.showToast('서버 오류가 발생했습니다.');
                                    }
                                });
                            },
                            fnRemainText: function (value) {
                                if (!value) return '-';
                                var today = new Date(); today.setHours(0, 0, 0, 0);
                                var target = new Date(String(value).replace(' ', 'T')); target.setHours(0, 0, 0, 0);
                                if (isNaN(target.getTime())) return '-';
                                var diff = Math.ceil((target - today) / (1000 * 60 * 60 * 24));
                                if (diff > 0) return diff + '일 남음';
                                if (diff === 0) return '오늘 반납';
                                return Math.abs(diff) + '일 지남';
                            },

                            showToast: function (msg) {
                                var t = document.getElementById('toast');
                                if (!t) { alert(msg); return; }
                                t.textContent = msg; t.classList.add('show');
                                setTimeout(function () { t.classList.remove('show'); }, 2500);
                            },

                            fnStatusText: function (s) {
                                var map = {
                                    PAID: '결제완료', READY: '상품준비중', SHIPPING: '배송중', DONE: '배송완료',
                                    RESERVED: '예약완료', RENTING: '대여중', IN_USE: '대여중',
                                    RETURN_REQUESTED: '반납요청', RETURN_PICKED: '수거중',
                                    RETURNED: '반납완료', RETURN_COMPLETED: '반납완료', CANCELLED: '취소'
                                };
                                return map[s] || s || '-';
                            },

                            fnPrice: function (v) { return Number(v || 0).toLocaleString() + '원'; },

                            fnDateTime: function (v) {
                                if (!v) return '-';
                                var d = new Date(String(v).replace(' ', 'T'));
                                if (isNaN(d.getTime())) return String(v);
                                var pad = function (n) { return String(n).padStart(2, '0'); };
                                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                                    + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
                            },

                            fnOpenModal: function (option) {
                                this.modal.show = true;
                                this.modal.eyebrow = option.eyebrow || 'CONFIRM';
                                this.modal.title = option.title || '확인';
                                this.modal.message = option.message || '';
                                this.modal.confirmText = option.confirmText || '확인';
                                this.modal.onConfirm = option.onConfirm || null;
                            },

                            fnCloseModal: function () { this.modal.show = false; this.modal.onConfirm = null; },

                            fnModalConfirm: function () {
                                var callback = this.modal.onConfirm;
                                this.fnCloseModal();
                                if (typeof callback === 'function') callback();
                            },
                            fnLoadGuestOrderRentals: function () {
                                var self = this;
                                self.isLoading = true;

                                $.ajax({
                                    url: '/rental/extension/guest/order-list.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        orderId: self.guestOrderId,
                                        token: self.guestToken
                                    },
                                    success: function (res) {
                                        self.isLoading = false;

                                        if (res.result === 'success') {
                                            self.rentalList = res.list || [];

                                        } else {
                                            self.showToast(res.message || '대여 목록을 불러오지 못했습니다.');
                                        }
                                    },
                                    error: function () {
                                        self.isLoading = false;
                                        self.showToast('서버 오류가 발생했습니다.');
                                    }
                                });
                            },

                            fnSelectGuestRental: function (rental) {
                                var self = this;

                                self.selectedRental = rental;
                                self.guestRentalId = rental.rentalId;

                                self.pickup.zipcode = rental.returnZipcode || '';
                                self.pickup.address = rental.returnAddress || '';
                                self.pickup.detailedAddress = rental.returnDetailedAddress || '';

                                self.extensions = [];
                                self.returnHistory = [];

                                self.fnLoadGuestAddress();

                                var savedRentalId = sessionStorage.getItem('extGuestRentalId');
                                var savedToken = sessionStorage.getItem('extGuestToken');

                                if (savedRentalId && savedToken && String(savedRentalId) === String(rental.rentalId)) {
                                    var originToken = self.guestToken;
                                    self.guestToken = savedToken;

                                    self.fnLoadGuestDetail();

                                    self.guestToken = originToken;
                                }
                            },
                            fnReloadGuestOrderList: function () {
                                var self = this;
                                var currentRentalId = self.selectedRental ? self.selectedRental.rentalId : null;

                                $.ajax({
                                    url: '/rental/extension/guest/order-list.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: {
                                        orderId: self.guestOrderId,
                                        token: self.guestToken
                                    },
                                    success: function (res) {
                                        if (res.result === 'success') {
                                            self.rentalList = res.list || [];

                                            for (var i = 0; i < self.rentalList.length; i++) {
                                                if (self.rentalList[i].rentalId === currentRentalId) {
                                                    self.selectedRental = self.rentalList[i];
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                });
                            },
                            
                        },

                        mounted: function () { this.fnInit(); }
                    });

                    app.mount('#app');
                </script>

    </body>

    </html>