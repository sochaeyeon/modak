<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리 - 모닥모닥 Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-products.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>
<%@ include file="/WEB-INF/admin/admin-sidebar.jsp" %>

<!-- 숨겨진 파일 인풋 -->
<input type="file" id="mainImgInput"   accept="image/*"          style="display:none">
<input type="file" id="descImgInput"   accept="image/*"          style="display:none">
<input type="file" id="detailImgInput" accept="image/*" multiple style="display:none">

<div id="app" class="admin-main" v-cloak>
<div class="prod-page-container">

    <!-- ── 페이지 헤더 ── -->
    <div class="prod-page-header">
        <div class="prod-title-wrap">
            <div class="prod-title-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
            </div>
            <div>
                <div class="prod-page-title">캠핑 장비 마스터 리스트</div>
                <div class="prod-page-subtitle">상품 등록·수정·옵션·재고를 한 곳에서 관리합니다</div>
            </div>
        </div>
        <button class="prod-add-btn" @click="fnOpenAdd">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            새 상품 등록
        </button>
    </div>

    <!-- ── 검색 바 ── -->
    <div class="prod-search-bar">
        <div class="prod-search-input-wrap">
            <svg class="prod-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input class="prod-search-input" v-model="keyword" placeholder="상품명으로 검색..." @keyup.enter="fnSearch">
            <button class="prod-search-clear" v-if="keyword" @click="keyword=''; fnSearch()">✕</button>
        </div>
        <div class="prod-type-tabs">
            <button class="prod-type-tab" :class="{active: typeFilter === ''}"         @click="typeFilter=''; fnSearch()">전체</button>
            <button class="prod-type-tab" :class="{active: typeFilter === 'RENTAL'}"   @click="typeFilter='RENTAL'; fnSearch()">대여 전용</button>
            <button class="prod-type-tab" :class="{active: typeFilter === 'PURCHASE'}" @click="typeFilter='PURCHASE'; fnSearch()">판매 전용</button>
        </div>
        <button class="prod-search-btn" @click="fnSearch">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            조회
        </button>
    </div>

    <!-- ── 리스트 카드 ── -->
    <div class="prod-list-card">
        <!-- 페이지 컨트롤 -->
        <div class="prod-page-ctrl">
            <div class="prod-page-info">
                총 <span class="prod-count-hi">{{ totalCount.toLocaleString() }}</span>개
                <span class="prod-count-muted">· {{ page }} / {{ Math.ceil(totalCount / pageSize) || 1 }} 페이지</span>
            </div>
            <div class="prod-page-btns">
                <button class="ppg-btn" :disabled="page === 1" @click="fnPrevPage">&#8249; 이전</button>
                <button class="ppg-btn" :disabled="page >= Math.ceil(totalCount / pageSize)" @click="fnNextPage">다음 &#8250;</button>
            </div>
        </div>

        <table class="prod-table">
            <thead>
                <tr>
                    <th style="width:70px">ID</th>
                    <th style="width:90px">이미지</th>
                    <th class="t-left">상품명 / 브랜드</th>
                    <th style="width:90px">구분</th>
                    <th style="width:110px">가격</th>
                    <th style="width:80px">조회수</th>
                    <th style="width:170px">관리</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="list.length === 0">
                    <td colspan="7" class="prod-empty-row">
                        <div class="prod-empty-icon">⛺</div>
                        <div>등록된 상품이 없습니다.</div>
                    </td>
                </tr>
                <tr class="prod-row" v-for="p in list" :key="p.PRODUCT_ID">
                    <td><span class="prod-id-badge">#{{ p.PRODUCT_ID }}</span></td>
                    <td>
                        <div class="prod-img-box">
                            <img v-if="p.IMG_URL" :src="p.IMG_URL" @error="imgError">
                            <span v-else class="prod-img-placeholder">🏕️</span>
                        </div>
                    </td>
                    <td class="prod-name-td">
                        <div class="prod-name">{{ p.PRODUCT_NAME }}</div>
                        <div class="prod-brand" v-if="p.BRAND_NAME">{{ p.BRAND_NAME }}</div>
                    </td>
                    <td>
                        <span class="prod-type-badge" :class="p.PRODUCT_TYPE === 'RENTAL' ? 'badge-rental' : 'badge-purchase'">
                            {{ p.PRODUCT_TYPE === 'RENTAL' ? '대여' : '구매' }}
                        </span>
                    </td>
                    <td class="prod-price">{{ Number(p.PRICE).toLocaleString() }}원</td>
                    <td class="prod-views">
                        <span class="prod-views-num">{{ (p.VIEW_COUNT || 0).toLocaleString() }}</span>
                    </td>
                    <td>
                        <div class="prod-action-pair">
                            <button class="prod-action-btn act-edit"   @click="fnOpenEdit(p)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                수정
                            </button>
                            <button class="prod-action-btn act-del"    @click="fnRemove(p)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
                                삭제
                            </button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

