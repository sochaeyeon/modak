<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>모닥모닥 - 장비 목록</title>

<!-- 구글 폰트 -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@300;400;600&family=Noto+Sans+KR:wght@300;400;500&display=swap" rel="stylesheet">

<!-- jQuery, Vue3 -->
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<style>
/* ════════════════════════════════════════
   1. CSS 변수 (색상, 공통 디자인 토큰)
   ════════════════════════════════════════ */
:root {
  --forest:    #2C3E2D;
  --pine:      #3D5A40;
  --moss:      #5A7A4E;
  --sage:      #8FAF7E;
  --mist:      #C8D8B8;
  --smoke:     #EDF2E6;
  --ember:     #C8602A;
  --flame:     #E8884A;
  --ash:       #F5EFE4;
  --bark:      #7A5C3E;
  --stone:     #A09080;
  --parchment: #FBF7F0;
  --ink:       #1E2A1F;
  --border:    rgba(90,122,78,0.15);
  --card-bg:   #FDF9F3;
}
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body {
  background: var(--parchment);
  color: var(--ink);
  font-family: 'Noto Sans KR', sans-serif;
  font-weight: 300;
  line-height: 1.7;
  min-height: 100vh;
}

/* ════════════════════════════════════════
   2. 상단 내비게이션 바
   ════════════════════════════════════════ */
