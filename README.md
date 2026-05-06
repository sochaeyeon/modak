<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:FF6B35,100:FF9F1C&height=200&section=header&text=🔥%20ModakModak&fontSize=60&fontColor=ffffff&fontAlignY=38&desc=모닥모닥%20—%20캠퍼를%20위한%20종합%20캠핑%20플랫폼&descAlignY=58&descColor=ffffff"/>

<br>

[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.5.12-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-AWS_RDS-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![JSP](https://img.shields.io/badge/JSP-Jakarta-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/java/technologies/jspt.html)
[![Gemini](https://img.shields.io/badge/Google_Gemini-AI-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://deepmind.google/technologies/gemini/)
[![Toss](https://img.shields.io/badge/Toss_Payments-결제연동-0064FF?style=for-the-badge&logo=tosspayments&logoColor=white)](https://docs.tosspayments.com)

<br>

> 🗓 **개발 기간** : 2026.04.08 ~ 2026.04.30 &nbsp;&nbsp;|&nbsp;&nbsp; 👥 **팀 구성** : 4인 팀 프로젝트

</div>

<br>

---

## 📌 프로젝트 소개

**모닥모닥(ModakModak)** 은 캠핑장 정보 조회, 장비 대여 및 구매, 커뮤니티까지 한 곳에서 해결하는 **종합 캠핑 플랫폼**입니다.

Spring Boot + MyBatis를 기반으로 구축되었으며, Google Gemini AI · 카카오맵 · 공공데이터 · 기상청 · Toss Payments 등 **다양한 외부 API**를 연동하여 실제 서비스에 가까운 완성도를 목표로 개발하였습니다.

```
🏕️ 캠핑장 탐색   →   🛒 장비 렌탈/구매   →   💬 커뮤니티 소통   →   ⚙️ 관리자 운영
```

<br>

---

## 👥 팀원 소개

<div align="center">

| 이름 | 역할 | GitHub |
|:---:|:---|:---:|
| **소채연** | `팀장` · 외부 API 연동 · 인증 아키텍처 설계 | [![GitHub](https://img.shields.io/badge/-sochaeyeon-181717?style=flat-square&logo=github)](https://github.com/sochaeyeon) |
| **김은동** | `풀스택` · 인프라 · 어드민 시스템 설계 | [![GitHub](https://img.shields.io/badge/-rladmsehd135-181717?style=flat-square&logo=github)](https://github.com/rladmsehd135) |
| **임예림** | `풀스택` · UI/UX 설계 · 이커머스 로직 | [![GitHub](https://img.shields.io/badge/-kewiibird--source-181717?style=flat-square&logo=github)](https://github.com/kewiibird-source) |
| **필우청** | `풀스택` · 데이터 모델링 · 고객 지원 시스템 | [![GitHub](https://img.shields.io/badge/-yuqingtangda-181717?style=flat-square&logo=github)](https://github.com/yuqingtangda) |

</div>

<br>

---

## 📂 관련 문서

<div align="center">

| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문서&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 설명 | 링크 |
|:---:|:---|:---:|
| 📝 **회의록** | 주간 회의 내용 및 결정 사항 기록 | [바로가기 →](https://drive.google.com/drive/folders/1bpM3vTIY-6_Rf_6FwxaOvptJlfphWDZC) |
| 📐 **설계 문서** | ERD, 요구사항 정의서, API 명세서 | [바로가기 →](https://drive.google.com/drive/folders/1ImcpHUeuDkVdmN7kLwLxJ86gxVyfqsfu) |
| 🛠️ **공통 가이드라인** | 코드 컨벤션, 브랜치 전략, 공통 규칙 | [바로가기 →](https://drive.google.com/drive/folders/1Xm2uaNjuhy3Qlk6FlUh8F5hIuKT3p7nS) |
| 🎞️ **발표 PPT** | 프로젝트 최종 발표 슬라이드 | [바로가기 →](manus-slides://DSK4P4RhMjDlrm8S45nSTW) |

</div>

<br>

---

## 🛠 기술 스택

### ⚙️ Backend & Infrastructure
| 기술 | 버전 | 용도 |
|:---|:---:|:---|
| Spring Boot | `3.5.12` | 메인 웹 프레임워크 |
| MyBatis | `3.0.5` | SQL 매핑 ORM |
| Java | `17` | 개발 언어 |
| Spring Security | `-` | 인증 및 보안 |
| MySQL (AWS RDS) | `-` | 클라우드 데이터베이스 |

### 🎨 Frontend
| 기술 | 용도 |
|:---|:---|
| JSP (Jakarta Servlet) | 서버사이드 템플릿 엔진 |
| JavaScript (jQuery, AJAX) | 비동기 통신 및 동적 UI |
| CSS3 (Custom Design) | 반응형 웹 디자인 |

### 🌐 External APIs
| 구분 | 기술 |
|:---|:---|
| 🔐 인증 | Google / Naver / Kakao OAuth2, Solapi (SMS 인증) |
| 💳 결제 / 배송 | Toss Payments, Delivery Tracker API |
| 🗺️ 지도 / 데이터 | 카카오맵 API, GoCamping 공공데이터, 기상청 단기예보 API |
| 🤖 AI / 메일 | Google Gemini API, Java Mail (Gmail SMTP) |

<br>

---

## 🚀 주요 기능

<details open>
<summary><b>⛺ 캠핑장 & 날씨</b></summary>
<br>
- 🗺️ <b>카카오맵 API</b> 기반 전국 캠핑장 위치 확인 및 목록 / 상세 조회
- 🏕️ <b>GoCamping 공공데이터</b> 연동 — 전국 캠핑장 정보 실시간 동기화
- 🌤️ <b>기상청 단기예보 API</b> — 캠핑장별 맞춤 날씨 정보 제공
</details>

<details>
<summary><b>🛒 쇼핑 & 렌탈</b></summary>
<br>
- 🏷️ 캠핑 용품 <b>구매 및 대여</b> 통합 시스템
- 🛒 장바구니, <b>Toss Payments</b> 결제, 회원 / 비회원 주문 처리
- 🔑 대여 연장 및 반납 관리 — <b>비회원 토큰 인증 지원</b>
- 🚚 <b>Delivery Tracker API</b> 실시간 배송 상태 추적
</details>

<details>
<summary><b>💬 커뮤니티 & AI</b></summary>
<br>
- 📋 게시판 (작성 / 수정 / 상세) 및 사용자 간 <b>1:1 실시간 채팅</b>
- 🤖 <b>Google Gemini</b> 기반 캠핑 가이드 AI 챗봇
- ✨ 상품 리뷰 <b>AI 자동 요약</b> (3문장 이내)
</details>

<details>
<summary><b>⚙️ 관리자 시스템</b></summary>
<br>
- 📊 매출 통계 및 실시간 재고 관리 <b>대시보드</b>
- 👥 회원 / 상품 / 캠핑장 / 쿠폰 / 리뷰 / 문의 <b>통합 관리</b>
- 🔔 공지사항 / 이벤트 / 알림 발송 시스템
- 🔄 주문 취소 승인, 반납 상태 변경, 검수 관리
</details>

<br>

---

## 📋 상세 역할 분담 (Role & Responsibilities)

### 🙂 소채연 (팀장 / 인증 및 아키텍처)
| 카테고리 | 상세 업무 및 담당 페이지 |
|:---|:---|
| **인증 / 계정** | 소셜 로그인 API, 회원가입, SMS 인증(아이디/비번 찾기) |
| **회원 서비스** | 마이페이지, 멤버십 정보, 포인트/쿠폰 내역, 주문 내역 관리 |
| **활동 기록** | 최근 본 상품, 위시리스트, 챗봇 기록, 리뷰 전체보기, 통합 검색 |
| **고객 지원** | 배송 현황(택배사 API), 1:1 문의 수정, 리뷰 및 게시글 수정/작성 |

### 🏗️ 김은동 (풀스택 / 어드민 및 인프라)
| 카테고리 | 상세 업무 및 담당 페이지 |
|:---|:---|
| **핵심 서비스** | 메인 페이지, 캠핑장 지도/목록/상세 조회(시설 정보 포함) |
| **주문 / 렌탈** | 비회원 주문 조회/상세, 대여 연장 및 반납, 교환 처리 로직 |
| **커뮤니티** | 게시판(목록/상세/작성), 1:1 채팅방 및 목록 관리, AI 챗봇 구현 |
| **관리자(Admin)** | **전체 어드민 시스템 설계 및 구현** (대시보드, 통계, 매출, 회원/상품/캠핑장/쿠폰/리뷰/문의 등 통합 관리) |

### 🛍️ 임예림 (풀스택 / 이커머스 로직)
| 카테고리 | 상세 업무 및 담당 페이지 |
|:---|:---|
| **상품 서비스** | 상품 목록, 상품 검색 결과, 상품 상세 페이지 구현 |
| **구매 로직** | 장바구니 관리, 결제 API 연동, 주문 완료 프로세스 |
| **사후 관리** | 환불 요청 및 환불 상세 조회 시스템 |
| **리뷰 시스템** | 리뷰 작성/수정, 리뷰 신고 폼 구축 |

### 📞 필우청 (풀스택 / 고객 지원 및 UI)
| 카테고리 | 상세 업무 및 담당 페이지 |
|:---|:---|
| **공통 UI** | 헤더/푸터 레이아웃, 에러 페이지 구성 |
| **고객 센터** | 고객센터 메인, FAQ, 1:1 문의 폼 구현 |
| **정보 / 약관** | 공지사항(목록/상세), 이용약관, 개인정보처리방침, 마케팅 수신동의 |
| **프로모션** | 이벤트 목록 및 이벤트 상세 페이지 관리 |

<br>

---

## 🌟 기대 효과

<div align="center">

| 구분 | 기대 효과 | 설명 |
|:---:|:---|:---|
| **사용자** | 🎯 **원스톱 솔루션** | 캠핑장 탐색부터 장비 렌탈, 날씨 확인까지 한 번에 해결 |
| **사용자** | 🤖 **스마트한 의사결정** | AI 리뷰 요약으로 방대한 정보를 빠르게 파악 |
| **운영자** | 📊 **데이터 기반 관리** | 매출 통계 및 실시간 재고 대시보드로 운영 효율 극대화 |
| **운영자** | 💰 **비용 절감** | AI 챗봇 및 자동 알림으로 고객 응대 자동화 |

</div>

<br>

---

## 🗂️ ERD

<details>
<summary><b>ERD 펼치기</b></summary>
<br>
<div align="center">
<img width="100%" alt="ModakModak ERD" src="https://private-user-images.githubusercontent.com/233740606/588049586-9fb81bc2-ce57-4edc-8706-a213e828eebf.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NzgwNDA3NDQsIm5iZiI6MTc3ODA0MDQ0NCwicGF0aCI6Ii8yMzM3NDA2MDYvNTg4MDQ5NTg2LTlmYjgxYmMyLWNlNTctNGVkYy04NzA2LWEyMTNlODI4ZWViZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwNTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDUwNlQwNDA3MjRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00Mjg3YTIyZmYwM2IyZDUyMzA0ZTA4MjMxMDc2NDVmNmM2MjNmMTRjM2VhNzE2NDU2OTU0ZDVmN2I3NTkyYWNkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.5ml0fCRnouPuOe9sTG7i1z8Ty6bwBj2Qz9I0gcK7Xpw" />
</div>
</details>

<br>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:FF6B35,100:FF9F1C&height=120&section=footer&fontSize=30&fontColor=ffffff"/>

**🔥 모닥불처럼 따뜻한 캠핑 플랫폼, 모닥모닥 🔥**

`Team Modak` · `2026`

</div>
