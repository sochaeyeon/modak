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

<%-- CSS 분리 --%>
<link rel="stylesheet" href="/css/common/header.css">
<link rel="stylesheet" href="/css/main/main.css">

<%-- JS 라이브러리 --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false"></script>
</head>
<body>

<%-- ★ 공통 헤더 include --%>
<%@ include file="/WEB-INF/common/header.jsp" %>

<!-- ════════════════ HERO ════════════════ -->
<section class="hero">
  <div class="hero-bg"></div>
  <div class="smoke-container">
    <div class="smoke" style="width:30px;height:30px;left:25px;animation-duration:5s"></div>
    <div class="smoke" style="width:40px;height:40px;left:10px;animation-duration:6s;animation-delay:1.5s"></div>
    <div class="smoke" style="width:25px;height:25px;left:35px;animation-duration:4.5s;animation-delay:3s"></div>
  </div>
  <div class="embers" id="embers"></div>
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
      <a href="/product/rental-list.do" class="btn-primary">장비 대여하기</a>
      <a href="/camp/map.do" class="btn-secondary">캠핑장 찾기</a>
    </div>
  </div>
  <div class="hero-scroll">SCROLL<div class="scroll-line"></div></div>
</section>

<!-- ════════════════ STRIP ════════════════ -->
<div class="strip">
  <div class="strip-inner">
    <span>🔥 일산화탄소 경보기 대여 가능</span><span class="strip-dot"> ✦ </span>
    <span>텐트·침낭·취사도구 전 품목 당일 배송</span><span class="strip-dot"> ✦ </span>
    <span>신규 회원 첫 대여 15% 할인 쿠폰 제공</span><span class="strip-dot"> ✦ </span>
    <span>캠핑장 500곳+ 실시간 예약 가능</span><span class="strip-dot"> ✦ </span>
    <span>파손 보험 가입으로 걱정 없는 캠핑</span><span class="strip-dot"> ✦ </span>
    <span>🔥 일산화탄소 경보기 대여 가능</span><span class="strip-dot"> ✦ </span>
    <span>텐트·침낭·취사도구 전 품목 당일 배송</span><span class="strip-dot"> ✦ </span>
    <span>신규 회원 첫 대여 15% 할인 쿠폰 제공</span><span class="strip-dot"> ✦ </span>
    <span>캠핑장 500곳+ 실시간 예약 가능</span><span class="strip-dot"> ✦ </span>
    <span>파손 보험 가입으로 걱정 없는 캠핑</span><span class="strip-dot"> ✦ </span>
  </div>
</div>

<!-- ════════════════ CATEGORIES ════════════════ -->
<section class="section" style="text-align:center">
  <p class="section-label">카테고리</p>
  <h2 class="section-title">필요한 모든 장비</h2>
  <p class="section-sub">대여 또는 구매로 당신의 캠핑을 완성하세요</p>
  <div class="cat-grid">
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=tent'">
      <div class="cat-icon">⛺</div><span class="cat-name">텐트</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=sleeping'">
      <div class="cat-icon">🛏️</div><span class="cat-name">침낭·매트</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=cooking'">
      <div class="cat-icon">🍳</div><span class="cat-name">취사도구</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=light'">
      <div class="cat-icon">💡</div><span class="cat-name">조명</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=chair'">
      <div class="cat-icon">🪑</div><span class="cat-name">테이블·의자</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=safety'">
      <div class="cat-icon">🔒</div><span class="cat-name">안전용품</span>
    </div>
    <div class="cat-item fade-up" onclick="location.href='/product/product-list.do?category=etc'">
      <div class="cat-icon">🎒</div><span class="cat-name">기타 용품</span>
    </div>
  </div>
</section>