nav {
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 48px; height: 60px;
  background: var(--forest);
  position: sticky; top: 0; z-index: 200;
}
.nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
.logo-text { font-family: 'Noto Serif KR', serif; font-size: 16px; font-weight: 600; color: #FBF7F0; letter-spacing: .06em; }
.nav-links { display: flex; gap: 28px; }
.nav-links a { font-size: 12px; color: var(--mist); text-decoration: none; letter-spacing: .08em; transition: color .2s; }
.nav-links a:hover { color: #fff; }
.nav-links a.active { color: var(--flame); }
.nav-right { display: flex; align-items: center; gap: 12px; }
.nav-icon { color: var(--mist); cursor: pointer; }
.nav-icon svg { width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 1.4; }
.nav-cta {
  font-size: 11px; padding: 6px 16px;
  border: 1px solid var(--sage); border-radius: 2px;
  color: var(--mist); background: transparent; cursor: pointer;
  letter-spacing: .08em; transition: all .2s;
}
.nav-cta:hover { background: var(--sage); color: var(--forest); }

/* ════════════════════════════════════════
   3. 브레드크럼 (경로 표시)
   ════════════════════════════════════════ */
.breadcrumb {
  padding: 14px 0;
  border-bottom: 1px solid var(--border);
  background: var(--parchment);
}
.breadcrumb-inner {
  max-width: 1200px; margin: 0 auto; padding: 0 32px;
  display: flex; align-items: center; gap: 6px;
}
.bc { font-size: 12px; color: var(--stone); text-decoration: none; transition: color .2s; }
.bc:hover { color: var(--ember); }
.bc-sep { font-size: 11px; color: var(--mist); }
.bc-current { font-size: 12px; color: var(--ink); }

/* ════════════════════════════════════════
   4. 카테고리 필터 pill 바 (가로 스크롤)
   ════════════════════════════════════════ */
.cat-bar {
  background: var(--parchment);
  border-bottom: 1px solid var(--border);
  padding: 16px 0;
  position: sticky; top: 60px; z-index: 100;
}
.cat-bar-inner {
  max-width: 1200px; margin: 0 auto; padding: 0 32px;
  display: flex; align-items: center; gap: 10px;
  overflow-x: auto; scrollbar-width: none;
}
.cat-bar-inner::-webkit-scrollbar { display: none; }
.cat-pill {
  display: flex; align-items: center; gap: 7px;
  padding: 8px 16px; border-radius: 40px;
  border: 1px solid var(--border); background: var(--card-bg);
  font-size: 12px; font-weight: 300; color: var(--stone);
  cursor: pointer; transition: all .2s; white-space: nowrap;
  font-family: 'Noto Sans KR', sans-serif;
}
.cat-pill .pill-emoji { font-size: 14px; line-height: 1; }
.cat-pill:hover { border-color: var(--ember); color: var(--ember); }
/* Vue :class 바인딩으로 active 클래스 제어 */
.cat-pill.active { background: var(--ember); border-color: var(--ember); color: #fff; font-weight: 400; }
.cat-pill.active .pill-emoji { filter: brightness(10); }

/* ════════════════════════════════════════
   5. 메인 레이아웃 (페이지 감싸기)
   ════════════════════════════════════════ */
.page-wrap { max-width: 1200px; margin: 0 auto; padding: 32px 32px 80px; }

.top-row {
  display: flex; align-items: flex-end; justify-content: space-between;
  margin-bottom: 24px; flex-wrap: wrap; gap: 14px;
}
.result-label { font-size: 12px; color: var(--stone); margin-bottom: 4px; letter-spacing: .04em; }
.result-title { font-family: 'Noto Serif KR', serif; font-size: 22px; font-weight: 400; color: var(--forest); }
.result-count { font-size: 13px; color: var(--stone); margin-left: 8px; }
.controls { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }

/* 정렬 셀렉트 박스 */
.sort-select {
  padding: 8px 28px 8px 14px;
  border: 1px solid var(--border); border-radius: 3px;
  background: var(--card-bg);
  font-family: 'Noto Sans KR', sans-serif; font-size: 12px; color: var(--ink);
  cursor: pointer; outline: none; -webkit-appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23A09080' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 10px center;
}
.sort-select:focus { border-color: var(--ember); }

/* 그리드 / 리스트 뷰 전환 버튼 */
.view-toggle { display: flex; border: 1px solid var(--border); border-radius: 3px; overflow: hidden; }
.vbtn {
  padding: 7px 11px; background: var(--card-bg); border: none;
  cursor: pointer; color: var(--stone); transition: all .2s;
}
.vbtn:hover { background: var(--smoke); }
.vbtn.active { background: var(--ember); color: #fff; }
.vbtn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.5; display: block; }

/* 필터 토글 버튼 */
.filter-toggle {
  display: flex; align-items: center; gap: 6px;
  padding: 8px 14px; border: 1px solid var(--border); border-radius: 3px;
  background: var(--card-bg); font-size: 12px; color: var(--stone);
  cursor: pointer; font-family: 'Noto Sans KR', sans-serif; transition: all .2s;
}
.filter-toggle:hover { border-color: var(--ember); color: var(--ember); }
.filter-toggle svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.5; }
.filter-badge {
  background: var(--ember); color: #fff; font-size: 10px;
  width: 16px; height: 16px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center; font-weight: 500;
}

/* ════════════════════════════════════════
   6. 사이드바 (필터 패널)
   ════════════════════════════════════════ */
.content-wrap { display: flex; gap: 28px; align-items: flex-start; }
.sidebar {
  width: 220px; flex-shrink: 0;
  background: var(--card-bg); border: 1px solid var(--border);
  border-radius: 6px; overflow: hidden; transition: all .3s;
}
/* Vue v-show로 숨김/표시 제어 */
.filter-section { border-bottom: 1px solid var(--border); padding: 18px 20px; }
.filter-section:last-child { border-bottom: none; }
.fs-header {
  display: flex; align-items: center; justify-content: space-between;
  cursor: pointer; margin-bottom: 14px;
}
.fs-title { font-size: 12px; font-weight: 500; color: var(--forest); letter-spacing: .06em; }
.fs-arrow { width: 12px; height: 12px; stroke: var(--stone); fill: none; stroke-width: 2; transition: transform .2s; }
.fs-arrow.open { transform: rotate(180deg); }
.filter-opts { display: flex; flex-direction: column; gap: 8px; }
.fopt {
  display: flex; align-items: center; gap: 8px; cursor: pointer;
  font-size: 12px; color: var(--stone); transition: color .15s;
}
.fopt:hover { color: var(--ember); }
.fopt input { accent-color: var(--ember); cursor: pointer; }
.fopt-count { margin-left: auto; font-size: 11px; color: var(--mist); }

/* 가격 범위 슬라이더 */
.range-wrap { padding-top: 4px; }
.range-row { display: flex; justify-content: space-between; margin-bottom: 8px; }
.range-val { font-size: 11px; color: var(--stone); }
input[type=range] {
  -webkit-appearance: none; width: 100%; height: 3px;
  background: linear-gradient(to right, var(--ember) 0%, var(--ember) 50%, var(--border) 50%, var(--border) 100%);
  border-radius: 3px; outline: none; cursor: pointer;
}
input[type=range]::-webkit-slider-thumb {
  -webkit-appearance: none; width: 14px; height: 14px;
  border-radius: 50%; background: var(--ember);
  border: 2px solid #fff; box-shadow: 0 1px 4px rgba(200,96,42,.3);
}
.filter-reset {
  width: 100%; margin-top: 14px; padding: 9px;
  border: 1px solid var(--border); border-radius: 3px;
  background: transparent; font-family: 'Noto Sans KR', sans-serif;
  font-size: 12px; color: var(--stone); cursor: pointer; transition: all .2s;
}
.filter-reset:hover { border-color: var(--ember); color: var(--ember); }

/* ════════════════════════════════════════
   7. 상품 카드 (그리드 뷰)
   ════════════════════════════════════════ */
.grid-wrap { flex: 1; min-width: 0; }
.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
}
/* 리스트 뷰일 때 그리드 변경 */
.product-grid.view-list { grid-template-columns: 1fr; gap: 12px; }

.pcard {
  background: var(--card-bg); border: 1px solid var(--border);
  border-radius: 10px; overflow: hidden;
  transition: transform .25s, box-shadow .25s;
  cursor: pointer; position: relative;
}
.pcard:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(44,62,45,.1); }

