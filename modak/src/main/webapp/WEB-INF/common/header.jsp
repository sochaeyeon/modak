<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/header.css?v=1.0">

<header class="site-header">
    <div class="header-left">
        <button class="icon-btn" onclick="fnMove('mypage')" title="마이페이지"><i class="fa-regular fa-user"></i></button>
        <button class="icon-btn" onclick="fnMove('search')" title="검색"><i class="fa-solid fa-magnifying-glass"></i></button>
        <button class="icon-btn" onclick="fnMove('wishlist')" title="찜목록"><i class="fa-regular fa-heart"></i></button>
        
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
            <a href="/logout" class="header-top-logout">Log out</a>
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
                    <a href="/policy/terms.do" style="font-size: 12px; color: #999;">이용약관</a>
                    <a href="/policy/privacy.do" style="font-size: 12px; color: #999;">개인정보처리방침</a>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    function toggleCategory() {
        document.getElementById('categoryMenu').classList.toggle('open');
    }

    document.addEventListener('click', function (e) {
        const menu = document.getElementById('categoryMenu');
        if (menu.classList.contains('open') && !e.target.closest('.category-trigger') && !e.target.closest('.category-menu')) {
            menu.classList.remove('open');
        }
    });

    $(document).ready(function() {
        const path = window.location.pathname;
        const $pageName = $("#currentPageName");
        let name = "모닥모닥";
        if (path.includes("product")) name = "상품목록";
        else if (path.includes("cart")) name = "장바구니";
        else if (path.includes("mypage")) name = "마이페이지";
        else if (path.includes("guide")) name = "이용가이드";
        $pageName.text(name);
    });

    function fnMove(type) {
        if (type === 'mypage') location.href = '/user/mypage.do';
        else if (type === 'search') location.href = '/product/search.do';
        else if (type === 'wishlist') location.href = '/user/wishlist.do';
        else if (type === 'cart') location.href = '/cart/list.do';
        else if (type === 'notice') location.href = '/user/notice.do';
    }
</script>