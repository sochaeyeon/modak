<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Noto+Sans+KR:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&libraries=services"></script>

    <style>
        /* ─── 기초 변수 및 초기화 ─── */
        *{margin:0;padding:0;box-sizing:border-box}
        :root{
          --cream:#F6F0E6; --cream2:#EDE5D4; --cream3:#E2D8C3;
          --orange:#E8732A; --orange2:#C4621E; --amber:#D4932A;
          --brown:#2C1E0F; --brown2:#5C4230; --brown3:#8B6B4A;
          --brown4:#B89A7A; --white:#FFFDF8; --card:#FFFFFF;
        }
        html{scroll-behavior:smooth}
        body{font-family:'Noto Sans KR',sans-serif;background:var(--cream);color:var(--brown);overflow-x:hidden}

        /* ─── NAV ─── */
        nav{position:fixed;top:0;left:0;right:0;z-index:100;background:rgba(246,240,230,0.92);backdrop-filter:blur(12px);border-bottom:1px solid var(--cream2);height:64px;display:flex;align-items:center;justify-content:space-between;padding:0 48px}
        .nav-left{display:flex;align-items:center;gap:32px}
        .nav-logo{font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:800;color:var(--brown);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-menu{display:flex;gap:28px;list-style:none}
        .nav-menu a{font-size:13px;color:var(--brown2);text-decoration:none;transition:color 0.2s}
        .nav-menu a:hover{color:var(--orange)}
        .nav-right{display:flex;align-items:center;gap:20px}
        .btn-login{background:var(--brown);color:var(--cream);font-size:13px;padding:8px 22px;border-radius:24px;border:none;cursor:pointer;transition:background 0.2s}
        .btn-login:hover{background:var(--orange)}

        /* ─── HERO & DYNAMIC CAMPFIRE (404 효과 이식) ─── */
        .hero{min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding-top:64px;position:relative;overflow:hidden}
        .hero-bg{position:absolute;inset:0;background:radial-gradient(ellipse 70% 60% at 50% 60%, #EDE0C4 0%, var(--cream) 70%);z-index:0}
        
        /* 연기 효과 */
        .smoke-container { position: absolute; bottom: 45%; left: 50%; transform: translateX(-50%); width: 80px; pointer-events: none; z-index: 1; }
        .smoke { position: absolute; bottom: 0; border-radius: 50%; background: radial-gradient(circle, rgba(180,150,110,0.22) 0%, transparent 70%); animation: smokeRise linear infinite; }
        @keyframes smokeRise { 
            0% { transform: translateY(0) scale(1); opacity: 0; } 
            10% { opacity: 0.6; } 
            100% { transform: translateY(-300px) scale(4); opacity: 0; } 
        }

        /* 불꽃 디자인 */
        .campfire-wrap { width: 200px; display: flex; flex-direction: column; align-items: center; z-index: 5; margin-bottom: 20px; position: relative;}
        .flames { position: relative; width: 100px; height: 80px; margin-bottom: -8px; z-index: 2; }
        .flame { position: absolute; bottom: 0; border-radius: 50% 50% 35% 35%; transform-origin: bottom center; animation: flicker ease-in-out infinite alternate; }
        .flame-outer { width: 90px; height: 70px; left: 5px; background: radial-gradient(ellipse at 50% 85%, #ff6b00 0%, #e84800 30%, #c43000 60%, transparent 100%); animation-duration: 0.9s; opacity: 0.85; }
        .flame-mid { width: 65px; height: 55px; left: 17px; background: radial-gradient(ellipse at 50% 85%, #ffaa00 0%, #ff7800 40%, #e84800 70%, transparent 100%); animation-duration: 0.7s; animation-delay: 0.1s; }
        .flame-inner { width: 40px; height: 38px; left: 30px; background: radial-gradient(ellipse at 50% 85%, #fff0a0 0%, #ffcc00 30%, #ffaa00 60%, transparent 100%); animation-duration: 0.55s; animation-delay: 0.2s; }
        .flame-core { width: 18px; height: 22px; left: 41px; background: radial-gradient(ellipse at 50% 80%, #fffde0 0%, #fff5b0 50%, transparent 100%); animation-duration: 0.45s; }
        @keyframes flicker { 0% { transform: scaleX(1) scaleY(1) rotate(-1deg); } 100% { transform: scaleX(0.99) scaleY(1.02) rotate(-1.5deg); } }

        /* 장작 및 바닥 효과 */
        .logs { width: 140px; height: 22px; position: relative; z-index: 3; }
        .log { position: absolute; height: 14px; border-radius: 7px; background: linear-gradient(to bottom, #5a3010, #2e1608); }
        .log::after { content: ''; position: absolute; inset: 2px 8px; border-radius: 5px; background: linear-gradient(to bottom, #7a4520 0%, transparent 100%); }
        .log-1 { width: 120px; left: 10px; top: 8px; transform: rotate(-10deg); }
        .log-2 { width: 110px; left: 15px; top: 6px; transform: rotate(12deg); }
        .log-3 { width: 90px; left: 25px; top: 2px; transform: rotate(-3deg); background: linear-gradient(to bottom, #3d1e09, #1a0905); }
        .ember-glow { position: absolute; bottom: 3px; left: 30px; width: 80px; height: 10px; border-radius: 50%; background: radial-gradient(ellipse, rgba(255,120,10,0.6) 0%, rgba(200,60,0,0.3) 50%, transparent 70%); animation: emberPulse 1.8s ease-in-out infinite alternate; }
        @keyframes emberPulse { from { opacity: 0.7; transform: scaleX(1); } to { opacity: 1; transform: scaleX(1.1); } }
        
        /* 불씨 애니메이션 컨테이너 */
        .embers { position: absolute; bottom: 100px; left: 50%; transform: translateX(-50%); width: 300px; height: 400px; pointer-events: none; z-index: 1; }
        .ember { position: absolute; border-radius: 50%; animation: emberFloat linear infinite; }
        @keyframes emberFloat { 0% { transform: translateY(0) translateX(0) scale(1); opacity: 1; } 100% { transform: translateY(-380px) translateX(var(--dx)) scale(0.2); opacity: 0; } }

        /* 타이틀 및 버튼 */
        .hero-content { position: relative; z-index: 10; }
        .hero-title{font-family:'Nanum Myeongjo',serif;font-size:52px;font-weight:800;line-height:1.2;color:var(--brown);margin-bottom:20px}
        .hero-title span{color:var(--orange)}
        .hero-sub{font-size:15px;color:var(--brown3);margin-bottom:40px}
        .btn-primary{background:var(--orange);color:#fff;padding:14px 36px;border-radius:32px;text-decoration:none;display:inline-block;font-weight:500;transition:0.25s;border:none;cursor:pointer}
        .btn-secondary{background:transparent;color:var(--brown2);padding:13px 34px;border-radius:32px;border:1.5px solid var(--brown4);text-decoration:none;display:inline-block;transition:0.25s}

        /* ─── SECTION COMMON ─── */
        .section{padding:80px 48px; text-align:center}
        .section-alt{background:var(--white);padding:80px 48px}
        .section-label{font-size:11px;color:var(--brown4);letter-spacing:2px;text-transform:uppercase;margin-bottom:10px}
        .section-title{font-family:'Nanum Myeongjo',serif;font-size:30px;font-weight:700;color:var(--brown);margin-bottom:40px}

        /* ─── STRIP & CATEGORIES ─── */
        .strip{background:var(--brown);color:var(--cream);padding:12px 0;overflow:hidden;white-space:nowrap}
        .strip-inner{display:inline-flex;gap:80px;animation:marquee 30s linear infinite;font-size:12px;opacity:0.85}
        @keyframes marquee{from{transform:translateX(0)}to{transform:translateX(-50%)}}
        .cat-grid{display:grid;grid-template-columns:repeat(7,1fr);gap:16px;max-width:900px;margin:0 auto}
        .cat-item{display:flex;flex-direction:column;align-items:center;gap:10px;cursor:pointer;transition:0.3s}
        .cat-icon{width:56px;height:56px;background:var(--cream2);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:26px}
        .cat-item:hover .cat-icon{background:var(--orange); color:white}

        /* ─── PRODUCTS ─── */
        .product-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:24px;max-width:1200px;margin:0 auto}
        .product-card{border-radius:16px;overflow:hidden;background:var(--card);cursor:pointer;transition:all 0.3s;border:1px solid var(--cream2)}
        .product-card:hover{transform:translateY(-6px);box-shadow:0 20px 48px rgba(44,30,15,0.12)}
        .product-img{width:100%;aspect-ratio:1;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:56px}
        .product-info{padding:16px; text-align:left}

        /* ─── MAP & WEATHER & FOOTER ─── */
        .map-banner{background:var(--brown);padding:80px 48px;display:flex;align-items:center;gap:64px;overflow:hidden;position:relative}
        .map-visual{flex:1;border-radius:20px;aspect-ratio:4/3;background:rgba(255,253,248,0.06);position:relative;overflow:hidden;border:1px solid rgba(255,253,248,0.1)}
        .ws-grid{display:grid;grid-template-columns:1fr 1fr;gap:32px;max-width:1200px;margin:0 auto}
        .ws-card{background:var(--cream2);border-radius:20px;padding:36px;text-align:left;border:1px solid var(--cream3)}
        .co-banner{background:linear-gradient(135deg,var(--orange),var(--amber));border-radius:16px;padding:20px;color:white;margin-top:20px;display:flex;justify-content:space-between;cursor:pointer}
        footer{background:var(--brown);padding:60px 48px 32px;color:var(--cream); text-align:center}
    </style>
</head>
<body>
<div id="app">
    <nav>
        <div class="nav-left">
            <a href="/main.do" class="nav-logo">⛺ 모닥모닥</a>
            <ul class="nav-menu">
                <li><a href="#">캠핑 용품</a></li>
                <li><a href="/camp/map.do">캠핑장 찾기</a></li>
                <li><a href="#">커뮤니티</a></li>
                <li><a href="#">고객센터</a></li>
            </ul>
        </div>
        <div class="nav-right">
            <button class="btn-login" onclick="location.href='/user/login.do'">로그인</button>
        </div>
    </nav>

    <section class="hero">
        <div class="hero-bg"></div>
        <div class="smoke-container">
            <div class="smoke" style="width:30px;height:30px;left:25px;animation-duration:5s;"></div>
            <div class="smoke" style="width:40px;height:40px;left:10px;animation-duration:6s;animation-delay:1.5s;"></div>
            <div class="smoke" style="width:25px;height:25px;left:35px;animation-duration:4.5s;animation-delay:3s;"></div>
        </div>
        <div class="embers" id="embers"></div>
        <div class="hero-content">
            <div class="campfire-wrap">
                <div class="flames">
                    <div class="flame flame-outer"></div><div class="flame flame-mid"></div><div class="flame flame-inner"></div><div class="flame flame-core"></div>
                </div>
                <div class="logs">
                    <div class="log log-3"></div><div class="log log-1"></div><div class="log log-2"></div>
                    <div class="ember-glow"></div>
                </div>
            </div>
            <h1 class="hero-title">불꽃처럼 빛나는<br><span>캠핑 라이프</span>를</h1>
            <p class="hero-sub">프리미엄 장비 대여부터 감성 캠핑장 예약까지, 모닥모닥과 함께하세요.</p>
            <div class="hero-btns">
                <a href="#" class="btn-primary">장비 대여하기</a>
            </div>
        </div>
    </section>

    <section class="section">
        <p class="section-label">Category</p>
        <h2 class="section-title">필요한 모든 장비</h2>
        <div class="cat-grid">
            <div class="cat-item"><div class="cat-icon">⛺</div><span>텐트</span></div>
            <div class="cat-item"><div class="cat-icon">🛏️</div><span>침낭</span></div>
            <div class="cat-item"><div class="cat-icon">🍳</div><span>취사</span></div>
            <div class="cat-item"><div class="cat-icon">💡</div><span>조명</span></div>
            <div class="cat-item"><div class="cat-icon">🪑</div><span>의자</span></div>
            <div class="cat-item"><div class="cat-icon">🔒</div><span>안전</span></div>
            <div class="cat-item"><div class="cat-icon">🎒</div><span>기타</span></div>
        </div>
    </section>

    <section class="map-banner">
        <div class="map-text">
            <p class="section-label" style="color:var(--orange)">Camping Map</p>
            <h2 class="section-title">내 주변 캠핑장을<br>지금 찾아보세요</h2>
            <p style="color:var(--brown4); margin-bottom: 24px;">현재 위치 기반으로 가장 가까운 캠핑 장소를 확인하세요.</p>
            <a href="/camp/map.do" class="btn-primary" style="text-decoration:none;">지도로 찾기</a>
        </div>
        
        <div id="main-map" class="map-visual" style="aspect-ratio: 4/3; max-height: 400px;"></div>
    </section>

    <section class="section" id="weatherApp">
        <p class="section-label">Weather</p>
        <h2 class="section-title">안전한 캠핑을 위한 실시간 날씨</h2>
        <div class="ws-grid">
            <div class="ws-card">
                <div class="ws-icon">{{ weatherIcon }}</div>
                <h3>현재 날씨</h3>
                <p style="font-size:28px; font-weight:700; color:var(--orange); margin:10px 0;">{{ temp }}°C</p>
                <p style="font-size:14px; color:var(--brown3);">습도 {{ humidity }}% | 강수량 {{ rain }}mm</p>
            </div>
            <div class="ws-card ws-safety">
                <div class="ws-icon">🛡️</div>
                <h3>안전 가이드</h3>
                <p style="font-size:14px; color:var(--brown3); margin-top:10px;">일산화탄소 경보기는 캠핑의 필수품입니다.</p>
                <div class="co-banner"><span>🚨 경보기 대여</span><span>→</span></div>
            </div>
        </div>
    </section>

    <footer>
        <p style="font-size:12px; opacity:0.5;">© 2026 모닥모닥. All Rights Reserved. 🔥</p>
    </footer>

    <div class="chatbot-fab" style="position: fixed; bottom: 30px; right: 30px; z-index: 1000; display: flex; align-items: center; gap: 10px; cursor: pointer;">
        <span class="fab-label" style="background: var(--brown); color: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">챗봇 문의</span>
        <div class="fab-btn" style="width: 60px; height: 60px; background: var(--orange); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 15px rgba(232,115,42,0.4); font-size: 24px; color: white;">💬</div>
    </div>
</div>
<script>
    // 1. 불씨(Ember) 애니메이션 (From 404)
    const emberContainer = document.getElementById('embers');
    function createEmber() {
        if(!emberContainer) return;
        const el = document.createElement('div');
        el.className = 'ember';
        const size = Math.random() * 4 + 1.5;
        const left = Math.random() * 160 + 70;
        const duration = Math.random() * 3 + 2.5;
        const dx = (Math.random() - 0.5) * 120;
        el.style.cssText = `width:${size}px; height:${size}px; left:${left}px; bottom:0; background:rgba(255,120,20,0.8); box-shadow:0 0 5px orange; --dx:${dx}px; animation-duration:${duration}s;`;
        emberContainer.appendChild(el);
        setTimeout(() => el.remove(), duration * 1000);
    }
    setInterval(createEmber, 300);

    // 2. 카카오 지도 초기화
    $(document).ready(function() {
        var mapContainer = document.getElementById('main-map'); 
        var mapOption = { center: new kakao.maps.LatLng(37.5668, 126.9786), level: 5 }; 
        var map = new kakao.maps.Map(mapContainer, mapOption); 
        map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
        map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
        
        // [팁] 지도가 작아졌으므로, 로드 후 relayout()을 한 번 호출해주는 것이 좋습니다.
        setTimeout(() => map.relayout(), 500);
    });

    // 3. Vue 날씨 연동 (기상청 API)
    const { createApp } = Vue;
    createApp({
        data() { return { temp: '--', humidity: '--', rain: '0', weatherIcon: '🌤️' } },
        methods: {
            getWeather() {
                // [중요] 은동님이 만든 WeatherController의 URL과 맞춥니다.
                $.ajax({
                    url: "/weather/now.dox", 
                    dataType: "json",
                    success: (data) => {
                        // 기상청 API 파싱 로직
                        if(data.response && data.response.body) {
                            const items = data.response.body.items.item;
                            items.forEach(item => {
                                if(item.category === "T1H") this.temp = item.obsrValue;   // 기온
                                if(item.category === "REH") this.humidity = item.obsrValue; // 습도
                                if(item.category === "RN1") this.rain = item.obsrValue;     // 강수량
                            });
                            
                            // 상태에 따른 아이콘 변경 (간단 예시)
                            if(parseFloat(this.rain) > 0) this.weatherIcon = '🌧️';
                            else if(parseFloat(this.temp) > 28) this.weatherIcon = '☀️';
                        }
                    },
                    error: (err) => {
                        console.error("날씨 로드 실패 : ", err);
                    }
                });
            }
        },
        mounted() { this.getWeather(); }
    }).mount('#weatherApp');
</script>
</body>
</html>