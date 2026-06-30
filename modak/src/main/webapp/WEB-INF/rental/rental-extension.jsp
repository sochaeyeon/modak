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

                        <!-- 연장 안내 박스 -->
                        <div class="ext-info-box">
                            <p class="ext-info-box-title">
                                <i class="ri-information-line"></i> 대여 연장 안내
                            </p>
                            · 1일 연장 기준 요금은 상품별로 상이합니다.<br>
                            · 최대 3일까지 연장 가능하며, 연장은 1회까지만 가능합니다.<br>
                            · 예약완료 또는 대여중 상태의 대여만 연장 가능합니다.<br>
                            · <strong class="ext-info-overdue-text">연체 시 3일째부터 하루당 총 대여금액의 20%가 추가 청구됩니다.</strong>
                        </div>
                    </div>

                    <!-- 대여 목록 -->
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

                                    <!-- 이미지 -->
                                    <div class="rental-icon">
                                        <img v-if="rental.imgUrl" :src="rental.imgUrl"
                                            style="width:100%;height:100%;object-fit:cover;border-radius:12px;"
                                            @error="$event.target.style.display='none'">
                                        <span v-else class="fallback-product-icon">
                                            <i class="ri-tent-line"></i>
                                        </span>
                                    </div>

                                    <!-- 정보 -->
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
                                            v-if="fnCanExtension(rental.rentalStatus, rental.returnDate)"
                                            @click.stop="isGuest ? (activeTab = 'extension', fnSelectGuestRental(rental)) : fnOpenExtension(rental)">
                                            연장 신청
                                        </button>
                                        <button type="button" class="mini-action-btn return"
                                            v-if="fnCanReturn(rental.rentalStatus)"
                                            @click.stop="isGuest ? (activeTab = 'return', fnSelectGuestRental(rental)) : fnOpenReturn(rental)">
                                            반납 신청
                                        </button>
                                        <button type="button" class="mini-action-btn return-cancel"
                                            v-if="rental.rentalStatus === 'RETURN_REQUESTED'"
                                            @click.stop="isGuest ? (activeTab = 'return', fnSelectGuestRental(rental)) : fnOpenReturn(rental)">
                                            반납 요청 취소
                                        </button>
                                    </div>

                                    <!-- ★ 연체 경고 띠 -->
                                    <div class="overdue-strip" :class="{ 'is-paid': rental.overdueFee > 0 && fnAdditionalOverdueDays(rental) === 0,
              'is-additional': rental.overdueFee > 0 && fnAdditionalOverdueDays(rental) > 0 }"
                                        v-if="fnIsOverdue(rental.returnDate) && ['PAID','READY','SHIPPING','DONE','IN_USE'].includes(rental.rentalStatus)">

                                        <template v-if="rental.overdueFee > 0">
                                            <template v-if="fnAdditionalOverdueDays(rental) > 0">
                                                <span class="overdue-strip-label">
                                                    <i class="ri-alarm-warning-line"></i>
                                                    결제 후 {{ fnAdditionalOverdueDays(rental) }}일 추가 경과 · 추가 연체료 발생
                                                </span>
                                                <span class="overdue-strip-amount">{{ fnPrice(fnTotalOverdueDue(rental))
                                                    }}</span>
                                            </template>
                                            <template v-else>
                                                <span class="overdue-strip-label">
                                                    <i class="ri-checkbox-circle-line"></i>
                                                    연체료 결제 완료 · 반납 신청만 하면 됩니다
                                                </span>
                                                <span class="overdue-strip-amount">{{ fnPrice(rental.overdueFee)
                                                    }}</span>
                                            </template>
                                        </template>

                                        <template v-else>
                                            <span class="overdue-strip-label">
                                                <i class="ri-time-line"></i>
                                                연체 {{ fnOverdueDays(rental.returnDate) }}일째 · 현재까지 예상 연체료
                                            </span>
                                            <span class="overdue-strip-amount">{{ fnPrice(fnOverdueFee(rental))
                                                }}</span>
                                        </template>
                                    </div>

                                    <div class="rental-ext-history"
                                        v-if="rental.extensions && rental.extensions.length > 0" @click.stop>
                                        <div class="ext-hist-title">
                                            <i class="ri-calendar-check-line" style="color:#E8732A;"></i>
                                            연장 내역 {{ rental.extensions.length }}건
                                        </div>
                                        <div class="ext-hist-item" v-for="ext in rental.extensions"
                                            :key="ext.extensionId">
                                            <span class="ext-hist-days">+{{ ext.extensionDays }}일</span>
                                            <span class="ext-hist-price">{{ fnPrice(ext.price) }}</span>
                                            <span class="ext-hist-date">{{ fnDateTime(ext.createdAt) }}</span>
                                            <button class="btn-ext-cancel-small"
                                                @click.stop="fnCancelExtensionInline(ext.extensionId, rental)">
                                                취소
                                            </button>
                                        </div>
                                    </div>

                                </div><!-- /rental-card -->
                            </div>
                        </div>
                    </div>

                    <!-- 선택 대여 모달 -->
                    <div class="ext-modal-backdrop" v-if="selectedRental" @click.self="fnClosePanel">
                        <div class="ext-panel ext-modal-panel">

                            <div class="ext-panel-head">
                                <div class="ext-panel-img">
                                    <img v-if="selectedRental.imgUrl" :src="selectedRental.imgUrl"
                                        @error="$event.target.style.display='none'"
                                        style="width:100%;height:100%;object-fit:cover;border-radius:12px;">
                                    <span v-else class="fallback-panel-icon"><i class="ri-tent-line"></i></span>
                                </div>
                                <div style="flex:1;">
                                    <p class="ext-panel-title">{{ selectedRental.productName || '상품명 없음' }}</p>
                                    <p class="ext-panel-subtitle">현재 반납 예정일: {{ selectedRental.returnDate || '-' }}</p>
                                    <p class="ext-panel-subtitle">
                                        남은 시간: <strong>{{ fnRemainText(selectedRental.returnDate) }}</strong>
                                    </p>
                                </div>
                                <button type="button" class="btn-close-panel" @click="fnClosePanel">✕</button>
                            </div>

                            <div class="ext-tab-bar"
                                :class="activeTab === 'return' && fnCanReturn(selectedRental.rentalStatus) ? 'is-return' : 'is-extension'">
                                <button type="button" class="ext-tab-btn" :class="{ active: activeTab === 'extension' }"
                                    @click="activeTab = 'extension'">
                                    <i class="ri-calendar-check-line"></i> 대여 연장
                                </button>
                                <button type="button" class="ext-tab-btn"
                                    v-if="fnCanReturn(selectedRental.rentalStatus)"
                                    :class="{ active: activeTab === 'return' }" @click="activeTab = 'return'">
                                    <i class="ri-inbox-unarchive-line"></i> 반납 신청
                                </button>
                            </div>

                            <!-- 연장 탭 -->
                            <div v-if="activeTab === 'extension'">
                                <div class="ext-form">
                                    <div v-if="fnCanExtension(selectedRental.rentalStatus, selectedRental.returnDate)">

                                        <!-- 이미 연장한 경우 -->
                                        <div v-if="extensions.length >= 1" class="ext-done-box">
                                            <i class="ri-calendar-check-line"></i>
                                            <p class="ext-done-box-title">연장이 이미 완료되었습니다</p>
                                            <p class="ext-done-box-desc">연장은 대여 1건당 1회, 최대 3일까지만 가능합니다.</p>
                                        </div>

                                        <!-- 아직 연장 안 한 경우 -->
                                        <div v-else>
                                            <div class="ext-form-row">
                                                <div class="form-group">
                                                    <label class="form-label">연장 일수</label>
                                                    <div class="days-stepper">
                                                        <button class="stepper-btn"
                                                            @click="extensionDays = Math.max(1, extensionDays - 1)"
                                                            type="button">−</button>
                                                        <input type="number" class="stepper-input"
                                                            v-model.number="extensionDays" min="1" max="3"
                                                            @input="extensionDays = Math.min(3, Math.max(1, extensionDays || 1))">
                                                        <button class="stepper-btn"
                                                            @click="extensionDays = Math.min(3, extensionDays + 1)"
                                                            :disabled="extensionDays >= 3"
                                                            :style="extensionDays >= 3 ? 'opacity:0.35;cursor:not-allowed;' : ''"
                                                            type="button">+</button>
                                                    </div>
                                                    <p v-if="extensionDays >= 3" class="stepper-max-notice">
                                                        최대 연장 가능 일수(3일)입니다.
                                                    </p>
                                                </div>
                                                <div class="price-preview">
                                                    <span class="price-preview-label">예상 금액</span>
                                                    <span class="price-preview-val">
                                                        {{ fnPrice(extensionDays * (selectedRental.pricePerDay || 5000))
                                                        }}
                                                    </span>
                                                </div>
                                                <button class="btn-apply"
                                                    :disabled="!extensionDays || extensionDays < 1 || extensionDays > 3 || isApplying"
                                                    @click="fnApply">
                                                    {{ isApplying ? '처리 중...' : '연장 신청' }}
                                                </button>
                                            </div>
                                        </div>

                                    </div>
                                    <div v-else class="ext-disabled-notice">
                                        ⚠ 현재 상태에서는 연장 신청이 불가능합니다.
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

                            <!-- 반납 탭 -->
                            <div v-if="activeTab === 'return'">
                                <div class="ext-form">
                                    <div class="return-info-box"
                                        v-if="selectedRental.rentalStatus !== 'RETURN_REQUESTED'">
                                        <div class="form-group" style="margin-bottom:10px;">
                                            <label class="form-label">회수 우편번호</label>
                                            <div style="display:flex;gap:8px;">
                                                <input type="text" class="form-input" v-model="pickup.zipcode"
                                                    style="width:160px;" readonly>
                                                <button type="button" class="btn-back" @click="fnSearchPickupAddress">주소
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

                                    <div v-if="fnCanReturn(selectedRental.rentalStatus)">
                                        <p class="ext-notice" style="margin-top:0;margin-bottom:14px;">
                                            · 반납 신청 후 상태가 반납 요청 상태로 변경됩니다.<br>
                                            · 관리자 확인 후 최종 반납 처리가 진행됩니다.
                                        </p>
                                        <button type="button" class="btn-return" :disabled="isApplying"
                                            @click="fnApplyReturn(selectedRental)">
                                            {{ isApplying ? '처리 중...' : '반납 신청' }}
                                        </button>
                                    </div>
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
                                    <div v-else class="ext-disabled-notice">
                                        ⚠ 현재 상태에서는 반납 신청 또는 취소가 불가능합니다.
                                    </div>
                                </div>
                            </div>

                        </div><!-- /ext-modal-panel -->
                    </div><!-- /ext-modal-backdrop -->
                    <div class="section-card" v-if="isGuest && isLoading">
                        <div class="state-box">
                            <div class="spinner"></div>
                            <p>대여 정보를 불러오는 중입니다...</p>
                        </div>
                    </div>

                    <div class="toast" id="toast"></div>
                </div><!-- /ext-page -->

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

            </div><!-- /app -->

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    var { createApp } = Vue;

                    var app = createApp({
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
                                returnHistory: [],
                                pickup: { zipcode: '', address: '', detailedAddress: '' },
                                modal: { show: false, title: '', message: '', confirmText: '확인', onConfirm: null },
                                guestOrderId: null,
                            };
                        },

                        methods: {

                            /* ══ 초기화 ══════════════════════════════════════════ */
                            fnInit: function () {
                                var self = this;
                                var params = new URLSearchParams(location.search);
                                var rid = params.get('rentalId');
                                var orderId = params.get('orderId');
                                var token = params.get('token');
                                var tab = params.get('tab');

                                if (tab === 'return' || tab === 'extension') self.activeTab = tab;

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

                                } else if (rid) {
                                    // 회원 — 결제 완료 후 특정 rental 자동 선택
                                    self.fnLoadMemberList();
                                    self.fnLoadPickupAddress();
                                    var check = setInterval(function () {
                                        var found = self.rentalList.find(function (r) {
                                            return String(r.rentalId) === String(rid);
                                        });
                                        if (found) {
                                            clearInterval(check);
                                            self.fnSelectRental(found);
                                            var url = new URL(location.href);
                                            url.searchParams.delete('rentalId');
                                            history.replaceState(null, '', url.toString());
                                        }
                                    }, 200);
                                    setTimeout(function () { clearInterval(check); }, 5000);

                                } else {
                                    self.fnLoadMemberList();
                                    self.fnLoadPickupAddress();
                                }
                            },

                            fnOpenExtension: function (r) { this.activeTab = 'extension'; this.fnSelectRental(r); },
                            fnOpenReturn: function (r) { this.activeTab = 'return'; this.fnSelectRental(r); },

                            /* ══ 주소 ════════════════════════════════════════════ */
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
                            fnLoadPickupAddress: function () { this.isGuest ? this.fnLoadGuestAddress() : this.fnLoadAddress(); },
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

                            /* ══ 목록 로드 ════════════════════════════════════════ */
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

                            /* ★ 핵심: 비회원 목록 로드 + 각 카드 연장내역 로드 */
                            fnLoadGuestOrderRentals: function () {
                                var self = this;
                                self.isLoading = true;
                                $.ajax({
                                    url: '/rental/extension/guest/order-list.dox', type: 'POST', dataType: 'json',
                                    data: { orderId: self.guestOrderId, token: self.guestToken },
                                    success: function (res) {
                                        self.isLoading = false;
                                        if (res.result !== 'success') {
                                            self.showToast(res.message || '대여 목록을 불러오지 못했습니다.');
                                            return;
                                        }

                                        // extensions 필드 미리 세팅 (Vue 3 반응성 보장)
                                        self.rentalList = (res.list || []).map(function (r) {
                                            r.extensions = [];
                                            return r;
                                        });

                                        // 각 카드 연장내역 비동기 로드
                                        self.rentalList.forEach(function (rental, idx) {
                                            $.ajax({
                                                url: '/rental/extension/guest/detail.dox',  // ★ guest 전용
                                                type: 'POST', dataType: 'json',
                                                data: { rentalId: rental.rentalId, token: self.guestToken },
                                                success: function (detailRes) {
                                                    if (detailRes.result !== 'success') return;

                                                    var exts = detailRes.extensions || [];

                                                    // ★ Vue 3 반응성: slice() 로 강제 갱신
                                                    self.rentalList[idx] = Object.assign({}, self.rentalList[idx], {
                                                        extensions: exts
                                                    });
                                                    self.rentalList = self.rentalList.slice();

                                                    // ★ 현재 열린 모달도 동기화
                                                    if (self.selectedRental &&
                                                        self.selectedRental.rentalId === rental.rentalId) {
                                                        self.extensions = exts;
                                                    }
                                                }
                                            });
                                        });
                                    },
                                    error: function () { self.isLoading = false; }
                                });
                            },

                            /* ══ 비회원 단건 조회 ══════════════════════════════════ */
                            fnLoadGuestDetail: function () {
                                var self = this;
                                self.isLoading = true;
                                $.ajax({
                                    url: '/rental/extension/guest/detail.dox', type: 'POST', dataType: 'json',
                                    data: { rentalId: self.guestRentalId, token: self.guestToken },
                                    success: function (res) {
                                        self.isLoading = false;
                                        if (res.result === 'success') {
                                            self.selectedRental = res.rental || null;
                                            self.extensions = res.extensions || [];
                                            self.returnHistory = res.returnHistory || [];
                                            self.activeTab = 'extension';
                                        } else {
                                            self.showToast(res.message || '조회에 실패했습니다.');
                                        }
                                    },
                                    error: function () { self.isLoading = false; self.showToast('서버 오류가 발생했습니다.'); }
                                });
                            },

                            /* ══ 회원 카드 선택 ════════════════════════════════════ */
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
                                            self.returnHistory = res.returnHistory || [];
                                        }
                                    },
                                    error: function () { self.isDetailLoading = false; self.showToast('내역을 불러오지 못했습니다.'); }
                                });
                            },
                            fnAdditionalOverdueDays: function (rental) {
                                if (!rental.overduePaidAt) return 0;
                                var today = new Date(); today.setHours(0, 0, 0, 0);
                                var paidDate = new Date(String(rental.overduePaidAt).replace(' ', 'T')); paidDate.setHours(0, 0, 0, 0);
                                var diff = Math.floor((today - paidDate) / (1000 * 60 * 60 * 24));
                                return diff > 0 ? diff : 0;
                            },

                            fnAdditionalOverdueFee: function (rental) {
                                var days = this.fnAdditionalOverdueDays(rental);
                                if (days <= 0) return 0;
                                var rentalDays = rental.rentalDays || 1;
                                var feePerDay = Math.floor((rental.pricePerDay || 0) * rentalDays * 0.2);
                                return feePerDay * days;
                            },

                            fnTotalOverdueDue: function (rental) {
                                return (rental.overdueFee || 0) + this.fnAdditionalOverdueFee(rental);
                            },
                            /* ★ 비회원 카드 선택 — 이미 로드된 extensions 즉시 사용 */
                            fnSelectGuestRental: function (rental) {
                                var self = this;

                                self.activeTab = 'extension';
                                self.selectedRental = rental;
                                self.guestRentalId = rental.rentalId;
                                self.pickup.zipcode = rental.returnZipcode || '';
                                self.pickup.address = rental.returnAddress || '';
                                self.pickup.detailedAddress = rental.returnDetailedAddress || '';
                                self.returnHistory = [];

                                // ★ 카드에 이미 로드된 extensions 즉시 반영 (UI 즉시 표시)
                                self.extensions = rental.extensions || [];

                                self.fnLoadGuestAddress();

                                // 백그라운드에서 최신 데이터 재조회
                                self.isDetailLoading = true;
                                $.ajax({
                                    url: '/rental/extension/guest/detail.dox',
                                    type: 'POST', dataType: 'json',
                                    data: { rentalId: rental.rentalId, token: self.guestToken },
                                    success: function (res) {
                                        self.isDetailLoading = false;
                                        if (res.result === 'success') {
                                            self.extensions = res.extensions || [];
                                            self.returnHistory = res.returnHistory || [];
                                        }
                                    },
                                    error: function () { self.isDetailLoading = false; }
                                });
                            },

                            fnClosePanel: function () {
                                this.selectedRental = null;
                                this.extensions = [];
                                this.returnHistory = [];
                                this.extensionDays = 1;
                            },

                            /* ══ 인라인 취소 ════════════════════════════════════════ */
                            fnCancelExtensionInline: function (extensionId, rental) {
                                var self = this;
                                self.fnOpenModal({
                                    title: '연장 신청을 취소하시겠습니까?',
                                    message: '선택한 연장 내역이 취소되고 반납일이 이전으로 돌아갑니다.',
                                    confirmText: '취소하기',
                                    onConfirm: function () {
                                        $.ajax({
                                            url: '/rental/extension/cancel.dox', type: 'POST', dataType: 'json',
                                            data: { extensionId: extensionId, rentalId: rental.rentalId, token: self.guestToken || '' },
                                            success: function (res) {
                                                if (res.result === 'success') {
                                                    self.showToast('연장이 취소되었습니다.');
                                                    self.fnLoadGuestOrderRentals();
                                                } else {
                                                    self.showToast(res.message || '취소 실패');
                                                }
                                            }
                                        });
                                    }
                                });
                            },

                            /* ══ 연장 신청 ══════════════════════════════════════════ */
                            fnApply: function () {
                                var self = this;
                                if (!self.selectedRental) { self.showToast('대여 건을 선택해주세요.'); return; }
                                if (!self.extensionDays || self.extensionDays < 1 || self.extensionDays > 3) {
                                    self.showToast('연장 일수는 최대 3일까지 가능합니다.'); return;
                                }
                                if (self.extensions.length >= 1) {
                                    self.showToast('연장은 1회까지만 가능합니다.'); return;
                                }
                                var expectedPrice = self.fnPrice(self.extensionDays * (self.selectedRental.pricePerDay || 5000));
                                self.fnOpenModal({
                                    title: '대여를 연장하시겠습니까?',
                                    message: '<strong>' + self.extensionDays + '일</strong> 연장됩니다.<br>결제 금액: <strong>' + expectedPrice + '</strong>',
                                    confirmText: '결제하기',
                                    onConfirm: function () {
                                        self.isApplying = true;
                                        var requestData = {
                                            rentalId: self.selectedRental.rentalId,
                                            extensionDays: self.extensionDays,
                                            pricePerDay: self.selectedRental.pricePerDay || 5000
                                        };
                                        if (self.isGuest) {
                                            requestData.token = self.guestToken || '';
                                            requestData.orderId = self.guestOrderId || '';
                                        }
                                        $.ajax({
                                            url: '/rental/extension/payment/ready.dox', type: 'POST', dataType: 'json',
                                            data: requestData,
                                            success: function (res) {
                                                self.isApplying = false;
                                                if (res.result === 'success') {
                                                    if (self.isGuest) {
                                                        sessionStorage.setItem('extGuestToken', self.guestToken || '');
                                                        sessionStorage.setItem('extGuestOrderId', self.guestOrderId || '');
                                                        sessionStorage.setItem('extGuestRentalId', self.selectedRental.rentalId || '');
                                                    }
                                                    var payUrl = '/rental/extension/payment.do'
                                                        + '?extensionOrderId=' + encodeURIComponent(res.extensionOrderId)
                                                        + '&amount=' + encodeURIComponent(res.amount)
                                                        + '&days=' + encodeURIComponent(self.extensionDays)
                                                        + '&productName=' + encodeURIComponent(self.selectedRental.productName || '대여 상품')
                                                        + '&imgUrl=' + encodeURIComponent(self.selectedRental.imgUrl || '');
                                                    if (self.isGuest) {
                                                        payUrl += '&token=' + encodeURIComponent(self.guestToken || '')
                                                            + '&orderId=' + encodeURIComponent(self.guestOrderId || '')
                                                            + '&rentalId=' + encodeURIComponent(self.selectedRental.rentalId || '');
                                                    }
                                                    location.href = payUrl;
                                                } else {
                                                    self.showToast(res.message || '결제 준비에 실패했습니다.');
                                                }
                                            },
                                            error: function () { self.isApplying = false; self.showToast('서버 오류가 발생했습니다.'); }
                                        });
                                    }
                                });
                            },

                            /* ══ 모달 내 연장 취소 ═════════════════════════════════ */
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
                                                    if (self.isGuest) {
                                                        self.fnLoadGuestDetail();
                                                        self.fnLoadGuestOrderRentals();
                                                    } else {
                                                        self.fnSelectRental(self.selectedRental);
                                                        self.fnLoadMemberList();
                                                    }
                                                } else { self.showToast(res.message || '취소에 실패했습니다.'); }
                                            },
                                            error: function () { self.showToast('서버 오류가 발생했습니다.'); }
                                        });
                                    }
                                });
                            },

                            fnApplyReturn: function (rental) {
                                var self = this;

                                var additionalFee = self.fnAdditionalOverdueFee(rental);

                                if (rental.overdueFee > 0 && additionalFee === 0) {
                                    self.fnOpenModal({
                                        title: '반납 신청하시겠습니까?',
                                        message: '이미 연체료(' + self.fnPrice(rental.overdueFee) + ')가 결제된 건입니다.<br>추가 결제 없이 반납 신청이 처리됩니다.',
                                        confirmText: '반납 신청',
                                        onConfirm: function () {
                                        }
                                    });
                                    return;
                                }

                                if (additionalFee > 0) {
                                    var totalDue = self.fnTotalOverdueDue(rental);
                                    self.fnOpenModal({
                                        title: '추가 연체료 결제가 필요합니다',
                                        message: '결제 후 <strong>' + self.fnAdditionalOverdueDays(rental) + '일</strong> 더 경과했습니다.<br>'
                                            + '추가 연체료: <strong>' + self.fnPrice(additionalFee) + '</strong><br>'
                                            + '총 납부액: <strong>' + self.fnPrice(totalDue) + '</strong>',
                                        confirmText: '결제하기',
                                        onConfirm: function () {
                                            self.isApplying = true;
                                            $.ajax({
                                                url: '/rental/extension/overdue/payment/ready.dox',
                                                type: 'POST', dataType: 'json',
                                                data: {
                                                    rentalId: rental.rentalId,
                                                    overdueDays: self.fnAdditionalOverdueDays(rental),
                                                    overdueFee: totalDue,
                                                    zipcode: self.pickup.zipcode,
                                                    address: self.pickup.address,
                                                    detailedAddress: self.pickup.detailedAddress,
                                                    guestName: self.isGuest ? rental.guestName : '',
                                                    guestPhone: self.isGuest ? rental.guestPhone : '',
                                                    token: self.guestToken || ''
                                                },
                                                success: function (res) {
                                                    self.isApplying = false;
                                                    if (res.result === 'success') {
                                                        var payUrl = '/rental/extension/payment.do'
                                                            + '?extensionOrderId=' + encodeURIComponent(res.overdueOrderId)
                                                            + '&amount=' + encodeURIComponent(res.amount)
                                                            + '&days=' + encodeURIComponent(self.fnAdditionalOverdueDays(rental))
                                                            + '&productName=' + encodeURIComponent(rental.productName || '대여 상품')
                                                            + '&imgUrl=' + encodeURIComponent(rental.imgUrl || '')
                                                            + '&type=overdue';
                                                        if (self.isGuest) {
                                                            payUrl += '&token=' + encodeURIComponent(self.guestToken || '')
                                                                + '&orderId=' + encodeURIComponent(self.guestOrderId || '')
                                                                + '&rentalId=' + encodeURIComponent(rental.rentalId || '');
                                                        }
                                                        location.href = payUrl;
                                                    } else {
                                                        self.showToast(res.message || '결제 준비에 실패했습니다.');
                                                    }
                                                },
                                                error: function () { self.isApplying = false; }
                                            });
                                        }
                                    });
                                    return;
                                }

                                var overdueDays = self.fnOverdueDays(rental.returnDate);
                                if (overdueDays >= 3) {
                                    var overdueFeePerDay = Math.floor((rental.pricePerDay * rental.rentalDays) * 0.2);
                                    var totalOverdueFee = overdueFeePerDay * overdueDays;

                                    self.fnOpenModal({
                                        title: '연체료 결제가 필요합니다',
                                        message: '연체 <strong>' + overdueDays + '일</strong> 발생<br>'
                                            + '연체료: <strong>' + self.fnPrice(totalOverdueFee) + '</strong><br>'
                                            + '결제 후 반납 신청이 완료됩니다.',
                                        confirmText: '결제하기',
                                        onConfirm: function () {
                                            self.isApplying = true;
                                            $.ajax({
                                                url: '/rental/extension/overdue/payment/ready.dox',
                                                type: 'POST', dataType: 'json',
                                                data: {
                                                    rentalId: rental.rentalId,
                                                    overdueDays: overdueDays,
                                                    overdueFee: totalOverdueFee,
                                                    zipcode: self.pickup.zipcode,
                                                    address: self.pickup.address,
                                                    detailedAddress: self.pickup.detailedAddress,
                                                    guestName: self.isGuest ? rental.guestName : '',
                                                    guestPhone: self.isGuest ? rental.guestPhone : '',
                                                    token: self.guestToken || ''
                                                },
                                                success: function (res) {
                                                    self.isApplying = false;
                                                    if (res.result === 'success') {
                                                        var payUrl = '/rental/extension/payment.do'
                                                            + '?extensionOrderId=' + encodeURIComponent(res.overdueOrderId)
                                                            + '&amount=' + encodeURIComponent(res.amount)
                                                            + '&days=' + encodeURIComponent(overdueDays)
                                                            + '&productName=' + encodeURIComponent(rental.productName || '대여 상품')
                                                            + '&imgUrl=' + encodeURIComponent(rental.imgUrl || '')
                                                            + '&type=overdue';  // ★ 연체료 결제임을 구분
                                                        if (self.isGuest) {
                                                            payUrl += '&token=' + encodeURIComponent(self.guestToken || '')
                                                                + '&orderId=' + encodeURIComponent(self.guestOrderId || '')
                                                                + '&rentalId=' + encodeURIComponent(rental.rentalId || '');
                                                        }
                                                        location.href = payUrl;
                                                    } else {
                                                        self.showToast(res.message || '결제 준비에 실패했습니다.');
                                                    }
                                                },
                                                error: function () { self.isApplying = false; }
                                            });
                                        }
                                    });
                                    return;  // ★ 여기서 중단, 아래 기존 반납 로직 실행 안 함
                                }
                                self.fnOpenModal({
                                    title: '반납 신청하시겠습니까?',
                                    message: '반납 신청 후 관리자가 확인하여 처리합니다.',
                                    confirmText: '반납 신청',
                                    onConfirm: function () {
                                        self.isApplying = true;

                                        // ✅ 회원/비회원 분기
                                        var url = self.isGuest
                                            ? '/rental/extension/return/guest/apply.dox'
                                            : '/rental/extension/return/apply.dox';

                                        var data = {
                                            rentalId: rental.rentalId,
                                            zipcode: self.pickup.zipcode,
                                            address: self.pickup.address,
                                            detailedAddress: self.pickup.detailedAddress
                                        };

                                        // ✅ 비회원일 때만 추가 파라미터 전송
                                        if (self.isGuest) {
                                            data.token = self.guestToken;
                                            data.orderId = self.guestOrderId;
                                            data.guestName = rental.guestName;
                                            data.guestPhone = rental.guestPhone;
                                        }

                                        $.ajax({
                                            url: url, type: 'POST', dataType: 'json', data: data,
                                            success: function (res) {
                                                self.isApplying = false;
                                                self.showToast(res.message || '완료');
                                                if (res.result === 'success') {
                                                    self.fnClosePanel();
                                                    self.isGuest ? self.fnLoadGuestOrderRentals() : self.fnLoadMemberList();
                                                }
                                            },
                                            error: function () { self.isApplying = false; }
                                        });
                                    }
                                });
                            },

                            /* ══ 반납 취소 ══════════════════════════════════════════ */
                            fnCancelReturn: function (rental) {
                                var self = this;
                                if (!rental || rental.rentalStatus !== 'RETURN_REQUESTED') {
                                    self.showToast('반납 요청 상태에서만 취소할 수 있습니다.'); return;
                                }
                                self.isApplying = true;
                                var url = self.isGuest ? '/rental/extension/return/guest/cancel.dox' : '/rental/extension/return/cancel.dox';
                                var data = { rentalId: rental.rentalId };
                                if (self.isGuest) { data.token = self.guestToken; data.guestName = rental.guestName; data.guestPhone = rental.guestPhone; }
                                $.ajax({
                                    url: url, type: 'POST', dataType: 'json', data: data,
                                    success: function (res) {
                                        self.isApplying = false;
                                        if (res.result === 'success') {
                                            self.showToast(res.message || '반납 요청이 취소되었습니다.');
                                            self.fnClosePanel();
                                            self.isGuest ? self.fnLoadGuestOrderRentals() : self.fnLoadMemberList();
                                        } else { self.showToast(res.message || '반납 요청 취소에 실패했습니다.'); }
                                    },
                                    error: function () { self.isApplying = false; self.showToast('서버 오류가 발생했습니다.'); }
                                });
                            },

                            /* ══ 유틸 ═══════════════════════════════════════════════ */
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
                                    RETURNED: '반납완료', RETURN_COMPLETED: '반납완료', CANCELLED: '취소완료',
                                    CANCEL_REQUESTED: '취소신청'
                                };
                                return map[s] || s || '-';
                            },

                            fnPrice: function (v) { return Number(v || 0).toLocaleString() + '원'; },
                            fnCanExtension: function (s, returnDate) {
                                if (!['PAID', 'READY', 'SHIPPING', 'DONE', 'IN_USE'].includes(s)) return false;
                                if (returnDate && this.fnIsOverdue(returnDate)) return false;
                                return true;
                            }, fnCanReturn: function (s) { return s === 'IN_USE'; },
                            fnIsOverdue: function (returnDate) {
                                if (!returnDate) return false;
                                var today = new Date(); today.setHours(0, 0, 0, 0);
                                var target = new Date(String(returnDate).replace(' ', 'T')); target.setHours(0, 0, 0, 0);
                                return today > target;
                            },

                            fnOverdueDays: function (returnDate) {
                                if (!returnDate) return 0;
                                var today = new Date(); today.setHours(0, 0, 0, 0);
                                var target = new Date(String(returnDate).replace(' ', 'T')); target.setHours(0, 0, 0, 0);
                                var diff = Math.floor((today - target) / (1000 * 60 * 60 * 24));
                                return diff > 0 ? diff : 0;
                            },

                            fnOverdueFee: function (rental) {
                                var days = this.fnOverdueDays(rental.returnDate);
                                if (days < 3) return 0;
                                var rentalDays = rental.rentalDays || 1;
                                var totalRentalPrice = (rental.pricePerDay || 0) * rentalDays;
                                return Math.floor(totalRentalPrice * 0.2) * days;
                            },
                            fnDateTime: function (v) {
                                if (!v) return '-';
                                var d = new Date(String(v).replace(' ', 'T'));
                                if (isNaN(d.getTime())) return String(v);
                                var pad = function (n) { return String(n).padStart(2, '0'); };
                                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                                    + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
                            },

                            fnOpenModal: function (opt) {
                                this.modal.show = true;
                                this.modal.title = opt.title || '확인';
                                this.modal.message = opt.message || '';
                                this.modal.confirmText = opt.confirmText || '확인';
                                this.modal.onConfirm = opt.onConfirm || null;
                            },
                            fnCloseModal: function () { this.modal.show = false; this.modal.onConfirm = null; },
                            fnModalConfirm: function () {
                                var cb = this.modal.onConfirm;
                                this.fnCloseModal();
                                if (typeof cb === 'function') cb();
                            },

                            fnReloadGuestOrderList: function () { this.fnLoadGuestOrderRentals(); },
                        },

                        mounted: function () { this.fnInit(); }
                    }).mount('#app');
                </script>

    </body>

    </html>