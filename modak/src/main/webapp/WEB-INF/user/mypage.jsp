<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>마이페이지</title>
                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>
                    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                    <link rel="stylesheet" href="/css/user/mypage.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">

                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>
                        <div id="app">
                            <!-- PAGE -->
                            <div class="page-wrap">

                                <!-- SIDEBAR -->
                                <aside class="sidebar">
                                    <div class="profile-card">
                                        <div class="avatar-wrap">
    <div class="avatar-ring profile-avatar" @click="fnTriggerProfileFile">
       <img :src="profileImageSrc"
     alt="프로필 이미지"
     class="profile-avatar-img">

        <div class="profile-overlay">
            <div class="overlay-content">
                <span class="overlay-icon">📷</span>
                <span>사진 변경</span>
            </div>
        </div>
    </div>

    <div class="profile-image-actions">
        <button type="button" class="profile-action-btn change" @click="fnTriggerProfileFile">
            변경
        </button>
        <button type="button" class="profile-action-btn delete" @click="fnDeleteProfile">
            삭제
        </button>
    </div>

    <input type="file"
           ref="profileFileInput"
           accept="image/*"
           style="display:none;"
           @change="fnProfileImageChange">
</div>

                                        <div class="profile-name">
                                            {{ displayUser.userName }}
                                        </div>

                                        <div class="profile-nick">
                                            @{{ displayUser.nickName }}
                                        </div>

                                        <div class="level-badge 
    grade-${empty user.gradeName ? 'default' : fn:toLowerCase(user.gradeName)}" @click="fnGoMembershipInfo">
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

    <div v-for="item in limitedOrderList" :key="item.orderId" class="order-item">
        <div class="order-thumb">
            <img
                v-if="item.itemList && item.itemList.length > 0 && item.itemList[0].imgUrl"
                :src="item.itemList[0].imgUrl"
                :alt="item.itemList[0].productName"
                class="order-thumb-img"
            >
            <span v-else-if="item.orderType === 'PURCHASE'">🛒</span>
            <span v-else-if="item.orderType === 'RENTAL'">⛺</span>
            <span v-else>📦</span>
        </div>

        <div class="order-info">
            <div class="order-name">
                {{ item.itemList && item.itemList.length > 0 ? item.itemList[0].productName : '상품명 없음' }}
                {{ item.itemList && item.itemList.length > 1 ? ' 외 ' + (item.itemList.length - 1) + '건' : '' }}
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

        <div class="order-side">
            <div class="order-status" :class="'status-' + item.orderStatus">
                {{ fnGetStatusText(item.orderStatus) }}
            </div>

            <div class="order-price">
                {{ Number(item.totalPrice || 0).toLocaleString() }}원
            </div>

            <div class="order-action-wrap" v-if="fnGetOrderActions(item).length > 0">
                <button
                    type="button"
                    class="btn-order-action"
                    :class="fnGetActionClass(action)"
                    v-for="action in fnGetOrderActions(item)"
                    :key="action"
                    @click="fnHandleOrderAction(item, action)">
                    {{ action }}
                </button>
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
                                                <h3>찜한 상품</h3><a href="javascript:;" @click="fnGoWishlistHistory">더보기
                                                    →</a>
                                            </div>
                                            <div class="wish-grid">
                                                <div v-if="wishlist.length === 0" class="empty-state">
                                                    <p>찜한 상품이 없습니다.</p>
                                                </div>

                                                <div class="wish-item" v-for="item in limitedWishlist"
                                                    :key="item.productId" @click="fnGoProductDetail(item.productId)">
                                                    <div class="wish-thumb">
    <img v-if="item.imgUrl"
         :src="item.imgUrl"
         style="width:100%; height:100%; object-fit:cover;">
    <span v-else>🛒</span>
</div>
                                                    <div class="wish-body">
                                                        <div class="wish-name">{{ item.productName }}</div>
                                                        <div class="wish-price">{{ Number(item.price ||
                                                            0).toLocaleString() }}원</div>
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
                                                <a href="javascript:;" @click="fnGoRecentHistory">더보기 →</a>
                                            </div>
                                            <div class="wish-grid">
                                                <div v-if="recentList.length === 0" class="empty-state">
                                                    <p>최근 본 상품이 없습니다.</p>
                                                </div>

                                                <div class="wish-item" v-for="item in recentList" :key="item.productId"
    @click="fnGoProductDetail(item.productId)">

    <div class="wish-thumb">
        <img v-if="item.imgUrl"
             :src="item.imgUrl"
             style="width:100%; height:100%; object-fit:cover;">
        <span v-else>🛒</span>
    </div>

    <div class="wish-body">
        <div class="wish-name">{{ item.productName }}</div>
        <div class="wish-price">
            {{ Number(item.price || 0).toLocaleString() }}원
        </div>
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

                                            <!-- 폼 바깥으로 메시지 이동 -->
                                            <div v-if="addressMsg" class="address-msg" :class="addressMsgType">
                                                {{ addressMsg }}
                                            </div>

                                            <!-- 추가 버튼 눌렀을 때만 보이게 -->
                                            <div class="address-form-box" v-if="showAddressForm">
                                                <div class="address-form-title">
                                                    {{ isEditMode ? '배송지 수정' : '새 배송지 입력' }}
                                                </div>

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
                                                    <button type="button" class="btn-save" @click="fnSaveAddress">
                                                        {{ isEditMode ? '수정' : '저장' }}
                                                    </button>
                                                    <button type="button" class="btn-outline"
                                                        @click="fnCancelAddressForm">취소</button>
                                                </div>
                                            </div>
                                            <div class="address-list">
                                                <div class="address-item" v-for="addr in addressList"
                                                    :key="addr.addressId">
                                                    <div class="address-top">
                                                        <div class="address-left">
                                                            <div class="address-badge" v-if="addr.defaultYn === 'Y'">기본
                                                                배송지</div>
                                                            <div class="address-name">{{ addr.addressAlias }}</div>
                                                        </div>

                                                        <div class="address-actions">
                                                            <button type="button" class="btn-outline btn-sm"
                                                                @click="fnEditAddress(addr)">수정</button>
                                                            <button type="button" class="btn-outline btn-sm danger"
                                                                @click="fnDeleteAddress(addr.addressId)">삭제</button>
                                                        </div>
                                                    </div>

                                                    <div class="address-detail">
                                                        ({{ addr.zipCode }}) {{ addr.address }} {{ addr.detailedAddress
                                                        }}
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
                                                    <div class="benefit-amount">
                                                        <fmt:formatNumber value="${summary.pointAmount}"
                                                            pattern="#,###" />
                                                        <span>P</span>
                                                    </div>
                                                    <div class="benefit-sub">1,000P 이상 사용 가능</div>
                                                </div>

                                                <div class="benefit-card">
                                                    <div class="benefit-title">사용 가능 쿠폰</div>
                                                    <div class="benefit-amount">
                                                        ${summary.couponCount}<span>장</span>
                                                    </div>
                                                    <div class="benefit-sub">
                                                        <c:choose>
                                                            <c:when test="${summary.expiringCouponCount > 0}">
                                                                만료 임박 쿠폰 ${summary.expiringCouponCount}장
                                                            </c:when>
                                                            <c:otherwise>
                                                                만료 임박 쿠폰 없음
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="section-card">
                                            <div class="section-head benefits-history-head">
                                                <h3>포인트 · 쿠폰 내역</h3>
                                                <a href="javascript:;" @click="fnGoBenefitHistory">더보기 →</a>
                                            </div>

                                            <div class="benefits-history-split">

                                                <!-- 왼쪽 : 포인트 내역 -->
                                                <div class="benefits-history-col">
                                                    <div class="benefits-sub-head">
                                                        <h4>포인트 내역</h4>
                                                    </div>

                                                    <div class="point-history mini-history">
                                                        <c:choose>
                                                            <c:when test="${not empty pointHistoryList}">
                                                                <c:forEach var="item" items="${pointHistoryList}">
                                                                    <div class="ph-item">
                                                                        <div>
                                                                            <div class="ph-desc">${item.description}
                                                                            </div>
                                                                            <div class="ph-date">${item.createdAt}</div>
                                                                        </div>

                                                                        <div
                                                                            style="display:flex; flex-direction:column; align-items:flex-end; gap:4px;">
                                                                         <div class="ph-point ${item.amount >= 0 ? 'plus' : 'minus'}">
    <c:if test="${item.amount >= 0}">+</c:if>
    <c:if test="${item.amount < 0}">-</c:if>
    <fmt:formatNumber value="${item.amount < 0 ? item.amount * -1 : item.amount}" pattern="#,###" />P
