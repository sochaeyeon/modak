# 🔥 ModakModak (모닥모닥)

<div align="center">

**캠핑장 탐색부터 장비 렌탈, AI 서비스, 커뮤니티까지**
**캠퍼를 위한 모든 것이 담긴 종합 캠핑 플랫폼**

[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.5.12-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-AWS_RDS-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![Gemini](https://img.shields.io/badge/Google_Gemini-AI-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://deepmind.google/technologies/gemini/)

</div>

<br>

---

## 📌 프로젝트 소개

**모닥모닥(ModakModak)** 은 캠핑장 정보 조회, 상품 대여 및 구매, 커뮤니티 기능을 하나로 통합한 **종합 캠핑 플랫폼**입니다.

Spring Boot + MyBatis 기반으로 구축되었으며, Google Gemini AI, 카카오맵, 공공데이터, 기상청, Toss Payments 등 다양한 외부 API를 연동하여 실제 서비스에 가까운 완성도를 목표로 개발하였습니다.

> 🗓 개발 기간 : 2025.03 ~ 2025.05
> 👥 팀 구성 : 4인 팀 프로젝트

<br>

---

## 👥 팀원 소개

| 프로필 | 이름 | 역할 | GitHub |
|:---:|:---:|:---|:---:|
| 🙂 | **소채연** | 팀장 · 외부 API 연동 아키텍처 설계 | [@sochaeyeon](https://github.com/sochaeyeon) |
| 😡 | **김은동** | 풀스택 · 인프라 · 어드민 시스템 설계 | [@rladmsehd135](https://github.com/rladmsehd135) |
| 😀 | **임예림** | 풀스택 · UI/UX 설계 · 이커머스 로직 | [@kewiibird-source](https://github.com/kewiibird-source) |
| 😂 | **필우청** | 풀스택 · 데이터 모델링 · 고객 지원 시스템 | [@yuqingtangda](https://github.com/yuqingtangda) |

<br>

---

## 📂 관련 문서

| 문서 | 링크 |
|:---:|:---:|
| 📝 회의록 | [바로가기](https://drive.google.com/drive/folders/1bpM3vTIY-6_Rf_6FwxaOvptJlfphWDZC) |
| 📐 설계 문서 (ERD, 요구사항) | [바로가기](https://drive.google.com/drive/folders/1ImcpHUeuDkVdmN7kLwLxJ86gxVyfqsfu) |
| 🛠️ 공통 가이드라인 | [바로가기](https://drive.google.com/drive/folders/1Xm2uaNjuhy3Qlk6FlUh8F5hIuKT3p7nS) |

<br>

---

## 🛠 기술 스택

### Backend
| 기술 | 버전 |
|:---|:---:|
| Spring Boot | 3.5.12 |
| MyBatis | 3.0.5 |
| Java | 17 |
| Spring Security + OAuth2 | - |
| MySQL (AWS RDS) | - |

### Frontend
| 기술 | 용도 |
|:---|:---|
| JSP (Jakarta Servlet JSP JSTL) | 템플릿 엔진 |
| Vue.js 3 | 동적 UI 컴포넌트 |
| jQuery / AJAX | 비동기 통신 |

### External APIs
| 구분 | 기술 |
|:---|:---|
| 인증 | Google / Naver / Kakao OAuth2, Solapi (SMS 인증) |
| 결제 / 배송 | Toss Payments, Delivery Tracker |
| 지도 / 데이터 | 카카오맵 API, GoCamping 공공데이터, 기상청 단기예보 API |
| AI / 메일 | Google Gemini API, Java Mail (Gmail SMTP) |

<br>

---

## 🚀 주요 기능

### ⛺ 캠핑장 & 날씨
- 카카오맵 API 기반 전국 캠핑장 위치 확인 및 목록 / 상세 조회
- GoCamping 공공데이터 연동 — 전국 캠핑장 정보 실시간 동기화
- 기상청 단기예보 API — 캠핑장별 맞춤 날씨 정보 제공

### 🛒 쇼핑 & 렌탈
- 캠핑 용품 구매 및 대여 통합 시스템
- 장바구니, Toss Payments 결제, 회원 / 비회원 주문 처리
- 대여 연장 및 반납 관리 **(비회원 토큰 인증 지원)**
- Delivery Tracker API 실시간 배송 상태 추적

### 💬 커뮤니티 & AI
- 게시판 (작성 / 수정 / 상세) 및 사용자 간 **1:1 실시간 채팅**
- Google Gemini 기반 **캠핑 가이드 AI 챗봇**
- 상품 리뷰 **AI 자동 요약** (3문장 이내)

### ⚙️ 관리자 시스템
- 매출 통계 및 실시간 재고 관리 대시보드
- 회원 / 상품 / 캠핑장 / 쿠폰 / 리뷰 / 문의 통합 관리
- 공지사항 / 이벤트 / 알림 발송 시스템
- 주문 취소 승인, 반납 상태 변경, 검수 관리

<br>

---

## 📋 역할 분담

### 🔐 소채연 — 팀장 / 외부 API 연동

| 카테고리 | 상세 내용 |
|:---|:---|
| 인증 / 계정 | 소셜 로그인 (Google, Naver, Kakao), 회원가입, SMS 인증 기반 계정 찾기 |
| 회원 서비스 | 마이페이지, 멤버십, 주문 내역, 포인트 / 쿠폰 내역 관리 |
| 활동 기록 | 최근 본 상품, 위시리스트, 챗봇 기록, 리뷰 전체보기, 통합 검색 |
| 고객 지원 | 배송 현황 (택배사 API), 1:1 문의 수정, 리뷰 및 게시글 수정 / 작성 |
| 기타 | CSS 통합 관리 |

### 🏗️ 김은동 — 풀스택 / 인프라 / 어드민

| 카테고리 | 상세 내용 |
|:---|:---|
| 핵심 서비스 | 메인 페이지, 캠핑장 지도 / 목록 / 상세 (시설 정보 포함) |
| 주문 / 렌탈 | 비회원 주문 조회 / 상세, 대여 연장 및 반납, 교환 처리 |
| 커뮤니티 | 게시판 (목록 / 상세 / 작성), 1:1 채팅방 및 목록 관리, AI 챗봇 구현 |
| 알림 / 가이드 | 알림 목록 / 상세, 설치 가이드, QR, 분리수거 가이드 |
| Admin 전체 | 대시보드, 통계, 매출, 회원 / 상품 / 캠핑장 / 쿠폰 / 리뷰 / 문의 / 등급 / 알림 / 취소 통합 관리 |
| 기타 | CSS 구현 |

### 🛍️ 임예림 — 풀스택 / UI·UX / 이커머스

| 카테고리 | 상세 내용 |
|:---|:---|
| 상품 서비스 | 상품 목록, 상품 검색 결과, 상품 상세 페이지 |
| 구매 프로세스 | 장바구니, Toss Payments 결제 연동, 주문 완료 화면 |
| 사후 관리 | 환불 요청 및 환불 상세 조회 |
| 리뷰 시스템 | 리뷰 작성 / 수정, 리뷰 신고 폼 |
| 기타 | CSS 구현 |

### 📞 필우청 — 풀스택 / 데이터 모델링 / 고객 지원

| 카테고리 | 상세 내용 |
|:---|:---|
| 공통 UI | 헤더 / 푸터 레이아웃, 에러 페이지 구성 |
| 고객 센터 | 고객센터 메인, FAQ, 1:1 문의 폼, 페이지 분할 관리 |
| 정보 / 약관 | 공지사항 (목록 / 상세), 이용약관, 개인정보처리방침, 마케팅 수신 동의 |
| 프로모션 | 이벤트 목록 및 상세 페이지 관리 |
| 기타 | CSS 구현 |

<br>

---

## 🌟 기대 효과

### 👤 사용자 경험
- **원스톱 솔루션** — 캠핑장 탐색부터 장비 렌탈, 날씨 확인까지 한 번에 해결
- **스마트한 의사결정** — AI 리뷰 요약으로 방대한 정보를 빠르게 파악
- **실시간 소통** — 커뮤니티와 1:1 채팅으로 캠핑족 간 정보 공유

### 🏢 비즈니스 운영
- **데이터 기반 관리** — 매출 통계 및 실시간 재고 대시보드로 운영 효율 극대화
- **비용 절감** — AI 챗봇 및 자동 알림으로 고객 응대 자동화
- **높은 확장성** — 모듈화 설계로 캠핑카 렌탈, 밀키트 정기 배송 등 부가 서비스 확장 용이

<br>

---

<div align="center">

**🔥 모닥불처럼 따뜻한 캠핑 플랫폼, 모닥모닥 🔥**

</div>