<!-- ════════════════ PRODUCTS ════════════════ -->
<section class="section-alt">
  <div class="section-header">
    <div>
      <p class="section-label">인기 장비</p>
      <h2 class="section-title" style="margin-bottom:0">지금 많이 찾는 장비</h2>
    </div>
    <a href="/product/product-list.do" class="view-all">전체보기</a>
  </div>
  <div class="product-grid">
    <div class="product-card fade-up" onclick="fnGoDetail(1)">
      <div class="product-img">⛺
        <span class="product-badge">인기</span>
        <button class="product-wish" onclick="fnWish(event,this,1)"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></button>
      </div>
      <div class="product-info">
        <p class="product-tag">텐트 · 4인용</p>
        <p class="product-name">스노우피크 랜드록 2024</p>
        <div class="product-stars"><span class="star">★★★★★</span><span class="product-reviews">(128)</span></div>
        <div class="product-price"><span class="price-main">35,000</span><span class="price-unit">원/1박</span><span class="price-sale">45,000원</span></div>
        <div class="product-btns">
          <button class="btn-rent" onclick="fnAddRental(event,1)">대여하기</button>
          <button class="btn-buy"  onclick="fnAddCart(event,1)">구매하기</button>
        </div>
      </div>
    </div>
    <div class="product-card fade-up" onclick="fnGoDetail(2)">
      <div class="product-img">🔥
        <span class="product-badge">⚠ 안전</span>
        <button class="product-wish" onclick="fnWish(event,this,2)"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></button>
      </div>
      <div class="product-info">
        <p class="product-tag">안전용품 · 필수</p>
        <p class="product-name">일산화탄소 경보기</p>
        <div class="product-stars"><span class="star">★★★★★</span><span class="product-reviews">(256)</span></div>
        <div class="product-price"><span class="price-main">3,000</span><span class="price-unit">원/1박</span></div>
        <div class="product-btns">
          <button class="btn-rent" onclick="fnAddRental(event,2)">대여하기</button>
          <button class="btn-buy"  onclick="fnAddCart(event,2)">구매하기</button>
        </div>
      </div>
    </div>
    <div class="product-card fade-up" onclick="fnGoDetail(3)">
      <div class="product-img">🛏️
        <button class="product-wish" onclick="fnWish(event,this,3)"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></button>
      </div>
      <div class="product-info">
        <p class="product-tag">침낭 · 동계용</p>
        <p class="product-name">나낙 레인저 -15℃ 구스다운</p>
        <div class="product-stars"><span class="star">★★★★☆</span><span class="product-reviews">(74)</span></div>
        <div class="product-price"><span class="price-main">12,000</span><span class="price-unit">원/1박</span></div>
        <div class="product-btns">
          <button class="btn-rent" onclick="fnAddRental(event,3)">대여하기</button>
          <button class="btn-buy"  onclick="fnAddCart(event,3)">구매하기</button>
        </div>
      </div>
    </div>
    <div class="product-card fade-up" onclick="fnGoDetail(4)">
      <div class="product-img">🍳
        <span class="product-badge">NEW</span>
        <button class="product-wish" onclick="fnWish(event,this,4)"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></button>
      </div>
      <div class="product-info">
        <p class="product-tag">취사도구 · 세트</p>
        <p class="product-name">코베아 캠핑 쿡웨어 5종 세트</p>
        <div class="product-stars"><span class="star">★★★★★</span><span class="product-reviews">(41)</span></div>
        <div class="product-price"><span class="price-main">18,000</span><span class="price-unit">원/1박</span></div>
        <div class="product-btns">
          <button class="btn-rent" onclick="fnAddRental(event,4)">대여하기</button>
          <button class="btn-buy"  onclick="fnAddCart(event,4)">구매하기</button>
        </div>
      </div>
    </div>
  </div>
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
    <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:40px;flex-wrap:wrap;gap:16px">
      <div>
        <p class="section-label">날씨 · 안전</p>
        <h2 class="section-title" style="margin-bottom:0">안전하고 즐거운 캠핑을 위해</h2>
      </div>
      <div style="display:flex;align-items:center;gap:10px;background:var(--white);border-radius:50px;
                  padding:8px 8px 8px 18px;border:1.5px solid var(--cream3);
                  box-shadow:0 2px 12px rgba(44,30,15,.06)">
        <span style="font-size:13px;color:var(--brown3);white-space:nowrap">📍 지역</span>
        <select @change="onRegionChange"
                style="border:none;outline:none;background:transparent;
                       font-size:13px;font-weight:600;color:var(--brown2);
                       font-family:'Noto Sans KR',sans-serif;cursor:pointer;padding-right:8px">
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
      <div style="background:var(--white);border-radius:24px;padding:32px;
                  box-shadow:0 4px 24px rgba(44,30,15,.07);border:1px solid var(--cream3)">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:24px">
          <div>
            <p style="font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:4px">FORECAST</p>
            <p style="font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:700;color:var(--brown)">
              {{ regionName }} 날씨 예보
            </p>
          </div>
          <div style="font-size:44px;line-height:1">{{ days.length > 0 ? days[0].icon : '🌤️' }}</div>
        </div>
        <div v-if="isLoading" style="display:flex;gap:10px;margin-bottom:24px">
          <div v-for="n in 5" :key="n" class="skel" style="flex:1;height:120px;border-radius:16px"></div>
        </div>
        <div v-else-if="!isError && days.length > 0"
             style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-bottom:20px">
          <div v-for="(d, i) in days" :key="i"
               :style="{borderRadius:'16px',padding:'16px 8px',textAlign:'center',
                        background:i<2?'linear-gradient(160deg,#FBE8DC,#FDF3EE)':'var(--cream)',
                        border:i<2?'1.5px solid rgba(232,115,42,.25)':'1.5px solid var(--cream3)',
                        transition:'transform .2s',cursor:'default'}"
               @mouseenter="$event.currentTarget.style.transform='translateY(-3px)'"
               @mouseleave="$event.currentTarget.style.transform='translateY(0)'">
            <div style="font-size:12px;font-weight:700;color:var(--brown2);margin-bottom:2px">{{ d.label }}</div>
            <div :style="{display:'inline-block',fontSize:'9px',fontWeight:'600',padding:'2px 7px',
                          borderRadius:'10px',marginBottom:'10px',
                          background:i<2?'rgba(232,115,42,.15)':'var(--cream2)',
                          color:i<2?'var(--orange)':'var(--brown4)'}">
              {{ i < 2 ? '단기' : '중기' }}
            </div>
            <div style="font-size:30px;line-height:1;margin-bottom:10px">{{ d.icon }}</div>
            <div style="font-size:16px;font-weight:800;color:var(--orange);margin-bottom:2px">{{ d.max }}</div>
            <div style="font-size:12px;color:var(--brown4);margin-bottom:8px">{{ d.min }}</div>
            <div style="display:inline-flex;align-items:center;gap:3px;font-size:10px;color:var(--brown3);
                        background:var(--cream2);border-radius:8px;padding:3px 7px">
              <span>🌧</span><span>{{ d.rain }}</span>
            </div>
          </div>
        </div>
        <div v-else style="text-align:center;padding:32px 0;color:var(--brown4);font-size:13px;margin-bottom:20px">
          날씨 정보를 불러올 수 없습니다.
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px">
          <p style="font-size:11px;color:var(--brown4)">
            <span style="display:inline-block;width:10px;height:10px;border-radius:3px;
                         background:#FBE8DC;border:1px solid rgba(232,115,42,.3);margin-right:4px;vertical-align:middle"></span>단기예보
            &nbsp;
            <span style="display:inline-block;width:10px;height:10px;border-radius:3px;
                         background:var(--cream2);border:1px solid var(--cream3);margin-right:4px;vertical-align:middle"></span>중기예보
          </p>
          <div class="weather-tags">
            <span class="weather-tag on" @click="fnWeatherTab($event)">5일 예보</span>
            <span class="weather-tag"   @click="fnWeatherTab($event)">주간 예보</span>
            <span class="weather-tag"   @click="fnWeatherTab($event)">지역 검색</span>
          </div>
        </div>
      </div>
      <div style="background:var(--white);border-radius:24px;padding:32px;
                  box-shadow:0 4px 24px rgba(44,30,15,.07);border:1px solid var(--cream3)">
        <div style="display:flex;align-items:center;gap:12px;margin-bottom:20px">
          <div style="width:48px;height:48px;background:#FFE8E8;border-radius:50%;
                      display:flex;align-items:center;justify-content:center;font-size:22px">🛡️</div>
          <div>
            <p style="font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:2px">SAFETY</p>
            <p style="font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:700;color:var(--brown)">캠핑 안전 수칙</p>
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
        <div class="guide-icon-row"><span class="guide-emoji">📹</span><p class="guide-card-title">설치 가이드 영상</p></div>
        <p class="guide-card-text">텐트, 타프, 취사도구 등 장비별 상세 설치 영상을 제공합니다. 초보 캠퍼도 쉽게 따라할 수 있어요.</p>
        <span class="guide-link">영상 보러가기</span>
      </div>
      <div class="guide-card fade-up" onclick="location.href='/guide/guide.do'">
        <div class="guide-num">02</div>
        <div class="guide-icon-row"><span class="guide-emoji">📱</span><p class="guide-card-title">QR 코드 매뉴얼</p></div>
        <p class="guide-card-text">장비 수령 시 QR코드를 스캔하면 해당 제품의 상세 매뉴얼을 즉시 확인할 수 있습니다.</p>
        <span class="guide-link">QR 사용법 보기</span>
      </div>
      <div class="guide-card fade-up" onclick="location.href='/guide/guide.do'">
        <div class="guide-num">03</div>
        <div class="guide-icon-row"><span class="guide-emoji">♻️</span><p class="guide-card-title">분리수거 가이드</p></div>
        <p class="guide-card-text">자연을 지키는 올바른 캠핑 문화. 캠핑장별 쓰레기 분리수거 규정과 방법을 안내해드립니다.</p>
        <span class="guide-link">가이드 확인하기</span>
      </div>
    </div>
  </div>