</div>
                                                                            <div class="ph-balance">
                                                                                잔액
                                                                                <fmt:formatNumber
                                                                                    value="${item.balanceAfter}"
                                                                                    pattern="#,###" />P
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <div class="empty-state small-empty">
                                                                    <p>포인트 내역이 없습니다.</p>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- 오른쪽 : 쿠폰 리스트 -->
                                                <div class="benefits-history-col">
                                                    <div class="benefits-sub-head">
                                                        <h4>쿠폰 리스트</h4>
                                                    </div>

                                                    <div class="coupon-history mini-history">
                                                        <c:choose>
                                                            <c:when test="${not empty couponList}">
                                                                <c:forEach var="item" items="${couponList}">
                                                                    <div class="coupon-item">
                                                                        <div class="coupon-left">
                                                                            <div class="coupon-name">${item.couponName}
                                                                            </div>
                                                                            <div class="coupon-date">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty item.expiredAt}">
                                                                                        ~ ${item.expiredAt}
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        사용기한 없음
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>

                                                                        <div class="coupon-right">
                                                                            <div
                                                                                class="coupon-status ${fn:toLowerCase(item.status)}">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${item.status eq 'AVAILABLE'}">
                                                                                        사용 가능</c:when>
                                                                                    <c:when
                                                                                        test="${item.status eq 'USED'}">
                                                                                        사용 완료</c:when>
                                                                                    <c:when
                                                                                        test="${item.status eq 'EXPIRED'}">
                                                                                        만료</c:when>
                                                                                    <c:otherwise>${item.status}
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <div class="empty-state small-empty">
                                                                    <p>보유 쿠폰이 없습니다.</p>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 내 리뷰 탭 ── -->
                                    <div class="tab-panel" id="tab-reviews">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>내가 쓴 리뷰</h3>
                                                <a href="/user/review/history.do">더보기 →</a>
                                            </div>

                                            <div class="review-list">
                                                <c:choose>
                                                    <c:when test="${not empty reviewList}">
                                                        <c:forEach var="item" items="${reviewList}">
                                                            <div class="review-item">

                                                                <div class="review-head">
                                                                    <span class="review-product clickable"
                                                                        @click="fnGoProductDetail(${item.productId})">
                                                                        ${ item.productName }
                                                                    </span>

                                                                    <div class="review-stars">
                                                                        <c:forEach begin="1" end="5" var="i">
                                                                            <svg class="star" viewBox="0 0 13 13"
                                                                                fill="${i <= item.rating ? '#e0621a' : '#ccc'}">
                                                                                <path
                                                                                    d="M6.5 1l1.5 3.5H12L9 7l1 3.5-3.5-2-3.5 2L4 7 1 4.5h4Z" />
                                                                            </svg>
                                                                        </c:forEach>
                                                                    </div>
                                                                </div>

                                                                <div class="review-title">
                                                                    ${item.title}
                                                                </div>

                                                                <div class="review-body">
                                                                    ${item.content}
                                                                </div>
                                                                <c:if test="${not empty item.imageList}">
                                                                    <div class="review-image-wrap">

                                                                        <div class="review-image-grid">
                                                                            <c:forEach var="img"
                                                                                items="${item.imageList}"
                                                                                varStatus="status">
                                                                                <c:if test="${status.index < 4}">
                                                                                    <div class="review-image-thumb">

                                                                                        <img src="${img.imgUrl}"
                                                                                            alt="리뷰 이미지">

                                                                                        <c:if
                                                                                            test="${status.index == 3 && item.imageCount > 4}">
                                                                                            <div
                                                                                                class="review-image-overlay">
                                                                                                +${item.imageCount - 4}
                                                                                            </div>
                                                                                        </c:if>

                                                                                    </div>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                        <c:if test="${item.imageCount > 4}">

                                                                        </c:if>

                                                                    </div>
                                                                </c:if>

                                                                <div class="review-bottom">
                                                                    <div class="review-date">
                                                                        ${item.createdAt}
                                                                    </div>

                                                                    <div class="review-actions">
                                                                        <button type="button" class="btn-outline btn-sm"
                                                                            @click="fnEditReview('${item.reviewId}')">수정</button>
                                                                        <button type="button"
                                                                            class="btn-outline btn-sm danger"
                                                                            @click="fnRemoveReview('${item.reviewId}')">삭제</button>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </c:forEach>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <div class="empty-state">
                                                            <p>작성한 리뷰가 없습니다.</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- ── 내 문의 목록 탭 ── -->
                                    <div class="tab-panel" id="tab-inquiries">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>내 문의 목록</h3>
                                                <a href="/user/inquiry/history.do">더보기 →</a>
                                            </div>

                                            <div class="review-list inquiry-review-list">
                                                <div v-if="inquiryList.length === 0" class="empty-state">
                                                    <p>문의 내역이 없습니다.</p>
                                                </div>

                                                <div class="review-item inquiry-review-item" v-for="item in inquiryList"
                                                    :key="item.inquiryId">

                                                    <div class="review-head inquiry-head"
                                                        @click="fnToggleInquiry(item)">
                                                        <div class="inquiry-head-left">
                                                            <div class="review-title inquiry-main-title">
                                                                {{ item.title }}
                                                            </div>

                                                            <div class="review-date inquiry-meta">
                                                                {{ item.createdAt }}
                                                            </div>
                                                        </div>

                                                        <div class="inquiry-head-right">
                                                            <div class="inquiry-status"
                                                                :class="fnInquiryStatusClass(item)">
                                                                {{ fnInquiryStatusText(item) }}
                                                            </div>

                                                            <div class="review-actions" v-if="!item.replyId">
                                                                <button type="button" class="btn-outline btn-sm"
                                                                    @click.stop="fnEditInquiry(item.inquiryId)">
                                                                    수정
                                                                </button>
                                                                <button type="button" class="btn-outline btn-sm danger"
                                                                    @click.stop="fnDeleteInquiry(item.inquiryId)">
                                                                    삭제
                                                                </button>
                                                            </div>

                                                            <div class="inquiry-toggle-icon"
                                                                :class="{ open: openInquiryId === item.inquiryId }">
                                                                ▼
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div v-if="openInquiryId === item.inquiryId"
                                                        class="inquiry-expand-area">
                                                        <div class="inquiry-detail-box">
                                                            <div class="inquiry-detail-section">
                                                                <div class="detail-label">문의 내용</div>
                                                                <div class="detail-value detail-content">
                                                                    {{ item.content }}
                                                                </div>
                                                            </div>

                                                            <div class="inquiry-detail-divider"
                                                                v-if="item.imageList && item.imageList.length > 0">
                                                            </div>

                                                            <div class="inquiry-detail-section"
                                                                v-if="item.imageList && item.imageList.length > 0">
                                                                <div class="detail-label">첨부 이미지</div>
                                                                <div class="detail-value">
                                                                    <div class="inquiry-image-list">
                                                                        <img v-for="img in item.imageList"
                                                                            :key="img.inquiryImgId" :src="img.imgUrl"
                                                                            class="inquiry-detail-img" alt="문의 이미지">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="inquiry-detail-box answer-box">
                                                            <div class="inquiry-detail-section">
                                                                <div class="detail-label">문의 답변</div>
                                                                <div class="detail-value detail-content"
                                                                    v-if="item.answer">
                                                                    {{ item.answer }}
                                                                </div>
                                                                <div class="detail-value" v-else>
                                                                    아직 답변이 등록되지 않았습니다.
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 챗봇 기록 탭 ── -->
                                    <div class="tab-panel" id="tab-chatbot">
                                        <div class="section-card">
                                            <div class="section-head">
                                                <h3>챗봇 기록</h3>
                                                <a href="javascript:;" @click="fnGoChatbotHistory">더보기 →</a>
                                            </div>

                                            <div class="review-list chatbot-review-list">
                                                <div v-if="chatbotList.length === 0" class="empty-state">
                                                    <p>챗봇 기록이 없습니다.</p>
                                                </div>

                                                <div class="review-item chatbot-review-item"
                                                    v-for="chat in limitedChatbotList" :key="chat.roomId"
                                                    @click="fnGoChatbotRoom(chat.roomId)">

                                                    <div class="review-head chatbot-head">
                                                        <div class="chatbot-head-left">
                                                            <div class="chatbot-icon-wrap">💬</div>

                                                            <div class="chatbot-head-text">
                                                                <div class="review-title chatbot-title">
                                                                    {{ chat.title && chat.title.trim() ? chat.title :
                                                                    '대화' }}
                                                                </div>

                                                                <div class="chatbot-preview" v-if="chat.lastMessage">
                                                                    {{ chat.lastMessage }}
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="chatbot-arrow">→</div>
                                                    </div>

                                                    <div class="review-bottom chatbot-bottom">
                                                        <div class="review-date chatbot-date">
                                                            {{ chat.lastRegDate }}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ── 계정설정 탭 ── -->
                                    <div class="tab-panel" id="tab-settings">

                                        <!-- 일반 회원 -->
                                        <template v-if="!settingsForm.socialType">
                                            <!-- 기본 정보 -->
                                            <div class="section-card">
                                                <div class="section-head">
                                                    <h3>기본 정보</h3>
                                                </div>

                                                <div class="settings-form">
                                                    <div v-if="settingsMsg" class="settings-msg"
                                                        :class="settingsMsgType">
                                                        {{ settingsMsg }}
                                                    </div>

                                                    <div class="setting-row">
                                                        <div class="setting-field">
                                                            <label>이름</label>
                                                            <input type="text" v-model="settingsForm.userName">
                                                        </div>

                                                        <div class="setting-field">
                                                            <label>닉네임</label>
                                                            <input type="text" v-model="settingsForm.nickName">
                                                        </div>
                                                    </div>

                                                    <div class="setting-row">
                                                        <div class="setting-field">
                                                            <label>이메일</label>
                                                            <input type="text" v-model="settingsForm.email" readonly>
                                                        </div>

                                                        <div class="setting-field">
                                                            <label>연락처</label>

                                                            <div class="phone-verify-wrap">
                                                                <div class="phone-input-row">
                                                                    <input type="text" v-model="settingsForm.userPhone"
                                                                        placeholder="01012345678"
                                                                        @input="fnHandlePhoneChanged">

                                                                    <button type="button" class="btn-outline"
                                                                        @click="fnSendSmsCode">
                                                                        인증번호 받기
                                                                    </button>
                                                                </div>

                                                                <div class="phone-verify-status">
                                                                    <span v-if="settingsForm.phoneVerifyYn === 'Y'"
                                                                        class="verify-success">
                                                                        인증 완료
                                                                        <span v-if="settingsForm.phoneVerifiedAt">
                                                                            ({{ settingsForm.phoneVerifiedAt }})
                                                                        </span>
                                                                    </span>
                                                                    <span v-else-if="smsInputVisible"
                                                                        class="verify-fail">미인증</span>
                                                                </div>

                                                                <div
                                                                    v-if="smsInputVisible && settingsForm.phoneVerifyYn !== 'Y'">
                                                                    <div class="phone-timer-wrap"
                                                                        v-if="smsTimeLeft > 0">
                                                                        <span class="phone-timer-text">남은 시간 {{
                                                                            formattedSmsTime }}</span>
                                                                    </div>

                                                                    <div class="phone-timer-wrap" v-if="smsExpired">
                                                                        <span class="phone-timer-expired">
                                                                            인증번호가 만료되었습니다. 다시 발급해주세요.
                                                                        </span>
                                                                    </div>

                                                                    <div class="phone-input-row">
                                                                        <input type="text" v-model="smsAuthCode"
                                                                            maxlength="6" placeholder="인증번호 6자리 입력">

                                                                        <button type="button" class="btn-save"
                                                                            @click="fnVerifySmsCode">
                                                                            인증 확인
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="settings-actions">
                                                        <button type="button" class="btn-save"
                                                            @click="fnSaveSettings">저장</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- 비밀번호 변경 -->
                                            <div class="section-card">
                                                <div class="section-head">
                                                    <h3>비밀번호 변경</h3>
                                                </div>

                                                <div class="settings-lock-box"
                                                    v-if="settingsForm.phoneVerifyYn !== 'Y'">
                                                    <div class="settings-lock-title">휴대폰 인증 후 비밀번호 변경 가능</div>
                                                    <div class="settings-lock-desc">
                                                        계정 보안을 위해 휴대폰 인증을 완료한 뒤 비밀번호를 변경할 수 있습니다.
                                                    </div>
                                                </div>

                                                <div class="settings-form" v-else>
                                                    <div v-if="passwordMsg" class="settings-msg"
                                                        :class="passwordMsgType">
                                                        {{ passwordMsg }}
                                                    </div>

                                                    <div class="setting-row">
                                                        <div class="setting-field">
                                                            <label>현재 비밀번호</label>
                                                            <input type="password" v-model="passwordForm.currentPwd"
                                                                placeholder="현재 비밀번호">
                                                        </div>

                                                        <div style="display:flex;gap:14px;">
                                                            <div class="setting-field" style="flex:1">
                                                                <label>새 비밀번호</label>
                                                                <input type="password" v-model="passwordForm.newPwd"
                                                                    placeholder="새 비밀번호">

                                                                <div class="password-guide"
                                                                    :class="passwordStrengthClass">
                                                                    {{ passwordStrengthText }}
                                                                </div>
                                                            </div>

                                                            <div class="setting-field" style="flex:1">
                                                                <label>확인</label>
                                                                <input type="password"
                                                                    v-model="passwordForm.newPwdConfirm"
                                                                    placeholder="비밀번호 확인">

                                                                <div class="password-guide"
                                                                    v-if="passwordForm.newPwdConfirm"
                                                                    :class="passwordMatch ? 'match-ok' : 'match-fail'">
                                                                    {{ passwordMatch ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.' }}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="settings-actions">
                                                        <button type="button" class="btn-save"
                                                            @click="fnChangePassword">변경하기</button>
                                                    </div>
                                                </div>

                                            </div>
                                        </template>

                                        <!-- 소셜 로그인 회원 -->
                                        <div class="section-card social-only-box" v-else>
                                            <div class="social-message">
                                                소셜 로그인 회원은 계정 정보를 수정할 수 없습니다.
                                            </div>
                                        </div>
                                        <div class="section-card">
                                            <div class="settings-divider"></div>

                                            <div class="danger-zone">
                                                <div class="danger-title">계정 관리</div>
                                                <button class="btn-danger" @click="fnDeleteUser">회원탈퇴</button>
                                            </div>
                                        </div>

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
                                addressMsgType: "",

                                isEditMode: false,
                                editAddressId: "",

                                wishlist: [],
                                recentList: [],
                                chatbotList: [],

                                settingsForm: {
                                    userName: "",
                                    nickName: "",
                                    email: "",
                                    userPhone: "",
                                    phoneVerifyYn: "N",
                                    phoneVerifiedAt: "",
                                    socialType: ""
                                },
                                originalPhone: "",
                                verifiedPhone: "",
                                smsAuthCode: "",
                                settingsMsg: "",
                                settingsMsgType: "",

                                passwordForm: {
                                    currentPwd: "",
                                    newPwd: "",
                                    newPwdConfirm: ""
                                },
                                smsTimer: null,
                                smsTimeLeft: 0,
                                smsExpired: false,

                                smsInputVisible: false,
                                passwordMsg: "",
                                passwordMsgType: "",
                                inquiryList: [],
                                openInquiryId: null,

                                displayUser: {
                                    userName: "${user.userName}",
                                    nickName: "${user.nickName}",
                                    profileImgUrl: "${empty user.profileImgUrl ? '' : user.profileImgUrl}"
                                },
                                 profileImageVersion: Date.now(),
                            };
                        },
                        computed: {
                            limitedOrderList() {
    return this.filteredOrderList.slice(0, 5);
},
                            passwordStrengthScore() {
                                let pwd = this.passwordForm.newPwd || "";
                                let score = 0;

                                if (pwd.length >= 8) score++;
                                if (/[A-Za-z]/.test(pwd)) score++;
                                if (/[0-9]/.test(pwd)) score++;
                                if (/[^A-Za-z0-9]/.test(pwd)) score++;

                                return score;
                            },
                            profileImageSrc() {
        let url = this.displayUser.profileImgUrl;

        if (!url || url === "null" || url === "undefined") {
            return "/img/profile/default-profile.png";
        }

        url = String(url).trim();

        if (
            !url.startsWith("/img/profile/") &&
            !url.startsWith("/upload/profile/")
        ) {
            return "/img/profile/default-profile.png";
        }

        return url + "?v=" + this.profileImageVersion;
    },
                            passwordStrengthText() {
                                let pwd = this.passwordForm.newPwd || "";

                                if (!pwd) {
                                    return "영문, 숫자를 조합해 8자 이상 입력해주세요.";
                                }

                                if (this.passwordStrengthScore <= 1) {
                                    return "비밀번호 강도: 약함";
                                } else if (this.passwordStrengthScore <= 3) {
                                    return "비밀번호 강도: 보통";
                                } else {
                                    return "비밀번호 강도: 강함";
                                }
                            },
                            passwordStrengthClass() {
                                if (!this.passwordForm.newPwd) {
                                    return "";
                                }

                                if (this.passwordStrengthScore <= 1) {
                                    return "strength-weak";
                                } else if (this.passwordStrengthScore <= 3) {
                                    return "strength-medium";
                                } else {
                                    return "strength-strong";
                                }
                            },
                            passwordMatch() {
                                return this.passwordForm.newPwd &&
                                    this.passwordForm.newPwdConfirm &&
                                    this.passwordForm.newPwd === this.passwordForm.newPwdConfirm;
                            },
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
                            formattedSmsTime() {
                                const minutes = Math.floor(this.smsTimeLeft / 60);
                                const seconds = this.smsTimeLeft % 60;
                                return minutes + ":" + String(seconds).padStart(2, "0");
                            },
                            limitedChatbotList() {
                                return this.chatbotList.slice(0, 6);
                            },


                            limitedWishlist() {
                                return this.wishlist.slice(0, 9);
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
                                            console.log(self.orderList);
                                            data.list.forEach(function(item) {
            if (item.orderStatus === "SHIPPING" || item.orderStatus === "READY" || item.orderStatus === "DONE") {
                console.log("주문번호:", item.orderId);
                console.log("전체 item:", item);
                console.log("deliveryId:", item.deliveryId);
                console.log("deliveryStatus:", item.deliveryStatus);
            }
        });
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
                                this.addressMsg = "";
                                this.addressMsgType = "";

                                if (this.addressList.length >= 7) {
                                    this.showAddressForm = false;
                                    this.addressMsg = "배송지는 최대 7개까지 등록할 수 있습니다.";
                                    this.addressMsgType = "error";
                                    return;
                                }

                                this.isEditMode = false;
                                this.editAddressId = "";
                                this.showAddressForm = true;

                                this.addressForm = {
                                    addressAlias: "",
                                    zipCode: "",
                                    address: "",
                                    detailedAddress: "",
                                    defaultYn: false
                                };
                            },
                            fnCancelAddressForm: function () {
                                this.showAddressForm = false;
                                this.isEditMode = false;
                                this.editAddressId = "";
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
                                    addressId: self.editAddressId,
                                    addressAlias: self.addressForm.addressAlias,
                                    zipCode: self.addressForm.zipCode,
                                    address: self.addressForm.address,
                                    detailedAddress: self.addressForm.detailedAddress,
                                    defaultYn: self.addressForm.defaultYn ? "Y" : "N"
                                };

                                let url = self.isEditMode ? "/user/address/edit.dox" : "/user/address/add.dox";

                                $.ajax({
                                    url: url,
                                    type: "POST",
                                    dataType: "json",
                                    data: param,
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.fnCancelAddressForm();
                                            self.fnGetAddressList();
                                        } else {
                                            self.addressMsg = data.message || "처리에 실패했습니다.";
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
                            fnEditAddress: function (addr) {
                                this.showAddressForm = true;
                                this.isEditMode = true;
                                this.editAddressId = addr.addressId;
                                this.addressMsg = "";

                                this.addressForm = {
                                    addressAlias: addr.addressAlias || "",
                                    zipCode: addr.zipCode || "",
                                    address: addr.address || "",
                                    detailedAddress: addr.detailedAddress || "",
                                    defaultYn: addr.defaultYn === "Y"
                                };
                            },

                            fnDeleteAddress: function (addressId) {
                                let self = this;

                                $.ajax({
                                    url: "/user/address/remove.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { addressId: addressId },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.fnGetAddressList();
                                            if (self.editAddressId == addressId) {
                                                self.fnCancelAddressForm();
                                            }
                                        } else {
                                            self.addressMsg = data.message || "삭제에 실패했습니다.";
                                            self.addressMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.addressMsg = "서버 오류가 발생했습니다.";
                                        self.addressMsgType = "error";
                                    }
                                });
                            },
                            fnGetWishlist: function () {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/user/wishlist/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.wishlist = data.list;
                                        } else {
                                            self.wishlist = [];
                                        }
                                    }
                                });
                            },
                            fnGoProductDetail: function (productId) {
                                pageChange("/product/detail.do", {
                                    productId: productId
                                });
                            },
                            fnGoWishlistHistory: function () {
                                pageChange("/user/wishlist/history.do", {});
                            },
                            fnGetRecentList: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/recent/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: 1,
                                        pageSize: 9
                                    },
                                    success: function (data) {
                                        console.log("마이페이지 최근 본 상품 응답:", data);

                                        if (data.result === "success") {
                                            self.recentList = data.list || [];
                                        } else {
                                            self.recentList = [];
                                        }
                                    },
                                    error: function () {
                                        self.recentList = [];
                                    }
                                });
                            },
                            fnGoRecentHistory: function () {
                                pageChange("/user/recent/history.do", {});
                            },

                            fnEditReview: function (reviewId) {
                                pageChange("/user/review/edit.do", { reviewId: reviewId });
                            },

                            fnChangePassword: function () {
                                let self = this;
                                self.passwordMsg = "";
                                self.passwordMsgType = "";

                                if (!(self.passwordForm.currentPwd || "").trim()) {
                                    self.passwordMsg = "현재 비밀번호를 입력해주세요.";
                                    self.passwordMsgType = "error";
                                    return;
                                }

                                if (!(self.passwordForm.newPwd || "").trim()) {
                                    self.passwordMsg = "새 비밀번호를 입력해주세요.";
                                    self.passwordMsgType = "error";
                                    return;
                                }

                                if ((self.passwordForm.newPwd || "").length < 8) {
                                    self.passwordMsg = "새 비밀번호는 8자 이상이어야 합니다.";
                                    self.passwordMsgType = "error";
                                    return;
                                }

                                if (!(self.passwordForm.newPwdConfirm || "").trim()) {
                                    self.passwordMsg = "비밀번호 확인을 입력해주세요.";
                                    self.passwordMsgType = "error";
                                    return;
                                }

                                if (self.passwordForm.newPwd !== self.passwordForm.newPwdConfirm) {
                                    self.passwordMsg = "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
                                    self.passwordMsgType = "error";
                                    return;
                                }

                                $.ajax({
                                    url: "/user/settings/password/update.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        currentPwd: self.passwordForm.currentPwd,
                                        newPwd: self.passwordForm.newPwd
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.passwordMsg = data.message || "비밀번호가 변경되었습니다.";
                                            self.passwordMsgType = "success";

                                            self.passwordForm.currentPwd = "";
                                            self.passwordForm.newPwd = "";
                                            self.passwordForm.newPwdConfirm = "";
                                        } else {
                                            self.passwordMsg = data.message || "비밀번호 변경에 실패했습니다.";
                                            self.passwordMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.passwordMsg = "서버 오류가 발생했습니다.";
                                        self.passwordMsgType = "error";
                                    }
                                });
                            },
                            fnDeleteUser: function () {
                                let self = this;

                                // ✅ 1차 확인
                                if (!confirm("정말 회원탈퇴 하시겠습니까?\n탈퇴 시 모든 정보가 삭제됩니다.")) {
                                    return;
                                }

                                // (선택) 2차 확인까지 하고 싶으면
                                if (!confirm("진짜로 탈퇴하시겠습니까? 되돌릴 수 없습니다.")) {
                                    return;
                                }

                                $.ajax({
                                    url: "/user/settings/delete.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            alert("회원탈퇴가 완료되었습니다.");
                                            location.href = "/user/login.do"; // 
                                        } else {
                                            alert(data.message || "탈퇴에 실패했습니다.");
                                        }
                                    },
                                    error: function () {
                                        alert("서버 오류가 발생했습니다.");
                                    }
                                });
                            },

                            fnRemoveReview: function (reviewId) {
                                if (!confirm("리뷰를 삭제하시겠습니까?")) {
                                    return;
                                }

                                $.ajax({
                                    url: "/user/review/remove.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { reviewId: reviewId },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            alert("리뷰가 삭제되었습니다.");
                                            // 리뷰 탭 유지용 저장
                                            sessionStorage.setItem("activeTab", "reviews");
                                            location.reload();
                                        } else {
                                            alert(data.message || "삭제에 실패했습니다.");
                                        }
                                    },
                                    error: function () {
                                        alert("서버 오류가 발생했습니다.");
                                    }
                                });
                            },
                            fnGetChatbotList: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/chatbot/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.chatbotList = data.list || [];
                                        } else {
                                            self.chatbotList = [];
                                        }
                                    },
                                    error: function () {
                                        self.chatbotList = [];
                                    }
                                });
                            },
                            fnGoChatbotRoom: function (roomId) {
                                pageChange("/chat/bot.do", { roomId: roomId });
                            },
                            fnGoChatbotHistory: function () {
                                pageChange("/user/chatbot/history.do", {});
                            },

                            fnGetUserSettings: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/settings/info.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {

                                            let info = data.info || {};

                                            self.settingsForm.userName = info.userName || "";
                                            self.settingsForm.nickName = info.nickName || "";
                                            let profileImgUrl = info.profileImgUrl || "";
profileImgUrl = String(profileImgUrl).trim();

if (
    !profileImgUrl.startsWith("/img/profile/") &&
    !profileImgUrl.startsWith("/upload/profile/")
) {
    profileImgUrl = "";
}

self.displayUser.profileImgUrl = profileImgUrl;
                                            self.settingsForm.email = info.email || "";
                                            self.settingsForm.userPhone = info.userPhone || "";
                                            self.settingsForm.phoneVerifyYn = info.phoneVerifyYn || "N";
                                            self.settingsForm.phoneVerifiedAt = info.phoneVerifiedAt || "";
                                            self.settingsForm.socialType = info.socialType || "";

                                            self.displayUser.userName = info.userName || "";
                                            self.displayUser.nickName = info.nickName || "";

                                            self.originalPhone = info.userPhone || "";
                                            self.verifiedPhone = (info.phoneVerifyYn === "Y") ? (info.userPhone || "") : "";
                                            self.smsAuthCode = "";

                                            self.fnStopSmsTimer();
                                            self.smsExpired = false;
                                            self.smsTimeLeft = 0;
                                            self.smsInputVisible = false;
                                        } else {
                                            self.settingsMsg = data.message || "계정정보 조회에 실패했습니다.";
                                            self.settingsMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.settingsMsg = "서버 오류가 발생했습니다.";
                                        self.settingsMsgType = "error";
                                    }
                                });
                            },

                            fnSendSmsCode: function () {
                                let self = this;
                                self.settingsMsg = "";

                                let phone = (self.settingsForm.userPhone || "").replace(/[^0-9]/g, "");

                                if (!phone) {
                                    self.settingsMsg = "휴대폰 번호를 입력해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                if (self.settingsForm.phoneVerifyYn === "Y" && phone === self.verifiedPhone) {
                                    self.settingsMsg = "이미 인증이 완료된 번호입니다.";
                                    self.settingsMsgType = "error";
                                    self.smsInputVisible = false;
                                    self.fnStopSmsTimer();
                                    self.smsTimeLeft = 0;
                                    self.smsExpired = false;
                                    return;
                                }

                                $.ajax({
                                    url: "/user/sms/send-code.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        userName: self.settingsForm.userName,
                                        userPhone: phone,
                                        authPurpose: "USER_SETTINGS"
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.settingsMsg = data.message || "인증번호가 발송되었습니다.";
                                            self.settingsMsgType = "success";
                                            self.smsAuthCode = "";
                                            self.smsInputVisible = true;
                                            self.fnStartSmsTimer();
                                        } else {
                                            self.settingsMsg = data.message || "인증번호 발송에 실패했습니다.";
                                            self.settingsMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.settingsMsg = "서버 오류가 발생했습니다.";
                                        self.settingsMsgType = "error";
                                    }
                                });
                            },
                            fnStartSmsTimer: function () {
                                let self = this;

                                self.fnStopSmsTimer();
                                self.smsTimeLeft = 180; // 3분
                                self.smsExpired = false;

                                self.smsTimer = setInterval(function () {
                                    if (self.smsTimeLeft > 0) {
                                        self.smsTimeLeft--;
                                    } else {
                                        self.fnStopSmsTimer();
                                        self.smsExpired = true;
                                        self.settingsMsg = "인증번호가 만료되었습니다. 다시 발급해주세요.";
                                        self.settingsMsgType = "error";
                                    }
                                }, 1000);
                            },
                            beforeUnmount() {
                                this.fnStopSmsTimer();
                            },

                            fnStopSmsTimer: function () {
                                if (this.smsTimer) {
                                    clearInterval(this.smsTimer);
                                    this.smsTimer = null;
                                }
                            },

                            fnHandlePhoneChanged: function () {
                                let phone = (this.settingsForm.userPhone || "").replace(/[^0-9]/g, "");
                                this.settingsForm.userPhone = phone;

                                // 이미 인증된 번호와 같으면 인증 유지
                                if (phone && phone === this.verifiedPhone) {
                                    this.settingsForm.phoneVerifyYn = "Y";
                                    this.smsAuthCode = "";
                                    this.smsExpired = false;
                                    this.fnStopSmsTimer();
                                    this.smsTimeLeft = 0;
                                    this.smsInputVisible = false;
                                } else {
                                    // 인증된 번호와 다르면 미인증 처리
                                    this.settingsForm.phoneVerifyYn = "N";
                                    this.settingsForm.phoneVerifiedAt = "";
                                    this.smsAuthCode = "";
                                    this.smsExpired = false;
                                    this.fnStopSmsTimer();
                                    this.smsTimeLeft = 0;
                                    this.smsInputVisible = false;
                                }

                                this.fnClearSettingsMsg();
                            },

                            fnVerifySmsCode: function () {
                                let self = this;
                                self.settingsMsg = "";

                                let phone = (self.settingsForm.userPhone || "").replace(/[^0-9]/g, "");
                                let authCode = (self.smsAuthCode || "").trim();

                                if (!phone) {
                                    self.settingsMsg = "휴대폰 번호를 입력해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                if (!authCode) {
                                    self.settingsMsg = "인증번호를 입력해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                if (self.smsExpired || self.smsTimeLeft <= 0) {
                                    self.settingsMsg = "인증번호가 만료되었습니다. 다시 발급해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                $.ajax({
                                    url: "/user/sms/verify-code.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        userPhone: phone,
                                        authCode: authCode,
                                        authPurpose: "USER_SETTINGS"
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.settingsMsg = data.message || "휴대폰 인증이 완료되었습니다.";
                                            self.settingsMsgType = "success";

                                            self.settingsForm.phoneVerifyYn = "Y";
                                            self.settingsForm.phoneVerifiedAt = data.phoneVerifiedAt || "";
                                            self.originalPhone = phone;
                                            self.verifiedPhone = phone;

                                            self.fnStopSmsTimer();
                                            self.smsExpired = false;
                                            self.smsTimeLeft = 0;
                                            self.smsInputVisible = false;
                                            self.smsAuthCode = "";
                                        } else {
                                            self.settingsMsg = data.message || "인증번호가 올바르지 않거나 만료되었습니다.";
                                            self.settingsMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.settingsMsg = "서버 오류가 발생했습니다.";
                                        self.settingsMsgType = "error";
                                    }
                                });
                            },
                            fnSaveSettings: function () {
                                let self = this;
                                self.settingsMsg = "";

                                if (!(self.settingsForm.userName || "").trim()) {
                                    self.settingsMsg = "이름을 입력해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                if (!(self.settingsForm.nickName || "").trim()) {
                                    self.settingsMsg = "닉네임을 입력해주세요.";
                                    self.settingsMsgType = "error";
                                    return;
                                }

                                $.ajax({
                                    url: "/user/settings/update.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        userName: self.settingsForm.userName,
                                        nickName: self.settingsForm.nickName,
                                        userPhone: self.settingsForm.userPhone,
                                        originalPhone: self.originalPhone
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.settingsMsg = data.message || "회원정보가 저장되었습니다.";
                                            self.settingsMsgType = "success";
                                            self.fnGetUserSettings();
                                        } else {
                                            self.settingsMsg = data.message || "저장에 실패했습니다.";
                                            self.settingsMsgType = "error";
                                        }
                                    },
                                    error: function () {
                                        self.settingsMsg = "서버 오류가 발생했습니다.";
                                        self.settingsMsgType = "error";
                                    }
                                });
                            },
                            fnResetSettingsForm: function () {
                                this.fnGetUserSettings();
                            },
                            fnClearSettingsMsg: function () {
                                this.settingsMsg = "";
                                this.settingsMsgType = "";
                            },
                            fnGetInquiryList: function () {
                                let self = this;

                                $.ajax({
                                    url: "/user/inquiry/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {},
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.inquiryList = (data.list || []).map(function (item) {
                                                item.imageList = item.imageList || [];
                                                return item;
                                            });
                                        } else {
                                            self.inquiryList = [];
                                        }
                                    },
                                    error: function () {
                                        self.inquiryList = [];
                                    }
                                });
                            },
                           fnToggleInquiry: function (item) {
    let self = this;

    if (self.openInquiryId === item.inquiryId) {
        self.openInquiryId = null;
        return;
    }

    self.openInquiryId = item.inquiryId;

    // 🔥 조건 수정 (핵심)
    if (item.imageList && item.imageList.length > 0 && item._loaded) {
        return;
    }

    $.ajax({
        url: "/user/inquiry/img/list.dox",
        type: "POST",
        dataType: "json",
        data: {
            inquiryId: item.inquiryId
        },
        success: function (data) {
            if (data.result === "success") {
                item.imageList = data.list || [];
                item._loaded = true; // 🔥 추가
            }
        }
    });
},
                            fnInquiryStatusText: function (item) {
                                return item.replyId ? "답변완료" : "답변대기";
                            },
                            fnInquiryStatusClass: function (item) {
                                return item.replyId ? "answered" : "waiting";
                            },
                            fnEditInquiry: function (inquiryId) {
                                pageChange("/user/inquiry/edit.do", { inquiryId: inquiryId });
                            },

                            fnDeleteInquiry: function (inquiryId) {
                                let self = this;

                                if (!confirm("문의글을 삭제하시겠습니까?")) {
                                    return;
                                }

                                $.ajax({
                                    url: "/user/inquiry/remove.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { inquiryId: inquiryId },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            alert("문의가 삭제되었습니다.");
                                            self.fnGetInquiryList();
                                            self.openInquiryId = null;
                                        } else {
                                            alert(data.message || "삭제 실패");
                                        }
                                    },
                                    error: function () {
                                        alert("서버 오류");
                                    }
                                });
                            },
                            fnGoBenefitHistory: function () {
                                pageChange("/user/benefit/history.do", {});
                            },
                            fnTriggerProfileFile: function () {
                                this.$refs.profileFileInput.click();
                            },
                            fnDeleteProfile: function () {
    let self = this;

    if (!confirm("프로필 사진을 삭제하시겠습니까?")) {
        return;
    }

    $.ajax({
        url: "/user/profile/delete.dox",
        type: "POST",
        dataType: "json",
        data: {},
        success: function (data) {
            if (data.result === "success") {
                self.displayUser.profileImgUrl = "";
                self.$refs.profileFileInput.value = "";
                alert("프로필 사진이 삭제되었습니다.");
            } else {
                alert(data.message || "프로필 사진 삭제에 실패했습니다.");
            }
        },
        error: function () {
            alert("서버 오류가 발생했습니다.");
        }
    });
},

                          fnProfileImageChange: function (event) {
    let self = this;
    let file = event.target.files[0];

    if (!file) {
        return;
    }

    let formData = new FormData();
    formData.append("profileImage", file);

    $.ajax({
        url: "/user/profile/upload.dox",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        dataType: "json",
        success: function (data) {
    self.$refs.profileFileInput.value = "";

    if (data.result === "success") {
        location.href = location.pathname + "?profileRefresh=" + new Date().getTime();
    } else {
        alert(data.message || "프로필 사진 변경에 실패했습니다.");
    }
},
        error: function () {
            self.$refs.profileFileInput.value = "";
            alert("서버 오류가 발생했습니다.");
        }
    });
},
                                 fnGetOrderActions: function (item) {
    const actions = [];
    const status = (item.orderStatus || "").toUpperCase();
    const orderType = (item.orderType || "").toUpperCase();
    const deliveryStatus = (item.deliveryStatus || "").toUpperCase();
    const deliveryId = item.deliveryId;

    if (orderType === "PURCHASE") {
        if (status === "PAID" || status === "READY") {
            actions.push("취소 신청");
        }

        if (status === "SHIPPING" && deliveryStatus === "SHIPPING" && deliveryId) {
            actions.push("배송조회");
        }

        if (status === "DONE") {
            actions.push("환불 신청");
            actions.push("리뷰 작성");
        }
    }

    if (orderType === "RENTAL") {
        if (status === "PAID" || status === "RESERVED" || status === "READY") {
            actions.push("취소 신청");
        }

        if (status === "SHIPPING" && deliveryStatus === "SHIPPING" && deliveryId) {
            actions.push("배송조회");
        }

        if (status === "DONE") {
            actions.push("환불 신청");
            actions.push("반납 신청");
            actions.push("연장 신청");
        }

        if (status === "IN_USE") {
            actions.push("반납 신청");
            actions.push("연장 신청");
        }

        if (status === "COMPLETED") {
            actions.push("리뷰 작성");
        }
    }

    return actions;
},
fnHandleOrderAction: function (item, action) {
    if (action === "취소 신청") {
        pageChange("/order/cancel/request.do", {
            orderId: item.orderId
        });
        return;
    }

    if (action === "환불 신청") {
        pageChange("/order/refund/request.do", {
            orderId: item.orderId
        });
        return;
    }

    if (action === "배송조회") {
        if (!item.deliveryId) {
            alert("배송 정보가 없습니다.");
            return;
        }

        pageChange("/user/delivery/detail.do", {
            deliveryId: item.deliveryId
        });
        return;
    }

    if (action === "반납 신청") {
        pageChange("/rental/return/request.do", {
            orderId: item.orderId
        });
        return;
    }

    if (action === "연장 신청") {
        pageChange("/rental/extend/request.do", {
            orderId: item.orderId
        });
        return;
    }

    if (action === "리뷰 작성") {
        pageChange("/user/review/write.do", {
            orderId: item.orderId
        });
        return;
    }
},
                                    fnGoTracking: function (item) {
                                        // trackingNo, carrierCode가 있다고 가정
                                        pageChange("/order/tracking.do", {
                                            orderId: item.orderId,
                                            trackingNo: item.trackingNo,
                                            carrierCode: item.carrierCode
                                        });
                                    },

                                    fnGoRefund: function (item) {
                                        pageChange("/refund/request.do", {
                                            orderId: item.orderId
                                        });
                                    },

                                    fnGoWriteReview: function (item) {
                                        pageChange("/user/review/edit.do", {
                                            orderId: item.orderId,
                                            productId: item.productId,
                                            itemId: item.itemId
                                        });
                                    },

                                    fnGoMyReview: function (item) {
                                        pageChange("/user/review/history.do", {
                                            orderId: item.orderId,
                                            reviewId: item.reviewId
                                        });
                                    },

                                    fnGoReturnRequest: function (item) {
                                        pageChange("/rental/return/request.do", {
                                            orderId: item.orderId,
                                            rentalId: item.rentalId
                                        });
                                    },
                                    fnGoMembershipInfo: function () {
                                        pageChange("/user/membership/info.do", {});
                                    },
                                   fnGetActionClass: function (action) {
    if (action === "취소 신청") return "cancel";
    if (action === "환불 신청") return "refund";
    if (action === "배송조회") return "tracking";
    if (action === "반납 신청") return "return";
    if (action === "연장 신청") return "extend";
    if (action === "리뷰 작성") return "review";
    return "";
},
                                }, // methods
                                    mounted() {
                                    let profileUrl = String(this.displayUser.profileImgUrl || "").trim();

if (
    !profileUrl ||
    (
        !profileUrl.startsWith("/img/profile/") &&
        !profileUrl.startsWith("/upload/profile/")
    )
) {
    this.displayUser.profileImgUrl = "";
}
                                let self = this;
                                self.fnGetOrderList();
                                self.fnGetAddressList();
                                self.fnGetWishlist();
                                self.fnGetRecentList();
                                self.fnGetChatbotList();
                                self.fnGetUserSettings();
                                self.fnGetInquiryList();

                                const savedTab = sessionStorage.getItem("activeTab");
                                if (savedTab) {
                                    switchTab(savedTab, null);
                                    sessionStorage.removeItem("activeTab");
                                }
                            }
                        });

                    app.mount('#app');
                </script>