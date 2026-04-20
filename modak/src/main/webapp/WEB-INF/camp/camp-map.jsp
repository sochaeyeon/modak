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

        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&autoload=false"></script>
    </head>

    <body>

        <div id="app" v-cloak>
            <div class="side-panel">
                <div class="panel-header">
                    <a href="/main.do" style="text-decoration: none;">
                        <h2 class="logo-text">⛺ 모닥모닥</h2>
                    </a>
                    <select v-model="selectedArea" class="area-select" @change="fnFilterArea">
                        <option value="">전국 전체</option>
                        <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
                    </select>
                    <div class="search-info">현재 검색 결과: <b>{{ filteredList.length }}</b>건</div>
                </div>

                <ul class="camp-list">
                    <li v-for="item in filteredList" :key="item.contentId" class="camp-item" @click="panTo(item)">
                        <div class="camp-title">{{ item.facltNm }}</div>
                        <div class="camp-address">📍 {{ item.addr1 }}</div>
                        <button @click.stop="openDetail(item)" class="btn-detail">상세보기</button>
                    </li>
                </ul>
            </div>

            <div class="map-container">
                <div id="map"></div>
            </div>

            <div v-if="isModalOpen" class="modal-overlay" @click.self="isModalOpen = false">
                <div class="modal-content">
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

                        <div class="review-box">
                            <h3 class="review-header">방문객 리뷰 ({{ reviewList.length }})</h3>
                            <div v-if="reviewList.length > 0">
                                <div v-for="rev in reviewList" :key="rev.campReviewId" class="review-item">
                                    <div class="review-meta">
                                        <span><b class="rating-star">★</b>{{ rev.rating }} | <b>{{ rev.userId
                                                }}</b></span>
                                        <span class="review-date">{{ rev.createdAt }}</span>
                                    </div>
                                    <div class="review-content">{{ rev.content }}</div>
                                </div>
                            </div>
                            <div v-else class="no-data">아직 작성된 리뷰가 없습니다. 첫 리뷰를 남겨보세요!</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        map: null,
                        markers: [],
                        infowindow: null,
                        allData: [],
                        filteredList: [],
                        cities: ['서울', '경기', '강원', '인천', '충북', '충남', '대전', '세종', '전북', '전남', '광주', '경북', '경남', '대구', '울산', '부산', '제주'],
                        selectedArea: '',
                        isModalOpen: false,
                        detailItem: {},
                        reviewList: []
                    };
                },
                methods: {
                    fnInit() {
                        kakao.maps.load(() => {
                            const container = document.getElementById('map');
                            const options = {
                                center: new kakao.maps.LatLng(36.5, 127.8),
                                level: 11
                            };
                            this.map = new kakao.maps.Map(container, options);

                            // 지도 컨트롤 추가
                            this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                            this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

                            this.fnFetch();
                        });
                    },
                    fnFetch() {
                        $.ajax({
                            url: "/camp/list.dox",
                            type: "POST",
                            dataType: "json",
                            success: (data) => {
                                this.allData = data.list || [];
                                this.filteredList = this.allData;
                                this.drawMarkers(this.allData);
                            }
                        });
                    },
                    fnFilterArea() {
                        if (!this.selectedArea) {
                            this.filteredList = this.allData;
                        } else {
                            this.filteredList = this.allData.filter(item =>
                                item.addr1 && item.addr1.includes(this.selectedArea)
                            );
                        }
                        this.drawMarkers(this.filteredList);
                        if (this.filteredList.length > 0) {
                            this.panTo(this.filteredList[0]);
                        }
                    },
                    drawMarkers(list) {
                        this.markers.forEach(m => m.setMap(null));
                        this.markers = [];

                        list.forEach(item => {
                            if (!item.mapY || !item.mapX) return;
                            const pos = new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX));
                            const marker = new kakao.maps.Marker({
                                position: pos,
                                map: this.map
                            });

                            kakao.maps.event.addListener(marker, 'click', () => {
                                this.openDetail(item);
                            });
                            this.markers.push(marker);
                        });
                    },
                    panTo(item) {
                        if (!item.mapY || !item.mapX) return;
                        const pos = new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX));
                        this.map.panTo(pos);
                        this.map.setLevel(7);
                    },
                    openDetail(item) {
                        this.detailItem = item;
                        this.isModalOpen = true;
                        $.ajax({
                            url: "/camp/reviewList.dox",
                            type: "POST",
                            data: { campId: item.contentId },
                            success: (data) => {
                                this.reviewList = data.list || [];
                            }
                        });
                    }
                },
                mounted() {
                    this.fnInit();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>