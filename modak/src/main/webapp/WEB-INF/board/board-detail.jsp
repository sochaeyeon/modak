<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page deferredSyntaxAllowedAsLiteral="true" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>게시글 - 모닥모닥</title>
            <link rel="stylesheaet" href="/css/common/font.css">
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
                    --border: rgba(44, 30, 15, .1);
                    --green: #2e7d32;
                    --blue: #2f6fd8;
                    --purple: #6f42c1;
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    background: var(--cream);
                    color: var(--brown);
                    font-family: 'Apple SD Gothic Neo', sans-serif;
                }

                [v-cloak] {
                    display: none;
                }

                .page-wrap {
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 32px 24px 80px;
                }

                /* 뒤로 */
                .back-btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    color: var(--brown3);
                    font-size: 13px;
                    font-weight: 700;
                    cursor: pointer;
                    margin-bottom: 20px;
                    background: none;
                    border: none;
                    padding: 0;
                    transition: color .18s;
                }

                .back-btn:hover {
                    color: var(--orange);
                }

                /* 카드 */
                .card {
                    background: var(--white);
                    border: 1.5px solid var(--border);
                    border-radius: 18px;
                    overflow: hidden;
                    margin-bottom: 16px;
                }

                .card-body {
                    padding: 28px;
                }

                /* 게시글 헤더 */
                .post-cats {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-bottom: 12px;
                }

                .cat-tag {
                    padding: 3px 10px;
                    border-radius: 999px;
                    font-size: 11px;
                    font-weight: 800;
                }

                .cat-FREE {
                    background: rgba(92, 66, 48, .1);
                    color: #5c4230;
                }

                .cat-REVIEW {
                    background: rgba(46, 125, 50, .1);
                    color: var(--green);
                }

                .cat-TIP {
                    background: rgba(47, 111, 216, .1);
                    color: var(--blue);
                }

                .cat-QNA {
                    background: rgba(232, 115, 42, .12);
                    color: var(--orange2);
                }

                .hot-badge {
                    padding: 3px 10px;
                    border-radius: 999px;
                    font-size: 11px;
                    font-weight: 800;
                    background: var(--orange);
                    color: #fff;
                }

                .poll-badge {
                    padding: 3px 10px;
                    border-radius: 999px;
                    font-size: 11px;
                    font-weight: 800;
                    background: rgba(111, 66, 193, .12);
                    color: var(--purple);
                }

                .post-title {
                    font-size: 22px;
                    font-weight: 800;
                    color: var(--brown);
                    line-height: 1.4;
                    margin-bottom: 14px;
                }

                .post-meta {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-size: 12px;
                    color: var(--brown3);
                    margin-bottom: 20px;
                    padding-bottom: 18px;
                    border-bottom: 1px solid var(--border);
                }

                .post-meta .dot {
                    color: var(--brown4);
                }

                .author-avatar {
                    width: 30px;
                    height: 30px;
                    border-radius: 50%;
                    background: var(--cream2);
                    overflow: hidden;
                    flex-shrink: 0;
                }

                .author-avatar img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .post-content {
                    font-size: 15px;
                    line-height: 1.85;
                    color: var(--brown2);
                    white-space: pre-wrap;
                    min-height: 60px;
                    margin-bottom: 20px;
                }

                /* 이미지 갤러리 */
                .img-gallery {
                    display: grid;
                    gap: 8px;
                    margin-bottom: 20px;
                }

                .img-gallery.one {
                    grid-template-columns: 1fr;
                }

                .img-gallery.two {
                    grid-template-columns: 1fr 1fr;
                }

                .img-gallery.many {
                    grid-template-columns: repeat(3, 1fr);
                }

                .gallery-img {
                    width: 100%;
                    border-radius: 10px;
                    overflow: hidden;
                    aspect-ratio: 4/3;
                    background: var(--cream2);
                }

                .gallery-img img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    cursor: pointer;
                }

                /* 제품 링크 */
                .product-link {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                    padding: 14px 16px;
                    border: 1.5px solid rgba(232, 115, 42, .3);
                    border-radius: 14px;
                    background: rgba(232, 115, 42, .04);
                    margin-bottom: 20px;
                    cursor: pointer;
                    transition: border-color .18s;
                }

                .product-link:hover {
                    border-color: var(--orange);
                }

                .product-link img {
                    width: 56px;
                    height: 56px;
                    border-radius: 10px;
                    object-fit: cover;
                }

                .product-link-badge {
                    display: inline-block;
                    padding: 2px 7px;
                    border-radius: 999px;
                    background: var(--orange);
                    color: #fff;
                    font-size: 10px;
                    font-weight: 800;
                    margin-bottom: 4px;
                }

                /* 투표 */
                .poll-card {
                    border: 1.5px solid rgba(111, 66, 193, .2);
                    border-radius: 14px;
                    padding: 20px;
                    background: rgba(111, 66, 193, .04);
                    margin-bottom: 20px;
                }

                .poll-question {
                    font-size: 15px;
                    font-weight: 800;
                    color: var(--brown);
                    margin-bottom: 16px;
                }

                .poll-option {
                    position: relative;
                    margin-bottom: 10px;
                    border-radius: 12px;
                    overflow: hidden;
                    cursor: pointer;
                    border: 1.5px solid var(--border);
                    background: #fff;
                    transition: border-color .18s;
                }

                .poll-option:hover:not(.voted) {
                    border-color: var(--purple);
                }

                .poll-option.selected {
                    border-color: var(--purple);
                }

                .poll-bar {
                    position: absolute;
                    top: 0;
                    left: 0;
                    height: 100%;
                    background: rgba(111, 66, 193, .1);
                    border-radius: 12px;
                    transition: width .5s ease;
                }

                .poll-option-inner {
                    position: relative;
                    z-index: 1;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 12px 16px;
                }

                .poll-option-text {
                    font-size: 13px;
                    font-weight: 700;
                    color: var(--brown);
                }

                .poll-pct {
                    font-size: 12px;
                    font-weight: 800;
                    color: var(--purple);
                }

                .poll-meta {
                    font-size: 11px;
                    color: var(--brown3);
                    margin-top: 10px;
                    text-align: right;
                }

                /* 반응 버튼 */
                .reaction-bar {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding-top: 18px;
                    border-top: 1px solid var(--border);
                }

                .react-btn {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    height: 38px;
                    padding: 0 16px;
                    border-radius: 10px;
                    border: 1.5px solid var(--border);
                    background: #fff;
                    color: var(--brown3);
                    font-size: 13px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all .18s;
                }

                .react-btn:hover {
                    border-color: var(--orange);
                    color: var(--orange);
                }

                .react-btn.liked {
                    border-color: var(--orange);
                    background: rgba(232, 115, 42, .1);
                    color: var(--orange2);
                }

                .react-btn.disliked {
                    border-color: #e74c3c;
                    background: rgba(231, 76, 60, .08);
                    color: #e74c3c;
                }

                .view-count {
                    margin-left: auto;
                    font-size: 12px;
                    color: var(--brown4);
                }

                /* 신고/수정/삭제 */
                .post-actions {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-left: auto;
                }

                .action-btn {
                    height: 32px;
                    padding: 0 12px;
                    border-radius: 8px;
                    border: 1.5px solid var(--border);
                    background: #fff;
                    color: var(--brown3);
                    font-size: 12px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all .18s;
                }

                .action-btn:hover {
                    border-color: var(--brown3);
                    color: var(--brown);
                }

                .action-btn.danger:hover {
                    border-color: #e74c3c;
                    color: #e74c3c;
                }

                /* 댓글 */
                .comments-head {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    font-size: 15px;
                    font-weight: 800;
                    color: var(--brown);
                    padding: 18px 24px 0;
                }

                .comment-count-badge {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 24px;
                    height: 24px;
                    border-radius: 50%;
                    background: var(--orange);
                    color: #fff;
                    font-size: 12px;
                    font-weight: 800;
                }

                .comment-list {
                    padding: 12px 24px 8px;
                }

                .comment-item {
                    padding: 16px 0;
                    border-bottom: 1px solid var(--border);
                }

                .comment-item:last-child {
                    border-bottom: none;
                }

                .comment-item.reply {
                    padding-left: 32px;
                    background: rgba(44, 30, 15, .02);
                    border-radius: 10px;
                    margin-top: 4px;
                }

                .comment-meta {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-bottom: 8px;
                    font-size: 12px;
                    color: var(--brown3);
                }

                .comment-avatar {
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    background: var(--cream2);
                    overflow: hidden;
                    flex-shrink: 0;
                }

                .comment-avatar img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .comment-content {
                    font-size: 14px;
                    color: var(--brown2);
                    line-height: 1.7;
                    margin-bottom: 10px;
                }

                .comment-actions {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .comment-like-btn {
                    display: flex;
                    align-items: center;
                    gap: 4px;
                    font-size: 12px;
                    color: var(--brown3);
                    background: none;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                    transition: color .18s;
                }

                .comment-like-btn:hover,
                .comment-like-btn.liked {
                    color: var(--orange);
                }

                .reply-btn {
                    font-size: 12px;
                    color: var(--brown3);
                    background: none;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                    transition: color .18s;
                }

                .reply-btn:hover {
                    color: var(--orange);
                }

                .comment-delete {
                    font-size: 11px;
                    color: var(--brown4);
                    background: none;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                    margin-left: auto;
                    transition: color .18s;
                }

                .comment-delete:hover {
                    color: #e74c3c;
                }

                /* 댓글 입력 */
                .comment-write {
                    padding: 16px 24px;
                    border-top: 1px solid var(--border);
                }

                .reply-indicator {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 8px 12px;
                    border-radius: 8px;
                    background: rgba(232, 115, 42, .08);
                    margin-bottom: 8px;
                    font-size: 12px;
                    color: var(--orange2);
                    font-weight: 700;
                }

                .comment-input-row {
                    display: flex;
                    gap: 10px;
                    align-items: flex-end;
                }

                .comment-textarea {
                    flex: 1;
                    padding: 12px 14px;
                    border: 1.5px solid var(--border);
                    border-radius: 12px;
                    background: #fff;
                    font-size: 14px;
                    font-family: inherit;
                    color: var(--brown);
                    resize: none;
                    outline: none;
                    transition: border-color .18s;
                    min-height: 56px;
                }

                .comment-textarea:focus {
                    border-color: var(--orange);
                    box-shadow: 0 0 0 3px rgba(232, 115, 42, .1);
                }

                .btn-comment-submit {
                    height: 56px;
                    padding: 0 20px;
                    border: none;
                    border-radius: 12px;
                    background: var(--orange);
                    color: #fff;
                    font-size: 13px;
                    font-weight: 800;
                    cursor: pointer;
                    flex-shrink: 0;
                    transition: background .18s;
                }

                .btn-comment-submit:hover {
                    background: var(--orange2);
                }

                /* 이미지 라이트박스 */
                .lightbox {
                    position: fixed;
                    inset: 0;
                    z-index: 9999;
                    background: rgba(0, 0, 0, .88);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .lightbox img {
                    max-width: 90vw;
                    max-height: 88vh;
                    border-radius: 12px;
                }

                .lightbox-close {
                    position: fixed;
                    top: 20px;
                    right: 24px;
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, .15);
                    border: none;
                    color: #fff;
                    font-size: 20px;
                    cursor: pointer;
                }

                /* 신고 모달 */
                .modal-bg {
                    position: fixed;
                    inset: 0;
                    z-index: 9000;
                    background: rgba(0, 0, 0, .45);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .modal-box {
                    background: #fff;
                    border-radius: 18px;
                    padding: 28px;
                    width: 360px;
                    max-width: 90vw;
                    box-shadow: 0 20px 50px rgba(0, 0, 0, .2);
                }

                .modal-title {
                    font-size: 16px;
                    font-weight: 800;
                    color: var(--brown);
                    margin-bottom: 14px;
                }

                .modal-select {
                    width: 100%;
                    padding: 12px 14px;
                    border: 1.5px solid var(--border);
                    border-radius: 10px;
                    font-size: 13px;
                    color: var(--brown);
                    margin-bottom: 14px;
                    outline: none;
                }

                .modal-actions {
                    display: flex;
                    gap: 10px;
                    justify-content: flex-end;
                }

                .modal-cancel,
                .modal-confirm {
                    height: 38px;
                    padding: 0 18px;
                    border-radius: 10px;
                    font-size: 13px;
                    font-weight: 700;
                    cursor: pointer;
                }

                .modal-cancel {
                    border: 1.5px solid var(--border);
                    background: #fff;
                    color: var(--brown3);
                }

                .modal-confirm {
                    border: none;
                    background: var(--orange);
                    color: #fff;
                }

                /* 토스트 */
                .toast {
                    position: fixed;
                    left: 50%;
                    bottom: 32px;
                    transform: translateX(-50%) translateY(20px);
                    padding: 12px 22px;
                    border-radius: 999px;
                    background: var(--brown);
                    color: var(--white);
                    font-size: 13px;
                    opacity: 0;
                    pointer-events: none;
                    transition: .25s ease;
                    z-index: 99999;
                }

                .toast.show {
                    opacity: 1;
                    transform: translateX(-50%) translateY(0);
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">
                        <button class="back-btn" @click="fnGoBack">← 목록으로</button>

                        <!-- 게시글 본문 -->
                        <div class="card" v-if="board">
                            <div class="card-body">

                                <!-- 카테고리/뱃지 -->
                                <div class="post-cats">
                                    <span class="cat-tag" :class="'cat-' + board.CATEGORY">{{ fnCatLabel(board.CATEGORY)
                                        }}</span>
                                    <span class="hot-badge" v-if="board.IS_HOT === 'Y'">🔥 HOT</span>
                                    <span class="poll-badge" v-if="board.HAS_POLL === 'Y'">📊 투표</span>
                                    <div class="post-actions">
                                        <template v-if="isMyPost">
                                            <button class="action-btn" @click="fnGoEdit">수정</button>
                                            <button class="action-btn danger" @click="fnDeletePost">삭제</button>
                                        </template>
                                        <button class="action-btn danger" @click="showReportModal = true"
                                            v-else>신고</button>
                                    </div>
                                </div>

                                <!-- 제목 -->
                                <div class="post-title">{{ board.TITLE }}</div>

                                <!-- 메타 -->
                                <div class="post-meta">
                                    <div class="author-avatar">
                                        <img v-if="board.profileImg" :src="board.profileImg" alt="프로필">
                                        <div v-else
                                            style="width:100%;height:100%;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:14px;">
                                            🏕</div>
                                    </div>
                                    <span style="font-weight:700;">{{ board.nickName }}</span>
                                    <span class="dot">·</span>
                                    <span>{{ fnFormatDate(board.CREATED_AT) }}</span>
                                    <span class="dot">·</span>
                                    <span>👁 {{ board.VIEW_COUNT }}</span>
                                </div>

                                <!-- 본문 -->
                                <div class="post-content">{{ board.CONTENT }}</div>

                                <!-- 이미지 갤러리 -->
                                <div v-if="imgList.length > 0" class="img-gallery"
                                    :class="imgList.length === 1 ? 'one' : imgList.length === 2 ? 'two' : 'many'">
                                    <div class="gallery-img" v-for="img in imgList" :key="img.imgId">
                                        <img :src="img.imgUrl" alt="이미지" @click="fnOpenLightbox(img.imgUrl)">
                                    </div>
                                </div>

                                <!-- 제품 링크 -->
                                <div class="product-link" v-if="board.productName"
                                    @click="fnGoProduct(board.PRODUCT_ID)">
                                    <img v-if="board.productImg" :src="board.productImg" alt="제품">
                                    <div v-else
                                        style="width:56px;height:56px;border-radius:10px;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:22px;">
                                        ⛺</div>
                                    <div>
                                        <div class="product-link-badge">🔗 연관 제품</div>
                                        <div style="font-size:14px;font-weight:700;color:var(--brown);">{{
                                            board.productName }}</div>
                                        <div style="font-size:12px;color:var(--brown3);">{{
                                            Number(board.productPrice||0).toLocaleString() }}원</div>
                                    </div>
                                </div>

                                <!-- 투표 -->
                                <div class="poll-card" v-if="poll">
                                    <div class="poll-question">📊 {{ poll.QUESTION }}</div>
                                    <div v-for="opt in pollOptions" :key="opt.optionId" class="poll-option"
                                        :class="{ selected: poll.myOptionId == opt.optionId, voted: poll.myVoted }"
                                        @click="fnVote(opt.optionId)">
                                        <div class="poll-bar" :style="{ width: fnPollPct(opt) + '%' }"></div>
                                        <div class="poll-option-inner">
                                            <span class="poll-option-text">
                                                {{ opt.optionText }}
                                                <span v-if="poll.myOptionId == opt.optionId"
                                                    style="color:var(--purple);">✔</span>
                                            </span>
                                            <span class="poll-pct" v-if="poll.myVoted">{{ fnPollPct(opt) }}%</span>
                                        </div>
                                    </div>
                                    <div class="poll-meta">
                                        총 {{ poll.totalVotes || 0 }}명 참여
                                        <span v-if="poll.END_DATE"> · 마감 {{ poll.END_DATE }}</span>
                                    </div>
                                </div>

                                <!-- 반응 버튼 -->
                                <div class="reaction-bar">
                                    <button class="react-btn" :class="{ liked: myLiked }"
                                        @click="fnReact('LIKE', 'BOARD')">
                                        ❤️ 추천 {{ board.LIKE_COUNT }}
                                    </button>
                                    <button class="react-btn" :class="{ disliked: myDisliked }"
                                        @click="fnReact('DISLIKE', 'BOARD')">
                                        👎 싫어요 {{ board.DISLIKE_COUNT }}
                                    </button>
                                    <span class="view-count">조회 {{ board.VIEW_COUNT }}</span>
                                </div>
                            </div>

                            <!-- 댓글 영역 -->
                            <div class="comments-head">
                                <span>댓글</span>
                                <span class="comment-count-badge">{{ commentList.length }}</span>
                            </div>

                            <div class="comment-list">
                                <div v-if="commentList.length === 0"
                                    style="padding:24px 0;text-align:center;color:var(--brown3);font-size:13px;">
                                    첫 번째 댓글을 남겨보세요 🔥
                                </div>
                                <template v-for="comment in topComments" :key="comment.COMMENT_ID">
                                    <!-- 원댓글 -->
                                    <div class="comment-item">
                                        <div class="comment-meta">
                                            <div class="comment-avatar">
                                                <img v-if="comment.profileImg" :src="comment.profileImg">
                                                <div v-else
                                                    style="width:100%;height:100%;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:12px;">
                                                    🏕</div>
                                            </div>
                                            <span style="font-weight:700;">{{ comment.nickName }}</span>
                                            <span style="color:var(--brown4);">·</span>
                                            <span>{{ fnFormatDate(comment.CREATED_AT) }}</span>
                                        </div>
                                        <div class="comment-content">{{ comment.CONTENT }}</div>
                                        <div class="comment-actions">
                                            <button class="comment-like-btn"
                                                :class="{ liked: isCommentLiked(comment.COMMENT_ID) }"
                                                @click="fnReact('LIKE', 'COMMENT', comment.COMMENT_ID)">
                                                ❤️ {{ comment.LIKE_COUNT }}
                                            </button>
                                            <button class="reply-btn" @click="fnSetReply(comment)">↩ 답글</button>
                                            <button class="reply-btn" @click="fnReportComment(comment.COMMENT_ID)">🚩
                                                신고</button>
                                            <button class="comment-delete" v-if="isMyComment(comment.USER_ID)"
                                                @click="fnDeleteComment(comment.COMMENT_ID)">삭제</button>
                                        </div>
                                    </div>
                                    <!-- 대댓글 -->
                                    <div class="comment-item reply" v-for="reply in getReplies(comment.COMMENT_ID)"
                                        :key="reply.COMMENT_ID">
                                        <div class="comment-meta">
                                            <span style="color:var(--orange);margin-right:4px;">↩</span>
                                            <div class="comment-avatar">
                                                <img v-if="reply.profileImg" :src="reply.profileImg">
                                                <div v-else
                                                    style="width:100%;height:100%;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:12px;">
                                                    🏕</div>
                                            </div>
                                            <span style="font-weight:700;">{{ reply.nickName }}</span>
                                            <span style="color:var(--brown4);">·</span>
                                            <span>{{ fnFormatDate(reply.CREATED_AT) }}</span>
                                        </div>
                                        <div class="comment-content">{{ reply.CONTENT }}</div>
                                        <div class="comment-actions">
                                            <button class="comment-like-btn"
                                                :class="{ liked: isCommentLiked(reply.COMMENT_ID) }"
                                                @click="fnReact('LIKE', 'COMMENT', reply.COMMENT_ID)">
                                                ❤️ {{ reply.LIKE_COUNT }}
                                            </button>
                                            <button class="comment-delete" v-if="isMyComment(reply.USER_ID)"
                                                @click="fnDeleteComment(reply.COMMENT_ID)">삭제</button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <!-- 댓글 입력 -->
                            <div class="comment-write">
                                <div class="reply-indicator" v-if="replyTarget">
                                    ↩ {{ replyTarget.nickName }}에게 답글
                                    <button @click="replyTarget = null"
                                        style="margin-left:auto;background:none;border:none;cursor:pointer;color:var(--orange2);">✕</button>
                                </div>
                                <div class="comment-input-row">
                                    <textarea class="comment-textarea" v-model="commentContent"
                                        :placeholder="replyTarget ? '답글을 입력하세요...' : '댓글을 입력하세요...'"
                                        @keydown.ctrl.enter="fnSubmitComment"></textarea>
                                    <button class="btn-comment-submit" @click="fnSubmitComment">
                                        등록
                                    </button>
                                </div>
                                <div style="font-size:11px;color:var(--brown4);margin-top:6px;">Ctrl+Enter로도 등록 가능</div>
                            </div>
                        </div>

                    </div>

                    <!-- 이미지 라이트박스 -->
                    <div class="lightbox" v-if="lightboxImg" @click.self="lightboxImg = null">
                        <button class="lightbox-close" @click="lightboxImg = null">✕</button>
                        <img :src="lightboxImg" alt="이미지">
                    </div>

                    <!-- 신고 모달 -->
                    <div class="modal-bg" v-if="showReportModal" @click.self="showReportModal = false">
                        <div class="modal-box">
                            <div class="modal-title">🚩 신고하기</div>
                            <select class="modal-select" v-model="reportReason">
                                <option value="">신고 사유를 선택해주세요</option>
                                <option value="스팸/광고">스팸/광고</option>
                                <option value="욕설/비방">욕설/비방</option>
                                <option value="음란물">음란물</option>
                                <option value="개인정보 침해">개인정보 침해</option>
                                <option value="기타">기타</option>
                            </select>
                            <div class="modal-actions">
                                <button class="modal-cancel" @click="showReportModal = false">취소</button>
                                <button class="modal-confirm" @click="fnSubmitReport">신고</button>
                            </div>
                        </div>
                    </div>

                    <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    boardId: new URLSearchParams(location.search).get('boardId'),
                                    board: null, imgList: [], commentList: [],
                                    poll: null, pollOptions: [],
                                    myReactions: [],
                                    commentContent: '', replyTarget: null,
                                    lightboxImg: null,
                                    showReportModal: false, reportReason: '',
                                    reportTarget: 'BOARD', reportCommentId: null,
                                    toastVisible: false, toastMsg: '',
                                    currentUserId: '${sessionScope.sessionId}' || null
                                };
                            },
                            computed: {
                                topComments() { return this.commentList.filter(c => !c.PARENT_ID); },
                                myLiked() { return this.myReactions.some(r => r.type === 'LIKE' && r.target === 'BOARD'); },
                                myDisliked() { return this.myReactions.some(r => r.type === 'DISLIKE' && r.target === 'BOARD'); },
                                isMyPost() {
                                    return this.board && this.currentUserId && this.board.USER_ID === this.currentUserId;
                                }
                            },
                            methods: {
                                fnLoad() {
                                    $.ajax({
                                        url: '/board/detail.dox', type: 'POST',
                                        data: { boardId: this.boardId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.board = res.board;
                                                this.imgList = res.imgList || [];
                                                this.commentList = res.commentList || [];
                                                this.poll = res.poll;
                                                this.pollOptions = res.pollOptions || [];
                                                this.myReactions = res.myReactions || [];
                                            }
                                        },
                                        // ★ 추가
                                        error: (xhr) => {
                                            console.error('상세 로드 실패:', xhr.responseText);
                                            this.showToast('데이터를 불러오지 못했습니다.');
                                        }
                                    });
                                },
                                getReplies(parentId) {
                                    return this.commentList.filter(c => c.PARENT_ID == parentId);
                                },
                                isCommentLiked(cid) {
                                    return this.myReactions.some(r => r.type === 'LIKE' && r.target === 'COMMENT' && r.commentId == cid);
                                },
                                isMyComment(userId) { return this.currentUserId && userId === this.currentUserId; },
                                fnCatLabel(c) { return { FREE: '자유', REVIEW: '후기', TIP: '꿀팁', QNA: 'Q&A' }[c] || c; },
                                fnFormatDate(dt) {
                                    if (!dt) return '';
                                    const d = new Date(dt), now = new Date();
                                    const diff = (now - d) / 1000;
                                    if (diff < 60) return '방금 전';
                                    if (diff < 3600) return Math.floor(diff / 60) + '분 전';
                                    if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
                                    return dt.toString().slice(0, 10);
                                },
                                fnPollPct(opt) {
                                    const total = Number(this.poll?.totalVotes || 0);
                                    if (total === 0) return 0;
                                    return Math.round(Number(opt.voteCount) / total * 100);
                                },
                                fnOpenLightbox(url) { this.lightboxImg = url; },
                                fnGoProduct(id) { location.href = '/product/detail.do?productId=' + id; },
                                fnGoEdit() { location.href = '/board/write.do?boardId=' + this.boardId; },

                                fnDeletePost() {
                                    if (!confirm('게시글을 삭제하시겠습니까?')) return;
                                    $.ajax({
                                        url: '/board/delete.dox', type: 'POST',
                                        data: { boardId: this.boardId },
                                        success: (res) => {
                                            if (res.result === 'success') { location.href = '/board/list.do'; }
                                            else this.showToast(res.message || '삭제 실패');
                                        }
                                    });
                                },
                                fnGoBack() {
                                    location.href = '/board/list.do';
                                },

                                fnVote(optionId) {
                                    if (this.poll?.myVoted) { this.showToast('이미 투표하셨습니다.'); return; }
                                    $.ajax({
                                        url: '/board/poll/vote.dox', type: 'POST',
                                        data: { pollId: this.poll.POLL_ID, optionId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.poll.myVoted = true;
                                                this.poll.myOptionId = optionId;
                                                const opt = this.pollOptions.find(o => o.optionId == optionId);
                                                if (opt) { opt.voteCount++; this.poll.totalVotes = (Number(this.poll.totalVotes || 0) + 1); }
                                                this.showToast('투표가 완료되었습니다! 🎉');
                                            } else this.showToast(res.message || '투표 실패');
                                        }
                                    });
                                },

                                fnReact(type, target, commentId) {
                                    $.ajax({
                                        url: '/board/reaction.dox', type: 'POST',
                                        data: { boardId: this.boardId, commentId: commentId || '', type, target },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.fnLoad(); // 간단히 재로드
                                            } else this.showToast(res.message || '로그인이 필요합니다.');
                                        }
                                    });
                                },

                                fnSetReply(comment) { this.replyTarget = comment; },

                                fnSubmitComment() {
                                    if (!this.commentContent.trim()) { this.showToast('댓글을 입력해주세요.'); return; }
                                    $.ajax({
                                        url: '/board/comment/write.dox', type: 'POST',
                                        data: {
                                            boardId: this.boardId,
                                            content: this.commentContent,
                                            parentId: this.replyTarget ? this.replyTarget.COMMENT_ID : ''
                                        },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.commentContent = '';
                                                this.replyTarget = null;
                                                this.fnLoad();
                                            } else this.showToast(res.message || '로그인이 필요합니다.');
                                        }
                                    });
                                },

                                fnDeleteComment(commentId) {
                                    if (!confirm('댓글을 삭제하시겠습니까?')) return;
                                    $.ajax({
                                        url: '/board/comment/delete.dox', type: 'POST',
                                        data: { commentId, boardId: this.boardId },
                                        success: (res) => {
                                            if (res.result === 'success') this.fnLoad();
                                            else this.showToast('삭제 실패');
                                        }
                                    });
                                },

                                fnReportComment(commentId) {
                                    this.reportTarget = 'COMMENT';
                                    this.reportCommentId = commentId;
                                    this.showReportModal = true;
                                },

                                fnSubmitReport() {
                                    if (!this.reportReason) { this.showToast('신고 사유를 선택해주세요.'); return; }
                                    $.ajax({
                                        url: '/board/report.dox', type: 'POST',
                                        data: {
                                            boardId: this.boardId,
                                            commentId: this.reportCommentId || '',
                                            target: this.reportTarget,
                                            reason: this.reportReason
                                        },
                                        success: (res) => {
                                            this.showReportModal = false;
                                            if (res.result === 'success') this.showToast('신고가 접수되었습니다.');
                                            else if (res.result === 'duplicate') this.showToast('이미 신고한 게시글입니다.');
                                            else this.showToast('로그인이 필요합니다.');
                                        }
                                    });
                                },

                                showToast(msg) {
                                    this.toastMsg = msg; this.toastVisible = true;
                                    setTimeout(() => { this.toastVisible = false; }, 2500);
                                }
                            },
                            mounted() { this.fnLoad(); }
                        }).mount('#app');
                    </script>
        </body>

        </html>