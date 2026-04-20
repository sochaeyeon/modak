<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <header class="site-header">
            <div class="header-left">
                <button class="icon-btn" onclick="fnMove('mypage')" title="마이페이지"><i
                        class="fa-regular fa-user"></i></button>
                <button class="icon-btn" onclick="fnMove('search')" title="검색"><i
                        class="fa-solid fa-magnifying-glass"></i></button>
                <button class="icon-btn" onclick="fnMove('wishlist')" title="찜목록"><i
                        class="fa-regular fa-heart"></i></button>

                <div class="cart-wrap" onclick="fnMove('cart')">
                    <button class="icon-btn" title="장바구니"><i class="fa-solid fa-basket-shopping"></i></button>
                    <span class="cart-badge" id="cartCount">0</span>
                </div>

                <div class="notice-wrap" onclick="fnMove('notice')">
                    <button class="icon-btn" title="알림"><i class="fa-regular fa-bell"></i></button>
                    <span class="notice-dot"></span>
                </div>
            </div>

            <a class="header-logo" href="/main.do">모닥모닥</a>

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
                </div>

                <div class="category-trigger" onclick="toggleCategory()">
                    <div class="burger-icon">
                        <span></span><span></span><span></span>
                    </div>
                    <span class="trigger-text">MENU</span>
                </div>
            </div>

            <div class="category-menu" id="categoryMenu">
                <div class="menu-inner">
                    <div class="menu-section">
                        <p class="section-label">SHOPPING</p>
                        <div class="link-grid">
                            <a href="/product/list.do" class="all-view-link">전체 상품 보기</a>
                            <a href="/product/list.do?cat=4">텐트 / 타프</a>
                            <a href="/product/list.do?cat=5">취사 용품</a>
                            <a href="/product/list.do?cat=6">캠핑 가구</a>
                            <a href="/product/list.do?cat=7">침낭 / 매트</a>
                        </div>
                    </div>
                    <div class="menu-line"></div>
                    <div class="menu-section">
                        <p class="section-label">SUPPORT</p>
                        <div class="link-grid">
                            <a href="/guide/guide.do" class="support-special">🏕️ 이용 가이드</a>
                            <a href="/customer/notice.do">공지사항</a>
                            <a href="/customer/qna.do">1:1 문의하기</a>
                            <c:choose>
                                <c:when test="${not empty sessionScope.sessionId}">
                                    <a href="/rental/extension/main.do">대여 연장 신청</a>
                                    <a href="/order/order-history.do">주문 내역</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/rental/extension/inquiry.do">비회원 연장 신청</a>
                                    <a href="/order/guest/inquiry.do">비회원 주문 조회</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <script>
            function toggleCategory() {
                const menu = document.getElementById('categoryMenu');
                if (menu) menu.classList.toggle('open');
            }
            function fnMove(type) {
                if (type === 'mypage') location.href = '/user/mypage.do';
                else if (type === 'search') location.href = '/product/search.do';
                else if (type === 'wishlist') location.href = '/user/wishlist.do';
                else if (type === 'cart') location.href = '/cart/list.do';
                else if (type === 'notice') location.href = '/user/notice.do';
            }

            document.addEventListener('click', function (e) {
                const menu = document.getElementById('categoryMenu');
                if (menu && menu.classList.contains('open')) {
                    if (!e.target.closest('.category-trigger') && !e.target.closest('.category-menu')) {
                        menu.classList.remove('open');
                    }
                }
            });
        </script>