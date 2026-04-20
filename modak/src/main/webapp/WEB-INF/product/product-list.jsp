<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>모닥모닥 - 장비 목록</title>

<!-- <link rel="stylesheet" href="/css/common/font.css"> -->
<link rel="stylesheet" href="/css/product/product-list.css">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="/js/page-change.js"></script>
</head>

<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app">

  <!-- ── 카테고리 pill 바 ── -->
  <div class="cat-bar">
    <div class="cat-bar-inner">
      <!-- 전체 pill (고정) -->
      <button
        class="cat-pill"
        :class="{ active: currentCat === null }"
        @click="selectCategory(null)"
      >
        <span class="pill-emoji">⛺</span>
        전체
      </button>
      <!-- DB에서 가져온 부모 카테고리 순회 -->
      <button
        v-for="cat in category"
        :key="cat.categoryId"
        class="cat-pill"
        :class="{ active: currentCat === cat.categoryId }"
        @click="selectCategory(cat.categoryId)"
      >
        {{ cat.categoryName }}
      </button>
    </div>
  </div>

  <!-- ── 메인 컨텐츠 영역 ── -->
  <div class="page-wrap">
    <div class="top-row">
      <div class="result-info">
        <div class="result-label">인기 장비</div>
        <div>
          <span class="result-title">{{ getCurrentCategoryName() }}</span>
          <span class="result-count">총 {{ filteredProducts.length }}개</span>
        </div>
      </div>
      <div class="controls">
        <button class="filter-toggle" @click="sidebarVisible = !sidebarVisible">
          <svg viewBox="0 0 24 24"><line x1="4" y1="6" x2="20" y2="6"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="11" y1="18" x2="13" y2="18"/></svg>
          필터
        </button>
        <select class="sort-select" v-model="sortKey" @change="currentPage = 1">
          <option value="popular">인기순</option>
          <option value="newest">최신순</option>
          <option value="price-low">가격 낮은순</option>
          <option value="price-high">가격 높은순</option>
          <option value="rating">평점순</option>
        </select>
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
      <div class="sidebar" v-show="sidebarVisible">
        <!-- 대여/구매 필터 -->
        <div class="filter-section">
          <div class="fs-header">
            <span class="fs-title">대여 / 구매</span>
          </div>
          <div class="filter-opts">
            <label class="fopt">
              <input type="checkbox" v-model="filter.rentable" @change="fnList"> 대여 가능
              <span class="fopt-count">38</span>
            </label>
            <label class="fopt">
              <input type="checkbox" v-model="filter.buyable" @change="fnList"> 구매 가능
              <span class="fopt-count">42</span>
            </label>
          </div>
        </div>

        <!-- 자식 카테고리 필터 -->
    <div class="filter-section" v-if="childCategory.length > 0">
      <div class="fs-header">
        <span class="fs-title">세부 카테고리</span>
      </div>

      <div class="filter-opts">
        <label
          class="fopt"
          v-for="child in childCategory"
          :key="child.categoryId"
        >
          <input
            type="radio"
            name="childCategory"
            :value="child.categoryId"
            v-model="currentChild"
            @change="fnList"
          >
          {{ child.categoryName }}
        </label>

        <!-- 전체 선택 -->
        <label class="fopt">
          <input
            type="radio"
            name="childCategory"
            :value="null"
            v-model="currentChild"
            @change="fnList"
          >
          전체
        </label>
      </div>
    </div>

        <!-- 브랜드 필터 -->
        <div class="filter-section">
          <div class="fs-header">
            <span class="fs-title">브랜드</span>
          </div>
          <div class="filter-opts">
            <label class="fopt">
              <input type="checkbox" v-model="filter.brandId" :value="1" @change="fnList"> 케로로
            </label>
            <label class="fopt">
              <input type="checkbox" v-model="filter.brandId" :value="2" @change="fnList"> 타마마
            </label>
          </div>
        </div>

        <!-- 가격 범위 슬라이더
        <div class="filter-section">
          <div class="fs-header">
            <span class="fs-title">1박 가격</span>
          </div>
          <div class="range-wrap">
            <div class="range-row">
              <span class="range-val">0원</span>
              <span class="range-val">{{ priceRangeLabel }}</span>
            </div>
            <input type="range" min="0" max="100" v-model="filter.priceRange" @input="updateRangeStyle">
          </div>
        </div> -->

        <!-- 평점 필터 -->
        <div class="filter-section">
          <div class="fs-header">
            <span class="fs-title">평점</span>
          </div>
          <div class="filter-opts">
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="5"> ★★★★★ 5.0</label>
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="4"> ★★★★☆ 4.0 이상</label>
            <label class="fopt"><input type="radio" name="rating" v-model="filter.minRating" value="3"> ★★★☆☆ 3.0 이상</label>
          </div>
        </div>

        <div style="padding:14px 20px;">
          <button class="filter-reset" @click="resetFilter">필터 초기화</button>
        </div>
      </div><!-- /sidebar -->

      <!-- ── 상품 목록 ── -->
      <div class="grid-wrap">
        <div v-if="loading" class="empty">
          <div class="empty-emoji">⏳</div>
          <div class="empty-msg">장비를 불러오는 중입니다...</div>
        </div>

        <div v-else-if="pagedProducts.length === 0" class="empty">
          <div class="empty-emoji">🏕️</div>
          <div class="empty-msg">해당 조건의 장비가 없습니다</div>
        </div>

        <div v-else :class="['product-grid', currentView === 'list' ? 'view-list' : '']">
          <div
            v-for="(product, idx) in pagedProducts"
            :key="product.productId"
            class="pcard"
            :class="{ 'list-card': currentView === 'list' }"
            :style="{ animationDelay: (idx * 0.05) + 's' }"
          >
            <div class="pcard-img">
              <a href="javascript:;" @click="fnView(product.productId)">
                <img
                  :src="product.imgUrl
                    ? '/product-img/' + product.imgUrl
                    : '/product-img/default.jpg'"
                  class="pcard-img"
                />
              </a>
              <button
                :class="{ wished: wishedIds.has(product.productId) }"
                @click.stop="toggleWish(product.productId)"
              >
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
              </button>
            </div>
            <div class="pcard-body">
              <template v-if="currentView === 'list'">
                <div class="pcard-main">
                  <div class="pcard-cat">{{ product.categoryId }}</div>
                  <div class="pcard-name">{{ product.productName }}</div>
                  <!-- <div class="stars">
                    <span v-html="starsHTML(product.rating)"></span>
                    <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span>
                  </div> -->
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
              
              <template v-else>
                <div class="pcard-name">{{ product.productName }}</div>
                <!-- <div class="stars">
                  <span v-html="starsHTML(product.rating)"></span>
                  <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span> 리뷰 별점 평균 -->
            </div>
                <div class="price-row">
                  <span class="price-orig" v-if="product.origRent">{{ product.origRent.toLocaleString() }}원</span>
                  <span class="price-main">{{ (product.price || 0).toLocaleString() }}원</span>
                  <span class="price-unit">/ 1박</span>
                </div>
              </template>

              <div class="btn-row">
                <button v-if="product.productType !== 'PURCHASE'" class="btn-rent">대여하기</button>
                <button v-if="product.productType !== 'RENTAL'" class="btn-buy">구매하기</button>
              </div>
            </div>
          </div>
        </div><!-- /product-grid -->

      </div><!-- /grid-wrap -->
    </div><!-- /content-wrap -->
  </div><!-- /page-wrap -->

