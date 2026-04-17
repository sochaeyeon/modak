<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
		rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="/css/common/header.css">

	<header class="site-header">

		<!-- 왼쪽 -->
		<div class="header-left">
			<button class="icon-btn" onclick="fnMove('mypage')" title="마이페이지">
				<i class="fa-regular fa-user"></i>
			</button>

			<button class="icon-btn" onclick="fnMove('search')" title="검색">
				<i class="fa-solid fa-magnifying-glass"></i>
			</button>

			<button class="icon-btn" onclick="fnMove('wishlist')" title="찜목록">
				<i class="fa-regular fa-heart"></i>
			</button>

			<div class="cart-wrap" onclick="fnMove('cart')">
				<button class="icon-btn" title="장바구니">
					<i class="fa-solid fa-basket-shopping"></i>
				</button>
				<span class="cart-badge" id="cartCount">0</span>
			</div>

			<a class="header-logout" href="/logout">
				<i class="fa-solid fa-arrow-right-from-bracket"></i>
				Log out
			</a>
		</div>

		<!-- 로고 -->
		<a class="header-logo" href="/main.do">모닥모닥</a>

		<!-- 카테고리 -->
		<div class="header-right" onclick="toggleCategory()">
			<i class="fa-solid fa-bars"></i>
			<span>카테고리</span>
		</div>

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

		function fnMove(type) {
			if (type === 'mypage') location.href = '/user/mypage.do';
			if (type === 'search') location.href = '/product/search.do';
			if (type === 'wishlist') location.href = '/user/wishlist.do';
			if (type === 'cart') location.href = '/cart/list.do';
			if (type === 'category') location.href = '/product/list.do';
		}

		// 장바구니 개수 (선택)  cart/count/dox 컨트롤러가 아직 없어서 오류나가지고 지금은 주석으로 막아둘게요
		// function loadCartCount() {
		//    $.ajax({
		//       url: "/cart/count.dox",
		//       type: "GET",
		//       success: function (data) {
		//          $("#cartCount").text(data.count || 0);
		//       }
		//    });
		// }

		$(document).ready(function () {
			// loadCartCount();
		});
	</script>