</div><!-- prod-page-container -->

<!-- ════════════════════════════════
     상품 등록/수정 모달
════════════════════════════════ -->
<transition name="prod-modal-fade">
<div class="prod-modal-overlay" v-if="modalOpen" @click.self="modalOpen=false">
    <div class="prod-modal">
        <!-- 모달 헤더 -->
        <div class="prod-modal-header">
            <div class="prod-modal-title-wrap">
                <div class="prod-modal-icon">{{ isEdit ? '🛠️' : '📦' }}</div>
                <div>
                    <div class="prod-modal-title">{{ isEdit ? '상품 정보 수정' : '신규 장비 등록' }}</div>
                    <div class="prod-modal-subtitle" v-if="isEdit && form.productName">{{ form.productName }}</div>
                    <div class="prod-modal-subtitle" v-else>기본 정보를 입력하고 탭을 전환해 이미지·옵션·재고를 관리하세요</div>
                </div>
            </div>
            <button class="prod-modal-close" @click="modalOpen=false">✕</button>
        </div>

        <!-- 탭 바 -->
        <div class="prod-tab-bar">
            <button class="prod-tab" :class="{active: activeTab==='basic'}"      @click="activeTab='basic'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93l-1.41 1.41M5.34 18.66l-1.41 1.41M2 12h2M20 12h2M19.07 19.07l-1.41-1.41M5.34 5.34L3.93 3.93M12 2v2M12 20v2"/></svg>
                기본 정보
            </button>
            <button class="prod-tab" :class="{active: activeTab==='images'}"     @click="activeTab='images'">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                상세 이미지
            </button>
            <button class="prod-tab" :class="{active: activeTab==='options'}"    @click="activeTab='options'" v-if="isEdit">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                옵션 관리
            </button>
            <button class="prod-tab" :class="{active: activeTab==='stock'}"      @click="activeTab='stock'"   v-if="isEdit">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-4 0v2M8 7V5a2 2 0 0 0-4 0v2"/></svg>
                재고 관리
            </button>
        </div>

        <!-- ══ TAB: 기본 정보 ══ -->
        <div class="prod-tab-body" v-show="activeTab === 'basic'">

            <div class="pm-section-label">메인 이미지</div>
            <div class="pm-img-section">
                <div class="main-img-preview" @click="fnTriggerMainImg">
                    <img v-if="mainImgPreview" :src="mainImgPreview">
                    <span v-else class="pm-img-placeholder">🏕️</span>
                    <div class="main-img-overlay">
                        <span>📷</span>
                        <span>클릭하여 변경</span>
                    </div>
                </div>
                <div class="pm-img-meta">
                    <div class="pm-img-hint">권장: 800×800px 이상 / JPG, PNG, WEBP</div>
                    <button class="pm-upload-btn" @click="fnTriggerMainImg" :disabled="mainImgUploading">
                        <span v-if="mainImgUploading"><span class="upload-spinner"></span> 업로드 중...</span>
                        <span v-else>📁 이미지 선택</span>
                    </button>
                    <div class="pm-img-url" v-if="form.imgUrl">{{ form.imgUrl }}</div>
                </div>
            </div>

            <div class="pm-section-label">기본 정보</div>
            <div class="pm-form-group pm-grid-3-1-1">
                <div class="pm-field">
                    <label class="pm-label">상품명 <span class="pm-req">*</span></label>
                    <input class="pm-input" v-model="form.productName" placeholder="상품명을 입력하세요">
                </div>
                <div class="pm-field">
                    <label class="pm-label">카테고리</label>
                    <select class="pm-input" v-model="form.categoryId">
                        <option value="1">텐트/타프</option>
                        <option value="2">침낭/매트</option>
                        <option value="3">테이블/의자</option>
                        <option value="4">조명/랜턴</option>
                        <option value="5">취사도구</option>
                    </select>
                </div>
                <div class="pm-field">
                    <label class="pm-label">브랜드 <span class="pm-req">*</span></label>
                    <select class="pm-input" v-model="form.brandId">
                        <option value="">브랜드 선택</option>
                        <option v-for="b in brandList" :key="b.brandId" :value="b.brandId">{{ b.brandName }}</option>
                    </select>
                </div>
            </div>
            <div class="pm-form-group pm-grid-3">
                <div class="pm-field">
                    <label class="pm-label">유형</label>
                    <select class="pm-input" v-model="form.productType">
                        <option value="RENTAL">대여</option>
                        <option value="PURCHASE">판매</option>
                    </select>
                </div>
                <div class="pm-field">
                    <label class="pm-label">가격 (원)</label>
                    <input class="pm-input" type="number" v-model.number="form.price" placeholder="0">
                </div>
                <div class="pm-field">
                    <label class="pm-label">보증금 (원)</label>
                    <input class="pm-input" type="number" v-model.number="form.deposit" placeholder="0">
                </div>
            </div>

            <div class="pm-section-label">상세 설명 이미지</div>
            <div class="pm-desc-section">
                <div class="pm-desc-preview" @click="fnTriggerDescImg">
                    <img v-if="descImgPreview" :src="descImgPreview">
                    <span v-else class="pm-img-placeholder">🖼️</span>
                    <div class="main-img-overlay"><span>📷</span><span>변경</span></div>
                </div>
                <div class="pm-img-meta">
                    <div class="pm-img-hint">상품 상세 페이지에 표시되는 설명 이미지입니다.</div>
                    <div class="pm-desc-btn-row">
                        <button class="pm-upload-btn" @click="fnTriggerDescImg" :disabled="descImgUploading">
                            <span v-if="descImgUploading"><span class="upload-spinner"></span> 업로드 중...</span>
                            <span v-else>📁 이미지 선택</span>
                        </button>
                        <button v-if="form.description" class="pm-del-sm-btn" @click="form.description=''; descImgPreview=''">삭제</button>
                    </div>
                    <div class="pm-img-url" v-if="form.description">{{ form.description }}</div>
                </div>
            </div>

            <div class="pm-section-label">상세 사양 (Spec)</div>
            <div class="pm-form-group pm-grid-3">
                <div class="pm-field"><label class="pm-label">용량/인원</label><input class="pm-input" v-model="form.capacity" placeholder="예: 3~4인용"></div>
                <div class="pm-field"><label class="pm-label">사이즈</label><input class="pm-input" v-model="form.size" placeholder="예: 300×250×180cm"></div>
                <div class="pm-field"><label class="pm-label">무게</label><input class="pm-input" v-model="form.weight" placeholder="예: 5.2kg"></div>
                <div class="pm-field"><label class="pm-label">재질</label><input class="pm-input" v-model="form.material" placeholder="예: 폴리에스터 210D"></div>
                <div class="pm-field"><label class="pm-label">원산지</label><input class="pm-input" v-model="form.origin" placeholder="예: Made in Korea"></div>
            </div>

            <div class="pm-section-label">제품 특징 (Feature)</div>
            <div class="pm-form-group pm-grid-1-2">
                <div class="pm-field"><label class="pm-label">특징 제목</label><input class="pm-input" v-model="form.featureTitle" placeholder="예: 올시즌 사용 가능"></div>
                <div class="pm-field"><label class="pm-label">상세 특징 설명</label><input class="pm-input" v-model="form.featureContent" placeholder="특징을 자세히 설명해주세요"></div>
            </div>

            <div class="pm-footer">
                <button class="pm-cancel-btn" @click="modalOpen=false">취소</button>
                <button class="pm-save-btn" @click="fnSave" :disabled="isSaving">
                    <span v-if="isSaving"><span class="upload-spinner"></span> 저장 중...</span>
                    <span v-else>💾 정보 저장</span>
                </button>
            </div>
        </div>

        <!-- ══ TAB: 상세 이미지 ══ -->
        <div class="prod-tab-body" v-show="activeTab === 'images'">
            <div class="pm-section-label">상세 이미지 업로드</div>
            <p class="pm-hint-text">상품 상세 페이지에 표시될 이미지입니다. 여러 장 동시 업로드가 가능합니다.</p>

            <div class="img-upload-area" :class="{'drag-over': isDragOver}"
                 @dragover.prevent="isDragOver=true" @dragleave="isDragOver=false"
                 @drop.prevent="fnDropDetailImg" @click="fnTriggerDetailImg">
                <div class="img-upload-icon">🖼️</div>
                <div class="img-upload-title">이미지를 드래그하거나 클릭하여 업로드</div>
                <div class="img-upload-sub">JPG · PNG · WEBP · 여러 장 동시 업로드 가능</div>
                <div v-if="detailImgUploading" class="img-upload-progress">
                    <span class="upload-spinner"></span>
                    <span>업로드 중...</span>
                </div>
            </div>

            <div class="detail-img-grid" v-if="detailImages.length > 0">
                <div v-for="(img, idx) in detailImages" :key="img.imageId || idx" class="detail-img-item">
                    <img :src="img.imgUrl">
                    <button class="detail-img-remove" @click="fnRemoveDetailImg(img, idx)">✕</button>
                </div>
                <div class="detail-img-add" @click="fnTriggerDetailImg">
                    <span class="detail-img-add-plus">+</span>
                    <span class="detail-img-add-lbl">추가</span>
                </div>
            </div>
            <p v-else class="pm-empty-hint">등록된 상세 이미지가 없습니다. 위 영역에 이미지를 드래그하거나 클릭하세요.</p>
        </div>

        <!-- ══ TAB: 옵션 관리 ══ -->
        <div class="prod-tab-body" v-show="activeTab === 'options'">
            <div class="pm-section-label">옵션 그룹</div>
            <p class="pm-hint-text">색상, 사이즈 등 옵션 종류를 추가하고, 각 그룹에 값을 등록하세요.</p>

            <div class="option-section">
                <div class="option-group-card" v-for="group in optionGroups" :key="group.optionGroupId">
                    <div class="option-group-head">
                        <div class="option-group-name-wrap">
                            <span class="option-group-dot"></span>
                            <span class="option-group-name">{{ group.optionName }}</span>
                        </div>
                        <button class="pm-del-sm-btn" @click="fnRemoveOptionGroup(group)">그룹 삭제</button>
                    </div>
                    <div class="option-values-wrap">
                        <div class="option-value-chip" v-for="val in group.values" :key="val.optionValueId">
                            {{ val.optionValue }}
                            <span class="chip-price" v-if="val.addPrice > 0">+{{ Number(val.addPrice).toLocaleString() }}원</span>
                            <button class="chip-del" @click="fnRemoveOptionValue(val, group)">✕</button>
                        </div>
                        <span v-if="!group.values || group.values.length === 0" class="option-no-val">값 없음</span>
                    </div>
                    <div class="option-add-row">
                        <input class="pm-input pm-input-inline" v-model="group._newValue"      placeholder="값 이름 (예: 카키)">
                        <input class="pm-input pm-input-inline" type="number" v-model.number="group._newAddPrice" placeholder="추가 금액">
                        <button class="pm-outline-btn" @click="fnAddOptionValue(group)">+ 값 추가</button>
                    </div>
                </div>

                <div class="option-new-group-row">
                    <input class="pm-input" style="flex:1;margin-bottom:0;" v-model="newGroupName" placeholder="새 옵션 그룹 이름 (예: 색상, 사이즈)">
                    <button class="pm-save-btn" style="white-space:nowrap;" @click="fnAddOptionGroup">+ 그룹 추가</button>
                </div>
            </div>

            <div class="pm-section-label" style="margin-top:24px;">옵션 조합 (구매 가능 아이템)</div>
            <p class="pm-hint-text">실제로 구매/대여 가능한 옵션 조합 목록입니다.</p>
            <div v-if="optionItems.length === 0" class="pm-empty-hint">
                옵션 그룹과 값을 추가하면 조합이 자동 생성됩니다.
            </div>
            <div class="option-items-list">
                <div v-for="item in optionItems" :key="item.optionItemId" class="option-item-row">
                    <div class="option-item-name">{{ item.itemName }}</div>
                    <div class="option-item-price">+{{ Number(item.extraPrice || 0).toLocaleString() }}원</div>
                    <span class="option-item-avail" :class="item.isAvailable === 'Y' ? 'avail-on' : 'avail-off'">
                        {{ item.isAvailable === 'Y' ? '판매중' : '판매중지' }}
                    </span>
                    <button class="pm-outline-btn pm-sm-btn" @click="fnToggleItemAvail(item)">
                        {{ item.isAvailable === 'Y' ? '중지' : '활성' }}
                    </button>
                </div>
            </div>
        </div>

        <!-- ══ TAB: 재고 관리 ══ -->
        <div class="prod-tab-body" v-show="activeTab === 'stock'">
            <div class="pm-section-label">재고 수량 관리</div>

            <div class="stock-section">
                <div v-if="stockList.length === 0" class="pm-empty-hint">등록된 재고 정보가 없습니다.</div>
                <div v-for="(stock, idx) in stockList" :key="idx" class="stock-row">
                    <div class="stock-opt-label">옵션 {{ stock.optionId || '—' }}</div>
                    <div class="stock-fields">
                        <div class="pm-field">
                            <label class="pm-label">전체 수량</label>
                            <input class="pm-input stock-input" type="number" v-model.number="stock.totalQty"    min="0" @change="fnUpdateStock(stock)">
                        </div>
                        <div class="pm-field">
                            <label class="pm-label">예약 수량</label>
                            <input class="pm-input stock-input" type="number" v-model.number="stock.reservedQty" min="0" @change="fnUpdateStock(stock)">
                        </div>
                        <div class="pm-field">
                            <label class="pm-label">가용 수량</label>
                            <input class="pm-input stock-input" type="number" :value="stock.totalQty - stock.reservedQty" readonly class="stock-readonly">
                        </div>
                    </div>
                </div>

                <div class="stock-add-row">
                    <input class="pm-input stock-input" type="number" v-model.number="newStock.totalQty" placeholder="전체 수량" min="0">
                    <input class="pm-input stock-input" type="text"   v-model="newStock.optionId"         placeholder="옵션 ID">
                    <button class="pm-save-btn" style="white-space:nowrap;" @click="fnAddStock">+ 재고 추가</button>
                </div>
            </div>
        </div>

    </div><!-- prod-modal -->
