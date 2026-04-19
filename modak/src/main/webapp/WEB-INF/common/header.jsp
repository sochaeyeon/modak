<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    /* 1. 헤더 기본 레이아웃 (중앙 로고 사수) */
    .site-header {
        background: rgba(255, 255, 255, 0.95) !important;
        backdrop-filter: blur(10px);
        border-bottom: 1px solid #eee !important;
        height: 80px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        padding: 0 40px !important;
        position: sticky !important;
        top: 0 !important;
        z-index: 1000 !important;
        width: 100% !important;
        box-sizing: border-box !important;
    }

    .header-logo {
        position: absolute !important;
        left: 50% !important;
        transform: translateX(-50%) !important;
        font-size: 26px !important;
        font-weight: 800 !important;
        color: #2c1f0e !important;
        text-decoration: none !important;
        letter-spacing: 1px !important;
    }

    /* 2. 왼쪽 아이콘 그룹 */
    .header-left {
        display: flex !important;
        align-items: center !important;
        gap: 20px !important;
        min-width: 320px !important;
    }

    .icon-btn {
        background: none !important;
        border: none !important;
        cursor: pointer !important;
        font-size: 20px !important;
        color: #333 !important;
        padding: 0 !important;
        outline: none !important;
        position: relative !important;
    }

    /* 알람 종 애니메이션 */
    .notice-wrap { position: relative !important; cursor: pointer !important; }
    .notice-dot {
        position: absolute !important;
        top: 1px !important;
        right: 1px !important;
        width: 6px !important;
        height: 6px !important;
        background: #ff4d4d !important;
        border-radius: 50% !important;
        border: 1px solid #fff !important;
    }
    .notice-wrap:hover .fa-bell {
        animation: bellRing 0.6s ease-in-out infinite !important;
        color: #E8732A !important;
    }

    @keyframes bellRing {
        0%, 100% { transform: rotate(0); }
        20% { transform: rotate(15deg); }
        40% { transform: rotate(-15deg); }
        60% { transform: rotate(10deg); }
        80% { transform: rotate(-10deg); }
    }

    /* 3. 오른쪽 유틸 영역 */
    .header-right-group {
        display: flex !important;
        flex-direction: column !important;
        align-items: flex-end !important;
        gap: 8px !important;
        min-width: 320px !important;
    }

    .top-utils { display: flex !important; align-items: center !important; gap: 15px !important; }
    .header-breadcrumb { font-size: 11px !important; color: #bbb !important; display: flex !important; align-items: center !important; }
    .header-breadcrumb .sep { margin: 0 6px !important; color: #eee !important; }

    .header-top-logout {
        font-size: 11px !important;
        color: #E8732A !important;
        font-weight: 700 !important;
        text-decoration: none !important;
        padding: 3px 12px !important;
        border: 1.5px solid #fde8d8 !important;
        border-radius: 12px !important;
    }

    /* 4. MENU 트리거 */
    .category-trigger {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        cursor: pointer !important;
    }
    .trigger-text { font-size: 14px !important; font-weight: 800 !important; color: #222 !important; }
    .burger-icon { width: 20px !important; height: 14px !important; display: flex !important; flex-direction: column !important; justify-content: space-between !important; }
    .burger-icon span { display: block !important; width: 100% !important; height: 2.5px !important; background: #222 !important; border-radius: 2px !important; }

    /* 5. 드롭다운 메뉴 (SUPPORT 보강) */
    .category-menu {
        position: absolute !important;
        top: 85px !important;
        right: 40px !important;
        background: #fff !important;
        width: 280px !important;
        border-radius: 20px !important;
        box-shadow: 0 12px 45px rgba(0,0,0,0.12) !important;
        display: none;
        z-index: 2000 !important;
    }
    .category-menu.open { display: block !important; }
    .menu-inner { padding: 30px 0 20px !important; }
    .section-label { font-size: 11px !important; color: #ccc !important; font-weight: 800 !important; margin-left: 25px; margin-bottom: 12px; letter-spacing: 1px; }

    .link-grid a { display: block !important; padding: 10px 25px !important; font-size: 14px !important; color: #444 !important; text-decoration: none !important; transition: 0.2s !important; }
    .link-grid a:hover { background: #faf7f2 !important; color: #E8732A !important; padding-left: 30px !important; }
    
    .menu-line { height: 1px !important; background: #f5f5f5 !important; margin: 15px 0 !important; }
    
    .all-view-link { font-weight: 700 !important; color: #222 !important; border-bottom: 1px solid #f8f8f8 !important; padding-bottom: 12px !important; margin-bottom: 8px !important; }
    .support-special { color: #E8732A !important; font-weight: 600 !important; }
</style>

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
                    <a href="/terms.do" style="font-size: 12px; color: #999;">이용약관</a>
                    <a href="/privacyPolicy.do" style="font-size: 12px; color: #999;">개인정보처리방침</a>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    function toggleCategory() {
        document.getElementById('categoryMenu').classList.toggle('open');
    }

    // 메뉴 바깥 클릭 시 닫기
    document.addEventListener('click', function (e) {
        const menu = document.getElementById('categoryMenu');
        const trigger = document.querySelector('.category-trigger');
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