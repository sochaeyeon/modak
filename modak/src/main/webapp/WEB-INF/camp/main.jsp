<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        /* 기본 스타일 */
        body, html { margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif; background-color: #fff; scroll-behavior: smooth; }
        ul { list-style: none; padding: 0; margin: 0; }
        a { text-decoration: none; color: inherit; }

        /* 섹션 공통 */
        section { width: 100%; position: relative; overflow: hidden; }
        .inner { max-width: 1200px; margin: 0 auto; padding: 100px 20px; }

        /* 1. 상단 비주얼 영역 (image_f9642f 반영) */
        .hero { height: 100vh; background: #f3eae3 url('https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=2070&auto=format&fit=crop') no-repeat center/cover; display: flex; align-items: center; justify-content: center; text-align: center; }
        .hero-content { background: rgba(243, 234, 227, 0.85); padding: 60px; border-radius: 30px; }
        .hero h1 { font-size: 48px; font-weight: 700; line-height: 1.3; margin-bottom: 20px; }
        .hero h1 span { color: #e67e22; }
        .hero p { font-size: 18px; color: #666; margin-bottom: 40px; }
        .btn-group { display: flex; justify-content: center; gap: 20px; }
        .btn { padding: 15px 40px; border-radius: 30px; font-size: 16px; cursor: pointer; transition: 0.3s; border: none; }
        .btn-primary { background: #e67e22; color: white; }
        .btn-secondary { background: #fff; color: #333; border: 1px solid #ddd; }
        .btn:hover { opacity: 0.8; transform: translateY(-3px); }

        /* 2. 카테고리 영역 (image_f96426 반영) */
        .categories { background: #fff; text-align: center; }
        .cat-list { display: flex; justify-content: center; gap: 40px; margin-top: 50px; }
        .cat-item { cursor: pointer; }
        .cat-icon { width: 80px; height: 80px; background: #f9f9f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 30px; margin-bottom: 10px; transition: 0.3s; }
        .cat-item:hover .cat-icon { background: #e67e22; color: white; }

        /* 3. 인기 장비 (상품 리스트) */
        .products { background: #fdfaf7; }
        .section-title { text-align: center; margin-bottom: 60px; }
        .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; }
        .prod-card { background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
        .prod-img { width: 100%; height: 200px; background: #eee; }
        .prod-info { padding: 20px; }
        .prod-info h4 { margin: 0 0 10px 0; font-size: 16px; }
        .price { font-weight: 700; color: #e67e22; }

        /* 4. 지도 섹션 (image_f963f0 반영) */
        .map-section { background: #f3eae3; display: flex; align-items: center; }
        .map-box { flex: 1; height: 500px; background: white; border-radius: 30px; margin-left: 50px; position: relative; }
        .map-text { width: 400px; }

        /* 5. 가이드 & 혜택 (image_f963cc 반영) */
        .guides { background: #fff; }
        .guide-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .guide-card { padding: 40px; background: #f9f9f9; border-radius: 20px; }
        .guide-card h3 { font-size: 40px; color: #ddd; margin: 0 0 20px 0; }

        /* 푸터 */
        footer { background: #f9f9f9; padding: 60px 0; border-top: 1px solid #eee; font-size: 13px; color: #888; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; }
    </style>
</head>
<body>

    <section class="hero">
        <div class="hero-content">
            <div style="color:#e67e22; font-weight: 500;">캠핑의 모든 것, 한 곳에서</div>
            <h1>불꽃처럼 빛나는<br><span>캠핑 라이프</span>를</h1>
            <p>고품질 캠핑 장비를 합리적으로 대여하고 구매하세요.<br>전국 캠핑장 실시간 날씨 정보와 안전 가이드까지.</p>
            <div class="btn-group">
                <button class="btn btn-primary">장비 대여하기</button>
                <button class="btn btn-secondary" onclick="openMapPopup()">캠핑장 찾기</button>
            </div>
        </div>
    </section>

    <section class="categories">
        <div class="inner">
            <div class="section-title">
                <h2 style="font-size: 28px;">필요한 모든 장비</h2>
                <p style="color:#999;">대여 또는 구매로 당신의 캠핑을 완성하세요</p>
            </div>
            <div class="cat-list">
                <div class="cat-item"><div class="cat-icon">⛺</div><span>텐트</span></div>
                <div class="cat-item"><div class="cat-icon">🛌</div><span>침낭/매트</span></div>
                <div class="cat-item"><div class="cat-icon">🍳</div><span>취사도구</span></div>
                <div class="cat-item"><div class="cat-icon">💡</div><span>조명</span></div>
                <div class="cat-item"><div class="cat-icon">🪑</div><span>테이블/의자</span></div>
            </div>
        </div>
    </section>

    <section class="products">
        <div class="inner">
            <div class="section-title"><h2>지금 많이 찾는 장비</h2></div>
            <div class="grid">
                <div class="prod-card" v-for="i in 4">
                    <div class="prod-img"></div>
                    <div class="prod-info">
                        <div style="color:#e67e22; font-size:12px;">텐트·4인용</div>
                        <h4>스노우피크 랜드록 2024</h4>
                        <div class="price">35,000원 <small style="color:#999; font-weight:400;">/ 1박</small></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="map-section">
        <div class="inner" style="display:flex; align-items:center;">
            <div class="map-text">
                <div style="color:#e67e22; font-weight: 500;">캠핑장 지도</div>
                <h2 style="font-size: 32px; margin: 15px 0;">내 주변 캠핑장을<br>지금 찾아보세요</h2>
                <p style="color:#666; margin-bottom: 30px;">현재 위치 기반으로 가까운 캠핑장과 주변 편의시설 위치를 한눈에 확인하세요.</p>
                <button class="btn btn-primary" onclick="openMapPopup()">지도에서 찾기</button>
            </div>
            <div class="map-box">
                <div style="width:100%; height:100%; background: url('https://t1.daumcdn.net/cfile/tistory/996A95335A3B306126') center/cover; border-radius: 30px; filter: grayscale(0.5) opacity(0.5);"></div>
                <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%);">
                    <button class="btn btn-primary" onclick="openMapPopup()">지도 열기</button>
                </div>
            </div>
        </div>
    </section>

    <section class="guides">
        <div class="inner">
            <div class="section-title"><h2>캠핑이 처음이신가요?</h2></div>
            <div class="guide-grid">
                <div class="guide-card"><h3>01</h3><h4>설치 가이드 영상</h4><p>초보 캠퍼도 쉽게 따라 할 수 있는 상세 설치 영상을 제공합니다.</p></div>
                <div class="guide-card"><h3>02</h3><h4>QR 코드 매뉴얼</h4><p>장비 수령 시 QR코드를 스캔하여 매뉴얼을 확인하세요.</p></div>
                <div class="guide-card"><h3>03</h3><h4>분리수거 가이드</h4><p>자연을 지키는 올바른 캠핑 에티켓을 안내해 드립니다.</p></div>
            </div>
        </div>
    </section>

    <footer>
        <div class="footer-inner">
            <div>
                <h3 style="color:#333;">⛺ 모닥모닥</h3>
                <p>자연과 함께하는 특별한 순간을<br>모닥모닥이 함께합니다.</p>
            </div>
            <div style="display:flex; gap: 80px;">
                <ul><li><b>서비스</b></li><li>대여하기</li><li>구매하기</li><li>캠핑장 찾기</li></ul>
                <ul><li><b>고객지원</b></li><li>공지사항</li><li>자주 묻는 질문</li><li>1:1 문의</li></ul>
            </div>
            <div>
                <b>고객센터</b><br><h2 style="margin:10px 0; color:#333;">1588-0000</h2>
                <p>평일 09:00 - 18:00<br>help@modakmodak.kr</p>
            </div>
        </div>
    </footer>

    <script>
        // 지도 팝업 함수 (기존 로직 그대로 유지)
        function openMapPopup() {
            const popupUrl = "/camp/map.do";
            const width = 1400;
            const height = 900;
            const left = (window.screen.width / 2) - (width / 2);
            const top = (window.screen.height / 2) - (height / 2);
            window.open(popupUrl, "ModakMap", 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=no');
        }
    </script>
</body>
</html>