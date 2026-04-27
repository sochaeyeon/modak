<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
      <link rel="stylesheet" href="/css/common/header.css">
      <link rel="stylesheet" href="/css/main/main.css">
      <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
      <script src="/js/wish.js"></script>
      <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
      <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.2.0/remixicon.min.css" rel="stylesheet">
    </head>

    <body>

      <%@ include file="/WEB-INF/common/header.jsp" %>

        <!-- ════════════════ HERO ════════════════ -->
        <section class="hero">
          <div class="hero-bg">
            <div class="aurora-layer aurora-1"></div>
            <div class="aurora-layer aurora-2"></div>
            <div class="aurora-layer aurora-3"></div>
            <div class="aurora-layer aurora-4"></div>
            <div class="campfire-glow"></div>
          </div>
          <div class="smoke-container">
            <div class="smoke" style="width:30px;height:30px;left:25px;animation-duration:5s"></div>
            <div class="smoke" style="width:40px;height:40px;left:10px;animation-duration:6s;animation-delay:1.5s">
            </div>
            <div class="smoke" style="width:25px;height:25px;left:35px;animation-duration:4.5s;animation-delay:3s">
            </div>
          </div>
          <div class="embers" id="embers"></div>



          <!-- 히어로 본문 -->
          <div class="hero-content">
            <div class="campfire-wrap">
              <div class="flames">
                <div class="flame flame-outer"></div>
                <div class="flame flame-mid"></div>
                <div class="flame flame-inner"></div>
                <div class="flame flame-core"></div>
              </div>
              <div class="logs">
                <div class="log log-3"></div>
                <div class="log log-1"></div>
                <div class="log log-2"></div>
                <div class="ember-glow"></div>
              </div>
            </div>
            <div class="hero-badge">캠핑의 모든 것, 한 곳에서</div>
            <h1 class="hero-title">불꽃처럼 빛나는<br><span>캠핑 라이프</span>를</h1>
            <p class="hero-sub">고품질 캠핑 장비를 합리적으로 대여하고 구매하세요.<br>전국 캠핑장 예약부터 날씨 정보, 안전 가이드까지.</p>
            <div class="hero-btns">
              <a href="/product/list.do" class="btn-primary">장비 대여하기</a>
              <a href="/camp/map.do" class="btn-secondary">캠핑장 찾기</a>
            </div>
          </div>
          <div class="hero-scroll">SCROLL<div class="scroll-line"></div>
          </div>
        </section>

        <!-- ════════════════ EVENT BANNER ════════════════ -->
        <div class="main-event-banner" id="heroBannerWrap">
          <div class="heb-track" id="hebTrack"></div>
          <div class="heb-dots" id="hebDots"></div>
          <button class="heb-arrow heb-arrow--prev" id="hebPrev">&#8249;</button>
          <button class="heb-arrow heb-arrow--next" id="hebNext">&#8250;</button>
        </div>

        <!-- ════════════════ CATEGORIES ════════════════ -->
        <section class="section" style="text-align:center">
          <p class="section-label">카테고리</p>
          <h2 class="section-title">필요한 모든 장비</h2>
          <p class="section-sub">대여 또는 구매로 당신의 캠핑을 완성하세요</p>
          <div class="cat-grid" id="catGrid"></div>
        </section>

        <!-- ════════════════ PRODUCTS ════════════════ -->
        <section class="section-alt">
          <div class="section-header">
            <div>
              <p class="section-label">인기 장비</p>
              <h2 class="section-title" style="margin-bottom:0">지금 많이 찾는 장비</h2>
            </div>
            <a href="/product/list.do" class="view-all">전체보기</a>
          </div>
          <div class="product-grid" id="popularGrid"></div>
        </section>

        <!-- ════════════════ MAP BANNER ════════════════ -->
        <section class="map-banner">
          <div class="map-text">
            <p class="section-label">캠핑장 지도</p>
            <h2 class="section-title">내 주변 캠핑장을<br>지금 찾아보세요</h2>
            <p class="section-sub">현재 위치 기반으로 가까운 캠핑장과 주변 편의시설, 병원 위치를 한눈에 확인하세요.</p>
            <ul class="map-features">
              <li>실시간 캠핑장 예약 · 500곳 이상</li>
              <li>주변 편의점, 병원, 동물병원 거리 표시</li>
              <li>현재 위치 기반 길찾기 연동</li>
              <li>계절별 캠핑장 추천</li>
            </ul>
            <button class="btn-primary" onclick="location.href='/camp/map.do'">지도로 찾기</button>
          </div>
          <div class="map-kakao-wrap">
            <div class="map-loading" id="mapLoading">
              <div class="map-spinner"></div>
              <span>캠핑장 불러오는 중...</span>
            </div>
            <div id="mainMap"></div>
            <button class="map-full-btn" onclick="location.href='/camp/map.do'">🗺️ 전체 지도 보기</button>
          </div>
        </section>

        <!-- ════════════════ WEATHER ════════════════ -->
        <section style="padding:80px 48px;background:var(--cream2)" id="weatherSection">
          <div style="max-width:1200px;margin:0 auto">
            <div
              style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:40px;flex-wrap:wrap;gap:16px">
              <div>
                <p class="section-label">날씨 · 안전</p>
                <h2 class="section-title" style="margin-bottom:0">안전하고 즐거운 캠핑을 위해</h2>
              </div>
              <div style="display:flex;align-items:center;gap:10px;background:var(--white);border-radius:50px;
                  padding:8px 8px 8px 18px;border:1.5px solid var(--cream3);
                  box-shadow:0 2px 12px rgba(44,30,15,.06)">
                <span style="font-size:13px;color:var(--brown3);white-space:nowrap">📍 지역</span>
                <select @change="onRegionChange"
                  style="border:none;outline:none;background:transparent;font-size:13px;font-weight:600;color:var(--brown2);font-family:'GgiBatang',sans-serif;cursor:pointer;padding-right:8px">
                  <option value="seoul">서울</option>
                  <option value="gyeonggi">경기</option>
                  <option value="gangwon">강원</option>
                  <option value="chungbuk">충북</option>
                  <option value="chungnam">충남</option>
                  <option value="jeonbuk">전북</option>
                  <option value="jeonnam">전남</option>
                  <option value="gyeongbuk">경북</option>
                  <option value="gyeongnam">경남</option>
                  <option value="jeju">제주</option>
                </select>
              </div>
            </div>
            <div class="ws-grid">
              <div
                style="background:var(--white);border-radius:24px;padding:32px;box-shadow:0 4px 24px rgba(44,30,15,.07);border:1px solid var(--cream3)">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:24px">
                  <div>
                    <p style="font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:4px">FORECAST</p>
                    <p style="font-family:'GgiBatang',serif;font-size:20px;font-weight:700;color:var(--brown)">{{
                      regionName }} 날씨 예보</p>
                  </div>
                  <div style="font-size:44px;line-height:1">{{ days.length > 0 ? days[0].icon : '🌤️' }}</div>
                </div>
                <div v-if="isLoading" style="display:flex;gap:10px;margin-bottom:24px">
                  <div v-for="n in 5" :key="n" class="skel" style="flex:1;height:120px;border-radius:16px"></div>
                </div>
                <div v-else-if="!isError && days.length > 0"
                  style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-bottom:20px">
                  <div v-for="(d, i) in days" :key="i" class="weather-card" :style="{borderRadius:'16px',padding:'16px 8px',textAlign:'center',
                        background:i<2?'linear-gradient(160deg,#FBE8DC,#FDF3EE)':'var(--cream)',
                        border:i<2?'1.5px solid rgba(232,115,42,.25)':'1.5px solid var(--cream3)',
                        transition:'transform .2s',cursor:'default'}">
                    <div style="font-size:12px;font-weight:700;color:var(--brown2);margin-bottom:2px">{{ d.label }}
                    </div>
                    <div
                      :style="{display:'inline-block',fontSize:'9px',fontWeight:'600',padding:'2px 7px',borderRadius:'10px',marginBottom:'10px',background:i<2?'rgba(232,115,42,.15)':'var(--cream2)',color:i<2?'var(--orange)':'var(--brown4)'}">
                      {{ i < 2 ? '단기' : '중기' }} </div>
                        <div style="font-size:30px;line-height:1;margin-bottom:10px">{{ d.icon }}</div>
                        <div style="font-size:16px;font-weight:800;color:var(--orange);margin-bottom:2px">{{ d.max }}
                        </div>
                        <div style="font-size:12px;color:var(--brown4);margin-bottom:8px">{{ d.min }}</div>
                        <div
                          style="display:inline-flex;align-items:center;gap:3px;font-size:10px;color:var(--brown3);background:var(--cream2);border-radius:8px;padding:3px 7px">
                          <span>🌧</span><span>{{ d.rain }}</span>
                        </div>
                    </div>
                  </div>
                  <div v-else
                    style="text-align:center;padding:32px 0;color:var(--brown4);font-size:13px;margin-bottom:20px">
                    날씨 정보를 불러올 수 없습니다.
                  </div>
                  <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px">
                    <p style="font-size:11px;color:var(--brown4)">
                      <span
                        style="display:inline-block;width:10px;height:10px;border-radius:3px;background:#FBE8DC;border:1px solid rgba(232,115,42,.3);margin-right:4px;vertical-align:middle"></span>단기예보
                      &nbsp;
                      <span
                        style="display:inline-block;width:10px;height:10px;border-radius:3px;background:var(--cream2);border:1px solid var(--cream3);margin-right:4px;vertical-align:middle"></span>중기예보
                    </p>
                  </div>
                </div>
                <div
                  style="background:var(--white);border-radius:24px;padding:32px;box-shadow:0 4px 24px rgba(44,30,15,.07);border:1px solid var(--cream3)">
                  <div style="display:flex;align-items:center;gap:12px;margin-bottom:20px">
                    <div
                      style="width:48px;height:48px;background:#FFE8E8;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:22px">
                      🛡️</div>
                    <div>
                      <p style="font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:2px">SAFETY</p>
                      <p style="font-family:'GgiBatang',serif;font-size:20px;font-weight:700;color:var(--brown)">캠핑 안전
                        수칙</p>
                    </div>
                  </div>
                  <ul class="safety-list" style="margin-bottom:24px">
                    <li><span class="safety-num">1</span>텐트 내 가스·화기 절대 사용 금지</li>
                    <li><span class="safety-num">2</span>일산화탄소 경보기 반드시 설치</li>
                    <li><span class="safety-num">3</span>취침 전 화롯대 완전 소화 확인</li>
                    <li><span class="safety-num">4</span>쓰레기 분리수거 및 흔적 남기지 않기</li>
                  </ul>
                  <div class="co-banner" onclick="location.href='/product/product-detail.do?no=10'">
                    <span style="font-size:28px">🚨</span>
                    <div class="co-text">
                      <p class="co-title">일산화탄소 경보기 대여</p>
                      <p class="co-sub">하루 3,000원 · 필수 안전 장비</p>
                    </div>
                    <span style="font-size:20px;color:rgba(255,255,255,.8)">→</span>
                  </div>
                </div>
              </div>
            </div>
        </section>

        <!-- ════════════════ GUIDE ════════════════ -->
        <section class="guide-section">
          <div style="max-width:1200px;margin:0 auto">
            <p class="section-label">이용 가이드</p>
            <h2 class="section-title">캠핑이 처음이신가요?</h2>
            <div class="guide-grid">
              <div class="guide-card fade-up" onclick="location.href='/guide/guide.do'">
                <div class="guide-num">01</div>
                <div class="guide-icon-row"><span class="guide-emoji">📹</span>
                  <p class="guide-card-title">설치 가이드 영상</p>
                </div>
                <p class="guide-card-text">텐트, 타프, 취사도구 등 장비별 상세 설치 영상을 제공합니다. 초보 캠퍼도 쉽게 따라할 수 있어요.</p>
                <span class="guide-link">영상 보러가기</span>
              </div>
              <div class="guide-card fade-up" onclick="location.href='/guide/guide.do'">
                <div class="guide-num">02</div>
                <div class="guide-icon-row"><span class="guide-emoji">📱</span>
                  <p class="guide-card-title">QR 코드 매뉴얼</p>
                </div>
                <p class="guide-card-text">장비 수령 시 QR코드를 스캔하면 해당 제품의 상세 매뉴얼을 즉시 확인할 수 있습니다.</p>
                <span class="guide-link">QR 사용법 보기</span>
              </div>
              <div class="guide-card fade-up" onclick="location.href='/guide/guide.do'">
                <div class="guide-num">03</div>
                <div class="guide-icon-row"><span class="guide-emoji">♻️</span>
                  <p class="guide-card-title">분리수거 가이드</p>
                </div>
                <p class="guide-card-text">자연을 지키는 올바른 캠핑 문화. 캠핑장별 쓰레기 분리수거 규정과 방법을 안내해드립니다.</p>
                <span class="guide-link">가이드 확인하기</span>
              </div>
            </div>
          </div>
        </section>

        <!-- ════════════════ MEMBERSHIP ════════════════ -->
        <section class="member-banner" id="memberSection">
          <div class="member-inner">
            <div>
              <h2 class="member-title">더 많이 이용할수록<br>더 큰 혜택을</h2>
              <p class="member-sub">이용 횟수와 금액에 따라 등급이 올라가며<br>할인 쿠폰, 전용 상품, 우선 예약 혜택을 드립니다.</p>
              <div class="grade-list" id="gradeListWrap"></div>
            </div>
            <div class="member-actions">
              <button class="btn-primary" onclick="location.href='/user/sign-up.do'">회원가입 하기</button>
              <a href="/user/membership/info.do" class="btn-secondary" style="text-align:center">멤버십 혜택 보기</a>
            </div>
          </div>
        </section>

        <!-- 챗봇 FAB -->
        <div class="chatbot-fab">
          <span class="fab-label">챗봇 문의</span>
          <button class="fab-btn" onclick="location.href='/chat/bot.do'">💬</button>
        </div>

        <!-- 최근 본 상품 바 -->
        <div class="recent-bar" id="recentBar">
          <span class="recent-label">최근 본 상품</span>
          <div class="recent-items" id="recentItems"></div>
          <button class="recent-close" onclick="closeRecent()">✕</button>
        </div>

        <!-- 토스트 -->
        <div class="toast" id="toast"></div>

        <!-- 로그인 유도 모달 -->
        <div id="loginModal"
          style="display:none;position:fixed;inset:0;z-index:99999;align-items:center;justify-content:center;background:rgba(44,30,15,.55);backdrop-filter:blur(4px);"
          onclick="fnCloseLoginModal(event)">
          <div
            style="background:#fffdf8;border-radius:24px;padding:36px 32px 28px;width:320px;box-shadow:0 24px 64px rgba(44,30,15,.25);text-align:center;animation:modalPop .25s ease;font-family:var(--font-body,'Noto Sans KR',sans-serif);position:relative;z-index:100000;">
            <div style="font-size:48px;margin-bottom:16px">🔐</div>
            <p
              style="font-size:18px;font-weight:800;color:#2C1E0F;margin-bottom:8px;font-family:var(--font-title,'GgiBatang',serif)">
              로그인이 필요해요</p>
            <p
              style="font-size:13px;color:#8B6B4A;line-height:1.7;margin-bottom:24px;font-family:var(--font-body,'Noto Sans KR',sans-serif)">
              찜 기능은 로그인 후 이용할 수 있어요.<br>로그인 페이지로 이동할까요?</p>
            <div style="display:flex;gap:10px;">
              <button onclick="fnCloseLoginModal()"
                style="flex:1;padding:13px;background:#EDE5D4;border:none;border-radius:12px;font-size:14px;font-weight:600;color:#5C4230;cursor:pointer;transition:background .2s;"
                onmouseover="this.style.background='#E2D8C3'" onmouseout="this.style.background='#EDE5D4'">취소</button>
              <button onclick="location.href='/user/login.do'"
                style="flex:1;padding:13px;background:#E8732A;border:none;border-radius:12px;font-size:14px;font-weight:600;color:#fff;cursor:pointer;box-shadow:0 4px 14px rgba(232,115,42,.35);transition:background .2s;"
                onmouseover="this.style.background='#C4621E'"
                onmouseout="this.style.background='#E8732A'">로그인하기</button>
            </div>
          </div>
        </div>
        <style>
          @keyframes modalPop {
            from {
              opacity: 0;
              transform: scale(.92) translateY(10px);
            }

            to {
              opacity: 1;
              transform: scale(1) translateY(0);
            }
          }
        </style>

        <%@ include file="/WEB-INF/common/footer.jsp" %>

          <script>
            /* ── 1. 불씨 + 낙엽 ── */
            (function () {
              var ec = document.getElementById('embers');
              var fireColors = ['rgba(255,120,20,.9)', 'rgba(255,80,0,.85)', 'rgba(255,180,30,.8)', 'rgba(220,60,0,.75)', 'rgba(255,140,40,.7)'];
              function mkEmber() {
                if (!ec) return;
                var el = document.createElement('div'); el.className = 'ember';
                var s = Math.random() * 4 + 1.5, l = Math.random() * (window.innerWidth * 0.6) + (window.innerWidth * 0.2),
                  d = Math.random() * 3 + 2.5, dx = (Math.random() - .5) * 200, c = fireColors[Math.floor(Math.random() * fireColors.length)];
                el.style.cssText = 'width:' + s + 'px;height:' + s + 'px;left:' + l + 'px;bottom:0;background:' + c + ';box-shadow:0 0 ' + (s * 2) + 'px ' + c + ';--dx:' + dx + 'px;animation-duration:' + d + 's;';
                ec.appendChild(el);
                setTimeout(function () { el.parentNode && el.parentNode.removeChild(el); }, d * 1000);
              }
              var leafColors = ['rgba(139,107,74,.5)', 'rgba(196,130,80,.45)', 'rgba(212,147,42,.4)', 'rgba(184,154,122,.4)'];
              function mkLeaf() {
                if (!ec) return;
                var el = document.createElement('div'), size = Math.random() * 8 + 5, left = Math.random() * window.innerWidth,
                  dur = Math.random() * 6 + 5, delay = Math.random() * 2, sway = (Math.random() - .5) * 180, rot = Math.random() * 360,
                  color = leafColors[Math.floor(Math.random() * leafColors.length)];
                el.style.cssText = 'position:absolute;font-size:' + size + 'px;left:' + left + 'px;top:-20px;color:' + color + ';pointer-events:none;--sway:' + sway + 'px;--rot:' + rot + 'deg;animation:leafFall ' + dur + 's ease-in ' + delay + 's both;';
                el.textContent = '◆'; ec.appendChild(el);
                setTimeout(function () { el.parentNode && el.parentNode.removeChild(el); }, (dur + delay) * 1000);
              }
              setInterval(mkEmber, 60); setInterval(mkLeaf, 600);
              for (var i = 0; i < 36; i++) setTimeout(mkEmber, i * 60);
              for (var j = 0; j < 15; j++) setTimeout(mkLeaf, j * 200);
            })();

            /* ── 2. 스크롤 리빌 ── */
            var revealObs = new IntersectionObserver(function (entries) {
              entries.forEach(function (e) { if (e.isIntersecting) e.target.classList.add('visible'); });
            }, { threshold: .12 });
            document.querySelectorAll('.fade-up').forEach(function (el) { revealObs.observe(el); });
            window.addEventListener('scroll', function () {
              var nav = document.getElementById('mainNav');
              if (nav) nav.classList.toggle('scrolled', window.scrollY > 40);
            });

            /* ── 4. 카카오맵 ── */
            kakao.maps.load(function () {
              var container = document.getElementById('mainMap'); if (!container) return;
              var map = new kakao.maps.Map(container, { center: new kakao.maps.LatLng(36.5, 127.8), level: 11, scrollwheel: false });
              map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
              var iw = new kakao.maps.InfoWindow({ zIndex: 10 });
              $.ajax({
                url: '/camp/list.dox', type: 'POST', dataType: 'json',
                success: function (data) {
                  var el = document.getElementById('mapLoading'); if (el) el.classList.add('hide');
                  if (!data || !data.list) return;
                  data.list.slice(0, 80).forEach(function (item) {
                    var lat = parseFloat(item.mapY), lng = parseFloat(item.mapX);
                    if (!lat || !lng || lat < 30 || lat > 40 || lng < 120 || lng > 135) return;
                    var pos = new kakao.maps.LatLng(lat, lng);
                    var ov = new kakao.maps.CustomOverlay({
                      position: pos, yAnchor: 0.5, zIndex: 3,
                      content: '<div style="width:12px;height:12px;background:#E8732A;border:2px solid rgba(255,253,248,.85);border-radius:50%;box-shadow:0 2px 6px rgba(232,115,42,.55);cursor:pointer"></div>'
                    }); ov.setMap(map);
                    var ct = '<div style="padding:10px 14px;font-size:12px;max-width:180px;line-height:1.6;font-family:GgiBatang,sans-serif;"><b style="color:#E8732A;display:block;margin-bottom:3px;">⛺ ' + item.facltNm + '</b><span style="color:#666;">' + (item.addr1 || '') + '</span><br><a href="/camp/map.do" style="color:#E8732A;font-size:11px;font-weight:500;">상세보기 →</a></div>';
                    var hm = new kakao.maps.Marker({ position: pos, map: map }); hm.setOpacity(0);
                    kakao.maps.event.addListener(hm, 'click', function () { iw.setContent(ct); iw.open(map, hm); });
                  });
                },
                error: function () { var el = document.getElementById('mapLoading'); if (el) el.innerHTML = '<span style="color:rgba(255,253,248,.5);font-size:13px">지도 데이터를 불러올 수 없습니다</span>'; }
              });
              setTimeout(function () {
                map.relayout();
                map.setCenter(new kakao.maps.LatLng(36.5, 127.8));
              }, 800);
            });

            /* ── 5. Vue 날씨 ── */
            var vueApp = Vue.createApp({
              data: function () { return { isLoading: true, isError: false, days: [], regionName: '서울', selectedRegion: 'seoul', regionMap: { seoul: { nx: 60, ny: 127, name: '서울', taId: '11B10101', landId: '11B00000' }, gyeonggi: { nx: 60, ny: 121, name: '경기', taId: '11B20601', landId: '11B00000' }, gangwon: { nx: 73, ny: 134, name: '강원', taId: '11D10301', landId: '11D10000' }, chungbuk: { nx: 69, ny: 107, name: '충북', taId: '11C10301', landId: '11C10000' }, chungnam: { nx: 68, ny: 100, name: '충남', taId: '11C20401', landId: '11C20000' }, jeonbuk: { nx: 63, ny: 89, name: '전북', taId: '11F10201', landId: '11F10000' }, jeonnam: { nx: 51, ny: 67, name: '전남', taId: '11F20501', landId: '11F20000' }, gyeongbuk: { nx: 89, ny: 91, name: '경북', taId: '11H10501', landId: '11H10000' }, gyeongnam: { nx: 91, ny: 77, name: '경남', taId: '11H20301', landId: '11H20000' }, jeju: { nx: 52, ny: 38, name: '제주', taId: '11G00201', landId: '11G00000' } } }; },
              methods: {
                onRegionChange: function (e) { this.selectedRegion = e.target.value; var r = this.regionMap[this.selectedRegion]; this.regionName = r.name; this.loadWeather(r); },
                loadWeather: async function (region) {
                  this.isLoading = true; this.isError = false; this.days = [];
                  try {
                    var results = await Promise.all([this.fetchShort(region.nx, region.ny), this.fetchMid(region.taId, region.landId)]);
                    var sR = results[0], mR = results[1], result = [], self = this;
                    if (sR.result === 'success') {
                      var items = sR.data.response.body.items.item, today = this.getDateStr(0), tmr = this.getDateStr(1), byDate = {};
                      items.forEach(function (item) { if (!byDate[item.fcstDate]) byDate[item.fcstDate] = { temps: [] }; var d = byDate[item.fcstDate]; if (item.category === 'TMX') d.max = item.fcstValue; if (item.category === 'TMN') d.min = item.fcstValue; if (item.category === 'TMP') d.temps.push(parseFloat(item.fcstValue)); if (item.category === 'SKY' && item.fcstTime === '1200') d.sky = item.fcstValue; if (item.category === 'PTY' && item.fcstTime === '1200') d.pty = item.fcstValue; if (item.category === 'POP' && item.fcstTime === '1200') d.rain = item.fcstValue; });
                      [today, tmr].forEach(function (ds, i) { var d = byDate[ds] || { temps: [] }; var mx = d.max != null ? Math.round(d.max) : d.temps.length > 0 ? Math.max.apply(null, d.temps) : null; var mn = d.min != null ? Math.round(d.min) : d.temps.length > 0 ? Math.min.apply(null, d.temps) : null; result.push({ label: i === 0 ? '오늘' : '내일', icon: self.skyToIcon(d.sky, d.pty), max: mx != null ? mx + '°' : '-°', min: mn != null ? mn + '°' : '-°', rain: d.rain != null ? d.rain + '%' : '-%' }); });
                    }
                    if (mR.result === 'success') {
                      var ta = Array.isArray(mR.ta.response.body.items.item) ? mR.ta.response.body.items.item[0] : mR.ta.response.body.items.item;
                      var land = Array.isArray(mR.land.response.body.items.item) ? mR.land.response.body.items.item[0] : mR.land.response.body.items.item;
                      [3, 4, 5].forEach(function (d) { var dt = new Date(); dt.setDate(dt.getDate() + d); var label = (dt.getMonth() + 1) + '/' + dt.getDate(), wf = land['wf' + d + 'Am'] || ''; result.push({ label: label, icon: self.wfToIcon(wf), max: (ta['taMax' + d] != null ? ta['taMax' + d] : '-') + '°', min: (ta['taMin' + d] != null ? ta['taMin' + d] : '-') + '°', rain: (land['rnSt' + d + 'Am'] != null ? land['rnSt' + d + 'Am'] : '-') + '%' }); });
                    }
                    this.days = result;
                  } catch (e) { console.error(e); this.isError = true; }
                  this.isLoading = false;
                },
                fetchShort: function (nx, ny) { return new Promise(function (r) { $.ajax({ url: '/weather/short.dox', data: { nx: nx, ny: ny }, dataType: 'json', success: r, error: function () { r({ result: 'fail' }); } }); }); },
                fetchMid: function (taRegId, landRegId) { return new Promise(function (r) { $.ajax({ url: '/weather/mid.dox', data: { taRegId: taRegId, landRegId: landRegId }, dataType: 'json', success: r, error: function () { r({ result: 'fail' }); } }); }); },
                getDateStr: function (n) { var d = new Date(); d.setDate(d.getDate() + n); return d.getFullYear() + String(d.getMonth() + 1).padStart(2, '0') + String(d.getDate()).padStart(2, '0'); },
                skyToIcon: function (sky, pty) { var p = parseInt(pty); if (p === 1 || p === 4) return '🌧️'; if (p === 2) return '🌨️'; if (p === 3) return '❄️'; var s = parseInt(sky); if (s === 1) return '☀️'; if (s === 3) return '⛅'; if (s === 4) return '☁️'; return '🌤️'; },
                wfToIcon: function (wf) { if (!wf) return '🌤️'; if (wf.indexOf('비') > -1) return '🌧️'; if (wf.indexOf('눈') > -1) return '❄️'; if (wf.indexOf('흐림') > -1) return '☁️'; if (wf.indexOf('구름') > -1) return '⛅'; return '☀️'; }
              },
              mounted: function () { this.loadWeather(this.regionMap['seoul']); }
            });
            vueApp.mount('#weatherSection');
            /* ── 6. 토스트 ── */
            function showToast(msg) { var t = document.getElementById('toast'); t.textContent = msg; t.classList.add('show'); setTimeout(function () { t.classList.remove('show'); }, 2200); }

            /* ── 7. 상품 상세 이동 + 최근 본 상품 localStorage 저장 ── */
            function fnGoDetail(productId, productName, imgUrl) {
              var items = JSON.parse(localStorage.getItem('recentViewed') || '[]');
              items = items.filter(function (i) { return i.no !== productId; });
              items.unshift({ no: productId, name: productName, icon: imgUrl || '🏕️' });
              if (items.length > 10) items.pop();
              localStorage.setItem('recentViewed', JSON.stringify(items));
              location.href = '/product/detail.do?productId=' + productId;
            }

            /* ── 8. 인기 상품 ── */
            (function () {

              function makeStars(score) {
                var n = Math.floor(Number(score) || 0);
                var html = '';

                for (var i = 1; i <= 5; i++) {
                  html += i <= n
                    ? '<span class="star on">★</span>'
                    : '<span class="star off">☆</span>';
                }

                return html;
              }

              function renderPopular(list) {
                var grid = document.getElementById('popularGrid');
                if (!grid) return;

                var html = '';

                list.forEach(function (p) {
                  var pid = p.productId || p.PRODUCT_ID;
                  var name = p.productName || p.PRODUCT_NAME || '';
                  var cat = p.categoryName || p.CATEGORY_NAME || '';
                  var brand = p.brandName || p.BRAND_NAME || '';
                  var price = Number(p.price || p.PRICE || 0).toLocaleString();
                  var img = p.imgUrl || p.IMG_URL || '';
                  var type = p.productType || p.PRODUCT_TYPE || '';

                  var rating = p.rating ?? p.avgRating ?? p.RATING ?? p.AVG_RATING ?? 0;
                  var reviewCnt = p.rCount ?? p.reviewCount ?? p.R_COUNT ?? p.REVIEW_COUNT ?? 0;

                  var score = Number(rating);
                  if (isNaN(score)) score = 0;

                  var imgHtml = img
                    ? '<img src="' + img + '" style="width:100%;height:100%;object-fit:cover;">'
                    : '<span style="font-size:56px">🏕️</span>';

                  var catHtml = cat
                    ? '<p class="product-tag">' + cat + '</p>'
                    : '';

                  var brandHtml = brand
                    ? '<span class="product-brand">' + brand + '</span>'
                    : '';

                  var ratingHtml =
                    '<div class="product-rating">'
                    + '<span class="rating-stars">' + makeStars(score) + '</span>'
                    + '<span class="rating-score">' + score.toFixed(1) + ' (' + reviewCnt + ')</span>'
                    + '</div>';

                  var rentBtn = type !== 'PURCHASE'
                    ? '<button type="button" class="btn-rent pop-rent" data-pid="' + pid + '">대여하기</button>'
                    : '';

                  var buyBtn = type !== 'RENTAL'
                    ? '<button type="button" class="btn-buy pop-buy" data-pid="' + pid + '">구매하기</button>'
                    : '';

                  html += ''
                    + '<div class="product-card fade-up pop-card" data-pid="' + pid + '" data-name="' + name.replace(/"/g, '') + '" data-img="' + img + '">'
                    + '<div class="product-img">'
                    + imgHtml
                    + '<button type="button" class="wish-btn" data-pid="' + pid + '">'
                    + '<svg viewBox="0 0 24 24">'
                    + '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l7.78-7.78a5.5 5.5 0 0 0 1.06-8.84z"></path>'
                    + '</svg>'
                    + '</button>'
                    + '</div>'
                    + '<div class="product-info">'
                    + catHtml
                    + '<div class="product-name-line">'
                    + '<p class="product-name">' + name + '</p>'
                    + brandHtml
                    + '</div>'
                    + ratingHtml
                    + '<div class="product-price">'
                    + '<span class="price-main">' + price + '원</span>'
                    + '<span class="price-unit">' + (type !== 'PURCHASE' ? '/ 1박' : '') + '</span>'
                    + '</div>'
                    + '<div class="product-btns">'
                    + rentBtn
                    + buyBtn
                    + '</div>'
                    + '</div>'
                    + '</div>';
                });

                grid.innerHTML = html;

                grid.onclick = function (e) {
                  var wish = e.target.closest('.wish-btn');
                  var rent = e.target.closest('.pop-rent');
                  var buy = e.target.closest('.pop-buy');
                  var card = e.target.closest('.pop-card');

                  if (wish) {
                    e.preventDefault();
                    e.stopPropagation();
                    fnWish(e, wish, parseInt(wish.dataset.pid));
                    return;
                  }

                  if (rent || buy) {
                    e.preventDefault();
                    e.stopPropagation();
                    var btn = rent || buy;
                    location.href = '/product/detail.do?productId=' + btn.dataset.pid;
                    return;
                  }

                  if (card) {
                    fnGoDetail(parseInt(card.dataset.pid), card.dataset.name, card.dataset.img);
                  }
                };

                grid.querySelectorAll('.fade-up').forEach(function (el) {
                  if (typeof revealObs !== 'undefined') revealObs.observe(el);
                });
              }

              $.ajax({
                url: '/product/popularList.dox',
                type: 'POST',
                dataType: 'json',
                success: function (data) {
                  if (data.result === 'success' && data.list && data.list.length) {
                    renderPopular(data.list);

                    $.ajax({
                      url: '/user/wishlist/list.dox',
                      type: 'POST',
                      dataType: 'json',
                      success: function (wRes) {
                        if (wRes.result === 'success' && wRes.list && wRes.list.length) {
                          var wishedIds = wRes.list.map(function (w) {
                            return w.productId || w.PRODUCT_ID;
                          });

                          document.querySelectorAll('#popularGrid .wish-btn').forEach(function (btn) {
                            if (wishedIds.indexOf(parseInt(btn.dataset.pid)) !== -1) {
                              btn.classList.add('on');
                            }
                          });
                        }
                      }
                    });
                  }
                }
              });

            })();
            /* ── 9. 최근 본 상품 바 ── */
            (function () {
              var items = JSON.parse(localStorage.getItem('recentViewed') || '[]');
              if (!items.length) return;
              var html = '';
              items.slice(0, 10).forEach(function (item) {
                var iconHtml = item.icon && item.icon.startsWith('/')
                  ? '<img src="' + item.icon + '" style="width:24px;height:24px;object-fit:cover;border-radius:4px;">'
                  : '<span>' + item.icon + '</span>';
                html += '<div class="recent-item" data-pid="' + item.no + '">'
                  + iconHtml
                  + '<span style="font-size:12px;color:var(--brown2)">' + item.name + '</span></div>';
              });
              var bar = document.getElementById('recentItems');
              if (bar) {
                bar.innerHTML = html;
                bar.addEventListener('click', function (e) {
                  var el = e.target.closest('.recent-item');
                  if (el) location.href = '/product/detail.do?productId=' + el.dataset.pid;
                });
              }
              setTimeout(function () { document.getElementById('recentBar').classList.add('visible'); }, 3000);
            })();
            function closeRecent() { document.getElementById('recentBar').classList.remove('visible'); }

            /* ── 10. 위시 / 로그인 모달 ── */
            function fnOpenLoginModal() { var m = document.getElementById('loginModal'); if (m) { m.style.display = 'flex'; } }
            function fnCloseLoginModal(e) { if (!e || e.target === document.getElementById('loginModal')) { var m = document.getElementById('loginModal'); if (m) m.style.display = 'none'; } }
            document.addEventListener('keydown', function (e) { if (e.key === 'Escape') fnCloseLoginModal({ target: document.getElementById('loginModal') }); });

            function fnWish(e, btn, no) {
              e.stopPropagation();
              $.ajax({
                url: '/user/wishlist/toggle.dox', type: 'POST', data: { productId: no }, dataType: 'json',
                success: function (res) {
                  if (res.result === 'success') {
                    btn.classList.toggle('on');
                    showToast(btn.classList.contains('on') ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
                  } else { fnOpenLoginModal(); }
                },
                error: function () { fnOpenLoginModal(); }
              });
            }

            /* ── 11. 카테고리 ── */
            (function () {
              var iconMap = {
                4: 'ri-tent-line',
                5: 'ri-landscape-line',
                6: 'ri-sofa-line',
                7: 'ri-hotel-bed-line',
                8: 'ri-fire-line',
                9: 'ri-restaurant-line',
                10: 'ri-lightbulb-flash-line',
                11: 'ri-shield-check-line',
                12: 'ri-shopping-bag-3-line'
              };
              function renderCat(list) {
                var grid = document.getElementById('catGrid');
                if (!grid) return;
                var html = '';
                list.forEach(function (cat) {
                  var cid = parseInt(cat.categoryId || cat.CATEGORY_ID);
                  var pid = parseInt(cat.parentId || cat.PARENT_CATEGORY || 0);
                  var name = cat.categoryName || cat.CATEGORY_NAME || '';
                  var icon = iconMap[cid] || '🏕️';
                  html += '<div class="cat-item fade-up" data-cid="' + cid + '" data-pid="' + pid + '">'
                    + '<div class="cat-icon"><i class="' + icon + '"></i></div>'
                    + '<span class="cat-name">' + name + '</span>'
                    + '</div>';
                });
                grid.innerHTML = html;
                grid.addEventListener('click', function (e) {
                  var item = e.target.closest('.cat-item');
                  if (item) location.href = '/product/list.do?categoryId=' + item.dataset.cid + '&parentId=' + item.dataset.pid;
                });
                grid.querySelectorAll('.fade-up').forEach(function (el) { revealObs.observe(el); });
              }
              var fallback = [
                { categoryId: 4, categoryName: '텐트' }, { categoryId: 7, categoryName: '침낭·매트' },
                { categoryId: 9, categoryName: '취사도구' }, { categoryId: 10, categoryName: '조명' },
                { categoryId: 6, categoryName: '테이블·의자' }, { categoryId: 11, categoryName: '안전용품' },
                { categoryId: 12, categoryName: '기타 용품' }
              ];
              $.ajax({
                url: '/product/mainCategoryList.dox', type: 'POST', dataType: 'json',
                success: function (data) { renderCat((data.result === 'success' && data.list && data.list.length) ? data.list : fallback); },
                error: function () { renderCat(fallback); }
              });
            })();

            /* ── 12. 배너 슬라이더 ── */
            (function () {
              var themes = ['heb-card--join', 'heb-card--invite', 'heb-card--dark', 'heb-card--green', 'heb-card--join'];
              var icons = ['🎪', '🔥', '🏕️', '🌿', '🎁'];
              function fnGoBanner(eid) { if (eid) location.href = '/event/detail.do?eventId=' + eid; }

              function buildSlides(list) {
                var track = document.getElementById('hebTrack');
                var dotsWrap = document.getElementById('hebDots');
                if (!track) return;

                var slideHtml = '';
                var dotHtml = '';

                list.forEach(function (ev, i) {
                  var eid = ev.eventId || ev.EVENT_ID || '';

                  // ⭐ 첫 번째 배너 이미지 고정
                  var img = (i === 0)
                    ? "/img/banner/bannerImg2.png"
                    : "/img/banner/bannerImg1.png"; // 나머지는 기본 이미지

                  slideHtml +=
                    '<div class="heb-slide">' +
                    '<img src="' + img + '" class="heb-img" data-eid="' + eid + '">' +
                    '</div>';

                  dotHtml += '<button class="heb-dot' + (i === 0 ? ' heb-dot--on' : '') + '" data-idx="' + i + '"></button>';
                });

                track.innerHTML = slideHtml;
                dotsWrap.innerHTML = dotHtml;

                // 클릭 이동
                track.addEventListener('click', function (e) {
                  var img = e.target.closest('.heb-img');
                  if (img && img.dataset.eid) {
                    location.href = '/event/detail.do?eventId=' + img.dataset.eid;
                  }
                });

                initSlider();
              }

              function initSlider() {
                var track = document.getElementById('hebTrack');
                var dots = document.querySelectorAll('.heb-dot');
                var btnPrev = document.getElementById('hebPrev');
                var btnNext = document.getElementById('hebNext');
                var total = dots.length;
                var cur = 0;
                var timer;
                function goTo(idx) {
                  cur = (idx + total) % total;
                  track.style.transform = 'translateX(-' + (cur * 100) + '%)';
                  dots.forEach(function (d, i) { d.classList.toggle('heb-dot--on', i === cur); });
                }
                function autoPlay() { timer = setInterval(function () { goTo(cur + 1); }, 4500); }
                function resetTimer() { clearInterval(timer); autoPlay(); }
                if (btnPrev) btnPrev.addEventListener('click', function () { goTo(cur - 1); resetTimer(); });
                if (btnNext) btnNext.addEventListener('click', function () { goTo(cur + 1); resetTimer(); });
                dots.forEach(function (d) { d.addEventListener('click', function () { goTo(parseInt(d.dataset.idx)); resetTimer(); }); });
                var startX = 0;
                track.addEventListener('touchstart', function (e) { startX = e.touches[0].clientX; }, { passive: true });
                track.addEventListener('touchend', function (e) { var diff = startX - e.changedTouches[0].clientX; if (Math.abs(diff) > 40) { goTo(diff > 0 ? cur + 1 : cur - 1); resetTimer(); } });
                autoPlay();
              }

              var fallbackSlide = [{ eventId: '', title: '모닥모닥 이벤트', content: '다양한 이벤트를 확인해보세요!', startDate: '', endDate: '' }];
              $.ajax({
                url: '/event/bannerList.dox', type: 'POST', dataType: 'json',
                success: function (data) { buildSlides((data.result === 'success' && data.list && data.list.length) ? data.list : fallbackSlide); },
                error: function () { buildSlides(fallbackSlide); }
              });
            })();

            /* ── 13. 멤버십 ── */
            (function () {
              var gradeStyle = { 1: { cls: 'grade-bronze', emoji: '🥉' }, 2: { cls: 'grade-silver', emoji: '🥈' }, 3: { cls: 'grade-gold', emoji: '🥇' }, 4: { cls: 'grade-vvip', emoji: '👑' } };
              function makeBenefitList(text) {
                if (!text || text.trim() === '') return '<li>기본 혜택 제공</li>';
                return text.split(',').map(function (v) { return '<li>' + v.trim() + '</li>'; }).join('');
              }
              function renderGrades(currentGradeId, allGrades) {
                var wrap = document.getElementById('gradeListWrap');
                if (!wrap || !allGrades || !allGrades.length) return;
                var html = '';
                allGrades.forEach(function (g) {
                  var gid = parseInt(g.gradeId || g.GRADE_ID || 0);
                  var gName = g.gradeName || g.GRADE_NAME || '';
                  var gDesc = g.description || g.DESCRIPTION || '';
                  var gBene = g.benefitText || g.BENEFIT_TEXT || '';
                  var st = gradeStyle[gid] || { cls: 'grade-bronze', emoji: '🏅' };
                  var isCurr = (currentGradeId > 0 && currentGradeId === gid);
                  html += '<div class="grade-item' + (isCurr ? ' active' : '') + '">'
                    + '<span class="grade-badge ' + st.cls + (isCurr ? ' grade-current' : '') + '">'
                    + st.emoji + ' ' + gName + (isCurr ? ' ✓' : '') + '</span>'
                    + '<div class="grade-cond">' + gDesc + '</div>'
                    + '<ul class="grade-benefit-summary">' + makeBenefitList(gBene) + '</ul>'
                    + '</div>';
                });
                wrap.innerHTML = html;
              }
              function loadDefaultGrades() {
                $.ajax({
                  url: '/membership/grade/list.dox', type: 'POST', dataType: 'json',
                  success: function (res) { if (res.result === 'success' && res.grades && res.grades.length) renderGrades(-1, res.grades); else renderFallback(); },
                  error: function () { renderFallback(); }
                });
              }
              function renderFallback() {
                var wrap = document.getElementById('gradeListWrap');
                if (wrap) wrap.innerHTML = '<p style="color:rgba(255,253,248,.5);font-size:13px">멤버십 정보를 불러올 수 없습니다.</p>';
              }
              $.ajax({
                url: '/membership/info.dox', type: 'POST', dataType: 'json',
                success: function (data) {
                  if (data.result === 'success' && data.info && data.info.gradeId) {
                    var grades = data.allGrades && data.allGrades.length ? data.allGrades : null;
                    if (grades) renderGrades(parseInt(data.info.gradeId), grades); else loadDefaultGrades();
                  } else {
                    if (data.allGrades && data.allGrades.length) renderGrades(-1, data.allGrades); else loadDefaultGrades();
                  }
                },
                error: function () { loadDefaultGrades(); }
              });
            })();
          </script>
    </body>

    </html>