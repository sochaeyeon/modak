<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 상품상세</title>
    <link rel="stylesheet" href="/css/product/product-detail.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>
    <div id="app">
        <!-- ── 카테고리 pill 바 ── -->
        
            
    <div class="wrap">
        <div class="ptop">
            <div class="gallery">
                <div class="gm">
                    <div class="gem" id="gem">
                        <img v-if="mainImgUrl"
                            :src="mainImgUrl"
                            alt="상품 메인 이미지"
                            style="width:100%; height:100%; object-fit:contain;">
                        <img v-else
                            src="/img/product/default.jpg"
                            style="width:100%; height:100%; object-fit:cover;">
                    </div>
                </div>
                <!-- 썸네일 목록 -->
                <div class="gthumbs">
                    <div
                        v-for="(img, idx) in productImages"
                        :key="idx"
                        class="gth"
                        :class="{ on: mainImgUrl === img.imgUrl }"
                        @click="setMainImg(img.imgUrl)"
                    >
                        <img :src="img.imgUrl"
                            style="width:100%; height:100%; object-fit:cover; display:block;">
                    </div>
                </div>
            </div>

            <!-- INFO -->
            <div class="pinfo">
            <div class="pbrand">{{ productInfo.brandName }}</div>
            <h1 class="ptitle">{{ productInfo.productName }}</h1>
            <div class="rrow">
                <div class="stars"><span class="st" style="color:#ddd">★★★★★</span></div>
                <span style="font-size:12px;color:var(--muted)">
                    <a href="#" style="color:var(--orange);text-decoration:none">(리뷰 {{ reviewList.length }}개)</a>
                    | 구매·대여 {{ orderCount }}회
                </span>
            </div>

            <!-- MODE TOGGLE 상품타입이 대여 / 구매에 따라서 둘중하나 비활성 -->
            <div class="mtog">
                <button class="mbtn on" id="mb-buy" 
                    onclick="setMode('buy')"
                    :disabled="productType === 'RENTAL'"
                    :style="productType === 'RENTAL' ? 'opacity:0.3; cursor:not-allowed;' : ''"
                    :title="productType === 'RENTAL' ? '이 상품은 대여만 가능한 상품입니다' : ''">
                    🛒 구매하기
                </button>
                <button class="mbtn" id="mb-rent" 
                    onclick="setMode('rent')"
                    :disabled="productType === 'PURCHASE'"
                    :style="productType === 'PURCHASE' ? 'opacity:0.3; cursor:not-allowed;' : ''"
                    :title="productType === 'PURCHASE' ? '이 상품은 구매만 가능한 상품입니다' : ''">
                    📅 대여하기
                </button>
            </div>

            <!-- BUY PRICE -->
            <div class="buy-only">
                <div class="pbox-buy">
                <div class="prow"><!--<span class="pct">10%</span>--><span class="pnow">{{ formatPrice(productInfo.price) }}</span></div>
                <div class="porig">23,150,000원</div>
                <div class="pnote">쿠폰 적용시 최대 10% 할인</div>
                </div>
            </div>

            <!-- RENT PRICE -->
            <div class="rent-only">
                <div class="pbox-rent">
                <div class="prow"><span class="rent-per">1박당</span><span class="rent-num">{{ formatPrice(productInfo.price) }}</span><span class="rent-unit"> / 박</span></div>
                <div style="font-size:12px;color:var(--muted);margin-top:4px">3박 이상 <strong style="color:var(--blue)">10% 할인</strong> · 7박 이상 <strong style="color:var(--blue)">20% 할인</strong></div>
                <div style="font-size:12px;color:var(--muted);margin-top:3px">⏱ 반납일 오전 10시까지 · 연체 시 1일 12,000원</div>
                </div>
            </div>

            <hr class="div">

            <!-- 색상 (공통) -->
            <div class="osec">
                <div class="olabel">색상</div>
                <div class="ochips">
                <div class="chip on" onclick="pickChip(this,'col')">블랙</div>
                <div class="chip" onclick="pickChip(this,'col')">오렌지</div>
                <div class="chip" onclick="pickChip(this,'col')">그린</div>
                <div class="chip off">화이트 (품절)</div>
                </div>
            </div>

            <!-- BUY OPTIONS -->
            <div class="buy-only">
                <div class="osec">
                <div class="olabel">사이즈</div>
                <div class="ochips">
                    <div class="chip on" onclick="pickChip(this,'opt')">텐트 단품</div>
                    <div class="chip" onclick="pickChip(this,'opt')">텐트 + 풋프린트</div>
                    <div class="chip" onclick="pickChip(this,'opt')">텐트 + 스노우 스커트</div>
                </div>
                </div>
            <div class="osec">
                <div class="olabel">
                    수량
                    <span v-if="remainQty > 0" style="color:var(--green);font-weight:600;">
                        {{ remainQty }}개 남음
                    </span>
                    <span v-else style="color:var(--red);font-weight:600;">
                        {{ productType === 'RENTAL' ? '재고 없음' : '품절' }}
                    </span>
                </div>
                <div class="qrow">
                    <button class="qbtn" @click="chgQty(-1)">−</button>
                    <input class="qinp" id="qinp" type="number" v-model="qty" min="1" :max="displayQty" readonly>
                    <button class="qbtn" @click="chgQty(1)">+</button>
                </div>
            </div>
                <div class="selbox">
                    <span style="font-size:13px">블랙 / 텐트 단품 / <span id="qdsp">1</span>개</span>
                    <span style="font-size:15px;font-weight:700" id="bprice">{{ totalPriceFormatted }}</span>
                </div>
                <div class="trow">
                    <span style="font-size:13px;color:var(--muted)">총 상품금액</span>
                    <span class="tprice" id="btotal">{{ totalPriceFormatted }}</span>
                </div>
                <div class="arow">
                    <button class="bwish" id="wb1"
                        :class="{ on: isWished }"
                        @click="fnWish($event)">
                        {{ isWished ? '❤️' : '🤍' }}
                    </button>
                    <button class="bcart">장바구니 담기</button>
                    <button class="bbuy">바로 구매하기</button>
                </div>
            </div>

            <!-- RENT CALENDAR -->
            <div class="rent-only" style="max-width: 700px;">
                <div class="cal-nav">
                    <button @click="changeMonth(-1)">‹</button>
                    <h2 style="font-weight: bold;">{{ currentYear }}년 {{ currentMonth + 1 }}월</h2>
                    <button @click="changeMonth(1)">›</button>
                </div>

                <div class="cal-grid">
                    <div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">{{w}}</div>
                    <div v-for="(day, idx) in calendarDays" :key="idx" :class="getDayClass(day)"
                        @click="onDayClick(day)">
                        <span v-if="day">{{ day.date }}</span>
                    </div>
                </div>

                <div class="booking-summary">
                    <div v-if="startDate && endDate">
                        <p style="font-size:0.9rem; color:#888; margin-bottom:5px;">{{ startDate }} ~ {{ endDate }} ({{ rentDays }}박)</p>
                        <div style="font-size:1.8rem; font-weight:bold; color:var(--orange);">
                            {{ (productInfo.price * rentDays).toLocaleString() }}원
                        </div>
                    </div>
                    <div v-else-if="startDate" style="color:var(--orange); font-weight:bold;">종료일을 선택해주세요.</div>
                    <div v-else style="color:#bbb;">캘린더에서 예약 날짜를 선택해주세요.</div>

                    <button v-if="startDate && endDate" class="btn-rent" @click="fnRent">대여 신청하기</button>
                </div>
                <!-- ✅ 대여 위시 버튼 -->
                <div class="arow" style="margin-top:10px;">
                    <button class="bwish" id="wb2"
                        :class="{ on: isWished }"
                        @click="fnWish($event)">
                        {{ isWished ? '❤️' : '🤍' }}
                    </button>
                </div>
            </div>
            

            <!-- DELIVERY -->
            <div class="delbox">
                <div class="drow buy-only"><span class="dkey">배송</span><span class="dv"><strong>무료배송</strong> · 오늘 주문 시 내일 도착</span></div>
                <div class="drow rent-only"><span class="dkey">수령/반납</span><span class="dv"><strong>무료 배송</strong> 또는 매장 직수령 · 반납일 오전 10시까지</span></div>
                <div class="drow"><span class="dkey">반품</span><span class="dv">구매 후 30일 이내 무료 반품</span></div>
                <div class="drow"><span class="dkey">적립</span><span class="dv buy-only"><strong>420포인트</strong> 적립</span><span class="dv rent-only">대여 확정 시 <strong>80포인트/박</strong> 적립</span></div>
            </div>
            </div>
        </div>

        <!-- TABS -->
        <div>
            <div class="tnav">
                <button class="tbtn on" @click="stab('det', $event)">상품 정보</button>
                <button class="tbtn" @click="stab('rev', $event)">리뷰 ({{ reviewList.length }})</button>
                <button class="tbtn" @click="stab('qna', $event)">Q&A (12)</button>
                <button class="tbtn" @click="stab('shp', $event)">배송/대여 안내</button>
            </div>
            <div class="tcont">
            <div class="tpane on" id="tp-det">
                <h3 style="font-size:15px;font-weight:700;margin-bottom:12px">🏕️ 제품 특징</h3>
                <div class="flist">
                <div class="fi"><div class="fic">⚡</div><div class="fit"><h4>초경량 설계</h4><p>총 중량 1.38kg, 장거리 백패킹 최적화.</p></div></div>
                <div class="fi"><div class="fic">💧</div><div class="fit"><h4>방수 성능</h4><p>내수압 3,000mm 이상 고성능 방수 코팅.</p></div></div>
                <div class="fi"><div class="fic">🌬️</div><div class="fit"><h4>통기성 이중 구조</h4><p>결로 최소화, 쾌적한 내부 유지.</p></div></div>
                <div class="fi"><div class="fic">🛠️</div><div class="fit"><h4>간편 설치</h4><p>색상 구분 폴+클립 시스템, 10분 내 설치.</p></div></div>
                </div>

                <hr class="div" style="margin:18px 0">
                <h3 style="font-size:15px;font-weight:700;margin-bottom:12px">📋 상품 스펙</h3>
                <table class="spec">
                    <tr><th>브랜드</th><td>헬리녹스 (Helinox)</td></tr>
                    <tr><th>수용 인원</th><td>1인용</td></tr>
                    <tr><th>전개 사이즈</th><td>220 × 90 × 105 cm</td></tr>
                    <tr><th>총 중량</th><td>1,380g</td></tr>
                    <tr><th>소재 (외피)</th><td>20D 나일론 립스탑 (내수압 3,000mm)</td></tr>
                    <tr><th>폴 소재</th><td>DAC 알루미늄 합금</td></tr>
                    <tr><th>원산지</th><td>대한민국</td></tr>
                </table>
            </div>

            <div class="tpane" id="tp-rev">
                <!-- 별점 요약 (기존 유지) -->
                <div class="rsum2">
                    <div class="rbig">
                        <div class="rn">4.3</div>
                        <div class="stars" style="justify-content:center;display:flex;margin:5px 0">
                            <span class="st">★</span><span class="st">★</span><span class="st">★</span>
                            <span class="st">★</span><span class="st" style="color:#ddd">★</span>
                        </div>
                        <div class="ro">{{ reviewList.length }}개 리뷰</div>
                    </div>
                    <div class="rbars">
                        <div class="bbar"><span class="blbl">5점</span><div class="btrk"><div class="bfil" style="width:55%"></div></div><span class="bcnt">65</span></div>
                        <div class="bbar"><span class="blbl">4점</span><div class="btrk"><div class="bfil" style="width:25%"></div></div><span class="bcnt">30</span></div>
                        <div class="bbar"><span class="blbl">3점</span><div class="btrk"><div class="bfil" style="width:12%"></div></div><span class="bcnt">14</span></div>
                        <div class="bbar"><span class="blbl">2점</span><div class="btrk"><div class="bfil" style="width:5%"></div></div><span class="bcnt">6</span></div>
                        <div class="bbar"><span class="blbl">1점</span><div class="btrk"><div class="bfil" style="width:3%"></div></div><span class="bcnt">4</span></div>
                    </div>
                </div>

                <!-- 리뷰 없을 때 -->
                <div v-if="reviewList.length === 0"
                    style="text-align:center;padding:36px 0;color:var(--muted);font-size:14px">
                    아직 작성된 리뷰가 없습니다.
                </div>

                <!-- 리뷰 목록 -->
                <div class="rcard" v-for="review in reviewList" :key="review.reviewId">
                    <div class="rhead">
                        <div>
                            <div class="rname">{{ review.userId }}</div>
                            <div class="stars" style="display:flex;gap:1px;margin-top:3px">
                                <span v-for="(star, i) in getStars(review.rating)" :key="i"
                                    class="st" :style="{ fontSize:'12px', color: star === '★' ? '' : '#ddd' }">
                                    {{ star }}
                                </span>
                            </div>
                        </div>
                        <div class="rdate">{{ review.createdAt }}</div>
                    </div>
                    <div class="rtext" style="font-weight:600;margin-bottom:4px">{{ review.title }}</div>
                    <div class="rtext">{{ review.content }}</div>
                    <div v-if="review.imageUrl" style="margin:10px 0;">
                            <img :src="review.imageUrl"
                                style="width:80px;height:80px;object-fit:cover;border-radius:8px;cursor:pointer;"
                                @click="openImg(review.imageUrl)">
                        </div>

                        <div class="rhelprow">
                            <span>도움이 됐나요?</span>
                            <button class="hbtn">👍 도움돼요</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tpane" id="tp-qna">
                <div style="text-align:center;padding:36px 0;color:var(--muted)">
                <div style="font-size:36px;margin-bottom:10px">💬</div>
                <p style="font-size:15px;font-weight:500;margin-bottom:4px">Q&A가 12개 있습니다</p>
                <p style="font-size:13px">궁금한 점을 남겨주세요. 평균 24시간 내 답변합니다.</p>
                <button style="margin-top:14px;background:var(--orange);color:#fff;border:none;border-radius:8px;padding:10px 24px;font-size:14px;cursor:pointer;font-family:inherit;font-weight:500">문의하기</button>
                </div>
            </div>
            <div class="tpane" id="tp-shp">
                <table class="spec">
                <tr><th>배송 방법</th><td>택배 (CJ 대한통운) 또는 매장 직수령</td></tr>
                <tr><th>배송비</th><td>무료배송 (제주·도서산간 +3,000원)</td></tr>
                <tr><th>대여 반납</th><td>반납일 오전 10시까지 · 택배 반납 가능</td></tr>
                <tr><th>연체 요금</th><td>1일당 12,000원 (대여가의 150%)</td></tr>
                <tr><th>파손/분실</th><td>수리 비용 또는 정가의 80% 배상</td></tr>
                <tr><th>반품/교환</th><td>수령 후 30일 이내 (구매 상품)</td></tr>
                </table>
            </div>
            </div>
        </div>

        <!-- RELATED -->
        <div class="rel" v-if="relatedList.length > 0">
            <h2 class="sectl">같은 카테고리 상품</h2>
            <div class="rgrid">
                <div class="pcard"
                    v-for="item in relatedList"
                    :key="item.productId"
                    @click="goDetail(item.productId)">
                    <div class="pcimg">
                        <img v-if="item.imgUrl"
                            :src="item.imgUrl"
                            style="width:100%;height:100%;object-fit:cover;">
                        <span v-else style="font-size:48px;">🏕️</span>
                    </div>
                    <div class="pcbody">
                        <div class="pcbr">{{ item.brandName }}</div>
                        <div class="pcnm">{{ item.productName }}</div>
                        <div class="pcprice">{{ formatPrice(item.price) }}</div>
                        <div class="pcacts">
                            <button class="pca1"
                                    v-if="item.productType === 'RENTAL' || item.productType === 'BOTH'"
                                    @click.stop="goDetail(item.productId, 'rent')">
                                대여
                            </button>
                            <button class="pca2"
                                    v-if="item.productType === 'PURCHASE' || item.productType === 'BOTH'"
                                    @click.stop="goDetail(item.productId, 'buy')">
                                구매
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%@ include file="/WEB-INF/common/footer.jsp" %>
</div>
</body>
</html>