</section>

<!-- ════════════════ MEMBERSHIP ════════════════ -->
<section class="member-banner">
  <div class="member-inner">
    <div>
      <h2 class="member-title">더 많이 이용할수록<br>더 큰 혜택을</h2>
      <p class="member-sub">이용 횟수와 금액에 따라 등급이 올라가며<br>할인 쿠폰, 전용 상품, 우선 예약 혜택을 드립니다.</p>
      <div class="grade-list">
        <div><span class="grade-badge grade-bronze">BRONZE</span><div class="grade-name">일반 회원</div></div>
        <div><span class="grade-badge grade-silver">SILVER</span><div class="grade-name">5회 이상</div></div>
        <div><span class="grade-badge grade-gold">GOLD</span><div class="grade-name">15회 이상</div></div>
      </div>
    </div>
    <div class="member-actions">
      <button class="btn-primary" onclick="location.href='/user/sign-up.do'">회원가입 하기</button>
      <a href="/membership/info.do" class="btn-secondary" style="text-align:center">멤버십 혜택 보기</a>
    </div>
  </div>
</section>

<!-- ════════════════ FOOTER ════════════════ -->
<footer>
  <div class="footer-top">
    <div class="footer-brand">
      <a href="/main.do" class="nav-logo" style="color:var(--cream)">
        <svg class="logo-flame" viewBox="0 0 24 24" fill="none">
          <path d="M12 2C10 6 6 8 8 13C9 16 11 17 12 22C13 17 15 16 16 13C18 8 14 6 12 2Z" fill="#E8732A"/>
          <path d="M12 8C11 10 9 11 10 14C10.5 16 11.5 17 12 20C12.5 17 13.5 16 14 14C15 11 13 10 12 8Z" fill="#F5C842"/>
        </svg>
        모닥모닥
      </a>
      <p>함께 만들어가는 따뜻한 캠핑 라이프.<br>합리적인 대여와 구매로 더 많은 사람이 캠핑을 즐길 수 있도록.</p>
    </div>
    <div class="footer-col">
      <h5>서비스</h5>
      <a href="/product/rental-list.do">대여하기</a>
      <a href="/product/product-list.do">구매하기</a>
      <a href="/camp/map.do">캠핑장 예약</a>
      <a href="#">날씨 정보</a>
      <a href="/board/guide-detail.do?no=1">이용가이드</a>
    </div>
    <div class="footer-col">
      <h5>마이페이지</h5>
      <a href="/mypage.do">회원정보</a>
      <a href="/order/order-history.do">예약 내역</a>
      <a href="/order/order-history.do">주문 내역</a>
      <a href="/wishlist.do">찜 목록</a>
      <a href="/cart/cart.do">장바구니</a>
    </div>
    <div class="footer-col">
      <h5>고객지원</h5>
      <a href="#">공지사항</a>
      <a href="#">자주 묻는 질문</a>
      <a href="/inquiry/inquiry-form.do">1:1 문의</a>
      <a href="#">이용 약관</a>
      <a href="#">개인정보처리방침</a>
    </div>
    <div class="footer-col footer-contact">
      <h5>고객센터</h5>
      <p class="phone">1588-0000</p>
      <p class="hours">평일 09:00 — 18:00<br>주말 · 공휴일 휴무</p>
      <a href="mailto:hello@modakmodak.com">hello@modakmodak.com</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p class="footer-copy">© 2025 모닥모닥. All Rights Reserved.</p>
    <div class="footer-links">
      <a href="#">이용약관</a>
      <a href="#">개인정보처리방침</a>
      <a href="#">청소년보호정책</a>
    </div>
  </div>
