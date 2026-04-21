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
    <div class="cat-bar">
        <div class="cat-bar-inner">
            
        </div>
    </div>
<div class="wrap">
    <div class="ptop">
        <!-- GALLERY -->
        <div class="gallery">
            <div class="gm">
                <span class="gtag" v-if="productImages.find(i => i.fileName === mainImgUrl)?.isMain === 'Y'">베스트</span>
                
                <div class="gem" id="gem">
                    <img v-if="mainImgUrl" 
                        :src="'/img/product/' + mainImgUrl" 
                        alt="상품 메인 이미지" 
                        style="width:100%; height:100%; object-fit:contain;"> <img v-else src="/img/product/default.jpg" style="width:100%; height:100%; object-fit:cover;">
                </div>
            </div>
            <!-- 메인아닌 이미지들 -->
            <div class="gthumbs">
                <div 
                    v-for="(img, idx) in productImages" 
                    :key="idx"
                    class="gth" 
                    :class="{ on: mainImgUrl === img.imgUrl }" 
                    @click="setMainImg(img.imgUrl)"
                >
                    <img :src="'/img/product/' + img.imgUrl" 
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
            <span style="font-size:12px;color:var(--muted)"><a href="#" style="color:var(--orange);text-decoration:none">(리뷰 119개)</a> | 구매·대여 238회</span>
        </div>

        <!-- MODE TOGGLE -->
        <div class="mtog">
            <button class="mbtn on" id="mb-buy" onclick="setMode('buy')">🛒 구매하기</button>
            <button class="mbtn" id="mb-rent" onclick="setMode('rent')">📅 대여하기</button>
        </div>

        <!-- BUY PRICE -->
        <div class="buy-only">
            <div class="pbox-buy">
            <div class="prow"><span class="pct">10%</span><span class="pnow">{{productInfo.price}}</span></div>
            <div class="porig">50,000원</div>
            <div class="pnote">쿠폰 적용시 최대 10% 할인</div>
            </div>
        </div>

        <!-- RENT PRICE -->
        <div class="rent-only">
            <div class="pbox-rent">
            <div class="prow"><span class="rent-per">1박당</span><span class="rent-num">8,000원</span><span class="rent-unit"> / 박</span></div>
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
            <div class="olabel">수량</div>
            <div class="qrow">
                <button class="qbtn" onclick="chgQ(-1)">−</button>
                <input class="qinp" id="qinp" type="number" value="1" min="1" max="99" readonly>
                <button class="qbtn" onclick="chgQ(1)">+</button>
            </div>
            </div>
            <div class="selbox">
            <span style="font-size:13px">블랙 / 텐트 단품 / <span id="qdsp">1</span>개</span>
            <span style="font-size:15px;font-weight:700" id="bprice">42,000원</span>
            </div>
            <div class="trow">
            <span style="font-size:13px;color:var(--muted)">총 상품금액</span>
            <span class="tprice" id="btotal">42,000원</span>
            </div>
            <div class="arow">
            <button class="bwish" id="wb1" onclick="togWish()">🤍</button>
            <button class="bcart">장바구니 담기</button>
            <button class="bbuy">바로 구매하기</button>
            </div>
        </div>

        <!-- RENT CALENDAR -->
        <div class="rent-only">
            <div class="calsec">
            <div class="olabel">
                📅 대여 날짜 선택
                <span style="font-size:11px;color:var(--muted);font-weight:400">시작일 → 반납일 순서로 클릭</span>
            </div>

            <div class="calwrap">
                <div class="calhead">
                <button class="cnav" onclick="prevMo()">‹</button>
                <span class="cmonth" id="cmlbl"></span>
                <button class="cnav" onclick="nextMo()">›</button>
                </div>
                <div class="calgrid">
                <div class="calwds">
                    <div class="cwd" style="color:var(--red)">일</div>
                    <div class="cwd">월</div><div class="cwd">화</div><div class="cwd">수</div><div class="cwd">목</div><div class="cwd">금</div>
                    <div class="cwd" style="color:var(--blue)">토</div>
                </div>
                <div class="caldays" id="cdays"></div>
                </div>
                <div class="leg">
                <div class="litem"><div class="ldot" style="background:var(--green)"></div> 여유 (5개↑)</div>
                <div class="litem"><div class="ldot" style="background:var(--yellow)"></div> 적음 (1~4개)</div>
                <div class="litem"><div class="ldot" style="background:#ddd"></div> 재고 없음</div>
                <div class="litem" style="margin-left:auto;font-size:11px;color:var(--muted)">● 오늘</div>
                </div>
            </div>

            <!-- 날짜 표시 -->
            <div class="ddisp">
                <div class="dbox" id="ds">
                <div class="dlbl">📦 대여 시작일</div>
                <div class="dval" id="dsv" style="font-size:13px;color:var(--muted)">날짜를 선택하세요</div>
                </div>
                <div class="darr">→</div>
                <div class="dbox" id="de">
                <div class="dlbl">🏠 반납일</div>
                <div class="dval" id="dev" style="font-size:13px;color:var(--muted)">날짜를 선택하세요</div>
                </div>
            </div>

            <!-- 재고 상태 -->
            <div id="stockEl"></div>

            <!-- 대여 요금 요약 -->
            <div class="rsum" id="rsumEl">
                <div class="rsrow"><span class="rskey">대여 기간</span><span class="rsval" id="rsDays">—</span></div>
                <div class="rsrow"><span class="rskey">기본 요금</span><span class="rsval" id="rsBase">—</span></div>
                <div class="rsrow" id="rsDiscRow" style="display:none"><span class="rskey" id="rsDiscLbl">할인</span><span class="rsval" style="color:var(--blue)" id="rsDsc">—</span></div>
                <div class="rsrow"><span class="rskey" style="font-weight:600">최종 대여 금액</span><span class="rsval rstotal" id="rsTotal">—</span></div>
            </div>
            </div>

            <div class="arow">
            <button class="bwish" id="wb2" onclick="">🤍</button>
            <button class="brent" id="rentBtn" disabled>날짜를 선택해 주세요</button>
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
        <button class="tbtn on" onclick="stab('det',this)">상품 정보</button>
        <button class="tbtn" onclick="stab('rev',this)">리뷰 (119)</button>
        <button class="tbtn" onclick="stab('qna',this)">Q&amp;A (12)</button>
        <button class="tbtn" onclick="stab('shp',this)">배송/대여 안내</button>
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
            <div class="rsum2">
            <div class="rbig">
                <div class="rn">4.3</div>
                <div class="stars" style="justify-content:center;display:flex;margin:5px 0"><span class="st">★</span><span class="st">★</span><span class="st">★</span><span class="st">★</span><span class="st" style="color:#ddd">★</span></div>
                <div class="ro">119개 리뷰</div>
            </div>
            <div class="rbars">
                <div class="bbar"><span class="blbl">5점</span><div class="btrk"><div class="bfil" style="width:55%"></div></div><span class="bcnt">65</span></div>
                <div class="bbar"><span class="blbl">4점</span><div class="btrk"><div class="bfil" style="width:25%"></div></div><span class="bcnt">30</span></div>
                <div class="bbar"><span class="blbl">3점</span><div class="btrk"><div class="bfil" style="width:12%"></div></div><span class="bcnt">14</span></div>
                <div class="bbar"><span class="blbl">2점</span><div class="btrk"><div class="bfil" style="width:5%"></div></div><span class="bcnt">6</span></div>
                <div class="bbar"><span class="blbl">1점</span><div class="btrk"><div class="bfil" style="width:3%"></div></div><span class="bcnt">4</span></div>
            </div>
            </div>
            <div class="rcard">
            <div class="rhead"><div><div class="rname">hyun****</div><div class="stars" style="display:flex;gap:1px;margin-top:3px"><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span></div></div><div class="rdate">2025.11.12</div></div>
            <div class="rtext">백패킹 갈 때마다 챙기는 텐트입니다. 무게가 정말 가볍고 설치가 쉬워요. 강원도 한겨울에도 결로가 거의 없어서 놀랐습니다!</div>
            <div class="rprod">블랙 / 구매</div>
            <div class="rhelprow"><span>도움이 됐나요?</span><button class="hbtn">👍 도움돼요 (23)</button></div>
            </div>
            <div class="rcard">
            <div class="rhead"><div><div class="rname">park****</div><div class="stars" style="display:flex;gap:1px;margin-top:3px"><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span class="st" style="font-size:12px">★</span><span style="font-size:12px;color:#ddd">★</span></div></div><div class="rdate">2025.10.28</div></div>
            <div class="rtext">대여로 먼저 써보고 너무 좋아서 구매했습니다. 방수 성능이 탁월해요!</div>
            <div class="rprod">오렌지 / 대여 후 구매</div>
            <div class="rhelprow"><span>도움이 됐나요?</span><button class="hbtn">👍 도움돼요 (17)</button></div>
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
    <div class="rel">
        <h2 class="sectl">함께 대여하면 좋은 상품</h2>
        <div class="rgrid">
        <div class="pcard"><div class="pcimg"><span class="pcbdg">베스트</span>🏕️</div><div class="pcbody"><div class="pcbr">스노우피크</div><div class="pcnm">스노우피크 랜드록 2024</div><div class="pcs"><span class="s">★</span> 4.8 (176)</div><div class="pcprice">35,000원</div><div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div></div></div>
        <div class="pcard"><div class="pcimg">🔦</div><div class="pcbody"><div class="pcbr">블랙다이아몬드</div><div class="pcnm">캠프 나이오 리액터 헤드랜턴</div><div class="pcs"><span class="s">★</span> 4.7 (88)</div><div class="pcprice">3,500원</div><div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div></div></div>
        <div class="pcard"><div class="pcimg"><span class="pcbdg" style="background:#3ab5e0">NEW</span>🎒</div><div class="pcbody"><div class="pcbr">그레고리</div><div class="pcnm">그레고리 발토로 75L</div><div class="pcs"><span class="s">★</span> 4.5 (71)</div><div class="pcprice">15,000원</div><div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div></div></div>
        <div class="pcard"><div class="pcimg">🔥</div><div class="pcbody"><div class="pcbr">MSR</div><div class="pcnm">MSR 드래곤플라이 멀티연료 버너</div><div class="pcs"><span class="s">★</span> 4.5 (93)</div><div class="pcprice">9,000원</div><div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div></div></div>
        </div>
    </div>
    </div>
    </div>