/* 카드 이미지 영역 */
.pcard-img {
  position: relative; background: var(--ash);
  aspect-ratio: 1 / 0.85;
  display: flex; align-items: center; justify-content: center; overflow: hidden;
}
.pcard-emoji { font-size: 56px; line-height: 1; user-select: none; }

/* 찜(위시리스트) 버튼 */
.pcard-wish {
  position: absolute; top: 12px; right: 12px;
  width: 30px; height: 30px; border-radius: 50%;
  background: rgba(255,255,255,.85);
  display: flex; align-items: center; justify-content: center;
  border: none; cursor: pointer; transition: all .2s;
}
.pcard-wish svg { width: 15px; height: 15px; stroke: #A09080; fill: none; stroke-width: 1.6; transition: all .2s; }
.pcard-wish:hover svg { stroke: var(--ember); }
/* Vue :class로 wished 상태 토글 */
.pcard-wish.wished svg { stroke: var(--ember); fill: var(--ember); }

/* 뱃지 (NEW, 인기, 할인 등)
.badge-row { position: absolute; top: 12px; left: 12px; display: flex; gap: 5px; }
.pbadge { font-size: 10px; padding: 3px 8px; border-radius: 3px; font-weight: 500; letter-spacing: .04em; }
.pbadge-hot  { background: #E8453C; color: #fff; }
.pbadge-sale { background: var(--ember); color: #fff; }
.pbadge-new  { background: var(--forest); color: var(--mist); }
.pbadge-best { background: var(--bark); color: #FAF0E0; } */

/* 카드 텍스트 영역 */
.pcard-body { padding: 14px 16px 16px; }
.pcard-cat  { font-size: 10px; color: var(--stone); letter-spacing: .06em; margin-bottom: 4px; }
.pcard-name {
  font-size: 13px; font-weight: 400; color: var(--ink);
  margin-bottom: 7px; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.stars { display: flex; align-items: center; gap: 4px; margin-bottom: 8px; }
.star { font-size: 10px; color: var(--flame); }
.star-count { font-size: 11px; color: var(--stone); }
.price-row { display: flex; align-items: baseline; gap: 6px; margin-bottom: 12px; }
.price-main { font-size: 16px; font-weight: 500; color: var(--ink); }
.price-unit { font-size: 11px; color: var(--stone); }
.price-orig { font-size: 11px; color: var(--mist); text-decoration: line-through; }

/* 버튼 행 (대여 / 구매) */
.btn-row { display: flex; gap: 7px; }
.btn-rent {
  flex: 1; padding: 9px 0;
  background: var(--ember); color: #fff;
  border: none; border-radius: 4px;
  font-family: 'Noto Sans KR', sans-serif; font-size: 12px; letter-spacing: .04em;
  cursor: pointer; transition: background .2s;
}
.btn-rent:hover { background: var(--flame); }
.btn-buy {
  flex: 1; padding: 9px 0;
  background: transparent; color: var(--forest);
  border: 1px solid var(--border); border-radius: 4px;
  font-family: 'Noto Sans KR', sans-serif; font-size: 12px; letter-spacing: .04em;
  cursor: pointer; transition: all .2s;
}
.btn-buy:hover { border-color: var(--forest); background: var(--smoke); }

/* ════════════════════════════════════════
   8. 리스트 뷰 카드 (가로 레이아웃)
   ════════════════════════════════════════ */
.pcard.list-card { display: flex; flex-direction: row; border-radius: 8px; }
.pcard.list-card .pcard-img {
  width: 160px; flex-shrink: 0;
  aspect-ratio: auto; height: auto; min-height: 130px; border-radius: 0;
}
.pcard.list-card .pcard-emoji { font-size: 44px; }
.pcard.list-card .pcard-body {
  flex: 1; display: flex; align-items: center;
  gap: 24px; flex-wrap: wrap; padding: 16px 20px;
}
.pcard.list-card .pcard-main { flex: 1; min-width: 180px; }
.pcard.list-card .pcard-price-wrap { text-align: right; min-width: 100px; }
.pcard.list-card .pcard-price-wrap .price-main { font-size: 18px; }
.pcard.list-card .btn-row { flex-direction: column; min-width: 110px; gap: 6px; }
.pcard.list-card .btn-rent,
.pcard.list-card .btn-buy { padding: 8px 16px; }

/* ════════════════════════════════════════
   9. 페이지네이션
   ════════════════════════════════════════ */
.pagination {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; margin-top: 48px;
}
.ppage {
  width: 34px; height: 34px; border-radius: 3px;
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; color: var(--stone);
  border: 1px solid transparent; cursor: pointer; transition: all .2s;
  background: none; font-family: 'Noto Sans KR', sans-serif;
}
.ppage:hover { border-color: var(--border); color: var(--ink); }
.ppage.active { background: var(--ember); color: #fff; border-color: var(--ember); }
.ppage.arrow { border: 1px solid var(--border); background: var(--card-bg); }
.ppage.arrow svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2; }

/* ════════════════════════════════════════
   10. 데이터 없을 때 빈 상태 표시
   ════════════════════════════════════════ */
.empty { text-align: center; padding: 80px 20px; }
.empty-emoji { font-size: 48px; margin-bottom: 16px; }
.empty-msg { font-size: 14px; color: var(--stone); }

/* ════════════════════════════════════════
   11. 카드 등장 애니메이션
   ════════════════════════════════════════ */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(14px); }
  to   { opacity: 1; transform: translateY(0); }
}
.pcard { animation: fadeUp .45s ease both; }