</footer>

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

<!-- 검색 모달 -->
<div class="search-overlay" id="searchOverlay" onclick="closeSearch(event)">
  <div class="search-box" onclick="event.stopPropagation()">
    <div class="search-input-row">
      <svg viewBox="0 0 24 24" style="width:22px;height:22px;stroke:var(--brown3);fill:none;stroke-width:1.5;flex-shrink:0">
        <circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35" stroke-linecap="round"/>
      </svg>
      <input type="text" class="search-input" id="searchInput"
             placeholder="텐트, 침낭, 캠핑장 검색..."
             onkeydown="if(event.key==='Enter')fnSearch()">
    </div>
    <p class="search-tags-title">인기 검색어</p>
    <div class="search-tags">
      <span class="search-tag" onclick="fnFillSearch('텐트')">텐트</span>
      <span class="search-tag" onclick="fnFillSearch('침낭')">침낭</span>
      <span class="search-tag" onclick="fnFillSearch('일산화탄소 경보기')">일산화탄소 경보기</span>
      <span class="search-tag" onclick="fnFillSearch('취사도구')">취사도구</span>
      <span class="search-tag" onclick="fnFillSearch('랜턴')">랜턴</span>
      <span class="search-tag" onclick="fnFillSearch('캠핑 의자')">캠핑 의자</span>
      <span class="search-tag" onclick="fnFillSearch('가평 캠핑장')">가평 캠핑장</span>
    </div>
  </div>
