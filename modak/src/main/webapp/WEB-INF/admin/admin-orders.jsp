<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-orders.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<div id="app" class="admin-main" v-cloak>
    <div class="order-page-container">

        <!-- ── 헤더 ── -->
        <div class="order-header">
            <div class="order-title">📦 주문 / 반납 관리</div>
            <button @click="fnGoDashboard" class="o-btn-back">🏠 대시보드</button>
        </div>

        <!-- ── 탭 바 ── -->
        <div class="o-tab-bar">
            <button class="o-tab-btn" :class="{ active: activeTab === 'orders' }"     @click="switchTab('orders')">🧾 주문 내역</button>
            <button class="o-tab-btn" :class="{ active: activeTab === 'returns' }"    @click="switchTab('returns')">
                📦 반납 요청
                <span class="o-tab-badge" v-if="returnCount > 0">{{ returnCount }}</span>
            </button>
            <button class="o-tab-btn" :class="{ active: activeTab === 'delivery' }"   @click="switchTab('delivery')">🚚 배송 등록</button>
            <button class="o-tab-btn" :class="{ active: activeTab === 'inspection' }" @click="switchTab('inspection')">🔍 검수 관리</button>
            <button class="o-tab-btn" :class="{ active: activeTab === 'refunds' }"    @click="switchTab('refunds')">💸 환불 관리</button>
            <button class="o-tab-btn" :class="{ active: activeTab === 'exchanges' }"  @click="switchTab('exchanges')">🔄 교환 관리</button>
        </div>

        <!-- ── 주문 내역 탭 ── -->
        <div v-if="activeTab === 'orders'" class="order-card">
            <table class="order-table">
                <thead>
                    <tr>
                        <th style="width:8%">주문번호</th>
                        <th style="width:12%">주문자 ID</th>
                        <th style="text-align:left">주문 상품 정보</th>
                        <th style="width:14%">총 결제금액</th>
                        <th style="width:17%">주문 일시</th>
                        <th style="width:14%">진행 상태 설정</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="orderList.length === 0">
                        <td colspan="6" class="ord-empty">주문 내역이 없습니다.</td>
                    </tr>
                    <tr class="ord-row" v-for="order in orderList" :key="order.ORDER_ID">
                        <td class="order-id">#{{ order.ORDER_ID }}</td>
                        <td class="ord-user">{{ order.USER_ID }}</td>
                        <td class="prod-info-td">
                            <div class="order-img-box">
                                <img v-if="order.IMG_URL" :src="order.IMG_URL">
                                <span v-else class="ord-img-empty">🏕️</span>
                            </div>
                            <span class="ord-product-name">{{ order.PRODUCT_NAME }}</span>
                        </td>
                        <td class="order-price">{{ formatPrice(order.TOTAL_PRICE) }}원</td>
                        <td class="order-date">{{ order.CREATED_AT }}</td>
                        <td>
                            <div v-if="order.ORDER_STATUS === 'CANCEL_REQUESTED'" class="ord-status-col">
                                <span class="o-status-badge st-cancel-req">취소요청</span>
                                <button class="o-action-btn cancel" @click="fnApproveCancel(order)">취소 승인</button>
                            </div>
                            <div v-else-if="order.ORDER_STATUS !== 'CANCELLED'">
                                <select class="o-select" v-model="order.ORDER_STATUS" @change="fnUpdateStatus(order)">
                                    <option value="PAID">✅ 결제완료</option>
                                    <option value="READY">📦 상품준비중</option>
                                    <option value="SHIPPING">🚚 배송중</option>
                                    <option value="DONE">🚩 배송완료</option>
                                </select>
                            </div>
                            <div v-else>
                                <span class="o-status-badge st-cancelled">취소완료</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="o-pagination" v-if="totalPage > 1">
                <button @click="fnMovePage(page - 1)" :disabled="page === 1">이전</button>
                <button v-for="p in pageList" :key="p" @click="fnMovePage(p)" :class="{ active: page === p }">{{ p }}</button>
                <button @click="fnMovePage(page + 1)" :disabled="page === totalPage">다음</button>
            </div>
        </div>

        <!-- ── 배송 등록 탭 ── -->
        <div v-if="activeTab === 'delivery'" class="order-card ord-delivery-section">
            <div class="ord-section-title">🚚 운송장 번호 등록</div>
            <div class="ord-delivery-form">
                <div>
                    <label class="ord-label">주문번호</label>
                    <input class="o-input" v-model="delivery.orderId" placeholder="주문번호 입력" type="text">
                </div>
                <div>
                    <label class="ord-label">운송장 번호</label>
                    <input class="o-input" v-model="delivery.trackingNo" placeholder="운송장 번호 입력" type="text" @keyup.enter="fnRegisterDelivery">
                </div>
                <button class="o-action-btn pickup ord-delivery-btn" @click="fnRegisterDelivery" :disabled="isDelivering">
                    {{ isDelivering ? '처리중...' : '등록' }}
                </button>
            </div>
            <div v-if="deliveryResult" class="delivery-result-box" :class="deliveryResult.type">{{ deliveryResult.message }}</div>

            <div class="ord-sub-section">
                <div class="ord-sub-title">최근 배송 등록 내역</div>
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>주문자</th>
                            <th style="text-align:left">상품명</th>
                            <th>운송장번호</th>
                            <th>출고일시</th>
                            <th>배송상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="deliveryList.length === 0">
                            <td colspan="6" class="ord-empty">등록된 배송 내역이 없습니다.</td>
                        </tr>
                        <tr class="ord-row" v-for="d in deliveryList" :key="d.DELIVERY_ID">
                            <td class="order-id">#{{ d.ORDER_ID }}</td>
                            <td class="ord-user">{{ d.USER_ID }}</td>
                            <td class="prod-info-td"><span class="ord-product-name">{{ d.PRODUCT_NAME }}</span></td>
                            <td class="ord-tracking">{{ d.TRACKING_NO }}</td>
                            <td class="order-date">{{ d.SHIPPED_AT }}</td>
                            <td><span class="o-status-badge rs-RETURN_PICKED">배송중</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ── 반납 요청 탭 ── -->
        <div v-if="activeTab === 'returns'" class="order-card">
            <div class="return-filter-bar">
                <button class="o-filter-btn" :class="{ active: returnFilter === 'ALL' }"              @click="fnSetReturnFilter('ALL')">전체</button>
                <button class="o-filter-btn" :class="{ active: returnFilter === 'RETURN_REQUESTED' }" @click="fnSetReturnFilter('RETURN_REQUESTED')">반납요청</button>
                <button class="o-filter-btn" :class="{ active: returnFilter === 'RETURN_PICKED' }"    @click="fnSetReturnFilter('RETURN_PICKED')">수거중</button>
                <button class="o-filter-btn" :class="{ active: returnFilter === 'RETURN_COMPLETED' }" @click="fnSetReturnFilter('RETURN_COMPLETED')">반납완료</button>
                <span class="return-total">총 <strong>{{ filteredReturnList.length }}</strong>건</span>
            </div>
            <table class="order-table">
                <thead>
                    <tr>
                        <th style="width:7%">대여번호</th>
                        <th style="width:10%">고객</th>
                        <th style="text-align:left">상품</th>
                        <th style="width:13%">대여기간</th>
                        <th style="width:19%">회수 주소</th>
                        <th style="width:12%">반납 신청일</th>
                        <th style="width:13%">상태 변경</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredReturnList.length === 0">
                        <td colspan="7" class="ord-empty">반납 요청 내역이 없습니다.</td>
                    </tr>
                    <tr class="ord-row" v-for="item in filteredReturnList" :key="item.RENTAL_ID">
                        <td class="order-id">#{{ item.RENTAL_ID }}</td>
                        <td>
                            <div class="ord-user-name">{{ item.USER_ID === 'GUEST' ? item.GUEST_NAME : item.USER_ID }}</div>
                            <div class="ord-user-sub" v-if="item.USER_ID === 'GUEST'">{{ item.GUEST_PHONE }}</div>
                            <span class="ord-guest-badge" v-if="item.USER_ID === 'GUEST'">비회원</span>
                        </td>
                        <td class="prod-info-td">
                            <div class="order-img-box">
                                <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                <span v-else class="ord-img-empty">🏕️</span>
                            </div>
                            <div>
                                <div class="ord-product-name">{{ item.PRODUCT_NAME }}</div>
                                <div class="ord-item-sub">아이템ID: {{ item.ITEM_ID }}</div>
                            </div>
                        </td>
                        <td class="ord-period">{{ item.START_DATE }} ~<br>{{ item.RETURN_DATE }}</td>
                        <td>
                            <div v-if="item.RETURN_ADDRESS" class="ord-address">
                                <span class="ord-zipcode">[{{ item.RETURN_ZIPCODE }}]</span>
                                <div>{{ item.RETURN_ADDRESS }}</div>
                                <div class="ord-address-detail">{{ item.RETURN_DETAILED_ADDRESS }}</div>
                            </div>
                            <span v-else class="ord-no-data">주소 없음</span>
                        </td>
                        <td class="order-date">{{ item.RETURN_REQUESTED_AT }}</td>
                        <td>
                            <div class="ord-status-col">
                                <span class="o-status-badge" :class="'rs-' + item.RENTAL_STATUS">{{ fnReturnStatusText(item.RENTAL_STATUS) }}</span>
                                <button v-if="item.RENTAL_STATUS === 'RETURN_REQUESTED'" class="o-action-btn pickup" @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">🚚 수거 시작</button>
                                <button v-if="item.RENTAL_STATUS === 'RETURN_PICKED'"    class="o-action-btn complete" @click="fnUpdateReturnStatus(item, 'RETURN_COMPLETED')">✅ 반납 완료</button>
                                <button v-if="item.RENTAL_STATUS === 'RETURN_COMPLETED'" class="o-action-btn cancel" @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">↩ 수거중으로</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- ── 검수 관리 탭 ── -->
        <div v-if="activeTab === 'inspection'" class="order-card">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>대여번호</th>
                        <th>고객</th>
                        <th style="text-align:left">상품</th>
                        <th>반납일</th>
                        <th>검수상태</th>
                        <th>공제금액</th>
                        <th>메모</th>
                        <th>검수</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="inspectionList.length === 0">
                        <td colspan="8" class="ord-empty">반납완료 내역이 없습니다.</td>
                    </tr>
                    <tr class="ord-row" v-for="item in inspectionList" :key="item.RENTAL_ID">
                        <td class="order-id">#{{ item.RENTAL_ID }}</td>
                        <td class="ord-user">{{ item.USER_ID }}</td>
                        <td class="prod-info-td">
                            <div class="order-img-box">
                                <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                <span v-else class="ord-img-empty">🏕️</span>
                            </div>
                            <span class="ord-product-name">{{ item.PRODUCT_NAME }}</span>
                        </td>
                        <td class="order-date">{{ item.RETURN_DATE }}</td>
                        <td>
                            <span v-if="item.CONDITION_CODE === 'GOOD'"    class="insp-good">✅ 양호</span>
                            <span v-else-if="item.CONDITION_CODE === 'DAMAGED'" class="insp-damaged">⚠ 파손</span>
                            <span v-else-if="item.CONDITION_CODE === 'LOST'"    class="insp-lost">❌ 분실</span>
                            <span v-else class="ord-no-data">미검수</span>
                        </td>
                        <td class="ord-deduction">{{ item.DEDUCTION_AMT ? Number(item.DEDUCTION_AMT).toLocaleString() + '원' : '-' }}</td>
                        <td class="ord-memo">{{ item.MEMO || '-' }}</td>
                        <td>
                            <button class="o-action-btn pickup" @click="fnOpenInspection(item)">
                                {{ item.INSPECTION_ID ? '재검수' : '검수 등록' }}
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- ── 환불 관리 탭 ── -->
        <div v-if="activeTab === 'refunds'" class="order-card">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>환불번호</th>
                        <th>주문번호</th>
                        <th>고객</th>
                        <th style="text-align:left">상품</th>
                        <th>환불금액</th>
                        <th>사유</th>
                        <th>상태</th>
                        <th>신청일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="refundList.length === 0">
                        <td colspan="8" class="ord-empty">환불 내역이 없습니다.</td>
                    </tr>
                    <tr class="ord-row" v-for="item in refundList" :key="item.REFUND_ID">
                        <td class="order-id">#{{ item.REFUND_ID }}</td>
                        <td class="order-id">#{{ item.ORDER_ID }}</td>
                        <td class="ord-user">{{ item.USER_ID }}</td>
                        <td class="prod-info-td">
                            <div class="order-img-box">
                                <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                <span v-else class="ord-img-empty">🏕️</span>
                            </div>
                            <span class="ord-product-name">{{ item.PRODUCT_NAME }}</span>
                        </td>
                        <td class="order-price">{{ Number(item.REFUND_AMOUNT || 0).toLocaleString() }}원</td>
                        <td class="ord-reason">{{ item.REFUND_REASON }}</td>
                        <td>
                            <div class="ord-status-col">
                                <span :class="['ord-status-text', 'rfs-' + item.REFUND_STATUS]">
                                    {{ {COMPLETED:'✅ 환불완료', REJECTED:'❌ 거절', PENDING:'⏳ 신청대기'}[item.REFUND_STATUS] || item.REFUND_STATUS }}
                                </span>
                                <button v-if="item.REFUND_STATUS === 'PENDING'" class="o-action-btn complete ord-sm-btn" @click="fnUpdateRefundStatus(item, 'COMPLETED')">승인</button>
                                <button v-if="item.REFUND_STATUS === 'PENDING'" class="o-action-btn cancel ord-sm-btn"   @click="fnUpdateRefundStatus(item, 'REJECTED')">거절</button>
                            </div>
                        </td>
                        <td class="order-date">{{ item.CREATED_AT }}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- ── 교환 관리 탭 ── -->
        <div v-if="activeTab === 'exchanges'" class="order-card">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>교환번호</th>
                        <th>주문번호</th>
                        <th>고객</th>
                        <th style="text-align:left">상품</th>
                        <th>사유</th>
                        <th>회수주소</th>
                        <th>상태</th>
                        <th>신청일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="exchangeList.length === 0">
                        <td colspan="8" class="ord-empty">교환 내역이 없습니다.</td>
                    </tr>
                    <tr class="ord-row" v-for="item in exchangeList" :key="item.EXCHANGE_ID">
                        <td class="order-id">#{{ item.EXCHANGE_ID }}</td>
                        <td class="order-id">#{{ item.ORDER_ID }}</td>
                        <td class="ord-user">{{ item.USER_ID }}</td>
                        <td class="prod-info-td">
                            <div class="order-img-box">
                                <img v-if="item.IMG_URL" :src="item.IMG_URL">
                                <span v-else class="ord-img-empty">🏕️</span>
                            </div>
                            <span class="ord-product-name">{{ item.PRODUCT_NAME }}</span>
                        </td>
                        <td class="ord-reason">{{ item.EXCHANGE_REASON || item.REASON || '-' }}</td>
                        <td class="ord-address-cell">{{ item.ADDRESS }} {{ item.DETAILED_ADDRESS || item.DETAIL_ADDRESS }}</td>
                        <td>
                            <div class="ord-status-col">
                                <span :class="['ord-status-text', 'exs-' + (item.EXCHANGE_STATUS || item.STATUS)]">
                                    {{ {REQUESTED:'📋 신청', APPROVED:'✅ 승인', REJECTED:'❌ 거절', COMPLETED:'🏁 완료'}[item.EXCHANGE_STATUS || item.STATUS] || (item.EXCHANGE_STATUS || item.STATUS) }}
                                </span>
                                <button v-if="(item.EXCHANGE_STATUS || item.STATUS) === 'REQUESTED'" class="o-action-btn complete ord-sm-btn" @click="fnUpdateExchangeStatus(item, 'APPROVED')">승인</button>
                                <button v-if="(item.EXCHANGE_STATUS || item.STATUS) === 'REQUESTED'" class="o-action-btn cancel ord-sm-btn"   @click="fnUpdateExchangeStatus(item, 'REJECTED')">거절</button>
                                <button v-if="(item.EXCHANGE_STATUS || item.STATUS) === 'APPROVED'"  class="o-action-btn pickup ord-sm-btn"   @click="fnUpdateExchangeStatus(item, 'COMPLETED')">처리완료</button>
                            </div>
                        </td>
                        <td class="order-date">{{ item.CREATED_AT }}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- ── 검수 모달 ── -->
        <transition name="ord-modal-fade">
            <div class="ins-modal-overlay" v-if="showInspectionModal" @click.self="showInspectionModal = false">
                <div class="ins-modal-box">
                    <div class="ins-modal-title">🔍 검수 등록</div>
                    <div class="ins-form-group">
                        <label class="ins-label">상품 상태</label>
                        <select class="o-select" v-model="inspectionForm.conditionCode" style="width:100%">
                            <option value="GOOD">✅ 양호</option>
                            <option value="DAMAGED">⚠️ 파손</option>
                            <option value="LOST">❌ 분실</option>
                        </select>
                    </div>
                    <div class="ins-form-group" v-if="inspectionForm.conditionCode !== 'GOOD'">
                        <label class="ins-label">공제 금액 (원)</label>
                        <input class="o-input" type="number" v-model.number="inspectionForm.deductionAmt" style="width:100%">
                    </div>
                    <div class="ins-form-group">
                        <label class="ins-label">메모</label>
                        <textarea class="o-input" v-model="inspectionForm.memo" rows="3" style="width:100%;resize:vertical"></textarea>
                    </div>
                    <div class="ins-modal-footer">
                        <button class="o-action-btn cancel"   @click="showInspectionModal = false">취소</button>
                        <button class="o-action-btn complete" @click="fnSaveInspection">저장</button>
                    </div>
                </div>
            </div>
        </transition>

        <!-- ── 확인 모달 ── -->
        <transition name="ord-modal-fade">
            <div class="ord-confirm-overlay" v-if="showConfirm">
                <div class="ord-confirm-box">
                    <div class="ord-confirm-icon">{{ confirmConfig.icon || '❓' }}</div>
                    <div class="ord-confirm-title">{{ confirmConfig.title }}</div>
                    <div class="ord-confirm-msg" v-html="confirmConfig.msg"></div>
                    <div class="ord-confirm-btns">
                        <button class="o-action-btn cancel ord-confirm-cancel" @click="showConfirm = false">취소</button>
                        <button class="o-action-btn" :class="confirmConfig.danger ? 'cancel' : 'complete'" @click="fnRunConfirm">
                            {{ confirmConfig.okLabel || '확인' }}
                        </button>
                    </div>
                </div>
            </div>
        </transition>

    </div><!-- order-page-container -->
