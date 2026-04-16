<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
		rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

	<style>
		.site-header {
			background: #fff;
			border-bottom: 1px solid #e8dfd0;
			height: 56px;
			display: flex;
			align-items: center;
			justify-content: space-between;
			padding: 0 32px;
			position: sticky;
			top: 0;
			z-index: 100;
			font-family: 'Noto Sans KR', sans-serif;
		}

		/* 왼쪽: 아이콘 + Log out */
		.header-left {
			display: flex;
			align-items: center;
			gap: 18px;
		}

		.header-left .icon-btn {
			background: none;
			border: none;
			cursor: pointer;
			font-size: 17px;
			color: #2c1f0e;
			padding: 4px;
			line-height: 1;
			position: relative;
		}

		.header-left .icon-btn:hover {
			color: #b85c1a;
		}

		/* 장바구니 배지 */
		.cart-wrap {
			position: relative;
			display: inline-flex;
		}

		.cart-badge {
			position: absolute;
			top: -5px;
			right: -6px;
			background: #b85c1a;
			color: #fff;
			font-size: 9px;
			font-weight: 700;
			width: 16px;
			height: 16px;
			border-radius: 50%;
			display: flex;
			align-items: center;
			justify-content: center;
			font-family: 'Noto Sans KR', sans-serif;
		}

		.header-logout {
			display: flex;
			align-items: center;
			gap: 5px;
			font-size: 13px;
			color: #5a4a38;
			text-decoration: none;
			cursor: pointer;
			border: none;
			background: none;
			font-family: 'Noto Sans KR', sans-serif;
		}

		.header-logout:hover {
			color: #b85c1a;
		}

		.header-logout i {
			font-size: 14px;
		}

		/* 가운데: 로고 */
		.header-logo {
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
			font-size: 22px;
			font-weight: 700;
			color: #2c1f0e;
			letter-spacing: -0.5px;
			text-decoration: none;
			font-family: 'Noto Sans KR', sans-serif;
		}

		.header-logo:hover {
			color: #b85c1a;
		}

		/* 오른쪽: 카테고리 */
		.header-right {
			display: flex;
			align-items: center;
			gap: 8px;
			cursor: pointer;
			color: #2c1f0e;
			font-size: 14px;
			font-weight: 500;
			font-family: 'Noto Sans KR', sans-serif;
		}

		.header-right:hover {
			color: #b85c1a;
		}

		.header-right i {
			font-size: 16px;
		}

		/* 카테고리 드롭다운 (선택사항) */
		.category-menu {
			display: none;
			position: absolute;
			top: 56px;
			right: 32px;
			background: #fff;
			border: 1px solid #e8dfd0;
			border-radius: 10px;
			box-shadow: 0 8px 24px rgba(0, 0, 0, .08);
			min-width: 160px;
			padding: 8px 0;
			z-index: 200;
			font-family: 'Noto Sans KR', sans-serif;
		}

		.category-menu.open {
			display: block;
		}

		.category-menu a {
			display: block;
			padding: 10px 20px;
			font-size: 14px;
			color: #2c1f0e;
			text-decoration: none;
		}

		.category-menu a:hover {
			background: #faf7f2;
			color: #b85c1a;
		}
	</style>

	<header class="site-header">
		<!-- 왼쪽: 아이콘 영역 -->
		<div class="header-left">
			<button class="icon-btn" title="마이페이지"><i class="fa-regular fa-user"></i></button>
			<button class="icon-btn" title="검색"><i class="fa-solid fa-magnifying-glass"></i></button>
			<button class="icon-btn" title="찜목록"><i class="fa-regular fa-heart"></i></button>
			<div class="cart-wrap">
				<button class="icon-btn" title="장바구니"><i class="fa-solid fa-basket-shopping"></i></button>
				<span class="cart-badge">3</span>
			</div>
			<a class="header-logout" href="/logout">
				<i class="fa-solid fa-arrow-right-from-bracket"></i>
				Log out
			</a>
		</div>

		<!-- 가운데: 로고 -->
		<a class="header-logo" href="/">모닥모닥</a>

		<!-- 오른쪽: 카테고리 -->
		<div class="header-right" onclick="toggleCategory()">
			<i class="fa-solid fa-bars"></i>
			<span>카테고리</span>
		</div>

		<!-- 카테고리 드롭다운 -->
		<div class="category-menu" id="categoryMenu">
			<a href="#">텐트 / 타프</a>
			<a href="#">취사 용품</a>
			<a href="#">캠핑 가구</a>
			<a href="#">침낭 / 매트</a>
			<a href="#">조명 / 전기</a>
			<a href="#">차박 용품</a>
		</div>
	</header>

	<script>
		function toggleCategory() {
			const menu = document.getElementById('categoryMenu');
			menu.classList.toggle('open');
		}
		document.addEventListener('click', function (e) {
			const menu = document.getElementById('categoryMenu');
			if (!e.target.closest('.header-right') && !e.target.closest('.category-menu')) {
				menu.classList.remove('open');
			}
		});
	</script>