</div>

<!-- 토스트 -->
<div class="toast" id="toast"></div>

<script>
/* 1. 불씨 */
(function(){
    var ec=document.getElementById('embers');
    var cols=['rgba(255,120,20,.9)','rgba(255,80,0,.85)','rgba(255,180,30,.8)','rgba(220,60,0,.75)','rgba(255,140,40,.7)'];
    function mk(){if(!ec)return;var el=document.createElement('div');el.className='ember';var s=Math.random()*4+1.5,l=Math.random()*160+70,d=Math.random()*3+2.5,dx=(Math.random()-.5)*120,c=cols[Math.floor(Math.random()*cols.length)];el.style.cssText='width:'+s+'px;height:'+s+'px;left:'+l+'px;bottom:0;background:'+c+';box-shadow:0 0 '+(s*2)+'px '+c+';--dx:'+dx+'px;animation-duration:'+d+'s;';ec.appendChild(el);setTimeout(function(){el.parentNode&&el.parentNode.removeChild(el);},d*1000);}
    setInterval(mk,220);for(var i=0;i<12;i++)setTimeout(mk,i*180);
})();

/* 2. 스크롤 리빌 + 네비 */
var revealObs=new IntersectionObserver(function(entries){entries.forEach(function(e){if(e.isIntersecting)e.target.classList.add('visible');});},{threshold:.12});
document.querySelectorAll('.fade-up').forEach(function(el){revealObs.observe(el);});
window.addEventListener('scroll',function(){document.getElementById('mainNav').classList.toggle('scrolled',window.scrollY>40);});

