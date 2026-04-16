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

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%-- Vue3 (날씨 섹션 반응형 처리용) --%>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<%-- 카카오맵 SDK: autoload=false 필수 --%>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false"></script>

<style>
/* ══════════════════════════════
   기본 변수 & 리셋
══════════════════════════════ */
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --cream:#F6F0E6; --cream2:#EDE5D4; --cream3:#E2D8C3;
  --orange:#E8732A; --orange2:#C4621E; --amber:#D4932A;
  --brown:#2C1E0F; --brown2:#5C4230; --brown3:#8B6B4A;
  --brown4:#B89A7A; --white:#FFFDF8;
}
html{scroll-behavior:smooth}
body{font-family:'Noto Sans KR',sans-serif;background:var(--cream);color:var(--brown);overflow-x:hidden}
a{text-decoration:none;color:inherit}

/* ══════════════════════════════
   NAV
══════════════════════════════ */
nav{
  position:fixed;top:0;left:0;right:0;z-index:200;
  background:rgba(246,240,230,0.93);backdrop-filter:blur(12px);
  border-bottom:1px solid var(--cream2);height:64px;
  display:flex;align-items:center;justify-content:space-between;padding:0 48px;
  transition:box-shadow .3s;
}
nav.scrolled{box-shadow:0 2px 20px rgba(44,30,15,.1)}
.nav-left{display:flex;align-items:center;gap:32px}
.nav-ham{display:flex;flex-direction:column;gap:5px;cursor:pointer;padding:4px}
.nav-ham span{width:22px;height:1.5px;background:var(--brown2);display:block}
.nav-logo{
  font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:800;
  color:var(--brown);display:flex;align-items:center;gap:8px;
}
.logo-flame{width:22px;height:22px}
.nav-menu{display:flex;gap:28px;list-style:none}
.nav-menu a{font-size:13px;color:var(--brown2);transition:color .2s}
.nav-menu a:hover{color:var(--orange)}
.nav-right{display:flex;align-items:center;gap:20px}
.nav-icon{width:38px;height:38px;display:flex;align-items:center;justify-content:center;
  cursor:pointer;border-radius:50%;transition:background .2s;position:relative;border:none;background:transparent}
.nav-icon:hover{background:var(--cream2)}
.nav-icon svg{width:20px;height:20px;stroke:var(--brown2);fill:none;stroke-width:1.5}
.nav-badge{position:absolute;top:4px;right:4px;width:16px;height:16px;background:var(--orange);
  border-radius:50%;font-size:10px;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:600}
.btn-login{background:var(--brown);color:var(--cream);font-size:13px;padding:8px 22px;
  border-radius:24px;border:none;cursor:pointer;transition:background .2s}
.btn-login:hover{background:var(--orange)}

/* ══════════════════════════════
   HERO + 불꽃 (문서4 방식)
══════════════════════════════ */
.hero{min-height:100vh;display:flex;flex-direction:column;align-items:center;
  justify-content:center;text-align:center;padding-top:64px;position:relative;overflow:hidden}
