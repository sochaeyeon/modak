<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <header class="site-header">
            <div class="header-left">
                <button class="icon-btn" onclick="fnMove('mypage')" title="마이페이지">
                    <i class="fa-regular fa-user"></i>
                </button>
                <button class="icon-btn" onclick="fnMove('wishlist')" title="찜목록">
                    <i class="fa-regular fa-heart"></i>
                </button>
                <div class="cart-wrap" onclick="fnMove('cart')">
                    <button class="icon-btn" title="장바구니"><i class="fa-solid fa-basket-shopping"></i></button>
                    <span class="cart-badge" id="cartCount">0</span>
                </div>
                <div class="alarm-wrap">
                    <button class="icon-btn" title="알림" onclick="toggleAlarm(event)">
                        <i class="fa-regular fa-bell"></i>
                    </button>
                    <span class="alarm-dot" id="alarmDot" style="display:none;"></span>
                    <div class="alarm-dropdown" id="alarmDropdown">
                        <div class="alarm-dropdown-header">
                            <span>최근 알림</span>
                            <a href="javascript:void(0)" onclick="fnMove('alarm')" class="view-all-btn">전체보기</a>
                        </div>
                        <div class="alarm-dropdown-body" id="alarmPreviewList"></div>
                    </div>
                </div>
            </div>

            <div class="header-center">
                <a class="header-logo" href="/main.do">모닥모닥</a>
            </div>

            <div class="header-right-group">
                <div class="top-utils">
                    <div class="header-breadcrumb">
                        <span class="node">홈</span>
                        <span class="sep">/</span>
                        <span class="node current" id="currentPageName"></span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.sessionId}">
                            <a href="/logout" class="header-top-logout">Log out</a>
                        </c:when>
                        <c:otherwise>
                            <a href="/user/login.do" class="header-top-logout">Login</a>
                        </c:otherwise>
                    </c:choose>
                    <div class="category-trigger" onclick="toggleCategory(event)">
                        <div class="burger-icon">
                            <span></span><span></span><span></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="category-menu" id="categoryMenu">
                <div class="menu-header">
                    <h3>CATEGORY</h3>
                    <div class="welcome-msg">
                        반갑닥! 모닥러님
                        <i class="fa-solid fa-fire flame-icon"></i>
                    </div>
                    <button class="close-btn" onclick="toggleCategory()">&times;</button>
                    <form class="menu-search-box" action="/search/integrated.do" method="POST">
                        <input type="text" name="keyword" placeholder="어떤 캠핑용품을 찾고 계신가요?">
                        <button type="submit">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </form>
                </div>

                <div class="menu-list-wrap">
                    <ul class="menu-list">
                        <li><a href="/product/list.do"><i class="fa-solid fa-tent"></i> 캠프기본장비</a></li>
                        <li><a href="/product/list.do"><i class="fa-solid fa-chair"></i> 취사/음식</a></li>
                        <li><a href="/product/list.do"><i class="fa-solid fa-bed"></i> 감성/편의용품</a></li>

                        <li class="divider"></li>

                        <li><a href="/guide/guide.do"><i class="fa-solid fa-compass"></i> 가이드</a></li>
                        <li><a href="/notification/list.do"><i class="fa-solid fa-bullhorn"></i> 공지사항</a></li>
                        <li><a href="/event/list.do"><i class="fa-solid fa-gift"></i> 이벤트</a></li>
                        <li><a href="/cs/center.do"><i class="fa-solid fa-comment-dots"></i> 고객센터</a></li>

                        <li class="divider"></li>

                        <!-- ★ 로그인 상태별 주문 메뉴 -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.sessionId}">
                                <li><a href="/order/history.do"><i class="fa-solid fa-receipt"></i> 주문내역</a></li>
                                <li><a href="/rental/extension/main.do"><i class="fa-solid fa-rotate"></i> 대여연장</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="/rental/extension/inquiry.do"><i class="fa-solid fa-rotate"></i> 대여연장
                                        조회</a></li>
                                <li><a href="/order/guest/inquiry.do"><i class="fa-solid fa-box"></i> 비회원 주문조회</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>

                <div class="menu-footer">
                    <p>모닥모닥과 함께 따뜻한 캠핑을!<br>오늘도 즐거운 불멍 되세요.</p>
                    <span class="brand-logo">모닥모닥</span>
                </div>
            </div>

            <div class="menu-overlay" id="menuOverlay" onclick="toggleCategory()"></div>
        </header>

        <script>
            const isLogin = "${not empty sessionScope.sessionId}" === "true";
            function toggleCategory(e) {
                if (e) e.stopPropagation();
                const menu = document.getElementById('categoryMenu');
                const overlay = document.getElementById('menuOverlay');
                const isOpen = menu.classList.contains('open');
                if (isOpen) {
                    menu.classList.remove('open');
                    overlay.classList.remove('show');
                } else {
                    const dropdown = document.getElementById('alarmDropdown');
                    if (dropdown) dropdown.classList.remove('open');
                    menu.classList.add('open');
                    overlay.classList.add('show');
                }
            }

            function toggleAlarm(e) {
                e.stopPropagation();
                const dropdown = document.getElementById('alarmDropdown');
                const isOpen = dropdown.classList.contains('open');
                if (isOpen) {
                    dropdown.classList.remove('open');
                } else {
                    fnLoadAlarmPreview();
                    dropdown.classList.add('open');
                    const menu = document.getElementById('categoryMenu');
                    const overlay = document.getElementById('menuOverlay');
                    if (menu) menu.classList.remove('open');
                    if (overlay) overlay.classList.remove('show');
                }
            }

            function fnLoadAlarmPreview() {
                const listBody = document.getElementById('alarmPreviewList');

                // 비회원 알림 안내
                if (!isLogin) {
                    listBody.innerHTML =
                        '<div class="guest-alarm-box">' +
                        '<div class="guest-alarm-icon">' +
                        '<i class="fa-regular fa-bell"></i>' +
                        '</div>' +
                        '<div class="guest-alarm-title">로그인하고 혜택 알림 받기</div>' +
                        '<div class="guest-alarm-desc">' +
                        '이벤트, 쿠폰, 배송 알림까지<br>' +
                        '모닥모닥의 소식을 놓치지 마세요.' +
                        '</div>' +
                        '<button type="button" class="guest-alarm-login-btn" onclick="location.href=\'/user/login.do\'">' +
                        '로그인하러 가기' +
                        '</button>' +
                        '</div>';
                    return;
                }

                $.ajax({
                    url: "/alarm/getAlarmList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (res) {
                        let html = '';

                        if (res.list && res.list.length > 0) {
                            const previewData = res.list.slice(0, 5);

                            previewData.forEach(item => {
                                const icon = item.TYPE === 'DELIVERY'
                                    ? '<i class="fa-solid fa-truck"></i>'
                                    : (item.TYPE === 'EVENT'
                                        ? '<i class="fa-solid fa-gift"></i>'
                                        : '<i class="fa-solid fa-bullhorn"></i>');
                                const unreadClass = item.IS_READ === 'N' ? 'unread' : '';

                                html += '<div class="alarm-preview-item ' + unreadClass + '" onclick="location.href=\'/alarm/notice-detail.do?alarmId=' + item.ALARM_ID + '\'">' +
                                    '<div class="item-icon">' + icon + '</div>' +
                                    '<div class="item-content">' +
                                    '<div class="item-title">' + item.TITLE + '</div>' +
                                    '<div class="item-time">' + item.CREATED_AT + '</div>' +
                                    '</div>' +
                                    '</div>';
                            });
                        } else {
                            html = '<div class="empty-alarm">새로운 소식이 없습니다.</div>';
                        }

                        listBody.innerHTML = html;
                    }
                });
            }

            function fnCheckAlarm() {
                $.ajax({
                    url: "/alarm/alarmCount.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (res) {
                        const dot = document.getElementById('alarmDot');
                        if (dot) dot.style.display = (res.count > 0) ? 'block' : 'none';
                    }
                });
            }

            function fnMove(type) {
                if (type === 'mypage') location.href = '/user/mypage.do';
                else if (type === 'search') location.href = '/product/search.do';
                else if (type === 'wishlist') location.href = '/user/wishlist/history.do';
                else if (type === 'cart') location.href = '/cart/list.do';
                else if (type === 'alarm') {
                    const dropdown = document.getElementById('alarmDropdown');
                    if (dropdown) dropdown.classList.remove('open');
                    location.href = '/alarm/notice-list.do';
                }
            }

            document.addEventListener('click', function (e) {
                const dropdown = document.getElementById('alarmDropdown');
                const menu = document.getElementById('categoryMenu');
                const overlay = document.getElementById('menuOverlay');
                if (dropdown && !e.target.closest('.alarm-wrap')) dropdown.classList.remove('open');
                if (menu && !e.target.closest('.category-trigger') && !e.target.closest('.category-menu')) {
                    menu.classList.remove('open');
                    if (overlay) overlay.classList.remove('show');
                }
            });

            document.addEventListener('DOMContentLoaded', function () {
                fnCheckAlarm();
                fnCheckCartCount();

                const title = document.title.split(' - ')[0];
                const pageNameEl = document.getElementById('currentPageName');
                if (pageNameEl) pageNameEl.innerText = title;
            });
            function fnCheckCartCount() {
                const cartCountEl = document.getElementById('cartCount');

                if (!cartCountEl) return;

                $.ajax({
                    url: "/cart/count.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (res) {
                        console.log("장바구니 개수 응답:", res);

                        const count = Number(res.count || 0);

                        cartCountEl.innerText = count;
                        cartCountEl.style.display = 'flex';
                    },
                    error: function (xhr) {
                        console.log("장바구니 개수 오류:", xhr.responseText);

                        cartCountEl.innerText = '0';
                        cartCountEl.style.display = 'flex';
                    }
                });
            }
        </script>