/* 3. 카카오맵 */
kakao.maps.load(function(){
    var container=document.getElementById('mainMap');if(!container)return;
    var map=new kakao.maps.Map(container,{center:new kakao.maps.LatLng(36.5,127.8),level:11,scrollwheel:false});
    map.addControl(new kakao.maps.ZoomControl(),kakao.maps.ControlPosition.RIGHT);
    var iw=new kakao.maps.InfoWindow({zIndex:10});
    $.ajax({url:'/camp/list.dox',type:'POST',dataType:'json',
        success:function(data){
            var el=document.getElementById('mapLoading');if(el)el.classList.add('hide');
            if(!data||!data.list)return;
            data.list.slice(0,80).forEach(function(item){
                var lat=parseFloat(item.mapY),lng=parseFloat(item.mapX);
                if(!lat||!lng||lat<30||lat>40||lng<120||lng>135)return;
                var pos=new kakao.maps.LatLng(lat,lng);
                var ov=new kakao.maps.CustomOverlay({position:pos,yAnchor:0.5,zIndex:3,
                    content:'<div style="width:12px;height:12px;background:#E8732A;border:2px solid rgba(255,253,248,.85);border-radius:50%;box-shadow:0 2px 6px rgba(232,115,42,.55);cursor:pointer"></div>'});
                ov.setMap(map);
                var ct='<div style="padding:10px 14px;font-size:12px;max-width:180px;line-height:1.6;font-family:Noto Sans KR,sans-serif;"><b style="color:#E8732A;display:block;margin-bottom:3px;">⛺ '+item.facltNm+'</b><span style="color:#666;">'+(item.addr1||'')+'</span><br><a href="/camp/map.do" style="color:#E8732A;font-size:11px;font-weight:500;">상세보기 →</a></div>';
                var hm=new kakao.maps.Marker({position:pos,map:map});hm.setOpacity(0);
                kakao.maps.event.addListener(hm,'click',function(){iw.setContent(ct);iw.open(map,hm);});
            });
        },
        error:function(){var el=document.getElementById('mapLoading');if(el)el.innerHTML='<span style="color:rgba(255,253,248,.5);font-size:13px">지도 데이터를 불러올 수 없습니다</span>';}
    });
    setTimeout(function(){map.relayout();},400);
});

