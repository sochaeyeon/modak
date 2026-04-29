<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 커뮤니티</title>
    <link rel="stylesheet" href="/css/common/font.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        :root {
            --cream: #F6F0E6;
            --cream2: #EDE5D4;
            --orange: #E8732A;
            --orange2: #C4621E;
            --brown: #2C1E0F;
            --brown2: #5C4230;
            --brown3: #8B6B4A;
            --brown4: #B89A7A;
            --white: #FFFDF8;
            --border: rgba(44,30,15,.1);
            --hot: #E8732A;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:var(--cream); color:var(--brown); font-family:'Apple SD Gothic Neo',sans-serif; }
        [v-cloak] { display:none; }

        .page-wrap { max-width:1100px; margin:0 auto; padding:32px 24px 80px; }

        /* 헤더 */
        .board-header { display:flex; align-items:flex-end; justify-content:space-between; margin-bottom:28px; }
        .board-title { font-size:28px; font-weight:800; color:var(--brown); letter-spacing:-.03em; }
        .board-title span { color:var(--orange); }
        .btn-write {
            height:42px; padding:0 22px; border:none; border-radius:12px;
            background:var(--orange); color:#fff; font-size:14px; font-weight:700;
            cursor:pointer; transition:background .18s;
        }
        .btn-write:hover { background:var(--orange2); }

        /* HOT */
        .hot-section { margin-bottom:28px; }
        .hot-title {
            display:flex; align-items:center; gap:8px;
            font-size:13px; font-weight:800; color:var(--orange);
            margin-bottom:12px; letter-spacing:.04em;
        }
        .hot-list { display:flex; gap:12px; overflow-x:auto; padding-bottom:6px; }
        .hot-list::-webkit-scrollbar { height:4px; }
        .hot-list::-webkit-scrollbar-thumb { background:var(--brown4); border-radius:999px; }
        .hot-card {
            flex-shrink:0; width:220px; padding:16px; border-radius:14px;
            background:var(--white); border:1.5px solid var(--border);
            cursor:pointer; transition:border-color .18s, box-shadow .18s;
        }
        .hot-card:hover { border-color:var(--orange); box-shadow:0 4px 14px rgba(232,115,42,.12); }
        .hot-badge {
            display:inline-block; padding:2px 8px; border-radius:999px;
            background:rgba(232,115,42,.12); color:var(--orange);
            font-size:10px; font-weight:800; margin-bottom:8px;
        }
        .hot-card-title { font-size:13px; font-weight:700; color:var(--brown); line-height:1.45; margin-bottom:8px;
            display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
        .hot-card-meta { font-size:11px; color:var(--brown3); }

        /* 필터/검색 */
        .filter-bar {
            display:flex; align-items:center; gap:10px;
            margin-bottom:18px; flex-wrap:wrap;
        }
        .cat-btn {
            height:34px; padding:0 16px; border:1.5px solid var(--border);
            border-radius:999px; background:var(--white); color:var(--brown3);
            font-size:12px; font-weight:700; cursor:pointer; transition:all .18s;
        }
        .cat-btn.active, .cat-btn:hover {
            border-color:var(--orange); background:var(--orange); color:#fff;
        }
        .search-wrap {
            margin-left:auto; display:flex; align-items:center;
            border:1.5px solid var(--border); border-radius:10px;
            background:var(--white); overflow:hidden; height:36px;
        }
        .search-wrap input {
            border:none; outline:none; background:transparent;
            padding:0 12px; font-size:13px; color:var(--brown); width:200px;
        }
        .search-wrap button {
            width:38px; height:36px; border:none; background:var(--orange);
            color:#fff; font-size:15px; cursor:pointer;
        }
        .sort-select {
            height:36px; padding:0 10px; border:1.5px solid var(--border);
            border-radius:10px; background:var(--white); color:var(--brown3);
            font-size:12px; font-weight:700; cursor:pointer; outline:none;
        }

        /* 게시글 목록 */
        .board-list { display:flex; flex-direction:column; gap:0; }
        .board-item {
            display:flex; align-items:center; gap:16px;
            padding:18px 16px; border-bottom:1px solid var(--border);
            cursor:pointer; transition:background .15s;
        }
        .board-item:hover { background:rgba(232,115,42,.04); }
        .board-item:first-child { border-top:1.5px solid var(--brown4); }

        .item-left { flex:1; min-width:0; }
        .item-cats { display:flex; align-items:center; gap:8px; margin-bottom:6px; }
        .cat-tag {
            padding:2px 8px; border-radius:999px; font-size:11px; font-weight:700;
        }
        .cat-FREE    { background:rgba(92,66,48,.1);    color:#5c4230; }
        .cat-REVIEW  { background:rgba(59,165,93,.1);   color:#2e7d32; }
        .cat-TIP     { background:rgba(47,111,216,.1);  color:#2f6fd8; }
        .cat-QNA     { background:rgba(232,115,42,.12); color:var(--orange2); }
        .hot-tag {
            padding:2px 8px; border-radius:999px; font-size:10px; font-weight:800;
            background:var(--orange); color:#fff; animation:pulse 2s infinite;
        }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.7} }
        .poll-tag {
            padding:2px 8px; border-radius:999px; font-size:10px; font-weight:700;
            background:rgba(101,74,255,.1); color:#6f42c1;
        }
        .item-title {
            font-size:15px; font-weight:600; color:var(--brown); margin-bottom:6px;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        .item-meta {
            display:flex; align-items:center; gap:10px; font-size:12px; color:var(--brown3);
        }
        .meta-dot { color:var(--brown4); }
        .item-stats { display:flex; align-items:center; gap:14px; flex-shrink:0; }
        .stat { display:flex; align-items:center; gap:4px; font-size:12px; color:var(--brown3); }
        .stat-icon { font-size:13px; }
        .item-thumb {
            width:72px; height:72px; border-radius:10px; overflow:hidden;
            flex-shrink:0; background:var(--cream2);
        }
        .item-thumb img { width:100%; height:100%; object-fit:cover; }

        /* 페이지네이션 */
        .pagination {
            display:flex; justify-content:center; gap:6px; margin-top:32px;
        }
        .page-btn {
            width:36px; height:36px; border:1.5px solid var(--border);
            border-radius:10px; background:var(--white); color:var(--brown3);
            font-size:13px; font-weight:700; cursor:pointer; transition:all .18s;
        }
        .page-btn.active, .page-btn:hover {
            background:var(--orange); border-color:var(--orange); color:#fff;
        }
        .page-btn:disabled { opacity:.35; cursor:not-allowed; }

        /* 빈 목록 */
        .empty-state {
            padding:80px 20px; text-align:center; color:var(--brown3);
            font-size:14px; font-weight:600;
        }
        .empty-emoji { font-size:48px; margin-bottom:16px; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
<div class="page-wrap">

    <!-- 헤더 -->
    <div class="board-header">
        <div>
            <div class="board-title">🔥 모닥<span>커뮤니티</span></div>
            <div style="font-size:13px;color:var(--brown3);margin-top:4px;">캠퍼들의 이야기가 모이는 곳</div>
        </div>
        <button class="btn-write" @click="fnGoWrite">✏️ 글쓰기</button>
    </div>

    <!-- HOT 게시글 -->
    <div class="hot-section" v-if="hotList.length > 0">
        <div class="hot-title">🔥 HOT 게시글</div>
        <div class="hot-list">
            <div class="hot-card" v-for="item in hotList" :key="item.BOARD_ID"
                 @click="fnGoDetail(item.BOARD_ID)">
                <div class="hot-badge">HOT 🔥</div>
                <div class="hot-card-title">{{ item.TITLE }}</div>
                <div class="hot-card-meta">
                    ❤️ {{ item.LIKE_COUNT }} · 💬 {{ item.COMMENT_COUNT }} · 👁 {{ item.VIEW_COUNT }}
                </div>
            </div>
        </div>
    </div>

    <!-- 필터 -->
    <div class="filter-bar">
        <button class="cat-btn" :class="{ active: category === '' }" @click="fnSetCat('')">전체</button>
        <button class="cat-btn" :class="{ active: category === 'FREE' }" @click="fnSetCat('FREE')">자유</button>
        <button class="cat-btn" :class="{ active: category === 'REVIEW' }" @click="fnSetCat('REVIEW')">후기</button>
        <button class="cat-btn" :class="{ active: category === 'TIP' }" @click="fnSetCat('TIP')">꿀팁</button>
        <button class="cat-btn" :class="{ active: category === 'QNA' }" @click="fnSetCat('QNA')">Q&A</button>

        <select class="sort-select" v-model="sort" @change="fnSearch">
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
                    <span>{{ item.nickName }}</span>
                    <span class="meta-dot">·</span>
                    <span>{{ fnFormatDate(item.CREATED_AT) }}</span>
                    <span class="meta-dot" v-if="item.productName">·</span>
                    <span style="color:var(--orange);" v-if="item.productName">🔗 {{ item.productName }}</span>
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
        <div>게시글이 없습니다. 첫 번째 글을 남겨보세요!</div>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination" v-if="totalPages > 1">
        <button class="page-btn" :disabled="page === 1" @click="fnPage(page - 1)">‹</button>
        <button class="page-btn" v-for="p in totalPages" :key="p"
                :class="{ active: p === page }" @click="fnPage(p)">{{ p }}</button>
        <button class="page-btn" :disabled="page === totalPages" @click="fnPage(page + 1)">›</button>
    </div>

</div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            list: [], hotList: [],
            totalCount: 0, page: 1, pageSize: 15,
            category: '', sort: 'newest', keyword: ''
        };
    },
    computed: {
        totalPages() { return Math.max(1, Math.ceil(this.totalCount / this.pageSize)); }
    },
    methods: {
        fnGetList() {
            $.ajax({
                url: '/board/list.dox', type: 'POST',
                data: { page: this.page, pageSize: this.pageSize,
                        category: this.category, sort: this.sort, keyword: this.keyword },
                success: (res) => {
                    if (res.result === 'success') {
                        this.list       = res.list      || [];
                        this.totalCount = res.totalCount || 0;
                        this.hotList    = res.hotList   || [];
                    }
                }
            });
        },
        fnSetCat(cat)  { this.category = cat; this.page = 1; this.fnGetList(); },
        fnSearch()     { this.page = 1; this.fnGetList(); },
        fnPage(p)      { this.page = p; this.fnGetList(); window.scrollTo(0, 0); },
        fnGoWrite()    { location.href = '/board/write.do'; },
        fnGoDetail(id) { location.href = '/board/detail.do?boardId=' + id; },
        fnCatLabel(c) {
            return { FREE:'자유', REVIEW:'후기', TIP:'꿀팁', QNA:'Q&A' }[c] || c;
        },
        fnFormatDate(dt) {
            if (!dt) return '';
            const d = new Date(dt);
            const now = new Date();
            const diff = (now - d) / 1000;
            if (diff < 60)    return '방금 전';
            if (diff < 3600)  return Math.floor(diff / 60) + '분 전';
            if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
            return dt.toString().slice(0, 10);
        }
    },
    mounted() { this.fnGetList(); }
}).mount('#app');
</script>
</body>
</html>