</div><!-- prod-modal-overlay -->
</transition>

<!-- ════════════════════════════════
     확인 모달
════════════════════════════════ -->
<transition name="prod-modal-fade">
    <div class="prod-confirm-overlay" v-if="showConfirmModal" @click.self="fnCancelConfirm">
        <div class="prod-confirm-box">
            <div class="prod-confirm-ico">{{ confirmConfig.icon || '❓' }}</div>
            <div class="prod-confirm-title">{{ confirmConfig.title }}</div>
            <div class="prod-confirm-msg" v-html="confirmConfig.msg"></div>
            <div class="prod-confirm-btns">
                <button class="pm-cancel-btn" @click="fnCancelConfirm">취소</button>
                <button class="pm-save-btn" :class="confirmConfig.danger ? 'pm-danger-btn' : ''" @click="fnRunConfirm">
                    {{ confirmConfig.okLabel || '확인' }}
                </button>
            </div>
        </div>
    </div>
</transition>

<!-- ── 토스트 ── -->
<div class="prod-toast-container">
    <transition-group name="prod-toast-slide">
        <div v-for="t in toasts" :key="t.id" class="prod-toast-item" :class="'prod-toast-' + t.type">
            <div class="prod-toast-icon">{{ t.type === 'success' ? '✅' : t.type === 'error' ? '❌' : 'ℹ️' }}</div>
            <div class="prod-toast-msg">{{ t.message }}</div>
            <button class="prod-toast-close" @click="removeToast(t.id)">✕</button>
            <div class="prod-toast-progress" :style="{animationDuration: (t.duration || 3000) + 'ms'}"></div>
        </div>
    </transition-group>
