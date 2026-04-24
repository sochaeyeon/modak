<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 장비 목록</title>

    <link rel="stylesheet" href="/css/product/product-list.css">
    <link rel="stylesheet" href="/css/search/search.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
      integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
  </head>
  <body>
    <%@ include file="/WEB-INF/common/header.jsp" %>

    <div id="app" v-cloak>

        <!-- ── 카테고리 pill 바 ── -->
        <div class="cat-bar">
          <div class="cat-bar-inner">
            <!-- 전체 pill (고정) -->
            <button class="cat-pill" :class="{ active: currentCat === null }" @click="selectCategory(null)">
              <span class="pill-emoji">⭐</span>
              전체
            </button>
            <!-- DB에서 가져온 부모 카테고리 순회 -->
            <button v-for="cat in category" :key="cat.categoryId" class="cat-pill"
              :class="{ active: currentCat === cat.categoryId }" @click="selectCategory(cat.categoryId)">
              <span class="pill-emoji">⛺</span>
              {{ cat.categoryName }}
            </button>
          </div>
        </div>

        <!-- ── 메인 컨텐츠 영역 ── -->
        <div class="page-wrap">
          <div class="top-row" style="display: grid; grid-template-columns: 1fr 400px 1fr;">
            <div class="result-info">
              <div class="result-label">인기 장비</div>
              <div>
                <span class="result-title">{{ getCurrentCategoryName() }}</span>
                <span class="result-count">총 {{ filteredProducts.length }}개</span>
              </div>
            </div>
            <!-- 검색창 -->
            <div class="search-box">
              <input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요" @keyup.enter="fnSearch">
              <button type="button" @click="fnSearch">검색</button>
            </div>
            <div class="controls">
              <button class="filter-toggle" :class="{ active: sidebarVisible }" @click="sidebarVisible = !sidebarVisible">
                <svg viewBox="0 0 24 24">
                  <line x1="4" y1="6" x2="20" y2="6" />
                  <line x1="8" y1="12" x2="16" y2="12" />
                  <line x1="11" y1="18" x2="13" y2="18" />
                </svg>
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
                  <svg viewBox="0 0 24 24">
                    <rect x="3" y="3" width="7" height="7" />
                    <rect x="14" y="3" width="7" height="7" />
                    <rect x="3" y="14" width="7" height="7" />
                    <rect x="14" y="14" width="7" height="7" />
                  </svg>
                </button>
                <button class="vbtn" :class="{ active: currentView === 'list' }" @click="currentView = 'list'">
                  <svg viewBox="0 0 24 24">
                    <line x1="8" y1="6" x2="21" y2="6" />
                    <line x1="8" y1="12" x2="21" y2="12" />
                    <line x1="8" y1="18" x2="21" y2="18" />
                    <line x1="3" y1="6" x2="3.01" y2="6" />
                    <line x1="3" y1="12" x2="3.01" y2="12" />
                    <line x1="3" y1="18" x2="3.01" y2="18" />
                  </svg>
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
                    <span class="fopt-count"></span>
                  </label>
                  <label class="fopt">
                    <input type="checkbox" v-model="filter.buyable" @change="fnList"> 구매 가능
                    <span class="fopt-count"></span>
                  </label>
                </div>
              </div>

              <!-- 자식 카테고리 필터 -->
              <div class="filter-section" v-if="childCategory.length > 0">
                <div class="fs-header">
                  <span class="fs-title">세부 카테고리</span>
                </div>
                <!-- 전체 선택 -->
                  <label class="fopt">
                    <input type="radio" name="childCategory" :value="null" v-model="currentChild" @change="fnList">
                    전체
                  </label>
                <div class="filter-opts">
                  <label class="fopt" v-for="child in childCategory" :key="child.categoryId">
                    <input type="radio" name="childCategory" :value="child.categoryId" v-model="currentChild"
                      @change="fnList">
                    {{ child.categoryName }}
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
                    <input type="radio" :checked="filter.brandId.length === 0" @change="clearBrands"> 전체
                  </label>

                  <label class="fopt" v-for="brand in brandList" :key="brand.brandId">
                    <input type="checkbox" :value="brand.brandId" v-model="filter.brandId" @change="fnList"> {{
                    brand.brandName }}
                  </label>
                </div>
              </div>

              <div class="filter-section">
                <div class="fs-header">
                  <span class="fs-title">1박 대여 가격</span>
                </div>
                <div class="filter-opts">
                  <label class="fopt"><input type="radio" v-model="filter.priceRange" :value="null" @change="fnSearch"
                      checked="checked"> 전체</label>
                  <label class="fopt"><input type="radio" v-model="filter.priceRange" value="0-10000"
                      @change="fnSearch"> 1만원 이하</label>
                  <label class="fopt"><input type="radio" v-model="filter.priceRange" value="10000-30000"
                      @change="fnSearch"> 1만원 ~ 3만원</label>
                  <label class="fopt"><input type="radio" v-model="filter.priceRange" value="30000-50000"
                      @change="fnSearch"> 3만원 ~ 5만원</label>
                  <label class="fopt"><input type="radio" v-model="filter.priceRange" value="50000-999999"
                      @change="fnSearch"> 5만원 이상</label>
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
                <div v-for="(product, idx) in pagedProducts" :key="product.productId" class="pcard"
                  :class="{ 'list-card': currentView === 'list' }" :style="{ animationDelay: (idx * 0.05) + 's' }"
                  @click="fnView(product.productId)">
                  <div class="pcard-img">
                      <img :src="product.imgUrl || '/img/product/default.jpg'" class="pcard-img" />
                  </div>
                  <button class="wish-btn"
                    :class="{ on: wishedIds.has(product.productId) }"
                    :data-pid="product.productId"
                    @click.stop="fnWishVue($event, product.productId)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                    </svg>
                </button>
                  <div class="pcard-body">
                    <template v-if="currentView === 'list'">
                      <div class="pcard-main">
                        <div class="pcard-name" style="cursor:pointer;">{{ product.productName }}</div>
                        <div class="stars">
                          <span v-html="starsHTML(product.rating)"></span>
                          <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span>
                        </div>
                      </div>
                      <div class="pcard-price-wrap">
                        <div class="price-row" style="justify-content:flex-end">
                          <span class="price-orig" v-if="product.origRent">{{ product.origRent.toLocaleString() }}원</span>
                          <span class="price-main">{{ product.price.toLocaleString() }}원</span>
                          <span class="price-unit" v-if="product.productType !== 'PURCHASE'">/ 1박</span>
                        </div>
                        <div v-if="product.buyPrice"
                          style="font-size:11px;color:var(--stone);text-align:right;margin-bottom:10px">
                          구매 {{ product.buyPrice.toLocaleString() }}원
                        </div>
                      </div>
                    </template>

                    <template v-else>
                      <div class="pcard-cat">{{ product.categoryName }}</div>

                      <div class="pcard-name">{{ product.productName }}</div>
                      <!-- <div class="stars">
                        <span v-html="starsHTML(product.rating)"></span>
                        <span class="star-count">{{ product.rating }} ({{ product.rCount }})</span> 리뷰 별점 평균
                      </div> -->
                      <div class="price-row">
                        <span class="price-orig" v-if="product.origRent">{{ product.origRent.toLocaleString() }}원</span>
                        <span class="price-main">{{ (product.price || 0).toLocaleString() }}원</span>
                        <span class="price-unit" v-if="product.productType !== 'PURCHASE'">/ 1박</span>
                      </div>
                    </template>

                    <div class="btn-row">
                      <button v-if="product.productType !== 'PURCHASE'" class="btn-rent" 
                        @click.stop="fnView(product.productId)">대여하기</button>
                      <button v-if="product.productType !== 'RENTAL'" class="btn-buy"
                        @click.stop="fnView(product.productId)">구매하기</button>
                    </div>
                  </div>
                </div>
              </div><!-- /product-grid -->
              <div class="grid-wrap">
                <div class="pagination" v-if="totalPages > 1">
                  <button class="page-btn prev" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
                    &lt;
                  </button>

                  <button v-for="page in totalPages" :key="page" class="page-number"
                    :class="{ active: currentPage === page }" @click="changePage(page)">
                    {{ page }}
                  </button>

                  <button class="page-btn next" :disabled="currentPage === totalPages"
                    @click="changePage(currentPage + 1)">
                    &gt;
                  </button>
                </div>
              </div>

            </div><!-- /grid-wrap -->
          </div><!-- /content-wrap -->
        </div><!-- /page-wrap -->
        <div v-if="confirmModal.open" class="confirm-overlay" @click.self="confirmCancel">
            <div class="confirm-box">
                <div class="confirm-title">알림</div>
                  <div class="confirm-message">{{ confirmModal.message }}</div>

                  <div class="confirm-btns">
                    <button class="confirm-cancel" @click="confirmCancel">
                        {{ confirmModal.cancelText }}
                    </button>
                    <button class="confirm-ok" @click="confirmOk">
                        {{ confirmModal.okText }}
                    </button>
                </div>
            </div>
        </div>
      </div><!-- /#app -->
      <%@ include file="/WEB-INF/common/footer.jsp" %>
    <script>
          // ── 토스트 ──
          function showToast(msg) {
              var t = document.getElementById('toast');
              if (!t) {
                  t = document.createElement('div');
                  t.id = 'toast';
                  t.style.cssText = 'position:fixed;bottom:30px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:10px 20px;border-radius:8px;font-size:13px;z-index:9999;display:none;';
                  document.body.appendChild(t);
              }
              t.textContent = msg;
              t.style.display = 'block';
              setTimeout(function(){ t.style.display = 'none'; }, 2200);
          }

          // ── 위시 토글 ──
          function fnWish(e, btn, no) {
              e.stopPropagation();
              $.ajax({
                  url     : '/user/wishlist/toggle.dox',
                  type    : 'POST',
                  data    : { productId: no },
                  dataType: 'json',
                  success : function(res) {
                      if (res.result === 'success') {
                          btn.classList.toggle('on');
                          var isOn = btn.classList.contains('on');
                          showToast(isOn ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
                      } else {
                          showToast('로그인이 필요합니다.');
                      }
                  }
              });
          }
          const { createApp } = Vue;

          createApp({

            data() {
              return {
                products: [],
                brandList: [],
                loading: false,

                category: [],    // 부모 카테고리 (pill 바)
                childCategory: [],    // 자식 카테고리 (사이드바) ← 추가
                currentCat: null,  // null = 전체  ← 'null' 문자열에서 수정
                currentChild: null,  // 선택된 자식 카테고리 ← 추가

                currentView: 'grid',
                sortKey: 'popular',
                currentPage: 1,
                perPage: 12,
                sidebarVisible: true,
                wishedIds: new Set(),
                searchKeyword: '', // 검색어 변수
                priceRange: null, // 가격 필터링

                filter: {
                  rentable: true,  // 페이지 로드 시 '대여 가능' 체크됨
                  buyable: true,   // 페이지 로드 시 '구매 가능' 체크됨
                  brandId: [], // 체크된 브랜드 아이디가 담김
                  priceRange: 50,
                  minRating: null,
                },
                confirmModal: {
                  open: false,
                  message: '',
                  okText: '확인',
                  cancelText: '취소',
                  onOk: null
                }
              };
            },

            computed: {

              filteredProducts() {
                let list = this.products;

                return [...list].sort((a, b) => {
                  if (this.sortKey === 'price-low') return a.price - b.price;
                  if (this.sortKey === 'price-high') return b.price - a.price;
                  if (this.sortKey === 'newest') return b.createdAt - a.createdAt;
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
                // 가격 필터링
                let minP = null;
                let maxP = null;
                // ⭐ 수정: priceRange가 존재하고(null이 아니고), 동시에 빈 문자열이 아닐 때만 split 실행
                if (self.filter.priceRange && typeof self.filter.priceRange === 'string') {
                  const prices = self.filter.priceRange.split('-');
                  minP = parseInt(prices[0]);
                  maxP = parseInt(prices[1]);
                }

                let param = {
                  categoryId: self.currentCat,
                  childCatId: self.currentChild,  // ← 자식 카테고리 파라미터 추가
                  sortKey: self.sortKey,
                  page: self.currentPage,
                  perPage: self.perPage,
                  // 구매/대여 필터링
                  rentable: self.filter.rentable,
                  buyable: self.filter.buyable,
                  // 브랜드 필터링 brandId가 빈 배열이면 서버에 보내지 않거나 null 처리
                  brandId: self.filter.brandId.length > 0 ? self.filter.brandId : null,
                  // 가격 필터링 , 전체일 때는 null이 넘어감
                  priceMin: minP,
                  priceMax: maxP,
                  // 검색어
                  searchKeyword: self.searchKeyword
                };
                console.log("서버 전송 전 필터 값:", param.rentable, param.buyable);
                $.ajax({
                  url: "/product/list.dox",
                  dataType: "json",
                  type: "POST",
                  data: param,
                  traditional: true,
                  success: function (data) {
                    self.products = Array.isArray(data.list) ? data.list : [];
                    self.loading = false;
                    console.log(self.products);

                    // 위시
                    self.$nextTick(function() {
                        // 위시 목록 가져와서 하트 초기화
                        $.ajax({
                            url     : '/user/wishlist/list.dox',
                            type    : 'POST',
                            dataType: 'json',
                            success : function(wRes) {
                                if (wRes.result === 'success' && wRes.list && wRes.list.length) {
                                    // ✅ Vue wishedIds Set 업데이트 → 자동 반영
                                    self.wishedIds = new Set(
                                        wRes.list.map(function(w){ return w.productId; })
                                    );
                                }
                            }
                        });
                    });
                  },
                  error: function (xhr, status, err) {
                    console.error("상품 목록 조회 실패:", err);
                    self.loading = false;
                  }
                });
              }, // fnList 
              
              fnSearch() {
                this.currentPage = 1;
                this.fnList();
              },

              // ── 부모 카테고리 조회 (pill 바) ──
              fetchCategory() {
                let self = this;
                $.ajax({
                  url: "/category/parentList.dox",
                  dataType: "json",
                  type: "POST",
                  success: function (data) {
                    if (data.result === 'success') {
                      self.category = data.list;
                    }
                  },
                  error: function (xhr, status, err) {
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
                  data: { parentId: parentId },
                  success: function (data) {
                    if (data.result === 'success') {
                      self.childCategory = data.list;
                    }

                  },
                  error: function (xhr, status, err) {
                    console.error("자식 카테고리 조회 실패:", err);
                  }
                });
              },

              // ── 부모 카테고리 선택 ──
              selectCategory(catId) {
                this.currentCat = catId;
                this.currentChild = null;          // 자식 카테고리 선택 초기화

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

              resetFilter() {
                this.filter = {
                  // productType: 'all', // 초기화 시 '전체'로 이동
                  rentable: true,   // '대여 가능' 체크박스 활성화
                  buyable: true,    // '구매 가능' 체크박스 활성화
                  brandId: [],
                  priceRange: null,
                  minRating: null,
                };
                // 부모 카테고리와 자식 카테고리도 초기화하고 싶다면 아래 주석 해제
                this.currentCat = null;
                this.currentChild = null;
                this.childCategory = [];
                this.currentPage = 1;
                this.fnList();
              },

              updateRangeStyle(event) {
                const el = event.target;
                const pct = el.value + '%';
                el.style.background = `linear-gradient(to right, var(--ember) 0%, var(--ember) ${pct}, var(--border) ${pct}, var(--border) 100%)`;
              },

              fnView: function (productId) {
                location.href = "/product/detail.do?productId=" + productId;
              },
              // 페이지 변경 시 호출할 공통 메서드
              changePage(page) {
                this.currentPage = page;

                // 화면 상단으로 부드럽게 이동 (선택 사항)
                window.scrollTo({
                  top: 0,
                  behavior: 'smooth' // 'smooth'를 넣으면 스르륵 올라가고, 빼면 바로 점프합니다.
                });
              },
              fetchBrandList() {
                let self = this;
                $.ajax({
                  url: "/product/brandList.dox", // 브랜드 목록 조회를 위한 URL
                  dataType: "json",
                  type: "POST",
                  data: {}, // 필요 시 조건 전달
                  success: function (data) {
                    if (data.result === 'success') {
                      self.brandList = data.list; // 서버에서 받은 리스트를 할당
                    }
                  },
                  error: function (err) {
                    console.error("브랜드 조회 실패:", err);
                  }
                });
              },
              clearBrands() {
                this.filter.brandId = []; // 배열을 비워서 다른 체크를 모두 해제
                this.fnSearch();
              },
              fnWishVue: function(e, productId) {
                e.stopPropagation();
                var self = this;
                var btn = e.currentTarget;
                $.ajax({
                    url     : '/user/wishlist/toggle.dox',
                    type    : 'POST',
                    data    : { productId: productId },
                    dataType: 'json',
                    success : function(res) {
                        if (res.result === 'success') {
                            btn.classList.toggle('on');
                            var isOn = btn.classList.contains('on');
                            // Vue wishedIds도 업데이트
                            var newSet = new Set(self.wishedIds);
                            if (isOn) newSet.add(productId);
                            else newSet.delete(productId);
                            self.wishedIds = newSet;
                            showToast(isOn ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
                        } else {
                            self.openConfirm('로그인이 필요합니다. 로그인하시겠습니까?', function() {
                                location.href = '/user/login.do';
                            }, '로그인하기');
                        }
                    }
                });
              },
              openConfirm(message, onOk, okText = '확인', cancelText = '취소') {
                  this.confirmModal.message = message;
                  this.confirmModal.onOk = onOk;
                  this.confirmModal.okText = okText;
                  this.confirmModal.cancelText = cancelText;
                  this.confirmModal.open = true;
              },

              confirmOk() {
                  if (typeof this.confirmModal.onOk === 'function') {
                      this.confirmModal.onOk();
                  }
                  this.confirmModal.open = false;
              },

              confirmCancel() {
                  this.confirmModal.open = false;
              },
              

          }, // methods

          mounted() {
            this.fetchCategory();   /* 부모 카테고리 pill 로드 */
            this.fetchBrandList();  /* 브랜드 목록 로드 */
        
            var self   = this;
            var params = new URLSearchParams(window.location.search);
            var catId  = params.get('categoryId');   /* 자식 카테고리 ID */
            var parId  = params.get('parentId');     /* 부모 카테고리 ID */
        
            if (catId && parId) {
                /* ── 메인에서 카테고리 아이콘 클릭해서 들어온 경우 ── */
                catId = parseInt(catId);
                parId = parseInt(parId);
        
                /* 부모 pill 선택 */
                self.currentCat = parId;
        
                /* 자식 카테고리 목록 로드 후 해당 자식 자동 선택 */
                $.ajax({
                    url     : '/category/childList.dox',
                    type    : 'POST',
                    dataType: 'json',
                    data    : { parentId: parId },
                    success : function(data) {
                        if (data.result === 'success') {
                            self.childCategory = data.list;
                            self.currentChild  = catId;   /* 세부 카테고리 자동 선택 */
                        }
                        self.fnList();
                    },
                    error: function() { self.fnList(); }
                });
        
            } else if (catId) {
                /* categoryId 만 있는 경우 — 부모 카테고리로 처리 */
                self.selectCategory(parseInt(catId));
        
            } else {
                /* 파라미터 없으면 전체 목록 */
                this.fnList();
            }

            

          },

        }).mount('#app');
      </script>
  </body>

  </html>