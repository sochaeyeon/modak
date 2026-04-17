<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Document</title>
                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>
                    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                    <link rel="stylesheet" href="/css/user/mypage.css">

                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>
                        <div id="app">
                            <!-- PAGE -->
                            <div class="page-wrap">

                                <!-- SIDEBAR -->
                                <aside class="sidebar">
                                    <div class="profile-card">
                                        <div class="avatar-ring">
                                            ${not empty user.userName ? fn:substring(user.userName, 0, 1) : '?'}
                                        </div>

                                        <div class="profile-name">
                                            ${user.userName}
                                        </div>

                                        <div class="profile-nick">
                                            @${user.nickName}
                                        </div>

                                        <div
                                            class="level-badge grade-${empty user.gradeName ? 'default' : fn:toLowerCase(user.gradeName)}">
                                            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                                                <path
                                                    d="M6 1L7.5 4.5H11L8.5 7L9.5 10.5L6 8.5L2.5 10.5L3.5 7L1 4.5H4.5Z" />
                                            </svg>
                                            ${empty user.gradeName ? '일반 회원' : user.gradeName}
                                        </div>
                                    </div>

                                    <div class="nav-card">
                                        <div class="nav-section-title">쇼핑</div>

                                        <div class="nav-item active" onclick="switchTab('orders', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <rect x="2" y="4" width="11" height="9" rx="2" stroke="#c94f1e"
                                                    stroke-width="1.3" />
                                                <path d="M5 4V3a2.5 2.5 0 0 1 5 0v1" stroke="#c94f1e" stroke-width="1.3"
                                                    stroke-linecap="round" />
                                            </svg>
                                            주문내역
                                        </div>

                                        <div class="nav-item" onclick="switchTab('address', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <path d="M7.5 13S3 9.3 3 6.5A4.5 4.5 0 0 1 12 6.5C12 9.3 7.5 13 7.5 13Z"
                                                    stroke="#7a5c3e" stroke-width="1.3" />
                                                <circle cx="7.5" cy="6.5" r="1.6" stroke="#7a5c3e" stroke-width="1.2" />
                                            </svg>
                                            배송지 목록
                                        </div>

                                        <div class="nav-item" onclick="switchTab('wishlist', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <path
                                                    d="M7.5 12.5S1.5 8.5 1.5 5A3 3 0 0 1 7.5 4 3 3 0 0 1 13.5 5c0 3.5-6 7.5-6 7.5Z"
                                                    stroke="#7a5c3e" stroke-width="1.3" />
                                            </svg>
                                            찜한 상품
                                        </div>

                                        <div class="nav-item" onclick="switchTab('recent', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <circle cx="7.5" cy="7.5" r="5.5" stroke="#7a5c3e" stroke-width="1.3" />
                                                <path d="M7.5 4.5V7.5l2 2" stroke="#7a5c3e" stroke-width="1.3"
                                                    stroke-linecap="round" />
                                            </svg>
                                            최근 본 상품
                                        </div>

                                        <div class="nav-divider"></div>

                                        <div class="nav-section-title">혜택</div>
                                        <div class="nav-item" onclick="switchTab('benefits', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <circle cx="7.5" cy="7.5" r="5.5" stroke="#7a5c3e" stroke-width="1.3" />
                                                <path d="M5.5 8.5A2.5 2.5 0 0 0 10 7.5M10 6.5A2.5 2.5 0 0 0 5.5 7.5"
                                                    stroke="#7a5c3e" stroke-width="1.2" stroke-linecap="round" />
                                            </svg>
                                            포인트 · 쿠폰
                                        </div>

                                        <div class="nav-divider"></div>

                                        <div class="nav-section-title">활동</div>

                                        <div class="nav-item" onclick="switchTab('reviews', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <path d="M2 2.5h11v7.5H8.5L6 12.5V10H2Z" stroke="#7a5c3e"
                                                    stroke-width="1.3" stroke-linejoin="round" />
                                            </svg>
                                            내 리뷰
                                        </div>

                                        <div class="nav-item" onclick="switchTab('chatbot', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <rect x="2" y="3" width="11" height="8" rx="2" stroke="#7a5c3e"
                                                    stroke-width="1.2" />
                                                <path d="M5 6.5h5M5 8.5h3" stroke="#7a5c3e" stroke-width="1.2"
                                                    stroke-linecap="round" />
                                                <path d="M6 11v2l2-2" stroke="#7a5c3e" stroke-width="1.2"
                                                    stroke-linejoin="round" />
                                            </svg>
                                            챗봇 기록
                                        </div>

                                        <div class="nav-item" onclick="switchTab('inquiries', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <path d="M2.5 3.5h10v8h-10z" stroke="#7a5c3e" stroke-width="1.2" />
                                                <path d="M4.5 6h6M4.5 8h4" stroke="#7a5c3e" stroke-width="1.2"
                                                    stroke-linecap="round" />
                                            </svg>
                                            내 문의 목록
                                        </div>

                                        <div class="nav-divider"></div>

                                        <div class="nav-section-title">계정</div>
                                        <div class="nav-item" onclick="switchTab('settings', this)">
                                            <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                                <circle cx="7.5" cy="7.5" r="2" stroke="#7a5c3e" stroke-width="1.3" />
                                                <path
                                                    d="M7.5 1v1.5M7.5 12.5V14M14 7.5h-1.5M2.5 7.5H1M12 3L11 4M4 11L3 12M12 12l-1-1M4 4L3 3"
                                                    stroke="#7a5c3e" stroke-width="1.3" stroke-linecap="round" />
                                            </svg>
                                            계정 설정
                                        </div>
                                    </div>
                                </aside>

                                <!-- MAIN -->
                                <main class="main">

                                    <!-- 요약 카드 (항상 표시) -->
                                    <div class="stats-grid">
                                        <div class="stat-card"
                                            onclick="switchTab('orders', document.querySelector('.nav-item'))">
                                            <div class="stat-label">총 주문</div>
                                            <div class="stat-value">${summary.orderCount}<span>건</span></div>
                                        </div>

                                        <div class="stat-card accent" onclick="switchTab('benefits', null)">
                                            <div class="stat-label">보유 포인트</div>
                                            <div class="stat-value">
                                                <fmt:formatNumber value="${summary.pointAmount}" pattern="#,###" />
                                                <span>P</span>
                                            </div>
                                        </div>

                                        <div class="stat-card" onclick="switchTab('benefits', null)">
                                            <div class="stat-label">사용 가능 쿠폰</div>
                                            <div class="stat-value">${summary.couponCount}<span>장</span></div>
                                        </div>

                                        <div class="stat-card" onclick="switchTab('wishlist', null)">
                                            <div class="stat-label">찜한 상품</div>
                                            <div class="stat-value">${summary.wishlistCount}<span>개</span></div>
                                        </div>
                                    </div>

                                    <!-- ── 주문내역 탭 ── -->
                                    <div class="tab-panel active" id="tab-orders">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>주문 현황</h3>
                                            </div>
                                            <div class="order-flow">
                                                <div class="flow-step"
                                                    :class="{ 'has-count': statusSummary.paid > 0, 'is-selected': selectedOrderStatus === 'PAID' }"
                                                    @click="fnFilterByStatus('PAID')">
                                                    <div class="flow-circle">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                                            <rect x="4" y="3" width="12" height="14" rx="2"
                                                                stroke="#c94f1e" stroke-width="1.5" />
                                                            <path d="M7 7h6M7 10h4" stroke="#c94f1e" stroke-width="1.3"
                                                                stroke-linecap="round" />
                                                        </svg>
                                                    </div>
                                                    <div class="flow-count">{{ statusSummary.paid }}</div>
                                                    <div class="flow-name">결제완료</div>
                                                </div>

                                                <div class="flow-arrow">›</div>

                                                <div class="flow-step"
                                                    :class="{ 'has-count': statusSummary.ready > 0, 'is-selected': selectedOrderStatus === 'READY' }"
                                                    @click="fnFilterByStatus('READY')">
                                                    <div class="flow-circle">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                                            <rect x="3" y="5" width="14" height="10" rx="2"
                                                                stroke="#b09070" stroke-width="1.4" />
                                                            <path d="M3 9h14" stroke="#b09070" stroke-width="1.3" />
                                                        </svg>
                                                    </div>
                                                    <div class="flow-count">{{ statusSummary.ready }}</div>
                                                    <div class="flow-name">배송준비</div>
                                                </div>

                                                <div class="flow-arrow">›</div>

                                                <div class="flow-step"
                                                    :class="{ 'has-count': statusSummary.shipping > 0, 'is-selected': selectedOrderStatus === 'SHIPPING' }"
                                                    @click="fnFilterByStatus('SHIPPING')">
                                                    <div class="flow-circle">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                                            <path d="M2 11l4-6h8l4 4v4H2v-2Z" stroke="#c94f1e"
                                                                stroke-width="1.4" stroke-linejoin="round" />
                                                            <circle cx="6" cy="15" r="1.5" stroke="#c94f1e"
                                                                stroke-width="1.3" />
                                                            <circle cx="14" cy="15" r="1.5" stroke="#c94f1e"
                                                                stroke-width="1.3" />
                                                        </svg>
                                                    </div>
                                                    <div class="flow-count">{{ statusSummary.shipping }}</div>
                                                    <div class="flow-name">배송중</div>
                                                </div>

                                                <div class="flow-arrow">›</div>

                                                <div class="flow-step"
                                                    :class="{ 'has-count': statusSummary.done > 0, 'is-selected': selectedOrderStatus === 'DONE' }"
                                                    @click="fnFilterByStatus('DONE')">
                                                    <div class="flow-circle">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                                            <path d="M5 10l3.5 3.5L15 7" stroke="#b09070"
                                                                stroke-width="1.6" stroke-linecap="round"
                                                                stroke-linejoin="round" />
                                                        </svg>
                                                    </div>
                                                    <div class="flow-count">{{ statusSummary.done }}</div>
                                                    <div class="flow-name">배송완료</div>
                                                </div>

                                                <div class="flow-arrow">›</div>

                                                <div class="flow-step"
                                                    :class="{ 'has-count': statusSummary.cancelled > 0, 'is-selected': selectedOrderStatus === 'CANCELLED' }"
                                                    @click="fnFilterByStatus('CANCELLED')">
                                                    <div class="flow-circle">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                                            <path d="M7 7l6 6M13 7l-6 6" stroke="#b09070"
                                                                stroke-width="1.4" stroke-linecap="round" />
                                                        </svg>
                                                    </div>
                                                    <div class="flow-count">{{ statusSummary.cancelled }}</div>
                                                    <div class="flow-name">취소/반품</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>최근 주문내역</h3>
                                                <div class="order-head-actions">
                                                    <a href="/order/history.do">더보기 →</a>
                                                </div>
                                            </div>
                                            <div class="order-list">
                                                <div v-if="filteredOrderList.length === 0" class="empty-state">
                                                    <p>해당 상태의 주문내역이 없습니다.</p>
                                                </div>

                                                <div v-for="item in filteredOrderList" :key="item.orderId"
                                                    class="order-item">
                                                    <div class="order-thumb">
                                                        <span v-if="item.orderType === 'PURCHASE'">🛒</span>
                                                        <span v-else-if="item.orderType === 'RENTAL'">⛺</span>
                                                        <span v-else>📦</span>
                                                    </div>

                                                    <div class="order-info">
                                                        <div class="order-name">
                                                            {{ item.productName }}{{ item.itemCount > 1 ? ' 외 ' +
                                                            (item.itemCount - 1) + '건' : '' }}
                                                        </div>

                                                        <div class="order-meta">
                                                            <span class="order-number">주문번호 {{ item.orderId }}</span>
                                                            <span class="dot">·</span>
                                                            <span class="order-date">{{ item.createdAt }}</span>
                                                            <span class="dot">·</span>
                                                            <span class="order-type-badge"
                                                                :class="item.orderType === 'PURCHASE' ? 'purchase' : 'rental'">
                                                                {{ item.orderType === 'PURCHASE' ? '구매' : '대여' }}
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <div
                                                        style="display:flex;flex-direction:column;align-items:flex-end;gap:5px;">
                                                        <div class="order-status" :class="'status-' + item.orderStatus">
                                                            {{ fnGetStatusText(item.orderStatus) }}
                                                        </div>
                                                        <div class="order-price">
                                                            {{ Number(item.totalPrice || 0).toLocaleString() }}원
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 찜한 상품 탭 ── -->
                                    <div class="tab-panel" id="tab-wishlist">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>찜한 상품</h3><a href="#">전체보기 →</a>
                                            </div>
                                            <div class="wish-grid">
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🔥</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">모닥모닥 화로대 미니</div>
                                                        <div class="wish-price">145,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🏕️</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">감성 원목 캠핑 테이블</div>
                                                        <div class="wish-price">89,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🌙</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">별빛 랜턴 LED 캠핑용</div>
                                                        <div class="wish-price">54,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">☕</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">캠핑 드립 커피 세트</div>
                                                        <div class="wish-price">38,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🪑</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">경량 접이식 캠핑 체어</div>
                                                        <div class="wish-price">62,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🪵</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">참나무 장작 프리미엄</div>
                                                        <div class="wish-price">28,000원</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 최근 본 상품 탭 ── -->
                                    <div class="tab-panel" id="tab-recent">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>최근 본 상품</h3>
                                            </div>
                                            <div class="wish-grid">
                                                <div class="wish-item">
                                                    <div class="wish-thumb">⛺</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">4인용 경량 텐트</div>
                                                        <div class="wish-price">218,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🔦</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">다기능 캠핑 헤드랜턴</div>
                                                        <div class="wish-price">32,000원</div>
                                                    </div>
                                                </div>
                                                <div class="wish-item">
                                                    <div class="wish-thumb">🍳</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">캠핑 코펠 4종 세트</div>
                                                        <div class="wish-price">76,000원</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 배송지 목록 탭 ── -->
                                    <div class="tab-panel" id="tab-address">
                                        <div class="section-card">
                                            <div class="section-head address-head">
                                                <div class="title-wrap">
                                                    <h3>배송지 목록</h3>
                                                    <span class="address-limit-text">
                                                        최대 7개 ({{ addressList.length }}/7)
                                                    </span>
                                                </div>

                                                <button class="btn-save" @click="fnShowAddressForm">배송지 추가</button>
                                            </div>

                                            <!-- 추가 버튼 눌렀을 때만 보이게 -->
                                            <div class="address-form-box" v-if="showAddressForm">
                                                <div class="address-form-title">새 배송지 입력</div>

                                                <div class="address-form-row">
                                                    <div class="setting-field">
                                                        <label>배송지 별칭</label>
                                                        <input type="text" v-model="addressForm.addressAlias"
                                                            placeholder="예: 집, 회사, 본가">
                                                    </div>
                                                </div>

                                                <div class="address-form-row">
                                                    <div class="setting-field">
                                                        <label>우편번호</label>
                                                        <div class="zipcode-wrap">
                                                            <input type="text" v-model="addressForm.zipCode"
                                                                placeholder="우편번호" readonly>
                                                            <button type="button" class="btn-outline"
                                                                @click="fnSearchAddress">
                                                                주소 검색
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="address-form-row">
                                                    <div class="setting-field">
                                                        <label>주소</label>
                                                        <input type="text" v-model="addressForm.address"
                                                            placeholder="주소 검색 버튼을 눌러주세요" readonly>
                                                    </div>
                                                </div>

                                                <div class="address-form-row">
                                                    <div class="setting-field">
                                                        <label>상세주소</label>
                                                        <input type="text" v-model="addressForm.detailedAddress"
                                                            placeholder="상세주소를 입력하세요" ref="detailAddressInput">
                                                    </div>
                                                </div>

                                                <div class="address-form-check">
                                                    <label>
                                                        <input type="checkbox" v-model="addressForm.defaultYn">
                                                        기본 배송지로 설정
                                                    </label>
                                                </div>

                                                <div class="settings-actions">
                                                    <button type="button" class="btn-save"
                                                        @click="fnSaveAddress">저장</button>
                                                    <button type="button" class="btn-outline"
                                                        @click="fnCancelAddressForm">취소</button>
                                                </div>
                                                <div v-if="addressMsg" class="address-msg" :class="addressMsgType">
                                                    {{ addressMsg }}
                                                </div>
                                            </div>

                                            <div class="address-list">
                                                <div class="address-item" v-for="addr in addressList"
                                                    :key="addr.addressId">
                                                    <div class="address-top">
                                                        <div class="address-badge" v-if="addr.defaultYn === 'Y'">기본 배송지
                                                        </div>
                                                        <div class="address-name">{{ addr.addressAlias }}</div>
                                                    </div>

                                                    <div class="address-detail">
                                                        {{ addr.address }} {{ addr.detailedAddress }}
                                                    </div>
                                                </div>

                                                <div v-if="addressList.length === 0" class="empty-state">
                                                    <p>등록된 배송지가 없습니다.</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 포인트·쿠폰 탭 ── -->
                                    <div class="tab-panel" id="tab-benefits">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>포인트 · 쿠폰</h3>
                                            </div>
                                            <div class="benefit-grid">
                                                <div class="benefit-card">
                                                    <div class="benefit-title">보유 포인트</div>
                                                    <div class="benefit-amount">4,200<span>P</span></div>
                                                    <div class="benefit-sub">1,000P 이상 사용 가능</div>
                                                </div>
                                                <div class="benefit-card">
                                                    <div class="benefit-title">사용 가능 쿠폰</div>
                                                    <div class="benefit-amount">3<span>장</span></div>
                                                    <div class="benefit-sub">만료 임박 쿠폰 1장</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>포인트 내역</h3>
                                            </div>
                                            <div class="point-history">
                                                <div class="ph-item">
                                                    <div>
                                                        <div class="ph-desc">화로대 미니 구매 적립</div>
                                                        <div class="ph-date">2026.03.28</div>
                                                    </div>
                                                    <div class="ph-point plus">+1,450P</div>
                                                </div>
                                                <div class="ph-item">
                                                    <div>
                                                        <div class="ph-desc">장작 세트 구매 적립</div>
                                                        <div class="ph-date">2026.04.06</div>
                                                    </div>
                                                    <div class="ph-point plus">+320P</div>
                                                </div>
                                                <div class="ph-item">
                                                    <div>
                                                        <div class="ph-desc">회원가입 웰컴 포인트</div>
                                                        <div class="ph-date">2026.01.15</div>
                                                    </div>
                                                    <div class="ph-point plus">+2,000P</div>
                                                </div>
                                                <div class="ph-item">
                                                    <div>
                                                        <div class="ph-desc">텐트 구매 사용</div>
                                                        <div class="ph-date">2026.03.15</div>
                                                    </div>
                                                    <div class="ph-point minus">-1,000P</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 내 리뷰 탭 ── -->
                                    <div class="tab-panel" id="tab-reviews">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>내가 쓴 리뷰</h3>
                                            </div>
                                            <div class="review-list">
                                                <div class="review-item">
                                                    <div class="review-head">
                                                        <span class="review-product">모닥모닥 화로대 미니 스탠드형</span>
                                                        <div class="review-stars">
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                        </div>
                                                    </div>
                                                    <div class="review-body">정말 예뻐요! 사이즈도 딱 적당하고 조립도 쉬웠어요. 혼자 캠핑할 때
                                                        이
                                                        화로대
                                                        하나면 충분할 것
                                                        같아요.
                                                        다음엔 대형도 구매해보려고요.</div>
                                                    <div class="review-date">2026.04.02</div>
                                                </div>
                                                <div class="review-item">
                                                    <div class="review-head">
                                                        <span class="review-product">참나무 장작 10kg + 불쏘시개 세트</span>
                                                        <div class="review-stars">
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#e0621a">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                            <svg class="star" viewBox="0 0 13 13" fill="#ccc">
                                                                <path
                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                            </svg>
                                                        </div>
                                                    </div>
                                                    <div class="review-body">장작 품질은 좋은데 불쏘시개가 생각보다 적게 들어있어요. 불 잘 붙고
                                                        오래
                                                        타는 건
                                                        만족스럽습니다.
                                                    </div>
                                                    <div class="review-date">2026.04.09</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- ── 내 문의 목록 탭 ── -->
                                    <div class="tab-panel" id="tab-inquiries">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>내 문의 목록</h3>
                                            </div>

                                            <!-- 목록 -->
                                            <div v-if="!selectedInquiry">
                                                <div class="inquiry-list">
                                                    <div class="inquiry-item" v-for="item in inquiryList"
                                                        :key="item.inquiryId" @click="fnSelectInquiry(item)">
                                                        <div class="inquiry-title">{{ item.title }}</div>
                                                        <div class="inquiry-date">{{ item.createdAt }}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- 상세 -->
                                            <div v-else class="inquiry-detail-wrap">
                                                <div class="detail-top">
                                                    <button class="btn-outline"
                                                        @click="fnBackToInquiryList">목록으로</button>
                                                </div>

                                                <div class="detail-card">
                                                    <div class="detail-label">문의 제목</div>
                                                    <div class="detail-value">{{ selectedInquiry.title }}</div>
                                                </div>

                                                <div class="detail-card">
                                                    <div class="detail-label">문의 내용</div>
                                                    <div class="detail-value detail-content">{{
                                                        selectedInquiry.content
                                                        }}
                                                    </div>
                                                </div>

                                                <div class="detail-card" v-if="selectedInquiry.answer">
                                                    <div class="detail-label">관리자 답변</div>
                                                    <div class="detail-value detail-content">{{
                                                        selectedInquiry.answer
                                                        }}
                                                    </div>
                                                </div>

                                                <div class="detail-card" v-else>
                                                    <div class="detail-label">관리자 답변</div>
                                                    <div class="detail-value">아직 답변이 등록되지 않았습니다.</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- ── 챗봇 기록 탭 ── -->
                                    <div class="tab-panel" id="tab-chatbot">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>챗봇 기록</h3>
                                            </div>

                                            <div class="history-list">
                                                <div class="history-item" v-for="chat in chatbotList"
                                                    :key="chat.chatId">
                                                    <div class="history-title">{{ chat.title }}</div>
                                                    <div class="history-date">{{ chat.createdAt }}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 계정설정 탭 ── -->
                                    <div class="tab-panel" id="tab-settings">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>기본 정보</h3>
                                            </div>
                                            <div class="settings-form">
                                                <div class="setting-row">
                                                    <div class="setting-field"><label>이름</label><input type="text"
                                                            value="김모닥">
                                                    </div>
                                                    <div class="setting-field"><label>닉네임</label><input type="text"
                                                            value="불꽃이">
                                                    </div>
                                                </div>
                                                <div class="setting-row">
                                                    <div class="setting-field"><label>이메일</label><input type="text"
                                                            value="modak@modakmodak.kr" readonly></div>
                                                    <div class="setting-field"><label>연락처</label><input type="text"
                                                            value="010-1234-5678"></div>
                                                </div>
                                                <div class="settings-actions">
                                                    <button class="btn-save">저장하기</button>
                                                    <button class="btn-outline">취소</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>비밀번호 변경</h3>
                                            </div>
                                            <div class="settings-form">
                                                <div class="setting-row">
                                                    <div class="setting-field"><label>현재 비밀번호</label><input
                                                            type="password" placeholder="현재 비밀번호"></div>
                                                    <div style="display:flex;gap:14px;">
                                                        <div class="setting-field" style="flex:1"><label>새
                                                                비밀번호</label><input type="password" placeholder="새 비밀번호">
                                                        </div>
                                                        <div class="setting-field" style="flex:1">
                                                            <label>확인</label><input type="password"
                                                                placeholder="비밀번호 확인">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="settings-actions"><button class="btn-save">변경하기</button>
                                                </div>
                                            </div>
                                            <div class="settings-divider"></div>
                                            <div class="danger-zone">
                                                <div class="danger-title">계정 관리</div>
                                                <button class="btn-danger">회원탈퇴</button>
                                            </div>
                                        </div>
                                    </div>

                                </main>
                            </div>
                        </div>
                        <%@ include file="/WEB-INF/common/footer.jsp" %>
                </body>

                </html>

                <script>
                    function switchTab(tabId, clickedEl) {
                        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                        document.getElementById('tab-' + tabId).classList.add('active');

                        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));

                        if (clickedEl) {
                            clickedEl.classList.add('active');
                        } else {
                            const map = {
                                orders: 0,
                                address: 1,
                                wishlist: 2,
                                recent: 3,
                                benefits: 4,
                                reviews: 5,
                                chatbot: 6,
                                inquiries: 7,
                                settings: 8
                            };
                            const items = document.querySelectorAll('.nav-item');
                            if (items[map[tabId]]) {
                                items[map[tabId]].classList.add('active');
                            }
                        }
                    }

                    const app = Vue.createApp({
                        data() {
                            return {
                                // 변수 - (key : value)
                                orderList: [],
                                selectedOrderStatus: 'ALL',

                                addressList: [],
                                showAddressForm: false,

                                addressForm: {
                                    addressAlias: "",
                                    zipCode: "",
                                    address: "",
                                    detailedAddress: "",
                                    defaultYn: false
                                },

                                addressMsg: "",
                                addressMsgType: ""
                            };
                        },
                        computed: {
                            statusSummary() {
                                const summary = {
                                    paid: 0,
                                    ready: 0,
                                    shipping: 0,
                                    done: 0,
                                    cancelled: 0
                                };

                                this.orderList.forEach(function (item) {
                                    if (item.orderStatus === "PAID") {
                                        summary.paid++;
                                    } else if (item.orderStatus === "READY") {
                                        summary.ready++;
                                    } else if (item.orderStatus === "SHIPPING") {
                                        summary.shipping++;
                                    } else if (item.orderStatus === "DONE") {
                                        summary.done++;
                                    } else if (item.orderStatus === "CANCELLED") {
                                        summary.cancelled++;
                                    }
                                });

                                return summary;
                            },
                            filteredOrderList() {
                                if (this.selectedOrderStatus === "ALL") {
                                    return this.orderList;
                                }

                                return this.orderList.filter(item => item.orderStatus === this.selectedOrderStatus);
                            },
                        },
                        methods: {
                            // 함수(메소드) - (key : function())
                            fnGetOrderList: function () {
                                let self = this;
                                let param = {};
                                $.ajax({
                                    url: "http://localhost:8080/order/list.dox",
                                    dataType: "json",
                                    type: "POST",
                                    data: param,
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.orderList = data.list;
                                        } else {
                                            self.orderList = [];
                                        }
                                        console.log(data);
                                    }
                                });
                            },
                            fnGetStatusText: function (status) {
                                if (status === "PAID") return "결제완료";
                                if (status === "READY") return "배송준비";
                                if (status === "SHIPPING") return "배송중";
                                if (status === "DONE") return "배송완료";
                                if (status === "CANCELLED") return "취소됨";
                                return "-";
                            },
                            fnFilterByStatus: function (status) {
                                if (this.selectedOrderStatus === status) {
                                    // 같은 거 다시 누르면 전체로
                                    this.selectedOrderStatus = "ALL";
                                } else {
                                    this.selectedOrderStatus = status;
                                }
                            },

                            fnShowAddressForm: function () {
                                if (this.addressList.length >= 7) {
                                    this.addressMsg = "배송지는 최대 7개까지 등록할 수 있습니다.";
                                    this.addressMsgType = "error";
                                    return;
                                }

                                this.addressMsg = "";
                                this.showAddressForm = true;
                            },

                            fnCancelAddressForm: function () {
                                this.showAddressForm = false;
                                this.addressMsg = "";

                                this.addressForm = {
                                    addressAlias: "",
                                    zipCode: "",
                                    address: "",
                                    detailedAddress: "",
                                    defaultYn: false
                                };
                            },

                            // 배송지 관련 함수
                            fnSaveAddress: function () {
                                let self = this;

                                self.addressMsg = "";

                                if (!self.addressForm.addressAlias.trim()) {
                                    self.addressMsg = "배송지 별칭을 입력해주세요.";
                                    self.addressMsgType = "error";
                                    return;
                                }

                                if (!self.addressForm.zipCode.trim()) {
                                    self.addressMsg = "주소 검색을 통해 우편번호를 입력해주세요.";
                                    self.addressMsgType = "error";
                                    return;
                                }

                                if (!self.addressForm.address.trim()) {
                                    self.addressMsg = "주소를 입력해주세요.";
                                    self.addressMsgType = "error";
                                    return;
                                }

                                if (!self.addressForm.detailedAddress.trim()) {
                                    self.addressMsg = "상세주소를 입력해주세요.";
                                    self.addressMsgType = "error";
                                    return;
                                }

                                let param = {
                                    addressAlias: self.addressForm.addressAlias,
                                    zipCode: self.addressForm.zipCode,
                                    address: self.addressForm.address,
                                    detailedAddress: self.addressForm.detailedAddress,
                                    defaultYn: self.addressForm.defaultYn ? "Y" : "N"
                                };

                                $.ajax({
                                    url: "/user/address/add.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: param,
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.addressMsg = "배송지가 등록되었습니다.";
                                            self.addressMsgType = "success";

                                            self.fnCancelAddressForm();
                                            self.fnGetAddressList(); // 🔥 리스트 갱신
                                        } else {
                                            self.addressMsg = data.message || "등록 실패";
                                            self.addressMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.addressMsg = "서버 오류가 발생했습니다.";
                                        self.addressMsgType = "error";
                                    }
                                });
                            },

                            fnGetAddressList: function () {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/user/address/list.dox",
                                    dataType: "json",
                                    type: "POST",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.addressList = data.list;
                                        } else {
                                            self.addressList = [];
                                        }
                                    }
                                });
                            },
                            fnSearchAddress: function () {
                                let self = this;

                                new kakao.Postcode({
                                    oncomplete: function (data) {
                                        let addr = "";

                                        if (data.userSelectedType === "R") {
                                            addr = data.roadAddress;   // 도로명 주소
                                        } else {
                                            addr = data.jibunAddress;  // 지번 주소
                                        }

                                        self.addressForm.zipCode = data.zonecode;
                                        self.addressForm.address = addr;

                                        self.$nextTick(function () {
                                            if (self.$refs.detailAddressInput) {
                                                self.$refs.detailAddressInput.focus();
                                            }
                                        });
                                    }
                                }).open();
                            },
                        }, // methods
                        mounted() {
                            let self = this;
                            self.fnGetOrderList();
                            self.fnGetAddressList();
                        }
                    });

                    app.mount('#app');
                </script>