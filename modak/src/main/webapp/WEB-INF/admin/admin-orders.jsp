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

    <!-- ── 페이지 헤더 ── -->
    <div class="ord-page-header">
        <div class="ord-title-wrap">
            <div class="ord-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
            </div>
            <div>
                <div class="ord-page-title">주문 / 반납 관리</div>
                <div class="ord-page-subtitle">주문·반납·검수·환불·교환을 한 곳에서 처리합니다</div>
            </div>
        </div>
        <button class="ord-dashboard-btn" @click="fnGoDashboard">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            대시보드
        </button>
    </div>

    <!-- ── 통계 스트립 ── -->
    <div class="ord-stat-strip">
        <div class="ord-stat-item">
            <div class="ord-stat-icon-wrap ord-stat-total">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
            </div>
            <div class="ord-stat-body">
                <div class="ord-stat-val">{{ totalCount.toLocaleString() }}</div>
                <div class="ord-stat-lbl">전체 주문</div>
            </div>
        </div>
        <div class="ord-stat-divider"></div>
        <div class="ord-stat-item">
            <div class="ord-stat-icon-wrap ord-stat-return">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-3.75"/></svg>
            </div>
            <div class="ord-stat-body">
                <div class="ord-stat-val ord-stat-v-warn">{{ returnCount }}</div>
                <div class="ord-stat-lbl">반납 요청</div>
            </div>
        </div>
        <div class="ord-stat-divider"></div>
        <div class="ord-stat-item">
            <div class="ord-stat-icon-wrap ord-stat-refund">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            </div>
            <div class="ord-stat-body">
                <div class="ord-stat-val ord-stat-v-red">{{ pendingRefundCount }}</div>
                <div class="ord-stat-lbl">환불 대기</div>
            </div>
        </div>
        <div class="ord-stat-divider"></div>
        <div class="ord-stat-item">
            <div class="ord-stat-icon-wrap ord-stat-exchange">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
            </div>
            <div class="ord-stat-body">
                <div class="ord-stat-val ord-stat-v-blue">{{ pendingExchangeCount }}</div>
                <div class="ord-stat-lbl">교환 요청</div>
            </div>
        </div>
    </div>

    <!-- ── 탭 바 ── -->
    <div class="ord-tab-bar">
        <button class="ord-tab-btn" :class="{active: activeTab === 'orders'}"     @click="switchTab('orders')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
            주문 내역
        </button>
        <button class="ord-tab-btn" :class="{active: activeTab === 'returns'}"    @click="switchTab('returns')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-3.75"/></svg>
            반납 요청
            <span class="ord-tab-cnt" v-if="returnCount > 0">{{ returnCount }}</span>
        </button>
        <button class="ord-tab-btn" :class="{active: activeTab === 'delivery'}"   @click="switchTab('delivery')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
            배송 등록
        </button>
        <button class="ord-tab-btn" :class="{active: activeTab === 'inspection'}" @click="switchTab('inspection')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            검수 관리
        </button>
        <button class="ord-tab-btn" :class="{active: activeTab === 'refunds'}"    @click="switchTab('refunds')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            환불 관리
            <span class="ord-tab-cnt ord-cnt-red" v-if="pendingRefundCount > 0">{{ pendingRefundCount }}</span>
        </button>
        <button class="ord-tab-btn" :class="{active: activeTab === 'exchanges'}"  @click="switchTab('exchanges')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
            교환 관리
            <span class="ord-tab-cnt ord-cnt-blue" v-if="pendingExchangeCount > 0">{{ pendingExchangeCount }}</span>
        </button>
    </div>

    <!-- ════════════════════════════════
         탭: 주문 내역
    ════════════════════════════════ -->
    <div v-if="activeTab === 'orders'" class="ord-card">
        <table class="ord-table">
            <thead>
                <tr>
                    <th style="width:8%">주문번호</th>
                    <th style="width:12%">주문자</th>
                    <th class="t-left">주문 상품</th>
                    <th style="width:13%">결제금액</th>
                    <th style="width:16%">주문일시</th>
                    <th style="width:15%">상태 처리</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="orderList.length === 0">
                    <td colspan="6" class="ord-empty-row">
                        <div class="ord-empty-icon">📦</div>
                        <div>주문 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="ord-row" v-for="order in orderList" :key="order.ORDER_ID">
                    <td><span class="ord-id-badge">#{{ order.ORDER_ID }}</span></td>
                    <td><span class="ord-user-chip">{{ order.USER_ID }}</span></td>
                    <td class="prod-info-td">
                        <div class="ord-img-wrap">
                            <img v-if="order.IMG_URL" :src="order.IMG_URL">
                            <span v-else class="ord-img-placeholder">🏕️</span>
                        </div>
                        <span class="ord-prod-name">{{ order.PRODUCT_NAME }}</span>
                    </td>
                    <td><span class="ord-price">{{ formatPrice(order.TOTAL_PRICE) }}원</span></td>
                    <td class="ord-date">{{ order.CREATED_AT }}</td>
                    <td>
                        <div v-if="order.ORDER_STATUS === 'CANCEL_REQUESTED'" class="ord-action-col">
                            <span class="ord-sbadge sbadge-warn">취소요청</span>
                            <button class="ord-act-btn act-danger" @click="fnApproveCancel(order)">취소 승인</button>
                        </div>
                        <div v-else-if="order.ORDER_STATUS === 'CANCELLED'">
                            <span class="ord-sbadge sbadge-cancelled">취소완료</span>
                        </div>
                        <div v-else>
                            <select class="ord-status-select" v-model="order.ORDER_STATUS"
                                    :class="'sel-' + order.ORDER_STATUS.toLowerCase()"
                                    @change="fnUpdateStatus(order)">
                                <option value="PAID">✅ 결제완료</option>
                                <option value="READY">📦 상품준비중</option>
                                <option value="SHIPPING">🚚 배송중</option>
                                <option value="DONE">🚩 배송완료</option>
                            </select>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="ord-pagination" v-if="totalPage > 1">
            <button class="opg-btn" @click="fnMovePage(page - 1)" :disabled="page === 1">&#8249;</button>
            <button class="opg-btn" v-for="p in pageList" :key="p" @click="fnMovePage(p)" :class="{active: page === p}">{{ p }}</button>
            <button class="opg-btn" @click="fnMovePage(page + 1)" :disabled="page === totalPage">&#8250;</button>
        </div>
    </div>

    <!-- ════════════════════════════════
         탭: 반납 요청
    ════════════════════════════════ -->
    <div v-if="activeTab === 'returns'" class="ord-card">
        <div class="ord-filter-bar">
            <button class="ord-filter-btn" :class="{active: returnFilter === 'ALL'}"              @click="fnSetReturnFilter('ALL')">
                <span class="ofd-dot ofd-all"></span> 전체 <span class="ofd-cnt">{{ returnList.length }}</span>
            </button>
            <button class="ord-filter-btn" :class="{active: returnFilter === 'RETURN_REQUESTED'}" @click="fnSetReturnFilter('RETURN_REQUESTED')">
                <span class="ofd-dot ofd-warn"></span> 반납요청 <span class="ofd-cnt">{{ returnList.filter(r => r.RENTAL_STATUS === 'RETURN_REQUESTED').length }}</span>
            </button>
            <button class="ord-filter-btn" :class="{active: returnFilter === 'RETURN_PICKED'}"    @click="fnSetReturnFilter('RETURN_PICKED')">
                <span class="ofd-dot ofd-blue"></span> 수거중 <span class="ofd-cnt">{{ returnList.filter(r => r.RENTAL_STATUS === 'RETURN_PICKED').length }}</span>
            </button>
            <button class="ord-filter-btn" :class="{active: returnFilter === 'RETURN_COMPLETED'}" @click="fnSetReturnFilter('RETURN_COMPLETED')">
                <span class="ofd-dot ofd-green"></span> 반납완료 <span class="ofd-cnt">{{ returnList.filter(r => r.RENTAL_STATUS === 'RETURN_COMPLETED').length }}</span>
            </button>
        </div>
        <table class="ord-table">
            <thead>
                <tr>
                    <th style="width:7%">대여번호</th>
                    <th style="width:11%">고객</th>
                    <th class="t-left">상품</th>
                    <th style="width:13%">대여기간</th>
                    <th style="width:18%">회수 주소</th>
                    <th style="width:12%">반납신청일</th>
                    <th style="width:14%">상태 처리</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="filteredReturnList.length === 0">
                    <td colspan="7" class="ord-empty-row">
                        <div class="ord-empty-icon">📭</div>
                        <div>반납 요청 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="ord-row" v-for="item in filteredReturnList" :key="item.RENTAL_ID">
                    <td><span class="ord-id-badge">#{{ item.RENTAL_ID }}</span></td>
                    <td>
                        <div class="ord-cust-name">{{ item.USER_ID === 'GUEST' ? item.GUEST_NAME : item.USER_ID }}</div>
                        <div class="ord-cust-sub" v-if="item.USER_ID === 'GUEST'">{{ item.GUEST_PHONE }}</div>
                        <span class="ord-guest-tag" v-if="item.USER_ID === 'GUEST'">비회원</span>
                    </td>
                    <td class="prod-info-td">
                        <div class="ord-img-wrap">
                            <img v-if="item.IMG_URL" :src="item.IMG_URL">
                            <span v-else class="ord-img-placeholder">🏕️</span>
                        </div>
                        <div>
                            <div class="ord-prod-name">{{ item.PRODUCT_NAME }}</div>
                            <div class="ord-prod-sub">아이템 #{{ item.ITEM_ID }}</div>
                        </div>
                    </td>
                    <td class="ord-period">{{ item.START_DATE }}<br><span class="ord-period-arrow">→</span> {{ item.RETURN_DATE }}</td>
                    <td>
                        <div v-if="item.RETURN_ADDRESS" class="ord-addr-cell">
                            <span class="ord-zipcode">[{{ item.RETURN_ZIPCODE }}]</span>
                            <div>{{ item.RETURN_ADDRESS }}</div>
                            <div class="ord-addr-detail">{{ item.RETURN_DETAILED_ADDRESS }}</div>
                        </div>
                        <span v-else class="ord-no-data">주소 없음</span>
                    </td>
                    <td class="ord-date">{{ item.RETURN_REQUESTED_AT }}</td>
                    <td>
                        <div class="ord-action-col">
                            <span class="ord-sbadge" :class="'rsbadge-' + item.RENTAL_STATUS">{{ fnReturnStatusText(item.RENTAL_STATUS) }}</span>
                            <button v-if="item.RENTAL_STATUS === 'RETURN_REQUESTED'" class="ord-act-btn act-blue"   @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">🚚 수거 시작</button>
                            <button v-if="item.RENTAL_STATUS === 'RETURN_PICKED'"    class="ord-act-btn act-green"  @click="fnUpdateReturnStatus(item, 'RETURN_COMPLETED')">✅ 반납 완료</button>
                            <button v-if="item.RENTAL_STATUS === 'RETURN_COMPLETED'" class="ord-act-btn act-ghost"  @click="fnUpdateReturnStatus(item, 'RETURN_PICKED')">↩ 수거중으로</button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ════════════════════════════════
         탭: 배송 등록
    ════════════════════════════════ -->
    <div v-if="activeTab === 'delivery'" class="ord-card ord-delivery-wrap">
        <div class="ord-section-head">
            <div class="ord-section-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
            </div>
            <div>
                <div class="ord-section-title">운송장 번호 등록</div>
                <div class="ord-section-sub">운송장을 등록하면 주문 상태가 자동으로 배송중으로 변경됩니다</div>
            </div>
        </div>
        <div class="ord-delivery-form">
            <div class="ord-dform-field">
                <label class="ord-dform-label">주문번호</label>
                <div class="ord-dform-input-wrap">
                    <span class="ord-dform-prefix">#</span>
                    <input class="ord-dform-input" v-model="delivery.orderId" placeholder="주문번호 입력" type="text">
                </div>
            </div>
            <div class="ord-dform-field">
                <label class="ord-dform-label">운송장 번호</label>
                <div class="ord-dform-input-wrap">
                    <input class="ord-dform-input" style="padding-left:14px" v-model="delivery.trackingNo" placeholder="운송장 번호 입력" type="text" @keyup.enter="fnRegisterDelivery">
                </div>
            </div>
            <button class="ord-dform-btn" @click="fnRegisterDelivery" :disabled="isDelivering">
                <span v-if="isDelivering" class="ord-dform-spinner"></span>
                {{ isDelivering ? '처리중...' : '등록하기' }}
            </button>
        </div>
        <transition name="dres-fade">
            <div v-if="deliveryResult" class="ord-delivery-result" :class="deliveryResult.type">
                <span>{{ deliveryResult.type === 'success' ? '✅' : '❌' }}</span>
                {{ deliveryResult.message }}
            </div>
        </transition>

        <div class="ord-sub-section">
            <div class="ord-sub-title">최근 배송 등록 내역</div>
            <table class="ord-table">
                <thead>
                    <tr>
                        <th style="width:9%">주문번호</th>
                        <th style="width:12%">주문자</th>
                        <th class="t-left">상품명</th>
                        <th style="width:16%">운송장번호</th>
                        <th style="width:16%">출고일시</th>
                        <th style="width:10%">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="deliveryList.length === 0">
                        <td colspan="6" class="ord-empty-row">
                            <div class="ord-empty-icon">🚛</div>
                            <div>등록된 배송 내역이 없습니다.</div>
                        </td>
                    </tr>
                    <tr class="ord-row" v-for="d in deliveryList" :key="d.DELIVERY_ID">
                        <td><span class="ord-id-badge">#{{ d.ORDER_ID }}</span></td>
                        <td><span class="ord-user-chip">{{ d.USER_ID }}</span></td>
                        <td class="prod-info-td"><span class="ord-prod-name">{{ d.PRODUCT_NAME }}</span></td>
                        <td><span class="ord-tracking-no">{{ d.TRACKING_NO }}</span></td>
                        <td class="ord-date">{{ d.SHIPPED_AT }}</td>
                        <td><span class="ord-sbadge rsbadge-RETURN_PICKED">배송중</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ════════════════════════════════
         탭: 검수 관리
    ════════════════════════════════ -->
    <div v-if="activeTab === 'inspection'" class="ord-card">
        <table class="ord-table">
            <thead>
                <tr>
                    <th style="width:8%">대여번호</th>
                    <th style="width:11%">고객</th>
                    <th class="t-left">상품</th>
                    <th style="width:11%">반납일</th>
                    <th style="width:11%">검수상태</th>
                    <th style="width:11%">공제금액</th>
                    <th style="width:18%">메모</th>
                    <th style="width:10%">검수</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="inspectionList.length === 0">
                    <td colspan="8" class="ord-empty-row">
                        <div class="ord-empty-icon">🔍</div>
                        <div>반납완료 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="ord-row" v-for="item in inspectionList" :key="item.RENTAL_ID">
                    <td><span class="ord-id-badge">#{{ item.RENTAL_ID }}</span></td>
                    <td><span class="ord-user-chip">{{ item.USER_ID }}</span></td>
                    <td class="prod-info-td">
                        <div class="ord-img-wrap">
                            <img v-if="item.IMG_URL" :src="item.IMG_URL">
                            <span v-else class="ord-img-placeholder">🏕️</span>
                        </div>
                        <span class="ord-prod-name">{{ item.PRODUCT_NAME }}</span>
                    </td>
                    <td class="ord-date">{{ item.RETURN_DATE }}</td>
                    <td>
                        <span v-if="item.CONDITION_CODE === 'GOOD'"    class="insp-badge insp-good">✅ 양호</span>
                        <span v-else-if="item.CONDITION_CODE === 'DAMAGED'" class="insp-badge insp-damaged">⚠️ 파손</span>
                        <span v-else-if="item.CONDITION_CODE === 'LOST'"    class="insp-badge insp-lost">❌ 분실</span>
                        <span v-else class="insp-badge insp-pending">미검수</span>
                    </td>
                    <td class="ord-deduction">{{ item.DEDUCTION_AMT ? Number(item.DEDUCTION_AMT).toLocaleString() + '원' : '—' }}</td>
                    <td class="ord-memo-cell">{{ item.MEMO || '—' }}</td>
                    <td>
                        <button class="ord-act-btn act-blue" @click="fnOpenInspection(item)">
                            {{ item.INSPECTION_ID ? '재검수' : '검수 등록' }}
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ════════════════════════════════
         탭: 환불 관리
    ════════════════════════════════ -->
    <div v-if="activeTab === 'refunds'" class="ord-card">
        <table class="ord-table">
            <thead>
                <tr>
                    <th style="width:8%">환불번호</th>
                    <th style="width:8%">주문번호</th>
                    <th style="width:10%">고객</th>
                    <th class="t-left">상품</th>
                    <th style="width:11%">환불금액</th>
                    <th style="width:14%">사유</th>
                    <th style="width:15%">상태</th>
                    <th style="width:12%">신청일</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="refundList.length === 0">
                    <td colspan="8" class="ord-empty-row">
                        <div class="ord-empty-icon">💸</div>
                        <div>환불 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="ord-row" v-for="item in refundList" :key="item.REFUND_ID">
                    <td><span class="ord-id-badge">#{{ item.REFUND_ID }}</span></td>
                    <td><span class="ord-id-badge">#{{ item.ORDER_ID }}</span></td>
                    <td><span class="ord-user-chip">{{ item.USER_ID }}</span></td>
                    <td class="prod-info-td">
                        <div class="ord-img-wrap">
                            <img v-if="item.IMG_URL" :src="item.IMG_URL">
                            <span v-else class="ord-img-placeholder">🏕️</span>
                        </div>
                        <span class="ord-prod-name">{{ item.PRODUCT_NAME }}</span>
                    </td>
                    <td class="ord-price">{{ Number(item.REFUND_AMOUNT || 0).toLocaleString() }}원</td>
                    <td class="ord-reason-cell">{{ item.REFUND_REASON }}</td>
                    <td>
                        <div class="ord-action-col">
                            <span class="ord-sbadge" :class="'rfbadge-' + item.REFUND_STATUS">
                                {{ {COMPLETED:'✅ 환불완료', REJECTED:'❌ 거절', PENDING:'⏳ 대기중'}[item.REFUND_STATUS] || item.REFUND_STATUS }}
                            </span>
                            <div class="ord-act-pair" v-if="item.REFUND_STATUS === 'PENDING'">
                                <button class="ord-act-btn act-green ord-sm-btn" @click="fnUpdateRefundStatus(item, 'COMPLETED')">승인</button>
                                <button class="ord-act-btn act-danger ord-sm-btn" @click="fnUpdateRefundStatus(item, 'REJECTED')">거절</button>
                            </div>
                        </div>
                    </td>
                    <td class="ord-date">{{ item.CREATED_AT }}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ════════════════════════════════
         탭: 교환 관리
    ════════════════════════════════ -->
    <div v-if="activeTab === 'exchanges'" class="ord-card">
        <table class="ord-table">
            <thead>
                <tr>
                    <th style="width:8%">교환번호</th>
                    <th style="width:8%">주문번호</th>
                    <th style="width:10%">고객</th>
                    <th class="t-left">상품</th>
                    <th style="width:12%">사유</th>
                    <th style="width:14%">회수주소</th>
                    <th style="width:15%">상태</th>
                    <th style="width:11%">신청일</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="exchangeList.length === 0">
                    <td colspan="8" class="ord-empty-row">
                        <div class="ord-empty-icon">🔄</div>
                        <div>교환 내역이 없습니다.</div>
                    </td>
                </tr>
                <tr class="ord-row" v-for="item in exchangeList" :key="item.EXCHANGE_ID">
                    <td><span class="ord-id-badge">#{{ item.EXCHANGE_ID }}</span></td>
                    <td><span class="ord-id-badge">#{{ item.ORDER_ID }}</span></td>
                    <td><span class="ord-user-chip">{{ item.USER_ID }}</span></td>
                    <td class="prod-info-td">
                        <div class="ord-img-wrap">
                            <img v-if="item.IMG_URL" :src="item.IMG_URL">
                            <span v-else class="ord-img-placeholder">🏕️</span>
                        </div>
                        <span class="ord-prod-name">{{ item.PRODUCT_NAME }}</span>
                    </td>
                    <td class="ord-reason-cell">{{ item.EXCHANGE_REASON || item.REASON || '—' }}</td>
                    <td class="ord-addr-short">{{ item.ADDRESS }} {{ item.DETAILED_ADDRESS || item.DETAIL_ADDRESS }}</td>
                    <td>
                        <div class="ord-action-col">
                            <span class="ord-sbadge" :class="'exbadge-' + (item.EXCHANGE_STATUS || item.STATUS)">
                                {{ {REQUESTED:'📋 신청', APPROVED:'✅ 승인', REJECTED:'❌ 거절', COMPLETED:'🏁 완료'}[item.EXCHANGE_STATUS || item.STATUS] || (item.EXCHANGE_STATUS || item.STATUS) }}
                            </span>
                            <div class="ord-act-pair" v-if="(item.EXCHANGE_STATUS || item.STATUS) === 'REQUESTED'">
                                <button class="ord-act-btn act-green ord-sm-btn"  @click="fnUpdateExchangeStatus(item, 'APPROVED')">승인</button>
                                <button class="ord-act-btn act-danger ord-sm-btn" @click="fnUpdateExchangeStatus(item, 'REJECTED')">거절</button>
                            </div>
                            <button v-if="(item.EXCHANGE_STATUS || item.STATUS) === 'APPROVED'" class="ord-act-btn act-blue ord-sm-btn" @click="fnUpdateExchangeStatus(item, 'COMPLETED')">처리완료</button>
                        </div>
                    </td>
                    <td class="ord-date">{{ item.CREATED_AT }}</td>
                </tr>
            </tbody>
        </table>
    </div>

