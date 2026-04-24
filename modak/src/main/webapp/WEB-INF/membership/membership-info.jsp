<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>멤버십 등급 안내 - 모닥모닥</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/membership/membership-info.css">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
    <div class="wrap">

        <section class="hero">
            <div class="hero-badge">🏅 모닥모닥 멤버십</div>
            <h1>대여할수록 커지는<br><span>나만의 캠핑 혜택</span></h1>
            <p>등급이 올라갈수록 더 큰 할인, 더 많은 포인트, 더 빠른 예약을 누려보세요.</p>
        </section>

        <section class="my-grade" v-if="myInfo && myInfo.gradeId">
            <div class="grade-icon" :class="fnGradeClass(myInfo.gradeName)">
                {{ fnGradeIcon(myInfo.gradeName) }}
            </div>

            <div class="grade-meta">
                <div class="label">현재 나의 등급</div>
                <div class="name">{{ myInfo.gradeName }} 회원</div>
            </div>

            <div class="progress-wrap">
                <div class="progress-label">
                    <span>{{ nextGrade ? nextGrade.gradeName + '까지' : '최고 등급 달성!' }}</span>
                    <span v-if="nextGrade">
                        누적 {{ fnPrice(myInfo.totalAmount) }} / {{ fnPrice(nextGrade.minAmount) }}
                    </span>
                    <span v-else>누적 {{ fnPrice(myInfo.totalAmount) }}</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" :style="{width: progressPercent + '%'}"></div>
                </div>
            </div>

            <div class="grade-points">
                <div class="pts">{{ fnPoint(myInfo.point) }}</div>
                <div class="pts-label">보유 포인트</div>
            </div>
        </section>

        <h3 class="section-title">멤버십 등급 안내</h3>

        <section class="grade-grid">
            <div v-for="g in grades"
                 :key="g.gradeId"
                 class="grade-card"
                 :class="[fnGradeClass(g.gradeName), {current: myInfo && Number(myInfo.gradeId) === Number(g.gradeId)}]">

                <div v-if="myInfo && Number(myInfo.gradeId) === Number(g.gradeId)" class="current-label">
                    현재 등급
                </div>

                <div class="grade-emoji">{{ fnGradeIcon(g.gradeName) }}</div>
                <div class="grade-name">{{ g.gradeName }}</div>
                <div class="grade-cond">
                    {{ g.minAmount > 0 ? '누적 ' + fnPrice(g.minAmount) + ' 이상' : '가입 즉시' }}
                </div>

                <div class="grade-perks" v-if="g.benefitText">
                    <div class="perk" v-for="b in fnSplitBenefits(g.benefitText)" :key="b">
                        <span class="perk-dot"></span>
                        <span>{{ b }}</span>
                    </div>
                </div>
            </div>
        </section>

        <h3 class="section-title">등급별 혜택 비교</h3>

        <section class="benefit-table-wrap">
            <table class="benefit-table">
                <thead>
                    <tr>
                        <th>혜택 항목</th>
                        <th v-for="g in grades"
                            :key="g.gradeId"
                            :class="myInfo && Number(myInfo.gradeId) === Number(g.gradeId) ? 'highlight-col' : ''">
                            {{ fnGradeIcon(g.gradeName) }} {{ g.gradeName }}
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>포인트 적립률</td>
                        <td>1%</td>
                        <td>2%</td>
                        <td>3%</td>
                        <td>5%</td>
                    </tr>
                    <tr>
                        <td>대여 상시 할인</td>
                        <td>—</td>
                        <td>5%</td>
                        <td>10%</td>
                        <td>15%</td>
                    </tr>
                    <tr>
                        <td>생일 쿠폰</td>
                        <td>1장</td>
                        <td>2장</td>
                        <td>3장</td>
                        <td>5장</td>
                    </tr>
                    <tr>
                        <td>신규 장비 우선 예약</td>
                        <td>—</td>
                        <td>1일 전</td>
                        <td>2일 전</td>
                        <td>3일 전</td>
                    </tr>
                    <tr>
                        <td>무료 배송</td>
                        <td>—</td>
                        <td>—</td>
                        <td>월 2회</td>
                        <td>무제한</td>
                    </tr>
                    <tr>
                        <td>전담 고객센터</td>
                        <td>—</td>
                        <td>—</td>
                        <td>—</td>
                        <td>✔ 24시간</td>
                    </tr>
                    <tr>
                        <td>시즌 특별 쿠폰</td>
                        <td>—</td>
                        <td>연 2회</td>
                        <td>연 4회</td>
                        <td>연 6회</td>
                    </tr>
                    <tr>
                        <td>장비 연장 무료</td>
                        <td>—</td>
                        <td>—</td>
                        <td>연 1회</td>
                        <td>연 3회</td>
                    </tr>
                </tbody>
            </table>
        </section>

        <h3 class="section-title">포인트 적립 방법</h3>

        <section class="point-section">
            <div class="point-grid">
                <div class="point-card">
                    <div class="point-icon">📦</div>
                    <div>
                        <h4>장비 대여</h4>
                        <p>대여 금액에 따라 포인트 적립</p>
                        <div class="rate">최대 5%</div>
                    </div>
                </div>

                <div class="point-card">
                    <div class="point-icon">⭐</div>
                    <div>
                        <h4>리뷰 작성</h4>
                        <p>사진 리뷰 작성 시 포인트 지급</p>
                        <div class="rate">+200P</div>
                    </div>
                </div>

                <div class="point-card">
                    <div class="point-icon">👥</div>
                    <div>
                        <h4>친구 초대</h4>
                        <p>친구 가입 완료 시 포인트 지급</p>
                        <div class="rate">+1,000P</div>
                    </div>
                </div>

                <div class="point-card">
                    <div class="point-icon">🎂</div>
                    <div>
                        <h4>생일 보너스</h4>
                        <p>생일 달에 쿠폰 또는 포인트 지급</p>
                        <div class="rate">+500P</div>
                    </div>
                </div>

                <div class="point-card">
                    <div class="point-icon">📱</div>
                    <div>
                        <h4>앱 출석</h4>
                        <p>매일 출석 시 포인트 적립</p>
                        <div class="rate">+10P / 일</div>
                    </div>
                </div>
            </div>
        </section>

        <h3 class="section-title">자주 묻는 질문</h3>

        <section class="faq-list">
            <div class="faq-item"
                 v-for="(f, index) in faqs"
                 :key="f.faqId || index"
                 :class="{open: openFaq === index}">

                <div class="faq-q" @click="fnToggleFaq(index)">
                    <span>{{ f.question }}</span>
                    <span class="arrow">▼</span>
                </div>

                <div class="faq-a">
                    {{ f.answer }}
                </div>
            </div>

            <div class="faq-empty" v-if="faqs.length === 0">
                등록된 FAQ가 없습니다.
            </div>
        </section>

        <section class="cta">
            <div class="cta-text">
                <h3>지금 바로 시작하세요</h3>
                <p>가입만 해도 브론즈 혜택 즉시 적용, 첫 대여 시 추가 5% 할인</p>
            </div>

            <div class="cta-btns">
                <button class="btn-join" @click="fnGoJoin">무료 회원가입</button>
                <button class="btn-login" @click="fnGoLogin">로그인</button>
            </div>
        </section>

    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
