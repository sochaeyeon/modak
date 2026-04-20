<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비회원 주문상세 - 모닥모닥</title>
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
            font-family: 'GgiBatang', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex; flex-direction: column;
            color: var(--brown);
        }
        #app { flex: 1; }

        .detail-page {
            max-width: 860px; margin: 0 auto;
            padding: 40px 24px 72px;
            display: flex; flex-direction: column; gap: 20px;
            animation: fadeUp .5s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── 페이지 헤더 ── */
        .page-header {
            display: flex; align-items: flex-end;
            justify-content: space-between; gap: 16px; flex-wrap: wrap;
        }
        .page-eyebrow { font-size: 11px; letter-spacing: 2px; color: var(--brown4); margin-bottom: 6px; }
        .page-title {
            font-family: 'GgiBatang', serif;
            font-size: 26px; font-weight: 800; color: var(--brown); margin-bottom: 4px;
        }
        .page-order-id { font-size: 13px; color: var(--brown3); font-weight: 300; }
        .page-order-id strong { color: var(--orange); font-weight: 600; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; color: var(--brown3); text-decoration: none;
            padding: 8px 16px; border: 1.5px solid var(--border);
            border-radius: 10px; background: var(--white); cursor: pointer;
            transition: all .2s; flex-shrink: 0;
        }
        .btn-back:hover { border-color: var(--brown4); color: var(--brown); }

        /* ── 섹션 카드 ── */
        .section-card {
            background: var(--white); border: 1px solid var(--border);
            border-radius: 20px; overflow: hidden;
        }
        .section-head {
            padding: 18px 24px 16px; border-bottom: 1px solid var(--border2);
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-head h3 {
            font-family: 'GgiBatang', serif;
            font-size: 16px; font-weight: 700; color: var(--brown);
        }
        .section-body { padding: 24px; }

        /* ── 상태 스텝바 ── */
        .status-flow { display: flex; align-items: center; padding: 24px 32px; }
        .status-step {
            flex: 1; display: flex; flex-direction: column;
            align-items: center; gap: 8px; position: relative;
        }
        .status-step::after {
            content: ''; position: absolute;
            top: 20px; left: calc(50% + 22px); right: calc(-50% + 22px);
            height: 2px; background: var(--border2);
        }
        .status-step:last-child::after { display: none; }
        .status-step.done::after { background: rgba(232,115,42,.35); }
        .step-circle {
            width: 40px; height: 40px; border-radius: 50%;
            border: 2px solid var(--border); background: var(--white);
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; position: relative; z-index: 1; transition: all .2s;
        }
        .status-step.done    .step-circle { border-color: var(--orange); background: rgba(232,115,42,.1); }
        .status-step.current .step-circle { border-color: var(--orange); background: var(--orange); }
        .step-name { font-size: 11px; color: var(--brown4); white-space: nowrap; }
        .status-step.done    .step-name { color: var(--brown3); }
        .status-step.current .step-name { color: var(--orange); font-weight: 600; }

        /* ── 주문 정보 그리드 ── */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 32px; }
        .info-label { font-size: 11px; letter-spacing: .8px; color: var(--brown4); margin-bottom: 5px; }
        .info-value { font-size: 14px; color: var(--brown); font-weight: 500; line-height: 1.5; }
        .info-value.price {
            font-family: 'GgiBatang', serif;
            font-size: 20px; color: var(--orange); font-weight: 700;
        }
        .info-divider { grid-column: 1 / -1; height: 1px; background: var(--border2); }

        /* ── 상품 목록 ── */
        .product-list { display: flex; flex-direction: column; gap: 12px; }
        .product-item {
            display: flex; align-items: center; gap: 16px; padding: 16px;
            background: var(--bg); border: 1px solid var(--border2); border-radius: 14px;
            transition: box-shadow .2s;
        }
        .product-item:hover { box-shadow: 0 4px 16px rgba(44,30,15,.06); }
        .product-thumb {
            width: 60px; height: 60px; border-radius: 10px;
            background: var(--cream2); border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-size: 24px; flex-shrink: 0;
        }
        .product-info { flex: 1; min-width: 0; }
        .product-name {
            font-size: 14px; font-weight: 600; color: var(--brown);
            margin-bottom: 4px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
        }
        .product-meta { font-size: 12px; color: var(--brown4); display: flex; gap: 10px; flex-wrap: wrap; }
        .type-badge { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 11px; font-weight: 500; }
        .badge-purchase { background: #fff4ec; color: #e0621a; }
        .badge-rental   { background: #eef6ff; color: #2f6fd8; }
        .product-price-wrap { text-align: right; flex-shrink: 0; }
        .product-price { font-family: 'GgiBatang', serif; font-size: 15px; font-weight: 700; color: var(--brown); }
        .product-qty   { font-size: 12px; color: var(--brown4); margin-top: 2px; }

        /* ── 배송 조회 ── */
        .track-list { display: flex; flex-direction: column; }
        .track-item {
            display: flex; gap: 14px; padding: 14px 0;
            border-bottom: 1px solid var(--border2);
        }
        .track-item:last-child { border-bottom: none; }
        .track-dot-col {
            display: flex; flex-direction: column;
            align-items: center; flex-shrink: 0; width: 14px; padding-top: 4px;
        }
        .track-dot { width: 10px; height: 10px; border-radius: 50%; background: var(--border); flex-shrink: 0; }
        .track-item.is-current .track-dot { background: var(--orange); box-shadow: 0 0 0 3px rgba(232,115,42,.2); }
        .track-line { flex: 1; width: 1px; background: var(--border2); margin-top: 4px; }
        .track-body { flex: 1; }
        .track-status { font-size: 13px; font-weight: 600; color: var(--brown); margin-bottom: 2px; }
        .track-item.is-current .track-status { color: var(--orange); }
        .track-desc { font-size: 12px; color: var(--brown3); font-weight: 300; }
        .track-time { font-size: 11px; color: var(--brown4); white-space: nowrap; flex-shrink: 0; padding-top: 4px; }
        .delivery-info-bar {
            padding: 14px 24px; background: var(--cream2);
            border-top: 1px solid var(--border2);
            font-size: 12px; color: var(--brown3);
            display: flex; gap: 16px; align-items: center; flex-wrap: wrap;
        }
        .delivery-info-bar strong { color: var(--brown); font-size: 13px; }
        .no-tracking {
            text-align: center; padding: 32px 20px;
            color: var(--brown4); font-size: 13px; font-weight: 300; line-height: 1.8;
        }

        /* ── 배송지 정보 ── */
        .receiver-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px 24px; }

        /* ── 취소/반품 ── */
        .action-section {
            background: var(--white); border: 1px solid var(--border);
            border-radius: 20px; padding: 24px;
        }
        .action-title { font-size: 13px; font-weight: 600; color: var(--brown2); margin-bottom: 14px; }
        .action-row   { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn-cancel {
            padding: 12px 24px; background: transparent;
            border: 1.5px solid rgba(201,79,30,.35); border-radius: 12px;
            color: var(--orange2); font-family: 'GgiBatang', sans-serif;
            font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s;
        }
        .btn-cancel:hover { background: rgba(201,79,30,.06); border-color: var(--orange); color: var(--orange); }
        .btn-return {
            padding: 12px 24px; background: transparent;
            border: 1.5px solid var(--border); border-radius: 12px;
            color: var(--brown3); font-family: 'GgiBatang', sans-serif;
            font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s;
        }
        .btn-return:hover { background: var(--cream2); border-color: var(--brown4); color: var(--brown2); }
        .action-notice { font-size: 11.5px; color: var(--brown4); margin-top: 12px; line-height: 1.8; font-weight: 300; }

        /* ── 상태 뱃지 ── */
        .status-badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500; }
        .st-PAID      { background: rgba(232,115,42,.1);  color: #c94f1e; }
        .st-READY     { background: rgba(255,193,7,.15);  color: #9b6a00; }
        .st-SHIPPING  { background: rgba(33,150,243,.12); color: #1565c0; }
        .st-DONE      { background: rgba(76,175,80,.12);  color: #2e7d32; }
        .st-CANCELLED { background: rgba(244,67,54,.12);  color: #c62828; }

        /* ── 모달 ── */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(44,30,15,.45);
            display: none; align-items: center; justify-content: center;
            z-index: 3000; padding: 20px;
        }
        .modal-overlay.open { display: flex; }
        .modal-box {
            background: var(--white); border-radius: 20px;
            padding: 36px 32px 28px; width: 100%; max-width: 400px;
            box-shadow: 0 16px 60px rgba(44,30,15,.18);
            animation: modalIn .25s ease;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(.95) translateY(10px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal-icon  { font-size: 36px; text-align: center; margin-bottom: 16px; }
        .modal-title { font-family: 'GgiBatang', serif; font-size: 20px; font-weight: 800; color: var(--brown); text-align: center; margin-bottom: 10px; }
        .modal-desc  { font-size: 13px; color: var(--brown3); text-align: center; line-height: 1.8; margin-bottom: 28px; white-space: pre-line; }
        .modal-btns  { display: flex; gap: 10px; }
        .modal-btn-no {
            flex: 1; padding: 13px; background: var(--cream2);
            border: none; border-radius: 12px; color: var(--brown2);
            font-size: 14px; cursor: pointer; transition: background .2s;
            font-family: 'GgiBatang', sans-serif;
        }
        .modal-btn-no:hover { background: var(--cream3); }
        .modal-btn-yes {
            flex: 1; padding: 13px; background: #c94f1e;
            border: none; border-radius: 12px; color: #fff;
            font-size: 14px; font-weight: 600; cursor: pointer; transition: background .2s;
            font-family: 'GgiBatang', sans-serif;
        }
        .modal-btn-yes:hover { background: #a33e16; }

        /* ── 로딩/에러 ── */
        .state-box {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            gap: 16px; padding: 80px 20px; text-align: center;
        }
        .spinner {
            width: 40px; height: 40px;
            border: 3px solid var(--cream3);
            border-top-color: var(--orange);
            border-radius: 50%; animation: spin .8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .state-box p { font-size: 14px; color: var(--brown3); line-height: 1.8; }

        /* ── 반응형 ── */
        @media (max-width: 640px) {
            .detail-page   { padding: 24px 16px 56px; }
            .info-grid     { grid-template-columns: 1fr; gap: 16px; }
            .receiver-grid { grid-template-columns: 1fr; gap: 12px; }
            .status-flow   { padding: 20px 8px; }
            .step-name     { font-size: 10px; }
            .status-step::after { display: none; }
            .action-row    { flex-direction: column; }
            .btn-cancel, .btn-return { width: 100%; }
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app">

    <!-- 로딩 -->
    <div class="detail-page" v-if="isLoading">
        <div class="state-box">
            <div class="spinner"></div>
            <p>주문 정보를 불러오는 중입니다...</p>
        </div>
    </div>

    <!-- 에러 -->
    <div class="detail-page" v-else-if="isError">
        <div class="state-box">
            <div style="font-size:48px">📭</div>
            <p>주문 정보를 불러올 수 없습니다.<br>다시 조회해주세요.</p>
            <a href="/order/guest/inquiry.do" class="btn-back" style="margin-top:8px">← 주문조회로 돌아가기</a>
        </div>
    </div>

    <!-- 정상 -->
    <div class="detail-page" v-else-if="order">

        <!-- 헤더 -->
        <div class="page-header">
            <div>
                <p class="page-eyebrow">GUEST ORDER DETAIL</p>
                <h1 class="page-title">주문 상세</h1>
                <p class="page-order-id">주문번호 <strong>{{ order.orderId }}</strong></p>
            </div>
            <a href="/order/guest/inquiry.do" class="btn-back">← 다시 조회하기</a>
        </div>

        <!-- 주문 현황 스텝바 -->
        <div class="section-card">
            <div class="section-head">
                <h3>주문 현황</h3>
                <span class="status-badge" :class="'st-' + order.orderStatus">
                    {{ fnStatusText(order.orderStatus) }}
                </span>
            </div>
            <div class="status-flow">
                <div v-for="(step, i) in statusSteps" :key="i"
                     class="status-step" :class="stepClass(step.code)">
                    <div class="step-circle">{{ step.icon }}</div>
                    <div class="step-name">{{ step.name }}</div>
                </div>
            </div>
        </div>

        <!-- 주문 정보 -->
        <div class="section-card">
            <div class="section-head"><h3>주문 정보</h3></div>
            <div class="section-body">
                <div class="info-grid">
                    <div>
                        <p class="info-label">주문 일시</p>
                        <p class="info-value">{{ fnDateTime(order.createdAt) }}</p>
                    </div>
                    <div>
                        <p class="info-label">주문 유형</p>
                        <p class="info-value">{{ order.orderType === 'PURCHASE' ? '구매' : '대여' }}</p>
                    </div>
                    <div class="info-divider"></div>
                    <div>
                        <p class="info-label">상품 금액</p>
                        <p class="info-value">{{ fnPrice(order.totalPrice + (order.discountAmt || 0)) }}</p>
                    </div>
                    <div>
                        <p class="info-label">할인 금액</p>
                        <p class="info-value" style="color:var(--orange2)">
                            {{ order.discountAmt > 0 ? '- ' + fnPrice(order.discountAmt) : '없음' }}
                        </p>
                    </div>
                    <div class="info-divider"></div>
                    <div style="grid-column: 1 / -1">
                        <p class="info-label">최종 결제 금액</p>
                        <p class="info-value price">{{ fnPrice(order.totalPrice) }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 주문 상품 -->
        <div class="section-card">
            <div class="section-head">
                <h3>주문 상품</h3>
                <span style="font-size:12px;color:var(--brown4)">
                    {{ order.items ? order.items.length : 0 }}개 상품
                </span>
            </div>
            <div class="section-body">
                <div class="product-list">
                    <div v-if="!order.items || order.items.length === 0"
                         style="text-align:center;padding:24px;color:var(--brown4);font-size:13px">
                        상품 정보가 없습니다.
                    </div>
                    <div v-for="item in order.items" :key="item.itemId" class="product-item">
                        <div class="product-thumb">
                            {{ order.orderType === 'RENTAL' ? '⛺' : '🛒' }}
                        </div>
                        <div class="product-info">
                            <p class="product-name">{{ item.productName }}</p>
                            <div class="product-meta">
                                <span class="type-badge"
                                      :class="order.orderType === 'PURCHASE' ? 'badge-purchase' : 'badge-rental'">
                                    {{ order.orderType === 'PURCHASE' ? '구매' : '대여' }}
                                </span>
                                <span v-if="item.startDate && item.endDate">
                                    {{ item.startDate }} ~ {{ item.endDate }}
                                </span>
                            </div>
                        </div>
                        <div class="product-price-wrap">
                            <p class="product-price">{{ fnPrice(item.unitPrice) }}</p>
                            <p class="product-qty">{{ item.quantity }}개</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 배송 조회 -->
        <div class="section-card">
            <div class="section-head"><h3>배송 조회</h3></div>

            <!-- 배송 준비 전 -->
            <div class="no-tracking"
                 v-if="!order.delivery || !order.delivery.deliveryId ||
                       order.orderStatus === 'PAID' || order.orderStatus === 'READY'">
                📦 아직 배송이 시작되지 않았습니다.<br>
                <span style="font-size:12px">배송 준비가 완료되면 운송장 번호가 등록됩니다.</span>
            </div>

            <!-- 취소 -->
            <div class="no-tracking" v-else-if="order.orderStatus === 'CANCELLED'">
                취소 / 반품 처리된 주문입니다.
            </div>

            <!-- 배송 이력 -->
            <div v-else class="section-body" style="padding: 0 24px">
                <div class="track-list">
                    <div v-if="!trackHistory || trackHistory.length === 0" class="no-tracking">
                        배송 조회 정보가 없습니다.
                    </div>
                    <div v-for="(t, i) in trackHistory" :key="i"
                         class="track-item" :class="{ 'is-current': i === 0 }">
                        <div class="track-dot-col">
                            <div class="track-dot"></div>
                            <div class="track-line" v-if="i < trackHistory.length - 1"></div>
                        </div>
                        <div class="track-body">
                            <p class="track-status">{{ t.status }}</p>
                            <p class="track-desc">{{ t.location }}</p>
                        </div>
                        <p class="track-time">{{ t.time }}</p>
                    </div>
                </div>
            </div>

            <!-- 운송장 번호 바 -->
            <div class="delivery-info-bar"
                 v-if="order.delivery && order.delivery.trackingNo">
                <span>🚚 운송장번호</span>
                <strong>{{ order.delivery.trackingNo }}</strong>
                <span style="color:var(--brown4)">배송사 문의 시 사용</span>
            </div>
        </div>

        <!-- 배송지 정보 -->
        <div class="section-card"
             v-if="order.delivery && order.delivery.deliveryId && order.delivery.receiverName">
            <div class="section-head"><h3>배송지 정보</h3></div>
            <div class="section-body">
                <div class="receiver-grid">
                    <div>
                        <p class="info-label">수령인</p>
                        <p class="info-value">{{ order.delivery.receiverName }}</p>
                    </div>
                    <div>
                        <p class="info-label">출고 일시</p>
                        <p class="info-value">{{ fnDateTime(order.delivery.shippedAt) }}</p>
                    </div>
                    <div style="grid-column: 1 / -1">
                        <p class="info-label">배송지 주소</p>
                        <p class="info-value">{{ order.delivery.address || '-' }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 취소/반품 -->
        <div class="action-section"
             v-if="order.orderStatus !== 'CANCELLED' && order.orderStatus !== 'DONE'">
            <p class="action-title">주문 관리</p>
            <div class="action-row">
                <button class="btn-cancel"
                        v-if="order.orderStatus === 'PAID' || order.orderStatus === 'READY'"
                        @click="openModal('cancel')">
                    주문 취소 신청
                </button>
                <button class="btn-return"
                        v-if="order.orderStatus === 'SHIPPING'"
                        @click="openModal('return')">
                    반품 신청
                </button>
            </div>
            <p class="action-notice">
                · 취소는 배송 준비 전까지 가능합니다.<br>
                · 반품은 배송중 상태에서 신청 가능합니다.<br>
                · 대여 상품은 대여 시작 24시간 전까지 취소 가능합니다.
            </p>
        </div>

        <!-- 이미 취소 -->
        <div class="action-section" v-if="order.orderStatus === 'CANCELLED'"
             style="text-align:center;color:var(--brown4)">
            <p style="font-size:14px">이미 취소 / 반품 처리된 주문입니다.</p>
        </div>

    </div><!-- /detail-page -->

    <!-- 모달 -->
    <div class="modal-overlay" :class="{ open: modalOpen }" @click.self="closeModal">
        <div class="modal-box">
            <div class="modal-icon">{{ modalType === 'cancel' ? '🗑️' : '↩️' }}</div>
            <p class="modal-title">{{ modalType === 'cancel' ? '주문 취소' : '반품 신청' }}</p>
            <p class="modal-desc">
                {{ modalType === 'cancel'
                    ? '주문을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.'
                    : '반품을 신청하시겠습니까?\n담당자 확인 후 처리됩니다.' }}
            </p>
            <div class="modal-btns">
                <button class="modal-btn-no"  @click="closeModal">아니요</button>
                <button class="modal-btn-yes" @click="fnConfirm">
                    {{ modalType === 'cancel' ? '취소하기' : '반품신청' }}
                </button>
            </div>
        </div>
    </div>

</div><!-- /#app -->

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    var app = Vue.createApp({
        data: function() {
            return {
                isLoading   : true,
                isError     : false,
                order       : null,
                trackHistory: [],
                modalOpen   : false,
                modalType   : '',
                statusSteps : [
                    { code: 'PAID',     name: '결제완료', icon: '💳' },
                    { code: 'READY',    name: '배송준비', icon: '📦' },
                    { code: 'SHIPPING', name: '배송중',   icon: '🚚' },
                    { code: 'DONE',     name: '배송완료', icon: '✔'  }
                ]
            };
        },

        methods: {
            /* ── 데이터 로드 ── */
            fnLoad: function() {
                var self  = this;
                var p     = new URLSearchParams(location.search);
                var orderId = p.get('orderId');
                var token   = p.get('token');

                if (!orderId || !token) {
                    self.isLoading = false;
                    self.isError   = true;
                    return;
                }

                $.ajax({
                    url     : '/order/guest/detail.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : { orderId: orderId, token: token },
                    success : function(res) {
                        self.isLoading = false;
                        if (res.result === 'success' && res.order) {
                            self.order        = res.order;
                            self.trackHistory = res.trackingList || [];
                        } else {
                            self.isError = true;
                        }
                    },
                    error: function() {
                        self.isLoading = false;
                        self.isError   = true;
                    }
                });
            },

            /* ── 스텝 클래스 ── */
            stepClass: function(code) {
                var steps   = this.statusSteps;
                var cur     = -1;
                var idx     = -1;
                for (var i = 0; i < steps.length; i++) {
                    if (steps[i].code === this.order.orderStatus) cur = i;
                    if (steps[i].code === code) idx = i;
                }
                if (idx < cur)   return 'done';
                if (idx === cur) return 'done current';
                return '';
            },

            /* ── 모달 ── */
            openModal: function(type) { this.modalType = type; this.modalOpen = true; },
            closeModal: function()    { this.modalOpen = false; },

            /* ── 취소/반품 실행 ── */
            fnConfirm: function() {
                var self  = this;
                var url   = self.modalType === 'cancel' ? '/order/guest/cancel.dox' : '/order/guest/return.dox';
                var token = new URLSearchParams(location.search).get('token');

                $.ajax({
                    url     : url,
                    type    : 'POST',
                    dataType: 'json',
                    data    : { orderId: self.order.orderId, token: token },
                    success : function(res) {
                        self.closeModal();
                        if (res.result === 'success') {
                            alert(self.modalType === 'cancel'
                                ? '주문이 취소되었습니다.'
                                : '반품 신청이 완료되었습니다.');
                            self.order.orderStatus = 'CANCELLED';
                        } else {
                            alert(res.message || '처리 중 오류가 발생했습니다.');
                        }
                    },
                    error: function() {
                        self.closeModal();
                        alert('서버 오류가 발생했습니다.');
                    }
                });
            },

            /* ── 날짜 포맷 (템플릿 리터럴 제거 — JSP EL 충돌 방지) ── */
            fnDateTime: function(v) {
                if (!v) return '-';
                var d = new Date(String(v).replace(' ', 'T'));
                if (isNaN(d.getTime())) return String(v);
                var pad = function(n) { return String(n).padStart(2, '0'); };
                return d.getFullYear() + '.' + pad(d.getMonth() + 1) + '.' + pad(d.getDate())
                     + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
            },

            /* ── 가격 포맷 ── */
            fnPrice: function(v) {
                return Number(v || 0).toLocaleString() + '원';
            },

            /* ── 상태 텍스트 ── */
            fnStatusText: function(s) {
                var map = {
                    PAID     : '결제완료',
                    READY    : '배송준비',
                    SHIPPING : '배송중',
                    DONE     : '배송완료',
                    CANCELLED: '취소/반품'
                };
                return map[s] || s || '-';
            }
        },

        mounted: function() {
            this.fnLoad();
        }
    });

    app.mount('#app');
</script>
</body>
</html>