</div>

</div><!-- #app -->

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                list: [], keyword: '', typeFilter: '', page: 1, pageSize: 20, totalCount: 0,
                modalOpen: false, isEdit: false, activeTab: 'basic',
                brandList: [],
                mainImgPreview: '', mainImgUploading: false,
                descImgPreview: '', descImgUploading: false,
                detailImages: [], detailImgUploading: false, isDragOver: false,
                optionGroups: [], optionItems: [], newGroupName: '',
                stockList: [], newStock: { totalQty: 0, optionId: '' },
                isSaving: false,
                showConfirmModal: false,
                confirmConfig: { icon: '', title: '', msg: '', okLabel: '', danger: false, resolve: null },
                toasts: [],
                form: {
                    productId: '', productName: '', categoryId: 1, productType: 'RENTAL',
                    price: 0, deposit: 0, description: '', imgUrl: '',
                    capacity: '', size: '', weight: '', material: '', origin: '',
                    featureTitle: '', featureContent: '', brandId: ''
                }
            };
        },

        methods: {
            /* ── 토스트 ── */
            toast(msg, type = 'success', duration = 3000) {
                const id = Date.now() + Math.random();
                this.toasts.push({ id, message: msg, type, duration });
                setTimeout(() => this.removeToast(id), duration);
            },
            removeToast(id) { this.toasts = this.toasts.filter(t => t.id !== id); },

            /* ── 확인 모달 (Promise 기반) ── */
            showConfirm(cfg) {
                return new Promise(resolve => {
                    this.confirmConfig = { ...cfg, resolve };
                    this.showConfirmModal = true;
                });
            },
            fnRunConfirm()    { this.showConfirmModal = false; if (this.confirmConfig.resolve) this.confirmConfig.resolve(true); },
            fnCancelConfirm() { this.showConfirmModal = false; if (this.confirmConfig.resolve) this.confirmConfig.resolve(false); },

            /* ══ 상품 목록 ══ */
            fnLoad() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/product/list.dox',
                    type: 'POST',
                    data: { keyword: this.keyword, productType: this.typeFilter, offset: (this.page - 1) * this.pageSize, pageSize: this.pageSize },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.list = data.list; this.totalCount = data.totalCount || 0; }
                    },
                    error: () => this.toast('상품 목록을 불러오지 못했습니다.', 'error')
                });
            },
            fnSearch()   { this.page = 1; this.fnLoad(); },
            fnNextPage() { this.page++; this.fnLoad(); },
            fnPrevPage() { this.page--; this.fnLoad(); },
            fnLoadBrands() {
                $.ajax({
                    url: '/admin/brand/list.dox', type: 'POST',
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') this.brandList = data.list || [];
                    }
                });
            },

            /* ══ 모달 열기 ══ */
            fnOpenAdd() {
                this.isEdit = false; this.activeTab = 'basic';
                this.form = { productId: '', productName: '', categoryId: 1, productType: 'RENTAL', price: 0, deposit: 0, description: '', imgUrl: '', capacity: '', size: '', weight: '', material: '', origin: '', featureTitle: '', featureContent: '', brandId: '' };
                this.mainImgPreview = ''; this.descImgPreview = '';
                this.detailImages = []; this.stockList = []; this.optionGroups = []; this.optionItems = [];
                this.newStock = { totalQty: 0, optionId: '' };
                this.modalOpen = true;
            },
            fnOpenEdit(p) {
                this.isEdit = true; this.activeTab = 'basic';
                this.form = {
                    productId: p.PRODUCT_ID, productName: p.PRODUCT_NAME, categoryId: p.CATEGORY_ID || 1,
                    productType: p.PRODUCT_TYPE, price: p.PRICE, deposit: p.DEPOSIT, description: p.DESCRIPTION,
                    imgUrl: p.IMG_URL || '', capacity: p.CAPACITY || '', size: p.SIZE || '', weight: p.WEIGHT || '',
                    material: p.MATERIAL || '', origin: p.ORIGIN || '',
                    featureTitle: p.FEATURE_TITLE || '', featureContent: p.FEATURE_CONTENT || '', brandId: p.BRAND_ID || ''
                };
                this.mainImgPreview = p.IMG_URL || '';
                this.descImgPreview = p.DESCRIPTION || '';
                this.detailImages = []; this.stockList = []; this.optionGroups = []; this.optionItems = [];
                this.modalOpen = true;
                this.fnLoadDetailImages(p.PRODUCT_ID);
                this.fnLoadStock(p.PRODUCT_ID);
                this.fnLoadOptions(p.PRODUCT_ID);
            },

            /* ══ 기본 정보 저장 ══ */
            fnSave() {
                if (!this.form.productName) { this.toast('상품명을 입력하세요.', 'error'); return; }
                if (!this.form.brandId)     { this.toast('브랜드를 선택하세요.', 'error'); return; }
                this.isSaving = true;
                const url = this.isEdit ? '/admin/product/update.dox' : '/admin/product/insertFull.dox';
                $.ajax({
                    url: '${pageContext.request.contextPath}' + url,
                    type: 'POST', data: this.form,
                    success: (res) => {
                        this.isSaving = false;
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') {
                            this.toast(this.isEdit ? '상품 정보가 수정되었습니다.' : '새 상품이 등록되었습니다.', 'success');
                            this.modalOpen = false; this.fnLoad();
                        } else { this.toast('오류: ' + (data.message || '저장 실패'), 'error'); }
                    },
                    error: () => { this.isSaving = false; this.toast('서버 오류가 발생했습니다.', 'error'); }
                });
            },

            /* ══ 상품 삭제 ══ */
            async fnRemove(p) {
                const ok = await this.showConfirm({
                    icon: '🗑️', title: '상품 삭제', danger: true,
                    msg: `<b>${p.PRODUCT_NAME}</b>를 삭제하시겠습니까?<br>관련 이미지·옵션·재고 데이터가 모두 삭제됩니다.`,
                    okLabel: '삭제'
                });
                if (!ok) return;
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/product/remove.dox',
                    type: 'POST', data: { productId: p.PRODUCT_ID },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.toast('상품이 삭제되었습니다.', 'success'); this.fnLoad(); }
                        else this.toast('삭제 실패: ' + (data.message || '오류'), 'error');
                    },
                    error: () => this.toast('서버 오류가 발생했습니다.', 'error')
                });
            },

            /* ══ 메인 이미지 ══ */
            fnTriggerMainImg() { document.getElementById('mainImgInput').click(); },
            fnUploadMainImg(file) {
                if (!file) return;
                this.mainImgUploading = true;
                const fd = new FormData(); fd.append('file', file); fd.append('type', 'main');
                $.ajax({
                    url: '/admin/product/upload-img.dox', type: 'POST', data: fd, processData: false, contentType: false,
                    success: (res) => {
                        this.mainImgUploading = false;
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.form.imgUrl = data.imgUrl; this.mainImgPreview = data.imgUrl; }
                        else this.toast('이미지 업로드 실패: ' + data.message, 'error');
                    },
                    error: () => { this.mainImgUploading = false; this.toast('이미지 업로드 오류', 'error'); }
                });
            },

            /* ══ 상세 설명 이미지 ══ */
            fnTriggerDescImg() { document.getElementById('descImgInput').click(); },
            fnUploadDescImg(file) {
                if (!file) return;
                this.descImgUploading = true;
                const fd = new FormData(); fd.append('file', file); fd.append('type', 'desc');
                $.ajax({
                    url: '/admin/product/upload-img.dox', type: 'POST', data: fd, processData: false, contentType: false,
                    success: (res) => {
                        this.descImgUploading = false;
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.form.description = data.imgUrl; this.descImgPreview = data.imgUrl; }
                        else this.toast('업로드 실패: ' + data.message, 'error');
                    },
                    error: () => { this.descImgUploading = false; this.toast('업로드 오류', 'error'); }
                });
            },

            /* ══ 상세 이미지 ══ */
            fnTriggerDetailImg() { document.getElementById('detailImgInput').click(); },
            fnLoadDetailImages(productId) {
                $.ajax({
                    url: '/admin/product/detail-images.dox', type: 'POST', data: { productId },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') this.detailImages = data.list || [];
                    }
                });
            },
            fnUploadDetailImgs(files) {
                if (!files || files.length === 0) return;
                if (!this.form.productId && !this.isEdit) { this.toast('상품을 먼저 저장한 뒤 상세 이미지를 업로드해주세요.', 'error'); return; }
                this.detailImgUploading = true;
                const fd = new FormData();
                Array.from(files).forEach(f => fd.append('files', f));
                fd.append('productId', this.form.productId); fd.append('type', 'detail');
                $.ajax({
                    url: '/admin/product/upload-detail-imgs.dox', type: 'POST', data: fd, processData: false, contentType: false,
                    success: (res) => {
                        this.detailImgUploading = false;
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') this.fnLoadDetailImages(this.form.productId);
                        else this.toast('업로드 실패: ' + data.message, 'error');
                    },
                    error: () => { this.detailImgUploading = false; this.toast('업로드 오류', 'error'); }
                });
            },
            fnDropDetailImg(e) { this.isDragOver = false; this.fnUploadDetailImgs(e.dataTransfer.files); },
            async fnRemoveDetailImg(img, idx) {
                const ok = await this.showConfirm({ icon: '🗑️', title: '이미지 삭제', msg: '이 이미지를 삭제하시겠습니까?', okLabel: '삭제', danger: true });
                if (!ok) return;
                if (img.imageId) {
                    $.ajax({
                        url: '/admin/product/detail-image/remove.dox', type: 'POST', data: { imageId: img.imageId },
                        success: (res) => {
                            const data = typeof res === 'string' ? JSON.parse(res) : res;
                            if (data.result === 'success') { this.detailImages.splice(idx, 1); this.toast('이미지가 삭제되었습니다.', 'success'); }
                        },
                        error: () => this.toast('삭제 오류', 'error')
                    });
                } else { this.detailImages.splice(idx, 1); }
            },

            /* ══ 옵션 관리 ══ */
            fnLoadOptions(productId) {
                $.ajax({
                    url: '/admin/product/option/list.dox', type: 'POST', data: { productId },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') {
                            this.optionGroups = (data.groups || []).map(g => ({ ...g, _newValue: '', _newAddPrice: 0 }));
                            this.optionItems = data.items || [];
                        }
                    }
                });
            },
            fnAddOptionGroup() {
                if (!this.newGroupName.trim()) { this.toast('그룹 이름을 입력하세요.', 'error'); return; }
                $.ajax({
                    url: '/admin/product/option/group/add.dox', type: 'POST',
                    data: { productId: this.form.productId, optionName: this.newGroupName.trim() },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.newGroupName = ''; this.fnLoadOptions(this.form.productId); this.toast('옵션 그룹이 추가되었습니다.', 'success'); }
                        else this.toast(data.message || '추가 실패', 'error');
                    }
                });
            },
            async fnRemoveOptionGroup(group) {
                const ok = await this.showConfirm({ icon: '🗑️', title: '옵션 그룹 삭제', danger: true, msg: `<b>${group.optionName}</b> 그룹과 모든 값을 삭제하시겠습니까?`, okLabel: '삭제' });
                if (!ok) return;
                $.ajax({
                    url: '/admin/product/option/group/remove.dox', type: 'POST', data: { optionGroupId: group.optionGroupId },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.fnLoadOptions(this.form.productId); this.toast('옵션 그룹이 삭제되었습니다.', 'success'); }
                    },
                    error: () => this.toast('삭제 오류', 'error')
                });
            },
            fnAddOptionValue(group) {
                if (!group._newValue.trim()) { this.toast('값 이름을 입력하세요.', 'error'); return; }
                $.ajax({
                    url: '/admin/product/option/value/add.dox', type: 'POST',
                    data: { optionGroupId: group.optionGroupId, optionValue: group._newValue.trim(), addPrice: group._newAddPrice || 0 },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { group._newValue = ''; group._newAddPrice = 0; this.fnLoadOptions(this.form.productId); }
                        else this.toast(data.message || '추가 실패', 'error');
                    }
                });
            },
            fnRemoveOptionValue(val, group) {
                $.ajax({
                    url: '/admin/product/option/value/remove.dox', type: 'POST', data: { optionValueId: val.optionValueId },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') this.fnLoadOptions(this.form.productId);
                    }
                });
            },
            fnToggleItemAvail(item) {
                const newVal = item.isAvailable === 'Y' ? 'N' : 'Y';
                $.ajax({
                    url: '/admin/product/option/item/avail.dox', type: 'POST', data: { optionItemId: item.optionItemId, isAvailable: newVal },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { item.isAvailable = newVal; this.toast(newVal === 'Y' ? '판매 활성화' : '판매 중지', 'success'); }
                    }
                });
            },

            /* ══ 재고 관리 ══ */
            fnLoadStock(productId) {
                $.ajax({
                    url: '/admin/product/stock/list.dox', type: 'POST', data: { productId },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') this.stockList = data.list || [];
                    }
                });
            },
            fnUpdateStock(stock) {
                stock.availableQty = stock.totalQty - stock.reservedQty;
                $.ajax({
                    url: '/admin/product/stock/update.dox', type: 'POST',
                    data: { stockId: stock.stockId, totalQty: stock.totalQty, reservedQty: stock.reservedQty, availableQty: stock.availableQty },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result !== 'success') this.toast('재고 수정 실패', 'error');
                    }
                });
            },
            fnAddStock() {
                if (!this.form.productId) { this.toast('상품을 먼저 저장하세요.', 'error'); return; }
                $.ajax({
                    url: '/admin/product/stock/add.dox', type: 'POST',
                    data: { productId: this.form.productId, optionId: this.newStock.optionId || '', totalQty: this.newStock.totalQty, reservedQty: 0, availableQty: this.newStock.totalQty },
                    success: (res) => {
                        const data = typeof res === 'string' ? JSON.parse(res) : res;
                        if (data.result === 'success') { this.fnLoadStock(this.form.productId); this.newStock = { totalQty: 0, optionId: '' }; this.toast('재고가 추가되었습니다.', 'success'); }
                    }
                });
            },

            imgError(e) { e.target.src = '/img/no-image.png'; }
        },

        mounted() {
            this.fnLoad();
            this.fnLoadBrands();
            document.getElementById('mainImgInput').addEventListener('change', (e) => {
                const file = e.target.files[0]; if (file) this.fnUploadMainImg(file); e.target.value = '';
            });
            document.getElementById('detailImgInput').addEventListener('change', (e) => {
                this.fnUploadDetailImgs(e.target.files); e.target.value = '';
            });
            document.getElementById('descImgInput').addEventListener('change', (e) => {
                const file = e.target.files[0]; if (file) this.fnUploadDescImg(file); e.target.value = '';
            });
        }
    }).mount('#app');
</script>
</body>
</html>