</div><!-- #app -->

<div class="ord-toast" id="ordToast"></div>

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                activeTab: 'orders',
                orderList: [], page: 1, pageSize: 15, totalCount: 0,
                returnList: [], returnFilter: 'ALL',
                delivery: { orderId: '', trackingNo: '' },
                deliveryResult: null, isDelivering: false, deliveryList: [],
                inspectionList: [], refundList: [], exchangeList: [],
                inspectionForm: { rentalId: null, userId: null, conditionCode: 'GOOD', deductionAmt: 0, memo: '' },
                showInspectionModal: false,
                showConfirm: false,
                confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, onConfirm: null }
            };
        },
        computed: {
            returnCount()  { return this.returnList.filter(r => r.RENTAL_STATUS === 'RETURN_REQUESTED').length; },
            filteredReturnList() {
                if (this.returnFilter === 'ALL') return this.returnList;
                return this.returnList.filter(r => r.RENTAL_STATUS === this.returnFilter);
            },
            totalPage() { return Math.ceil(this.totalCount / this.pageSize); },
            pageList() {
                const blockSize = 5;
                const start = Math.floor((this.page - 1) / blockSize) * blockSize + 1;
                const end = Math.min(start + blockSize - 1, this.totalPage);
                const list = [];
                for (let i = start; i <= end; i++) list.push(i);
                return list;
            }
        },
        methods: {
            toast(msg, type = 'success') {
                const el = document.getElementById('ordToast');
                el.textContent = msg;
                el.className = 'ord-toast show ' + type;
                clearTimeout(el._t);
                el._t = setTimeout(() => { el.className = 'ord-toast'; }, 3000);
            },
            fnShowConfirm(cfg) { this.confirmConfig = cfg; this.showConfirm = true; },
            fnRunConfirm() {
                this.showConfirm = false;
                if (this.confirmConfig.onConfirm) this.confirmConfig.onConfirm();
            },

            /* ── 탭 ── */
            switchTab(tab) {
                this.activeTab = tab;
                if (tab === 'returns'    && this.returnList.length === 0)  this.fnGetReturnList();
                if (tab === 'inspection') this.fnGetInspectionList();
                if (tab === 'refunds')    this.fnGetRefundList();
                if (tab === 'exchanges')  this.fnGetExchangeList();
                if (tab === 'delivery'   && this.deliveryList.length === 0) this.fnGetDeliveryList();
            },

            /* ── 주문 목록 ── */
            fnGetList() {
                $.ajax({
                    url: '/admin/order/list.dox', type: 'POST',
                    data: { page: this.page, pageSize: this.pageSize },
                    success: (data) => {
                        if (data.result === 'success') {
                            this.orderList = (data.list || []).map(o => {
                                o.ORDER_STATUS = String(o.ORDER_STATUS || '').toUpperCase();
                                return o;
                            });
                            this.totalCount = data.totalCount || 0;
                        }
                    }
                });
            },
            fnMovePage(p) {
                if (p < 1 || p > this.totalPage) return;
                this.page = p;
                this.fnGetList();
            },

            /* ── 주문 상태 변경 ── */
            fnUpdateStatus(order) {
                if (order.ORDER_STATUS === 'CANCEL_REQUESTED') {
                    this.toast('⚠️ 취소요청 상태는 승인 버튼으로 처리하세요', 'error');
                    return;
                }
                $.ajax({
                    url: '/admin/order/update-status.dox', type: 'POST',
                    data: { orderId: order.ORDER_ID, status: order.ORDER_STATUS },
                    success: (res) => {
                        if (res.result === 'success') {
                            this.toast('✅ 주문 상태가 변경되었습니다', 'success');
                        } else {
                            this.toast('⚠️ 상태 변경 실패', 'error');
                        }
                    },
                    error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                });
            },

            /* ── 취소 승인 ── */
            fnApproveCancel(order) {
                this.fnShowConfirm({
                    icon: '🚫', title: '주문 취소 승인',
                    msg: '취소 승인 시 <b>결제가 취소</b>됩니다.<br>승인하시겠습니까?',
                    okLabel: '취소 승인', danger: true,
                    onConfirm: () => {
                        $.ajax({
                            url: '/admin/order/cancel-approve.dox', type: 'POST',
                            data: { orderId: order.ORDER_ID },
                            success: (res) => {
                                if (res.result === 'success') {
                                    order.ORDER_STATUS = 'CANCELLED';
                                    this.toast('✅ 취소 및 환불 처리 완료', 'success');
                                } else {
                                    this.toast('⚠️ ' + (res.message || '취소 처리 실패'), 'error');
                                }
                            },
                            error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                        });
                    }
                });
            },

            /* ── 반납 목록 ── */
            fnGetReturnList() {
                $.ajax({
                    url: '/admin/rental/return/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.returnList = res.list; }
                });
            },

            /* ── 반납 상태 변경 ── */
            fnUpdateReturnStatus(item, status) {
                const cfgMap = {
                    RETURN_PICKED:    { icon: '🚚', title: '수거 시작',  msg: '수거를 시작하시겠습니까?',      okLabel: '수거 시작' },
                    RETURN_COMPLETED: { icon: '✅', title: '반납 완료',  msg: '반납 완료 처리하시겠습니까?',   okLabel: '완료 처리' }
                };
                const cfg = cfgMap[status] || { icon: '🔄', title: '상태 변경', msg: '상태를 변경하시겠습니까?', okLabel: '변경' };
                this.fnShowConfirm({
                    ...cfg,
                    onConfirm: () => {
                        $.ajax({
                            url: '/admin/rental/return/update-status.dox', type: 'POST',
                            data: { rentalId: item.RENTAL_ID, status },
                            success: (res) => {
                                if (res.result === 'success') {
                                    item.RENTAL_STATUS = status;
                                    this.toast('✅ 반납 상태가 변경되었습니다', 'success');
                                } else {
                                    this.toast('⚠️ ' + (res.message || '상태 변경 실패'), 'error');
                                }
                            },
                            error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                        });
                    }
                });
            },

            /* ── 검수 ── */
            fnGetInspectionList() {
                $.ajax({
                    url: '/admin/inspection/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.inspectionList = res.list; }
                });
            },
            fnOpenInspection(item) {
                this.inspectionForm = { rentalId: item.RENTAL_ID, userId: item.USER_ID, conditionCode: 'GOOD', deductionAmt: 0, memo: '' };
                this.showInspectionModal = true;
            },
            fnSaveInspection() {
                $.ajax({
                    url: '/admin/inspection/save.dox', type: 'POST',
                    data: this.inspectionForm,
                    success: (res) => {
                        if (res.result === 'success') {
                            this.showInspectionModal = false;
                            this.fnGetInspectionList();
                            this.toast('✅ 검수 등록이 완료되었습니다', 'success');
                        } else {
                            this.toast('⚠️ ' + (res.message || '검수 등록 실패'), 'error');
                        }
                    },
                    error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                });
            },

            /* ── 환불 ── */
            fnGetRefundList() {
                $.ajax({
                    url: '/admin/refund/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.refundList = res.list; }
                });
            },
            fnUpdateRefundStatus(item, status) {
                const isApprove = status === 'COMPLETED';
                this.fnShowConfirm({
                    icon: isApprove ? '💸' : '❌',
                    title: isApprove ? '환불 승인' : '환불 거절',
                    msg: isApprove ? '환불을 <b>승인</b> 처리하시겠습니까?' : '환불을 <b>거절</b> 처리하시겠습니까?',
                    okLabel: isApprove ? '승인' : '거절',
                    danger: !isApprove,
                    onConfirm: () => {
                        $.ajax({
                            url: '/admin/refund/update-status.dox', type: 'POST',
                            data: { refundId: item.REFUND_ID, orderId: item.ORDER_ID, userId: item.USER_ID, status },
                            success: (res) => {
                                if (res.result === 'success') {
                                    item.REFUND_STATUS = status;
                                    this.toast(isApprove ? '✅ 환불 승인 완료' : '✅ 환불 거절 완료', 'success');
                                } else {
                                    this.toast('⚠️ ' + (res.message || '환불 상태 변경 실패'), 'error');
                                }
                            },
                            error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                        });
                    }
                });
            },

            /* ── 교환 ── */
            fnGetExchangeList() {
                $.ajax({
                    url: '/admin/exchange/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.exchangeList = res.list; }
                });
            },
            fnUpdateExchangeStatus(item, status) {
                const cfgMap = {
                    APPROVED:  { icon: '✅', title: '교환 승인', msg: '교환을 <b>승인</b>하시겠습니까?',      okLabel: '승인', danger: false },
                    REJECTED:  { icon: '❌', title: '교환 거절', msg: '교환을 <b>거절</b>하시겠습니까?',      okLabel: '거절', danger: true  },
                    COMPLETED: { icon: '🏁', title: '교환 완료', msg: '교환 처리를 <b>완료</b>하시겠습니까?', okLabel: '완료', danger: false }
                };
                const cfg = cfgMap[status] || { icon: '🔄', title: '상태 변경', msg: '상태를 변경하시겠습니까?', okLabel: '변경', danger: false };
                this.fnShowConfirm({
                    ...cfg,
                    onConfirm: () => {
                        $.ajax({
                            url: '/admin/exchange/update-status.dox', type: 'POST',
                            data: { exchangeId: item.EXCHANGE_ID, userId: item.USER_ID, status },
                            success: (res) => {
                                if (res.result === 'success') {
                                    item.STATUS = status;
                                    item.EXCHANGE_STATUS = status;
                                    this.toast('✅ 교환 상태가 변경되었습니다', 'success');
                                } else {
                                    this.toast('⚠️ ' + (res.message || '교환 상태 변경 실패'), 'error');
                                }
                            },
                            error: () => this.toast('⚠️ 서버 오류가 발생했습니다', 'error')
                        });
                    }
                });
            },

            /* ── 배송 ── */
            fnSetReturnFilter(f) { this.returnFilter = f; },
            fnRegisterDelivery() {
                if (!this.delivery.orderId)   { this.deliveryResult = { type: 'error', message: '주문번호를 입력하세요.' }; return; }
                if (!this.delivery.trackingNo) { this.deliveryResult = { type: 'error', message: '운송장 번호를 입력하세요.' }; return; }
                this.isDelivering = true;
                this.deliveryResult = null;
                $.ajax({
                    url: '/admin/delivery/register.dox', type: 'POST',
                    data: { orderId: this.delivery.orderId, trackingNo: this.delivery.trackingNo },
                    success: (res) => {
                        this.isDelivering = false;
                        if (res.result === 'success') {
                            this.deliveryResult = { type: 'success', message: '✅ 배송 등록 완료! 주문상태가 배송중으로 변경되었습니다.' };
                            this.delivery.orderId = '';
                            this.delivery.trackingNo = '';
                            this.fnGetDeliveryList();
                        } else {
                            this.deliveryResult = { type: 'error', message: '❌ ' + (res.message || '등록 실패') };
                        }
                    },
                    error: () => { this.isDelivering = false; this.deliveryResult = { type: 'error', message: '서버 오류' }; }
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
                const map = { RETURN_REQUESTED: '반납요청', RETURN_PICKED: '수거중', RETURN_COMPLETED: '반납완료', IN_USE: '대여중', RESERVED: '예약완료' };
                return map[s] || s || '-';
            },
            fnGoDashboard() { location.href = '/admin/dashboard.do'; }
        },
        mounted() { this.fnGetList(); }
    }).mount('#app');
</script>
</body>
</html>
