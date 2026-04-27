<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>내 주문 - 모닥모닥</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <link rel="stylesheet" href="/css/order/order-history.css">
            <script src="/js/page-change.js"></script>

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="order-history-wrap">
                        <div class="page-hero">
                            <div class="hero-left">
                                <div class="page-eyebrow">MY SHOPPING</div>
                                <h2 class="page-title">주문 전체보기</h2>
                                <p class="page-desc">주문 내역을 날짜별로 확인하고, 기간별로 필터링할 수 있어요.</p>
                            </div>
                            <div class="hero-summary-card">
                                <div class="hero-summary-label">조회 결과</div>
                                <div class="hero-summary-value">
                                    <transition name="count-rise" mode="out-in">
                                        <span class="result-count-number" :key="animatedCount">{{ animatedCount
                                            }}</span>
                                    </transition>
                                    <span class="result-count-unit">건</span>
                                </div>
                            </div>
                        </div>

                        <div class="glass-card filter-card">
                            <div class="section-head">
                                <h3>주문 기간 선택</h3>
                            </div>
                            <div class="filter-body">
                                <div class="period-tab-wrap" ref="periodTabs">
                                    <button v-for="p in periodList" :key="p.value" type="button" class="period-tab"
                                        :class="{ active: selectedPeriod === p.value }" @click="fnSetPeriod(p.value)">
                                        {{ p.label }}
                                    </button>

                                    <span class="period-underline"
                                        :style="{ left: periodUnderline.left + 'px', width: periodUnderline.width + 'px' }">
                                    </span>
                                </div>
                                <div class="custom-date-row" v-if="selectedPeriod === 'CUSTOM'">
                                    <input type="date" v-model="startDate"> <span>~</span> <input type="date"
                                        v-model="endDate">
                                    <button class="btn-apply" @click="fnApplyCustomRange">적용</button>
                                </div>
                                <div class="date-error-msg" v-if="dateErrorMsg">{{ dateErrorMsg }}</div>
                            </div>
                        </div>

                        <div class="glass-card">
                            <div class="section-head">
                                <h3>선택 기간 내 주문 현황</h3>
                            </div>
                            <div class="order-flow">
                                <button v-for="(val, key) in statusMap" :key="key" type="button" class="flow-step"
                                    :class="{ 
            'has-count': statusSummary[key] > 0,
            'active': selectedStatus === key
        }" @click="fnSetStatusFilter(key)">
                                    <div class="flow-count">{{ statusSummary[key] }}</div>
                                    <div class="flow-name">{{ val.name }}</div>
                                </button>
                            </div>
                        </div>
                        <div class="glass-card order-search-card">
                            <div class="section-head search-section-head">
                                <h3>주문 상품 검색</h3>

                                <div class="search-box order-search-box">
                                    <input type="text" v-model="keyword" placeholder="상품명 · 브랜드 · 카테고리 검색"
                                        @keyup.enter="fnRunFilterAnimation">

                                    <button type="button" @click="fnRunFilterAnimation">검색</button>
                                </div>
                            </div>
                        </div>
                        <transition name="list-rise" mode="out-in">
                            <div class="list-container" :key="listAnimateKey">
                                <div v-if="isLoaded && groupedOrders.length === 0" class="empty-state glass-card">
                                    <p>선택한 기간에 주문내역이 없습니다.</p>
                                </div>

                                <div v-else v-for="group in groupedOrders" :key="group.date" class="date-group">
                                    <div class="group-date-head">
                                        <span class="group-date">{{ group.date }}</span>
                                        <span class="group-count">총 <strong>{{ group.items.length }}</strong>건</span>
                                    </div>

                                    <div v-for="item in group.items" :key="item.orderId" class="order-card-wrap">
                                        <div class="order-card" :class="{ open: expandedOrderId === item.orderId }"
                                            @click="fnToggleOrder(item.orderId)">

                                            <div class="card-left">
                                                <div class="thumb">
                                                    <img v-if="item.itemList && item.itemList.length > 0 && item.itemList[0].imgUrl"
                                                        :src="item.itemList[0].imgUrl"
                                                        :alt="item.itemList[0].productName">
                                                    <div v-else class="thumb-fallback">
                                                        {{ item.orderType === 'PURCHASE' ? '🛒' : '⛺' }}
                                                    </div>
                                                </div>

                                                <div class="info">
                                                    <div class="order-type-top">
                                                        <span class="badge" :class="item.orderType.toLowerCase()">
                                                            {{ item.orderType === 'PURCHASE' ? '구매' : '대여' }}
                                                        </span>
                                                    </div>
                                                    <div class="name-row">
                                                        <strong>
                                                            {{ item.itemList && item.itemList.length > 0 ?
                                                            item.itemList[0].productName : '상품명 없음' }}

                                                            <span
                                                                v-if="item.itemList && item.itemList.length > 0 && item.itemList[0].brandName"
                                                                class="order-brand-inline">
                                                                · {{ item.itemList[0].brandName }}
                                                            </span>
                                                        </strong>
                                                        <div v-if="item.itemList && item.itemList.length > 0 && item.itemList[0].categoryName"
                                                            class="order-category-pill">
                                                            {{ item.itemList[0].categoryName }}
                                                        </div>
                                                        <span v-if="item.itemList && item.itemList.length > 1"
                                                            class="extra">
                                                            외 {{ item.itemList.length - 1 }}건
                                                        </span>

                                                    </div>

                                                    <div class="sub-row">
                                                        주문번호 {{ item.orderId }} · {{ fnFormatDateTime(item.createdAt) }}
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card-right">
                                                <div class="status-badge" :class="item.orderStatus.toLowerCase()">
                                                    {{ fnGetStatusText(item.orderStatus) }}
                                                </div>

                                                <div class="price">
                                                    {{ fnFormatPrice((item.totalPrice || 0) - (item.discountAmt || 0))
                                                    }}
                                                </div>

                                                <div class="order-btn-group" @click.stop>
                                                    <button class="detail-btn detail-main-btn"
                                                        @click="fnGoOrderDetail(item.orderId)">
                                                        주문상세
                                                    </button>

                                                    <button class="detail-btn sub-action-btn"
                                                        :class="[fnGetActionClass(action), { 'return-done-btn': action === '반납 신청' && fnIsReturnRequested(item) }]"
                                                        v-for="action in fnGetOrderActions(item)" :key="action"
                                                        :disabled="action === '반납 신청' && fnIsReturnRequested(item)"
                                                        @click="fnHandleOrderAction(item, action)">

                                                        {{ action === '반납 신청' && fnIsReturnRequested(item) ? '반납 신청 완료'
                                                        : action }}
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="order-open-indicator">
                                                <i class="fa-solid"
                                                    :class="expandedOrderId === item.orderId ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
                                            </div>
                                        </div>

                                        <transition name="expand-fade">
                                            <div v-if="expandedOrderId === item.orderId" class="order-expand-box">
                                                <div class="expand-title">주문 상품 정보</div>

                                                <div v-for="orderItem in item.itemList" :key="orderItem.itemId"
                                                    class="expand-item-row">

                                                    <div class="expand-thumb">
                                                        <img v-if="orderItem.imgUrl" :src="orderItem.imgUrl"
                                                            :alt="orderItem.productName">
                                                        <div v-else class="expand-thumb-fallback">📦</div>
                                                    </div>

                                                    <div class="expand-info">
                                                        <div class="expand-name">
                                                            {{ orderItem.productName }}
                                                            <span v-if="orderItem.brandName" class="order-brand-inline">
                                                                · {{ orderItem.brandName }}
                                                            </span>
                                                        </div>

                                                        <div v-if="orderItem.categoryName"
                                                            class="order-category-pill expand-category-pill">
                                                            {{ orderItem.categoryName }}
                                                        </div>

                                                        <div class="expand-meta">
                                                            수량 {{ orderItem.count }}개 · {{
                                                            fnFormatPrice(orderItem.price) }}
                                                        </div>

                                                        <div class="expand-meta"
                                                            v-if="item.orderType === 'RENTAL' && orderItem.startDate && orderItem.endDate">
                                                            대여기간 {{ orderItem.startDate }} ~ {{ orderItem.endDate }}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </transition>
                                    </div>
                                </div>
                            </div>
                        </transition>
                    </div>
                    <div v-if="modal.show" class="return-modal-backdrop" @click.self="fnCloseReturnModal">
                        <div class="return-modal-box" ref="returnModal" tabindex="0"
                            @keydown.enter.prevent="fnConfirmReturn" @keydown.esc.prevent="fnCloseReturnModal">

                            <div class="return-modal-title">반납을 신청하시겠어요?</div>
                            <div class="return-modal-desc">
                                신청 후 관리자 확인을 거쳐 반납 절차가 진행됩니다.
                            </div>

                            <div class="return-modal-actions">
                                <button type="button" class="return-confirm-btn" @click="fnConfirmReturn">
                                    확인
                                </button>
                                <button type="button" class="return-cancel-btn" @click="fnCloseReturnModal">
                                    취소
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="toast" class="toast"></div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    orderId: new URLSearchParams(location.search).get('orderId') || '',
                                    orderList: [], selectedPeriod: "ALL", startDate: "", endDate: "",
                                    appliedStartDate: "", appliedEndDate: "", dateErrorMsg: "",
                                    animatedCount: 0, listAnimateKey: 0,
                                    keyword: "",
                                    selectedStatus: "",
                                    statusMap: {
                                        paid: { name: '결제완료' },
                                        ready: { name: '배송준비' },
                                        shipping: { name: '배송중' },
                                        inUse: { name: '이용중' },
                                        done: { name: '배송/반납 완료' },
                                        cancelled: { name: '취소/반품' }
                                    },
                                    expandedOrderId: null,
                                    periodList: [
                                        { value: "ALL", label: "전체" },
                                        { value: "1M", label: "1개월" },
                                        { value: "3M", label: "3개월" },
                                        { value: "6M", label: "6개월" },
                                        { value: "1Y", label: "1년" },
                                        { value: "CUSTOM", label: "직접 선택" }
                                    ],
                                    periodUnderline: {
                                        left: 0,
                                        width: 0
                                    },
                                    isLoaded: false,
                                    returnRequestedMap: {},
                                    modal: {
                                        show: false,
                                        order: null
                                    }
                                };
                            },
                            watch: {
                                'filteredOrderList.length'(newVal) { this.animatedCount = newVal; }
                            },
                            computed: {
                                filteredOrderList() {
                                    const now = new Date();
                                    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

                                    let start = null;
                                    let end = null;

                                    if (this.selectedPeriod === "1M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 1);
                                    } else if (this.selectedPeriod === "3M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 3);
                                    } else if (this.selectedPeriod === "6M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 6);
                                    } else if (this.selectedPeriod === "1Y") {
                                        start = new Date(today);
                                        start.setFullYear(start.getFullYear() - 1);
                                    } else if (this.selectedPeriod === "CUSTOM" && this.appliedStartDate && this.appliedEndDate) {
                                        start = new Date(this.appliedStartDate + "T00:00:00");
                                        end = new Date(this.appliedEndDate + "T23:59:59");
                                    }

                                    const keyword = (this.keyword || "").trim().toLowerCase();

                                    return this.orderList.filter(item => {
                                        const d = new Date(String(item.createdAt).replace(" ", "T"));
                                        const status = (item.orderStatus || "").toUpperCase();

                                        const periodMatch = (!start || d >= start) && (!end || d <= end);
                                        const statusMatch = this.fnMatchStatusFilter(status);

                                        let keywordMatch = true;

                                        if (keyword) {
                                            keywordMatch = false;

                                            if (item.itemList && item.itemList.length > 0) {
                                                keywordMatch = item.itemList.some(orderItem => {
                                                    const productName = (orderItem.productName || "").toLowerCase();
                                                    const brandName = (orderItem.brandName || "").toLowerCase();
                                                    const categoryName = (orderItem.categoryName || "").toLowerCase();

                                                    return productName.includes(keyword)
                                                        || brandName.includes(keyword)
                                                        || categoryName.includes(keyword);
                                                });
                                            }
                                        }

                                        return periodMatch && statusMatch && keywordMatch;
                                    });
                                },
                                groupedOrders() {
                                    const groupMap = {};
                                    this.filteredOrderList.forEach(item => {
                                        const date = item.createdAt.split(' ')[0].replaceAll('-', '.');
                                        if (!groupMap[date]) groupMap[date] = [];
                                        groupMap[date].push(item);
                                    });
                                    // 날짜 내림차순 정렬
                                    return Object.keys(groupMap).sort((a, b) => b.localeCompare(a)).map(date => ({ date, items: groupMap[date] }));
                                },
                                statusSummary() {
                                    const s = {
                                        paid: 0,
                                        ready: 0,
                                        shipping: 0,
                                        inUse: 0,
                                        done: 0,
                                        cancelled: 0
                                    };

                                    const now = new Date();
                                    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

                                    let start = null;
                                    let end = null;

                                    if (this.selectedPeriod === "1M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 1);
                                    } else if (this.selectedPeriod === "3M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 3);
                                    } else if (this.selectedPeriod === "6M") {
                                        start = new Date(today);
                                        start.setMonth(start.getMonth() - 6);
                                    } else if (this.selectedPeriod === "1Y") {
                                        start = new Date(today);
                                        start.setFullYear(start.getFullYear() - 1);
                                    } else if (this.selectedPeriod === "CUSTOM" && this.appliedStartDate && this.appliedEndDate) {
                                        start = new Date(this.appliedStartDate + "T00:00:00");
                                        end = new Date(this.appliedEndDate + "T23:59:59");
                                    }

                                    this.orderList.forEach(item => {
                                        const d = new Date(String(item.createdAt).replace(" ", "T"));
                                        const periodMatch = (!start || d >= start) && (!end || d <= end);

                                        if (!periodMatch) return;

                                        const status = (item.orderStatus || "").toUpperCase();

                                        if (status === "PAID" || status === "RESERVED") {
                                            s.paid++;
                                        } else if (status === "READY") {
                                            s.ready++;
                                        } else if (status === "SHIPPING") {
                                            s.shipping++;
                                        } else if (status === "IN_USE") {
                                            s.inUse++;
                                        } else if (status === "DONE" || status === "RETURNED" || status === "COMPLETED") {
                                            s.done++;
                                        } else if (status === "CANCELLED") {
                                            s.cancelled++;
                                        }
                                    });

                                    return s;
                                },
                            },
                            methods: {
                                fnGetOrderList() {
                                    $.ajax({
                                        url: "/order/list.dox",
                                        type: "POST",
                                        dataType: "json",
                                        success: (res) => {
                                            if (res.result === "success") {
                                                this.orderList = res.list || [];
                                            } else {
                                                this.orderList = [];
                                            }
                                            this.isLoaded = true;
                                            this.animatedCount = this.filteredOrderList.length;
                                        },
                                        error: () => {
                                            this.orderList = [];
                                            this.isLoaded = true;
                                        }
                                    });
                                },
                                fnSetPeriod(p) {
                                    this.selectedPeriod = p;
                                    this.dateErrorMsg = "";

                                    this.$nextTick(() => {
                                        this.fnMovePeriodUnderline();
                                    });

                                    if (p !== "CUSTOM") {
                                        this.startDate = "";
                                        this.endDate = "";
                                        this.appliedStartDate = "";
                                        this.appliedEndDate = "";
                                        this.fnRunFilterAnimation();
                                    }
                                },
                                fnApplyCustomRange() {
                                    this.dateErrorMsg = "";

                                    if (!this.startDate || !this.endDate) {
                                        this.dateErrorMsg = "조회할 시작일과 종료일을 모두 선택해주세요.";
                                        return;
                                    }

                                    if (this.startDate > this.endDate) {
                                        this.dateErrorMsg = "시작일은 종료일보다 늦을 수 없습니다.";
                                        return;
                                    }

                                    this.appliedStartDate = this.startDate;
                                    this.appliedEndDate = this.endDate;
                                    this.fnRunFilterAnimation();
                                },

                                fnMovePeriodUnderline() {
                                    const wrap = this.$refs.periodTabs;
                                    if (!wrap) return;

                                    const active = wrap.querySelector(".period-tab.active");
                                    if (!active) return;

                                    this.periodUnderline.left = active.offsetLeft;
                                    this.periodUnderline.width = active.offsetWidth;
                                },
                                fnRunFilterAnimation() { this.listAnimateKey++; },
                                fnFormatPrice(p) { return Number(p).toLocaleString() + '원'; },
                                fnGetStatusText(s) {
                                    const m = {
                                        PAID: '결제완료',
                                        READY: '배송준비',
                                        SHIPPING: '배송중',
                                        DONE: '배송완료',
                                        RETURNED: '반납완료',
                                        COMPLETED: '대여완료',
                                        CANCELLED: '취소/반품',
                                        RESERVED: '예약완료',
                                        IN_USE: '이용중',
                                        EXCHANGE_REQUESTED : '교환신청'
                                    };
                                    return m[s] || s;
                                },
                                fnFormatDateTime(v) { return v.substring(0, 16).replaceAll('-', '.'); },
                                fnGoOrderDetail(id) { location.href = "/order/detail.do?orderId=" + id; },
                                fnGetOrderActions(item) {
                                    const actions = [];
                                    const status = (item.orderStatus || "").toUpperCase();
                                    const orderType = (item.orderType || "").toUpperCase();

                                    if (orderType === "PURCHASE") {
                                        if (status === "DONE") {
                                            actions.push("환불 신청");
                                            actions.push("리뷰 작성");
                                            actions.push("교환 신청");
                                        }
                                    }

                                    if (orderType === "RENTAL") {
                                        if (status === "DONE") {
                                            actions.push("환불 신청");
                                            actions.push("반납 신청");
                                            actions.push("연장 신청");
                                        }

                                        if (status === "IN_USE") {
                                            actions.push("반납 신청");
                                            actions.push("연장 신청");
                                        }

                                        if (status === "COMPLETED" || status === "RETURNED") {
                                            actions.push("리뷰 작성");
                                        }
                                    }

                                    return actions;
                                },

                                fnHandleOrderAction: function (item, action) {

                                    if (action === "취소 신청") {
                                        pageChange("/order/cancel/request.do", {
                                            orderId: item.orderId
                                        });
                                        return;
                                    }

                                    if (action === "환불 신청") {
                                        pageChange("/order/refund/request.do", {
                                            orderId: item.orderId
                                        });
                                        return;
                                    }
                                    if (action === "교환 신청") {
                                        location.href = "/order/exchange/request.do?orderId=" + item.orderId;
                                        return;
                                    }

                                    // 수정 후
                                    if (action === "반납 신청") {
                                        location.href = "/rental/extension/main.do?tab=return";
                                        return;
                                    }

                                    if (action === "연장 신청") {
                                        location.href = "/rental/extension/main.do?tab=extension";
                                        return;
                                    }

                                    if (action === "리뷰 작성") {
                                        pageChange("/user/review/add.do", {
                                            orderId: item.orderId
                                        });
                                        return;
                                    }
                                },

                                fnToggleOrder(orderId) {
                                    this.expandedOrderId = this.expandedOrderId === orderId ? null : orderId;
                                },
                                fnGetActionClass(action) {
                                    if (action === "취소 신청") return "cancel-btn";
                                    if (action === "환불 신청") return "refund-btn";
                                    if (action === "리뷰 작성") return "review-btn";
                                    if (action === "반납 신청") return "return-btn";
                                    if (action === "연장 신청") return "extend-btn";
                                    return "";
                                },
                                fnSetStatusFilter(key) {
                                    if (this.selectedStatus === key) {
                                        this.selectedStatus = "";
                                    } else {
                                        this.selectedStatus = key;
                                    }

                                    this.expandedOrderId = null;
                                    this.fnRunFilterAnimation();
                                },

                                fnMatchStatusFilter(status) {
                                    if (!this.selectedStatus) return true;

                                    if (this.selectedStatus === "paid") {
                                        return status === "PAID" || status === "RESERVED";
                                    }

                                    if (this.selectedStatus === "ready") {
                                        return status === "READY";
                                    }

                                    if (this.selectedStatus === "shipping") {
                                        return status === "SHIPPING";
                                    }

                                    if (this.selectedStatus === "inUse") {
                                        return status === "IN_USE";
                                    }

                                    if (this.selectedStatus === "done") {
                                        return status === "DONE" || status === "RETURNED" || status === "COMPLETED";
                                    }

                                    if (this.selectedStatus === "cancelled") {
                                        return status === "CANCELLED";
                                    }

                                    return true;
                                },
                                fnOpenReturnModal(item) {
                                    this.modal.show = true;
                                    this.modal.order = item;

                                    this.$nextTick(() => {
                                        if (this.$refs.returnModal) {
                                            this.$refs.returnModal.focus();
                                        }
                                    });
                                },

                                fnCloseReturnModal() {
                                    this.modal.show = false;
                                    this.modal.order = null;
                                },

                                fnConfirmReturn() {
                                    if (!this.modal.order) return;

                                    const orderId = this.modal.order.orderId;

                                    this.returnRequestedMap[orderId] = true;
                                    this.fnCloseReturnModal();
                                    this.fnShowToast("반납이 신청되었어요!");
                                },

                                fnShowToast(msg) {
                                    const toast = document.getElementById("toast");
                                    if (!toast) return;

                                    toast.textContent = msg;
                                    toast.classList.add("show");

                                    setTimeout(() => {
                                        toast.classList.remove("show");
                                    }, 2200);
                                },

                                fnIsReturnRequested(item) {
                                    return this.returnRequestedMap[item.orderId] === true;
                                },

                            },
                            mounted() {
                                this.fnGetOrderList();

                                this.$nextTick(() => {
                                    this.fnMovePeriodUnderline();
                                });

                                window.addEventListener("resize", this.fnMovePeriodUnderline);
                            }
                        }).mount("#app");
                    </script>
        </body>

        </html>