<script>
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
    // gallery
    function setGem(e,el){document.getElementById('gem').textContent=e;document.querySelectorAll('.gth').forEach(t=>t.classList.remove('on'));el.classList.add('on');}

    // mode
    function setMode(m){
        const r=m==='rent';
        document.getElementById('mb-buy').classList.toggle('on',!r);
        document.getElementById('mb-rent').classList.toggle('on',r);
        document.body.classList.toggle('rent',r);
    }

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                productId: '${productId}', // 서버에서 전달받은 상품 번호 (JSP 방식)
                productInfo: {},
                productImages: [],         // DB에서 가져온 전체 이미지 리스트
                mainImgUrl: '',            // 메인이미지
                reviewList: [],
                orderCount: 0, // 주문 카운트

                productType: '', // 대여/구매 타입
                availableQty: 0, // 대여용 AVAILABLE_QTY 
                totalQty: 0, // 구매용 TOTAL_QTY
                qty: 1,  // 수량 ← 추가
                // 캘린더용
                currentYear: new Date().getFullYear(),
                currentMonth: new Date().getMonth(),
                rentedRanges: [],
                startDate: null,
                endDate: null,
                isWished: false, // 위시 여부
                relatedList: [], // 하단 같은 카테고리 상품 추천
            };
        },
        computed: {
            // 현재 타입에 따라 표시할 재고
            displayQty() {
                if (this.productType === 'PURCHASE') return this.totalQty;
                return this.availableQty;
            },
            // 재고에서 선택 수량 뺀 남은 재고
            remainQty() {
                return this.displayQty - this.qty;
            },
            totalPrice() {
                return (this.productInfo.price || 0) * this.qty;
            },
            totalPriceFormatted() {
                return this.totalPrice.toLocaleString('ko-KR') + '원';
            },
            calendarDays() {
                const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
                const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
                const days = [];
                for (let i = 0; i < firstDay; i++) days.push(null);
                for (let d = 1; d <= lastDate; d++) {
                    const dateObj = new Date(this.currentYear, this.currentMonth, d);
                    const fullStr = this.formatDateCal(dateObj);
                    days.push({
                        date: d,
                        full: fullStr,
                        isRented: this.checkIsRented(fullStr),
                        isPast: dateObj < new Date().setHours(0,0,0,0)
                    });
                }
                return days;
            },
            rentDays() {
                if (!this.startDate || !this.endDate) return 0;
                return Math.ceil((new Date(this.endDate) - new Date(this.startDate)) / (1000 * 60 * 60 * 24));
            }
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnDetail: function () {
                let self = this;
                let param = { productId: self.productId };
                $.ajax({
                    url: "/product/detail.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.productInfo = data.info;
                        self.orderCount = data.orderCount || 0; // 오더 카운트
                        self.availableQty = data.info.availableQty || 0;  // 대여용
                        self.totalQty     = data.info.totalQty     || 0;  // 구매용 
                        self.fetchRelatedProducts(data.info.categoryId); // 하단 카테고리 상품 추가
                        // ✅ productType 저장 후 자동 탭 전환
                        self.productType = data.info.productType || '';
                        if (self.productType === 'RENTAL') {
                            setMode('rent');
                        } else if (self.productType === 'PURCHASE') {
                            setMode('buy');
                        }
                        // ✅ 위시 상태 초기화
                        $.ajax({
                            url: '/user/wishlist/list.dox',
                            type: 'POST',
                            dataType: 'json',
                            success: function(wRes) {
                                if (wRes.result === 'success' && wRes.list) {
                                    var wishedIds = wRes.list.map(function(w){ return w.productId; });
                                    self.isWished = wishedIds.indexOf(parseInt(self.productId)) !== -1;
                                }
                            }
                        });
                    }
                });
            },
            fetchProductImages: function () {
                let self = this;
                $.ajax({
                    url: '/product/detail.dox',
                    type: 'POST',
                    data: { productId: self.productId },
                    success: function (data) {
                        const imageList = data.img || [];
                        self.productImages = imageList;

                        if (imageList.length > 0) {
                            // mainImg === 'Y' 인 이미지 우선, 없으면 첫 번째
                            const main = imageList.find(i => i.mainImg === 'Y');
                            self.mainImgUrl = main ? main.imgUrl : imageList[0].imgUrl;
                        } else {
                            self.mainImgUrl = '/img/product/default.jpg';
                        }
                    },
                    error: function (err) {
                        console.error('이미지 로드 실패:', err);
                        self.productImages = [];
                        self.mainImgUrl = '/img/product/default.jpg';
                    }
                });
            },
            // 2. 썸네일 클릭 시 메인 이미지 변경
            setMainImg(imgUrl) {
                let self = this;
                self.mainImgUrl = imgUrl;
            },
            fnGetReviews: function () {
                let self = this;
                let param = { 
                    productId: self.productId,
                    page : 1,
                    pageSize : 10
                };
                $.ajax({
                    url: '/review/list.dox',
                    dataType: 'json',
                    type: 'POST',
                    data: param,
                    success: function (data) {
                        self.reviewList = data.list || [];
                        console.log(self.reviewList);
                    
                    },
                    error: function (err) {
                        console.error('리뷰 로드 실패:', err);
                        console.error('status:', err.status);  
                        console.error('responseText:', err.responseText); 
                        self.reviewList = [];
                    }
                });
            },
            // 별점 배열 반환 (★/☆ 구분용)
            getStars: function (rating) {
                return Array.from({ length: 5 }, (_, i) => i < rating ? '★' : '☆');
            },
            // 날짜 포맷 (2026-04-16 20:10:00 → 2026.04.16)
            formatDate: function (dateStr) {
                if (!dateStr) return '';
                return dateStr.slice(0, 10).replace(/-/g, '.');
            },
            stab: function(n, event) {
                const el = event.currentTarget;
                document.querySelectorAll('.tbtn').forEach(b => b.classList.remove('on'));
                document.querySelectorAll('.tpane').forEach(p => p.classList.remove('on'));
                el.classList.add('on');
                document.getElementById('tp-' + n).classList.add('on');

                // 리뷰 탭 클릭 시 리뷰 불러오기
                if (n === 'rev') {
                    this.fnGetReviews();
                }
            },
            openImg: function(url) {
                window.open(url, '_blank');
            },
            formatPrice: function(price) {
                if (!price) return '0원';
                return Number(price).toLocaleString('ko-KR') + '원';
            },
            chgQty: function(d) {
                const max = this.displayQty;   // 원본 재고
                const next = this.qty + d;

                if (next < 1) return;          // 최소 1개
                if (next > max) {              // 재고 초과 방지
                    alert('재고가 부족합니다. (최대 ' + max + '개)');
                    return;
                }

                this.qty = next;               // qty만 변경, 재고는 건드리지 않음
                // remainQty = displayQty - qty 가 자동으로 반영됨 ✅
            },
            //캘린더
            formatDateCal(dateVal) {
                let d = new Date(dateVal);
                return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
            },
            checkIsRented(targetStr) {
                if (!this.rentedRanges || this.rentedRanges.length === 0) return false;
                return this.rentedRanges.some(range => {
                    const s = this.formatDateCal(range.startDate || range.START_DATE);
                    const e = this.formatDateCal(range.returnDate || range.RETURN_DATE);
                    return targetStr >= s && targetStr <= e;
                });
            },
            getDayClass(day) {
                if (!day) return 'cal-day empty';
                if (day.isRented) return 'cal-day rented';
                if (day.isPast) return 'cal-day past';
                if (day.full === this.startDate || day.full === this.endDate) return 'cal-day selected';
                if (this.startDate && this.endDate && day.full > this.startDate && day.full < this.endDate) return 'cal-day in-range';
                return 'cal-day available';
            },
            onDayClick(day) {
                if (!day || day.isPast || day.isRented) return;
                if (!this.startDate || (this.startDate && this.endDate)) {
                    this.startDate = day.full; this.endDate = null;
                } else {
                    if (day.full < this.startDate) this.startDate = day.full;
                    else if (day.full === this.startDate) this.startDate = null;
                    else this.endDate = day.full;
                }
            },
            changeMonth(diff) {
                const newDate = new Date(this.currentYear, this.currentMonth + diff, 1);
                this.currentYear = newDate.getFullYear();
                this.currentMonth = newDate.getMonth();
            },
            fetchRentedDates() {
                let self = this;
                $.ajax({
                    url: '/rental/calendar/dates.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ itemId: self.productId }),
                    success: function(res) {
                        if (res.result === 'success') {
                            self.rentedRanges = res.rentedList;
                        }
                    }
                });
            },
            fnRent() {
                if (!confirm("대여 신청하시겠습니까?")) return;
                let self = this;
                $.ajax({
                    url: '/rental/apply.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ itemId: self.productId, startDate: self.startDate, endDate: self.endDate }),
                    success: function(res) {
                        if (res.result === 'success') {
                            alert('신청 완료!');
                            location.reload();
                        }
                    }
                });
            },
            fnWish: function(e) {
                e.stopPropagation();
                var self = this;
                $.ajax({
                    url: '/user/wishlist/toggle.dox',
                    type: 'POST',
                    data: { productId: self.productId },
                    dataType: 'json',
                    success: function(res) {
                        if (res.result === 'success') {
                            self.isWished = !self.isWished;
                            showToast(self.isWished ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
                        } else {
                            alert('로그인이 필요합니다');
                            setTimeout(function(){ location.href = '/user/login.do'; }, 1200);
                        }
                    }
                });
            },
            fetchRelatedProducts: function(categoryId) {
                let self = this;
                $.ajax({
                    url: '/product/related.dox',
                    type: 'POST',
                    data: { categoryId: categoryId, productId: self.productId },
                    dataType: 'json',
                    success: function(res) {
                        if (res.result === 'success') {
                            self.relatedList = res.list || [];
                        }
                    }
                });
            },
            goDetail: function(productId, mode) {
                let url = '/product/detail.do?productId=' + productId;
                if (mode) url += '&mode=' + mode;
                location.href = url;
            },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnDetail();
            self.fetchProductImages();
            self.fetchRentedDates();
        }
    });

    app.mount('#app');
</script>