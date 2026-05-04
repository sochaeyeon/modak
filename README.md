# 🔥 ModakModak (모닥모닥)

> **캠핑장 탐색부터 장비 렌탈, 커뮤니티까지 — 캠퍼를 위한 종합 플랫폼**

Spring Boot + MyBatis 기반으로 구축된 모닥모닥은 카카오맵, 공공데이터, 기상청, Gemini AI 등 다양한 외부 API를 연동하여 캠핑을 더 스마트하고 편리하게 즐길 수 있도록 돕습니다.

<br>

---

## 👥 팀원 소개

| 이름 | 역할 | GitHub |
|:---:|:---:|:---:|
| **소채연** | 팀장 · 외부 API 연동 아키텍처 | [@sochaeyeon](https://github.com/sochaeyeon) |
| **김은동** | 풀스택 · 인프라 · 어드민 시스템 | [@rladmsehd135](https://github.com/rladmsehd135) |
| **임예림** | 풀스택 · UI/UX · 이커머스 로직 | [@kewiibird-source](https://github.com/kewiibird-source) |
| **필우청** | 풀스택 · 데이터 모델링 · 고객 지원 | [@yuqingtangda](https://github.com/yuqingtangda) |

<br>

---

## 📂 관련 문서

| 문서 | 링크 |
|:---:|:---:|
| 📝 회의록 | [바로가기](https://drive.google.com/drive/folders/14zyi4NPYp5hNNngEVUll3zfDjJBpoXgU) |
| 📐 설계 문서 (ERD, 요구사항) | [바로가기](https://drive.google.com/drive/folders/1ImcpHUeuDkVdmN7kLwLxJ86gxVyfqsfu) |
| 🛠️ 공통 가이드라인 | [바로가기](https://drive.google.com/drive/folders/1Xm2uaNjuhy3Qlk6FlUh8F5hIuKT3p7nS) |

<br>

---

## 🛠 기술 스택

### Backend / Frontend
| 구분 | 기술 |
|:---:|:---|
| Framework | Spring Boot 3.5.12, MyBatis 3.0.5 |
| Language | Java 17, JavaScript (jQuery, AJAX), Vue.js 3 |
| Database | MySQL (AWS RDS) |
| Template | JSP (Jakarta Servlet JSP JSTL) |
| Security | Spring Security, OAuth2 Client |

### External APIs
| 구분 | 기술 |
|:---:|:---|
| 인증 | Google / Naver / Kakao OAuth2, Solapi (SMS) |
| 결제 / 배송 | Toss Payments, Delivery Tracker |
| 데이터 | GoCamping 공공데이터, 기상청 단기예보 API, 카카오맵 API |
| AI / 메일 | Google Gemini API, Java Mail (Gmail SMTP) |

<br>

---

## 🚀 주요 기능

### ⛺ 캠핑장 & 날씨
- 카카오맵 기반 캠핑장 위치 확인 및 목록/상세 조회
- GoCamping 공공데이터 연동 — 전국 캠핑장 정보 실시간 동기화
- 기상청 단기예보 API — 캠핑장별 실시간 날씨 제공

### 🛒 쇼핑 & 렌탈
- 캠핑 용품 구매 및 대여 통합 시스템
- 장바구니, Toss Payments 결제, 회원/비회원 주문 처리
- 대여 연장 및 반납 관리 (비회원 토큰 인증 지원)
- Delivery Tracker API 실시간 배송 상태 추적

### 💬 커뮤니티 & AI
- 게시판 (작성/수정/상세) 및 사용자 간 1:1 실시간 채팅
- Google Gemini 기반 캠핑 가이드 AI 챗봇
- 상품 리뷰 AI 자동 요약 (3문장 이내)

### ⚙️ 관리자 시스템
- 매출 통계 및 실시간 재고 관리 대시보드
- 회원 / 상품 / 캠핑장 / 쿠폰 / 리뷰 / 문의 통합 관리
- 공지사항 / 이벤트 / 알림 발송 시스템

<br>

---

## 📋 역할 분담

<details>
<summary><b>🙂 소채연 — 팀장 / 외부 API 연동</b></summary>

- 소셜 로그인 (Google, Naver, Kakao), 회원가입, SMS 인증 기반 계정 찾기
- 마이페이지, 멤버십, 주문 내역, 포인트/쿠폰 관리
- 리뷰/최근 본 상품/위시리스트/챗봇 기록 전체보기, 통합 검색
- 문의 목록/수정, 배송 조회 (택배사 API 연동), 게시글/리뷰 작성·수정
- CSS 통합 관리
</details>

<details>
<summary><b>😡 김은동 — 풀스택 / 인프라 / 어드민 시스템</b></summary>

- 메인 페이지, 캠핑장 지도/목록/상세 (시설 정보 포함)
- 주문 상세, 비회원 주문 조회, 회원/비회원 대여 연장·반납·교환
- 게시판 목록/상세/작성, 1:1 채팅방, AI 챗봇 구현
- 알림 목록/상세, 가이드 페이지
- Admin 전체 — 대시보드, 통계, 회원/상품/캠핑장/쿠폰/리뷰/문의/등급/알림/취소 관리
- CSS 구현
</details>

<details>
<summary><b>😀 임예림 — 풀스택 / UI·UX / 이커머스</b></summary>

- 상품 목록/검색/상세
- 장바구니, 결제 API 연동, 주문 완료 화면
- 환불 요청 및 상세 조회
- 리뷰 작성/수정, 리뷰 신고 폼
- CSS 구현
</details>

<details>
<summary><b>😂 필우청 — 풀스택 / 데이터 모델링 / 고객 지원</b></summary>

- 헤더, 푸터, 에러 페이지
- 고객센터 메인, FAQ, 1:1 문의 폼
- 공지사항 목록/상세, 이용약관, 개인정보 처리방침, 마케팅 수신 동의
- 이벤트 목록/상세
- CSS 구현
</details>

<br>

---

## 🌟 기대 효과

### 사용자 경험
- **원스톱 솔루션** — 캠핑장 탐색부터 장비 렌탈, 날씨 확인까지 한 번에 해결
- **스마트한 의사결정** — AI 리뷰 요약으로 방대한 정보를 빠르게 파악
- **실시간 소통** — 커뮤니티와 1:1 채팅으로 캠핑족 간 정보 공유

### 비즈니스 운영
- **데이터 기반 관리** — 매출 통계 및 실시간 재고 대시보드로 운영 효율 극대화
- **비용 절감** — AI 챗봇 및 자동 알림 시스템으로 고객 응대 자동화
- **확장 가능한 플랫폼** — 모듈화 설계로 캠핑카 렌탈, 밀키트 정기 배송 등 부가 서비스 확장 용이
