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
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">

                        <!-- 헤더 -->
                        <div class="board-header">
                            <div>
                                <div class="board-title">🔥 모닥<span>커뮤니티</span></div>
                                <div style="font-size:13px;color:var(--brown3);margin-top:4px;">
                                    캠퍼들의 이야기가 모이는 곳
                                </div>
                            </div>
                            <button class="btn-write" @click="fnGoWrite">✏️ 글쓰기</button>
                        </div>

                        <!-- 태그 검색 상태 -->
                        <div class="tag-search-banner" v-if="tagKeyword">
                            <div>
                                <strong>#{{ tagKeyword }}</strong> 태그 검색 결과
                            </div>
                            <button type="button" @click="fnClearTagSearch">전체 글 보기</button>
                        </div>

                        <!-- HOT 게시글 -->
                        <!-- 기존 hot-section 교체 -->
                        <div class="hot-section" v-if="!tagKeyword && hotList.length > 0">
                            <div class="hot-title">🔥 오늘의 인기글</div>
                            <div class="hot-list">
                                <div class="hot-card" v-for="(item, idx) in hotList" :key="item.BOARD_ID"
                                    @click="fnGoDetail(item.BOARD_ID)">
                                    <div class="hot-rank" :class="'rank-' + (idx+1)">{{ idx + 1 }}</div>
                                    <div class="hot-card-body">
                                        <div class="hot-card-title">{{ item.TITLE }}</div>
                                        <div class="hot-card-meta">
                                            ❤️ {{ item.LIKE_COUNT }}
                                            · 💬 {{ item.COMMENT_COUNT }}
                                            · 👁 {{ item.VIEW_COUNT }}
                                            · 🔥 {{ Math.round(item.hotScore) }}점
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
                            <span>🏆 커뮤니티 등급 안내</span>
                            <span>{{ showGradeInfo ? '▲' : '▼' }}</span>
                        </div>

                        <div class="grade-info-panel" v-if="showGradeInfo">
                            <div class="grade-row" v-for="g in gradeList" :key="g.code">
                                <span class="grade-icon">{{ g.icon }}</span>
                                <div class="grade-info">
                                    <span class="grade-name">{{ g.name }}</span>
                                    <span class="grade-desc">{{ g.desc }}</span>
                                </div>
                            </div>
                        </div>

                        <!-- 필터 -->
                        <div class="filter-bar">
                            <button class="cat-btn" :class="{ active: category === '' }"
                                @click="fnSetCat('')">전체</button>
                            <button class="cat-btn" :class="{ active: category === 'FREE' }"
                                @click="fnSetCat('FREE')">자유</button>
                            <button class="cat-btn" :class="{ active: category === 'REVIEW' }"
                                @click="fnSetCat('REVIEW')">후기</button>
                            <button class="cat-btn" :class="{ active: category === 'TIP' }"
                                @click="fnSetCat('TIP')">꿀팁</button>
                            <button class="cat-btn" :class="{ active: category === 'QNA' }"
                                @click="fnSetCat('QNA')">Q&A</button>

                            <select class="sort-select" v-model="sort" @change="fnSearch" :disabled="tagKeyword">
                                <option value="newest">최신순</option>
                                <option value="popular">추천순</option>
                                <option value="oldest">오래된순</option>
                            </select>

                            <div class="search-wrap">
                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnSearch">
                                <button @click="fnSearch">🔍</button>
                            </div>
                        </div>

                        <!-- 목록 -->
                        <div class="board-list" v-if="list.length > 0">
                            <div class="board-item" v-for="item in list" :key="item.BOARD_ID"
                                @click="fnGoDetail(item.BOARD_ID)">

                                <div class="item-left">
                                    <div class="item-cats">
                                        <span class="cat-tag" :class="'cat-' + item.CATEGORY">
                                            {{ fnCatLabel(item.CATEGORY) }}
                                        </span>
                                        <span class="hot-tag" v-if="item.IS_HOT === 'Y'">🔥 HOT</span>
                                        <span class="poll-tag" v-if="item.HAS_POLL === 'Y'">📊 투표</span>
                                    </div>

                                    <div class="item-title">{{ item.TITLE }}</div>

                                    <div class="item-meta">
                                        <span>{{ item.nickName || item.NICKNAME || item.USER_ID }}</span>
                                        <span class="meta-dot">·</span>
                                        <span>{{ fnFormatDate(item.CREATED_AT) }}</span>
                                        <span class="meta-dot" v-if="item.productName">·</span>
                                        <span style="color:var(--orange);" v-if="item.productName">
                                            🔗 {{ item.productName }}
                                        </span>
                                    </div>
                                </div>

                                <div class="item-stats">
                                    <div class="stat"><span class="stat-icon">👁</span>{{ item.VIEW_COUNT }}</div>
                                    <div class="stat"><span class="stat-icon">❤️</span>{{ item.LIKE_COUNT }}</div>
                                    <div class="stat"><span class="stat-icon">💬</span>{{ item.COMMENT_COUNT }}</div>
                                </div>

                                <div class="item-thumb" v-if="item.thumbUrl">
                                    <img :src="item.thumbUrl" alt="썸네일">
                                </div>
                            </div>
                        </div>

                        <div class="empty-state" v-else>
                            <div class="empty-emoji">🏕️</div>
                            <div v-if="tagKeyword">#{{ tagKeyword }} 태그의 게시글이 없습니다.</div>
                            <div v-else>게시글이 없습니다. 첫 번째 글을 남겨보세요!</div>
                        </div>

                        <!-- 페이지네이션 -->
                        <div class="pagination" v-if="!tagKeyword && totalPages > 1">
                            <button class="page-btn" :disabled="page === 1" @click="fnPage(page - 1)">‹</button>

                            <button class="page-btn" v-for="p in totalPages" :key="p" :class="{ active: p === page }"
                                @click="fnPage(p)">
                                {{ p }}
                            </button>

                            <button class="page-btn" :disabled="page === totalPages"
                                @click="fnPage(page + 1)">›</button>
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
                                        { code: 'SPROUT', icon: '🌱', name: '새싹', desc: '가입 후 기본 등급' },
                                        { code: 'EMBER', icon: '🔥', name: '불씨', desc: '게시글 5개 이상 또는 댓글 10개 이상' },
                                        { code: 'CAMPER', icon: '⛺', name: '캠퍼', desc: '게시글 20개 이상 또는 받은 추천 50개 이상' },
                                        { code: 'FIRE_CAMPER', icon: '🔥⛺', name: '불꽃캠퍼', desc: '게시글 50개 이상 또는 받은 추천 200개 이상' },
                                        { code: 'MODAK', icon: '🪵', name: '모닥불', desc: '게시글 100개 이상 또는 받은 추천 500개 이상' },
                                    ],
                                };
                            },

                            computed: {
                                totalPages() {
                                    return Math.max(1, Math.ceil(this.totalCount / this.pageSize));
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
                                },

                                fnSearch() {
                                    if (this.tagKeyword) {
                                        this.fnClearTagSearch();
                                        return;
                                    }

                                    this.page = 1;
                                    this.fnGetList();
                                },

                                fnPage(p) {
                                    if (p < 1 || p > this.totalPages) return;

                                    this.page = p;
                                    this.fnGetList();
                                    window.scrollTo(0, 0);
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
                                }
                            },

                            mounted() {
                                if (this.tagKeyword) {
                                    this.fnLoadByTag(this.tagKeyword);
                                } else {
                                    this.fnGetList();
                                }
                            }
                        }).mount('#app');
                    </script>
        </body>

        </html>