.hero-bg{position:absolute;inset:0;
  background:radial-gradient(ellipse 70% 60% at 50% 60%,#EDE0C4 0%,var(--cream) 70%);z-index:0}
.smoke-container{position:absolute;bottom:48%;left:50%;transform:translateX(-50%);width:80px;pointer-events:none;z-index:2}
.smoke{position:absolute;bottom:0;border-radius:50%;
  background:radial-gradient(circle,rgba(180,150,110,.22) 0%,transparent 70%);animation:smokeRise linear infinite}
@keyframes smokeRise{0%{transform:translateY(0) scale(1);opacity:0}10%{opacity:.6}100%{transform:translateY(-280px) scale(4);opacity:0}}
.embers{position:absolute;bottom:120px;left:50%;transform:translateX(-50%);
  width:300px;height:400px;pointer-events:none;z-index:2}
.ember{position:absolute;border-radius:50%;animation:emberFloat linear infinite}
@keyframes emberFloat{0%{transform:translateY(0) translateX(0) scale(1);opacity:1}70%{opacity:.8}100%{transform:translateY(-380px) translateX(var(--dx)) scale(.2);opacity:0}}
.campfire-wrap{width:200px;display:flex;flex-direction:column;align-items:center;z-index:5;margin-bottom:16px}
.flames{position:relative;width:100px;height:80px;margin-bottom:-8px;z-index:2}
.flame{position:absolute;bottom:0;border-radius:50% 50% 35% 35%;transform-origin:bottom center;animation:flicker ease-in-out infinite alternate}
.flame-outer{width:90px;height:70px;left:5px;background:radial-gradient(ellipse at 50% 85%,#ff6b00 0%,#e84800 30%,#c43000 60%,transparent 100%);animation-duration:.9s;opacity:.85}
.flame-mid  {width:65px;height:55px;left:17px;background:radial-gradient(ellipse at 50% 85%,#ffaa00 0%,#ff7800 40%,#e84800 70%,transparent 100%);animation-duration:.7s;animation-delay:.1s}
.flame-inner{width:40px;height:38px;left:30px;background:radial-gradient(ellipse at 50% 85%,#fff0a0 0%,#ffcc00 30%,#ffaa00 60%,transparent 100%);animation-duration:.55s;animation-delay:.2s}
.flame-core {width:18px;height:22px;left:41px;background:radial-gradient(ellipse at 50% 80%,#fffde0 0%,#fff5b0 50%,transparent 100%);animation-duration:.45s}
@keyframes flicker{
  0%  {transform:scaleX(1)    scaleY(1)    rotate(-1deg)}
  25% {transform:scaleX(1.03) scaleY(.97)  rotate(.5deg)}
  50% {transform:scaleX(.97)  scaleY(1.03) rotate(-.5deg)}
  75% {transform:scaleX(1.02) scaleY(.98)  rotate(1deg)}
  100%{transform:scaleX(.99)  scaleY(1.02) rotate(-1.5deg)}
}
.logs{width:140px;height:22px;position:relative;z-index:3}
.log{position:absolute;height:14px;border-radius:7px;background:linear-gradient(to bottom,#5a3010,#2e1608)}
.log::after{content:'';position:absolute;inset:2px 8px;border-radius:5px;background:linear-gradient(to bottom,#7a4520 0%,transparent 100%)}
.log-1{width:120px;left:10px;top:8px;transform:rotate(-10deg)}
.log-2{width:110px;left:15px;top:6px;transform:rotate(12deg)}
.log-3{width:90px;left:25px;top:2px;transform:rotate(-3deg);background:linear-gradient(to bottom,#3d1e09,#1a0905)}
.ember-glow{position:absolute;bottom:3px;left:30px;width:80px;height:10px;border-radius:50%;
  background:radial-gradient(ellipse,rgba(255,120,10,.6) 0%,rgba(200,60,0,.3) 50%,transparent 70%);
  animation:emberPulse 1.8s ease-in-out infinite alternate}
@keyframes emberPulse{from{opacity:.7;transform:scaleX(1)}to{opacity:1;transform:scaleX(1.1)}}
.hero-content{position:relative;z-index:10}
.hero-badge{display:inline-block;background:var(--cream2);color:var(--orange2);font-size:11px;
  letter-spacing:1.5px;padding:6px 16px;border-radius:20px;margin-bottom:20px;border:1px solid var(--cream3)}
.hero-title{font-family:'Nanum Myeongjo',serif;font-size:52px;font-weight:800;line-height:1.2;
  color:var(--brown);margin-bottom:20px;letter-spacing:-1px}
.hero-title span{color:var(--orange)}
.hero-sub{font-size:15px;color:var(--brown3);line-height:1.8;margin-bottom:40px;font-weight:300}
.hero-btns{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.btn-primary{background:var(--orange);color:#fff;font-size:14px;padding:14px 36px;border-radius:32px;
  border:none;cursor:pointer;font-family:'Noto Sans KR',sans-serif;transition:all .25s;font-weight:500;display:inline-block}
.btn-primary:hover{background:var(--orange2);transform:translateY(-2px)}
.btn-secondary{background:transparent;color:var(--brown2);font-size:14px;padding:13px 34px;
  border-radius:32px;border:1.5px solid var(--brown4);cursor:pointer;font-family:'Noto Sans KR',sans-serif;transition:all .25s;display:inline-block}
.btn-secondary:hover{border-color:var(--brown2);background:var(--cream2)}
.hero-scroll{position:absolute;bottom:32px;left:50%;transform:translateX(-50%);
  display:flex;flex-direction:column;align-items:center;gap:8px;color:var(--brown4);font-size:11px;letter-spacing:1px}
.scroll-line{width:1px;height:40px;background:linear-gradient(to bottom,var(--brown4),transparent);animation:scrollBounce 1.8s ease-in-out infinite}
@keyframes scrollBounce{0%,100%{transform:translateY(0)}50%{transform:translateY(6px)}}

/* ══════════════════════════════
   STRIP
══════════════════════════════ */
.strip{background:var(--brown);color:var(--cream);padding:12px 0;overflow:hidden;white-space:nowrap}
.strip-inner{display:inline-flex;gap:80px;animation:marquee 30s linear infinite;font-size:12px;opacity:.85}
@keyframes marquee{from{transform:translateX(0)}to{transform:translateX(-50%)}}
.strip-dot{color:var(--orange)}

/* ══════════════════════════════
   섹션 공통
══════════════════════════════ */
.section{padding:80px 48px}
.section-alt{background:var(--white);padding:80px 48px}
.section-label{font-size:11px;color:var(--brown4);letter-spacing:2px;text-transform:uppercase;margin-bottom:10px}
.section-title{font-family:'Nanum Myeongjo',serif;font-size:30px;font-weight:700;color:var(--brown);margin-bottom:8px;letter-spacing:-.5px}
.section-sub{font-size:14px;color:var(--brown3);font-weight:300;margin-bottom:40px;line-height:1.7}

/* ══════════════════════════════
   CATEGORIES
══════════════════════════════ */
.cat-grid{display:grid;grid-template-columns:repeat(7,1fr);gap:16px;max-width:900px;margin:0 auto}
.cat-item{display:flex;flex-direction:column;align-items:center;gap:10px;cursor:pointer;
  padding:20px 12px;border-radius:16px;transition:all .25s;border:1px solid transparent}
.cat-item:hover{background:var(--cream2);border-color:var(--cream3);transform:translateY(-4px)}
.cat-icon{width:56px;height:56px;background:var(--cream2);border-radius:50%;
  display:flex;align-items:center;justify-content:center;font-size:26px;transition:background .25s}
.cat-item:hover .cat-icon{background:var(--orange)}
.cat-name{font-size:12px;color:var(--brown2);font-weight:400;text-align:center}

/* ══════════════════════════════
   PRODUCTS
══════════════════════════════ */
.section-header{display:flex;justify-content:space-between;align-items:flex-end;
  margin-bottom:40px;max-width:1200px;margin-left:auto;margin-right:auto}
.view-all{font-size:13px;color:var(--brown3);border-bottom:1px solid var(--brown4);padding-bottom:2px;transition:color .2s}
.view-all:hover{color:var(--orange)}
.product-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:24px;max-width:1200px;margin:0 auto}
.product-card{border-radius:16px;overflow:hidden;background:var(--cream);cursor:pointer;
  transition:all .3s;border:1px solid var(--cream2);position:relative}
.product-card:hover{transform:translateY(-6px);box-shadow:0 20px 48px rgba(44,30,15,.12)}
.product-img{width:100%;aspect-ratio:1;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:56px;position:relative}
.product-badge{position:absolute;top:12px;left:12px;background:var(--orange);color:#fff;
  font-size:10px;padding:4px 10px;border-radius:12px;font-weight:500}
.product-wish{position:absolute;top:12px;right:12px;width:32px;height:32px;
  background:rgba(255,253,248,.9);border-radius:50%;border:none;cursor:pointer;
  display:flex;align-items:center;justify-content:center;transition:all .2s}
.product-wish:hover{background:#fff;transform:scale(1.1)}
.product-wish svg{width:16px;height:16px;stroke:var(--brown3);fill:none;stroke-width:1.5}
.product-wish.on svg{stroke:var(--orange);fill:var(--orange)}
.product-info{padding:16px}
.product-tag{font-size:10px;color:var(--orange);letter-spacing:1px;font-weight:500;margin-bottom:6px}
.product-name{font-size:14px;font-weight:500;color:var(--brown);margin-bottom:8px;line-height:1.4}
.product-stars{display:flex;align-items:center;gap:4px;margin-bottom:8px}
.star{font-size:11px;color:var(--amber)}
.product-reviews{font-size:11px;color:var(--brown4)}
.product-price{display:flex;align-items:baseline;gap:6px}
.price-main{font-size:16px;font-weight:600;color:var(--brown)}
.price-unit{font-size:11px;color:var(--brown4)}
.price-sale{font-size:12px;color:var(--brown4);text-decoration:line-through}
.product-btns{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:12px}
.btn-rent{background:var(--orange);color:#fff;font-size:12px;padding:8px;border-radius:10px;
  border:none;cursor:pointer;font-family:'Noto Sans KR',sans-serif;transition:background .2s}
.btn-rent:hover{background:var(--orange2)}
.btn-buy{background:var(--cream2);color:var(--brown2);font-size:12px;padding:8px;border-radius:10px;
  border:none;cursor:pointer;font-family:'Noto Sans KR',sans-serif;transition:background .2s}
.btn-buy:hover{background:var(--cream3)}

/* ══════════════════════════════
   MAP BANNER (카카오맵 실제 연동)
══════════════════════════════ */
.map-banner{background:var(--brown);padding:80px 48px;display:flex;align-items:center;
  gap:64px;overflow:hidden;position:relative}
.map-banner::before{content:'';position:absolute;right:-80px;top:-80px;width:500px;height:500px;
  background:radial-gradient(circle,rgba(232,115,42,.15) 0%,transparent 70%)}
.map-text{flex:1;position:relative;z-index:1}
.map-text .section-label{color:var(--orange);opacity:.8}
.map-text .section-title{color:var(--cream);margin-bottom:16px}
.map-text .section-sub{color:var(--brown4);margin-bottom:32px}
.map-features{list-style:none;display:flex;flex-direction:column;gap:10px;margin-bottom:36px}
.map-features li{display:flex;align-items:center;gap:10px;font-size:13px;color:var(--cream2);font-weight:300}
.map-features li::before{content:'';width:6px;height:6px;background:var(--orange);border-radius:50%;flex-shrink:0}

/* ★ 카카오맵 컨테이너 */
.map-kakao-wrap{
  flex:1; position:relative;
  border-radius:20px; overflow:hidden;
  border:1px solid rgba(255,253,248,.12);
  min-height:360px; max-height:460px;
}
#mainMap{width:100%;height:100%;min-height:360px;display:block}

/* 지도 위 "전체 지도 보기" 버튼 */
.map-full-btn{
  position:absolute;bottom:16px;right:16px;z-index:10;
  background:var(--orange);color:#fff;font-size:12px;font-weight:500;
  padding:8px 18px;border-radius:20px;border:none;cursor:pointer;
  font-family:'Noto Sans KR',sans-serif;
  box-shadow:0 4px 12px rgba(232,115,42,.45);transition:background .2s,transform .15s;
}
.map-full-btn:hover{background:var(--orange2);transform:translateY(-1px)}

/* 지도 로딩 스피너 */
.map-loading{
  position:absolute;inset:0;background:rgba(44,30,15,.55);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  color:var(--cream2);font-size:13px;gap:12px;z-index:5;border-radius:20px;
  transition:opacity .3s;
}
.map-loading.hide{opacity:0;pointer-events:none}
.map-spinner{
  width:36px;height:36px;border:3px solid rgba(255,253,248,.2);
  border-top-color:var(--orange);border-radius:50%;animation:spin .8s linear infinite;
}
@keyframes spin{to{transform:rotate(360deg)}}

/* ══════════════════════════════
   WEATHER (Vue 반응형)
══════════════════════════════ */
.ws-grid{display:grid;grid-template-columns:1fr 1fr;gap:32px;max-width:1200px;margin:0 auto}
.ws-card{background:var(--cream2);border-radius:20px;padding:36px;border:1px solid var(--cream3)}
.ws-icon{font-size:40px;margin-bottom:16px}
.ws-card-title{font-family:'Nanum Myeongjo',serif;font-size:22px;font-weight:700;color:var(--brown);margin-bottom:10px}
.ws-card-text{font-size:13px;color:var(--brown3);line-height:1.8;margin-bottom:24px;font-weight:300}

/* ★ 날씨 실시간 카드 */
.weather-now{display:flex;align-items:center;gap:24px;margin-bottom:20px}
.weather-temp{font-size:48px;font-weight:700;color:var(--orange);font-family:'Nanum Myeongjo',serif;line-height:1}
.weather-info-list{display:flex;flex-direction:column;gap:6px}
.weather-info-item{font-size:13px;color:var(--brown2);display:flex;align-items:center;gap:6px}
.weather-info-item span{font-weight:500;color:var(--brown)}
.weather-tags{display:flex;gap:8px;flex-wrap:wrap}
.weather-tag{background:var(--cream);border:1px solid var(--cream3);border-radius:20px;
  padding:6px 14px;font-size:12px;color:var(--brown2);cursor:pointer;transition:all .2s}
.weather-tag:hover,.weather-tag.on{background:var(--orange);color:#fff;border-color:var(--orange)}

/* 날씨 로딩 */
.weather-skeleton{display:flex;gap:12px;align-items:center}
.skel{background:var(--cream3);border-radius:8px;animation:shimmer 1.5s ease-in-out infinite}
@keyframes shimmer{0%,100%{opacity:.6}50%{opacity:1}}

/* 안전 카드 */
.safety-list{list-style:none;display:flex;flex-direction:column;gap:12px}
.safety-list li{display:flex;align-items:center;gap:12px;font-size:13px;color:var(--brown2)}
.safety-num{width:26px;height:26px;background:var(--orange);color:#fff;border-radius:50%;
  display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:600;flex-shrink:0}
.co-banner{background:linear-gradient(135deg,var(--orange),var(--amber));border-radius:16px;
  padding:20px 24px;display:flex;align-items:center;gap:16px;margin-top:20px;cursor:pointer;transition:transform .2s}
.co-banner:hover{transform:scale(1.01)}
.co-text{flex:1}
.co-title{font-size:14px;font-weight:600;color:#fff;margin-bottom:4px}
.co-sub{font-size:12px;color:rgba(255,255,255,.8)}

/* ══════════════════════════════
   GUIDE
══════════════════════════════ */
.guide-section{background:var(--cream2);padding:80px 48px}
.guide-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:24px;max-width:1200px;margin:40px auto 0}
.guide-card{background:var(--white);border-radius:16px;padding:28px;border:1px solid var(--cream3);
  cursor:pointer;transition:all .25s;display:flex;flex-direction:column;gap:14px}
.guide-card:hover{transform:translateY(-4px);border-color:var(--orange)}
.guide-num{font-family:'Nanum Myeongjo',serif;font-size:42px;font-weight:800;color:var(--cream3);line-height:1}
.guide-icon-row{display:flex;align-items:center;gap:12px}
.guide-emoji{font-size:28px}
.guide-card-title{font-size:15px;font-weight:500;color:var(--brown)}
.guide-card-text{font-size:13px;color:var(--brown3);line-height:1.7;font-weight:300;flex:1}
.guide-link{font-size:12px;color:var(--orange);font-weight:500;display:flex;align-items:center;gap:4px}
.guide-link::after{content:'→';transition:transform .2s;display:inline-block}
.guide-card:hover .guide-link::after{transform:translateX(4px)}

/* ══════════════════════════════
   MEMBERSHIP
══════════════════════════════ */
.member-banner{padding:80px 48px;background:var(--white)}
.member-inner{max-width:900px;margin:0 auto;background:var(--brown);border-radius:24px;
  padding:56px;display:grid;grid-template-columns:1fr auto;gap:48px;align-items:center;
  position:relative;overflow:hidden}
.member-inner::before{content:'';position:absolute;right:-40px;bottom:-60px;width:280px;height:280px;
  border-radius:50%;border:60px solid rgba(232,115,42,.12)}
.member-title{font-family:'Nanum Myeongjo',serif;font-size:28px;font-weight:800;color:var(--cream);margin-bottom:12px;line-height:1.3}
.member-sub{font-size:14px;color:var(--brown4);line-height:1.8;font-weight:300;margin-bottom:24px}
.grade-list{display:flex;gap:24px}
.grade-badge{display:inline-block;font-size:11px;padding:4px 12px;border-radius:12px;font-weight:500}
.grade-bronze{background:rgba(196,130,80,.2);color:#C48250}
.grade-silver{background:rgba(180,180,180,.2);color:#A0A0A0}
.grade-gold  {background:rgba(212,147,42,.2);color:#D4932A}
.grade-name{font-size:12px;color:var(--brown4);font-weight:300;margin-top:4px}
.member-actions{display:flex;flex-direction:column;gap:12px;position:relative;z-index:1}

/* ══════════════════════════════
   FOOTER
══════════════════════════════ */
footer{background:var(--brown);padding:60px 48px 32px;color:var(--cream)}
.footer-top{display:grid;grid-template-columns:2fr 1fr 1fr 1fr 1fr;gap:48px;
  padding-bottom:48px;border-bottom:1px solid rgba(255,253,248,.1)}
.footer-brand p{font-size:12px;color:var(--brown4);line-height:1.9;font-weight:300;max-width:220px;margin-top:12px}
.footer-col h5{font-size:12px;color:var(--cream);letter-spacing:1px;margin-bottom:16px;font-weight:500}
.footer-col a,.footer-col span{display:block;font-size:12px;color:var(--brown4);margin-bottom:8px;transition:color .2s;cursor:pointer}
.footer-col a:hover,.footer-col span:hover{color:var(--orange)}
.footer-contact .phone{font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:700;color:var(--cream);margin-bottom:4px}
.footer-contact .hours{font-size:11px;color:var(--brown4);margin-bottom:12px;font-weight:300}
.footer-bottom{display:flex;justify-content:space-between;align-items:center;padding-top:28px}
.footer-copy{font-size:11px;color:var(--brown4);font-weight:300}
.footer-links{display:flex;gap:20px}
.footer-links a{font-size:11px;color:var(--brown4);transition:color .2s}
.footer-links a:hover{color:var(--cream)}

/* ══════════════════════════════
   챗봇 FAB
══════════════════════════════ */
.chatbot-fab{position:fixed;bottom:32px;right:32px;z-index:500;display:flex;flex-direction:column;align-items:flex-end;gap:10px}
.fab-btn{width:56px;height:56px;background:var(--orange);border-radius:50%;border:none;cursor:pointer;
  display:flex;align-items:center;justify-content:center;font-size:22px;
  box-shadow:0 8px 24px rgba(232,115,42,.45);transition:all .25s;
  animation:fabPulse 2.5s ease-in-out infinite}
.fab-btn:hover{transform:scale(1.08)}
@keyframes fabPulse{0%,100%{box-shadow:0 8px 24px rgba(232,115,42,.4)}50%{box-shadow:0 8px 32px rgba(232,115,42,.65)}}
.fab-label{background:var(--brown);color:var(--cream);font-size:12px;padding:6px 14px;
  border-radius:20px;white-space:nowrap;font-family:'Noto Sans KR',sans-serif}

/* ══════════════════════════════
   최근 본 상품 바
══════════════════════════════ */
.recent-bar{position:fixed;bottom:0;left:0;right:0;z-index:190;
  background:var(--white);border-top:1px solid var(--cream2);
  padding:12px 48px;display:flex;align-items:center;gap:16px;
  transform:translateY(100%);transition:transform .3s;padding-right:120px}
.recent-bar.visible{transform:translateY(0)}
.recent-label{font-size:11px;color:var(--brown4);letter-spacing:1px;white-space:nowrap}
.recent-items{display:flex;gap:12px;overflow-x:auto;scrollbar-width:none;flex:1}
.recent-item{display:flex;align-items:center;gap:8px;background:var(--cream);border:1px solid var(--cream2);
  border-radius:10px;padding:6px 12px;cursor:pointer;transition:all .2s;white-space:nowrap;flex-shrink:0}
.recent-item:hover{border-color:var(--orange)}
.recent-close{margin-left:auto;font-size:18px;color:var(--brown4);cursor:pointer;background:none;border:none}

/* ══════════════════════════════
   검색 모달
══════════════════════════════ */
.search-overlay{position:fixed;inset:0;z-index:600;background:rgba(44,30,15,.6);
  display:none;align-items:flex-start;justify-content:center;padding-top:120px}
.search-overlay.open{display:flex}
.search-box{background:var(--white);border-radius:20px;padding:24px;width:100%;max-width:600px;box-shadow:0 24px 64px rgba(44,30,15,.2)}
.search-input-row{display:flex;align-items:center;gap:12px;border-bottom:1.5px solid var(--cream3);padding-bottom:16px;margin-bottom:20px}
.search-input{border:none;outline:none;font-size:18px;flex:1;font-family:'Noto Sans KR',sans-serif;color:var(--brown);background:transparent;font-weight:300}
.search-input::placeholder{color:var(--brown4)}
.search-tags-title{font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:10px}
.search-tags{display:flex;flex-wrap:wrap;gap:8px}
.search-tag{background:var(--cream);border:1px solid var(--cream3);border-radius:20px;padding:6px 14px;font-size:12px;color:var(--brown2);cursor:pointer;transition:all .2s}
.search-tag:hover{background:var(--orange);color:#fff;border-color:var(--orange)}

/* ══════════════════════════════
   스크롤 리빌 / 토스트
══════════════════════════════ */
.fade-up{opacity:0;transform:translateY(24px);transition:opacity .7s ease,transform .7s ease}
.fade-up.visible{opacity:1;transform:translateY(0)}
.toast{position:fixed;bottom:80px;left:50%;transform:translateX(-50%) translateY(60px);
  background:var(--brown);color:var(--cream);padding:12px 24px;border-radius:50px;
  font-size:13px;box-shadow:0 4px 20px rgba(0,0,0,.2);z-index:700;
  opacity:0;transition:all .3s cubic-bezier(.34,1.56,.64,1);white-space:nowrap}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}
</style>
</head>
<body>

<!-- ════════════════ NAV ════════════════ -->
<nav id="mainNav">
  <div class="nav-left">
    <div class="nav-ham" onclick="toggleMenu()">
      <span></span><span></span><span></span>
    </div>
    <a href="/main.do" class="nav-logo">
      <svg class="logo-flame" viewBox="0 0 24 24" fill="none">
        <path d="M12 2C10 6 6 8 8 13C9 16 11 17 12 22C13 17 15 16 16 13C18 8 14 6 12 2Z" fill="#E8732A"/>
        <path d="M12 8C11 10 9 11 10 14C10.5 16 11.5 17 12 20C12.5 17 13.5 16 14 14C15 11 13 10 12 8Z" fill="#F5C842"/>
      </svg>
      모닥모닥
    </a>
    <ul class="nav-menu">
      <li><a href="/product/product-list.do">캠핑 용품</a></li>
      <li><a href="/product/rental-list.do">대여</a></li>
      <li><a href="/product/product-list.do">구매</a></li>
      <li><a href="/camp/map.do">캠핑장</a></li>
      <li><a href="/board/board-list.do">커뮤니티</a></li>
      <li><a href="/cs-center.do">고객센터</a></li>
    </ul>
  </div>
  <div class="nav-right">
    <button class="nav-icon" onclick="openSearch()">
      <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35" stroke-linecap="round"/></svg>
    </button>
    <button class="nav-icon" onclick="location.href='/wishlist.do'">
      <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
    </button>
    <button class="nav-icon" onclick="location.href='/cart/cart.do'" style="position:relative">
      <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6" stroke-linecap="round"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
      <span class="nav-badge">2</span>
    </button>
    <c:choose>
      <c:when test="${not empty sessionScope.loginUser}">
        <button class="btn-login" onclick="location.href='/user/logout.do'">로그아웃</button>
      </c:when>
      <c:otherwise>
        <button class="btn-login" onclick="location.href='/user/login.do'">로그인</button>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

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

<!-- ════════════════ MAP BANNER (카카오맵 + 캠핑API) ════════════════ -->
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

  <%-- ★ 실제 카카오맵 영역 --%>
  <div class="map-kakao-wrap">
    <%-- 지도 로딩 스피너 --%>
    <div class="map-loading" id="mapLoading">
      <div class="map-spinner"></div>
      <span>캠핑장 불러오는 중...</span>
    </div>
    <%-- 카카오맵 렌더링 div --%>
    <div id="mainMap"></div>
    <%-- 전체 지도 보기 버튼 --%>
    <button class="map-full-btn" onclick="location.href='/camp/map.do'">🗺️ 전체 지도 보기</button>
  </div>
</section>

<!-- ════════════════ WEATHER ════════════════ -->
<section style="padding:80px 48px;background:var(--cream2)" id="weatherSection">
  <div style="max-width:1200px;margin:0 auto">

    <%-- 섹션 헤더 + 지역 선택 한 줄 --%>
    <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:40px;flex-wrap:wrap;gap:16px">
      <div>
        <p class="section-label">날씨 · 안전</p>
        <h2 class="section-title" style="margin-bottom:0">안전하고 즐거운 캠핑을 위해</h2>
      </div>
      <%-- 지역 선택 드롭다운 --%>
      <div style="display:flex;align-items:center;gap:10px;
                  background:var(--white);border-radius:50px;
                  padding:8px 8px 8px 18px;
                  border:1.5px solid var(--cream3);
                  box-shadow:0 2px 12px rgba(44,30,15,.06)">
        <span style="font-size:13px;color:var(--brown3);white-space:nowrap">📍 지역</span>
        <select @change="onRegionChange"
                style="border:none;outline:none;background:transparent;
                       font-size:13px;font-weight:600;color:var(--brown2);
                       font-family:'Noto Sans KR',sans-serif;cursor:pointer;
                       padding-right:8px">
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

      <%-- ★ 날씨 카드 --%>
      <div style="background:var(--white);border-radius:24px;padding:32px;
                  box-shadow:0 4px 24px rgba(44,30,15,.07);border:1px solid var(--cream3)">

        <%-- 카드 헤더 --%>
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:24px">
          <div>
            <p style="font-size:11px;color:var(--brown4);letter-spacing:1px;margin-bottom:4px">FORECAST</p>
            <p style="font-family:'Nanum Myeongjo',serif;font-size:20px;font-weight:700;color:var(--brown)">
              {{ regionName }} 날씨 예보
            </p>
          </div>
          <div style="font-size:44px;line-height:1">
            {{ days.length > 0 ? days[0].icon : '🌤️' }}
          </div>
        </div>

        <%-- 로딩 스켈레톤 --%>
        <div v-if="isLoading" style="display:flex;gap:10px;margin-bottom:24px">
          <div v-for="n in 5" :key="n" class="skel"
               style="flex:1;height:120px;border-radius:16px"></div>
        </div>

        <%-- 5일치 날씨 카드 --%>
        <div v-else-if="!isError && days.length > 0"
             style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-bottom:20px">
          <div v-for="(d, i) in days" :key="i"
               :style="{
                 borderRadius:'16px',
                 padding:'16px 8px',
                 textAlign:'center',
                 background: i < 2 ? 'linear-gradient(160deg,#FBE8DC,#FDF3EE)' : 'var(--cream)',
                 border: i < 2 ? '1.5px solid rgba(232,115,42,.25)' : '1.5px solid var(--cream3)',
                 transition:'transform .2s',
                 cursor:'default'
               }"
               @mouseenter="$event.currentTarget.style.transform='translateY(-3px)'"
               @mouseleave="$event.currentTarget.style.transform='translateY(0)'">

            <%-- 날짜 라벨 --%>
            <div style="font-size:12px;font-weight:700;color:var(--brown2);margin-bottom:2px">
              {{ d.label }}
            </div>
            <%-- 단기/중기 뱃지 --%>
            <div :style="{
                   display:'inline-block',
                   fontSize:'9px',
                   fontWeight:'600',
                   padding:'2px 7px',
                   borderRadius:'10px',
                   marginBottom:'10px',
                   background: i < 2 ? 'rgba(232,115,42,.15)' : 'var(--cream2)',
                   color: i < 2 ? 'var(--orange)' : 'var(--brown4)'
                 }">
              {{ i < 2 ? '단기' : '중기' }}
            </div>
            <%-- 날씨 이모지 --%>
            <div style="font-size:30px;line-height:1;margin-bottom:10px">{{ d.icon }}</div>
            <%-- 최고기온 --%>
            <div style="font-size:16px;font-weight:800;color:var(--orange);margin-bottom:2px">
              {{ d.max }}
            </div>
            <%-- 최저기온 --%>
            <div style="font-size:12px;color:var(--brown4);margin-bottom:8px">{{ d.min }}</div>
            <%-- 강수확률 --%>
            <div style="display:inline-flex;align-items:center;gap:3px;
                        font-size:10px;color:var(--brown3);
                        background:var(--cream2);border-radius:8px;
                        padding:3px 7px">
              <span>🌧</span><span>{{ d.rain }}</span>
            </div>
          </div>
        </div>

        <%-- 에러 --%>
        <div v-else style="text-align:center;padding:32px 0;color:var(--brown4);font-size:13px;margin-bottom:20px">
          날씨 정보를 불러올 수 없습니다.
        </div>

        <%-- 범례 + 태그 --%>
        <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px">
          <p style="font-size:11px;color:var(--brown4)">
            <span style="display:inline-block;width:10px;height:10px;border-radius:3px;
                         background:#FBE8DC;border:1px solid rgba(232,115,42,.3);
                         margin-right:4px;vertical-align:middle"></span>단기예보
            &nbsp;
            <span style="display:inline-block;width:10px;height:10px;border-radius:3px;
                         background:var(--cream2);border:1px solid var(--cream3);
                         margin-right:4px;vertical-align:middle"></span>중기예보
          </p>
          <div class="weather-tags">
            <span class="weather-tag on" @click="fnWeatherTab($event)">5일 예보</span>
            <span class="weather-tag"   @click="fnWeatherTab($event)">주간 예보</span>
            <span class="weather-tag"   @click="fnWeatherTab($event)">지역 검색</span>
          </div>
        </div>
      </div>

      <%-- 안전 카드 --%>
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
      <div class="guide-card fade-up" onclick="location.href='/board/guide-detail.do?no=1'">
        <div class="guide-num">01</div>
        <div class="guide-icon-row"><span class="guide-emoji">📹</span><p class="guide-card-title">설치 가이드 영상</p></div>
        <p class="guide-card-text">텐트, 타프, 취사도구 등 장비별 상세 설치 영상을 제공합니다. 초보 캠퍼도 쉽게 따라할 수 있어요.</p>
        <span class="guide-link">영상 보러가기</span>
      </div>
      <div class="guide-card fade-up" onclick="location.href='/board/guide-detail.do?no=2'">
        <div class="guide-num">02</div>
        <div class="guide-icon-row"><span class="guide-emoji">📱</span><p class="guide-card-title">QR 코드 매뉴얼</p></div>
        <p class="guide-card-text">장비 수령 시 QR코드를 스캔하면 해당 제품의 상세 매뉴얼을 즉시 확인할 수 있습니다.</p>
        <span class="guide-link">QR 사용법 보기</span>
      </div>
      <div class="guide-card fade-up" onclick="location.href='/board/guide-detail.do?no=3'">
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
      <a href="/membership.do" class="btn-secondary" style="text-align:center">멤버십 혜택 보기</a>
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

<!-- ════════════════ 챗봇 FAB ════════════════ -->
<div class="chatbot-fab">
  <span class="fab-label">챗봇 문의</span>
  <%-- ChatController: /chat/bot.do 로 이동 --%>
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
      <svg viewBox="0 0 24 24" style="width:22px;height:22px;stroke:var(--brown3);fill:none;stroke-width:1.5;flex-shrink:0"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35" stroke-linecap="round"/></svg>
      <input type="text" class="search-input" id="searchInput" placeholder="텐트, 침낭, 캠핑장 검색..." onkeydown="if(event.key==='Enter')fnSearch()">
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


<!-- ════════════════════════════════════════════
     JavaScript
════════════════════════════════════════════ -->
<script>
/* ──────────────────────────────────────────
   1. 불씨(Ember) 애니메이션
────────────────────────────────────────── */
(function(){
    var ec = document.getElementById('embers');
    var cols = ['rgba(255,120,20,.9)','rgba(255,80,0,.85)','rgba(255,180,30,.8)','rgba(220,60,0,.75)','rgba(255,140,40,.7)'];
    function mk(){
        if(!ec) return;
        var el=document.createElement('div'); el.className='ember';
        var s=Math.random()*4+1.5, l=Math.random()*160+70, d=Math.random()*3+2.5, dx=(Math.random()-.5)*120, c=cols[Math.floor(Math.random()*cols.length)];
        el.style.cssText='width:'+s+'px;height:'+s+'px;left:'+l+'px;bottom:0;background:'+c+';box-shadow:0 0 '+(s*2)+'px '+c+';--dx:'+dx+'px;animation-duration:'+d+'s;';
        ec.appendChild(el);
        setTimeout(function(){el.parentNode&&el.parentNode.removeChild(el);},d*1000);
    }
    setInterval(mk,220);
    for(var i=0;i<12;i++) setTimeout(mk,i*180);
})();

/* ──────────────────────────────────────────
   2. 스크롤 → 네비 그림자 + 리빌
────────────────────────────────────────── */
var revealObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){ if(e.isIntersecting) e.target.classList.add('visible'); });
},{threshold:.12});
document.querySelectorAll('.fade-up').forEach(function(el){ revealObserver.observe(el); });

window.addEventListener('scroll',function(){
    document.getElementById('mainNav').classList.toggle('scrolled',window.scrollY>40);
});

/* ──────────────────────────────────────────
   3. ★ 카카오맵 초기화 + 캠핑API 마커
   - camp-map.jsp의 fnFetch() 로직 그대로 축소 적용
   - /camp/list.dox 호출 → 마커 표시 (최대 50개)
────────────────────────────────────────── */
kakao.maps.load(function(){
    var container = document.getElementById('mainMap');
    if(!container) return;

    var map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(36.5, 127.8),
        level: 11,
        scrollwheel: false   /* 메인 페이지 스크롤 방해 방지 */
    });

    /* 줌 컨트롤 */
    map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

    var infowindow = new kakao.maps.InfoWindow({zIndex:10});
    var markers = [];

    /* 캠핑 공공API 데이터 호출 */
    $.ajax({
        url: '/camp/list.dox',
        type: 'POST',
        dataType: 'json',
        success: function(data){
            /* 로딩 스피너 숨김 */
            var loadEl = document.getElementById('mapLoading');
            if(loadEl) loadEl.classList.add('hide');

            if(!data || !data.list) return;

            /* 메인에서는 최대 80개만 표시 (성능) */
            var list = data.list.slice(0,80);

            list.forEach(function(item){
                var lat = parseFloat(item.mapY);
                var lng = parseFloat(item.mapX);
                if(!lat || !lng || lat<30 || lat>40 || lng<120 || lng>135) return;

                var pos = new kakao.maps.LatLng(lat, lng);

                /* 오렌지 커스텀 마커 */
                var markerContent =
                    '<div style="' +
                    'width:12px;height:12px;' +
                    'background:#E8732A;' +
                    'border:2px solid rgba(255,253,248,.85);' +
                    'border-radius:50%;' +
                    'box-shadow:0 2px 6px rgba(232,115,42,.55);' +
                    'cursor:pointer' +
                    '"></div>';

                var overlay = new kakao.maps.CustomOverlay({
                    position: pos,
                    content:  markerContent,
                    yAnchor:  0.5,
                    zIndex:   3
                });
                overlay.setMap(map);
                markers.push(overlay);

                /* 마커 클릭 → 인포윈도우 */
                var content =
                    '<div style="padding:10px 14px;font-size:12px;max-width:180px;line-height:1.6;font-family:Noto Sans KR,sans-serif;">' +
                    '<b style="color:#E8732A;display:block;margin-bottom:3px;">⛺ ' + item.facltNm + '</b>' +
                    '<span style="color:#666;">' + (item.addr1||'') + '</span>' +
                    '<br><a href="/camp/map.do" style="color:#E8732A;font-size:11px;font-weight:500;">상세보기 →</a>' +
                    '</div>';

                /* CustomOverlay에는 이벤트 직접 등록 불가 → DOM 이벤트 활용 */
                overlay.getContent = function(){ return markerContent; };

                /* 일반 마커로도 클릭 감지 (invisible marker trick) */
                var hiddenMarker = new kakao.maps.Marker({position:pos, map:map});
                hiddenMarker.setOpacity(0);

                kakao.maps.event.addListener(hiddenMarker, 'click', function(){
                    infowindow.setContent(content);
                    infowindow.open(map, hiddenMarker);
                });
            });
        },
        error: function(){
            var loadEl = document.getElementById('mapLoading');
            if(loadEl){ loadEl.innerHTML='<span style="color:rgba(255,253,248,.5);font-size:13px">지도 데이터를 불러올 수 없습니다</span>'; }
        }
    });

    /* 지도 relayout (flex 안에서 크기 재계산) */
    setTimeout(function(){ map.relayout(); }, 400);
});

/* ──────────────────────────────────────────
   4. Vue3 날씨 (단기예보 + 중기예보 + 지역선택)
────────────────────────────────────────── */
const { createApp } = Vue;
createApp({
    data() {
        return {
            isLoading:      true,
            isError:        false,
            days:           [],
            regionName:     '서울',
            selectedRegion: 'seoul',
            regionMap: {
                seoul:     { nx:60,  ny:127, name:'서울',  taId:'11B10101', landId:'11B00000' },
                gyeonggi:  { nx:60,  ny:121, name:'경기',  taId:'11B20601', landId:'11B00000' },
                gangwon:   { nx:73,  ny:134, name:'강원',  taId:'11D10301', landId:'11D10000' },
                chungbuk:  { nx:69,  ny:107, name:'충북',  taId:'11C10301', landId:'11C10000' },
                chungnam:  { nx:68,  ny:100, name:'충남',  taId:'11C20401', landId:'11C20000' },
                jeonbuk:   { nx:63,  ny:89,  name:'전북',  taId:'11F10201', landId:'11F10000' },
                jeonnam:   { nx:51,  ny:67,  name:'전남',  taId:'11F20501', landId:'11F20000' },
                gyeongbuk: { nx:89,  ny:91,  name:'경북',  taId:'11H10501', landId:'11H10000' },
                gyeongnam: { nx:91,  ny:77,  name:'경남',  taId:'11H20301', landId:'11H20000' },
                jeju:      { nx:52,  ny:38,  name:'제주',  taId:'11G00201', landId:'11G00000' }
            }
        };
    },
    methods: {
        /* 지역 드롭다운 변경 */
        onRegionChange(e) {
            this.selectedRegion = e.target.value;
            const r = this.regionMap[this.selectedRegion];
            this.regionName = r.name;
            this.loadWeather(r);
        },

        /* 단기 + 중기 병렬 호출 */
        async loadWeather(region) {
            this.isLoading = true;
            this.isError   = false;
            this.days      = [];
            try {
                const [shortRes, midRes] = await Promise.all([
                    this.fetchShort(region.nx, region.ny),
                    this.fetchMid(region.taId, region.landId)
                ]);

                const result = [];

                /* ── 단기예보 파싱 (오늘, 내일) ── */
                if (shortRes.result === 'success') {
                    const items    = shortRes.data.response.body.items.item;
                    const today    = this.getDateStr(0);
                    const tomorrow = this.getDateStr(1);
                    const byDate   = {};

                    items.forEach(item => {
                        if (!byDate[item.fcstDate]) byDate[item.fcstDate] = { temps: [] };
                        const d = byDate[item.fcstDate];
                        if (item.category === 'TMX') d.max = item.fcstValue;
                        if (item.category === 'TMN') d.min = item.fcstValue;
                        /* TMP: 시간별 기온 수집 → TMX/TMN 없을 때 최대/최솟값으로 대체 */
                        if (item.category === 'TMP') d.temps.push(parseFloat(item.fcstValue));
                        if (item.category === 'SKY' && item.fcstTime === '1200') d.sky  = item.fcstValue;
                        if (item.category === 'PTY' && item.fcstTime === '1200') d.pty  = item.fcstValue;
                        if (item.category === 'POP' && item.fcstTime === '1200') d.rain = item.fcstValue;
                    });

                    [today, tomorrow].forEach((dateStr, i) => {
                        const d = byDate[dateStr] || { temps: [] };
                        /* TMX 없으면 TMP 중 최댓값, TMN 없으면 최솟값으로 대체 */
                        const maxVal = d.max  != null ? Math.round(d.max)
                                     : d.temps.length > 0 ? Math.max(...d.temps) : null;
                        const minVal = d.min  != null ? Math.round(d.min)
                                     : d.temps.length > 0 ? Math.min(...d.temps) : null;
                        result.push({
                            label: i === 0 ? '오늘' : '내일',
                            icon:  this.skyToIcon(d.sky, d.pty),
                            max:   maxVal != null ? maxVal + '°' : '-°',
                            min:   minVal != null ? minVal + '°' : '-°',
                            rain:  d.rain != null ? d.rain + '%' : '-%'
                        });
                    });
                }

                /* ── 중기예보 파싱 (D+3 ~ D+5) ── */
                if (midRes.result === 'success') {
                    const taRaw   = midRes.ta.response.body.items.item;
                    const landRaw = midRes.land.response.body.items.item;
                    const ta      = Array.isArray(taRaw)   ? taRaw[0]   : taRaw;
                    const land    = Array.isArray(landRaw) ? landRaw[0] : landRaw;

                    [3, 4, 5].forEach(d => {
                        const dt = new Date();
                        dt.setDate(dt.getDate() + d);
                        const label = (dt.getMonth()+1) + '/' + dt.getDate();
                        const wf    = land['wf' + d + 'Am'] || '';
                        result.push({
                            label: label,
                            icon:  this.wfToIcon(wf),
                            max:   (ta['taMax' + d] != null ? ta['taMax' + d] : '-') + '°',
                            min:   (ta['taMin' + d] != null ? ta['taMin' + d] : '-') + '°',
                            rain:  (land['rnSt' + d + 'Am'] != null ? land['rnSt' + d + 'Am'] : '-') + '%'
                        });
                    });
                }

                this.days = result;

            } catch(e) {
                console.error('날씨 로드 에러:', e);
                this.isError = true;
            }
            this.isLoading = false;
        },

        /* 단기예보 Ajax */
        fetchShort(nx, ny) {
            return new Promise(resolve => {
                $.ajax({
                    url: '/weather/short.dox',
                    data: { nx, ny },
                    dataType: 'json',
                    success: resolve,
                    error: () => resolve({ result: 'fail' })
                });
            });
        },

        /* 중기예보 Ajax */
        fetchMid(taRegId, landRegId) {
            return new Promise(resolve => {
                $.ajax({
                    url: '/weather/mid.dox',
                    data: { taRegId, landRegId },
                    dataType: 'json',
                    success: resolve,
                    error: () => resolve({ result: 'fail' })
                });
            });
        },

        /* yyyyMMdd 날짜 문자열 */
        getDateStr(addDay) {
            const d = new Date();
            d.setDate(d.getDate() + addDay);
            return d.getFullYear()
                + String(d.getMonth() + 1).padStart(2, '0')
                + String(d.getDate()).padStart(2, '0');
        },

        /* 단기예보 SKY + PTY → 이모지 */
        skyToIcon(sky, pty) {
            const p = parseInt(pty);
            if (p === 1 || p === 4) return '🌧️';
            if (p === 2)             return '🌨️';
            if (p === 3)             return '❄️';
            const s = parseInt(sky);
            if (s === 1)             return '☀️';
            if (s === 3)             return '⛅';
            if (s === 4)             return '☁️';
            return '🌤️';
        },

        /* 중기예보 wf → 이모지 */
        wfToIcon(wf) {
            if (!wf)                  return '🌤️';
            if (wf.includes('비'))    return '🌧️';
            if (wf.includes('눈'))    return '❄️';
            if (wf.includes('흐림'))  return '☁️';
            if (wf.includes('구름'))  return '⛅';
            return '☀️';
        },

        fnWeatherTab(e) {
            document.querySelectorAll('.weather-tag').forEach(t => t.classList.remove('on'));
            e.target.classList.add('on');
        }
    },
    mounted() {
        this.loadWeather(this.regionMap['seoul']);
    }
}).mount('#weatherSection');

/* ──────────────────────────────────────────
   5. 토스트
────────────────────────────────────────── */
function showToast(msg){
    var t=document.getElementById('toast');
    t.textContent=msg; t.classList.add('show');
    setTimeout(function(){t.classList.remove('show');},2200);
}

/* ──────────────────────────────────────────
   6. 상품 이동 (최근 본 상품 저장)
────────────────────────────────────────── */
var PROD_MAP = {
    1:{no:1,name:'스노우피크 랜드록',icon:'⛺'},
    2:{no:2,name:'일산화탄소 경보기',icon:'🔥'},
    3:{no:3,name:'나낙 레인저 침낭', icon:'🛏️'},
    4:{no:4,name:'코베아 쿡웨어',   icon:'🍳'}
};
function fnGoDetail(no){
    var items=JSON.parse(localStorage.getItem('recentViewed')||'[]');
    items=items.filter(function(i){return i.no!==no;});
    items.unshift(PROD_MAP[no]);
    if(items.length>5) items.pop();
    localStorage.setItem('recentViewed',JSON.stringify(items));
    location.href='/product/product-detail.do?no='+no;
}

/* 최근 본 상품 바 렌더링 */
(function(){
    var items=JSON.parse(localStorage.getItem('recentViewed')||'[]');
    if(!items.length) return;
    var html='';
    items.slice(0,5).forEach(function(item){
        html+='<div class="recent-item" onclick="location.href=\'/product/product-detail.do?no='+item.no+'\'">'
            +'<span class="recent-item-img">'+item.icon+'</span>'
            +'<span style="font-size:12px;color:var(--brown2)">'+item.name+'</span>'
            +'</div>';
    });
    document.getElementById('recentItems').innerHTML=html;
    setTimeout(function(){document.getElementById('recentBar').classList.add('visible');},3000);
})();
function closeRecent(){document.getElementById('recentBar').classList.remove('visible');}

/* ──────────────────────────────────────────
   7. 위시리스트 / 장바구니 Ajax
────────────────────────────────────────── */
function fnWish(e,btn,no){
    e.stopPropagation();
    $.ajax({url:'/product/toggleWish.dox',type:'POST',data:{productNo:no},
        success:function(res){
            var r=JSON.parse(res);
            if(r.result==='success'){
                btn.classList.toggle('on');
                showToast(btn.classList.contains('on')? '♥ 위시리스트에 추가됐어요':'위시리스트에서 제거됐어요');
            } else { showToast('로그인이 필요합니다'); setTimeout(function(){location.href='/user/login.do';},1200); }
        }
    });
}
function fnAddRental(e,no){
    e.stopPropagation();
    $.ajax({url:'/cart/addCart.dox',type:'POST',data:{productNo:no,cartType:'rental'},
        success:function(res){
            var r=JSON.parse(res);
            if(r.result==='success') showToast('🏕️ 대여 장바구니에 담겼어요!');
            else { showToast('로그인이 필요합니다'); setTimeout(function(){location.href='/user/login.do';},1200); }
        }
    });
}
function fnAddCart(e,no){
    e.stopPropagation();
    $.ajax({url:'/cart/addCart.dox',type:'POST',data:{productNo:no,cartType:'buy'},
        success:function(res){
            var r=JSON.parse(res);
            if(r.result==='success') showToast('🛒 장바구니에 담겼어요!');
            else { showToast('로그인이 필요합니다'); setTimeout(function(){location.href='/user/login.do';},1200); }
        }
    });
}

/* ──────────────────────────────────────────
   8. 검색 모달
────────────────────────────────────────── */
function openSearch(){document.getElementById('searchOverlay').classList.add('open');document.getElementById('searchInput').focus();}
function closeSearch(e){if(e.target===document.getElementById('searchOverlay'))document.getElementById('searchOverlay').classList.remove('open');}
function fnFillSearch(v){document.getElementById('searchInput').value=v;}
function fnSearch(){var kw=document.getElementById('searchInput').value.trim();if(kw)location.href='/product/product-search.do?keyword='+encodeURIComponent(kw);}
document.addEventListener('keydown',function(e){if(e.key==='Escape')document.getElementById('searchOverlay').classList.remove('open');});

/* 메뉴 토글 (추후 구현) */
function toggleMenu(){showToast('전체 메뉴 준비 중입니다');}
</script>

</body>
</html>
