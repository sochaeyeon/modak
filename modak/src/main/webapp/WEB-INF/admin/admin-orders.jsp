<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ page deferredSyntaxAllowedAsLiteral="true" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>주문 관리 - 모닥모닥 Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-orders.css">
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            </head>

            <body>
                <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

                    <div id="app" class="admin-main">
                        <div class="order-page-container">

                            <!-- 헤더 -->
                            <div class="order-header">
                                <div class="order-title">📦 주문 / 반납 관리</div>
                                <button @click="fnGoDashboard" class="o-btn-back">
                                    <span>🏠</span> 대시보드로 돌아가기
                                </button>
                            </div>

                            <!-- ★ 탭 바 -->
                            <div class="o-tab-bar">
                                <button class="o-tab-btn" :class="{ active: activeTab === 'orders' }"
                                    @click="switchTab('orders')">
                                    🧾 주문 내역
                                </button>
                                <button class="o-tab-btn" :class="{ active: activeTab === 'returns' }"
                                    @click="switchTab('returns')">
                                    📦 반납 요청
                                    <span class="o-tab-badge" v-if="returnCount > 0">{{ returnCount }}</span>
                                </button>
                                <button class="o-tab-btn" :class="{ active: activeTab === 'delivery' }"
                                    @click="switchTab('delivery')">
                                    🚚 배송 등록
                                </button>
                            </div>

                            <!-- ══ 주문 내역 탭 ══ -->
                            <div v-if="activeTab === 'orders'" class="order-card">
                                <table class="order-table">
                                    <thead>
                                        <tr>
                                            <th style="width:8%;">주문번호</th>
                                            <th style="width:12%;">주문자 ID</th>
                                            <th style="text-align:left;">주문 상품 정보</th>
                                            <th style="width:15%;">총 결제금액</th>
                                            <th style="width:18%;">주문 일시</th>
                                            <th style="width:15%;">진행 상태 설정</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-if="orderList.length === 0">
                                            <td colspan="6" style="padding:40px;color:var(--o-text-muted);">주문 내역이 없습니다.
                                            </td>
                                        </tr>
                                        <tr v-for="order in orderList" :key="order.ORDER_ID">
                                            <td class="order-id">#{{ order.ORDER_ID }}</td>
                                            <td>{{ order.USER_ID }}</td>
                                            <td class="prod-info-td">
                                                <div class="order-img-box">
                                                    <img v-if="order.IMG_URL" :src="order.IMG_URL">
                                                    <div v-else
                                                        style="display:flex;justify-content:center;align-items:center;height:100%;font-size:12px;">
                                                        🏕️</div>
                                                </div>
                                                <div style="font-weight:500;">{{ order.PRODUCT_NAME }}</div>
                                            </td>
                                            <td class="order-price">{{ formatPrice(order.TOTAL_PRICE) }}원</td>
                                            <td class="order-date">{{ order.CREATED_AT }}</td>
                                            <td>
                                                <select class="o-select" v-model="order.ORDER_STATUS"
                                                    @change="fnUpdateStatus(order)">
                                                    <option value="PAID">✅ 결제완료</option>
                                                    <option value="READY">📦 상품준비중</option>
                                                    <option value="SHIPPING">🚚 배송중</option>
                                                    <option value="DELIVERED">🚩 배송완료</option>
                                                    <option value="CANCELLED">❌ 주문취소</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 배송 등록 탭 -->
                            <div v-if="activeTab === 'delivery'" class="order-card" style="padding:28px;">
                                <div style="font-size:15px;font-weight:700;color:#fff;margin-bottom:24px;">🚚 운송장 번호 등록
                                </div>

                                <div
                                    style="display:grid;grid-template-columns:1fr 1fr auto;gap:12px;align-items:end;max-width:700px;">
                                    <div>
                                        <label
                                            style="font-size:11px;color:var(--o-text-muted);display:block;margin-bottom:6px;">주문번호</label>
                                        <input class="o-input" v-model="delivery.orderId" placeholder="주문번호 입력"
                                            type="text">
                                    </div>
                                    <div>
                                        <label
                                            style="font-size:11px;color:var(--o-text-muted);display:block;margin-bottom:6px;">운송장
                                            번호</label>
                                        <input class="o-input" v-model="delivery.trackingNo" placeholder="운송장 번호 입력"
                                            type="text" @keyup.enter="fnRegisterDelivery">
                                    </div>
                                    <button class="o-action-btn pickup" style="height:42px;width:100px;"
                                        @click="fnRegisterDelivery" :disabled="isDelivering">
                                        {{ isDelivering ? '처리중...' : '등록' }}
                                    </button>
                                </div>

                                <!-- 결과 표시 -->
                                <div v-if="deliveryResult" class="delivery-result-box" :class="deliveryResult.type">
                                    <span>{{ deliveryResult.message }}</span>
                                </div>

                                <!-- 최근 등록 내역 -->
                                <div style="margin-top:32px;">
                                    <div style="font-size:13px;color:var(--o-text-muted);margin-bottom:12px;">최근 배송 등록
                                        내역</div>
                                    <table class="order-table">
                                        <thead>
                                            <tr>
                                                <th>주문번호</th>
                                                <th>주문자</th>
                                                <th style="text-align:left;">상품명</th>
                                                <th>운송장번호</th>
                                                <th>출고일시</th>
                                                <th>배송상태</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-if="deliveryList.length === 0">
                                                <td colspan="6" style="padding:40px;color:var(--o-text-muted);">등록된 배송
                                                    내역이 없습니다.</td>
                                            </tr>
                                            <tr v-for="d in deliveryList" :key="d.DELIVERY_ID">
                                                <td class="order-id">#{{ d.ORDER_ID }}</td>
                                                <td>{{ d.USER_ID }}</td>
                                                <td class="prod-info-td">
                                                    <div>{{ d.PRODUCT_NAME }}</div>
                                                </td>
                                                <td style="font-family:monospace;color:var(--o-accent);">{{
                                                    d.TRACKING_NO }}</td>
                                                <td class="order-date">{{ d.SHIPPED_AT }}</td>
                                                <td>
                                                    <span class="o-status-badge rs-RETURN_PICKED">배송중</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- ══ 반납 요청 탭 ══ -->
                            <div v-if="activeTab === 'returns'" class="order-card">

                                <!-- 필터 바 -->
                                <div class="return-filter-bar">
                                    <button class="o-filter-btn" :class="{ active: returnFilter === 'ALL' }"
                                        @click="fnSetReturnFilter('ALL')">전체</button>
                                    <button class="o-filter-btn"
                                        :class="{ active: returnFilter === 'RETURN_REQUESTED' }"
                                        @click="fnSetReturnFilter('RETURN_REQUESTED')">반납요청</button>
                                    <button class="o-filter-btn" :class="{ active: returnFilter === 'RETURN_PICKED' }"
                                        @click="fnSetReturnFilter('RETURN_PICKED')">수거중</button>
                                    <button class="o-filter-btn"
                                        :class="{ active: returnFilter === 'RETURN_COMPLETED' }"
                                        @click="fnSetReturnFilter('RETURN_COMPLETED')">반납완료</button>
                                    <span class="return-total">총 <strong>{{ filteredReturnList.length
                                            }}</strong>건</span>
                                </div>

                                <table class="order-table">
                                    <thead>
                                        <tr>
                                            <th style="width:7%;">대여번호</th>
                                            <th style="width:10%;">고객</th>
                                            <th style="text-align:left;">상품</th>
                                            <th style="width:14%;">대여기간</th>
                                            <th style="width:20%;">회수 주소</th>
                                            <th style="width:13%;">반납 신청일</th>
                                            <th style="width:13%;">상태 변경</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-if="filteredReturnList.length === 0">
                                            <td colspan="7" style="padding:40px;color:var(--o-text-muted);">반납 요청 내역이
                                                없습니다.</td>
                                        </tr>
                                        <tr v-for="item in filteredReturnList" :key="item.RENTAL_ID">
                                            <td class="order-id">#{{ item.RENTAL_ID }}</td>
                                            <td>
                                                <div style="font-weight:600;color:#fff;">{{ item.USER_ID === 'GUEST' ?
                                                    item.GUEST_NAME : item.USER_ID }}</div>
                                                <div style="font-size:11px;color:var(--o-text-muted);"
                                                    v-if="item.USER_ID === 'GUEST'">{{ item.GUEST_PHONE }}</div>
                                                <div style="font-size:10px;color:var(--o-accent);margin-top:2px;"
                                                    v-if="item.USER_ID === 'GUEST'">비회원</div>
                                            </td>
                                            <td class="prod-info-td">
                                                <div class="order-img-box">
                                                    <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                                    <div v-else
                                                        style="display:flex;justify-content:center;align-items:center;height:100%;font-size:12px;">
                                                        🏕️</div>
                                                </div>
                                                <div>
                                                    <div style="font-weight:500;">{{ item.PRODUCT_NAME }}</div>
                                                    <div
                                                        style="font-size:11px;color:var(--o-text-muted);margin-top:2px;">
                                                        아이템ID: {{ item.ITEM_ID }}</div>
                                                </div>
                                            </td>
                                            <td style="font-size:12px;color:var(--o-text-muted);">
                                                {{ item.START_DATE }} ~<br>{{ item.RETURN_DATE }}
                                            </td>
                                            <td>
                                                <div v-if="item.RETURN_ADDRESS" style="font-size:12px;line-height:1.5;">
                                                    <div style="color:var(--o-text-muted);font-size:10px;">[{{
                                                        item.RETURN_ZIPCODE }}]</div>
                                                    <div>{{ item.RETURN_ADDRESS }}</div>
                                                    <div style="color:var(--o-text-muted);">{{
                                                        item.RETURN_DETAILED_ADDRESS }}</div>
                                                </div>
                                                <div v-else style="color:var(--o-text-muted);font-size:12px;">주소 없음
                                                </div>
                                            </td>
                                            <td style="font-size:12px;color:var(--o-text-muted);">{{
                                                item.RETURN_REQUESTED_AT }}</td>
                                            <td>
                                                <div style="display:flex;flex-direction:column;gap:6px;">
                                                    <span class="o-status-badge" :class="'rs-' + item.RENTAL_STATUS">
                                                        {{ fnReturnStatusText(item.RENTAL_STATUS) }}
                                                    </span>
                                                    <!-- RETURN_REQUESTED → 수거중 -->
                                                    <button v-if="item.RENTAL_STATUS === 'RETURN_REQUESTED'"
                                                        class="o-action-btn pickup"
                                                        @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">
                                                        🚚 수거 시작
                                                    </button>
                                                    <!-- RETURN_PICKED → 반납 완료 -->
                                                    <button v-if="item.RENTAL_STATUS === 'RETURN_PICKED'"
                                                        class="o-action-btn complete"
                                                        @click="fnUpdateReturnStatus(item, 'RETURN_COMPLETED')">
                                                        ✅ 반납 완료
                                                    </button>
                                                    <!-- 반납완료 → 되돌리기 (선택사항) -->
                                                    <button v-if="item.RENTAL_STATUS === 'RETURN_COMPLETED'"
                                                        class="o-action-btn cancel"
                                                        @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">
                                                        ↩ 수거중으로
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    activeTab: 'orders',
                                    // 주문
                                    orderList: [],
                                    page: 1, pageSize: 15,
                                    // 반납
                                    returnList: [],
                                    returnFilter: 'ALL',
                                    delivery: { orderId: '', trackingNo: '' },
                                    deliveryResult: null,
                                    isDelivering: false,
                                    deliveryList: []
                                };
                            },
                            computed: {
                                returnCount() {
                                    return this.returnList.filter(r => r.RENTAL_STATUS === 'RETURN_REQUESTED').length;
                                },
                                filteredReturnList() {
                                    if (this.returnFilter === 'ALL') return this.returnList;
                                    return this.returnList.filter(r => r.RENTAL_STATUS === this.returnFilter);
                                }
                            },
                            methods: {
                                /* ── 탭 전환 ── */
                                switchTab(tab) {
                                    this.activeTab = tab;
                                    if (tab === 'returns' && this.returnList.length === 0) {
                                        this.fnGetReturnList();
                                        
                                    }
                                    if (tab === 'delivery' && this.deliveryList.length === 0) this.fnGetDeliveryList(); 
                                },

                                /* ── 주문 목록 ── */
                                fnGetList() {
                                    const self = this;
                                    $.ajax({
                                        url: '/admin/order/list.dox', type: 'POST',
                                        data: { page: self.page, pageSize: self.pageSize },
                                        success(data) {
                                            if (data.result === 'success') self.orderList = data.list;
                                        }
                                    });
                                },

                                /* ── 주문 상태 변경 ── */
                                fnUpdateStatus(order) {
                                    $.ajax({
                                        url: '/admin/order/update-status.dox', type: 'POST',
                                        data: { orderId: order.ORDER_ID, status: order.ORDER_STATUS },
                                        success(res) { if (res.result !== 'success') alert('상태 변경 실패'); }
                                    });
                                },

                                /* ── 반납 요청 목록 ── */
                                fnGetReturnList() {
                                    const self = this;
                                    $.ajax({
                                        url: '/admin/rental/return/list.dox', type: 'POST',
                                        success(res) {
                                            if (res.result === 'success') self.returnList = res.list;
                                        }
                                    });
                                },

                                /* ── 반납 상태 변경 ── */
                                fnUpdateReturnStatus(item, newStatus) {
                                    const self = this;
                                    const labels = {
                                        RETURN_PICKED: '수거를 시작하시겠습니까?',
                                        RETURN_COMPLETED: '반납 완료 처리하시겠습니까?',
                                        IN_USE: '반납 요청을 취소하시겠습니까?'
                                    };
                                    if (!confirm(labels[newStatus] || '상태를 변경하시겠습니까?')) return;

                                    $.ajax({
                                        url: '/admin/rental/return/update-status.dox', type: 'POST',
                                        data: { rentalId: item.RENTAL_ID, status: newStatus },
                                        success(res) {
                                            if (res.result === 'success') {
                                                item.RENTAL_STATUS = newStatus;
                                            } else {
                                                alert(res.message || '상태 변경에 실패했습니다.');
                                            }
                                        }
                                    });
                                },

                                fnSetReturnFilter(f) { this.returnFilter = f; },
                                fnRegisterDelivery() {
                                    const self = this;
                                    if (!self.delivery.orderId) { self.deliveryResult = { type: 'error', message: '주문번호를 입력하세요.' }; return; }
                                    if (!self.delivery.trackingNo) { self.deliveryResult = { type: 'error', message: '운송장 번호를 입력하세요.' }; return; }

                                    self.isDelivering = true;
                                    self.deliveryResult = null;

                                    $.ajax({
                                        url: '/admin/delivery/register.dox', type: 'POST',
                                        data: { orderId: self.delivery.orderId, trackingNo: self.delivery.trackingNo },
                                        success(res) {
                                            self.isDelivering = false;
                                            if (res.result === 'success') {
                                                self.deliveryResult = { type: 'success', message: '✅ 배송 등록 완료! 주문상태가 배송중으로 변경되었습니다.' };
                                                self.delivery.orderId = '';
                                                self.delivery.trackingNo = '';
                                                self.fnGetDeliveryList();  // 목록 갱신
                                            } else {
                                                self.deliveryResult = { type: 'error', message: '❌ ' + (res.message || '등록 실패') };
                                            }
                                        },
                                        error() { self.isDelivering = false; self.deliveryResult = { type: 'error', message: '서버 오류' }; }
                                    });
                                },

                                fnGetDeliveryList() {
                                    $.ajax({
                                        url: '/admin/delivery/list.dox', type: 'POST',
                                        success: (res) => { if (res.result === 'success') this.deliveryList = res.list; }
                                    });
                                },

                                /* ── 유틸 ── */
                                formatPrice(val) { return Number(val || 0).toLocaleString(); },

                                fnReturnStatusText(s) {
                                    const map = {
                                        RETURN_REQUESTED: '반납요청',
                                        RETURN_PICKED: '수거중',
                                        RETURN_COMPLETED: '반납완료',
                                        IN_USE: '대여중',
                                        RESERVED: '예약완료'
                                    };
                                    return map[s] || s || '-';
                                },

                                fnGoDashboard() { location.href = '/admin/dashboard.do'; }
                            },
                            mounted() { this.fnGetList(); }
                        }).mount('#app');
                    </script>
            </body>

            </html>