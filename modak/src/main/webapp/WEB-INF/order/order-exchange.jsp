<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>교환 신청 - 모닥모닥</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/order/order-exchange.css">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    </head>

    <body>

        <%@ include file="/WEB-INF/common/header.jsp" %>

            <div id="app" v-cloak>
                <div class="exchange-page">

                    <!-- 헤더 -->
                    <p class="page-eyebrow">ORDER EXCHANGE</p>
                    <h1 class="page-title">교환 신청</h1>
                    <p class="page-desc">구매하신 상품을 교환하실 수 있어요. 아래 정보를 입력해 주세요.</p>

                    <!-- 스텝 바 -->
                    <div class="step-bar">
                        <div class="step" :class="{ active: currentStep >= 1, done: currentStep > 1 }">
                            <div class="step-dot">{{ currentStep > 1 ? '✓' : '1' }}</div>
                            <span>교환 사유</span>
                        </div>
                        <div class="step-line"></div>
                        <div class="step" :class="{ active: currentStep >= 2, done: currentStep > 2 }">
                            <div class="step-dot">{{ currentStep > 2 ? '✓' : '2' }}</div>
                            <span>회수 주소</span>
                        </div>
                        <div class="step-line"></div>
                        <div class="step" :class="{ active: currentStep >= 3 }">
                            <div class="step-dot">3</div>
                            <span>최종 확인</span>
                        </div>
                    </div>

                    <!-- 로딩 -->
                    <div v-if="isLoading" class="section-card">
                        <div class="spinner"></div>
                    </div>

                    <template v-else>

                        <!-- ══ STEP 1: 교환 사유 ══ -->
                        <template v-if="currentStep === 1">

                            <!-- 주문 상품 정보 -->
                            <div class="section-card">
                                <div class="section-head">
                                    <h3>교환 상품</h3>
                                    <span class="head-badge">주문번호 {{ orderId }}</span>
                                </div>
                                <div class="section-body">
                                    <div class="order-product-card" v-if="orderInfo">
                                        <div class="op-thumb">
                                            <img v-if="orderInfo.imgUrl" :src="orderInfo.imgUrl"
                                                :alt="orderInfo.productName">
                                            <span v-else>🛒</span>
                                        </div>
                                        <div class="op-info">
                                            <p class="op-name">{{ orderInfo.productName || '상품명 없음' }}</p>
                                            <p class="op-meta">수량 {{ orderInfo.count || 1 }}개</p>
                                            <p class="op-meta" v-if="orderInfo.optionName">옵션: {{ orderInfo.optionName
                                                }}</p>
                                        </div>
                                        <div class="op-price">{{ fnPrice(orderInfo.price) }}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 교환 사유 선택 -->
                            <div class="section-card">
                                <div class="section-head">
                                    <h3>교환 사유 선택</h3>
                                    <span class="head-badge">필수</span>
                                </div>
                                <div class="section-body">
                                    <div class="reason-grid">
                                        <div v-for="r in reasonList" :key="r.value" class="reason-chip"
                                            :class="{ active: selectedReason === r.value }"
                                            @click="selectedReason = r.value">
                                            <span class="chip-icon">{{ r.icon }}</span>
                                            {{ r.label }}
                                        </div>
                                    </div>

                                    <!-- 직접 입력 -->
                                    <div v-if="selectedReason === 'OTHER' || selectedReason">
                                        <label class="form-label" style="margin-top:6px;">
                                            상세 사유
                                            <span style="color:var(--brown4);font-weight:300;"> (선택)</span>
                                        </label>
                                        <textarea class="reason-textarea" v-model="reasonDetail"
                                            :placeholder="selectedReason === 'OTHER' ? '교환 사유를 직접 입력해 주세요.' : '추가로 전달할 내용이 있으면 입력해 주세요.'"
                                            maxlength="300" @input="fnCountChar">
                            </textarea>
                                        <div class="char-count">{{ reasonDetail.length }} / 300</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 교환 방법 -->
                            <div class="section-card">
                                <div class="section-head">
                                    <h3>교환 방법</h3>
                                    <span class="head-badge">필수</span>
                                </div>
                                <div class="section-body">
                                    <div class="method-grid">
                                        <div class="method-card" :class="{ active: exchangeMethod === 'PICKUP' }"
                                            @click="exchangeMethod = 'PICKUP'">
                                            <div class="method-icon">🚚</div>
                                            <div class="method-name">택배 회수</div>
                                            <div class="method-desc">기사님이 방문하여 수거</div>
                                        </div>
                                        <div class="method-card" :class="{ active: exchangeMethod === 'DIRECT' }"
                                            @click="exchangeMethod = 'DIRECT'">
                                            <div class="method-icon">📦</div>
                                            <div class="method-name">직접 발송</div>
                                            <div class="method-desc">고객 직접 택배 발송</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </template>

                        <!-- ══ STEP 2: 회수 주소 ══ -->
                        <template v-if="currentStep === 2">

                            <div class="section-card">
                                <div class="section-head">
                                    <h3>회수 주소</h3>
                                    <span class="head-badge">필수</span>
                                </div>
                                <div class="section-body">

                                    <div class="form-group">
                                        <label class="form-label">우편번호</label>
                                        <div class="zipcode-row">
                                            <input type="text" class="form-input" v-model="pickup.zipcode" readonly
                                                placeholder="우편번호">
                                            <button type="button" class="btn-search-addr" @click="fnSearchAddr">주소
                                                검색</button>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">주소</label>
                                        <input type="text" class="form-input" v-model="pickup.address" readonly
                                            placeholder="주소 검색을 눌러주세요">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">상세 주소</label>
                                        <input type="text" class="form-input" v-model="pickup.detailAddress"
                                            ref="detailAddrInput" placeholder="상세 주소를 입력해 주세요">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">회수 요청 사항</label>
                                        <input type="text" class="form-input" v-model="pickup.memo"
                                            placeholder="예: 문 앞에 놓아주세요 (선택)">
                                    </div>

                                    <!-- 택배 직접 발송 안내 -->
                                    <div v-if="exchangeMethod === 'DIRECT'" class="notice-box" style="margin-top:4px;">
                                        <p style="font-weight:700;color:var(--brown2);margin-bottom:6px;">📦 직접 발송 안내
                                        </p>
                                        <ul>
                                            <li>아래 주소로 상품을 보내주세요.</li>
                                            <li>발송 택배사: 자유 선택</li>
                                            <li>반송 주소: 서울시 강남구 테헤란로 123 모닥모닥 물류센터</li>
                                            <li>발송 후 운송장 번호를 고객센터로 알려주세요.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                        </template>

                        <!-- ══ STEP 3: 최종 확인 ══ -->
                        <template v-if="currentStep === 3">

                            <div class="section-card">
                                <div class="section-head">
                                    <h3>신청 내용 확인</h3>
                                </div>
                                <div class="section-body">

                                    <!-- 상품 -->
                                    <div style="margin-bottom:20px;">
                                        <p class="form-label">교환 상품</p>
                                        <div class="order-product-card" v-if="orderInfo">
                                            <div class="op-thumb">
                                                <img v-if="orderInfo.imgUrl" :src="orderInfo.imgUrl">
                                                <span v-else>🛒</span>
                                            </div>
                                            <div class="op-info">
                                                <p class="op-name">{{ orderInfo.productName }}</p>
                                                <p class="op-meta">수량 {{ orderInfo.count || 1 }}개</p>
                                            </div>
                                            <div class="op-price">{{ fnPrice(orderInfo.price) }}</div>
                                        </div>
                                    </div>

                                    <!-- 요약 테이블 -->
                                    <table style="width:100%;border-collapse:collapse;font-size:13px;">
                                        <tr style="border-bottom:1px solid var(--cream2);">
                                            <td style="padding:12px 0;color:var(--brown4);width:120px;font-weight:600;">
                                                교환 사유</td>
                                            <td style="padding:12px 0;color:var(--brown);font-weight:500;">{{
                                                fnReasonLabel(selectedReason) }}</td>
                                        </tr>
                                        <tr style="border-bottom:1px solid var(--cream2);" v-if="reasonDetail">
                                            <td style="padding:12px 0;color:var(--brown4);font-weight:600;">상세 사유</td>
                                            <td style="padding:12px 0;color:var(--brown3);">{{ reasonDetail }}</td>
                                        </tr>
                                        <tr style="border-bottom:1px solid var(--cream2);">
                                            <td style="padding:12px 0;color:var(--brown4);font-weight:600;">교환 방법</td>
                                            <td style="padding:12px 0;color:var(--brown);font-weight:500;">
                                                {{ exchangeMethod === 'PICKUP' ? '🚚 택배 회수' : '📦 직접 발송' }}
                                            </td>
                                        </tr>
                                        <tr v-if="exchangeMethod === 'PICKUP'">
                                            <td style="padding:12px 0;color:var(--brown4);font-weight:600;">회수 주소</td>
                                            <td style="padding:12px 0;color:var(--brown3);">
                                                ({{ pickup.zipcode }}) {{ pickup.address }} {{ pickup.detailAddress }}
                                                <span v-if="pickup.memo"
                                                    style="display:block;font-size:11px;color:var(--brown4);margin-top:2px;">
                                                    요청사항: {{ pickup.memo }}
                                                </span>
                                            </td>
                                        </tr>
                                    </table>

                                    <!-- 안내 -->
                                    <div class="notice-box" style="margin-top:20px;">
                                        <ul>
                                            <li>교환 신청 후 영업일 1~3일 내 처리됩니다.</li>
                                            <li>교환 상품은 동일 상품으로만 가능합니다.</li>
                                            <li>상품 수령 후 7일 이내만 교환 신청 가능합니다.</li>
                                            <li>고객 변심의 경우 왕복 배송비가 부과될 수 있습니다.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                        </template>

                    </template><!-- /template v-else -->

                    <!-- 하단 버튼 -->
                    <div class="bottom-actions" v-if="!isLoading">
                        <button class="btn-cancel" @click="fnPrev">
                            {{ currentStep === 1 ? '← 돌아가기' : '← 이전' }}
                        </button>
                        <button class="btn-submit" :disabled="!fnCanNext()" @click="fnNext">
                            {{ currentStep === 3 ? '교환 신청 완료' : '다음 →' }}
                        </button>
                    </div>

                </div><!-- /exchange-page -->

                <!-- 완료 모달 -->
                <div class="modal-backdrop" v-if="modal.show" @click.self="fnCloseModal">
                    <div class="modal-box">
                        <div class="modal-icon">🎉</div>
                        <div class="modal-title">교환 신청 완료!</div>
                        <div class="modal-desc">
                            교환 신청이 접수되었습니다.<br>
                            영업일 1~3일 내로 처리 결과를 안내드립니다.
                        </div>
                        <div class="modal-actions">
                            <button class="modal-cancel" @click="fnGoHistory">주문내역 보기</button>
                            <button class="modal-confirm" @click="fnGoMain">메인으로</button>
                        </div>
                    </div>
                </div>

                <div class="toast" id="toast"></div>

            </div><!-- /#app -->

            <%@ include file="/WEB-INF/common/footer.jsp" %>

                <script>
                    var app = Vue.createApp({
                        data: function () {
                            return {
                                orderId: new URLSearchParams(location.search).get('orderId') || '',
                                token: new URLSearchParams(location.search).get('token') || '',
                                isLoading: false,
                                isSubmitting: false,
                                currentStep: 1,

                                orderInfo: null,

                                /* 교환 사유 */
                                selectedReason: '',
                                reasonDetail: '',
                                reasonList: [
                                    { value: 'DEFECT', icon: '🔧', label: '상품 불량/파손' },
                                    { value: 'WRONG', icon: '❌', label: '오배송' },
                                    { value: 'DIFF', icon: '📦', label: '상품 설명 상이' },
                                    { value: 'SIZE', icon: '📏', label: '사이즈/색상 변경' },
                                    { value: 'MIND', icon: '💭', label: '단순 변심' },
                                    { value: 'OTHER', icon: '✏️', label: '기타 (직접 입력)' },
                                ],

                                /* 교환 방법 */
                                exchangeMethod: 'PICKUP',

                                /* 회수 주소 */
                                pickup: {
                                    zipcode: '',
                                    address: '',
                                    detailAddress: '',
                                    memo: ''
                                },

                                modal: { show: false }
                            };
                        },

                        methods: {
                            /* ── 초기 데이터 로드 ── */
                            fnInit: function () {
                                var params = new URLSearchParams(location.search);
                                this.orderId = params.get('orderId') || '';

                                if (!this.orderId) {
                                    this.fnShowToast('잘못된 접근입니다.');
                                    return;
                                }

                                var self = this;
                                this.isLoading = true;

                                $.ajax({
                                    url: '/order/exchange/info.dox',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: { orderId: self.orderId },
                                    success: function (res) {
                                        self.isLoading = false;

                                        if (res.result === 'success') {
                                            self.orderInfo = res.orderInfo;

                                            // ⭐ 기본 주소 자동 세팅
                                            if (res.defaultAddress) {
                                                self.pickup.zipcode = res.defaultAddress.zipcode;
                                                self.pickup.address = res.defaultAddress.address;
                                                self.pickup.detailAddress = res.defaultAddress.detailedAddress;
                                            }

                                        } else {
                                            self.fnShowToast(res.message);
                                        }
                                    }
                                });
                            },

                            fnSubmit: function () {
                                if (this.isSubmitting) return;

                                this.isSubmitting = true;

                                var self = this;
                                var isGuest = !!self.token;

                                var url = isGuest
                                    ? '/order/guest/exchange.dox'
                                    : '/order/exchange/apply.dox';

                                var data = {
                                    orderId: self.orderId,
                                    exchangeReason: self.selectedReason,
                                    reasonDetail: self.reasonDetail,
                                    exchangeMethod: self.exchangeMethod,
                                    zipcode: self.pickup.zipcode,
                                    address: self.pickup.address,
                                    detailAddress: self.pickup.detailAddress,
                                    detailedAddress: self.pickup.detailAddress,
                                    memo: self.pickup.memo
                                };

                                if (isGuest) {
                                    data.token = self.token;
                                }

                                $.ajax({
                                    url: url,
                                    type: 'POST',
                                    dataType: 'json',
                                    data: data,
                                    success: function (res) {
                                        self.isSubmitting = false;

                                        if (res.result === 'success') {
                                            self.modal.show = true;
                                        } else {
                                            self.fnShowToast(res.message || '교환 신청 실패');
                                        }
                                    },
                                    error: function () {
                                        self.isSubmitting = false;
                                        self.fnShowToast('서버 오류');
                                    }
                                });
                            },
                            /* ── 주소 검색 ── */
                            fnSearchAddr: function () {
                                var self = this;
                                new daum.Postcode({
                                    oncomplete: function (data) {
                                        var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                                        self.pickup.zipcode = data.zonecode;
                                        self.pickup.address = addr;
                                        self.$nextTick(function () {
                                            if (self.$refs.detailAddrInput) self.$refs.detailAddrInput.focus();
                                        });
                                    }
                                }).open();
                            },

                            /* ── 스텝 이동 ── */
                            fnCanNext: function () {
                                if (this.currentStep === 1) return !!this.selectedReason && !!this.exchangeMethod;
                                if (this.currentStep === 2) {
                                    if (this.exchangeMethod === 'PICKUP') return !!this.pickup.address && !!this.pickup.detailAddress;
                                    return true;
                                }
                                return true;
                            },

                            fnNext: function () {
                                if (!this.fnCanNext()) { this.fnShowToast('필수 항목을 입력해 주세요.'); return; }
                                if (this.currentStep < 3) {
                                    this.currentStep++;
                                    window.scrollTo({ top: 0, behavior: 'smooth' });
                                } else {
                                    this.fnSubmit();
                                }
                            },

                            fnPrev: function () {
                                if (this.currentStep > 1) {
                                    this.currentStep--;
                                    window.scrollTo({ top: 0, behavior: 'smooth' });
                                } else {
                                    history.back();
                                }
                            },


                            /* ── 유틸 ── */
                            fnReasonLabel: function (val) {
                                var r = this.reasonList.find(function (r) { return r.value === val; });
                                return r ? r.icon + ' ' + r.label : '-';
                            },

                            fnPrice: function (v) { return Number(v || 0).toLocaleString() + '원'; },

                            fnCountChar: function () {
                                if (this.reasonDetail.length > 300) this.reasonDetail = this.reasonDetail.slice(0, 300);
                            },

                            fnShowToast: function (msg) {
                                var t = document.getElementById('toast');
                                if (!t) return;
                                t.textContent = msg;
                                t.classList.add('show');
                                setTimeout(function () { t.classList.remove('show'); }, 2400);
                            },

                            fnCloseModal: function () { this.modal.show = false; },
                            fnGoHistory: function () { location.href = '/order/history.do'; },
                            fnGoMain: function () { location.href = '/main.do'; }
                        },

                        mounted: function () { this.fnInit(); }
                    });

                    app.mount('#app');
                </script>

    </body>

    </html>