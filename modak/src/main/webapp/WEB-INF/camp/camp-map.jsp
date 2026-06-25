<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>모닥모닥 - 캠핑장 지도 서비스</title>
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/camp/camp-map.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.2.0/remixicon.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false&libraries=services"></script>


    </head>

    <body>

        <div id="app" v-cloak>

            <div class="side-panel">
                <div class="panel-header">
                    <span class="logo-text" onclick="location.href='/main.do'"><i class="ri-fire-fill"></i>모닥모닥</span>

                    <div class="search-wrap">
                        <input type="text" class="search-input" v-model="searchKeyword" placeholder="이름·주소·설명 검색..."
                            @keydown.enter="fnSearch">
                        <button class="search-btn" @click="fnSearch"><i class="ri-search-line"></i>검색</button>
                    </div>

                    <div class="tag-wrap">
                        <button v-for="tag in tagList" :key="tag" class="tag-btn" :class="{ active: activeTag === tag }"
                            @click="fnTagSearch(tag)">{{ tag }}</button>
                    </div>

                    <select v-model="selectedArea" class="area-select" @change="fnFilterArea">
                        <option value="">전국 전체</option>
                        <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
                    </select>

                    <div class="search-info"><i class="ri-list-check-2"></i>검색 결과 <b>{{ filteredList.length }}</b>건
                    </div>
                </div>
                <div v-if="isLoading" class="camp-loading">
                    <div class="camp-loading-bar">
                        <div class="camp-loading-fill"></div>
                    </div>
                    <span>캠핑장 정보를 불러오는 중...</span>
                </div>
                <ul class="camp-list" v-else>
                    <li v-for="item in filteredList" :key="item.contentId" class="camp-item"
                        :class="{ active: selectedItem && selectedItem.contentId === item.contentId }"
                        @click="panTo(item)">
                        <div class="camp-title">{{ item.facltNm }}</div>
                        <div class="camp-address"><i class="ri-map-pin-2-line camp-address-icon"></i><span>{{ item.addr1
                                }}</span></div>
                        <button class="btn-detail-hold"
                            :class="{ active: isDetailView && detailItem.contentId === item.contentId }"
                            @click.stop="toggleDetail(item)">

                            {{ isDetailView && detailItem.contentId === item.contentId ? '닫기' : '상세보기' }}
                        </button>
                    </li>
                    <li v-if="filteredList.length === 0" class="camp-empty"><i class="ri-search-eye-line"></i><strong>검색
                            결과가 없습니다.</strong><span>다른 키워드나 지역을 선택해보세요.</span></li>
                </ul>
            </div>

            <div class="map-container">
                <div id="map"></div>
                <div v-if="isDetailView" class="map-detail-page">
                    <div class="map-detail-page-header">
                        <div class="detail-header-title">
                            <span>캠핑장 상세정보</span>
                            <b>{{ detailItem.facltNm }}</b>
                        </div>
                    </div>
                    <div class="map-detail-page-scroll">
                        <section class="detail-hero-wrap">
                            <div class="map-detail-hero">
                                <img v-if="detailItem.firstImageUrl"
                                    :src="fnGetHighQualityImg(detailItem.firstImageUrl)"
                                    @error="detailItem.firstImageUrl = null">

                                <div v-else class="map-detail-no-img">
                                    <i class="ri-image-line"></i>
                                    등록된 이미지가 없습니다
                                </div>

                                <div class="detail-hero-dim"></div>

                                <div class="detail-hero-content">
                                    <div class="map-detail-badge">
                                        <i class="ri-map-pin-2-fill"></i>
                                        {{ fnGetRegionKey(detailItem.addr1, 'sido') }}
                                    </div>

                                    <h2 class="map-detail-title">{{ detailItem.facltNm }}</h2>

                                    <p class="map-detail-address">
                                        <i class="ri-map-pin-2-line"></i>
                                        {{ detailItem.addr1 }}
                                    </p>
                                </div>
                            </div>
                        </section>

                        <div class="map-detail-page-body">
                            <div class="detail-summary-grid">
                                <div class="detail-summary-card">
                                    <i class="ri-road-map-line"></i>
                                    <span>지역</span>
                                    <b>{{ fnGetRegionKey(detailItem.addr1, 'sido') }}</b>
                                </div>

                                <div class="detail-summary-card">
                                    <i class="ri-tent-line"></i>
                                    <span>유형</span>
                                    <b>{{ detailItem.induty || '캠핑장' }}</b>
                                </div>

                                <div class="detail-summary-card">
                                    <i class="ri-star-smile-line"></i>
                                    <span>리뷰</span>
                                    <b>{{ reviewList.length }}개</b>
                                </div>
                            </div>

                            <section class="map-detail-section intro-section">
                                <h3><i class="ri-leaf-line"></i> 캠핑장 소개</h3>
                                <p>{{ detailItem.lineIntro || '소개 정보가 등록되지 않은 캠핑장입니다.' }}</p>
                            </section>

                            <div class="detail-two-col">
                                <section class="map-detail-section">
                                    <h3><i class="ri-compass-3-line"></i> 주변 편의시설</h3>

                                    <div class="facility-tabs detail-facility-tabs">
                                        <button class="facility-tab" :class="{ active: modalFacTab === 'HP8' }"
                                            @click="fnModalFacility('HP8')"><i class="ri-hospital-line"></i> 병원</button>
                                        <button class="facility-tab" :class="{ active: modalFacTab === 'CS2' }"
                                            @click="fnModalFacility('CS2')"><i class="ri-store-2-line"></i> 편의점</button>
                                        <button class="facility-tab" :class="{ active: modalFacTab === 'PM9' }"
                                            @click="fnModalFacility('PM9')"><i class="ri-capsule-line"></i> 약국</button>
                                        <button class="facility-tab" :class="{ active: modalFacTab === 'PK6' }"
                                            @click="fnModalFacility('PK6')"><i class="ri-gas-station-line"></i>
                                            주유소</button>
                                    </div>

                                    <div class="facility-loading" v-if="isFacLoading">
                                        <i class="ri-loader-4-line"></i> 검색 중...
                                    </div>

                                    <div class="facility-list" v-else-if="facilityList.length > 0">
                                        <div v-for="fac in facilityList" :key="fac.id" class="facility-item">
                                            <i :class="['facility-icon', facIconClass(modalFacTab)]"></i>
                                            <span class="facility-name">{{ fac.place_name }}</span>
                                            <div class="facility-dist">
                                                <b>{{ fnFormatDist(fac.distance) }}</b>
                                                {{ fnWalkTime(fac.distance) }} 도보
                                            </div>
                                        </div>
                                    </div>

                                    <div class="facility-empty" v-else-if="modalFacTab && !isFacLoading">
                                        반경 5km 내 결과가 없습니다.
                                    </div>

                                    <div class="facility-empty" v-else>
                                        탭을 선택하면 주변 시설을 검색합니다.
                                    </div>
                                </section>

                                <section class="map-detail-section">
                                    <div class="review-header-row">
                                        <h3><i class="ri-star-line"></i> 방문객 리뷰</h3>
                                        <button v-if="reviewList.length > 3" class="btn-review-all"
                                            @click="isReviewExpanded = !isReviewExpanded">
                                            {{ isReviewExpanded ? '접기' : '리뷰 ' + (reviewList.length - 3) + '개 더보기' }}
                                        </button>
                                    </div>

                                    <div class="detail-review-score" v-if="reviewList.length > 0">
                                        <strong>{{ reviewAvg }}</strong>
                                        <span>{{ fnStars(reviewAvg) }}</span>
                                        <em>총 {{ reviewList.length }}개 리뷰</em>
                                    </div>

                                    <div class="facility-loading" v-if="isReviewLoading">
                                        <i class="ri-loader-4-line"></i> 리뷰 불러오는 중...
                                    </div>

                                    <div v-else-if="reviewList.length > 0">
                                        <div v-for="rev in (isReviewExpanded ? reviewList : reviewList.slice(0, 3))"
                                            :key="rev.CAMP_REVIEW_ID" class="review-item review-item-clickable"
                                            @click="openReviewDetail(rev)">
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
                                    </div>

                                    <div v-else class="no-data">아직 작성된 리뷰가 없습니다.</div>
                                </section>
                            </div>
                            <div class="detail-back-row">
                                <button class="btn-back-map" @click="backToMap">
                                    <i class="ri-arrow-left-line"></i>
                                    지도로 돌아가기
                                </button>
                            </div>
                            <button class="btn-scroll-top" v-show="showScrollTop" @click="scrollToTop">
                                <i class="ri-arrow-up-line"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <!-- 클러스터 모드일 때 안내 문구 -->
                <div v-if="isClusterMode" class="cluster-hint">
                    <i class="ri-map-2-line"></i> 지역을 클릭하면 캠핑장 마커가 표시됩니다
                </div>

                <div class="facility-btns" v-if="selectedItem">
                    <button class="facility-btn" :class="{ active: activeFacility === 'HP8' }"
                        @click="fnToggleFacility('HP8')"><i class="ri-hospital-line"></i> 병원</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'CS2' }"
                        @click="fnToggleFacility('CS2')"><i class="ri-store-2-line"></i> 편의점</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'PM9' }"
                        @click="fnToggleFacility('PM9')"><i class="ri-capsule-line"></i> 약국</button>
                    <button class="facility-btn" :class="{ active: activeFacility === 'PK6' }"
                        @click="fnToggleFacility('PK6')"><i class="ri-gas-station-line"></i> 주유소</button>
                    <button class="facility-btn-clear" v-if="activeFacility" @click="fnClearFacility"><i
                            class="ri-close-line"></i> 초기화</button>
                </div>
            </div>

            <!-- 리뷰 전체보기 모달 -->
            <div v-if="isReviewModalOpen" class="modal-overlay review-modal-overlay"
                @click.self="isReviewModalOpen = false">
                <div class="modal-content review-modal-content">
                    <div class="review-modal-header">
                        <div>
                            <h3 class="review-modal-title">방문객 리뷰</h3>
                            <p class="review-modal-camp">{{ detailItem.facltNm }}</p>
                        </div>
                        <button class="modal-close-btn" style="position:static" @click="isReviewModalOpen = false"><i
                                class="ri-close-line"></i></button>
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
                        @click="isReviewDetailOpen = false"><i class="ri-close-line"></i></button>
                    <div class="review-detail-stars">{{ fnStars(selectedReviewDetail.rating) }}</div>
                    <div class="review-detail-rating">{{ selectedReviewDetail.rating }} / 5</div>
                    <div class="review-detail-user">{{ selectedReviewDetail.userId }}</div>
                    <div class="review-detail-date">{{ selectedReviewDetail.createdAt }}</div>
                    <div class="review-detail-content">{{ selectedReviewDetail.content }}</div>
                </div>
            </div>

        </div>

        <script>
            /* ── 지역별 중심 좌표 ── */
            var REGION_CENTER = {
                '서울': { lat: 37.5665, lng: 126.9780 },
                '경기': { lat: 37.4138, lng: 127.5183 },
                '강원': { lat: 37.8228, lng: 128.1555 },
                '인천': { lat: 37.4563, lng: 126.7052 },
                '충북': { lat: 36.8000, lng: 127.7000 },
                '충남': { lat: 36.5184, lng: 126.8000 },
                '대전': { lat: 36.3504, lng: 127.3845 },
                '세종': { lat: 36.4800, lng: 127.2890 },
                '전북': { lat: 35.7175, lng: 127.1530 },
                '전남': { lat: 34.8679, lng: 126.9910 },
                '광주': { lat: 35.1595, lng: 126.8526 },
                '경북': { lat: 36.4919, lng: 128.8889 },
                '경남': { lat: 35.4606, lng: 128.2132 },
                '대구': { lat: 35.8714, lng: 128.6014 },
                '울산': { lat: 35.5384, lng: 129.3114 },
                '부산': { lat: 35.1796, lng: 129.0756 },
                '제주': { lat: 33.4890, lng: 126.4983 },
            };
            var REGION_BOUNDS = {
                '서울': { minLat: 37.40, maxLat: 37.75, minLng: 126.75, maxLng: 127.20 },
                '경기': { minLat: 36.85, maxLat: 38.35, minLng: 126.35, maxLng: 127.90 },
                '인천': { minLat: 37.00, maxLat: 37.90, minLng: 124.50, maxLng: 126.90 },
                '강원': { minLat: 37.00, maxLat: 38.70, minLng: 127.50, maxLng: 129.40 },
                '충북': { minLat: 36.00, maxLat: 37.35, minLng: 127.20, maxLng: 128.75 },
                '충남': { minLat: 35.95, maxLat: 37.15, minLng: 125.90, maxLng: 127.70 },
                '대전': { minLat: 36.15, maxLat: 36.55, minLng: 127.20, maxLng: 127.55 },
                '세종': { minLat: 36.35, maxLat: 36.75, minLng: 127.10, maxLng: 127.45 },
                '전북': { minLat: 35.25, maxLat: 36.25, minLng: 126.35, maxLng: 127.95 },
                '전남': { minLat: 33.85, maxLat: 35.50, minLng: 125.00, maxLng: 127.85 },
                '광주': { minLat: 35.00, maxLat: 35.30, minLng: 126.70, maxLng: 127.00 },
                '경북': { minLat: 35.55, maxLat: 37.35, minLng: 128.00, maxLng: 130.00 },
                '경남': { minLat: 34.55, maxLat: 35.95, minLng: 127.55, maxLng: 129.40 },
                '대구': { minLat: 35.65, maxLat: 36.05, minLng: 128.35, maxLng: 128.85 },
                '울산': { minLat: 35.30, maxLat: 35.75, minLng: 129.00, maxLng: 129.55 },
                '부산': { minLat: 35.00, maxLat: 35.40, minLng: 128.75, maxLng: 129.35 },
                '제주': { minLat: 33.05, maxLat: 33.65, minLng: 126.10, maxLng: 126.95 }
            };
            var vueApp = Vue.createApp({
                data: function () {
                    return {
                        isLoading: true,
                        map: null, markers: [], facMarkers: [], clusterOverlays: [], places: null,
                        allData: [], filteredList: [],
                        cities: ['서울', '경기', '강원', '인천', '충북', '충남', '대전', '세종', '전북', '전남', '광주', '경북', '경남', '대구', '울산', '부산', '제주'],
                        selectedArea: '', searchKeyword: '', activeTag: '', selectedItem: null,
                        isClusterMode: true,   /* ← 클러스터 모드 여부 */
                        isModalOpen: false, detailItem: {},
                        reviewList: [], isReviewLoading: false,
                        isReviewModalOpen: false,
                        selectedReviewId: -1,
                        isReviewDetailOpen: false, selectedReviewDetail: {},
                        activeFacility: '', modalFacTab: '', facilityList: [], isFacLoading: false,
                        tagList: ['텐트', '글램핑', '카라반', '오토캠핑', '펜션', '수영장', '계곡', '바다', '숲속', '반려동물'],
                        zoomTimer: null,
                        currentClusterDepth: '',
                        regionCenterCache: {},
                        geocoder: null,
                        isFocusingCamp: false,
                        isProgrammaticMove: false,
                        markerModeHoldTimer: null,
                        campPositionCache: {},
                        clusterMouseDownPos: null,
                        clusterDragged: false,
                        lastClusterDepth: '',
                        isClusterDepthChanged: false,
                        isDetailView: false,
                        savedMapState: null,
                        isReviewExpanded: false,
                        showScrollTop: false,
                    };
                },
                computed: {
                    reviewAvg: function () {
                        if (!this.reviewList.length) return '0.0';
                        var sum = 0;
                        this.reviewList.forEach(function (r) { sum += parseFloat(r.rating) || 0; });
                        return (sum / this.reviewList.length).toFixed(1);
                    }
                }, watch: {
                    isDetailView: function (val) {
                        var self = this;

                        if (val) {
                            this.$nextTick(function () {
                                var el = document.querySelector('.map-detail-page-scroll');

                                if (el) {
                                    el.addEventListener('scroll', function () {
                                        self.showScrollTop = el.scrollTop > 120;
                                    });
                                }
                            });
                        }
                    }
                },
                methods: {
                    fnInit: function () {
                        var self = this;
                        kakao.maps.load(function () {
                            var container = document.getElementById('map');
                            self.map = new kakao.maps.Map(container, {
                                center: new kakao.maps.LatLng(36.5, 127.8),
                                level: 11
                            });
                            self.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                            self.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
                            self.places = new kakao.maps.services.Places();
                            self.geocoder = new kakao.maps.services.Geocoder();
                            self.fnFetch();
                            kakao.maps.event.addListener(self.map, 'zoom_changed', function () {
                                clearTimeout(self.zoomTimer);

                                self.zoomTimer = setTimeout(function () {
                                    if (self.isFocusingCamp || self.isProgrammaticMove) return;

                                    self.currentClusterDepth = '';
                                    self.fnRefreshByZoom();
                                }, 260);
                            });

                            kakao.maps.event.addListener(self.map, 'dragend', function () {
                                clearTimeout(self.zoomTimer);

                                self.zoomTimer = setTimeout(function () {
                                    if (self.isFocusingCamp || self.isProgrammaticMove) return;

                                    self.currentClusterDepth = '';
                                    self.fnRefreshByZoom();
                                }, 260);
                            });
                        });
                    },

                    fnFetch: function () {
                        var self = this;
                        $.ajax({
                            url: '/camp/list.dox', type: 'POST', dataType: 'json',
                            success: function (data) {
                                self.allData = data.list || [];
                                self.filteredList = self.allData;
                                self.currentClusterDepth = '';
                                self.fnRefreshByZoom();
                                self.isLoading = false;
                            }
                        });
                    },

                    drawClusters: function (list, depth) {
                        var self = this;

                        this.clearMarkers();
                        this.clearClusters();
                        this.isClusterMode = true;

                        var level = this.map.getLevel();

                        if (!depth) {
                            if (level >= 11) {
                                depth = 'sido';
                            } else if (level >= 8) {
                                depth = 'sigungu';
                            } else {
                                depth = 'dong';
                            }
                        }


                        var groupMap = {};

                        list.forEach(function (item) {
                            if (!item.mapY || !item.mapX) return;

                            var key = self.fnGetRegionKey(item.addr1 || '', depth);
                            if (!key) key = '기타';

                            if (!groupMap[key]) {
                                groupMap[key] = {
                                    name: key,
                                    items: [],
                                    latSum: 0,
                                    lngSum: 0
                                };
                            }

                            groupMap[key].items.push(item);
                            groupMap[key].latSum += parseFloat(item.mapY);
                            groupMap[key].lngSum += parseFloat(item.mapX);
                        });

                        Object.keys(groupMap).forEach(function (key) {
                            var group = groupMap[key];
                            var count = group.items.length;

                            var center = REGION_CENTER[group.name];

                            var lat, lng;

                            if (center) {
                                lat = center.lat;
                                lng = center.lng;
                            } else {
                                // fallback (데이터 평균)
                                lat = group.latSum / count;
                                lng = group.lngSum / count;
                            }
                            var size = 58;

                            if (count >= 100) {
                                size = 92;
                            } else if (count >= 50) {
                                size = 82;
                            } else if (count >= 20) {
                                size = 72;
                            } else if (count >= 10) {
                                size = 64;
                            }

                            var fontSize = size >= 86 ? 24 : size >= 74 ? 21 : size >= 64 ? 18 : 16;

                            var div = document.createElement('div');
                            div.className = self.isClusterDepthChanged ? 'region-cluster cluster-animate' : 'region-cluster';
                            div.innerHTML =
                                '<div class="cluster-bubble" style="width:' + size + 'px;height:' + size + 'px;">' +
                                '  <div class="cluster-count" style="font-size:' + fontSize + 'px;">' + count + '</div>' +
                                '  <div class="cluster-unit">개</div>' +
                                '</div>' +
                                '<div class="cluster-label">' + key + '</div>';

                            div.addEventListener('mousedown', function (e) {
                                self.clusterMouseDownPos = {
                                    x: e.clientX,
                                    y: e.clientY
                                };
                                self.clusterDragged = false;
                            });

                            div.addEventListener('mousemove', function (e) {
                                if (!self.clusterMouseDownPos) return;

                                var dx = Math.abs(e.clientX - self.clusterMouseDownPos.x);
                                var dy = Math.abs(e.clientY - self.clusterMouseDownPos.y);

                                if (dx > 5 || dy > 5) {
                                    self.clusterDragged = true;
                                }
                            });

                            div.addEventListener('mouseup', function (e) {
                                if (!self.clusterMouseDownPos) return;

                                var dx = Math.abs(e.clientX - self.clusterMouseDownPos.x);
                                var dy = Math.abs(e.clientY - self.clusterMouseDownPos.y);

                                self.clusterMouseDownPos = null;

                                if (self.clusterDragged || dx > 5 || dy > 5) {
                                    self.clusterDragged = false;
                                    return;
                                }

                                self.fnClickSmartCluster(group.items, lat, lng, key, depth);
                            });

                            var overlay = new kakao.maps.CustomOverlay({
                                position: new kakao.maps.LatLng(lat, lng),
                                content: div,
                                zIndex: 3
                            });

                            overlay.setMap(self.map);
                            self.clusterOverlays.push(overlay);
                        });
                    },
                    drawClustersInBounds: function (list, depth) {
                        var self = this;
                        var bounds = this.map.getBounds();

                        this.clearMarkers();
                        this.clearClusters();
                        this.isClusterMode = true;

                        var groupMap = {};

                        list.forEach(function (item) {
                            if (!item.mapY || !item.mapX) return;

                            var lat = parseFloat(item.mapY);
                            var lng = parseFloat(item.mapX);

                            var key = self.fnGetRegionKey(item.addr1 || '', depth);
                            if (!key) key = '기타';

                            if (!groupMap[key]) {
                                groupMap[key] = {
                                    name: key,
                                    items: [],
                                    latSum: 0,
                                    lngSum: 0
                                };
                            }

                            groupMap[key].items.push(item);
                            groupMap[key].latSum += lat;
                            groupMap[key].lngSum += lng;
                        });

                        Object.keys(groupMap).forEach(function (key) {
                            var group = groupMap[key];
                            var count = group.items.length;

                            var lat = group.latSum / count;
                            var lng = group.lngSum / count;
                            var pos = new kakao.maps.LatLng(lat, lng);

                            if (!bounds.contain(pos)) return;

                            var size = 50;
                            if (count >= 100) size = 82;
                            else if (count >= 50) size = 74;
                            else if (count >= 20) size = 66;
                            else if (count >= 10) size = 58;

                            var div = document.createElement('div');
                            div.className = self.isClusterDepthChanged ? 'map-cluster cluster-animate' : 'map-cluster';
                            div.innerHTML =
                                '<button type="button" class="map-cluster-circle" style="width:' + size + 'px;height:' + size + 'px;">' +
                                '   <strong>' + count + '</strong>' +
                                '   <span>개</span>' +
                                '</button>' +
                                '<div class="map-cluster-name">' + key + '</div>';
                            div.addEventListener('mousedown', function (e) {
                                self.clusterMouseDownPos = {
                                    x: e.clientX,
                                    y: e.clientY
                                };
                                self.clusterDragged = false;
                            });

                            div.addEventListener('mousemove', function (e) {
                                if (!self.clusterMouseDownPos) return;

                                var dx = Math.abs(e.clientX - self.clusterMouseDownPos.x);
                                var dy = Math.abs(e.clientY - self.clusterMouseDownPos.y);

                                if (dx > 5 || dy > 5) {
                                    self.clusterDragged = true;
                                }
                            });

                            div.addEventListener('mouseup', function (e) {
                                if (!self.clusterMouseDownPos) return;

                                var dx = Math.abs(e.clientX - self.clusterMouseDownPos.x);
                                var dy = Math.abs(e.clientY - self.clusterMouseDownPos.y);

                                self.clusterMouseDownPos = null;

                                if (self.clusterDragged || dx > 5 || dy > 5) {
                                    self.clusterDragged = false;
                                    return;
                                }

                                self.fnClickSmartCluster(group.items, lat, lng, key, depth);
                            });
                            var overlay = new kakao.maps.CustomOverlay({
                                position: pos,
                                content: div,
                                zIndex: 3
                            });

                            overlay.setMap(self.map);
                            self.clusterOverlays.push(overlay);
                        });
                    },

                    fnClickSmartCluster: function (items, lat, lng, clusterKey, depth) {
                        var self = this;

                        if (!items || items.length === 0) return;
                        if (clusterKey && depth) {
                            items = items.filter(function (item) {
                                var sameRegion = this.fnGetRegionKey(item.addr1 || '', depth) === clusterKey;
                                var validPosition = this.fnIsValidRegionPosition(item, clusterKey, depth);

                                return sameRegion && validPosition;
                            }.bind(this));
                        }
                        this.isFocusingCamp = true;
                        this.isProgrammaticMove = true;

                        this.filteredList = items;
                        this.selectedItem = null;
                        this.fnClearFacility();

                        this.clearClusters();
                        this.clearMarkers();

                        var bounds = new kakao.maps.LatLngBounds();
                        var positions = [];

                        items.forEach(function (item) {
                            var pos = self.fnGetRawPosition(item);
                            if (!pos) return;

                            positions.push({
                                item: item,
                                pos: pos
                            });

                            bounds.extend(pos);
                        });

                        if (positions.length === 0) {
                            this.isFocusingCamp = false;
                            this.isProgrammaticMove = false;
                            return;
                        }

                        this.isClusterMode = false;
                        this.currentClusterDepth = 'marker';

                        if (positions.length === 1) {
                            this.panTo(positions[0].item);
                            return;
                        }

                        this.map.setBounds(bounds, 70, 70, 70, 70);

                        /*
                            idle만 믿으면 가끔 안 그림.
                            그래서 이동 직후 + 보정 타이머로 무조건 한 번 그림.
                        */
                        setTimeout(function () {
                            self.fnDrawClusterMarkers(positions);
                        }, 180);

                        setTimeout(function () {
                            self.fnDrawClusterMarkers(positions);
                            self.isFocusingCamp = false;
                            self.isProgrammaticMove = false;
                        }, 520);
                    },
                    fnHasFilter: function () {
                        return !!(this.selectedArea || this.searchKeyword || this.activeTag);
                    },

                    fnGetMapList: function () {
                        if (this.fnHasFilter()) {
                            return this.filteredList || [];
                        }
                        return this.allData || [];
                    },

                    clearClusters: function () {
                        this.clusterOverlays.forEach(function (o) { o.setMap(null); });
                        this.clusterOverlays = [];
                    }, fnDrawClusterMarkers: function (positions) {
                        var self = this;

                        this.clearClusters();
                        this.clearMarkers();

                        this.isClusterMode = false;
                        this.currentClusterDepth = 'marker';

                        positions.forEach(function (p) {
                            var marker = new kakao.maps.Marker({
                                position: p.pos,
                                map: self.map,
                                zIndex: 10
                            });

                            kakao.maps.event.addListener(marker, 'click', function () {
                                self.openDetail(p.item);
                            });

                            self.markers.push(marker);
                        });
                    },
                    fnRefreshByZoom: function () {
                        if (!this.map) return;
                        if (this.isFocusingCamp || this.isProgrammaticMove) return;

                        var level = this.map.getLevel();
                        var list = this.fnGetMapList();
                        var nextDepth = '';

                        if (level >= 11) {
                            nextDepth = 'sido';
                        } else if (level >= 8) {
                            nextDepth = 'sigungu';
                        } else if (level >= 6) {
                            nextDepth = 'dong';
                        } else {
                            nextDepth = 'marker';
                        }

                        this.clearClusters();
                        this.clearMarkers();

                        this.isClusterDepthChanged = this.currentClusterDepth !== nextDepth;
                        this.currentClusterDepth = nextDepth;

                        if (nextDepth === 'marker') {
                            this.isClusterMode = false;
                            this.drawMarkersInBounds(list);
                            return;
                        }

                        this.isClusterMode = true;
                        this.drawClustersInBounds(list, nextDepth);
                    },
                    clearMarkers: function () {
                        this.markers.forEach(function (m) { m.setMap(null); });
                        this.markers = [];
                    },

                    /* ════════════════════════════
                       개별 마커 그리기
                    ════════════════════════════ */
                    drawMarkers: function (list) {
                        var self = this;
                        this.clearMarkers();
                        list.forEach(function (item) {
                            if (!item.mapY || !item.mapX) return;
                            var marker = new kakao.maps.Marker({
                                position: new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX)),
                                map: self.map
                            });
                            kakao.maps.event.addListener(marker, 'click', function () {
                                self.openDetail(item);
                            });
                            self.markers.push(marker);
                        });
                    },

                    /* ════════════════════════════
                       검색 / 필터
                    ════════════════════════════ */
                    fnSearch: function () { this.fnApplyFilter(); },
                    fnTagSearch: function (tag) {
                        this.activeTag = (this.activeTag === tag) ? '' : tag;
                        this.searchKeyword = '';
                        this.fnApplyFilter();
                    },
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

                        if (area || keyword || tag) {
                            this.clearClusters();
                            this.isClusterMode = false;
                            this.drawMarkers(result);
                            if (result.length > 0) this.panTo(result[0]);
                        } else {
                            this.selectedItem = null;
                            this.map.setCenter(new kakao.maps.LatLng(36.5, 127.8));
                            this.map.setLevel(11);
                            this.currentClusterDepth = '';
                            this.fnRefreshByZoom();
                        }
                    },

                    panTo: function (item) {
                        if (!item) return;

                        var self = this;
                        var pos = this.fnGetRawPosition(item);

                        if (!pos) return;

                        this.isFocusingCamp = true;
                        this.isProgrammaticMove = true;
                        this.selectedItem = item;

                        this.clearClusters();
                        this.clearMarkers();
                        this.fnClearFacility();

                        this.isClusterMode = false;
                        this.currentClusterDepth = 'marker';

                        this.map.setLevel(4, { animate: true });
                        this.map.panTo(pos);

                        setTimeout(function () {
                            self.clearClusters();
                            self.clearMarkers();

                            var marker = new kakao.maps.Marker({
                                position: pos,
                                map: self.map
                            });

                            kakao.maps.event.addListener(marker, 'click', function () {
                                self.openDetail(item);
                            });

                            self.markers.push(marker);

                            clearTimeout(self.markerModeHoldTimer);
                            self.markerModeHoldTimer = setTimeout(function () {
                                self.isFocusingCamp = false;
                                self.isProgrammaticMove = false;
                            }, 700);
                        }, 320);
                    },
                    openDetail: function (item) {
                        var self = this;

                        if (!item) return;

                        this.savedMapState = {
                            center: this.map.getCenter(),
                            level: this.map.getLevel(),
                            selectedArea: this.selectedArea,
                            searchKeyword: this.searchKeyword,
                            activeTag: this.activeTag,
                            filteredList: this.filteredList.slice(),
                            selectedItem: this.selectedItem
                        };

                        this.detailItem = item;
                        this.selectedItem = item;
                        this.isDetailView = true;
                        this.isModalOpen = false;

                        this.modalFacTab = '';
                        this.facilityList = [];
                        this.reviewList = [];
                        this.isReviewLoading = true;
                        this.isReviewExpanded = false;
                        this.panTo(item);

                        $.ajax({
                            url: '/camp/reviewList.dox',
                            type: 'POST',
                            data: { campId: parseInt(item.contentId, 10) },
                            dataType: 'json',
                            success: function (data) {
                                self.isReviewLoading = false;
                                self.reviewList = data.list || [];
                            },
                            error: function () {
                                self.isReviewLoading = false;
                                self.reviewList = [];
                            }
                        });
                    },
                    openReviewModal: function () {
                        this.selectedReviewId = -1;
                        this.isReviewModalOpen = true;
                    },

                    fnToggleReview: function (rev) {
                        this.selectedReviewDetail = rev;
                        this.isReviewDetailOpen = true;
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
                        this.activeFacility = code;
                        this.isFacLoading = true;
                        this.fnSearchFacility(code, 'map', parseFloat(this.selectedItem.mapY), parseFloat(this.selectedItem.mapX));
                    },

                    drawFacMarkers: function (list, code) {
                        var self = this;
                        this.facMarkers.forEach(function (m) { m.setMap(null); });
                        this.facMarkers = [];
                        this.isFacLoading = false;
                        var iconClass = self.facIconClass(code);
                        list.slice(0, 15).forEach(function (fac) {
                            var pos = new kakao.maps.LatLng(parseFloat(fac.y), parseFloat(fac.x));
                            var content = '<div style="background:#fff;border:1.5px solid #E8732A;border-radius:10px;padding:6px 10px;font-size:12px;white-space:nowrap;box-shadow:0 2px 8px rgba(44,30,15,.15);">'
                                + '<i class="' + iconClass + '"></i> ' + fac.place_name
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
                        this.modalFacTab = code;
                        this.facilityList = [];
                        this.isFacLoading = true;
                        this.fnSearchFacility(code, 'modal', parseFloat(this.detailItem.mapY), parseFloat(this.detailItem.mapX));
                    },

                    facIconClass: function (code) {
                        var m = { HP8: 'ri-hospital-line', CS2: 'ri-store-2-line', PM9: 'ri-capsule-line', PK6: 'ri-gas-station-line' };
                        return m[code] || 'ri-map-pin-2-line';
                    },
                    fnFormatDist: function (dist) {
                        var d = parseInt(dist);
                        if (isNaN(d)) return '-';
                        return d >= 1000 ? (d / 1000).toFixed(1) + 'km' : d + 'm';
                    },
                    fnWalkTime: function (dist) {
                        var d = parseInt(dist);
                        if (isNaN(d)) return '-';
                        var min = Math.ceil(d / 67);
                        return min < 60 ? min + '분' : Math.floor(min / 60) + '시간 ' + (min % 60) + '분';
                    },
                    fnGetRegionKey: function (addr, depth) {
                        if (!addr) return '기타';

                        var parts = addr.split(' ').filter(function (v) {
                            return v && v.trim() !== '';
                        });

                        if (parts.length === 0) return '기타';

                        var sidoMap = {
                            '서울특별시': '서울',
                            '서울시': '서울',
                            '서울': '서울',

                            '경기도': '경기',
                            '경기': '경기',

                            '인천광역시': '인천',
                            '인천시': '인천',
                            '인천': '인천',

                            '강원특별자치도': '강원',
                            '강원도': '강원',
                            '강원': '강원',

                            '충청북도': '충북',
                            '충북': '충북',

                            '충청남도': '충남',
                            '충남': '충남',

                            '대전광역시': '대전',
                            '대전시': '대전',
                            '대전': '대전',

                            '세종특별자치시': '세종',
                            '세종시': '세종',
                            '세종': '세종',

                            '전북특별자치도': '전북',
                            '전라북도': '전북',
                            '전북': '전북',

                            '전라남도': '전남',
                            '전남': '전남',

                            '광주광역시': '광주',
                            '광주시': '광주',
                            '광주': '광주',

                            '경상북도': '경북',
                            '경북': '경북',

                            '경상남도': '경남',
                            '경남': '경남',

                            '대구광역시': '대구',
                            '대구시': '대구',
                            '대구': '대구',

                            '울산광역시': '울산',
                            '울산시': '울산',
                            '울산': '울산',

                            '부산광역시': '부산',
                            '부산시': '부산',
                            '부산': '부산',

                            '제주특별자치도': '제주',
                            '제주도': '제주',
                            '제주': '제주'
                        };

                        var sido = sidoMap[parts[0]] || parts[0];

                        if (depth === 'sido') {
                            return sido;
                        }

                        if (depth === 'sigungu') {
                            if (parts.length >= 2) {
                                return sido + ' ' + parts[1];
                            }
                            return sido;
                        }

                        if (depth === 'dong') {
                            if (parts.length >= 3) {
                                return parts[1] + ' ' + parts[2];
                            }

                            if (parts.length >= 2) {
                                return parts[1];
                            }

                            return sido;
                        }

                        return sido;
                    },
                    drawMarkersInBounds: function (list) {
                        var self = this;
                        var bounds = this.map.getBounds();

                        this.clearMarkers();

                        list.forEach(function (item) {
                            if (!item.mapY || !item.mapX) return;

                            var lat = parseFloat(item.mapY);
                            var lng = parseFloat(item.mapX);
                            var pos = new kakao.maps.LatLng(lat, lng);

                            if (!bounds.contain(pos)) return;

                            var marker = new kakao.maps.Marker({
                                position: pos,
                                map: self.map
                            });

                            kakao.maps.event.addListener(marker, 'click', function () {
                                self.openDetail(item);
                            });

                            self.markers.push(marker);
                        });
                    },
                    fnResolveRegionCenter: function (key, callback) {
                        var self = this;

                        if (!key) {
                            callback(null);
                            return;
                        }

                        // 시도 고정 좌표 먼저 사용
                        if (REGION_CENTER[key]) {
                            callback(REGION_CENTER[key]);
                            return;
                        }

                        // 이미 구한 좌표는 재사용
                        if (this.regionCenterCache[key]) {
                            callback(this.regionCenterCache[key]);
                            return;
                        }

                        // 카카오 주소 검색용 키워드 보정
                        var query = key;

                        this.geocoder.addressSearch(query, function (result, status) {
                            if (status === kakao.maps.services.Status.OK && result.length > 0) {
                                var center = {
                                    lat: parseFloat(result[0].y),
                                    lng: parseFloat(result[0].x)
                                };

                                self.regionCenterCache[key] = center;
                                callback(center);
                            } else {
                                callback(null);
                            }
                        });
                    },
                    fnGetCampPosition: function (item, callback) {
                        callback(this.fnGetRawPosition(item));
                    },

                    fnGetRawPosition: function (item) {
                        if (!item.mapY || !item.mapX) return null;

                        return new kakao.maps.LatLng(
                            parseFloat(item.mapY),
                            parseFloat(item.mapX)
                        );
                    }, fnIsValidRegionPosition: function (item, clusterKey, depth) {
                        if (!item || !clusterKey || !depth) return true;
                        if (!item.mapY || !item.mapX) return false;

                        var sido = clusterKey.split(' ')[0];
                        var box = REGION_BOUNDS[sido];

                        if (!box) return true;

                        var lat = parseFloat(item.mapY);
                        var lng = parseFloat(item.mapX);

                        if (isNaN(lat) || isNaN(lng)) return false;

                        return lat >= box.minLat &&
                            lat <= box.maxLat &&
                            lng >= box.minLng &&
                            lng <= box.maxLng;
                    },
                    fnOnceIdle: function (callback) {
                        var self = this;

                        var handler = kakao.maps.event.addListener(this.map, 'idle', function () {
                            kakao.maps.event.removeListener(self.map, 'idle', handler);

                            if (typeof callback === 'function') {
                                callback();
                            }
                        });
                    },
                    fnGetHighQualityImg: function (url) {
                        if (!url) return '';

                        return url
                            .replace('/thumb/', '/')
                            .replace('thumb_720_', '');
                    },
                    backToMap: function () {
                        var self = this;

                        this.isDetailView = false;
                        this.detailItem = {};
                        this.reviewList = [];
                        this.facilityList = [];
                        this.modalFacTab = '';
                        this.fnClearFacility();

                        if (!this.savedMapState) {
                            this.fnRefreshByZoom();
                            return;
                        }

                        this.isFocusingCamp = true;
                        this.isProgrammaticMove = true;

                        this.selectedArea = this.savedMapState.selectedArea;
                        this.searchKeyword = this.savedMapState.searchKeyword;
                        this.activeTag = this.savedMapState.activeTag;
                        this.filteredList = this.savedMapState.filteredList;
                        this.selectedItem = this.savedMapState.selectedItem;

                        this.clearMarkers();
                        this.clearClusters();

                        this.map.setLevel(this.savedMapState.level);
                        this.map.setCenter(this.savedMapState.center);

                        setTimeout(function () {
                            self.isFocusingCamp = false;
                            self.isProgrammaticMove = false;
                            self.fnRefreshByZoom();
                        }, 300);
                    }, toggleDetail: function (item) {
                        if (this.isDetailView && this.detailItem.contentId === item.contentId) {
                            this.backToMap();
                            return;
                        }

                        this.openDetail(item);
                    },
                    scrollToTop: function () {
                        var el = document.querySelector('.map-detail-page-scroll');
                        if (el) {
                            el.scrollTo({ top: 0, behavior: 'smooth' });
                        }
                    },
                },
                mounted: function () {
                    this.fnInit();

                    var self = this;

                    setTimeout(function () {
                        var el = document.querySelector('.map-detail-page-scroll');

                        if (el) {
                            el.addEventListener('scroll', function () {
                                self.showScrollTop = el.scrollTop > 200;
                            });
                        }
                    }, 500);
                }
            });

            vueApp.mount('#app');
        </script>
    </body>

    </html>