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

    <div id="app" class="admin-main">
        <div class="prod-page-container">
            <div class="prod-header">
                <div class="prod-title">⛺ 캠핑 장비 마스터 리스트</div>
                <button class="p-btn" @click="fnOpenAdd">+ 새 상품 등록</button>
            </div>

            <div class="prod-filter-wrap">
                <input class="p-input" v-model="keyword" placeholder="상품명으로 검색..." @keyup.enter="fnSearch" style="margin-bottom:0; flex:1">
                <select class="p-input" v-model="typeFilter" @change="fnSearch" style="margin-bottom:0; width:150px">
                    <option value="">유형 전체</option>
                    <option value="RENTAL">대여 전용</option>
                    <option value="PURCHASE">판매 전용</option>
                </select>
                <button class="p-btn" @click="fnSearch" style="padding: 0 40px;">조회</button>
            </div>

            <div class="prod-card">
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
                        <tr v-for="p in list" :key="p.PRODUCT_ID">
                            <td>#{{ p.PRODUCT_ID }}</td>
                            <td>
                                <div class="prod-img-box">
                                    <img v-if="p.IMG_URL" :src="p.IMG_URL" @error="imgError">
                                    <div v-else style="padding-top:12px">🏕️</div>
                                </div>
                            </td>
                            <td style="text-align:left; font-weight:600">{{ p.PRODUCT_NAME }}</td>
                            <td>
                                <span class="p-badge" :class="p.PRODUCT_TYPE === 'RENTAL' ? 'rental' : 'purchase'">
                                    {{ p.PRODUCT_TYPE === 'RENTAL' ? '대여' : '구매' }}
                                </span>
                            </td>
                            <td style="color:var(--p-accent); font-weight:700">{{ Number(p.PRICE).toLocaleString() }}원</td>
                            <td>{{ p.VIEW_COUNT || 0 }}</td>
                            <td>
                                <button class="p-btn manage-btn" @click="fnOpenEdit(p)">수정</button>
                                <button class="p-btn manage-btn del-btn" @click="fnRemove(p)">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="p-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="p-modal">
                <div style="font-size:20px; font-weight:700; margin-bottom:25px; color:#fff; display:flex; justify-content:space-between;">
                    <span>{{ isEdit ? '🛠️ 상품 정보 수정' : '🆕 신규 장비 등록' }}</span>
                    <span style="cursor:pointer; color:var(--p-text-muted)" @click="modalOpen=false">&times;</span>
                </div>

                <div class="section-title">상품 이미지 설정</div>
                <div class="modal-img-section">
                    <div class="prod-img-box" style="width:120px; height:120px; margin:0;">
                        <img v-if="form.imgUrl" :src="fullImgPath" @error="imgError">
                        <div v-else class="no-img-text">No Image</div>
                    </div>
                    <div style="flex:1">
                        <label class="p-label">이미지 파일명 (img/product/ 폴더 내 파일)</label>
                        <input class="p-input" v-model="form.imgUrl" placeholder="예: tent_01.png">
                    </div>
                </div>

                <div class="section-title">기본 정보</div>
                <div style="display:grid; grid-template-columns: 2fr 1fr; gap:15px">
                    <input class="p-input" v-model="form.productName" placeholder="상품명">
                    <select class="p-input" v-model="form.categoryId">
                        <option value="1">텐트/타프</option>
                        <option value="2">침낭/매트</option>
                        <option value="3">테이블/의자</option>
                        <option value="4">조명/랜턴</option>
                        <option value="5">취사도구</option>
                    </select>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:15px">
                    <select class="p-input" v-model="form.productType">
                        <option value="RENTAL">대여</option>
                        <option value="PURCHASE">판매</option>
                    </select>
                    <input class="p-input" type="number" v-model.number="form.price" placeholder="가격">
                    <input class="p-input" type="number" v-model.number="form.deposit" placeholder="보증금">
                </div>
                <textarea class="p-input" v-model="form.description" placeholder="상세 설명" style="height:80px;"></textarea>

                <div class="section-title">상세 사양 (Spec)</div>
                <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:10px">
                    <input class="p-input" v-model="form.capacity" placeholder="용량/인원">
                    <input class="p-input" v-model="form.size" placeholder="사이즈">
                    <input class="p-input" v-model="form.weight" placeholder="무게">
                    <input class="p-input" v-model="form.material" placeholder="재질">
                    <input class="p-input" v-model="form.origin" placeholder="원산지">
                </div>

                <div class="section-title">제품 특징 (Feature)</div>
                <div style="display:grid; grid-template-columns: 1fr 2fr; gap:10px">
                    <input class="p-input" v-model="form.featureTitle" placeholder="특징 제목">
                    <input class="p-input" v-model="form.featureContent" placeholder="상세 특징 설명">
                </div>

                <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:30px">
                    <button class="p-btn" style="background:#353945" @click="modalOpen=false">취소</button>
                    <button class="p-btn" @click="fnSave">정보 저장</button>
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
                    form: { 
                        productId: '', productName: '', categoryId: 1, productType: 'RENTAL', 
                        price: 0, deposit: 0, description: '', imgUrl: '',
                        capacity: '', size: '', weight: '', material: '', origin: '',
                        featureTitle: '', featureContent: ''
                    }
                };
            },
            computed: {
                fullImgPath() {
                    if (!this.form.imgUrl) return '';
                    if (this.form.imgUrl.startsWith('/') || this.form.imgUrl.startsWith('http')) return this.form.imgUrl;
                    return '/img/product/' + this.form.imgUrl;
                }
            },
            methods: {
                fnLoad() {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/product/list.dox',
                        type: 'POST',
                        data: { keyword: this.keyword, productType: this.typeFilter, offset: 0, pageSize: this.pageSize },
                        success: (res) => { 
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') this.list = data.list; 
                        }
                    });
                },
                fnSearch() { this.fnLoad(); },
                fnOpenAdd() {
                    this.isEdit = false;
                    this.form = { 
                        productId: '', productName: '', categoryId: 1, productType: 'RENTAL', price: 0, deposit: 0, description: '',
                        imgUrl: '', capacity: '', size: '', weight: '', material: '', origin: '', featureTitle: '', featureContent: ''
                    };
                    this.modalOpen = true;
                },
                fnOpenEdit(p) {
                    this.isEdit = true;
                    // 중요: DB 대문자 데이터를 Vue 소문자 모델에 바인딩
                    this.form = { 
                        productId: p.PRODUCT_ID, 
                        productName: p.PRODUCT_NAME, 
                        categoryId: p.CATEGORY_ID || 1,
                        productType: p.PRODUCT_TYPE, 
                        price: p.PRICE, 
                        deposit: p.DEPOSIT, 
                        description: p.DESCRIPTION,
                        imgUrl: p.IMG_URL ? p.IMG_URL.replace('/img/product/', '') : '',
                        // 상세 정보 바인딩 (XML에서 JOIN을 걸어야 값이 들어옵니다)
                        capacity: p.CAPACITY || '', 
                        size: p.SIZE || '', 
                        weight: p.WEIGHT || '',
                        material: p.MATERIAL || '', 
                        origin: p.ORIGIN || '',
                        featureTitle: p.FEATURE_TITLE || '', 
                        featureContent: p.FEATURE_CONTENT || ''
                    };
                    this.modalOpen = true;
                },
                fnSave() {
                    let self = this;
                    if(!self.form.productName) { alert("상품명을 입력하세요."); return; }

                    let finalImg = self.form.imgUrl;
                    if(finalImg && !finalImg.startsWith('/') && !finalImg.startsWith('http')) {
                        finalImg = '/img/product/' + finalImg;
                    }

                    const saveData = { ...self.form, imgUrl: finalImg };
                    const url = self.isEdit ? '/admin/product/update.dox' : '/admin/product/insertFull.dox';

                    $.ajax({
                        url: '${pageContext.request.contextPath}' + url,
                        type: 'POST',
                        data: saveData,
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                alert("저장 성공!");
                                self.modalOpen = false;
                                self.fnLoad();
                            } else {
                                alert("오류: " + data.message);
                            }
                        }
                    });
                },
                fnRemove(p) {
                    if(!confirm("정말 삭제하시겠습니까? 관련 데이터가 모두 삭제됩니다.")) return;
                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/product/remove.dox',
                        type: 'POST',
                        data: { productId: p.PRODUCT_ID },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') {
                                alert("삭제되었습니다.");
                                this.fnLoad();
                            }
                        }
                    });
                },
                imgError(e) { e.target.src = '/img/no-image.png'; }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>