/* ════════════════════════════════════════
   12. 반응형 미디어 쿼리
   ════════════════════════════════════════ */
@media (max-width: 900px) {
  .sidebar { display: none; }
  .product-grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 640px) {
  nav { padding: 0 16px; }
  .nav-links { display: none; }
  .page-wrap { padding: 20px 16px 60px; }
  .cat-bar-inner { padding: 0 16px; }
  .product-grid { grid-template-columns: repeat(2, 1fr); }
  .breadcrumb-inner { padding: 0 16px; }
}
</style>
</head>
<body>

<!-- Vue 마운트 대상 루트 요소 -->
<div id="app">

  <!-- ── 상단 내비게이션 ── -->
  <nav>
    <a class="nav-logo" href="#">
      <svg width="28" height="28" viewBox="0 0 32 32" fill="none">
        <path d="M16 3C16 3 10 10 10 16a6 6 0 0 0 12 0c0-6-6-13-6-13z" fill="#E8884A" opacity=".9"/>
        <path d="M16 10C16 10 12 15 12 18a4 4 0 0 0 8 0c0-3-4-8-4-8z" fill="#FAC878"/>
        <ellipse cx="16" cy="26" rx="7" ry="2.5" fill="#5A7A4E" opacity=".6"/>
      </svg>
      <span class="logo-text">모닥모닥</span>
    </a>
    <div class="nav-links">
      <a href="#">홈</a>
      <a href="#" class="active">대여</a>
      <a href="#">구매</a>
      <a href="#">커뮤니티</a>
      <a href="#">고객센터</a>
    </div>
    <div class="nav-right">
      <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></span>
      <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></span>
      <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg></span>
      <button class="nav-cta">로그인</button>
    </div>
  </nav>

  <!-- ── 브레드크럼 ── -->
  <div class="breadcrumb">
    <div class="breadcrumb-inner">
      <a class="bc" href="#">홈</a>
      <span class="bc-sep">›</span>
      <a class="bc" href="#">장비</a>
    </div>
  </div>

  <!-- ── 카테고리 pill 바 ── -->
  <!-- v-for로 categories 배열을 순회하며 pill 렌더링 -->
  <!-- :class로 currentCat와 일치하면 active 클래스 적용 -->
  <!-- @click으로 카테고리 선택 메서드 호출 -->
  <div class="cat-bar">
    <div class="cat-bar-inner">
      <button
        v-for="cat in categories"
        :key="cat.name"
        class="cat-pill"
        :class="{ active: currentCat === cat.name }"
        @click="selectCat(cat)"
      >
        <span class="pill-emoji">{{ cat.emoji }}</span> {{ cat.name }}
      </button>
    </div>
  </div>

  <!-- ── 메인 컨텐츠 영역 ── -->
  <div class="page-wrap">
    <div class="top-row">
      <div class="result-info">
        <div class="result-label">인기 장비</div>
        <div>
          <!-- Vue 반응형 데이터로 현재 카테고리명·결과 수 표시 -->
          <span class="result-title">{{ currentCat === '전체' ? '전체 장비' : currentCat }}</span>
          <span class="result-count">총 {{ filteredProducts.length }}개</span>
        </div>
      </div>
      <div class="controls">
        <!-- 필터 사이드바 토글 버튼 -->
        <button class="filter-toggle" @click="sidebarVisible = !sidebarVisible">
          <svg viewBox="0 0 24 24"><line x1="4" y1="6" x2="20" y2="6"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="11" y1="18" x2="13" y2="18"/></svg>
          필터
        </button>
        <!-- 정렬 기준 선택 → v-model로 sortKey와 양방향 바인딩 -->
        <select class="sort-select" v-model="sortKey" @change="currentPage = 1">
          <option value="popular">인기순</option>
          <option value="newest">최신순</option>
          <option value="price-low">가격 낮은순</option>
          <option value="price-high">가격 높은순</option>
          <option value="rating">평점순</option>
        </select>
        <!-- 그리드 / 리스트 뷰 전환 -->
        <div class="view-toggle">
          <button class="vbtn" :class="{ active: currentView === 'grid' }" @click="currentView = 'grid'">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          </button>
          <button class="vbtn" :class="{ active: currentView === 'list' }" @click="currentView = 'list'">
            <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
          </button>
        </div>
      </div>
    </div>

    <div class="content-wrap">

      <!-- ── 필터 사이드바 (v-show로 토글) ── -->
      <div class="sidebar" v-show="sidebarVisible">
        <!-- 대여/구매 필터 -->
        <div class="filter-section">
        <div class="fs-header" @click="toggleSection($event)">
        <span class="fs-title">대여 / 구매</span>
        <svg class="fs-arrow open" viewBox="0 0 24 24">
            <polyline points="6 9 12 15 18 9"/>
        </svg>
        </div>

        <div class="filter-opts">
        <label class="fopt">
            <input type="checkbox" v-model="filter.rentable"> 대여 가능
            <span class="fopt-count">38</span>
        </label>
        <label class="fopt">
            <input type="checkbox" v-model="filter.buyable"> 구매 가능
            <span class="fopt-count">42</span>
        </label>
        </div>
    </div>

        <!-- 대여 기간 필터 -->
        <div class="filter-section">
          <div class="fs-header" @click="toggleSection($event)">
            <span class="fs-title">대여 기간</span>
            <svg class="fs-arrow open" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"/></svg>
          </div>
          <div class="filter-opts">
            <label class="fopt"><input type="checkbox" v-model="filter.period" value="1"> 1박 2일</label>
            <label class="fopt"><input type="checkbox" v-model="filter.period" value="2"> 2박 3일</label>
            <label class="fopt"><input type="checkbox" v-model="filter.period" value="3"> 3박 이상</label>
          </div>
        </div>
        <!-- 가격 범위 슬라이더 -->
        <div class="filter-section">
          <div class="fs-header" @click="toggleSection($event)">
            <span class="fs-title">1박 가격</span>
            <svg class="fs-arrow open" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"/></svg>
          </div>
          <div class="range-wrap">
            <div class="range-row">
              <span class="range-val">0원</span>
              <!-- 슬라이더 값에 따라 표시 금액 갱신 (computed 사용) -->
              <span class="range-val">{{ priceRangeLabel }}</span>
            </div>
            <input type="range" min="0" max="100" v-model="filter.priceRange" @input="updateRangeStyle">
          </div>
        </div>
        <!-- 평점 필터 -->
        <div class="filter-section">
          <div class="fs-header" @click="toggleSection($event)">
            <span class="fs-title">평점</span>
            <svg class="fs-arrow open" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"/></svg>
          </div>
          <div class="filter-opts">
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="5"> ★★★★★ 5.0</label>
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="4"> ★★★★☆ 4.0 이상</label>
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="3"> ★★★☆☆ 3.0 이상</label>
          </div>
        </div>
        <div style="padding:14px 20px;">
          <!-- 필터 초기화 버튼 -->
          <button class="filter-reset" @click="resetFilter">필터 초기화</button>
        </div>
      </div><!-- /sidebar -->

      <!-- ── 상품 목록 ── -->
      <div class="grid-wrap">

        <!-- 데이터 로딩 중 표시 -->
        <div v-if="loading" class="empty">
          <div class="empty-emoji">⏳</div>
          <div class="empty-msg">장비를 불러오는 중입니다...</div>
        </div>

        <!-- 결과 없을 때 빈 상태 -->
        <div v-else-if="pagedProducts.length === 0" class="empty">
          <div class="empty-emoji">🏕️</div>
          <div class="empty-msg">해당 조건의 장비가 없습니다</div>
        </div>

        <!-- 상품 카드 그리드 / 리스트 -->
        <!-- v-else로 데이터가 있을 때만 렌더링 -->
        <div v-else :class="['product-grid', currentView === 'list' ? 'view-list' : '']">
          <div
            v-for="(product, idx) in pagedProducts"
            :key="product.productId"
            class="pcard"
            :class="{ 'list-card': currentView === 'list' }"
            :style="{ animationDelay: (idx * 0.05) + 's' }"
          >
            <!-- 카드 이미지  + 찜버튼 -->
            <div class="pcard-img">
                <a href="javascript:;" @click="fnView(item.empNo)">
                    <img 
                    :src="product.imgUrl 
                        ? '/product-img/' + product.imgUrl 
                        : '/product-img/default.jpg'"
                    class="pcard-img"
                    /> 
                </a>
              <!-- 찜 버튼 : wishedIds Set에 포함 여부로 wished 클래스 토글 -->
              <button
                :class="{ wished: wishedIds.has(product.productId) }"
                @click.stop="toggleWish(product.productId)"
              >
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
              </button>
            </div>

            <!-- 카드 텍스트 본문 -->
            <div class="pcard-body">
              <!-- 리스트 뷰: 이름/별점/가격/버튼을 가로로 배치 -->
              <template v-if="currentView === 'list'">
                <div class="pcard-main">
                  <div class="pcard-cat">{{ product.categoryId }}</div>
                  <div class="pcard-name">{{ product.productName }}</div>
                  <div class="stars">
                    <span v-html="starsHTML(product.rating)"></span>
                    <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span>
                  </div>
                </div>
                <div class="pcard-price-wrap">
                  <div class="price-row" style="justify-content:flex-end">
                    <span class="price-orig" v-if="product.origRent">{{ product.origRent.toLocaleString() }}원</span>
                    <span class="price-main">{{ product.price.toLocaleString() }}원</span>
                    <span class="price-unit">/ 1박</span>
                  </div>
                  <div v-if="product.buyPrice" style="font-size:11px;color:var(--stone);text-align:right;margin-bottom:10px">
                    구매 {{ product.buyPrice.toLocaleString() }}원
                  </div>
                </div>
              </template>

              <!-- 그리드 뷰: 세로 배치 -->
              <template v-else>
                <!-- <div class="pcard-cat">{{ product.brand }} · {{ product.cat }}</div> -->
                <div class="pcard-name">{{ product.productName }}</div>
                <div class="stars">
                  <span v-html="starsHTML(product.rating)"></span>
                  <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span>
                </div>
                <div class="price-row">
                  <span class="price-orig" v-if="product.origRent">{{ product.origRent.toLocaleString() }}원</span>
                  <span class="price-main">{{ (product.price || 0).toLocaleString() }}원</span>
                  <span class="price-unit">/ 1박</span>
                </div>
              </template>

              <!-- 대여 / 구매 버튼 -->
              <div class="btn-row">
                <button v-if="product.productType !== 'PURCHASE'" class="btn-rent">대여하기</button>
                <button v-if="product.productType !== 'RENTAL'" class="btn-buy">구매하기</button>
              </div>
            </div>
          </div>
        </div><!-- /product-grid -->

        <!-- ── 페이지네이션 ── -->
        <div class="pagination" v-if="totalPages > 1">
          <button class="ppage arrow" @click="goPage(currentPage - 1)" :disabled="currentPage === 1">
            <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
          <button
            v-for="n in totalPages"
            :key="n"
            class="ppage"
            :class="{ active: n === currentPage }"
            @click="goPage(n)"
          >{{ n }}</button>
          <button class="ppage arrow" @click="goPage(currentPage + 1)" :disabled="currentPage === totalPages">
            <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
          </button>
        </div>
        
      </div><!-- /grid-wrap -->
    </div><!-- /content-wrap -->
  </div><!-- /page-wrap -->