/* 4. Vue 날씨 */
const{createApp}=Vue;
createApp({
    data(){return{isLoading:true,isError:false,days:[],regionName:'서울',selectedRegion:'seoul',
        regionMap:{
            seoul:{nx:60,ny:127,name:'서울',taId:'11B10101',landId:'11B00000'},
            gyeonggi:{nx:60,ny:121,name:'경기',taId:'11B20601',landId:'11B00000'},
            gangwon:{nx:73,ny:134,name:'강원',taId:'11D10301',landId:'11D10000'},
            chungbuk:{nx:69,ny:107,name:'충북',taId:'11C10301',landId:'11C10000'},
            chungnam:{nx:68,ny:100,name:'충남',taId:'11C20401',landId:'11C20000'},
            jeonbuk:{nx:63,ny:89,name:'전북',taId:'11F10201',landId:'11F10000'},
            jeonnam:{nx:51,ny:67,name:'전남',taId:'11F20501',landId:'11F20000'},
            gyeongbuk:{nx:89,ny:91,name:'경북',taId:'11H10501',landId:'11H10000'},
            gyeongnam:{nx:91,ny:77,name:'경남',taId:'11H20301',landId:'11H20000'},
            jeju:{nx:52,ny:38,name:'제주',taId:'11G00201',landId:'11G00000'}
        }};},
    methods:{
        onRegionChange(e){this.selectedRegion=e.target.value;const r=this.regionMap[this.selectedRegion];this.regionName=r.name;this.loadWeather(r);},
        async loadWeather(region){
            this.isLoading=true;this.isError=false;this.days=[];
            try{
                const[sR,mR]=await Promise.all([this.fetchShort(region.nx,region.ny),this.fetchMid(region.taId,region.landId)]);
                const result=[];
                if(sR.result==='success'){
                    const items=sR.data.response.body.items.item;
                    const today=this.getDateStr(0),tmr=this.getDateStr(1),byDate={};
                    items.forEach(item=>{if(!byDate[item.fcstDate])byDate[item.fcstDate]={temps:[]};const d=byDate[item.fcstDate];if(item.category==='TMX')d.max=item.fcstValue;if(item.category==='TMN')d.min=item.fcstValue;if(item.category==='TMP')d.temps.push(parseFloat(item.fcstValue));if(item.category==='SKY'&&item.fcstTime==='1200')d.sky=item.fcstValue;if(item.category==='PTY'&&item.fcstTime==='1200')d.pty=item.fcstValue;if(item.category==='POP'&&item.fcstTime==='1200')d.rain=item.fcstValue;});
                    [today,tmr].forEach((ds,i)=>{const d=byDate[ds]||{temps:[]};const mx=d.max!=null?Math.round(d.max):d.temps.length>0?Math.max(...d.temps):null;const mn=d.min!=null?Math.round(d.min):d.temps.length>0?Math.min(...d.temps):null;result.push({label:i===0?'오늘':'내일',icon:this.skyToIcon(d.sky,d.pty),max:mx!=null?mx+'°':'-°',min:mn!=null?mn+'°':'-°',rain:d.rain!=null?d.rain+'%':'-%'});});
                }
                if(mR.result==='success'){
                    const ta=Array.isArray(mR.ta.response.body.items.item)?mR.ta.response.body.items.item[0]:mR.ta.response.body.items.item;
                    const land=Array.isArray(mR.land.response.body.items.item)?mR.land.response.body.items.item[0]:mR.land.response.body.items.item;
                    [3,4,5].forEach(d=>{const dt=new Date();dt.setDate(dt.getDate()+d);const label=(dt.getMonth()+1)+'/'+dt.getDate();const wf=land['wf'+d+'Am']||'';result.push({label,icon:this.wfToIcon(wf),max:(ta['taMax'+d]!=null?ta['taMax'+d]:'-')+'°',min:(ta['taMin'+d]!=null?ta['taMin'+d]:'-')+'°',rain:(land['rnSt'+d+'Am']!=null?land['rnSt'+d+'Am']:'-')+'%'});});
                }
                this.days=result;
            }catch(e){console.error(e);this.isError=true;}
            this.isLoading=false;
        },
        fetchShort(nx,ny){return new Promise(r=>{$.ajax({url:'/weather/short.dox',data:{nx,ny},dataType:'json',success:r,error:()=>r({result:'fail'})});});},
        fetchMid(taRegId,landRegId){return new Promise(r=>{$.ajax({url:'/weather/mid.dox',data:{taRegId,landRegId},dataType:'json',success:r,error:()=>r({result:'fail'})});});},
        getDateStr(n){const d=new Date();d.setDate(d.getDate()+n);return d.getFullYear()+String(d.getMonth()+1).padStart(2,'0')+String(d.getDate()).padStart(2,'0');},
        skyToIcon(sky,pty){const p=parseInt(pty);if(p===1||p===4)return'🌧️';if(p===2)return'🌨️';if(p===3)return'❄️';const s=parseInt(sky);if(s===1)return'☀️';if(s===3)return'⛅';if(s===4)return'☁️';return'🌤️';},
        wfToIcon(wf){if(!wf)return'🌤️';if(wf.includes('비'))return'🌧️';if(wf.includes('눈'))return'❄️';if(wf.includes('흐림'))return'☁️';if(wf.includes('구름'))return'⛅';return'☀️';},
        fnWeatherTab(e){document.querySelectorAll('.weather-tag').forEach(t=>t.classList.remove('on'));e.target.classList.add('on');}
    },
    mounted(){this.loadWeather(this.regionMap['seoul']);}
}).mount('#weatherSection');