</div><!-- order-page-container -->

<!-- ════════════════════════════════
     검수 등록 모달
════════════════════════════════ -->
<transition name="ord-modal-fade">
    <div class="ins-overlay" v-if="showInspectionModal" @click.self="showInspectionModal = false">
        <div class="ins-modal">
            <div class="ins-header">
                <div class="ins-header-left">
                    <div class="ins-header-icon">🔍</div>
                    <div>
                        <div class="ins-title">검수 등록</div>
                        <div class="ins-subtitle" v-if="currentInspectionItem">{{ currentInspectionItem.PRODUCT_NAME }}</div>
                    </div>
                </div>
                <button class="ins-close" @click="showInspectionModal = false">✕</button>
            </div>
            <div class="ins-body">
                <div class="ins-info-row" v-if="currentInspectionItem">
                    <div class="ins-info-item">
                        <span class="ins-info-lbl">대여번호</span>
                        <span class="ins-info-val">#{{ currentInspectionItem.RENTAL_ID }}</span>
                    </div>
                    <div class="ins-info-item">
                        <span class="ins-info-lbl">고객</span>
                        <span class="ins-info-val">{{ currentInspectionItem.USER_ID }}</span>
                    </div>
                    <div class="ins-info-item">
                        <span class="ins-info-lbl">반납일</span>
                        <span class="ins-info-val">{{ currentInspectionItem.RETURN_DATE }}</span>
                    </div>
                </div>

                <div class="ins-form-group">
                    <label class="ins-label">상품 상태 <span class="ins-req">*</span></label>
                    <div class="ins-condition-btns">
                        <button class="ins-cond-btn" :class="{active: inspectionForm.conditionCode === 'GOOD'}"    @click="inspectionForm.conditionCode = 'GOOD'">
                            <span>✅</span> 양호
                        </button>
                        <button class="ins-cond-btn" :class="{active: inspectionForm.conditionCode === 'DAMAGED'}" @click="inspectionForm.conditionCode = 'DAMAGED'">
                            <span>⚠️</span> 파손
                        </button>
                        <button class="ins-cond-btn" :class="{active: inspectionForm.conditionCode === 'LOST'}"    @click="inspectionForm.conditionCode = 'LOST'">
                            <span>❌</span> 분실
                        </button>
                    </div>
                </div>

                <transition name="dres-fade">
                    <div class="ins-form-group" v-if="inspectionForm.conditionCode !== 'GOOD'">
                        <label class="ins-label">공제 금액 (원)</label>
                        <input class="ins-input" type="number" v-model.number="inspectionForm.deductionAmt" placeholder="0">
                    </div>
                </transition>

                <div class="ins-form-group">
                    <label class="ins-label">메모</label>
                    <textarea class="ins-input ins-textarea" v-model="inspectionForm.memo" rows="3" placeholder="검수 내용을 입력하세요..."></textarea>
                </div>
            </div>
            <div class="ins-footer">
                <button class="ins-cancel-btn" @click="showInspectionModal = false">취소</button>
                <button class="ins-save-btn" @click="fnSaveInspection">💾 검수 저장</button>
            </div>
        </div>
    </div>
