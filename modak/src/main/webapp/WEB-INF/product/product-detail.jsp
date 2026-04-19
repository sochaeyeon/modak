<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - {{ product.productName || '상품 상세' }}</title>
    <link rel="stylesheet" href="/css/product/product-detail.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
    <div class="wrap" v-if="!loading">
        <div class="crumb">
            <a href="/">홈</a> › <a href="#">캠핑 장비</a> › <span>{{ product.categoryName }}</span> › 
            <span style="color:var(--muted)">{{ product.productName }}</span>
        </div>

        <div class="ptop">
            <div class="gallery">
                <div class="gm">
                    <span class="gtag" v-if="product.isBest === 'Y'">베스트</span>
                    <div class="gem">
                        <img :src="'/product-img/' + product.imgUrl" v-if="product.imgUrl" style="width:100%; height:100%; object-fit:cover;">
                        <span v-else>⛺</span>
                    </div>
                </div>
            </div>

            <div class="pinfo">
                <div class="pbrand">{{ product.brandName }} · {{ product.categoryName }}</div>
                <h1 class="ptitle">{{ product.productName }}</h1>
                
                <div class="rrow">
                    <div class="stars">
                        <span class="st" v-for="i in 5" :key="i" :style="{ color: i <= product.rating ? '#e07a3b' : '#ddd' }">★</span>
                    </div>
                    <span style="font-size:13px;font-weight:500">{{ product.rating }}</span>
                    <span style="font-size:12px;color:var(--muted)"> (리뷰 {{ product.reviewCount }}개)</span>
                </div>

                <div class="mtog">
                    <button class="mbtn" :class="{ on: mode === 'buy' }" @click="setMode('buy')">🛒 구매하기</button>
                    <button class="mbtn" :class="{ on: mode === 'rent' }" @click="setMode('rent')">📅 대여하기</button>
                </div>

                <div class="buy-only" v-if="mode === 'buy'">
                    <div class="pbox-buy">
                        <div class="prow">
                            <span class="pct" v-if="product.discount > 0">{{ product.discount }}%</span>
                            <span class="pnow">{{ (product.price || 0).toLocaleString() }}원</span>
                        </div>
                        <div class="porig" v-if="product.originPrice">{{ product.originPrice.toLocaleString() }}원</div>
                    </div>
                    
                    <div class="osec">
                        <div class="olabel">수량</div>
                        <div class="qrow">
                            <button class="qbtn" @click="chgQ(-1)">−</button>
                            <input class="qinp" type="number" :value="qty" readonly>
                            <button class="qbtn" @click="chgQ(1)">+</button>
                        </div>
                    </div>
                </div>

                <div class="rent-only" v-if="mode === 'rent'">
                    <div class="pbox-rent">
                        <div class="prow">
                            <span class="rent-per">1박당</span>
                            <span class="rent-num">{{ (product.rentPrice || 0).toLocaleString() }}원</span>
                        </div>
                    </div>
                    
                    <div class="calsec">
                        <div class="olabel">📅 대여 날짜 선택</div>
                        <div class="calwrap">
                            <div class="calhead">
                                <button class="cnav" @click="prevMo">‹</button>
                                <span class="cmonth">{{ calY }}년 {{ calM + 1 }}월</span>
                                <button class="cnav" @click="nextMo">›</button>
                            </div>
                            <div class="calgrid">
                                <div class="calwds">
                                    <div class="cwd" style="color:var(--red)">일</div>
                                    <div class="cwd">월</div><div class="cwd">화</div><div class="cwd">수</div><div class="cwd">목</div><div class="cwd">금</div>
                                    <div class="cwd" style="color:var(--blue)">토</div>
                                </div>
                                <div class="caldays">
                                    <div v-for="blank in firstDay" :key="'b'+blank" class="cday emp"></div>
                                    <div v-for="d in lastDate" :key="d" 
                                         class="cday" 
                                         :class="getDayClass(d)"
                                         @click="selectDate(d)">
                                        {{ d }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="trow">
                    <span style="font-size:13px;color:var(--muted)">총 금액</span>
                    <span class="tprice">{{ totalPrice.toLocaleString() }}원</span>
                </div>

                <div class="arow">
                    <button class="bwish" @click="isWished = !isWished">
                        {{ isWished ? '❤️' : '🤍' }}
                    </button>
                    <button class="bbuy" v-if="mode === 'buy'">바로 구매하기</button>
                    <button class="brent" v-else :disabled="!rE">대여 신청하기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
const { createApp } = Vue;

createApp({
    data() {
        return {
            productId: '${param.productId}',
            product: {},
            loading: true,
            mode: 'buy',
            qty: 1,
            isWished: false,
            
            // 달력 관련 데이터
            today: new Date(new Date().setHours(0,0,0,0)),
            calY: new Date().getFullYear(),
            calM: new Date().getMonth(),
            rS: null, // 시작일 (Date 객체)
            rE: null  // 종료일 (Date 객체)
        };
    },
    computed: {
        totalPrice() {
            if (this.mode === 'buy') {
                return (this.product.price || 0) * this.qty;
            } else {
                if (!this.rS || !this.rE) return 0;
                const nights = Math.round((this.rE - this.rS) / (1000 * 60 * 60 * 24));
                return nights * (this.product.rentPrice || 0);
            }
        },
        firstDay() { return new Date(this.calY, this.calM, 1).getDay(); },
        lastDate() { return new Date(this.calY, this.calM + 1, 0).getDate(); }
    },
    methods: {
        fnDetail() {
            let self = this;
            $.ajax({
                url: "/product/detail.dox",
                type: "POST",
                data: { productId: self.productId },
                success: function(data) {
                    self.product = data.item;
                    self.loading = false;
                }
            });
        },
        setMode(m) { this.mode = m; },
        chgQ(d) { this.qty = Math.max(1, this.qty + d); },
        
        // 달력 로직
        prevMo() { if (this.calM === 0) { this.calM = 11; this.calY--; } else { this.calM--; } },
        nextMo() { if (this.calM === 11) { this.calM = 0; this.calY++; } else { this.calM++; } },
        
        getDayClass(d) {
            const curr = new Date(this.calY, this.calM, d);
            const classes = [];
            if (curr < this.today) classes.push('past');
            if (this.rS && curr.getTime() === this.rS.getTime()) classes.push('rs');
            if (this.rE && curr.getTime() === this.rE.getTime()) classes.push('re');
            if (this.rS && this.rE && curr > this.rS && curr < this.rE) classes.push('ir');
            return classes;
        },
        selectDate(d) {
            const dt = new Date(this.calY, this.calM, d);
            if (dt < this.today) return;

            if (!this.rS || (this.rS && this.rE)) {
                this.rS = dt;
                this.rE = null;
            } else {
                if (dt < this.rS) {
                    this.rS = dt;
                } else if (dt.getTime() === this.rS.getTime()) {
                    this.rS = null;
                } else {
                    this.rE = dt;
                }
            }
        }
    },
    mounted() {
        this.fnDetail();
    }
}).mount('#app');
</script>

<style>
[v-cloak] { display: none; }
/* 선택된 날짜 및 범위 스타일 */
.cday.rs, .cday.re { background: #e07a3b !important; color: white !important; border-radius: 50%; }
.cday.ir { background: #fdf2e9; }
.cday.past { color: #ccc; cursor: default; }
</style>
</body>
</html>