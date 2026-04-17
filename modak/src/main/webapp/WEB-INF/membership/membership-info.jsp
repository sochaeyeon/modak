<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html lang="ko">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap"
      rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/membership/membership-info.css">

  </head>

  <body>
    <%@ include file="/WEB-INF/common/header.jsp" %>
      <div id="app">
        <div class="nav">
          <a href="/main.do"><span class="nav-brand">모닥모닥 </span></a>
          <div class="nav-crumb">
            <a href="/main.do"><span>홈</span></a> › <a href="/user/mypage.do"><span>마이페이지</span></a> › <span
              class="cur">멤버십 혜택</span>
          </div>
        </div>

        <div class="wrap">

          <!-- HERO -->
          <div class="hero">
            <div class="hero-badge">🏅 모닥모닥 멤버십</div>
            <h1>대여할수록 커지는<br><span>나만의 캠핑 혜택</span></h1>
            <p>등급이 올라갈수록 더 큰 할인, 더 많은 포인트, 더 빠른 예약을 누려보세요.</p>
          </div>

          <!-- 내 등급 현황 -->
          <div class="my-grade">
            <div class="grade-icon" :class="currentGradeClass">{{ currentGradeEmoji }}</div>

            <div class="grade-meta">
              <div class="label">현재 나의 등급</div>
              <div class="name">{{ info.gradeName }} 회원</div>
            </div>
            <div class="progress-wrap">
              <div class="progress-label">
                <span>실버</span>
                <span v-if="info.gradeName !== 'VVIP'">
                  {{ info.gradeName }} →
                  {{ nextGradeName }}까지
                  <strong style="color:#e8610a;">
                    {{ remainAmount.toLocaleString() }}원
                  </strong>
                  남음
                </span>

                <span v-else>
                  최고 등급 회원입니다
                </span>
              </div>
              <div class="progress-bar">
                <div class="progress-fill" :style="{ width: progressPercent + '%' }"></div>
              </div>
              <div style="font-size:11px;color:#bbb;margin-top:5px;" v-if="info.gradeName !== 'VVIP'">
                누적 대여금액 {{ info.totalAmount.toLocaleString() }}원 / {{ nextGradeMinAmount.toLocaleString() }}원
              </div>

              <div style="font-size:11px;color:#bbb;margin-top:5px;" v-else>
                누적 대여금액 {{ info.totalAmount.toLocaleString() }}원 / 최고 등급 달성
              </div>
            </div>
            <div class="grade-points">
              <div class="pts">{{ info.point.toLocaleString() }}P</div>
              <div class="pts-label">보유 포인트</div>
            </div>
          </div>

          <!-- 등급 카드 -->
          <div class="section-title">멤버십 등급 안내</div>
          <div class="grade-grid">

            <div class="grade-card bronze" :class="{ current: isCurrentGrade('브론즈') }">
              <div class="current-label" v-if="isCurrentGrade('브론즈')">현재 등급</div>
              <div class="grade-emoji">🥉</div>
              <div class="grade-name">브론즈</div>
              <div class="grade-cond">가입 즉시</div>
              <div class="grade-perks">
                <div class="perk">
                  <div class="perk-dot"></div><span>기본 적립 <span class="highlight">1%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>생일 쿠폰 <span class="highlight">1장</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>신규 할인 <span class="highlight">5%</span></span>
                </div>
              </div>
            </div>

            <div class="grade-card silver" :class="{ current: isCurrentGrade('실버') }">
              <div class="current-label" v-if="isCurrentGrade('실버')">현재 등급</div>
              <div class="grade-emoji">🥈</div>
              <div class="grade-name">실버</div>
              <div class="grade-cond">누적 3만원 이상</div>
              <div class="grade-perks">
                <div class="perk">
                  <div class="perk-dot"></div><span>적립률 <span class="highlight">2%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>대여 할인 <span class="highlight">5%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>생일 쿠폰 <span class="highlight">2장</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>우선 예약 <span class="highlight">1일 전</span></span>
                </div>
              </div>
            </div>

            <div class="grade-card gold" :class="{ current: isCurrentGrade('골드') }">
              <div class="current-label" v-if="isCurrentGrade('골드')">현재 등급</div>
              <div class="grade-emoji">🥇</div>
              <div class="grade-name">골드</div>
              <div class="grade-cond">누적 10만원 이상</div>
              <div class="grade-perks">
                <div class="perk">
                  <div class="perk-dot"></div><span>적립률 <span class="highlight">3%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>대여 할인 <span class="highlight">10%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>생일 쿠폰 <span class="highlight">3장</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>우선 예약 <span class="highlight">2일 전</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>무료 배송 <span class="highlight">월 2회</span></span>
                </div>
              </div>
            </div>

            <div class="grade-card vvip" :class="{ current: isCurrentGrade('VVIP') }">
              <div class="current-label" v-if="isCurrentGrade('VVIP')">현재 등급</div>
              <div class="grade-emoji">👑</div>
              <div class="grade-name">VVIP</div>
              <div class="grade-cond">누적 30만원 이상</div>
              <div class="grade-perks">
                <div class="perk">
                  <div class="perk-dot"></div><span>적립률 <span class="highlight">5%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>대여 할인 <span class="highlight">15%</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>생일 쿠폰 <span class="highlight">5장</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>우선 예약 <span class="highlight">3일 전</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>무료 배송 <span class="highlight">무제한</span></span>
                </div>
                <div class="perk">
                  <div class="perk-dot"></div><span>전담 CS <span class="highlight">24시간</span></span>
                </div>
              </div>
            </div>

          </div>

          <!-- 혜택 비교 테이블 -->
          <div class="section-title">등급별 혜택 비교</div>
          <div class="benefit-table-wrap" style="margin-bottom:48px;">
            <table class="benefit-table">
              <thead>
                <tr>
                  <th style="text-align:left;">혜택 항목</th>
                  <th :class="{ 'highlight-col': isCurrentGrade('브론즈') }">🥉 브론즈</th>
                  <th :class="{ 'highlight-col': isCurrentGrade('실버') }">🥈 실버</th>
                  <th :class="{ 'highlight-col': isCurrentGrade('골드') }">🥇 골드</th>
                  <th :class="{ 'highlight-col': isCurrentGrade('VVIP') }">👑 VVIP</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>포인트 적립률</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }">1%</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }">2%</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">3%</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">5%</td>
                </tr>
                <tr>
                  <td>대여 상시 할인</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }">5%</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">10%</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">15%</td>
                </tr>
                <tr>
                  <td>생일 쿠폰</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }">1장</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }">2장</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">3장</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">5장</td>
                </tr>
                <tr>
                  <td>신규 장비 우선 예약</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }">1일 전</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">2일 전</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">3일 전</td>
                </tr>
                <tr>
                  <td>무료 배송</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">월 2회</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">무제한</td>
                </tr>
                <tr>
                  <td>전담 고객센터</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }" class="check">✓ 24시간</td>
                </tr>
                <tr>
                  <td>시즌 특별 쿠폰</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }">연 2회</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }">연 4회</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }">연 6회</td>
                </tr>
                <tr>
                  <td>장비 연장 무료</td>
                  <td :class="{ 'val-orange': isCurrentGrade('브론즈') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('실버') }" class="cross">—</td>
                  <td :class="{ 'val-orange': isCurrentGrade('골드') }" class="check">연 1회</td>
                  <td :class="{ 'val-orange': isCurrentGrade('VVIP') }" class="check">연 3회</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- 포인트 적립 안내 -->
          <div class="point-section">
            <div class="section-title">포인트 적립 방법</div>
            <div class="point-grid">
              <div class="point-card">
                <div class="point-icon" style="background:#fde8d8;">📦</div>
                <div>
                  <h4>장비 대여</h4>
                  <p>대여 금액의 등급별 %가 적립돼요</p>
                  <div class="rate">최대 5%</div>
                </div>
              </div>
              <div class="point-card">
                <div class="point-icon" style="background:#dff0e4;">⭐</div>
                <div>
                  <h4>리뷰 작성</h4>
                  <p>사진 포함 리뷰 작성 시 보너스 지급</p>
                  <div class="rate">+200P</div>
                </div>
              </div>
              <div class="point-card">
                <div class="point-icon" style="background:#ddeeff;">👥</div>
                <div>
                  <h4>친구 초대</h4>
                  <p>친구가 첫 대여 완료 시 포인트 지급</p>
                  <div class="rate">+1,000P</div>
                </div>
              </div>
              <div class="point-card">
                <div class="point-icon" style="background:#ece8fb;">🎂</div>
                <div>
                  <h4>생일 보너스</h4>
                  <p>생일 당월에 자동으로 적립돼요</p>
                  <div class="rate">+500P</div>
                </div>
              </div>
              <div class="point-card">
                <div class="point-icon" style="background:#faeeda;">📱</div>
                <div>
                  <h4>앱 출석</h4>
                  <p>매일 앱 접속 시 포인트 적립</p>
                  <div class="rate">+10P / 일</div>
                </div>
              </div>
            </div>
          </div>

          <!-- FAQ -->
          <div class="section-title">자주 묻는 질문</div>
          <div class="faq-list">
            <div class="faq-item" v-for="item in faqList" :key="item.faqId">
              <div class="faq-q" @click="toggleFaq($event)">
                {{ item.question }}
                <span class="arrow">▼</span>
              </div>
              <div class="faq-a">
                {{ item.answer }}
              </div>
            </div>
          </div>

          <!-- CTA -->
          <div class="cta">
            <div class="cta-text">
              <h3>지금 바로 시작하세요</h3>
              <p>가입만 해도 브론즈 혜택 즉시 적용, 첫 대여 시 추가 5% 할인!</p>
            </div>
            <div class="cta-btns">
              <button class="btn-join" @click="fnGoSignUp">회원가입</button>
              <button class="btn-login" @click="fnGoLogin">로그인</button>
            </div>
          </div>

        </div> <!-- wrap 닫기 -->
      </div> <!-- #app 닫기 -->
      <%@ include file="/WEB-INF/common/footer.jsp" %>
  </body>
  <script>

    const app = Vue.createApp({
      data() {
        return {
          info: {
            userName: '',
            gradeName: '',
            totalAmount: 0,
            minAmount: 0,
            point: 0,
            discountRate: 0
          },
          faqList: [

          ]
        };
      },

      computed: {
        currentGradeEmoji() {
          const emojiMap = {
            '브론즈': '🥉',
            '실버': '🥈',
            '골드': '🥇',
            'VVIP': '👑'
          };
          return emojiMap[this.info.gradeName] || '🏅';
        },

        currentGradeClass() {
          const classMap = {
            '브론즈': 'bronze',
            '실버': 'silver',
            '골드': 'gold',
            'VVIP': 'vvip'
          };
          return classMap[this.info.gradeName] || '';
        },

        nextGradeName() {
          const gradeMap = {
            '브론즈': '실버',
            '실버': '골드',
            '골드': 'VVIP',
            'VVIP': 'VVIP'
          };
          return gradeMap[this.info.gradeName] || '-';
        },

        nextGradeMinAmount() {
          const minMap = {
            '브론즈': 30000,
            '실버': 100000,
            '골드': 300000,
            'VVIP': 300000
          };
          return minMap[this.info.gradeName] || 0;
        },

        remainAmount() {
          if (this.info.gradeName === 'VVIP') {
            return 0;
          }
          return Math.max(this.nextGradeMinAmount - this.info.totalAmount, 0);
        },

        progressPercent() {
          if (this.info.gradeName === 'VVIP') {
            return 100;
          }

          if (!this.nextGradeMinAmount) {
            return 0;
          }

          return Math.min((this.info.totalAmount / this.nextGradeMinAmount) * 100, 100);
        }
      },

      methods: {
        toggleFaq(e) {
          const item = e.currentTarget.parentElement;
          item.classList.toggle("open");
        },
        isCurrentGrade(gradeName) {
          return this.info.gradeName === gradeName;
        },

        fnGetInfo() {
          let self = this;

          $.ajax({
            url: "/membership/info.dox",
            type: "POST",
            dataType: "json",
            success: function (data) {
              if (data.result === "success") {
                console.log(data);
                self.info = data.info;
              }
            }
          });
        },

        fnGetFAQ: function () {
          let self = this;
          let param = {

          }
          $.ajax({
            url: "http://localhost:8080/FAQ/list/5.dox",
            dataType: "json",
            type: "POST",
            data: param,
            success: function (data) {
              console.log(data);
              self.faqList = data.list;
            }
          });
        },

        fnGoSignUp: function() {
          location.href="/user/sign-up.do";
        },

        fnGoLogin: function() {
          location.href="/user/login.do";
        }
      },

      mounted() {
        let self = this;
        self.fnGetInfo();
        self.fnGetFAQ();
      }
    });

    app.mount('#app');
  </script>
  </body>

  </html>