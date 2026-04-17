<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>제품 상세보기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="/css/product/product-detail.css">
</head>
<%@ include file="/WEB-INF/common/header.jsp" %>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <div class="wrap">

  <!-- breadcrumb -->
  <div class="crumb">
    <a href="/">홈</a> › 
    <a href="/category/${product.categoryId}">${product.categoryName}</a> › 
    <span>${product.productName}</span>
  </div>

  <div class="ptop">

    <!-- ================= LEFT: IMAGE ================= -->
    <div class="gallery">
      <div class="gm">
        <span class="gtag">${product.badge}</span>
        <div class="gem">⛺</div>
      </div>

      <div class="gthumbs">
        <c:forEach var="img" items="${product.images}">
          <div class="gth">📷</div>
        </c:forEach>
      </div>
    </div>

    <!-- ================= RIGHT: INFO ================= -->
    <div class="pinfo">

      <div class="pbrand">
      </div>

      <h1 class="ptitle"> <!-- 상품명 -->
        {{productId}}
      </h1>

      <div class="rrow">
        <div class="stars">★★★★★</div>
        <span>${product.rating}</span>
        <span>
          (리뷰 ${product.reviewCount}개 | 구매 ${product.buyCount}회)
        </span>
      </div>

      <!-- ===== PRICE (구매) ===== -->
      <div class="buy-only">
        <div class="pbox-buy">
          <div class="prow">
            <span class="pct">${product.discountRate}%</span>
            <span class="pnow">
              <fmt:formatNumber value="${product.salePrice}" type="number"/>원
            </span>
          </div>

          <div class="porig">
            <fmt:formatNumber value="${product.originalPrice}" type="number"/>원
          </div>
        </div>
      </div>

      <!-- ===== RENT PRICE ===== -->
      <div class="rent-only">
        <div class="pbox-rent">
          <div class="rent-num">
            <fmt:formatNumber value="${product.rentPrice}" type="number"/>원 / 박
          </div>
        </div>
      </div>

      <hr class="div">

      <!-- ================= OPTIONS ================= -->
      <div class="osec">
        <div class="olabel">색상</div>
        <div class="ochips">
          <c:forEach var="color" items="${product.colors}">
            <div class="chip">${color}</div>
          </c:forEach>
        </div>
      </div>

      <div class="osec">
        <div class="olabel">옵션</div>
        <div class="ochips">
          <c:forEach var="opt" items="${product.options}">
            <div class="chip">${opt.optionName}</div>
          </c:forEach>
        </div>
      </div>

      <!-- ================= ACTION ================= -->
      <div class="arow">
        <button class="bwish">🤍</button>

        <!-- 장바구니 -->
        <button class="bcart"
                onclick="addCart(${product.productId})">
          장바구니
        </button>

        <!-- 구매 -->
        <button class="bbuy"
                onclick="buyNow()">
          바로 구매
        </button>
      </div>

    </div>
  </div>

  <!-- ================= LOWER SECTIONS (삭제 안함) ================= -->

  <div class="rel">
    <h2 class="sectl">관련 상품</h2>

    <div class="rgrid">
      <c:forEach var="item" items="${relatedList}">
        <div class="pcard" onclick="fnView()">
          <div class="pcimg">📦</div>
          <div class="pcbody">
            <div class="pcbr">${item.brandName}</div>
            <div class="pcnm">${item.productName}</div>
            <div class="pcprice">
              <fmt:formatNumber value="${item.price}" type="number"/>원
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>

</div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (키 : 값)
                // list : [] 
                productId : "${productId}",
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    // 백엔드로 전달할 데이터
                };
                $.ajax({
                    url: "http://localhost:8080/product/default.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // 받은 데이터를 변수에 저장하세요
                        // self.list = data.list;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>