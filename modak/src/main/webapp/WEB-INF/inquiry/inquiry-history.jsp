<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>내 문의</title>

                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <script src="/js/page-change.js"></script>

                    <!-- 문의 전용 추가 스타일 -->
                    <link rel="stylesheet" href="/css/inquiry/inquiry-history.css">
                </head>

                <body>
                    <%@ include file="/WEB-INF/common/header.jsp" %>

                        <div id="app" v-cloak>
                            <div class="wishlist-history-page">
                                <div class="wishlist-history-wrap">

                                    <div class="page-hero">
                                        <div>
                                            <div class="page-eyebrow">MY INQUIRY</div>
                                            <h2 class="page-title">내 문의 전체보기</h2>
                                            <p class="page-desc">
                                                내가 등록한 문의를 최신순으로 확인할 수 있어요.
                                            </p>
                                        </div>

                                        <div class="hero-summary-card">
                                            <div class="hero-summary-label">{{ fnSummaryLabel() }}</div>
                                            <div class="hero-summary-value">
                                                <transition name="count-rise" mode="out-in">
                                                    <span class="result-count-number" :key="summaryCount">{{
                                                        summaryCount }}</span>
                                                </transition>
                                                <span class="result-count-unit">개</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="section-card">
                                        <div class="section-head">
                                            <div class="section-head-left">
                                                <h3>전체 문의</h3>
                                                <p class="recent-guide-text">문의는 10개씩 확인할 수 있습니다.</p>
                                            </div>
                                            <div class="inquiry-filter-tabs" ref="filterTabs">
                                                <button type="button" ref="tabAll" class="inquiry-filter-tab"
                                                    :class="{ active: statusFilter === 'ALL' }"
                                                    @click="fnChangeStatusFilter('ALL')">
                                                    전체
                                                </button>

                                                <button type="button" ref="tabWaiting" class="inquiry-filter-tab"
                                                    :class="{ active: statusFilter === 'WAITING' }"
                                                    @click="fnChangeStatusFilter('WAITING')">
                                                    답변대기
                                                </button>

                                                <button type="button" ref="tabAnswered" class="inquiry-filter-tab"
                                                    :class="{ active: statusFilter === 'ANSWERED' }"
                                                    @click="fnChangeStatusFilter('ANSWERED')">
                                                    답변완료
                                                </button>

                                                <div class="filter-underline" :style="filterUnderlineStyle"></div>
                                            </div>
                                        </div>
                                        <transition name="list-rise" mode="out-in">
                                            <div class="wishlist-content" :key="'inquiry-' + listAnimateKey">
                                                <div v-if="filteredInquiryList.length === 0" class="empty-state">
                                                    <p>문의 내역이 없습니다.</p>
                                                </div>

                                                <div v-else class="review-list inquiry-list">
                                                    <div class="review-item inquiry-item"
                                                        v-for="item in filteredInquiryList" :key="item.inquiryId"
                                                        @click="fnToggleInquiry(item)"
                                                        :class="{ active: expandedInquiryId === item.inquiryId }">

                                                        <!-- 상단 -->
                                                        <div class="inquiry-title-row">
                                                            <div class="inquiry-title-wrap">
                                                                <div class="review-title inquiry-title">
                                                                    {{ item.title || '제목 없음' }}
                                                                </div>
                                                                <div class="review-date inquiry-date">
                                                                    {{ item.createdAt }}
                                                                </div>
                                                            </div>

                                                            <div class="inquiry-right-tools">
                                                                <div class="inquiry-status"
                                                                    :class="fnInquiryStatusClass(item)">
                                                                    {{ fnInquiryStatusText(item) }}
                                                                </div>

                                                                <button type="button" class="review-toggle-btn"
                                                                    @click.stop="fnToggleInquiry(item)">
                                                                    <span>{{ expandedInquiryId === item.inquiryId ? '접기'
                                                                        : '펼치기' }}</span>
                                                                    <span class="arrow"
                                                                        :class="{ open: expandedInquiryId === item.inquiryId }">▾</span>
                                                                </button>
                                                            </div>
                                                        </div>

                                                        <!-- 펼침 -->
                                                        <div v-if="expandedInquiryId === item.inquiryId"
                                                            class="inquiry-expand-area">

                                                            <div class="inquiry-detail-box">
                                                                <div class="inquiry-detail-section">
                                                                    <div class="detail-label">문의 내용</div>
                                                                    <div class="detail-value detail-content">
                                                                        {{ item.content }}
                                                                    </div>
                                                                </div>

                                                                <div class="inquiry-detail-divider"
                                                                    v-if="item.imageList && item.imageList.length > 0">
                                                                </div>

                                                                <div class="inquiry-detail-section"
                                                                    v-if="item.imageList && item.imageList.length > 0">
                                                                    <div class="detail-label">첨부 이미지</div>
                                                                    <div class="detail-value">
                                                                        <div class="review-image-grid">
                                                                            <div class="review-image-thumb"
                                                                                v-for="(img, index) in item.imageList.slice(0, 6)"
                                                                                :key="index"
                                                                                @click.stop="fnOpenImageModal(item.imageList, index)">

                                                                                <img :src="img.imgUrl" alt="문의 이미지">

                                                                                <div v-if="index === 5 && item.imageList.length > 6"
                                                                                    class="review-image-overlay">
                                                                                    +{{ item.imageList.length - 6 }}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="inquiry-detail-box answer-box">
                                                                <div class="inquiry-detail-section">
                                                                    <div class="detail-label">문의 답변</div>

                                                                    <!-- 답변 있을 때 -->
                                                                    <div v-if="item.answer">
                                                                        <div class="detail-value detail-content">
                                                                            {{ item.answer }}
                                                                        </div>

                                                                        <!-- 🔥 답변일시 추가 -->
                                                                        <div class="answer-date">
                                                                            답변일시 : {{ item.replyCreatedAt }}
                                                                        </div>
                                                                    </div>

                                                                    <!-- 답변 없을 때 -->
                                                                    <div class="detail-value" v-else>
                                                                        아직 답변이 등록되지 않았습니다.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- 하단 -->
                                                        <div class="review-bottom">
                                                            <div></div>

                                                            <div class="review-actions" v-if="!item.replyId" @click.stop>
                                                                <button class="btn-outline btn-sm"
                                                                    @click.stop="fnEditInquiry(item.inquiryId)">
                                                                    수정
                                                                </button>

                                                                <button class="btn-outline btn-sm danger"
                                                                    @click.stop="fnOpenDeleteModal(item.inquiryId)">
                                                                    삭제
                                                                </button>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div v-if="totalPages > 1" class="pagination-wrap">
                                                    <button class="page-btn" :disabled="page === 1"
                                                        @click="fnChangePage(page - 1)">
                                                        이전
                                                    </button>

                                                    <button v-for="num in totalPages" :key="num" class="page-btn"
                                                        :class="{ active: page === num }" @click="fnChangePage(num)">
                                                        {{ num }}
                                                    </button>

                                                    <button class="page-btn" :disabled="page === totalPages"
                                                        @click="fnChangePage(page + 1)">
                                                        다음
                                                    </button>
                                                </div>
                                            </div>
                                        </transition>
                                    </div>
                                </div>
                            </div>

                            <!-- 이미지 모달 -->
                            <div v-if="isImageModalOpen" class="image-modal" @click="fnCloseImageModal">
                                <div class="image-modal-content" @click.stop>
                                    <button class="image-modal-close" @click="fnCloseImageModal">×</button>

                                    <button class="image-modal-nav prev" v-if="modalImageList.length > 1"
                                        @click="fnPrevImage">
                                        ‹
                                    </button>

                                    <img :src="modalImageList[currentImageIndex].imgUrl" alt="확대 이미지"
                                        class="image-modal-img">

                                    <button class="image-modal-nav next" v-if="modalImageList.length > 1"
                                        @click="fnNextImage">
                                        ›
                                    </button>
                                </div>
                            </div>
                            <div class="toast" :class="{ show: toastVisible }">
                                {{ toastMsg }}
                            </div>

                            <div v-if="deleteModalOpen" class="delete-modal-backdrop" @click.self="fnCloseDeleteModal"
                                @keydown.enter.prevent="fnConfirmDelete" @keydown.esc.prevent="fnCloseDeleteModal"
                                tabindex="0" ref="deleteModal">

                                <div class="delete-modal-box">
                                    <div class="delete-modal-title">문의를 삭제하시겠습니까?</div>
                                    <div class="delete-modal-desc">
                                        삭제한 문의는 다시 복구할 수 없습니다.
                                    </div>

                                    <div class="delete-modal-actions">
                                        <button type="button" class="delete-confirm-btn" @click="fnConfirmDelete">
                                            삭제
                                        </button>
                                        <button type="button" class="delete-cancel-btn" @click="fnCloseDeleteModal">
                                            취소
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%@ include file="/WEB-INF/common/footer.jsp" %>
                </body>

                </html>

                <script>
                    const app = Vue.createApp({
                        data() {
                            return {
                                inquiryList: [],
                                totalCount: 0,
                                page: 1,
                                pageSize: 10,
                                totalPages: 1,
                                listAnimateKey: 0,

                                expandedInquiryId: null,

                                isImageModalOpen: false,
                                modalImageList: [],
                                currentImageIndex: 0,
                                filteredInquiryList: [],
                                statusFilter: "ALL",

                                toastVisible: false,
                                toastMsg: '',
                                deleteModalOpen: false,
                                deleteInquiryId: null,
                                filterUnderlineStyle: {
                                    width: "0px",
                                    transform: "translateX(0px)"
                                }

                            };
                        },
                        computed: {
                            summaryCount() {
                                return this.filteredInquiryList.length;
                            },

                        },
                        methods: {
                            fnGetInquiryList: function (moveTop = false) {
                                let self = this;

                                $.ajax({
                                    url: "/user/inquiry/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        page: self.page,
                                        pageSize: self.pageSize,
                                        statusFilter: self.statusFilter
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.inquiryList = (data.list || []).map(function (item) {
                                                item.imageList = item.imageList || [];
                                                return item;
                                            });

                                            self.filteredInquiryList = self.inquiryList;

                                            self.totalCount = data.totalCount || 0;
                                            self.totalPages = Math.ceil(self.totalCount / self.pageSize) || 1;
                                            self.listAnimateKey++;
                                            self.expandedInquiryId = null;

                                            if (moveTop) {
                                                window.scrollTo({
                                                    top: 0,
                                                    behavior: "smooth"
                                                });
                                            }
                                        } else {
                                            self.inquiryList = [];
                                            self.totalCount = 0;
                                            self.totalPages = 1;
                                            self.expandedInquiryId = null;
                                        }
                                    },
                                    error: function () {
                                        self.inquiryList = [];
                                        self.totalCount = 0;
                                        self.totalPages = 1;
                                        self.expandedInquiryId = null;
                                    }
                                });
                            },
                            fnMoveFilterUnderline: function () {
                                let target = this.$refs.tabAll;

                                if (this.statusFilter === "WAITING") {
                                    target = this.$refs.tabWaiting;
                                }

                                if (this.statusFilter === "ANSWERED") {
                                    target = this.$refs.tabAnswered;
                                }

                                if (!target || !this.$refs.filterTabs) return;

                                const parentRect = this.$refs.filterTabs.getBoundingClientRect();
                                const targetRect = target.getBoundingClientRect();

                                this.filterUnderlineStyle = {
                                    width: targetRect.width + "px",
                                    transform: "translateX(" + (targetRect.left - parentRect.left) + "px)"
                                };
                            },

                            fnChangePage: function (num) {
                                if (num < 1 || num > this.totalPages || num === this.page) {
                                    return;
                                }

                                this.page = num;
                                this.fnGetInquiryList(true);
                            },

                            fnToggleInquiry: function (item) {
                                let self = this;

                                if (self.expandedInquiryId === item.inquiryId) {
                                    self.expandedInquiryId = null;
                                    return;
                                }

                                self.expandedInquiryId = item.inquiryId;

                                if (item.imageList && item.imageList.length > 0) {
                                    return;
                                }

                                $.ajax({
                                    url: "/user/inquiry/img/list.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        inquiryId: item.inquiryId
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            item.imageList = data.list || [];
                                        } else {
                                            item.imageList = [];
                                        }
                                    },
                                    error: function () {
                                        item.imageList = [];
                                    }
                                });
                            },

                            fnInquiryStatusText: function (item) {
                                return item.replyId ? "답변완료" : "답변대기";
                            },

                            fnInquiryStatusClass: function (item) {
                                return item.replyId ? "answered" : "waiting";
                            },

                            fnEditInquiry: function (inquiryId) {
                                pageChange("/user/inquiry/edit.do", { inquiryId: inquiryId });
                            },
                            fnOpenDeleteModal: function (inquiryId) {
                                let self = this;

                                self.deleteInquiryId = inquiryId;
                                self.deleteModalOpen = true;

                                self.$nextTick(function () {
                                    self.$refs.deleteModal.focus();
                                });
                            },

                            fnCloseDeleteModal: function () {
                                this.deleteModalOpen = false;
                                this.deleteInquiryId = null;
                            },

                            fnConfirmDelete: function () {
                                let self = this;

                                if (!self.deleteInquiryId) {
                                    return;
                                }

                                $.ajax({
                                    url: "/user/inquiry/remove.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        inquiryId: self.deleteInquiryId
                                    },
                                    success: function (data) {
                                        if (data.result === "success") {
                                            self.fnCloseDeleteModal();
                                            self.showToast("문의가 삭제되었습니다.");

                                            if (self.inquiryList.length === 1 && self.page > 1) {
                                                self.page--;
                                            }

                                            self.fnGetInquiryList();
                                        } else {
                                            alert(data.message || "삭제 실패");
                                        }
                                    },
                                    error: function () {
                                        alert("서버 오류");
                                    }
                                });
                            },

                            fnOpenImageModal: function (imageList, index) {
                                this.modalImageList = imageList;
                                this.currentImageIndex = index;
                                this.isImageModalOpen = true;
                                document.body.style.overflow = "hidden";
                            },

                            fnCloseImageModal: function () {
                                this.isImageModalOpen = false;
                                this.modalImageList = [];
                                this.currentImageIndex = 0;
                                document.body.style.overflow = "";
                            },

                            fnPrevImage: function () {
                                if (this.currentImageIndex > 0) {
                                    this.currentImageIndex--;
                                } else {
                                    this.currentImageIndex = this.modalImageList.length - 1;
                                }
                            },

                            fnNextImage: function () {
                                if (this.currentImageIndex < this.modalImageList.length - 1) {
                                    this.currentImageIndex++;
                                } else {
                                    this.currentImageIndex = 0;
                                }
                            },
                            fnChangeStatusFilter: function (status) {
                                this.statusFilter = status;
                                this.page = 1;
                                this.expandedInquiryId = null;

                                this.$nextTick(() => {
                                    this.fnMoveFilterUnderline();
                                });

                                this.fnGetInquiryList(true);
                            },

                            showToast: function (msg) {
                                let self = this;
                                self.toastMsg = msg;
                                self.toastVisible = true;

                                setTimeout(function () {
                                    self.toastVisible = false;
                                }, 2000);
                            },
                            fnSummaryLabel: function () {
                                if (this.statusFilter === "WAITING") {
                                    return "답변대기";
                                }

                                if (this.statusFilter === "ANSWERED") {
                                    return "답변완료";
                                }

                                return "내 문의";
                            }

                        },
                        mounted() {
                            this.fnGetInquiryList();

                            this.$nextTick(() => {
                                this.fnMoveFilterUnderline();
                            });
                        }
                    });

                    app.mount("#app");
                </script>