<%@ include file="/WEB-INF/common/footer.jsp" %>
</div>
</body>
</html>

<script>
    
    // gallery
    function setGem(e,el){document.getElementById('gem').textContent=e;document.querySelectorAll('.gth').forEach(t=>t.classList.remove('on'));el.classList.add('on');}

    // mode
    function setMode(m){
    const r=m==='rent';
    document.getElementById('mb-buy').classList.toggle('on',!r);
    document.getElementById('mb-rent').classList.toggle('on',r);
    document.body.classList.toggle('rent',r);
    }

    // chips
    function pickChip(el,g){el.closest('.ochips').querySelectorAll('.chip:not(.off)').forEach(c=>c.classList.remove('on'));el.classList.add('on');updBuy();}

    // buy qty
    //let qty=1;const BP=42000;
    //function chgQ(d){qty=Math.max(1,Math.min(99,qty+d));document.getElementById('qinp').value=qty;document.getElementById('qdsp').textContent=qty;updBuy();}
    //function updBuy(){const t=(BP*qty).toLocaleString('ko-KR')+'원';document.getElementById('bprice').textContent=t;document.getElementById('btotal').textContent=t;}

    
    // tabs
    function stab(n,el){document.querySelectorAll('.tbtn').forEach(b=>b.classList.remove('on'));document.querySelectorAll('.tpane').forEach(p=>p.classList.remove('on'));el.classList.add('on');document.getElementById('tp-'+n).classList.add('on');}

    

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                productId: '${productId}', // 서버에서 전달받은 상품 번호 (JSP 방식)
                productInfo: {},
                productImages: [],         // DB에서 가져온 전체 이미지 리스트
                mainImgUrl: '',            // 메인이미지
                categoryId: self.currentCat
            };
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
                    }
                });
            },
            formattedDate() {
                return String(this.product.day).padStart(2, '0');
            },
            fetchProductImages() {
                let self = this;
                $.ajax({
                    url: "/product/detail.dox", 
                    type: "POST",
                    data: { productId: self.productId },
                    success: function(data) {
                        const imageList = data.img || [];
                        self.productImages = data.img;

                        // 리스트가 있을 때만 메인 이미지 초기화
                        if (imageList.length > 0) {
                            // 1. IS_MAIN이 'Y'인 이미지를 먼저 찾습니다. (필드명 mainImg 확인!)
                            const main = imageList.find(i => i.mainImg === 'Y');
                            
                            // 2. 메인이 있으면 그걸 쓰고, 없으면 0번째 이미지를 씁니다.
                            self.mainImgUrl = main ? main.imgUrl : imageList[0].imgUrl;
                        } else {
                            self.mainImgUrl = 'default.jpg';
                        }
                    },
                    error: function(err) {
                        console.error("이미지 로드 실패:", err);
                        self.productImages = [];
                    }
                });
            },

            // 2. 썸네일 클릭 시 메인 이미지 변경
            setMainImg(fileName) {
                this.mainImgUrl = fileName;
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnDetail();
            self.fetchProductImages();
        }
    });

    app.mount('#app');
</script>