<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 불꽃처럼 빛나는 캠핑 라이프</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
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
                <a href="/main.do"><span>홈</span></a> › <a href="/user/mypage.do"><span>마이페이지</span></a> › <span class="cur">멤버십 혜택</span>
            </div>
        </div>

        <div class="wrap" v-if="isLoaded">
            <div class="hero">
                <div class="hero-badge">🏅 모닥모닥 멤버십</div>
                <h1>대여할수록 커지는<br><span>나만의 캠핑 혜택</span></h1>
                <p>등급이 올라갈수록 더 큰 할인, 더 많은 포인트, 더 빠른 예약을 누려보세요.</p>
            </div>

            <div class="my-grade">
                <div class="grade-icon" :class="getGradeClass(info.gradeName)">{{ getGradeEmoji(info.gradeName) }}</div>
                <div class="grade-meta">
                    <div class="label">현재 나의 등급</div>
                    <div class="name">{{ info.gradeName || '일반' }} 회원</div>
                </div>
                <div class="progress-wrap">
                    <div class="progress-label">
                        <span>{{ info.gradeName }}</span>
                        <span v-if="nextGrade">
                            → {{ getVal(nextGrade, 'GRADE_NAME') }}까지 
                            <strong style="color:#e8610a;">{{ (remainAmount || 0).toLocaleString() }}원</strong> 남음
                        </span>
                        <span v-else>최고 등급 달성! 👑</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" :style="{ width: progressPercent + '%' }"></div>
                    </div>
                    <div style="font-size:11px;color:#bbb;margin-top:5px;text-align:right;">
                        누적 대여금액 {{ (info.totalAmount || 0).toLocaleString() }}원 
                        <span v-if="nextGrade"> / {{ (getVal(nextGrade, 'MIN_AMOUNT') || 0).toLocaleString() }}원</span>
                    </div>
                </div>
                <div class="grade-points">
                    <div class="pts">{{ (info.point || 0).toLocaleString() }}P</div>
                    <div class="pts-label">보유 포인트</div>
                </div>
            </div>

            <div class="section-title">멤버십 등급 안내</div>
            <div class="grade-grid">
                <div v-for="g in gradeList" :key="getVal(g, 'GRADE_ID')" 
                     class="grade-card" :class="[getGradeClass(getVal(g, 'GRADE_NAME')), { current: isCurrentGrade(getVal(g, 'GRADE_NAME')) }]">
                    
                    <div class="current-label" v-if="isCurrentGrade(getVal(g, 'GRADE_NAME'))">현재 등급</div>
                    <div class="grade-emoji">{{ getGradeEmoji(getVal(g, 'GRADE_NAME')) }}</div>
                    <div class="grade-name">{{ getVal(g, 'GRADE_NAME') }}</div>
                    <div class="grade-cond">{{ getVal(g, 'DESCRIPTION') }}</div>
                    
                    <div class="grade-perks">
                        <div class="perk" v-for="(benefit, bIdx) in splitBenefits(getVal(g, 'BENEFIT_TEXT'))" :key="bIdx">
                            <div class="perk-dot"></div>
                            <span>{{ benefit }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="section-title">등급별 혜택 비교</div>
            <div class="benefit-table-wrap" style="margin-bottom:48px;">
                <table class="benefit-table">
                    <thead>
                        <tr>
                            <th style="text-align:left;">혜택 항목</th>
                            <th v-for="g in gradeList" :class="{ 'highlight-col': isCurrentGrade(getVal(g, 'GRADE_NAME')) }">
                                {{ getVal(g, 'GRADE_NAME') }}
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>상시 할인율</td>
                            <td v-for="g in gradeList" :class="{ 'val-orange': isCurrentGrade(getVal(g, 'GRADE_NAME')) }">
                                {{ getVal(g, 'DISCOUNT_RATE') }}%
                            </td>
                        </tr>
                        <tr>
                            <td>승급 조건액</td>
                            <td v-for="g in gradeList" :class="{ 'val-orange': isCurrentGrade(getVal(g, 'GRADE_NAME')) }">
                                {{ (getVal(g, 'MIN_AMOUNT') || 0).toLocaleString() }}원
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div v-else style="text-align:center; padding:150px 0;">
            <p style="color:#888;">데이터를 안전하게 동기화 중입니다...</p>
        </div>
    </div>
    <%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
    const app = Vue.createApp({
        data() {
            return {
                info: { gradeName: '', totalAmount: 0, point: 0 },
                gradeList: [],
                isLoaded: false
            };
        },
        computed: {
            currentGradeObj() {
                if(!this.gradeList.length) return null;
                return this.gradeList.find(g => this.getVal(g, 'GRADE_NAME') === this.info.gradeName);
            },
            nextGrade() {
                if (!this.gradeList.length) return null;
                const idx = this.gradeList.findIndex(g => this.getVal(g, 'GRADE_NAME') === this.info.gradeName);
                return (idx >= 0 && idx < this.gradeList.length - 1) ? this.gradeList[idx + 1] : null;
            },
            remainAmount() {
                if (!this.nextGrade) return 0;
                return Math.max((this.getVal(this.nextGrade, 'MIN_AMOUNT') || 0) - (this.info.totalAmount || 0), 0);
            },
            progressPercent() {
                if (!this.nextGrade) return 100;
                const currMin = this.currentGradeObj ? (this.getVal(this.currentGradeObj, 'MIN_AMOUNT') || 0) : 0;
                const nextMin = this.getVal(this.nextGrade, 'MIN_AMOUNT') || 1;
                const myTotal = this.info.totalAmount || 0;
                const percent = ((myTotal - currMin) / (nextMin - currMin)) * 100;
                return Math.min(Math.max(percent, 0), 100);
            }
        },
        methods: {
            // [방어코드] 대소문자, CamelCase 상관없이 서버 데이터를 찾아내는 함수
            getVal(obj, key) {
                if (!obj) return '';
                if (obj[key] !== undefined) return obj[key]; // 대문자 (GRADE_NAME)
                const camelKey = key.toLowerCase().replace(/_([a-z])/g, (g) => g[1].toUpperCase());
                if (obj[camelKey] !== undefined) return obj[camelKey]; // CamelCase (gradeName)
                if (obj[key.toLowerCase()] !== undefined) return obj[key.toLowerCase()]; // 소문자
                return '';
            },

            // [핵심] DB의 '혜택1,혜택2' 문자열을 배열로 쪼개는 함수
            splitBenefits(text) {
                if (!text || text.trim() === '') return ['기본 혜택 제공'];
                return text.split(',').map(item => item.trim());
            },

            isCurrentGrade(name) { return this.info.gradeName === name; },
            getGradeClass(name) {
                const map = { '브론즈': 'bronze', '실버': 'silver', '골드': 'gold', 'VVIP': 'vvip' };
                return map[name] || 'bronze';
            },
            getGradeEmoji(name) {
                const map = { '브론즈': '🥉', '실버': '🥈', '골드': '🥇', 'VVIP': '👑' };
                return map[name] || '🏅';
            },

            fnGetInfo() {
                let self = this;
                $.ajax({
                    url: "/membership/info.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.info = data.info || { gradeName: '', totalAmount: 0, point: 0 };
                            self.gradeList = data.allGrades || [];
                        }
                        // 데이터가 세팅된 직후 로딩 해제
                        self.$nextTick(() => { self.isLoaded = true; });
                    },
                    error: function() { self.isLoaded = true; }
                });
            }
        },
        mounted() {
            this.fnGetInfo();
        }
    });
    app.mount('#app');
</script>
</body>
</html>