</div><!-- /#app -->

<script>
const { createApp, ref, computed, onMounted, reactive } = Vue;

createApp({

  /* ══════════════════════════════════════
     반응형 데이터 (data)
     - Vue가 변경을 감지하여 자동으로 화면을 갱신함
  ══════════════════════════════════════ */
  data() {
    return {
      /* 서버에서 불러온 상품 목록 (AJAX 응답 후 채워짐) */
      products: [],

      /* 로딩 상태 표시 플래그 */
      loading: false,

      /* 현재 선택된 카테고리 ('전체' 기본값) */
      currentCat: '전체',

      /* 그리드 / 리스트 뷰 전환 */
      currentView: 'grid',

      /* 정렬 기준 */
      sortKey: 'popular',

      /* 현재 페이지 번호 */
      currentPage: 1,

      /* 페이지당 상품 수 */
      perPage: 12,

      /* 사이드바 표시 여부 */
      sidebarVisible: true,

      /* 찜 목록 (상품 id Set) - DB 연동 시 로그인 사용자 찜 목록으로 초기화 */
      wishedIds: new Set(),

      /* 필터 옵션 상태 */
      filter: {
        rentable:   true,
        buyable:    true,
        period:     [],        /* 선택된 대여 기간 배열 */
        priceRange: 50,        /* 0~100 슬라이더 값 */
        minRating:  null,      /* 최소 평점 */
      },

      /* 카테고리 pill 목록 (필요 시 서버에서 불러올 수 있음) */
      categories: [
        { id: '전체', name: '전체', emoji: '🏕️' },
        { id: 4, name: '텐트', emoji: '⛺' },
        { id: 5, name: '침낭·매트', emoji: '🛏️' },
        { id: 6, name: '취사도구', emoji: '🔥' },
        { id: 7, name: '조명', emoji: '💡' },
        { id: 8, name: '테이블·의자', emoji: '🪑' },
        { id: 9, name: '안전용품', emoji: '🔒' },
        { id: 10, name: '기타 용품', emoji: '🎒' },
        ]

    };
  },

  /* ══════════════════════════════════════
     계산된 속성 (computed)
     - 의존 데이터가 바뀔 때 자동으로 재계산됨
  ══════════════════════════════════════ */
  computed: {

    /* 카테고리 + 필터 + 정렬이 적용된 상품 목록 */
    filteredProducts() {
    let list = this.currentCat === '전체'
        ? this.products
        : this.products.filter(p => p.categoryId === this.currentCat);

    return [...list].sort((a, b) => {
        if (this.sortKey === 'price-low')  return a.price - b.price;
        if (this.sortKey === 'price-high') return b.price - a.price;
        if (this.sortKey === 'newest')     return b.productId - a.productId;

        return b.productId - a.productId;
    });
    },

    /* 현재 페이지에 해당하는 상품 슬라이스 */
    pagedProducts() {
      const start = (this.currentPage - 1) * this.perPage;
      return this.filteredProducts.slice(start, start + this.perPage);
    },

    /* 전체 페이지 수 */
    totalPages() {
      return Math.ceil(this.filteredProducts.length / this.perPage);
    },

    /* 슬라이더 값 → 화면 표시 금액 문자열 */
    priceRangeLabel() {
      const v = Math.round(this.filter.priceRange * 500);
      return v >= 50000 ? '50,000원+' : v.toLocaleString() + '원';
    },
  },

  /* ══════════════════════════════════════
     메서드 (methods)
  ══════════════════════════════════════ */
  methods: {

    /* ── 상품 목록 조회 (AJAX → Spring Boot) ──────────────
       엔드포인트 예시: POST /product/list.dox
       Spring Boot 컨트롤러에서 List<ProductVO>를 JSON으로 반환
    ────────────────────────────────────────────────────── */
    fnList() {
      let self = this;
      self.loading = true;

      let param = {
        cat:      self.currentCat,   /* 선택된 카테고리 */
        sortKey:  self.sortKey,      /* 정렬 기준 */
        page:     self.currentPage,  /* 페이지 번호 */
        perPage:  self.perPage,      /* 페이지당 항목 수 */
      };

      $.ajax({
        url:      "http://localhost:8080/product/list.dox",
        dataType: "json",
        type:     "POST",
        data:     param,
        success: function(data) {
          /* 서버 응답 구조 예시: { list: [...], total: 48 } */
          self.products    = data.list;
          self.loading     = false;
          self.currentPage = 1;

          console.log("서버 데이터:", data.list);
        console.log("첫번째 상품:", data.list[0]);
        self.products = data.list;
        },
        error: function(xhr, status, err) {
          /* 에러 발생 시 처리 */
          console.error("상품 목록 조회 실패:", err);
          self.loading = false;
        }
      });
    },

    /* ── 찜 토글 (위시리스트 추가/제거) ──────────────────
       서버 동기화가 필요하면 아래 주석 해제 후 사용
    ────────────────────────────────────────────────────── */
    toggleWish(id) {
      /* Set은 Vue 반응형을 직접 감지하지 못하므로 새 Set으로 교체 */
      const next = new Set(this.wishedIds);
      if (next.has(id)) {
        next.delete(id);
        /* 서버 제거 요청 예시: this.fnWishDelete(id); */
      } else {
        next.add(id);
        /* 서버 추가 요청 예시: this.fnWishAdd(id); */
      }
      this.wishedIds = next;
    },

    /* ── 카테고리 선택 ── */
    selectCat(cat) {
        this.currentCat = cat.id;   // ⭐ 핵심
        this.currentPage = 1;
      /* 카테고리 변경 시 서버 재조회 필요하면 this.fnList() 호출 */
    },

    /* ── 페이지 이동 ── */
    goPage(n) {
      if (n < 1 || n > this.totalPages) return;
      this.currentPage = n;
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },

    /* ── 필터 초기화 ── */
    resetFilter() {
      this.filter = {
        rentable:   true,
        buyable:    true,
        period:     [],
        priceRange: 50,
        minRating:  null,
      };
      this.currentPage = 1;
    },

    /* ── 대여하기 버튼 클릭 → 대여 페이지 이동 또는 모달 오픈 ── */
    goRent(product) {
      /* 예시: location.href = '/rent/form.jsp?id=' + product.id; */
      console.log('대여하기:', product);
    },

    /* ── 구매하기 버튼 클릭 → 구매 페이지 이동 또는 카트 추가 ── */
    goBuy(product) {
      /* 예시: location.href = '/buy/form.jsp?id=' + product.id; */
      console.log('구매하기:', product);
    },

    /* ── 사이드바 필터 섹션 접기/펼치기 ── */
    toggleSection(event) {
      const header = event.currentTarget;
      const opts   = header.nextElementSibling;
      const arrow  = header.querySelector('.fs-arrow');
      const isOpen = arrow.classList.contains('open');
      opts.style.display = isOpen ? 'none' : 'flex';
      arrow.classList.toggle('open', !isOpen);
    },

    /* ── 가격 슬라이더 배경 그라데이션 업데이트 ── */
    updateRangeStyle(event) {
      const el  = event.target;
      const pct = el.value + '%';
      el.style.background = `linear-gradient(to right, var(--ember) 0%, var(--ember) ${pct}, var(--border) ${pct}, var(--border) 100%)`;
    },

    /* ── 별점 HTML 생성 (v-html로 렌더링) ── */
    starsHTML(rating) {
      const full = Math.floor(rating);
      const half = rating % 1 >= 0.5;
      let html = '';
      for (let i = 0; i < full; i++) html += '<span class="star">★</span>';
      if (half) html += '<span class="star" style="opacity:.5">★</span>';
      return html;
    }

    // /* ── 뱃지 CSS 클래스 반환 ── */
    // badgeClass(badge) {
    //   const map = { hot: 'pbadge-hot', sale: 'pbadge-sale', new: 'pbadge-new', best: 'pbadge-best' };
    //   return map[badge] || '';
    // },

    // /* ── 뱃지 표시 텍스트 반환 ── */
    // badgeText(badge) {
    //   const map = { hot: '🔥 인기', sale: '할인', new: 'NEW', best: '베스트' };
    //   return map[badge] || '';
    // },
  },

  /* ══════════════════════════════════════
     라이프사이클 훅 (mounted)
     - DOM이 준비된 직후 실행 → 초기 데이터 로딩
  ══════════════════════════════════════ */
  mounted() {
    /* 페이지 최초 진입 시 상품 목록 조회 */
    this.fnList();
  },

}).mount('#app');
</script>
</body>
</html>
