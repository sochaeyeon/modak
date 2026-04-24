<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>모닥모닥 - 캠핑장 지도 서비스</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/camp/camp-map.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false&libraries=services"></script>
    </head>

    <body>

        <div id="app" v-cloak>

            <div class="side-panel">
                <div class="panel-header">
                    <span class="logo-text" onclick="location.href='/main.do'">⛺ 모닥모닥</span>

                    <div class="search-wrap">
                        <input type="text" class="search-input" v-model="searchKeyword" placeholder="이름·주소·설명 검색..."
                            @keydown.enter="fnSearch">
                        <button class="search-btn" @click="fnSearch">검색</button>
                    </div>

                    <div class="tag-wrap">
                        <button v-for="tag in tagList" :key="tag" class="tag-btn" :class="{ active: activeTag === tag }"
                            @click="fnTagSearch(tag)">{{ tag }}</button>
                    </div>

                    <select v-model="selectedArea" class="area-select" @change="fnFilterArea">
                        <option value="">전국 전체</option>
                        <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
                    </select>

                    <div class="search-info">검색 결과: <b>{{ filteredList.length }}</b>건</div>
                </div>

                <ul class="camp-list">
                    <li v-for="item in filteredList" :key="item.contentId" class="camp-item"
                        :class="{ active: selectedItem && selectedItem.contentId === item.contentId }"
                        @click="panTo(item)">
                        <div class="camp-title">{{ item.facltNm }}</div>
                        <div class="camp-address">📍 {{ item.addr1 }}</div>
                        <button @click.stop="openDetail(item)" class="btn-detail">상세보기</button>
                    </li>
                    <li v-if="filteredList.length === 0"
                        style="padding:24px;text-align:center;color:var(--brown4);font-size:13px">
                        검색 결과가 없습니다.
                    </li>
                </ul>
            </div>

            <div class="map-container">
                <div id="map"></div>

                <div class="facility-btns" v-if="selectedItem">
                    <button class="facility-btn" :class="{ active: activeFacility === 'HP8' }"
                        @click="fnToggleFacility('HP8')">🏥 병원</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'CS2' }"
                        @click="fnToggleFacility('CS2')">🏪 편의점</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'PM9' }"
                        @click="fnToggleFacility('PM9')">💊 약국</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'PK6' }"
                        @click="fnToggleFacility('PK6')">⛽ 주유소</button>
                    <button class="facility-btn-clear" v-if="activeFacility" @click="fnClearFacility">✕ 초기화</button>
                </div>
            </div>

            <!-- 캠핑장 상세 모달 -->
            <div v-if="isModalOpen" class="modal-overlay" @click.self="isModalOpen = false">
                <div class="modal-content">
                    <button class="modal-close-btn" @click="isModalOpen = false">✕</button>

                    <div class="modal-img-wrapper">
                        <img v-if="detailItem.firstImageUrl" :src="detailItem.firstImageUrl" class="modal-img"
                            @error="detailItem.firstImageUrl = null">
                        <div v-else class="no-img-text">🏕️ 등록된 이미지가 없습니다</div>
                    </div>

                    <div class="modal-body">
                        <h2 class="detail-title">{{ detailItem.facltNm }}</h2>
                        <p class="detail-addr">📍 {{ detailItem.addr1 }}</p>
                        <div class="detail-intro">
                            {{ detailItem.lineIntro || '소개 정보가 등록되지 않은 캠핑장입니다.' }}
                        </div>

                        <div class="facility-section">
                            <p class="facility-section-title">📍 주변 편의시설</p>
                            <div class="facility-tabs">
                                <button class="facility-tab" :class="{ active: modalFacTab === 'HP8' }"
                                    @click="fnModalFacility('HP8')">🏥 병원</button>
                                <button class="facility-tab" :class="{ active: modalFacTab === 'CS2' }"
                                    @click="fnModalFacility('CS2')">🏪 편의점</button>
                                <button class="facility-tab" :class="{ active: modalFacTab === 'PM9' }"
                                    @click="fnModalFacility('PM9')">💊 약국</button>
                                <button class="facility-tab" :class="{ active: modalFacTab === 'PK6' }"
                                    @click="fnModalFacility('PK6')">⛽ 주유소</button>
                            </div>
                            <div class="facility-loading" v-if="isFacLoading">⏳ 검색 중...</div>
                            <div class="facility-list" v-else-if="facilityList.length > 0">
                                <div v-for="fac in facilityList" :key="fac.id" class="facility-item">
                                    <span class="facility-icon">{{ facIcon(modalFacTab) }}</span>
                                    <span class="facility-name">{{ fac.place_name }}</span>
                                    <div class="facility-dist">
                                        <b>{{ fnFormatDist(fac.distance) }}</b>
                                        {{ fnWalkTime(fac.distance) }} 도보
                                    </div>
                                </div>
                            </div>
                            <div class="facility-empty" v-else-if="modalFacTab && !isFacLoading">반경 5km 내 결과가 없습니다.
                            </div>
                            <div class="facility-empty" v-else>탭을 선택하면 주변 시설을 검색합니다.</div>
                        </div>

                        <div class="review-box">
                            <div class="review-header-row">
                                <h3 class="review-header">방문객 리뷰 ({{ reviewList.length }})</h3>
                                <button v-if="reviewList.length > 0" class="btn-review-all"
                                    @click="openReviewModal">전체보기</button>
                            </div>

                            <div class="facility-loading" v-if="isReviewLoading">⏳ 리뷰 불러오는 중...</div>
                            <div v-else-if="reviewList.length > 0">
                                <!-- 미리보기 3개 — 클릭 시 단건 상세 -->
                                <div v-for="rev in reviewList.slice(0, 3)" :key="rev.CAMP_REVIEW_ID"
                                    class="review-item review-item-clickable" @click="openReviewDetail(rev)">
                                    <div class="review-meta">
                                        <span>
                                            <b class="rating-star">{{ fnStars(rev.rating) }}</b>
                                            <span class="review-rating-num">{{ rev.rating }}</span>
                                            | <b>{{ rev.userId }}</b>
                                        </span>
                                        <span class="review-date">{{ rev.createdAt }}</span>
                                    </div>
                                    <div class="review-content review-content-clamp">{{ rev.content }}</div>
                                </div>
                                <button v-if="reviewList.length > 3" class="btn-more-review" @click="openReviewModal">
                                    리뷰 {{ reviewList.length - 3 }}개 더보기 ›
                                </button>
                            </div>
                            <div v-else class="no-data">아직 작성된 리뷰가 없습니다.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 리뷰 전체보기 모달 — ★ parseInt 로 타입 통일 -->
            <div v-if="isReviewModalOpen" class="modal-overlay review-modal-overlay"
                @click.self="isReviewModalOpen = false">
                <div class="modal-content review-modal-content">
                    <div class="review-modal-header">
                        <div>
                            <h3 class="review-modal-title">방문객 리뷰</h3>
                            <p class="review-modal-camp">{{ detailItem.facltNm }}</p>
                        </div>
                        <button class="modal-close-btn" style="position:static"
                            @click="isReviewModalOpen = false">✕</button>
                    </div>

                    <div class="review-avg-wrap">
                        <span class="review-avg-star">{{ fnStars(reviewAvg) }}</span>
                        <span class="review-avg-num">{{ reviewAvg }}</span>
                        <span class="review-avg-count">/ 5.0 · 총 {{ reviewList.length }}개</span>
                    </div>

                    <div class="review-list-scroll">
                        <div v-for="rev in reviewList" :key="rev.CAMP_REVIEW_ID || rev.campReviewId"
                            class="review-item review-item-full"
                            :class="{ 'review-item-selected': selectedReviewId === parseInt(rev.CAMP_REVIEW_ID || rev.campReviewId) }"
                            @click="fnToggleReview(rev)">

                            <div class="review-meta">
                                <span>
                                    <b class="rating-star">{{ fnStars(rev.rating) }}</b>
                                    <span class="review-rating-num">{{ rev.rating }}</span>
                                    | <b>{{ rev.userId }}</b>
                                </span>
                                <span class="review-date">{{ rev.createdAt }}</span>
                            </div>

                            <div class="review-content"
                                :class="{ 'review-content-clamp': selectedReviewId !== parseInt(rev.CAMP_REVIEW_ID || rev.campReviewId) }">
                                {{ rev.content }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 리뷰 단건 상세 카드 -->
            <div v-if="isReviewDetailOpen" class="modal-overlay" style="z-index: 2000;"
                @click.self="isReviewDetailOpen = false">
                <div class="review-detail-card">
                    <button class="modal-close-btn" style="position:absolute; top:16px; right:16px;"
                        @click="isReviewDetailOpen = false">✕</button>
                    <div class="review-detail-stars">{{ fnStars(selectedReviewDetail.rating) }}</div>
                    <div class="review-detail-rating">{{ selectedReviewDetail.rating }} / 5</div>
                    <div class="review-detail-user">{{ selectedReviewDetail.userId }}</div>
                    <div class="review-detail-date">{{ selectedReviewDetail.createdAt }}</div>
                    <div class="review-detail-content">{{ selectedReviewDetail.content }}</div>
                </div>
            </div>

        </div>

        <script>
            var vueApp = Vue.createApp({
                data: function () {
                    return {
                        map: null, markers: [], facMarkers: [], places: null,
                        allData: [], filteredList: [],
                        cities: ['서울', '경기', '강원', '인천', '충북', '충남', '대전', '세종', '전북', '전남', '광주', '경북', '경남', '대구', '울산', '부산', '제주'],
                        selectedArea: '', searchKeyword: '', activeTag: '', selectedItem: null,
                        isModalOpen: false, detailItem: {},
                        reviewList: [], isReviewLoading: false,
                        isReviewModalOpen: false,
                        selectedReviewId: -1,        /* ★ -1 = 선택 없음 */
                        isReviewDetailOpen: false, selectedReviewDetail: {},
                        activeFacility: '', modalFacTab: '', facilityList: [], isFacLoading: false,
                        tagList: ['텐트', '글램핑', '카라반', '오토캠핑', '펜션', '수영장', '계곡', '바다', '숲속', '반려동물']
                    };
                },
                computed: {
                    reviewAvg: function () {
                        if (!this.reviewList.length) return '0.0';
                        var sum = 0;
                        this.reviewList.forEach(function (r) { sum += parseFloat(r.rating) || 0; });
                        return (sum / this.reviewList.length).toFixed(1);
                    }
                },
                methods: {
                    fnInit: function () {
                        var self = this;
                        kakao.maps.load(function () {
                            var container = document.getElementById('map');
                            self.map = new kakao.maps.Map(container, { center: new kakao.maps.LatLng(36.5, 127.8), level: 11 });
                            self.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                            self.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
                            self.places = new kakao.maps.services.Places();
                            self.fnFetch();
                        });
                    },
                    fnFetch: function () {
                        var self = this;
                        $.ajax({
                            url: '/camp/list.dox', type: 'POST', dataType: 'json',
                            success: function (data) {
                                self.allData = data.list || [];
                                self.filteredList = self.allData;
                                self.drawMarkers(self.allData);
                            }
                        });
                    },
                    fnSearch: function () { this.fnApplyFilter(); },
                    fnTagSearch: function (tag) { this.activeTag = (this.activeTag === tag) ? '' : tag; this.searchKeyword = ''; this.fnApplyFilter(); },
                    fnFilterArea: function () { this.fnApplyFilter(); },
                    fnApplyFilter: function () {
                        var area = this.selectedArea;
                        var keyword = (this.searchKeyword || '').trim().toLowerCase();
                        var tag = (this.activeTag || '').trim().toLowerCase();
                        var result = this.allData.filter(function (item) {
                            if (area && !(item.addr1 && item.addr1.indexOf(area) > -1)) return false;
                            if (keyword) {
                                var nm = (item.facltNm || '').toLowerCase();
                                var addr = (item.addr1 || '').toLowerCase();
                                var desc = (item.lineIntro || '').toLowerCase();
                                var indu = (item.induty || '').toLowerCase();
                                if (nm.indexOf(keyword) === -1 && addr.indexOf(keyword) === -1 &&
                                    desc.indexOf(keyword) === -1 && indu.indexOf(keyword) === -1) return false;
                            }
                            if (tag) {
                                var nm = (item.facltNm || '').toLowerCase();
                                var addr = (item.addr1 || '').toLowerCase();
                                var desc = (item.lineIntro || '').toLowerCase();
                                var indu = (item.induty || '').toLowerCase();
                                var sbrnd = (item.sbrndCl || '').toLowerCase();
                                var animal = (item.animalCmgCl || '').toLowerCase();
                                var theme = (item.themaEnvrnCl || '').toLowerCase();
                                if (tag === '반려동물') {
                                    var hasAnimal = animal.indexOf('가능') > -1 || animal.indexOf('반려') > -1
                                        || desc.indexOf('반려') > -1 || indu.indexOf('반려') > -1 || nm.indexOf('반려') > -1;
                                    if (!hasAnimal) return false;
                                } else {
                                    if (nm.indexOf(tag) === -1 && addr.indexOf(tag) === -1 && desc.indexOf(tag) === -1 &&
                                        indu.indexOf(tag) === -1 && sbrnd.indexOf(tag) === -1 && theme.indexOf(tag) === -1) return false;
                                }
                            }
                            return true;
                        });
                        this.filteredList = result;
                        this.drawMarkers(result);
                        if (result.length > 0) this.panTo(result[0]);
                    },
                    drawMarkers: function (list) {
                        var self = this;
                        this.markers.forEach(function (m) { m.setMap(null); });
                        this.markers = [];
                        list.forEach(function (item) {
                            if (!item.mapY || !item.mapX) return;
                            var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX)), map: self.map });
                            kakao.maps.event.addListener(marker, 'click', function () { self.openDetail(item); });
                            self.markers.push(marker);
                        });
                    },
                    panTo: function (item) {
                        if (!item.mapY || !item.mapX) return;
                        this.selectedItem = item;
                        this.map.panTo(new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX)));
                        this.map.setLevel(7);
                        this.fnClearFacility();
                    },
                    openDetail: function (item) {
                        var self = this;
                        this.detailItem = item;
                        this.isModalOpen = true;
                        this.modalFacTab = '';
                        this.facilityList = [];
                        this.reviewList = [];
                        this.selectedItem = item;
                        this.isReviewLoading = true;
                        this.panTo(item);
                        $.ajax({
                            url: '/camp/reviewList.dox', type: 'POST',
                            data: { campId: parseInt(item.contentId, 10) },
                            dataType: 'json',
                            success: function (data) { self.isReviewLoading = false; self.reviewList = data.list || []; },
                            error: function () { self.isReviewLoading = false; self.reviewList = []; }
                        });
                    },
                    openReviewModal: function () {
                        this.selectedReviewId = -1;   /* ★ 초기화 */
                        this.isReviewModalOpen = true;
                    },
                    /* ★ parseInt 로 타입 통일 — DB에서 문자열로 올 경우 대비 */
                    /* ── 리뷰 개별 토글 (전체보기 모달 전용) ── */
                    // Vue methods 내부
                    fnToggleReview: function (rev) {
                        // 1. 이제 리스트를 펼치지 않고(selectedReviewId 대신), 단건 상세 모달을 엽니다.
                        this.selectedReviewDetail = rev;
                        this.isReviewDetailOpen = true;

                        // 2. 만약 펼치기 기능도 같이 쓰고 싶다면 유지해도 되지만, 
                        // 이미지처럼 팝업을 띄우는 게 목적이라면 위 두 줄만 쓰시면 됩니다.
                        console.log("상세 보기 클릭 ID:", rev.CAMP_REVIEW_ID);
                    },
                    openReviewDetail: function (rev) {
                        this.selectedReviewDetail = rev;
                        this.isReviewDetailOpen = true;
                    },
                    fnStars: function (rating) {
                        var n = Math.round(parseFloat(rating) || 0);
                        var str = '';
                        for (var i = 0; i < 5; i++) str += (i < n) ? '★' : '☆';
                        return str;
                    },
                    fnSearchFacility: function (code, target, lat, lng) {
                        var self = this;
                        this.places.categorySearch(code, function (result, status) {
                            self.isFacLoading = false;
                            if (status === kakao.maps.services.Status.OK) {
                                if (target === 'modal') self.facilityList = result.slice(0, 8);
                                else self.drawFacMarkers(result, code);
                            } else {
                                if (target === 'modal') self.facilityList = [];
                            }
                        }, { location: new kakao.maps.LatLng(lat, lng), radius: 5000, sort: kakao.maps.services.SortBy.DISTANCE });
                    },
                    fnToggleFacility: function (code) {
                        if (this.activeFacility === code) { this.fnClearFacility(); return; }
                        if (!this.selectedItem) return;
                        this.activeFacility = code; this.isFacLoading = true;
                        this.fnSearchFacility(code, 'map', parseFloat(this.selectedItem.mapY), parseFloat(this.selectedItem.mapX));
                    },
                    drawFacMarkers: function (list, code) {
                        var self = this;
                        this.facMarkers.forEach(function (m) { m.setMap(null); });
                        this.facMarkers = []; this.isFacLoading = false;
                        var icon = self.facIcon(code);
                        list.slice(0, 15).forEach(function (fac) {
                            var pos = new kakao.maps.LatLng(parseFloat(fac.y), parseFloat(fac.x));
                            var content = '<div style="background:#fff;border:1.5px solid #E8732A;border-radius:10px;padding:6px 10px;font-size:12px;white-space:nowrap;box-shadow:0 2px 8px rgba(44,30,15,.15);font-family:GgiBatang,sans-serif;">'
                                + icon + ' ' + fac.place_name
                                + '<br><span style="color:#B89A7A;font-size:11px;">' + self.fnFormatDist(fac.distance) + ' · ' + self.fnWalkTime(fac.distance) + ' 도보</span></div>';
                            var overlay = new kakao.maps.CustomOverlay({ position: pos, content: content, yAnchor: 1.3, zIndex: 3 });
                            overlay.setMap(self.map);
                            self.facMarkers.push(overlay);
                        });
                    },
                    fnClearFacility: function () {
                        this.activeFacility = '';
                        this.facMarkers.forEach(function (m) { m.setMap(null); });
                        this.facMarkers = [];
                    },
                    fnModalFacility: function (code) {
                        this.modalFacTab = code; this.facilityList = []; this.isFacLoading = true;
                        this.fnSearchFacility(code, 'modal', parseFloat(this.detailItem.mapY), parseFloat(this.detailItem.mapX));
                    },
                    facIcon: function (code) { var m = { HP8: '🏥', CS2: '🏪', PM9: '💊', PK6: '⛽' }; return m[code] || '📍'; },
                    fnFormatDist: function (dist) { var d = parseInt(dist); if (isNaN(d)) return '-'; return d >= 1000 ? (d / 1000).toFixed(1) + 'km' : d + 'm'; },
                    fnWalkTime: function (dist) { var d = parseInt(dist); if (isNaN(d)) return '-'; var min = Math.ceil(d / 67); return min < 60 ? min + '분' : Math.floor(min / 60) + '시간 ' + (min % 60) + '분'; }
                },
                mounted: function () { this.fnInit(); }
            });
            vueApp.mount('#app');
        </script>
    </body>

    </html>