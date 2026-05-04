#  ModakModak (모닥모닥)

Modak(모닥모닥)은 캠핑장 정보 조회, 상품 대여 및 구매, 커뮤니티 기능을 제공하는 종합 캠핑 플랫폼입니다. Spring Boot와 MyBatis를 기반으로 구축되었으며, 다양한 외부 API(카카오 지도, 공공데이터 캠핑장 정보, 기상청 날씨, Gemini AI 리뷰 요약 등)를 연동하여 사용자에게 풍부한 경험을 제공합니다.

## 🚀 주요 기능

### 1. 캠핑장 및 날씨 정보
* **캠핑장 검색 및 지도 연동**: 카카오맵 API를 활용한 캠핑장 위치 확인
* **공공데이터 연동**: GoCamping API를 통한 전국 캠핑장 정보 제공 및 동기화
* **날씨 정보**: 기상청 단기예보 API를 활용한 실시간 날씨 제공

### 2. 쇼핑 및 렌탈 (이커머스)
* **상품 검색 및 상세**: 다양한 캠핑 용품(구매/대여) 조회
* **장바구니 및 주문**: 회원 및 비회원 주문 지원
* **결제 시스템**: 토스 페이먼츠 연동을 통한 안전한 결제
* **배송 조회**: Delivery Tracker API를 이용한 실시간 배송 상태 확인
* **렌탈 연장**: 대여 상품에 대한 연장 신청 및 결제 기능 (비회원 토큰 인증 지원)

### 3.커뮤니티 및 리뷰
* **게시판**: 회원 간 캠핑 정보 공유
* **실시간 채팅**: 사용자 간 1:1 채팅 및 대화 신청 기능
* **AI 리뷰 요약**: Google Gemini API를 활용하여 상품 리뷰를 3문장 이내로 요약 제공

### 4. 회원 및 멤버십
* **소셜 로그인**: 구글, 네이버, 카카오 OAuth2 로그인 지원
* **멤버십 등급**: 구매 실적에 따른 등급 부여 및 혜택 제공
* **마이페이지**: 주문 내역, 찜 목록, 쿠폰, 포인트 관리

### 5.관리자 시스템 (Admin)
* **대시보드**: 매출 및 통계 요약
* **회원 및 상품 관리**: 사용자 정보, 캠핑장 데이터, 상품 재고 관리
* **주문 및 배송 관리**: 전체 주문 내역 및 배송 상태 업데이트

---

## 🛠 기술 스택

### Backend
* **Framework**: Spring Boot 3.5.12
* **Language**: Java 17
* **Database**: MySQL (AWS RDS)
* **ORM**: MyBatis 3.0.5
* **Security**: Spring Security, OAuth2 Client
* **Build Tool**: Maven

### Frontend
* **Template Engine**: JSP (Jakarta Servlet JSP JSTL)
* **Styling**: CSS, Bootstrap (추정)
* **Scripting**: JavaScript, jQuery, AJAX

### External APIs & Services
* **Map**: Kakao Map API
* **Payment**: Toss Payments API
* **Data**: GoCamping API, 기상청 API
* **AI**: Google Gemini API (리뷰 요약, 챗봇)
* **Delivery**: Delivery Tracker API
* **Auth**: Google, Naver, Kakao OAuth2
* **SMS**: Solapi SDK
* **Mail**: Spring Boot Mail (Gmail SMTP)

---

## 📁 프로젝트 구조

```text
src/main/java/com/example/modak/
├── address/       # 배송지 관리
├── admin/         # 관리자 페이지
├── alarm/         # 알림 서비스
├── board/         # 커뮤니티 게시판
├── camp/          # 캠핑장 정보 및 지도
├── cart/          # 장바구니
├── category/      # 상품 카테고리
├── chat/          # 챗봇 및 채팅 서비스
├── chatroom/      # 사용자 간 1:1 채팅방
├── common/        # 공통 설정 (Security, OAuth2, Error)
├── csCenter/      # 고객센터 (FAQ, 공지사항, 1:1 문의)
├── delivery/      # 배송 조회
├── event/         # 이벤트 페이지
├── guide/         # 이용 가이드
├── main/          # 메인 페이지
├── membership/    # 멤버십 등급 및 혜택
├── order/         # 주문 (회원/비회원), 교환
├── payment/       # 결제 연동 (토스)
├── product/       # 상품 정보
├── refund/        # 환불 처리
├── rental/        # 렌탈 연장 서비스
├── review/        # 리뷰 및 AI 리뷰 요약
├── search/        # 통합 검색
├── user/          # 회원가입, 로그인, 마이페이지, 쿠폰, 포인트
└── wishlist/      # 찜하기