const { createApp } = Vue;

createApp({
    data: function () {
        return {
            myInfo: {},
            grades: [],
            faqs: [],
            openFaq: null
        };
    },
    computed: {
        nextGrade: function () {
            if (!this.myInfo || !this.grades.length) return null;

            var total = Number(this.myInfo.totalAmount || 0);

            for (var i = 0; i < this.grades.length; i++) {
                if (Number(this.grades[i].minAmount || 0) > total) {
                    return this.grades[i];
                }
            }

            return null;
        },
        progressPercent: function () {
            if (!this.myInfo || !this.grades.length) return 0;

            var total = Number(this.myInfo.totalAmount || 0);

            if (!this.nextGrade) {
                return 100;
            }

            var prevAmount = 0;

            for (var i = 0; i < this.grades.length; i++) {
                if (Number(this.grades[i].gradeId) === Number(this.myInfo.gradeId)) {
                    prevAmount = Number(this.grades[i].minAmount || 0);
                    break;
                }
            }

            var nextAmount = Number(this.nextGrade.minAmount || 0);
            var range = nextAmount - prevAmount;

            if (range <= 0) return 0;

            var percent = ((total - prevAmount) / range) * 100;

            if (percent < 0) percent = 0;
            if (percent > 100) percent = 100;

            return percent;
        }
    },
    methods: {
        fnLoadMembership: function () {
            var self = this;

            $.ajax({
                url: "/membership/info.dox",
                type: "POST",
                dataType: "json",
                success: function (res) {
                    if (res.result === "success") {
                        self.myInfo = res.info || {};
                        self.grades = (res.allGrades || []).map(function (g) {
                            g.gradeId = Number(g.gradeId);
                            g.minAmount = Number(g.minAmount || 0);
                            g.discountRate = Number(g.discountRate || 0);
                            return g;
                        });
                    } else {
                        alert(res.message || "멤버십 정보를 불러오지 못했습니다.");
                    }
                },
                error: function () {
                    alert("멤버십 정보 조회 중 오류가 발생했습니다.");
                }
            });
        },
        fnLoadFaq: function () {
            var self = this;

            $.ajax({
                url: "/membership/faq/list.dox",
                type: "POST",
                dataType: "json",
                success: function (res) {
                    if (res.result === "success") {
                        self.faqs = res.faqs || [];
                    }
                }
            });
        },
        fnToggleFaq: function (index) {
            this.openFaq = this.openFaq === index ? null : index;
        },
        fnPrice: function (value) {
            return Number(value || 0).toLocaleString() + "원";
        },
        fnPoint: function (value) {
            return Number(value || 0).toLocaleString() + "P";
        },
        fnGradeIcon: function (name) {
            if (name === "브론즈") return "🥉";
            if (name === "실버") return "🥈";
            if (name === "골드") return "🥇";
            if (name === "VVIP") return "👑";
            return "🏕️";
        },
        fnGradeClass: function (name) {
            if (name === "브론즈") return "bronze";
            if (name === "실버") return "silver";
            if (name === "골드") return "gold";
            if (name === "VVIP") return "vvip";
            return "";
        },
        fnGoJoin: function () {
            location.href = "/user/sign.do";
        },
        fnGoLogin: function () {
            location.href = "/user/login.do";
        },
        fnSplitBenefits: function (text) {
            if (!text) return [];

            return text.split(",").map(function (v) {
                return v.trim();
            }).filter(function (v) {
                return v !== "";
            });
        }
    },
    mounted: function () {
        this.fnLoadMembership();
        this.fnLoadFaq();
    }
}).mount("#app");
</script>

</body>
</html>