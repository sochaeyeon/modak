<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>모닥모닥 - 대여 예약</title>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rental/rental-calendar.css">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>

    <body>

        <div id="app" class="main-wrapper">
            <div class="product-info-side">
                <span class="product-badge">RENTAL ITEM</span>
                <div class="product-img-box">
                    <img v-if="!imageError && productImg"
                        :src="'${pageContext.request.contextPath}/product-img/' + productImg"
                        @error="imageError = true">

                    <div v-else style="text-align: center; color: #A8A092;">
                        <div style="font-size: 3rem; margin-bottom: 10px;">⛺</div>
                        준비 중인 이미지입니다
                    </div>
                </div>

                <h2 style="font-size:1.8rem; margin-bottom:15px; color:var(--brown);">{{ productName }}</h2>
                <p style="color:#777; line-height:1.7; margin-bottom:30px; font-size:0.95rem;">
                    모닥모닥이 검수한 프리미엄 장비입니다.<br>
                    즐거운 캠핑의 시작을 함께하세요.
                </p>

                <div style="padding-top:20px; border-top:1px solid #f0f0f0;">
                    <p style="font-size:0.85rem; color:#aaa; margin-bottom:5px;">1박 대여가</p>
                    <p style="font-size:1.6rem; font-weight:bold; color:var(--brown);">
                        {{ dailyPrice.toLocaleString() }}원
                    </p>
                </div>
            </div>

            <div class="calendar-side">
                <div class="cal-nav">
                    <button @click="changeMonth(-1)">‹</button>
                    <h2 style="font-weight: bold;">{{ currentYear }}년 {{ currentMonth + 1 }}월</h2>
                    <button @click="changeMonth(1)">›</button>
                </div>

                <div class="cal-grid">
                    <div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">{{w}}</div>
                    <div v-for="(day, idx) in calendarDays" :key="idx" :class="getDayClass(day)"
                        @click="onDayClick(day)">
                        <span v-if="day">{{ day.date }}</span>
                    </div>
                </div>

                <div class="booking-summary">
                    <div v-if="startDate && endDate">
                        <p style="font-size:0.9rem; color:#888; margin-bottom:5px;">{{ startDate }} ~ {{ endDate }} ({{
                            rentDays }}박)</p>
                        <div style="font-size:1.8rem; font-weight:bold; color:var(--orange);">{{ (dailyPrice *
                            rentDays).toLocaleString() }}원</div>
                    </div>
                    <div v-else-if="startDate" style="color:var(--orange); font-weight:bold;">종료일을 선택해주세요.</div>
                    <div v-else style="color:#bbb;">캘린더에서 예약 날짜를 선택해주세요.</div>

                    <button v-if="startDate && endDate" class="btn-rent" @click="fnRent">대여 신청하기</button>
                </div>
            </div>
        </div>

        <script>
            const { createApp } = Vue;
            createApp({
                data() {
                    return {
                        itemId: new URLSearchParams(location.search).get('itemId') || 9,
                        productImg: '', // DB에서 가져온 실제 이미지 파일명닥!
                        imageError: false,
                        currentYear: new Date().getFullYear(),
                        currentMonth: new Date().getMonth(),
                        rentedRanges: [],
                        startDate: null,
                        endDate: null,
                        dailyPrice: 0,
                        productName: ''
                    }
                },
                computed: {
                    calendarDays() {
                        const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
                        const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
                        const days = [];
                        for (let i = 0; i < firstDay; i++) days.push(null);
                        for (let d = 1; d <= lastDate; d++) {
                            const dateObj = new Date(this.currentYear, this.currentMonth, d);
                            const fullStr = this.formatDate(dateObj);
                            days.push({
                                date: d,
                                full: fullStr,
                                isRented: this.checkIsRented(fullStr),
                                isPast: dateObj < new Date().setHours(0, 0, 0, 0)
                            });
                        }
                        return days;
                    },
                    rentDays() {
                        if (!this.startDate || !this.endDate) return 0;
                        return Math.ceil((new Date(this.endDate) - new Date(this.startDate)) / (1000 * 60 * 60 * 24));
                    }
                },
                methods: {
                    formatDate(dateVal) {
                        if (!dateVal) return "";
                        let d = new Date(dateVal);
                        if (isNaN(d.getTime()) && typeof dateVal === 'string') {
                            const regex = /(\d+)월\s+(\d+),\s+(\d+)/;
                            const match = dateVal.match(regex);
                            if (match) d = new Date(parseInt(match[3]), parseInt(match[1]) - 1, parseInt(match[2]));
                        }
                        if (isNaN(d.getTime())) return "";
                        return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
                    },
                    checkIsRented(targetStr) {
                        if (!this.rentedRanges || this.rentedRanges.length === 0) return false;
                        return this.rentedRanges.some(range => {
                            const s = this.formatDate(range.startDate || range.START_DATE);
                            const e = this.formatDate(range.returnDate || range.RETURN_DATE);
                            return targetStr >= s && targetStr <= e;
                        });
                    },
                    getDayClass(day) {
                        if (!day) return 'cal-day empty';
                        if (day.isRented) return 'cal-day rented';
                        if (day.isPast) return 'cal-day past';
                        if (day.full === this.startDate || day.full === this.endDate) return 'cal-day selected';
                        if (this.startDate && this.endDate && day.full > this.startDate && day.full < this.endDate) return 'cal-day in-range';
                        return 'cal-day available';
                    },
                    onDayClick(day) {
                        if (!day || day.isPast || day.isRented) return;
                        if (!this.startDate || (this.startDate && this.endDate)) {
                            this.startDate = day.full; this.endDate = null;
                        } else {
                            if (day.full < this.startDate) this.startDate = day.full;
                            else if (day.full === this.startDate) this.startDate = null;
                            else this.endDate = day.full;
                        }
                    },
                    changeMonth(diff) {
                        const newDate = new Date(this.currentYear, this.currentMonth + diff, 1);
                        this.currentYear = newDate.getFullYear();
                        this.currentMonth = newDate.getMonth();
                    },
                    fetchData() {
                        $.ajax({
                            url: '/rental/calendar/dates.dox',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ itemId: this.itemId }),
                            success: (res) => {
                                if (res.result === 'success') {
                                    this.rentedRanges = res.rentedList;
                                    this.dailyPrice = res.priceInfo.dailyPrice;
                                    this.productName = res.priceInfo.itemName;
                                    this.productImg = res.priceInfo.imgUrl; // DB의 IMG_URL을 여기에 저장닥!
                                }
                            }
                        });
                    },
                    fnRent() {
                        if (!confirm("대여 신청하시겠습니까?")) return;
                        $.ajax({
                            url: '/rental/apply.dox',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ itemId: this.itemId, startDate: this.startDate, endDate: this.endDate }),
                            success: (res) => { if (res.result === 'success') { alert('신청 완료!'); location.reload(); } }
                        });
                    }
                },
                mounted() { this.fetchData(); }
            }).mount('#app');
        </script>
    </body>

    </html>