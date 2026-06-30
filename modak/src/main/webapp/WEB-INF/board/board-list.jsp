<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page deferredSyntaxAllowedAsLiteral="true" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>모닥모닥 커뮤니티</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board-list.css">

            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/js/page-change.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">

                        <div class="board-header">
                            <div class="board-title-area">
                                <div class="board-title">
                                    <i class="ri-discuss-line"></i>
                                    모닥<span>커뮤니티</span>
                                </div>
                                <div class="board-subtitle">
                                    캠퍼들의 이야기가 모이는 곳
                                </div>
                            </div>

                            <button class="btn-write" @click="fnGoWrite">
                                <i class="ri-pencil-line"></i>
                                글쓰기
                            </button>
                        </div>

                        <!-- 태그 검색 상태 -->
                        <div class="tag-search-banner" v-if="tagKeyword">
                            <div>
                                <strong>#{{ tagKeyword }}</strong> 태그 검색 결과
                            </div>
                            <button type="button" @click="fnClearTagSearch">전체 글 보기</button>
                        </div>

                        <!-- HOT 게시글 -->
                        <div class="hot-section" v-if="!tagKeyword && hotList.length > 0">
                            <div class="hot-title">
                                <i class="ri-fire-fill icon-hot"></i>
                                오늘의 인기글
                            </div>

                            <div class="hot-list">
                                <div class="hot-card" :class="{ 'is-top': idx === 0 }" v-for="(item, idx) in hotList" :key="item.BOARD_ID"
                                    @click="fnGoDetail(item.BOARD_ID)">

                                    <div class="hot-rank" :class="'rank-' + (idx+1)">
                                        {{ idx + 1 }}
                                    </div>

                                    <div class="hot-card-body">
                                        <div class="hot-card-badge" v-if="idx === 0">오늘의 불씨</div>
                                        <div class="hot-card-title">{{ item.TITLE }}</div>

                                        <div class="hot-card-meta">
                                            <span class="meta-chip">
                                                <i class="ri-heart-3-fill icon-like"></i>
                                                {{ item.LIKE_COUNT }}
                                            </span>
                                            <span class="meta-chip">
                                                <i class="ri-chat-3-line icon-comment"></i>
                                                {{ item.COMMENT_COUNT }}
                                            </span>
                                            <span class="meta-chip">
                                                <i class="ri-eye-line icon-view"></i>
                                                {{ item.VIEW_COUNT }}
                                            </span>
                                            <span class="meta-chip">
                                                <i class="ri-fire-fill icon-hot"></i>
                                                {{ Math.round(item.hotScore) }}점
                                            </span>
                                        </div>
                                    </div>

                                    <div class="hot-thumb" v-if="item.thumbUrl">
                                        <img :src="item.thumbUrl">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 필터바 위에 추가 -->
                        <div class="grade-info-bar" @click="showGradeInfo = !showGradeInfo">
                            <span>
                                <i class="ri-trophy-fill icon-grade-main"></i>
                                커뮤니티 등급 안내
                            </span>
                            <i :class="showGradeInfo ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
                        </div>

                        <div class="grade-info-panel" v-if="showGradeInfo">
                            <div class="grade-row" v-for="g in gradeList" :key="g.code">
                                <span class="grade-icon" :class="g.colorClass">
                                    <i :class="g.iconClass"></i>
                                </span>
                                <div class="grade-info">
                                    <span class="grade-name">{{ g.name }}</span>
                                    <span class="grade-desc">{{ g.desc }}</span>
                                </div>
                            </div>
                        </div>

                        <!-- 필터 -->
                        <div class="filter-bar">
                            <div class="community-tabs" ref="tabWrap">
                                <button class="tab-btn" :class="{ active: category === '' }" @click="fnSetCat('')">
                                    전체
                                </button>
                                <button class="tab-btn" :class="{ active: category === 'FREE' }"
                                    @click="fnSetCat('FREE')">
                                    자유
                                </button>
                                <button class="tab-btn" :class="{ active: category === 'REVIEW' }"
                                    @click="fnSetCat('REVIEW')">
                                    후기
                                </button>
                                <button class="tab-btn" :class="{ active: category === 'TIP' }"
                                    @click="fnSetCat('TIP')">
                                    꿀팁
                                </button>
                                <button class="tab-btn" :class="{ active: category === 'QNA' }"
                                    @click="fnSetCat('QNA')">
                                    Q&A
                                </button>

                                <span class="tab-line" :style="tabLineStyle"></span>
                            </div>
                            <select class="sort-select" v-model="sort" @change="fnChangeSort">
                                <option value="newest">최신순</option>
                                <option value="popular">추천순</option>
                                <option value="oldest">오래된순</option>
                            </select>

                            <div class="search-wrap">
                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnSearch">
                                <button type="button" @click="fnSearch" aria-label="검색">
                                    <i class="ri-search-line"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 목록 -->
                        <div class="board-list" v-if="list.length > 0">
                            <div class="board-item" :class="'cat-border-' + item.CATEGORY" v-for="item in list" :key="item.BOARD_ID"
                                @click="fnGoDetail(item.BOARD_ID)">

                                <div class="item-main">
                                    <div class="item-top">
                                        <span class="cat-tag" :class="'cat-' + item.CATEGORY">
                                            {{ fnCatLabel(item.CATEGORY) }}
                                        </span>

                                        <span class="hot-tag" v-if="item.IS_HOT === 'Y'">
                                            <i class="ri-fire-fill icon-hot"></i>
                                            HOT
                                        </span>

                                        <span class="poll-tag" v-if="item.HAS_POLL === 'Y'">
                                            <i class="ri-bar-chart-box-fill icon-poll"></i>
                                            투표
                                        </span>
                                    </div>

                                    <div class="item-title">{{ item.TITLE }}</div>

                                    <div class="item-info">
                                        <span class="writer">
                                            {{ item.nickName || item.NICKNAME || item.USER_ID }}
                                        </span>

                                        <span class="dot">·</span>
                                        <span>{{ fnFormatDate(item.CREATED_AT) }}</span>

                                        <span class="dot">·</span>
                                        <span class="info-count">
                                            <i class="ri-eye-line icon-view"></i>
                                            {{ item.VIEW_COUNT }}
                                        </span>

                                        <span class="dot">·</span>
                                        <span class="info-count">
                                            <i class="ri-heart-3-fill icon-like"></i>
                                            {{ item.LIKE_COUNT }}
                                        </span>

                                        <span class="dot">·</span>
                                        <span class="info-count">
                                            <i class="ri-chat-3-line icon-comment"></i>
                                            {{ item.COMMENT_COUNT }}
                                        </span>

                                        <template v-if="item.productName">
                                            <span class="dot">·</span>
                                            <span class="linked-product">
                                                <i class="ri-links-line"></i>
                                                {{ item.productName }}
                                            </span>
                                        </template>
                                    </div>
                                </div>

                                <div class="item-thumb" v-if="item.thumbUrl">
                                    <img :src="item.thumbUrl" alt="썸네일">
                                </div>
                            </div>
                        </div>

                        <div class="empty-state" v-else>
                            <div class="empty-emoji">
                                <i class="ri-tent-fill"></i>
                            </div>
                            <div v-if="tagKeyword">#{{ tagKeyword }} 태그의 게시글이 없습니다.</div>
                            <div v-else>게시글이 없습니다. 첫 번째 글을 남겨보세요!</div>
                        </div>

                        <!-- 페이지네이션 -->
                        <div class="pagination" v-if="!tagKeyword && totalPages > 1">

                            <button class="page-btn" v-if="page > 5" @click="fnPage(page - 5)">
                                «
                            </button>

                            <button class="page-btn" :disabled="page === 1" @click="fnPage(page - 1)">
                                ‹
                            </button>

                            <button class="page-btn" v-for="p in visiblePages" :key="p" :class="{ active: p === page }"
                                @click="fnPage(p)">
                                {{ p }}
                            </button>

                            <button class="page-btn" :disabled="page === totalPages" @click="fnPage(page + 1)">
                                ›
                            </button>

                            <button class="page-btn" v-if="visiblePages[visiblePages.length - 1] < totalPages"
                                @click="fnPage(page + 5)">
                                »
                            </button>

                        </div>

                    </div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>

                    <script>
                        const { createApp } = Vue;

                        createApp({
                            data() {
                                return {
                                    list: [],
                                    hotList: [],
                                    totalCount: 0,
                                    page: 1,
                                    pageSize: 15,
                                    category: '',
                                    sort: 'newest',
                                    keyword: '',
                                    tagKeyword: new URLSearchParams(location.search).get('tag') || '',
                                    // data()에 추가
                                    showGradeInfo: false,
                                    gradeList: [
                                        { code: 'SPROUT', iconClass: 'ri-seedling-fill', colorClass: 'grade-sprout', name: '새싹', desc: '가입 후 기본 등급' },
                                        { code: 'EMBER', iconClass: 'ri-fire-fill', colorClass: 'grade-ember', name: '불씨', desc: '게시글 5개 이상 또는 댓글 10개 이상' },
                                        { code: 'CAMPER', iconClass: 'ri-tent-fill', colorClass: 'grade-camper', name: '캠퍼', desc: '게시글 20개 이상 또는 받은 추천 50개 이상' },
                                        { code: 'FIRE_CAMPER', iconClass: 'ri-blaze-fill', colorClass: 'grade-fire-camper', name: '불꽃캠퍼', desc: '게시글 50개 이상 또는 받은 추천 200개 이상' },
                                        { code: 'MODAK', iconClass: 'ri-award-fill', colorClass: 'grade-modak', name: '모닥불', desc: '게시글 100개 이상 또는 받은 추천 500개 이상' },
                                    ], tabLineStyle: {
                                        width: '0px',
                                        left: '0px'
                                    },
                                };
                            },

                            computed: {
                                totalPages() {
                                    return Math.max(1, Math.ceil(this.totalCount / this.pageSize));
                                },

                                visiblePages() {
                                    const groupSize = 5;
                                    const start = Math.floor((this.page - 1) / groupSize) * groupSize + 1;
                                    const end = Math.min(start + groupSize - 1, this.totalPages);

                                    let arr = [];
                                    for (let i = start; i <= end; i++) {
                                        arr.push(i);
                                    }

                                    return arr;
                                }
                            },

                            methods: {
                                fnGetList() {
                                    $.ajax({
                                        url: '/board/list.dox',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: {
                                            page: this.page,
                                            pageSize: this.pageSize,
                                            category: this.category,
                                            sort: this.sort,
                                            keyword: this.keyword
                                        },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.list = res.list || [];
                                                this.totalCount = res.totalCount || 0;
                                                this.hotList = res.hotList || [];
                                            } else {
                                                this.list = [];
                                                this.totalCount = 0;
                                                this.hotList = [];
                                            }
                                        },
                                        error: () => {
                                            this.list = [];
                                            this.totalCount = 0;
                                            this.hotList = [];
                                        }
                                    });
                                },

                                fnLoadByTag(tag) {
                                    $.ajax({
                                        url: '/board/tag/list.dox',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: {
                                            tag: tag
                                        },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.list = res.list || [];
                                                this.totalCount = this.list.length;
                                                this.hotList = [];
                                            } else {
                                                this.list = [];
                                                this.totalCount = 0;
                                                this.hotList = [];
                                            }
                                        },
                                        error: () => {
                                            this.list = [];
                                            this.totalCount = 0;
                                            this.hotList = [];
                                        }
                                    });
                                },

                                fnClearTagSearch() {
                                    location.href = '/board/list.do';
                                },

                                fnSetCat(cat) {
                                    if (this.tagKeyword) {
                                        this.fnClearTagSearch();
                                        return;
                                    }

                                    this.category = cat;
                                    this.page = 1;
                                    this.fnGetList();
                                    this.fnMoveTabLine();
                                },
                                fnSearch() {
                                    if (this.tagKeyword) {
                                        this.fnClearTagSearch();
                                        return;
                                    }

                                    this.page = 1;
                                    this.fnGetList();

                                    this.$nextTick(() => {
                                        this.fnMoveTabLine();
                                    });
                                },
                                fnPage(p) {
                                    if (p < 1) p = 1;
                                    if (p > this.totalPages) p = this.totalPages;

                                    this.page = p;
                                    this.fnGetList();

                                    window.scrollTo({
                                        top: 0,
                                        behavior: 'smooth'
                                    });
                                },

                                fnGoWrite() {
                                    location.href = '/board/write.do';
                                },

                                fnGoDetail(id) {
                                    location.href = '/board/detail.do?boardId=' + id;
                                },

                                fnCatLabel(c) {
                                    return {
                                        FREE: '자유',
                                        REVIEW: '후기',
                                        TIP: '꿀팁',
                                        QNA: 'Q&A'
                                    }[c] || c;
                                },

                                fnFormatDate(dt) {
                                    if (!dt) return '';

                                    const d = new Date(dt);
                                    const now = new Date();
                                    const diff = (now - d) / 1000;

                                    if (diff < 60) return '방금 전';
                                    if (diff < 3600) return Math.floor(diff / 60) + '분 전';
                                    if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';

                                    return dt.toString().slice(0, 10);
                                },
                                fnMoveTabLine() {
                                    this.$nextTick(() => {
                                        const wrap = this.$refs.tabWrap;
                                        if (!wrap) return;

                                        const active = wrap.querySelector('.tab-btn.active');
                                        if (!active) return;

                                        this.tabLineStyle = {
                                            width: active.offsetWidth + 'px',
                                            left: active.offsetLeft + 'px'
                                        };
                                    });
                                }, fnChangeSort() {
                                    this.page = 1;
                                    this.fnGetList();

                                    this.$nextTick(() => {
                                        this.fnMoveTabLine();
                                    });
                                },
                            },
                            mounted() {
                                if (this.tagKeyword) {
                                    this.fnLoadByTag(this.tagKeyword);
                                } else {
                                    this.fnGetList();
                                }

                                this.fnMoveTabLine();

                                window.addEventListener('resize', this.fnMoveTabLine);
                            }
                        }).mount('#app');
                    </script>
        </body>

        </html>