</transition>

<!-- ════════════════════════════════
     확인 모달
════════════════════════════════ -->
<transition name="ord-modal-fade">
    <div class="ord-confirm-overlay" v-if="showConfirm" @click.self="showConfirm = false">
        <div class="ord-confirm-box">
            <div class="ord-confirm-ico">{{ confirmConfig.icon || '❓' }}</div>
            <div class="ord-confirm-title">{{ confirmConfig.title }}</div>
            <div class="ord-confirm-msg" v-html="confirmConfig.msg"></div>
            <div class="ord-confirm-btns">
                <button class="ord-confirm-cancel-btn" @click="showConfirm = false">취소</button>
                <button class="ord-confirm-ok-btn" :class="confirmConfig.danger ? 'ok-danger' : 'ok-primary'" @click="fnRunConfirm">
                    {{ confirmConfig.okLabel || '확인' }}
                </button>
            </div>
        </div>
    </div>
</transition>

<!-- ════════════════════════════════
     토스트 (Vue 기반)
════════════════════════════════ -->
<div class="ord-toast-container">
    <transition-group name="ord-toast-slide">
        <div v-for="t in toasts" :key="t.id" class="ord-toast-item" :class="'ord-toast-' + t.type">
            <div class="ord-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
            <div class="ord-toast-msg">{{ t.message }}</div>
            <button class="ord-toast-close" @click="removeToast(t.id)">✕</button>
            <div class="ord-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
        </div>
    </transition-group>
