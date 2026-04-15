<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모닥모닥 - 캠핑장 지도 서비스</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=56203df9ba6a9876af824b38ea2ec90f&autoload=false"></script>
    <style>
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; font-family: 'Noto Sans KR', sans-serif; }
        #app { display: flex; width: 100vw; height: 100vh; }

        /* 왼쪽 사이드바 */
        .side-panel { width: 380px; min-width: 380px; height: 100%; background: white; display: flex; flex-direction: column; box-shadow: 2px 0 10px rgba(0,0,0,0.1); z-index: 100; }
        .panel-header { padding: 20px; border-bottom: 1px solid #eee; background: #fff; }
        .area-select { width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 10px; }
        .camp-list { flex: 1; overflow-y: auto; list-style: none; padding: 0; margin: 0; }
        .camp-item { padding: 15px 20px; border-bottom: 1px solid #f9f9f9; cursor: pointer; transition: 0.2s; }
        .camp-item:hover { background: #fdfaf7; }

        /* 지도 영역 */
        .map-container { flex: 1; height: 100%; position: relative; }
        #map { width: 100%; height: 100%; }

        /* 모달 (상세보기 & 리뷰) */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 2000; }
        .modal-content { width: 550px; max-height: 85vh; background: white; border-radius: 15px; overflow-y: auto; position: relative; padding-bottom: 30px; }
        .modal-img-wrapper { width: 100%; height: 250px; background: #eee; display: flex; align-items: center; justify-content: center; overflow: hidden; }
        .modal-img { width: 100%; height: 100%; object-fit: cover; }
        .modal-body { padding: 25px; }
        
        /* 리뷰 스타일 */
        .review-box { margin-top: 25px; border-top: 1px solid #eee; padding-top: 20px; }
        .review-item { padding: 10px 0; border-bottom: 1px solid #f5f5f5; font-size: 14px; }
        .rating-star { color: #f1c40f; margin-right: 5px; }
        .no-data { text-align: center; padding: 30px; color: #999; }
        
        .btn-detail { margin-top:8px; padding:4px 10px; border:1px solid #e67e22; background:none; color:#e67e22; border-radius:4px; cursor:pointer; font-weight: bold; }
        .btn-detail:hover { background: #e67e22; color: white; }
    </style>
</head>
<body>

<div id="app">
    <div class="side-panel">
        <div class="panel-header">
            <h2 style="color:#e67e22; margin-bottom: 15px;">⛺ 모닥모닥</h2>
            <select v-model="selectedArea" class="area-select" @change="fnFilterArea">
                <option value="">전국 전체</option>
                <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
            </select>
            <div style="font-size: 13px; color: #666;">현재 검색 결과: <b>{{ filteredList.length }}</b>건</div>
        </div>

        <ul class="camp-list">
            <li v-for="item in filteredList" :key="item.contentId" class="camp-item" @click="panTo(item)">
                <div style="font-weight: bold; font-size: 16px; color: #333;">{{ item.facltNm }}</div>
                <div style="font-size: 13px; color: #888; margin-top: 5px;">📍 {{ item.addr1 }}</div>
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
                <img v-if="detailItem.firstImageUrl" :src="detailItem.firstImageUrl" class="modal-img" @error="detailItem.firstImageUrl = null">
                <div v-else style="color: #bbb; font-weight: bold;">🏕️ 등록된 이미지가 없습니다</div>
            </div>
            
            <div class="modal-body">
                <h2 style="margin-top:0; color: #333;">{{ detailItem.facltNm }}</h2>
                <p style="color:#e67e22; font-weight: bold;">📍 {{ detailItem.addr1 }}</p>
                <div style="line-height:1.6; color:#555; background: #f9f9f9; padding: 15px; border-radius: 8px;">
                    {{ detailItem.lineIntro || '소개 정보가 등록되지 않은 캠핑장입니다.' }}
                </div>

                <div class="review-box">
                    <h3 style="font-size:18px; margin-bottom: 15px;">방문객 리뷰 ({{ reviewList.length }})</h3>
                    
                    <div v-if="reviewList.length > 0">
                        <div v-for="rev in reviewList" :key="rev.campReviewId" class="review-item">
                            <div style="display:flex; justify-content:space-between;">
                                <span><b class="rating-star">★</b>{{ rev.rating }} | <b>{{ rev.userId }}</b></span>
                                <span style="color:#ccc;">{{ rev.createdAt }}</span>
                            </div>
                            <div style="margin-top:5px; color:#555;">{{ rev.content }}</div>
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
            cities: ['서울','경기','강원','인천','충북','충남','대전','세종','전북','전남','광주','경북','경남','대구','울산','부산','제주'],
            selectedArea: '',
            isModalOpen: false,
            detailItem: {},
            reviewList: [] // length 에러 방지를 위해 빈 배열로 초기화
        };
    },
    methods: {
        fnInit() {
            // 카카오맵 로드 및 초기 설정
            kakao.maps.load(() => {
                const container = document.getElementById('map');
                const options = { 
                    center: new kakao.maps.LatLng(36.5, 127.8), 
                    level: 11 
                };
                this.map = new kakao.maps.Map(container, options);
                this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
                this.fnFetch();
            });
        },
        fnFetch() {
            // DB에서 저장된 캠핑장 목록(CAMP + CAMP_IMG) 가져오기
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
            // 지역 필터링 로직
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
            // 기존 마커 제거 후 새 마커 그리기
            this.markers.forEach(m => m.setMap(null));
            this.markers = [];

            list.forEach(item => {
                if (!item.mapY || !item.mapX) return;
                const pos = new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX));
                const marker = new kakao.maps.Marker({ 
                    position: pos, 
                    map: this.map 
                });
                
                // 마커 클릭 시 상세보기 모달 오픈
                kakao.maps.event.addListener(marker, 'click', () => {
                    this.openDetail(item);
                });
                this.markers.push(marker);
            });
        },
        panTo(item) {
            // 선택된 항목으로 지도 이동
            if (!item.mapY || !item.mapX) return;
            const pos = new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX));
            this.map.panTo(pos);
        },
        openDetail(item) {
            // 상세보기 모달 데이터 설정
            this.detailItem = item;
            this.reviewList = []; // 이전 데이터 잔상 제거
            this.isModalOpen = true;

            // 해당 캠핑장의 리뷰 목록을 DB에서 별도로 조회
            $.ajax({
                url: "/camp/reviewList.dox",
                type: "POST",
                data: { campId: item.contentId }, // XML 매퍼와 일치
                success: (data) => {
                    // 서버 응답이 null이어도 빈 배열로 처리해서 .length 에러 방지
                    this.reviewList = data.list || [];
                },
                error: (err) => {
                    console.error("리뷰 로드 실패:", err);
                    this.reviewList = [];
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