/* 5. 토스트 */
function showToast(msg){var t=document.getElementById('toast');t.textContent=msg;t.classList.add('show');setTimeout(function(){t.classList.remove('show');},2200);}

/* 6. 상품 */
var PM={1:{no:1,name:'스노우피크 랜드록',icon:'⛺'},2:{no:2,name:'일산화탄소 경보기',icon:'🔥'},3:{no:3,name:'나낙 레인저 침낭',icon:'🛏️'},4:{no:4,name:'코베아 쿡웨어',icon:'🍳'}};
function fnGoDetail(no){var items=JSON.parse(localStorage.getItem('recentViewed')||'[]');items=items.filter(function(i){return i.no!==no;});items.unshift(PM[no]);if(items.length>5)items.pop();localStorage.setItem('recentViewed',JSON.stringify(items));location.href='/product/product-detail.do?no='+no;}
(function(){var items=JSON.parse(localStorage.getItem('recentViewed')||'[]');if(!items.length)return;var html='';items.slice(0,5).forEach(function(item){html+='<div class="recent-item" onclick="location.href=\'/product/product-detail.do?no='+item.no+'\'">'+'<span>'+item.icon+'</span><span style="font-size:12px;color:var(--brown2)">'+item.name+'</span></div>';});document.getElementById('recentItems').innerHTML=html;setTimeout(function(){document.getElementById('recentBar').classList.add('visible');},3000);})();
function closeRecent(){document.getElementById('recentBar').classList.remove('visible');}

/* 7. 위시 / 장바구니 */
function fnWish(e,btn,no){e.stopPropagation();$.ajax({url:'/product/toggleWish.dox',type:'POST',data:{productNo:no},success:function(res){var r=JSON.parse(res);if(r.result==='success'){btn.classList.toggle('on');showToast(btn.classList.contains('on')?'♥ 위시리스트에 추가됐어요':'위시리스트에서 제거됐어요');}else{showToast('로그인이 필요합니다');setTimeout(function(){location.href='/user/login.do';},1200);}}});}
function fnAddRental(e,no){e.stopPropagation();$.ajax({url:'/cart/addCart.dox',type:'POST',data:{productNo:no,cartType:'rental'},success:function(res){var r=JSON.parse(res);if(r.result==='success')showToast('🏕️ 대여 장바구니에 담겼어요!');else{showToast('로그인이 필요합니다');setTimeout(function(){location.href='/user/login.do';},1200);}}});}
function fnAddCart(e,no){e.stopPropagation();$.ajax({url:'/cart/addCart.dox',type:'POST',data:{productNo:no,cartType:'buy'},success:function(res){var r=JSON.parse(res);if(r.result==='success')showToast('🛒 장바구니에 담겼어요!');else{showToast('로그인이 필요합니다');setTimeout(function(){location.href='/user/login.do';},1200);}}});}

/* 8. 검색 */
function openSearch(){document.getElementById('searchOverlay').classList.add('open');document.getElementById('searchInput').focus();}
function closeSearch(e){if(e.target===document.getElementById('searchOverlay'))document.getElementById('searchOverlay').classList.remove('open');}
function fnFillSearch(v){document.getElementById('searchInput').value=v;}
function fnSearch(){var kw=document.getElementById('searchInput').value.trim();if(kw)location.href='/product/product-search.do?keyword='+encodeURIComponent(kw);}
document.addEventListener('keydown',function(e){if(e.key==='Escape')document.getElementById('searchOverlay').classList.remove('open');});
function toggleMenu(){showToast('전체 메뉴 준비 중입니다');}
</script>
</body>
</html>