</div><!-- /#app -->

<script>
const { createApp } = Vue;

createApp({

  data() {
    return {
      products:        [],
      loading:         false,

      category:      [],    // 부모 카테고리 (pill 바)
      childCategory: [],    // 자식 카테고리 (사이드바) ← 추가
      currentCat:      null,  // null = 전체  ← 'null' 문자열에서 수정
      currentChild:    null,  // 선택된 자식 카테고리 ← 추가

      currentView:     'grid',
      sortKey:         'popular',
      currentPage:     1,
      perPage:         12,
      sidebarVisible:  true,
      wishedIds:       new Set(),

      filter: {
        rentable:   true,
        buyable:    true,
        brandId:   [],
        priceRange: 50,
        minRating:  null,
      },
    };
  },

  computed: {

    filteredProducts() {
      let list = this.currentCat === null          // ← 'null' 문자열에서 수정
        ? this.products
        : this.products.filter(p => p.categoryId === this.currentCat);

      // 자식 카테고리 필터 ← 추가
      if (this.currentChild !== null) {
        list = list.filter(p => p.childCategoryId === this.currentChild);
      }

      return [...list].sort((a, b) => {
        if (this.sortKey === 'price-low')  return a.price - b.price;
        if (this.sortKey === 'price-high') return b.price - a.price;
        if (this.sortKey === 'newest')     return b.productId - a.productId;
        return b.productId - a.productId;
      });
    },

    pagedProducts() {
      const start = (this.currentPage - 1) * this.perPage;
      return this.filteredProducts.slice(start, start + this.perPage);
    },

    totalPages() {
      return Math.ceil(this.filteredProducts.length / this.perPage);
    },

    priceRangeLabel() {
      const v = Math.round(this.filter.priceRange * 500);
      return v >= 50000 ? '50,000원+' : v.toLocaleString() + '원';
    },
  },

  methods: {

    // ── 상품 목록 조회 ──
    fnList() {
      let self = this;
      self.loading = true;
      

      let param = {
        categoryId:  self.currentCat,
        childCatId:  self.currentChild,  // ← 자식 카테고리 파라미터 추가
        sortKey:     self.sortKey,
        page:        self.currentPage,
        perPage:     self.perPage,
        // 구매/대여 필터링
        rentable: self.filter.rentable,  
        buyable:  self.filter.buyable,
        // 브랜드 필터링
        brandId: self.filter.brandId || []
      };

      $.ajax({
        url:      "/product/list.dox",
        dataType: "json",
        type:     "POST",
        data:     param,
        traditional: true,
        success: function(data) {
          self.products = Array.isArray(data.list) ? data.list : [];
          self.loading     = false;
          self.currentPage = 1;
        },
        error: function(xhr, status, err) {
          console.error("상품 목록 조회 실패:", err);
          self.loading = false;
        }
      });
    },

    // ── 부모 카테고리 조회 (pill 바) ──
    fetchCategory() {
      let self = this;
      $.ajax({
        url: "/category/parentList.dox",
        dataType: "json",
        type: "POST",
        success: function(data) {
          if (data.result === 'success') {
            self.category = data.list;
          }
        },
        error: function(xhr, status, err) {
          console.error("카테고리 조회 실패:", err);
        }
      });
    },

    // ── 자식 카테고리 조회 (사이드바) ── ← 추가
    fetchChildCategory(parentId) {
      let self = this;
      $.ajax({
        url: "/category/childList.dox",
        dataType: "json",
        type: "POST",
        data:     { parentId: parentId },
        success: function(data) {
          if (data.result === 'success') {
            self.childCategory = data.list;
          }
          
        },
        error: function(xhr, status, err) {
          console.error("자식 카테고리 조회 실패:", err);
        }
      });
    },

    // ── 부모 카테고리 선택 ──
    selectCategory(catId) {
      this.currentCat   = catId;
      this.currentChild = null;          // 자식 선택 초기화

      if (catId !== null) {
        this.fetchChildCategory(catId); // 자식 카테고리 로드
      } else {
        this.childCategory = [];        // 전체 선택 시 사이드바 비우기
      }

      this.currentPage = 1;
      this.fnList();
    },

    // ── 현재 카테고리명 반환 ──
    getCurrentCategoryName() {
      if (this.currentCat === null) return '전체 장비';  // ← '전체' 문자열에서 수정
      const cat = this.category.find(c => c.categoryId === this.currentCat);
      return cat ? cat.categoryName : '';
    },

    toggleWish(id) {
      const next = new Set(this.wishedIds);
      if (next.has(id)) next.delete(id);
      else              next.add(id);
      this.wishedIds = next;
    },

    resetFilter() {
      this.filter = {
        rentable:   true,
        buyable:    true,
        brandId:   [],
        priceRange: 50,
        minRating:  null,
      };
      this.currentPage = 1;
    },

    updateRangeStyle(event) {
      const el  = event.target;
      const pct = el.value + '%';
      el.style.background = `linear-gradient(to right, var(--ember) 0%, var(--ember) ${pct}, var(--border) ${pct}, var(--border) 100%)`;
    },

    // starsHTML(rating) {
    //   const full = Math.floor(rating);
    //   const half = rating % 1 >= 0.5;
    //   let html = '';
    //   for (let i = 0; i < full; i++) html += '<span class="star">★</span>';
    //   if (half) html += '<span class="star" style="opacity:.5">★</span>';
    //   return html;
    // },
    fnView : function(productId) {
                alert("제품상세로 이동");
                pageChange("/product/detail.do", {productId : productId});
            }
  },

  mounted() {
    this.fetchCategory();  // 부모 카테고리 로드
    this.fnList();           // 상품 목록 로드 (fetchProducts 제거, fnList로 통일)
  },

}).mount('#app');
</script>
</body>
</html>