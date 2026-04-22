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
                <button class="p-btn" @click="fnSearch" style="padding: 0 30px;">조회</button>
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
                            <th>상태</th>
                            <th style="width:180px">매니징</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="p in list" :key="p.PRODUCT_ID">
                            <td>#{{ p.PRODUCT_ID }}</td>
                            <td>
                                <div class="prod-img-box">
                                    <img v-if="p.IMG_URL" :src="p.IMG_URL">
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
                            <td>
                                <span :style="{color: p.IS_AVAILABLE === 'Y' ? '#58d68d' : '#ec7063', fontSize: '12px', fontWeight: 'bold'}">
                                    {{ p.IS_AVAILABLE === 'Y' ? '● 판매중' : '● 중지됨' }}
                                </span>
                            </td>
                            <td>
                                <button class="p-btn" @click="fnOpenEdit(p)" style="background:#353945; padding:6px 12px; margin-right:5px">수정</button>
                                <button class="p-btn" @click="fnToggleAvail(p)" 
                                        :style="{background: p.IS_AVAILABLE === 'Y' ? 'rgba(231,76,60,0.2)' : 'rgba(46,204,113,0.2)', 
                                                 color: p.IS_AVAILABLE === 'Y' ? '#ec7063' : '#58d68d',
                                                 boxShadow: 'none'}">
                                    {{ p.IS_AVAILABLE === 'Y' ? '중지' : '복구' }}
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="p-modal-overlay" :class="{open: modalOpen}" @click.self="modalOpen=false">
            <div class="p-modal">
                <div style="font-size:20px; font-weight:700; margin-bottom:30px; color:#fff">
                    {{ isEdit ? '🛠️ 상품 정보 수정' : '🆕 신규 장비 등록' }}
                </div>
                <label style="font-size:11px; color:var(--p-text-muted)">상품명</label>
                <input class="p-input" v-model="form.productName" placeholder="장비 이름을 입력하세요">
                
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px">
                    <div>
                        <label style="font-size:11px; color:var(--p-text-muted)">유형</label>
                        <select class="p-input" v-model="form.productType">
                            <option value="RENTAL">대여</option>
                            <option value="PURCHASE">구매</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:11px; color:var(--p-text-muted)">가격 (원)</label>
                        <input class="p-input" type="number" v-model.number="form.price">
                    </div>
                </div>

                <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:30px">
                    <button @click="modalOpen=false" style="background:transparent; color:var(--p-text-muted); border:none; cursor:pointer">닫기</button>
                    <button class="p-btn" @click="fnSave">{{ isEdit ? '수정 완료' : '등록 하기' }}</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    list: [], keyword: '', typeFilter: '', page: 1, pageSize: 15,
                    modalOpen: false, isEdit: false,
                    form: { productId: '', productName: '', productType: 'RENTAL', price: 0 }
                };
            },
            methods: {
                fnLoad() {
                    $.ajax({
                        url: '/admin/product/list.dox',
                        type: 'POST',
                        data: { keyword: this.keyword, productType: this.typeFilter, page: this.page, pageSize: this.pageSize },
                        success: (res) => { if (res.result === 'success') this.list = res.list; }
                    });
                },
                fnSearch() { this.page = 1; this.fnLoad(); },
                fnOpenAdd() {
                    this.isEdit = false;
                    this.form = { productName: '', productType: 'RENTAL', price: 0 };
                    this.modalOpen = true;
                },
                fnOpenEdit(p) {
                    this.isEdit = true;
                    this.form = { productId: p.PRODUCT_ID, productName: p.PRODUCT_NAME, productType: p.PRODUCT_TYPE, price: p.PRICE };
                    this.modalOpen = true;
                },
                fnSave() {
                    const url = this.isEdit ? '/admin/product/update.dox' : '/admin/product/insert.dox';
                    $.ajax({
                        url, type: 'POST', data: this.form,
                        success: (res) => { if (res.result === 'success') { this.modalOpen = false; this.fnLoad(); } }
                    });
                },
                fnToggleAvail(p) {
                    const newVal = p.IS_AVAILABLE === 'Y' ? 'N' : 'Y';
                    $.ajax({
                        url: '/admin/product/avail.dox',
                        type: 'POST',
                        data: { productId: p.PRODUCT_ID, isAvailable: newVal },
                        success: (res) => { if (res.result === 'success') p.IS_AVAILABLE = newVal; }
                    });
                }
            },
            mounted() { this.fnLoad(); }
        }).mount('#app');
    </script>
</body>
</html>