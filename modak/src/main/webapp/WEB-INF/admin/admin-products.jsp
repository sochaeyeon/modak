<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ page deferredSyntaxAllowedAsLiteral="true" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>상품 관리 - 모닥모닥 Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-products.css">
                <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
                <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

            </head>

            <body>
                <%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

                    <!-- 숨겨진 파일 인풋들 -->
                    <input type="file" id="mainImgInput" accept="image/*" style="display:none">
                    <input type="file" id="descImgInput" accept="image/*" style="display:none">
                    <input type="file" id="detailImgInput" accept="image/*" multiple style="display:none">

                    <div id="app" class="admin-main">
                        <div class="prod-page-container">
                            <div class="prod-header">
                                <div class="prod-title">⛺ 캠핑 장비 마스터 리스트</div>
                                <button class="p-btn" @click="fnOpenAdd">+ 새 상품 등록</button>
                            </div>

                            <div class="prod-filter-wrap">
                                <input class="p-input" v-model="keyword" placeholder="상품명으로 검색..."
                                    @keyup.enter="fnSearch" style="margin-bottom:0; flex:1">
                                <select class="p-input" v-model="typeFilter" @change="fnSearch"
                                    style="margin-bottom:0; width:150px">
                                    <option value="">유형 전체</option>
                                    <option value="RENTAL">대여 전용</option>
                                    <option value="PURCHASE">판매 전용</option>
                                </select>
                                <button class="p-btn" @click="fnSearch" style="padding:0 40px;">조회</button>
                            </div>

                            <div class="prod-card">
                                <div
                                    style="display:flex;justify-content:center;align-items:center;gap:8px;margin-top:20px;">
                                    <button class="p-btn manage-btn" :disabled="page === 1" @click="fnPrevPage">←
                                        이전</button>

                                    <span style="color:#fff;font-size:13px;">
                                        {{ page }} / {{ Math.ceil(totalCount / pageSize) }} 페이지
                                        <span style="color:var(--p-text-muted);margin-left:8px;">(총 {{ totalCount
                                            }}개)</span>
                                    </span>

                                    <button class="p-btn manage-btn"
                                        :disabled="page >= Math.ceil(totalCount / pageSize)" @click="fnNextPage">다음
                                        →</button>
                                </div>
                                <table class="prod-table">
                                    <thead>
                                        <tr>
                                            <th style="width:80px">ID</th>
                                            <th style="width:100px">이미지</th>
                                            <th style="text-align:left">상품명</th>
                                            <th>구분</th>
                                            <th>가격</th>
                                            <th>조회수</th>
                                            <th style="width:200px">매니징</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-if="list.length === 0">
                                            <td colspan="7" style="padding:40px;color:var(--p-text-muted);">상품이 없습니다.
                                            </td>
                                        </tr>
                                        <tr v-for="p in list" :key="p.PRODUCT_ID">
                                            <td>#{{ p.PRODUCT_ID }}</td>
                                            <td>
                                                <div class="prod-img-box">
                                                    <img v-if="p.IMG_URL" :src="p.IMG_URL" @error="imgError">
                                                    <div v-else style="padding-top:12px;font-size:20px;">🏕️</div>
                                                </div>
                                            </td>
                                            <td style="text-align:left; font-weight:600">{{ p.PRODUCT_NAME }}</td>
                                            <td>
                                                <span class="p-badge"
                                                    :class="p.PRODUCT_TYPE === 'RENTAL' ? 'rental' : 'purchase'">
                                                    {{ p.PRODUCT_TYPE === 'RENTAL' ? '대여' : '구매' }}
                                                </span>
                                            </td>
                                            <td style="color:var(--p-accent); font-weight:700">{{
                                                Number(p.PRICE).toLocaleString() }}원</td>
                                            <td>{{ p.VIEW_COUNT || 0 }}</td>
                                            <td>
                                                <button class="p-btn manage-btn" @click="fnOpenEdit(p)">수정</button>
                                                <button class="p-btn manage-btn del-btn"
                                                    @click="fnRemove(p)">삭제</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- ══ 상품 등록/수정 모달 ══ -->
                        <div class="p-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
                            <div class="p-modal">
                                <!-- 모달 헤더 -->
                                <div
                                    style="font-size:20px;font-weight:700;margin-bottom:10px;color:#fff;display:flex;justify-content:space-between;">
                                    <span>{{ isEdit ? '🛠️ 상품 정보 수정' : '🆕 신규 장비 등록' }}</span>
                                    <span style="cursor:pointer;color:var(--p-text-muted)"
                                        @click="modalOpen=false">&times;</span>
                                </div>

                                <!-- 탭 -->
                                <div class="p-tab-bar">
                                    <button class="p-tab" :class="{active: activeTab==='basic'}"
                                        @click="activeTab='basic'">기본 정보</button>
                                    <button class="p-tab" :class="{active: activeTab==='images'}"
                                        @click="activeTab='images'">상세 이미지</button>
                                    <button class="p-tab" :class="{active: activeTab==='options'}"
                                        @click="activeTab='options'" v-if="isEdit">옵션 관리</button>
                                    <button class="p-tab" :class="{active: activeTab==='stock'}"
                                        @click="activeTab='stock'" v-if="isEdit">재고 관리</button>
                                </div>

                                <!-- ══ TAB: 기본 정보 ══ -->
                                <div v-show="activeTab === 'basic'">
                                    <div class="section-title">메인 이미지</div>
                                    <div
                                        style="display:flex;align-items:center;gap:20px;background:rgba(255,255,255,.02);padding:20px;border-radius:16px;border:1px solid var(--p-border);">
                                        <div class="main-img-preview" @click="fnTriggerMainImg">
                                            <img v-if="mainImgPreview" :src="mainImgPreview">
                                            <div v-else style="font-size:30px;">🏕️</div>
                                            <div class="main-img-overlay">
                                                <span style="font-size:18px;">📷</span>
                                                <span>클릭하여 변경</span>
                                            </div>
                                        </div>
                                        <div>
                                            <p style="font-size:12px;color:var(--p-text-muted);margin-bottom:8px;">
                                                이미지를 클릭하거나 파일을 드래그해 업로드하세요.
                                            </p>
                                            <button class="p-btn" style="padding:8px 16px;font-size:12px;"
                                                @click="fnTriggerMainImg">
                                                <span v-if="mainImgUploading"><span class="upload-spinner"></span> 업로드
                                                    중...</span>
                                                <span v-else>📁 이미지 선택</span>
                                            </button>
                                            <p style="font-size:11px;color:var(--p-text-muted);margin-top:6px;">
                                                {{ form.imgUrl || '이미지 없음' }}
                                            </p>
                                        </div>
                                    </div>

                                    <div class="section-title">기본 정보</div>
                                    <div style="display:grid;grid-template-columns:2fr 1fr;gap:15px">
                                        <input class="p-input" v-model="form.productName" placeholder="상품명">
                                        <select class="p-input" v-model="form.categoryId">
                                            <option value="1">텐트/타프</option>
                                            <option value="2">침낭/매트</option>
                                            <option value="3">테이블/의자</option>
                                            <option value="4">조명/랜턴</option>
                                            <option value="5">취사도구</option>
                                        </select>
                                    </div>
                                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:15px">
                                        <select class="p-input" v-model="form.productType">
                                            <option value="RENTAL">대여</option>
                                            <option value="PURCHASE">판매</option>
                                        </select>
                                        <input class="p-input" type="number" v-model.number="form.price"
                                            placeholder="가격">
                                        <input class="p-input" type="number" v-model.number="form.deposit"
                                            placeholder="보증금">
                                    </div>
                                    <!-- 기존 textarea 삭제하고 아래로 교체 -->
                                    <div class="section-title">상세 설명 이미지</div>
                                    <div
                                        style="display:flex;align-items:center;gap:16px;background:rgba(255,255,255,.02);padding:16px;border-radius:14px;border:1px solid var(--p-border);">

                                        <!-- 미리보기 -->
                                        <div style="width:100px;height:100px;border-radius:10px;overflow:hidden;background:#1a1a27;border:1px solid var(--p-border);flex-shrink:0;display:flex;align-items:center;justify-content:center;cursor:pointer;"
                                            @click="fnTriggerDescImg">
                                            <img v-if="descImgPreview" :src="descImgPreview"
                                                style="width:100%;height:100%;object-fit:cover;">
                                            <span v-else style="font-size:28px;">🖼️</span>
                                        </div>

                                        <div>
                                            <p style="font-size:12px;color:var(--p-text-muted);margin-bottom:8px;">
                                                상품 상세 설명 이미지를 업로드하세요.<br>
                                                <span style="color:rgba(255,255,255,.3)">현재: {{ form.description || '없음'
                                                    }}</span>
                                            </p>
                                            <button class="p-btn" style="padding:8px 16px;font-size:12px;"
                                                @click="fnTriggerDescImg">
                                                <span v-if="descImgUploading"><span class="upload-spinner"></span> 업로드
                                                    중...</span>
                                                <span v-else>📁 이미지 선택</span>
                                            </button>
                                            <button v-if="form.description" class="p-btn"
                                                style="padding:8px 16px;font-size:12px;background:#353945;margin-left:8px;"
                                                @click="form.description=''; descImgPreview=''">
                                                삭제
                                            </button>
                                        </div>
                                    </div>
                                    <div class="section-title">상세 사양 (Spec)</div>
                                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px">
                                        <input class="p-input" v-model="form.capacity" placeholder="용량/인원">
                                        <input class="p-input" v-model="form.size" placeholder="사이즈">
                                        <input class="p-input" v-model="form.weight" placeholder="무게">
                                        <input class="p-input" v-model="form.material" placeholder="재질">
                                        <input class="p-input" v-model="form.origin" placeholder="원산지">
                                    </div>

                                    <div class="section-title">제품 특징 (Feature)</div>
                                    <div style="display:grid;grid-template-columns:1fr 2fr;gap:10px">
                                        <input class="p-input" v-model="form.featureTitle" placeholder="특징 제목">
                                        <input class="p-input" v-model="form.featureContent" placeholder="상세 특징 설명">
                                    </div>
                                </div>

                                <!-- ══ TAB: 상세 이미지 ══ -->
                                <div v-show="activeTab === 'images'">
                                    <div class="section-title">상세 설명 이미지</div>
                                    <p style="font-size:12px;color:var(--p-text-muted);margin-bottom:12px;">
                                        상품 상세 페이지에 표시될 이미지입니다. 여러 장 업로드 가능합니다.
                                    </p>

                                    <!-- 드래그 업로드 영역 -->
                                    <div class="img-upload-area" :class="{'drag-over': isDragOver}"
                                        @dragover.prevent="isDragOver=true" @dragleave="isDragOver=false"
                                        @drop.prevent="fnDropDetailImg" @click="fnTriggerDetailImg"
                                        style="margin-bottom:16px;">
                                        <div style="font-size:32px;margin-bottom:8px;">🖼️</div>
                                        <div style="font-size:14px;font-weight:700;color:#fff;margin-bottom:4px;">이미지를
                                            드래그하거나 클릭하여 업로드</div>
                                        <div style="font-size:12px;color:var(--p-text-muted);">JPG, PNG, WEBP 지원 · 여러 장
                                            동시 업로드 가능</div>
                                        <div v-if="detailImgUploading" style="margin-top:10px;">
                                            <span class="upload-spinner"></span>
                                            <span style="font-size:12px;color:var(--p-text-muted);margin-left:8px;">업로드
                                                중...</span>
                                        </div>
                                    </div>

                                    <div class="detail-img-grid">
                                        <div v-for="(img, idx) in detailImages" :key="img.imageId || idx"
                                            class="detail-img-item">
                                            <img :src="img.imgUrl">
                                            <button class="detail-img-remove"
                                                @click="fnRemoveDetailImg(img, idx)">✕</button>
                                        </div>
                                        <div class="detail-img-add" @click="fnTriggerDetailImg">
                                            <span>+</span>
                                            <span style="font-size:10px;margin-top:4px;">추가</span>
                                        </div>
                                    </div>

                                    <p v-if="detailImages.length === 0"
                                        style="font-size:13px;color:var(--p-text-muted);text-align:center;padding:20px;">
                                        등록된 상세 이미지가 없습니다.
                                    </p>
                                </div>

                                <!-- ══ TAB: 옵션 관리 ══ -->
                                <div v-show="activeTab === 'options'">
                                    <div class="section-title">옵션 그룹</div>
                                    <p style="font-size:12px;color:var(--p-text-muted);margin-bottom:14px;">색상, 사이즈 등 옵션
                                        종류를 추가하고, 각 그룹에 값(카키, L 등)을 등록하세요.</p>

                                    <div class="option-section">
                                        <!-- 기존 옵션 그룹들 -->
                                        <div class="option-group-card" v-for="group in optionGroups"
                                            :key="group.optionGroupId">
                                            <div class="option-group-head">
                                                <span class="option-group-name">{{ group.optionName }}</span>
                                                <button class="p-btn manage-btn del-btn"
                                                    style="padding:5px 10px;font-size:11px;"
                                                    @click="fnRemoveOptionGroup(group)">그룹 삭제</button>
                                            </div>

                                            <!-- 옵션 값 목록 -->
                                            <div class="option-values-wrap">
                                                <div class="option-value-chip" v-for="val in group.values"
                                                    :key="val.optionValueId">
                                                    {{ val.optionValue }}
                                                    <span class="chip-price" v-if="val.addPrice > 0">+{{
                                                        Number(val.addPrice).toLocaleString() }}원</span>
                                                    <button class="chip-del"
                                                        @click="fnRemoveOptionValue(val, group)">✕</button>
                                                </div>
                                                <span v-if="!group.values || group.values.length === 0"
                                                    style="font-size:12px;color:var(--p-text-muted);">값 없음</span>
                                            </div>

                                            <!-- 값 추가 행 -->
                                            <div class="option-add-row">
                                                <input class="p-input" style="width:130px;" v-model="group._newValue"
                                                    placeholder="값 이름 (예: 카키)">
                                                <input class="p-input" style="width:110px;" type="number"
                                                    v-model.number="group._newAddPrice" placeholder="추가 금액">
                                                <button class="p-btn" style="padding:10px 16px;font-size:12px;"
                                                    @click="fnAddOptionValue(group)">+ 값 추가</button>
                                            </div>
                                        </div>

                                        <!-- 새 옵션 그룹 추가 -->
                                        <div
                                            style="display:flex;gap:10px;align-items:center;padding:14px;background:rgba(255,255,255,.02);border-radius:12px;border:1px dashed var(--p-border);">
                                            <input class="p-input" style="flex:1;margin-bottom:0;"
                                                v-model="newGroupName" placeholder="새 옵션 그룹 이름 (예: 색상)">
                                            <button class="p-btn" style="padding:10px 20px;white-space:nowrap;"
                                                @click="fnAddOptionGroup">+ 그룹 추가</button>
                                        </div>
                                    </div>

                                    <!-- 옵션 아이템 (조합) -->
                                    <div class="section-title" style="margin-top:24px;">옵션 조합 (구매 가능 아이템)</div>
                                    <p style="font-size:12px;color:var(--p-text-muted);margin-bottom:10px;">
                                        실제로 구매/대여 가능한 옵션 조합 목록입니다.
                                    </p>
                                    <div v-if="optionItems.length === 0"
                                        style="font-size:13px;color:var(--p-text-muted);padding:16px;text-align:center;">
                                        옵션 그룹과 값을 추가하면 조합이 자동 생성됩니다.
                                    </div>
                                    <div v-for="item in optionItems" :key="item.optionItemId" class="option-item-row">
                                        <div class="option-item-name">{{ item.itemName }}</div>
                                        <div class="option-item-price">+{{ Number(item.extraPrice || 0).toLocaleString()
                                            }}원</div>
                                        <div class="option-item-avail"
                                            :class="item.isAvailable === 'Y' ? '' : 'unavail'">
                                            {{ item.isAvailable === 'Y' ? '판매중' : '판매중지' }}
                                        </div>
                                        <button class="p-btn manage-btn" style="padding:5px 10px;font-size:11px;"
                                            @click="fnToggleItemAvail(item)">
                                            {{ item.isAvailable === 'Y' ? '중지' : '활성' }}
                                        </button>
                                    </div>
                                </div>

                                <!-- ══ TAB: 재고 관리 ══ -->
                                <div v-show="activeTab === 'stock'">
                                    <div class="section-title">재고 수량 관리</div>
                                    <div class="stock-section">
                                        <div v-if="stockList.length === 0"
                                            style="color:var(--p-text-muted);font-size:13px;padding:12px 0;">
                                            등록된 재고 정보가 없습니다.
                                        </div>
                                        <div v-for="(stock, idx) in stockList" :key="idx" class="stock-row">
                                            <div style="flex:1;">
                                                <span class="p-label" style="margin:0;">옵션 {{ stock.optionId || '-'
                                                    }}</span>
                                            </div>
                                            <div style="display:flex;gap:10px;align-items:center;">
                                                <div>
                                                    <label class="p-label">전체 수량</label>
                                                    <input class="p-input stock-input" type="number"
                                                        v-model.number="stock.totalQty" min="0"
                                                        @change="fnUpdateStock(stock)">
                                                </div>
                                                <div>
                                                    <label class="p-label">예약 수량</label>
                                                    <input class="p-input stock-input" type="number"
                                                        v-model.number="stock.reservedQty" min="0"
                                                        @change="fnUpdateStock(stock)">
                                                </div>
                                                <div>
                                                    <label class="p-label">가용 수량</label>
                                                    <input class="p-input stock-input" type="number"
                                                        :value="stock.totalQty - stock.reservedQty" readonly
                                                        style="opacity:.5;cursor:not-allowed;">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="stock-add-row">
                                            <input class="p-input stock-input" type="number"
                                                v-model.number="newStock.totalQty" placeholder="전체 수량" min="0">
                                            <input class="p-input stock-input" type="text" v-model="newStock.optionId"
                                                placeholder="옵션 ID (필수)">
                                            <button class="p-btn" style="padding:10px 20px;white-space:nowrap;"
                                                @click="fnAddStock">+ 재고 추가</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- 하단 버튼 -->
                                <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:30px;">
                                    <button class="p-btn" style="background:#353945"
                                        @click="modalOpen=false">취소</button>
                                    <button class="p-btn" @click="fnSave" v-if="activeTab === 'basic'">정보 저장</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    list: [], keyword: '', typeFilter: '', page: 1, pageSize: 20,
                                    modalOpen: false, isEdit: false,
                                    activeTab: 'basic',
                                    totalCount: 0,
                                    // 이미지
                                    mainImgPreview: '',
                                    mainImgUploading: false,
                                    detailImages: [],
                                    detailImgUploading: false,
                                    isDragOver: false,
                                    descImgPreview: '',
                                    descImgUploading: false,

                                    // 옵션
                                    optionGroups: [],
                                    optionItems: [],
                                    newGroupName: '',

                                    // 재고
                                    stockList: [],
                                    newStock: { totalQty: 0, optionId: '' },

                                    form: {
                                        productId: '', productName: '', categoryId: 1, productType: 'RENTAL',
                                        price: 0, deposit: 0, description: '', imgUrl: '',
                                        capacity: '', size: '', weight: '', material: '', origin: '',
                                        featureTitle: '', featureContent: ''
                                    }
                                };
                            },

                            methods: {
                                /* ══ 상품 목록 ══ */
                                fnLoad() {
                                    $.ajax({
                                        url: '${pageContext.request.contextPath}/admin/product/list.dox',
                                        type: 'POST',
                                        data: {
                                            keyword: this.keyword,
                                            productType: this.typeFilter,
                                            offset: (this.page - 1) * this.pageSize,  // ← 이 부분 확인
                                            pageSize: this.pageSize
                                        },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.list = data.list;
                                                this.totalCount = data.totalCount || 0;
                                            }
                                        }
                                    });
                                },
                                fnSearch() {
                                    this.page = 1;  // ← 검색하면 1페이지로
                                    this.fnLoad();
                                },
                                fnNextPage() {
                                    this.page++;
                                    this.fnLoad();
                                },
                                fnPrevPage() {
                                    this.page--;
                                    this.fnLoad();
                                },
                                /* ══ 모달 열기 ══ */
                                fnOpenAdd() {
                                    this.isEdit = false;
                                    this.activeTab = 'basic';
                                    this.form = { productId: '', productName: '', categoryId: 1, productType: 'RENTAL', price: 0, deposit: 0, description: '', imgUrl: '', capacity: '', size: '', weight: '', material: '', origin: '', featureTitle: '', featureContent: '' };
                                    this.mainImgPreview = '';
                                    this.detailImages = [];
                                    this.stockList = [];
                                    this.optionGroups = [];
                                    this.optionItems = [];
                                    this.newStock = { totalQty: 0, optionId: '' };
                                    this.modalOpen = true;
                                    this.descImgPreview = '';
                                },
                                fnTriggerDescImg() {
                                    document.getElementById('descImgInput').click();
                                },

                                fnUploadDescImg(file) {
                                    if (!file) return;
                                    this.descImgUploading = true;
                                    const fd = new FormData();
                                    fd.append('file', file);
                                    fd.append('type', 'desc');
                                    $.ajax({
                                        url: '/admin/product/upload-img.dox',
                                        type: 'POST', data: fd,
                                        processData: false, contentType: false,
                                        success: (res) => {
                                            this.descImgUploading = false;
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.form.description = data.imgUrl;  // ← description 컬럼에 이미지 URL 저장
                                                this.descImgPreview = data.imgUrl;
                                            } else {
                                                alert('업로드 실패: ' + data.message);
                                            }
                                        },
                                        error: () => { this.descImgUploading = false; alert('업로드 오류'); }
                                    });
                                },

                                fnOpenEdit(p) {
                                    this.isEdit = true;
                                    this.activeTab = 'basic';
                                    this.form = {
                                        productId: p.PRODUCT_ID, productName: p.PRODUCT_NAME, categoryId: p.CATEGORY_ID || 1,
                                        productType: p.PRODUCT_TYPE, price: p.PRICE, deposit: p.DEPOSIT, description: p.DESCRIPTION,
                                        imgUrl: p.IMG_URL || '',
                                        capacity: p.CAPACITY || '', size: p.SIZE || '', weight: p.WEIGHT || '',
                                        material: p.MATERIAL || '', origin: p.ORIGIN || '',
                                        featureTitle: p.FEATURE_TITLE || '', featureContent: p.FEATURE_CONTENT || ''
                                    };
                                    this.mainImgPreview = p.IMG_URL || '';
                                    this.detailImages = [];
                                    this.stockList = [];
                                    this.optionGroups = [];
                                    this.optionItems = [];
                                    this.modalOpen = true;
                                    this.fnLoadDetailImages(p.PRODUCT_ID);
                                    this.fnLoadStock(p.PRODUCT_ID);
                                    this.fnLoadOptions(p.PRODUCT_ID);
                                },

                                /* ══ 기본 정보 저장 ══ */
                                fnSave() {
                                    if (!this.form.productName) { alert('상품명을 입력하세요.'); return; }
                                    const url = this.isEdit ? '/admin/product/update.dox' : '/admin/product/insertFull.dox';
                                    $.ajax({
                                        url: '${pageContext.request.contextPath}' + url,
                                        type: 'POST', data: this.form,
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                alert('저장 성공!');
                                                this.modalOpen = false;
                                                this.fnLoad();
                                            } else {
                                                alert('오류: ' + data.message);
                                            }
                                        }
                                    });
                                },

                                fnRemove(p) {
                                    if (!confirm('정말 삭제하시겠습니까? 관련 데이터가 모두 삭제됩니다.')) return;
                                    $.ajax({
                                        url: '${pageContext.request.contextPath}/admin/product/remove.dox',
                                        type: 'POST', data: { productId: p.PRODUCT_ID },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') { alert('삭제되었습니다.'); this.fnLoad(); }
                                        }
                                    });
                                },

                                /* ══ 메인 이미지 업로드 ══ */
                                fnTriggerMainImg() {
                                    document.getElementById('mainImgInput').click();
                                },

                                fnUploadMainImg(file) {
                                    if (!file) return;
                                    this.mainImgUploading = true;
                                    const fd = new FormData();
                                    fd.append('file', file);
                                    fd.append('type', 'main');
                                    $.ajax({
                                        url: '/admin/product/upload-img.dox',
                                        type: 'POST', data: fd,
                                        processData: false, contentType: false,
                                        success: (res) => {
                                            this.mainImgUploading = false;
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.form.imgUrl = data.imgUrl;
                                                this.mainImgPreview = data.imgUrl;
                                            } else {
                                                alert('이미지 업로드 실패: ' + data.message);
                                            }
                                        },
                                        error: () => { this.mainImgUploading = false; alert('업로드 오류'); }
                                    });
                                },

                                /* ══ 상세 이미지 ══ */
                                fnTriggerDetailImg() {
                                    document.getElementById('detailImgInput').click();
                                },

                                fnLoadDetailImages(productId) {
                                    $.ajax({
                                        url: '/admin/product/detail-images.dox',
                                        type: 'POST', data: { productId },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') this.detailImages = data.list || [];
                                        }
                                    });
                                },

                                fnUploadDetailImgs(files) {
                                    if (!files || files.length === 0) return;
                                    if (!this.form.productId && !this.isEdit) {
                                        alert('상품을 먼저 저장한 뒤 상세 이미지를 업로드해주세요.');
                                        return;
                                    }
                                    this.detailImgUploading = true;
                                    const fd = new FormData();
                                    Array.from(files).forEach(f => fd.append('files', f));
                                    fd.append('productId', this.form.productId);
                                    fd.append('type', 'detail');
                                    $.ajax({
                                        url: '/admin/product/upload-detail-imgs.dox',
                                        type: 'POST', data: fd,
                                        processData: false, contentType: false,
                                        success: (res) => {
                                            this.detailImgUploading = false;
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.fnLoadDetailImages(this.form.productId);
                                            } else {
                                                alert('업로드 실패: ' + data.message);
                                            }
                                        },
                                        error: () => { this.detailImgUploading = false; alert('업로드 오류'); }
                                    });
                                },

                                fnDropDetailImg(e) {
                                    this.isDragOver = false;
                                    this.fnUploadDetailImgs(e.dataTransfer.files);
                                },

                                fnRemoveDetailImg(img, idx) {
                                    if (!confirm('이미지를 삭제하시겠습니까?')) return;
                                    if (img.imageId) {
                                        $.ajax({
                                            url: '/admin/product/detail-image/remove.dox',
                                            type: 'POST', data: { imageId: img.imageId },
                                            success: (res) => {
                                                const data = typeof res === 'string' ? JSON.parse(res) : res;
                                                if (data.result === 'success') this.detailImages.splice(idx, 1);
                                            }
                                        });
                                    } else {
                                        this.detailImages.splice(idx, 1);
                                    }
                                },

                                /* ══ 옵션 관리 ══ */
                                fnLoadOptions(productId) {
                                    $.ajax({
                                        url: '/admin/product/option/list.dox',
                                        type: 'POST', data: { productId },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.optionGroups = (data.groups || []).map(g => ({
                                                    ...g, _newValue: '', _newAddPrice: 0
                                                }));
                                                this.optionItems = data.items || [];
                                            }
                                        }
                                    });
                                },

                                fnAddOptionGroup() {
                                    if (!this.newGroupName.trim()) { alert('그룹 이름을 입력하세요.'); return; }
                                    $.ajax({
                                        url: '/admin/product/option/group/add.dox',
                                        type: 'POST', data: { productId: this.form.productId, optionName: this.newGroupName.trim() },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.newGroupName = '';
                                                this.fnLoadOptions(this.form.productId);
                                            } else { alert(data.message || '추가 실패'); }
                                        }
                                    });
                                },

                                fnRemoveOptionGroup(group) {
                                    if (!confirm('옵션 그룹과 관련 값을 모두 삭제하시겠습니까?')) return;
                                    $.ajax({
                                        url: '/admin/product/option/group/remove.dox',
                                        type: 'POST', data: { optionGroupId: group.optionGroupId },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') this.fnLoadOptions(this.form.productId);
                                        }
                                    });
                                },

                                fnAddOptionValue(group) {
                                    if (!group._newValue.trim()) { alert('값 이름을 입력하세요.'); return; }
                                    $.ajax({
                                        url: '/admin/product/option/value/add.dox',
                                        type: 'POST', data: {
                                            optionGroupId: group.optionGroupId,
                                            optionValue: group._newValue.trim(),
                                            addPrice: group._newAddPrice || 0
                                        },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                group._newValue = ''; group._newAddPrice = 0;
                                                this.fnLoadOptions(this.form.productId);
                                            } else { alert(data.message || '추가 실패'); }
                                        }
                                    });
                                },

                                fnRemoveOptionValue(val, group) {
                                    $.ajax({
                                        url: '/admin/product/option/value/remove.dox',
                                        type: 'POST', data: { optionValueId: val.optionValueId },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') this.fnLoadOptions(this.form.productId);
                                        }
                                    });
                                },

                                fnToggleItemAvail(item) {
                                    const newVal = item.isAvailable === 'Y' ? 'N' : 'Y';
                                    $.ajax({
                                        url: '/admin/product/option/item/avail.dox',
                                        type: 'POST', data: { optionItemId: item.optionItemId, isAvailable: newVal },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') item.isAvailable = newVal;
                                        }
                                    });
                                },

                                /* ══ 재고 관리 ══ */
                                fnLoadStock(productId) {
                                    $.ajax({
                                        url: '/admin/product/stock/list.dox',
                                        type: 'POST', data: { productId },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') this.stockList = data.list || [];
                                        }
                                    });
                                },

                                fnUpdateStock(stock) {
                                    stock.availableQty = stock.totalQty - stock.reservedQty;
                                    $.ajax({
                                        url: '/admin/product/stock/update.dox',
                                        type: 'POST',
                                        data: { stockId: stock.stockId, totalQty: stock.totalQty, reservedQty: stock.reservedQty, availableQty: stock.availableQty },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result !== 'success') alert('재고 수정 실패');
                                        }
                                    });
                                },

                                fnAddStock() {
                                    if (!this.form.productId) { alert('상품을 먼저 저장하세요.'); return; }
                                    $.ajax({
                                        url: '/admin/product/stock/add.dox',
                                        type: 'POST',
                                        data: { productId: this.form.productId, optionId: this.newStock.optionId || '', totalQty: this.newStock.totalQty, reservedQty: 0, availableQty: this.newStock.totalQty },
                                        success: (res) => {
                                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                                            if (data.result === 'success') {
                                                this.fnLoadStock(this.form.productId);
                                                this.newStock = { totalQty: 0, optionId: '' };
                                            }
                                        }
                                    });
                                },

                                imgError(e) { e.target.src = '/img/no-image.png'; }
                            },

                            mounted() {
                                this.fnLoad();

                                // 메인 이미지 선택 이벤트
                                document.getElementById('mainImgInput').addEventListener('change', (e) => {
                                    const file = e.target.files[0];
                                    if (file) this.fnUploadMainImg(file);
                                    e.target.value = '';
                                });

                                // 상세 이미지 선택 이벤트
                                document.getElementById('detailImgInput').addEventListener('change', (e) => {
                                    this.fnUploadDetailImgs(e.target.files);
                                    e.target.value = '';
                                });
                                document.getElementById('descImgInput').addEventListener('change', (e) => {
                                    const file = e.target.files[0];
                                    if (file) this.fnUploadDescImg(file);
                                    e.target.value = '';
                                });
                            }
                        }).mount('#app');
                    </script>
            </body>

            </html>