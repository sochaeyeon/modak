<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
		rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="/css/common/header.css">

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
		<a class="header-logo" href="/main.do">모닥모닥</a>

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