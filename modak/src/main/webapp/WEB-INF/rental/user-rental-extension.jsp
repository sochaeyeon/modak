<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대여 연장 신청</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
	<link rel="stylesheet" href="/css/common/font.css">
    <link rel="stylesheet" href="/css/rental/user-rental-extension.css">
</head>
<body>
    <%@ include file="/WEB-INF/common/header.jsp" %>

    <div id="app">
        <div class="rental-extension-page">
            <div class="rental-extension-wrap">

                <!-- 상단 헤더 -->
                <div class="page-hero">
                    <div>
                        <div class="page-eyebrow">RENTAL EXTENSION</div>
                        <h2 class="page-title">대여 연장 신청</h2>
                        <p class="page-desc">
                            현재 대여 중인 상품의 반납일을 연장할 수 있어요.<br>
                            상품 상태와 예약 상황에 따라 연장이 제한될 수 있습니다.
                        </p>
                    </div>

                    <div class="hero-summary-group">
                        <div class="hero-summary-card">
                            <div class="hero-summary-label">연장 가능 상품</div>
                            <div class="hero-summary-value">
                                <transition name="count-rise" mode="out-in">
                                    <span class="result-count-number" :key="extendableCount">{{ extendableCount }}</span>
                                </transition>
                                <span class="result-count-unit">건</span>
                            </div>
                        </div>

                        <div class="hero-summary-card total-card">
                            <div class="hero-summary-label">예상 추가금액</div>
                            <div class="hero-summary-value amount-value">
                                {{ Number(totalExtensionAmount || 0).toLocaleString() }}
                                <span class="result-count-unit">원</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 안내 카드 -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-head-left">
                            <h3>연장 안내</h3>
                            <p class="recent-guide-text">
                                연장 신청은 상품별 재고 및 다음 예약 일정에 따라 승인 여부가 달라질 수 있습니다.
                            </p>
                        </div>
                    </div>

                    <div class="guide-content">
                        <div class="guide-chip-wrap">
                            <span class="guide-chip">기본 1일 단위 연장</span>
                            <span class="guide-chip">최대 7일 연장</span>
                            <span class="guide-chip">예약 충돌 시 신청 불가</span>
                            <span class="guide-chip">추가 요금 즉시 확인</span>
                        </div>
                    </div>
                </div>

                <!-- 대여 연장 신청 리스트 -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-head-left">
                            <h3>연장 신청 가능 목록</h3>
                            <p class="recent-guide-text">
                                연장할 상품을 선택하고 기간을 설정해 주세요.
                            </p>
                        </div>
                    </div>

                    <transition name="list-rise" mode="out-in">
                        <div class="rental-content" :key="'extend-' + listAnimateKey">
                            <div v-if="rentalList.length === 0" class="empty-state">
                                <p>
                                    현재 연장 신청 가능한 대여 상품이 없습니다.<br>
                                    배송 상태 또는 다음 예약 일정을 확인해 주세요.
                                </p>
                            </div>

                            <div v-else class="rental-grid">
                                <div class="rental-item" v-for="item in rentalList" :key="item.rentalOrderId">

                                    <div class="rental-thumb" @click="fnGoProductDetail(item.productId)">
                                        <img :src="item.imgUrl" v-if="item.imgUrl"
                                            style="width:100%; height:100%; object-fit:cover;">
                                        <span v-else>🏕️</span>
                                    </div>

                                    <div class="rental-body">
                                        <div class="rental-top-row">
                                            <span class="status-badge" :class="item.extendableYn === 'Y' ? 'available' : 'disabled'">
                                                {{ item.extendableYn === 'Y' ? '연장 가능' : '연장 불가' }}
                                            </span>
                                            <span class="rental-order-no">주문번호 {{ item.rentalOrderId }}</span>
                                        </div>

                                        <div class="rental-name" @click="fnGoProductDetail(item.productId)">
                                            {{ item.productName }}
                                        </div>

                                        <div class="rental-info-box">
                                            <div class="info-row">
                                                <span class="info-label">대여기간</span>
                                                <span class="info-value">
                                                    {{ fnFormatDate(item.rentalStartDate) }} ~ {{ fnFormatDate(item.rentalEndDate) }}
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">현재 반납 예정일</span>
                                                <span class="info-value highlight">{{ fnFormatDate(item.returnDueDate) }}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">1일 연장 금액</span>
                                                <span class="info-value">{{ Number(item.dailyExtensionPrice || 0).toLocaleString() }}원</span>
                                            </div>
                                        </div>

                                        <div class="extension-control" v-if="item.extendableYn === 'Y'">
                                            <div class="control-label">연장일수 선택</div>

                                            <div class="day-selector">
                                                <button type="button" class="day-btn"
                                                    @click="fnChangeExtensionDay(item, -1)">
                                                    -
                                                </button>

                                                <div class="day-value">{{ item.extensionDays }}일</div>

                                                <button type="button" class="day-btn"
                                                    @click="fnChangeExtensionDay(item, 1)">
                                                    +
                                                </button>
                                            </div>

                                            <div class="extension-preview">
                                                <div class="preview-row">
                                                    <span>연장 후 반납일</span>
                                                    <strong>{{ fnCalcExtendedDate(item.returnDueDate, item.extensionDays) }}</strong>
                                                </div>
                                                <div class="preview-row">
                                                    <span>예상 추가금액</span>
                                                    <strong class="amount-text">
                                                        {{ Number((item.dailyExtensionPrice || 0) * (item.extensionDays || 0)).toLocaleString() }}원
                                                    </strong>
                                                </div>
                                            </div>

                                            <div class="rental-action-row">
                                                <button type="button" class="outline-btn"
                                                    @click="fnGoProductDetail(item.productId)">
                                                    상품 보기
                                                </button>

                                                <button type="button" class="primary-btn"
                                                    @click="fnApplyExtension(item)">
                                                    연장 신청
                                                </button>
                                            </div>
                                        </div>

                                        <div class="disabled-message" v-else>
                                            {{ item.blockReason || '다음 예약 또는 재고 일정으로 인해 연장 신청이 어렵습니다.' }}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 페이지네이션 -->
                            <div v-if="totalPages > 1" class="pagination-wrap">
                                <button class="page-btn" :disabled="page === 1" @click="fnChangePage(page - 1)">
                                    이전
                                </button>

                                <button v-for="num in totalPages"
                                    :key="num"
                                    class="page-btn"
                                    :class="{ active: page === num }"
                                    @click="fnChangePage(num)">
                                    {{ num }}
                                </button>

                                <button class="page-btn" :disabled="page === totalPages" @click="fnChangePage(page + 1)">
                                    다음
                                </button>
                            </div>
                        </div>
                    </transition>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/common/footer.jsp" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    rentalList: [],
                    page: 1,
                    pageSize: 6,
                    totalCount: 0,
                    totalPages: 1,
                    listAnimateKey: 0
                };
            },
            computed: {
                extendableCount() {
                    return this.rentalList.filter(item => item.extendableYn === "Y").length;
                },
                totalExtensionAmount() {
                    return this.rentalList.reduce((sum, item) => {
                        if (item.extendableYn !== "Y") {
                            return sum;
                        }
                        return sum + ((item.dailyExtensionPrice || 0) * (item.extensionDays || 0));
                    }, 0);
                }
            },
            methods: {
                fnGetRentalExtensionList: function(moveTop = false) {
                    let self = this;

                    $.ajax({
                        url: "/rental/extension/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            page: self.page,
                            pageSize: self.pageSize
                        },
                        success: function(data) {
                            if (data.result === "success") {
                                self.rentalList = (data.list || []).map(item => {
                                    item.extensionDays = item.extensionDays || 1;
                                    return item;
                                });

                                self.totalCount = data.totalCount || 0;
                                self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;
                                self.listAnimateKey++;

                                if (moveTop) {
                                    window.scrollTo({
                                        top: 0,
                                        behavior: "smooth"
                                    });
                                }
                            } else {
                                self.rentalList = [];
                                self.totalCount = 0;
                                self.totalPages = 1;
                            }
                        },
                        error: function() {
                            self.rentalList = [];
                            self.totalCount = 0;
                            self.totalPages = 1;
                        }
                    });
                },

                fnChangePage: function(num) {
                    if (num < 1 || num > this.totalPages || num === this.page) {
                        return;
                    }

                    this.page = num;
                    this.fnGetRentalExtensionList(true);
                },

                fnChangeExtensionDay: function(item, diff) {
                    let next = (item.extensionDays || 1) + diff;

                    if (next < 1) {
                        next = 1;
                    }

                    if (next > 7) {
                        next = 7;
                    }

                    item.extensionDays = next;
                },

                fnApplyExtension: function(item) {
                    let self = this;

                    if (item.extendableYn !== "Y") {
                        alert("해당 상품은 현재 연장 신청이 불가능합니다.");
                        return;
                    }

                    if (!confirm("선택한 기간으로 대여 연장을 신청하시겠습니까?")) {
                        return;
                    }

                    $.ajax({
                        url: "/rental/extension/apply.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            rentalOrderId: item.rentalOrderId,
                            extensionDays: item.extensionDays
                        },
                        success: function(data) {
                            if (data.result === "success") {
                                alert("대여 연장 신청이 완료되었습니다.");
                                self.fnGetRentalExtensionList();
                            } else {
                                alert(data.message || "연장 신청 중 문제가 발생했습니다.");
                            }
                        },
                        error: function() {
                            alert("연장 신청 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnGoProductDetail: function(productId) {
                    pageChange("/product/detail.do", { productId: productId });
                },

                fnFormatDate: function(value) {
                    if (!value) {
                        return "-";
                    }

                    const normalized = String(value).replace(" ", "T");
                    const date = new Date(normalized);

                    if (isNaN(date.getTime())) {
                        return value;
                    }

                    const y = date.getFullYear();
                    const m = String(date.getMonth() + 1).padStart(2, "0");
                    const d = String(date.getDate()).padStart(2, "0");

                    return y + "." + m + "." + d;
                },

                fnCalcExtendedDate: function(dateValue, days) {
                    if (!dateValue) {
                        return "-";
                    }

                    const normalized = String(dateValue).replace(" ", "T");
                    const date = new Date(normalized);

                    if (isNaN(date.getTime())) {
                        return dateValue;
                    }

                    date.setDate(date.getDate() + Number(days || 0));

                    const y = date.getFullYear();
                    const m = String(date.getMonth() + 1).padStart(2, "0");
                    const d = String(date.getDate()).padStart(2, "0");

                    return y + "." + m + "." + d;
                }
            },
            mounted() {
                this.fnGetRentalExtensionList();
            }
        });

        app.mount("#app");
    </script>
</body>
</html>