</div>

</div><!-- #app -->

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
                currentInspectionItem: null,
                showInspectionModal: false,
                showConfirm: false,
                confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, onConfirm: null },
                toasts: []
            };
        },
        computed: {
            returnCount()          { return this.returnList.filter(r => r.RENTAL_STATUS === 'RETURN_REQUESTED').length; },
            pendingRefundCount()   { return this.refundList.filter(r => r.REFUND_STATUS === 'PENDING').length; },
            pendingExchangeCount() { return this.exchangeList.filter(e => (e.EXCHANGE_STATUS || e.STATUS) === 'REQUESTED').length; },
            filteredReturnList() {
                if (this.returnFilter === 'ALL') return this.returnList;
                return this.returnList.filter(r => r.RENTAL_STATUS === this.returnFilter);
            },
            totalPage() { return Math.ceil(this.totalCount / this.pageSize) || 1; },
            pageList() {
                const blockSize = 5, start = Math.floor((this.page - 1) / blockSize) * blockSize + 1;
                const end = Math.min(start + blockSize - 1, this.totalPage);
                const list = [];
                for (let i = start; i <= end; i++) list.push(i);
                return list;
            }
        },
        methods: {
            /* ── 토스트 ── */
            toast(msg, type = 'success', duration = 3000) {
                const id = Date.now() + Math.random();
                this.toasts.push({ id, message: msg, type, duration });
                setTimeout(() => this.removeToast(id), duration);
            },
            removeToast(id) { this.toasts = this.toasts.filter(t => t.id !== id); },

            /* ── 확인 모달 ── */
            fnShowConfirm(cfg) { this.confirmConfig = cfg; this.showConfirm = true; },
            fnRunConfirm() {
                this.showConfirm = false;
                if (this.confirmConfig.onConfirm) this.confirmConfig.onConfirm();
            },

            /* ── 탭 전환 ── */
            switchTab(tab) {
                this.activeTab = tab;
                if (tab === 'returns'    && !this.returnList.length)   this.fnGetReturnList();
                if (tab === 'inspection')  this.fnGetInspectionList();
                if (tab === 'refunds')     this.fnGetRefundList();
                if (tab === 'exchanges')   this.fnGetExchangeList();
                if (tab === 'delivery'   && !this.deliveryList.length) this.fnGetDeliveryList();
            },

            /* ── 주문 목록 ── */
            fnGetList() {
                $.ajax({
                    url: '/admin/order/list.dox', type: 'POST',
                    data: { page: this.page, pageSize: this.pageSize },
                    success: (data) => {
                        if (data.result === 'success') {
                            this.orderList  = (data.list || []).map(o => { o.ORDER_STATUS = String(o.ORDER_STATUS || '').toUpperCase(); return o; });
                            this.totalCount = data.totalCount || 0;
                        }
                    },
                    error: () => this.toast('주문 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnMovePage(p) { if (p < 1 || p > this.totalPage) return; this.page = p; this.fnGetList(); },

            /* ── 주문 상태 변경 ── */
            fnUpdateStatus(order) {
                if (order.ORDER_STATUS === 'CANCEL_REQUESTED') { this.toast('취소요청 상태는 승인 버튼으로 처리하세요', 'error'); return; }
                $.ajax({
                    url: '/admin/order/update-status.dox', type: 'POST',
                    data: { orderId: order.ORDER_ID, status: order.ORDER_STATUS },
                    success: (res) => {
                        if (res.result === 'success') this.toast('주문 상태가 변경되었습니다.', 'success');
                        else this.toast('상태 변경 실패: ' + (res.message || '서버 오류'), 'error');
                    },
                    error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                });
            },

            /* ── 취소 승인 ── */
            fnApproveCancel(order) {
                this.fnShowConfirm({
                    icon: '🚫', title: '주문 취소 승인',
                    msg: '취소 승인 시 <b>결제가 취소</b>됩니다.<br>정말 승인하시겠습니까?',
                    okLabel: '취소 승인', danger: true,
                    onConfirm: () => {
                        $.ajax({
                            url: '/admin/order/cancel-approve.dox', type: 'POST',
                            data: { orderId: order.ORDER_ID },
                            success: (res) => {
                                if (res.result === 'success') { order.ORDER_STATUS = 'CANCELLED'; this.toast('취소 및 환불 처리가 완료되었습니다.', 'success'); }
                                else this.toast('취소 처리 실패: ' + (res.message || '서버 오류'), 'error');
                            },
                            error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                        });
                    }
                });
            },

            /* ── 반납 ── */
            fnGetReturnList() {
                $.ajax({ url: '/admin/rental/return/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.returnList = res.list; },
                    error: () => this.toast('반납 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnUpdateReturnStatus(item, status) {
                const cfgMap = {
                    RETURN_PICKED:    { icon: '🚚', title: '수거 시작',  msg: '수거를 시작하시겠습니까?',    okLabel: '수거 시작' },
                    RETURN_COMPLETED: { icon: '✅', title: '반납 완료',  msg: '반납 완료 처리하시겠습니까?', okLabel: '완료 처리' }
                };
                const cfg = cfgMap[status] || { icon: '🔄', title: '상태 변경', msg: '상태를 변경하시겠습니까?', okLabel: '변경' };
                this.fnShowConfirm({ ...cfg, onConfirm: () => {
                    $.ajax({ url: '/admin/rental/return/update-status.dox', type: 'POST', data: { rentalId: item.RENTAL_ID, status },
                        success: (res) => {
                            if (res.result === 'success') { item.RENTAL_STATUS = status; this.toast('반납 상태가 변경되었습니다.', 'success'); }
                            else this.toast('상태 변경 실패: ' + (res.message || '오류'), 'error');
                        },
                        error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                    });
                }});
            },
            fnSetReturnFilter(f) { this.returnFilter = f; },

            /* ── 검수 ── */
            fnGetInspectionList() {
                $.ajax({ url: '/admin/inspection/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.inspectionList = res.list; },
                    error: () => this.toast('검수 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnOpenInspection(item) {
                this.currentInspectionItem = item;
                this.inspectionForm = { rentalId: item.RENTAL_ID, userId: item.USER_ID, conditionCode: 'GOOD', deductionAmt: 0, memo: '' };
                this.showInspectionModal = true;
            },
            fnSaveInspection() {
                $.ajax({ url: '/admin/inspection/save.dox', type: 'POST', data: this.inspectionForm,
                    success: (res) => {
                        if (res.result === 'success') {
                            this.showInspectionModal = false;
                            this.fnGetInspectionList();
                            this.toast('검수 등록이 완료되었습니다.', 'success');
                        } else this.toast('검수 등록 실패: ' + (res.message || '오류'), 'error');
                    },
                    error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                });
            },

            /* ── 환불 ── */
            fnGetRefundList() {
                $.ajax({ url: '/admin/refund/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.refundList = res.list; },
                    error: () => this.toast('환불 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnUpdateRefundStatus(item, status) {
                const isApprove = status === 'COMPLETED';
                this.fnShowConfirm({
                    icon: isApprove ? '💸' : '❌',
                    title: isApprove ? '환불 승인' : '환불 거절',
                    msg: isApprove ? '환불을 <b>승인</b> 처리하시겠습니까?' : '환불을 <b>거절</b> 처리하시겠습니까?',
                    okLabel: isApprove ? '승인' : '거절', danger: !isApprove,
                    onConfirm: () => {
                        $.ajax({ url: '/admin/refund/update-status.dox', type: 'POST', data: { refundId: item.REFUND_ID, orderId: item.ORDER_ID, userId: item.USER_ID, status },
                            success: (res) => {
                                if (res.result === 'success') { item.REFUND_STATUS = status; this.toast(isApprove ? '환불 승인 완료' : '환불 거절 완료', 'success'); }
                                else this.toast('환불 상태 변경 실패', 'error');
                            },
                            error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                        });
                    }
                });
            },

            /* ── 교환 ── */
            fnGetExchangeList() {
                $.ajax({ url: '/admin/exchange/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.exchangeList = res.list; },
                    error: () => this.toast('교환 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnUpdateExchangeStatus(item, status) {
                const cfgMap = {
                    APPROVED:  { icon: '✅', title: '교환 승인', msg: '교환을 <b>승인</b>하시겠습니까?',      okLabel: '승인', danger: false },
                    REJECTED:  { icon: '❌', title: '교환 거절', msg: '교환을 <b>거절</b>하시겠습니까?',      okLabel: '거절', danger: true  },
                    COMPLETED: { icon: '🏁', title: '교환 완료', msg: '교환 처리를 <b>완료</b>하시겠습니까?', okLabel: '완료', danger: false }
                };
                const cfg = cfgMap[status] || { icon: '🔄', title: '상태 변경', msg: '변경하시겠습니까?', okLabel: '변경', danger: false };
                this.fnShowConfirm({ ...cfg, onConfirm: () => {
                    $.ajax({ url: '/admin/exchange/update-status.dox', type: 'POST', data: { exchangeId: item.EXCHANGE_ID, userId: item.USER_ID, status },
                        success: (res) => {
                            if (res.result === 'success') { item.STATUS = status; item.EXCHANGE_STATUS = status; this.toast('교환 상태가 변경되었습니다.', 'success'); }
                            else this.toast('교환 상태 변경 실패', 'error');
                        },
                        error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                    });
                }});
            },

            /* ── 배송 ── */
            fnRegisterDelivery() {
                if (!this.delivery.orderId)   { this.deliveryResult = { type: 'error', message: '주문번호를 입력하세요.' }; return; }
                if (!this.delivery.trackingNo) { this.deliveryResult = { type: 'error', message: '운송장 번호를 입력하세요.' }; return; }
                this.isDelivering = true; this.deliveryResult = null;
                $.ajax({
                    url: '/admin/delivery/register.dox', type: 'POST',
                    data: { orderId: this.delivery.orderId, trackingNo: this.delivery.trackingNo },
                    success: (res) => {
                        this.isDelivering = false;
                        if (res.result === 'success') {
                            this.deliveryResult = { type: 'success', message: '배송 등록 완료! 주문 상태가 배송중으로 변경되었습니다.' };
                            this.delivery.orderId = ''; this.delivery.trackingNo = '';
                            this.fnGetDeliveryList();
                        } else {
                            this.deliveryResult = { type: 'error', message: res.message || '등록 실패' };
                        }
                    },
                    error: () => { this.isDelivering = false; this.deliveryResult = { type: 'error', message: '서버 오류가 발생했습니다.' }; }
                });
            },
            fnGetDeliveryList() {
                $.ajax({ url: '/admin/delivery/list.dox', type: 'POST',
                    success: (res) => { if (res.result === 'success') this.deliveryList = res.list; }
                });
            },

            /* ── 유틸 ── */
            formatPrice(val) { return Number(val || 0).toLocaleString(); },
            fnReturnStatusText(s) {
                return { RETURN_REQUESTED: '반납요청', RETURN_PICKED: '수거중', RETURN_COMPLETED: '반납완료', IN_USE: '대여중', RESERVED: '예약완료' }[s] || s || '—';
            },
            fnGoDashboard() { location.href = '/admin/dashboard.do'; }
        },
        mounted() {
            this.fnGetList();
            this.fnGetReturnList();
            this.fnGetRefundList();
            this.fnGetExchangeList();
        }
    }).mount('#app');
</script>
</body>
</html>
