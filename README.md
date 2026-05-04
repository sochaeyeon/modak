# 🏕️ ModakModak (모닥모닥)

Modak(모닥모닥)은 캠핑장 정보 조회, 상품 대여 및 구매, 커뮤니티 기능을 제공하는 종합 캠핑 플랫폼입니다. Spring Boot와 MyBatis를 기반으로 구축되었으며, 다양한 외부 API(카카오 지도, 공공데이터 캠핑장 정보, 기상청 날씨, Gemini AI 리뷰 요약 등)를 연동하여 사용자에게 풍부한 경험을 제공합니다.

---

## 👥 팀원 소개 (Team Modak)

| 성명 | 역할 | GitHub |
| :--- | :--- | :--- |
| **소채연** | **팀장** / 백엔드 / 외부 API 연동 아키텍처 설계 | [@sochaeyeon](https://github.com/sochaeyeon) |
| **김은동** | **풀스택** / 인프라 및 서비스 아키텍처 / 어드민 시스템 설계 | [@rladmsehd135](https://github.com/rladmsehd135) |
| **임예림** | **풀스택** / UI·UX 설계 / 이커머스 로직 구현 | [@kewiibird-source](https://github.com/kewiibird-source) |
| **필우청** | **풀스택** / 데이터 모델링 / 고객 지원 시스템 구축 | [@yuqingtangda](https://github.com/yuqingtangda) |

---

## 📂 관련 문서 (Documents)

프로젝트의 상세 기획 및 설계 내용은 아래 링크에서 확인하실 수 있습니다.

*   [📝 회의록]([https://drive.google.com/drive/folders/1bpM3vTIY-6_Rf_6FwxaOvptJlfphWDZC](https://drive.google.com/drive/folders/14zyi4NPYp5hNNngEVUll3zfDjJBpoXgU))
*   [📐 설계 문서 ([ERD, 요구사항 등)](https://drive.google.com/drive/folders/1WqbDMTMkynVD0cCp9hnwFD0ld0HBcUQW](https://drive.google.com/drive/folders/1ImcpHUeuDkVdmN7kLwLxJ86gxVyfqsfu))
*   [🛠️ 공통 가이드라인](https://drive.google.com/drive/folders/1Xm2uaNjuhy3Qlk6FlUh8F5hIuKT3p7nS)

---

## 🌟 기대 효과 (Expected Effects)

Modak 프로젝트는 캠핑 시장의 디지털 전환을 목표로 하며 다음과 같은 가치를 창출합니다.

### 1. 사용자 경험의 혁신 (User Experience)
*   **통합 서비스 제공**: 캠핑장 탐색부터 장비 렌탈, 구매, 날씨 확인까지 한 번에 해결하는 **원스톱 솔루션**을 제공합니다.
*   **스마트한 의사결정**: **AI 리뷰 요약** 기능을 통해 방대한 정보를 빠르게 파악하고 자신에게 맞는 캠핑 용품을 선택할 수 있도록 돕습니다.
*   **실시간 소통**: 커뮤니티와 1:1 채팅을 통해 캠핑족 간의 유대감을 형성하고 실시간 정보를 공유합니다.

### 2. 효율적인 비즈니스 운영 (Business Operation)
*   **데이터 기반 관리**: 매출 통계 및 실시간 재고 관리 대시보드를 통해 **운영 효율성**을 극대화합니다.
*   **리소스 최적화**: AI 챗봇과 자동화된 알림 시스템을 도입하여 고객 응대 비용을 절감하고 서비스 품질을 유지합니다.
*   **확장 가능한 플랫폼**: 모듈화된 설계를 통해 향후 캠핑카 렌탈, 밀키트 정기 배송 등 다양한 **부가 서비스로의 확장이 용이**합니다.

---

## 🚀 주요 기능

### 1. ⛺ 캠핑장 및 날씨 정보
*   **캠핑장 검색 및 지도 연동**: 카카오맵 API를 활용한 캠핑장 위치 확인 및 목록/상세 조회
*   **공공데이터 연동**: GoCamping API를 통한 전국 캠핑장 정보 제공 및 실시간 동기화
*   **날씨 정보**: 기상청 단기예보 API를 활용한 캠핑장별 실시간 날씨 정보 제공

### 2. 🛒 쇼핑 및 렌탈 (이커머스)
*   **상품 관리**: 다양한 캠핑 용품의 구매 및 대여 시스템 구축
*   **주문/결제**: 장바구니, 토스 페이먼츠 연동 결제, 회원/비회원 주문 처리
*   **렌탈 특화**: 대여 상품의 연장 신청 및 반납 관리 (비회원 토큰 인증 지원)
*   **배송 조회**: Delivery Tracker API를 이용한 실시간 배송 상태 추적

### 3. 💬 커뮤니티 및 AI 서비스
*   **커뮤니티**: 게시판(글 작성/수정/상세) 및 사용자 간 1:1 실시간 채팅방
*   **AI 챗봇**: Google Gemini API 기반의 캠핑 가이드 챗봇 서비스
*   **AI 리뷰 요약**: 수많은 상품 리뷰를 Gemini AI가 3문장 이내로 자동 요약

### 4. ⚙️ 관리자 시스템 (Admin)
*   **통합 관리**: 대시보드, 매출 통계, 회원/상품/캠핑장/쿠폰/리뷰/문의 등 전방위 관리 기능
*   **운영 도구**: 공지사항 및 이벤트 관리, 알림 발송 시스템

---

## 🖥️ 상세 역할 분담 (Role & Responsibilities)

### 🙂 소채연 (팀장 / 외부 API 연동 아키텍처 설계)
*   **인증 및 계정**: 소셜 로그인 API 연동, 회원가입, SMS 인증 기반 아이디/비밀번호 찾기
*   **사용자 활동**: 마이페이지, 멤버십 정보, 주문 내역, 포인트/쿠폰 내역 관리
*   **기록 및 조회**: 리뷰/최근 본 상품/위시리스트/챗봇 기록 전체보기, 통합 검색 결과
*   **고객지원 및 소통**: 문의 목록 조회/수정, 배송 현황(택배사 API), 리뷰 및 게시글 수정/작성
*   **CSS** : css 통합

### 😡 김은동 (백엔드 / 인프라 및 서비스 아키텍처 / 어드민 시스템 설계)
*   **서비스 메인**: 메인 페이지, 캠핑장 지도 조회 및 목록/상세(시설 정보 포함)
*   **주문 및 렌탈**: 주문 상세, 비회원 주문 조회/상세, 회원/비회원 대여 연장 및 반납, 교환 처리
*   **커뮤니티**: 게시판 목록/상세/작성, 1:1 채팅방 및 채팅 목록 관리, 챗봇 기능 구현
*   **운영 및 관리**: 알림 목록/상세, 가이드(설치, QR, 분리수거 등)
*   **Admin 시스템**: 관리자 메인/로그인/대시보드/사이드바, 통계 및 매출 관리, 회원/상품/캠핑장/쿠폰/리뷰/문의/등급/알림/취소 등 모든 관리자 기능
*   **CSS** : css구현

### 😀 임예림 (백엔드 / UI·UX 설계 / 이커머스 로직 구현)
*   **상품 서비스**: 상품 목록 조회, 상품 검색 결과, 상품 상세보기
*   **구매 프로세스**: 장바구니 관리, 결제 API 연동, 주문 완료 화면 구현
*   **사후 관리**: 환불 요청 및 상세 조회
*   **리뷰 시스템**: 리뷰 작성 및 수정, 리뷰 신고 폼(JSP) 작성
*   **CSS** : css구현

### 😂 필우청 (백엔드 / 데이터 모델링 / 고객 지원 시스템 구축)
*   **공통 UI**: 헤더, 푸터, 에러 페이지 구성
*   **고객 센터**: 고객센터 메인, FAQ(자주 묻는 질문), 1:1 문의 폼, 페이지 분할 관리
*   **정보 제공**: 공지사항 목록 및 상세, 서비스 이용 약관, 개인정보 처리 방침, 마케팅 수신 동의
*   **이벤트**: 이벤트 목록 및 상세 페이지 관리
*   **CSS** : css구현

---

## 🛠 기술 스택

### Backend / Frontend
*   **Framework**: Spring Boot 3.5.12 / MyBatis 3.0.5
*   **Language**: Java 17 / JavaScript (jQuery, AJAX)
*   **Database**: MySQL (AWS RDS)
*   **Template**: JSP (Jakarta Servlet JSP JSTL)
*   **Security**: Spring Security, OAuth2 Client

### External APIs
*   **Auth**: Google, Naver, Kakao OAuth2 / Solapi (SMS)
*   **Business**: Toss Payments / Delivery Tracker / GoCamping / 기상청 API
*   **AI/Communication**: Google Gemini API / Java Mail (Gmail SMTP)

---


