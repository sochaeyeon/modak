<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page deferredSyntaxAllowedAsLiteral="true" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>게시글 - 모닥모닥</title>
            <link rel="stylesheet" href="/css/common/font.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board-detail.css">
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="/js/page-change.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">

            <style>
                /* ── 미니 프로필 채팅 버튼 ───────────────────── */
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">
                        <button class="back-btn" @click="fnGoBack">
                            <i class="ri-arrow-left-line"></i>
                            목록으로
                        </button>

                        <!-- 게시글 본문 -->
                        <div class="card" v-if="board">
                            <div class="card-body">

                                <!-- 카테고리/뱃지 -->
                                <div class="post-cats">
                                    <span class="cat-tag" :class="'cat-' + board.CATEGORY">{{ fnCatLabel(board.CATEGORY)
                                        }}</span>
                                    <span class="hot-badge" v-if="board.IS_HOT === 'Y'">
                                        <i class="ri-fire-fill"></i> HOT
                                    </span>
                                    <span class="poll-badge" v-if="board.HAS_POLL === 'Y'">
                                        <i class="ri-bar-chart-box-fill"></i> 투표
                                    </span>
                                    <div class="post-menu-wrap">
                                        <button class="more-btn" type="button"
                                            @click.stop="postMenuOpen = !postMenuOpen">
                                            <i class="ri-more-2-fill"></i>
                                        </button>
                                        <div class="more-menu" v-if="postMenuOpen" @click.stop>
                                            <template v-if="isMyPost">
                                                <button type="button"
                                                    @click="postMenuOpen = false; fnGoEdit();">수정</button>
                                                <button type="button" class="danger"
                                                    @click="postMenuOpen = false; fnDeletePost();">삭제</button>
                                            </template>
                                            <template v-else>
                                                <button type="button" class="danger"
                                                    @click="postMenuOpen = false; showReportModal = true;">신고</button>
                                            </template>
                                        </div>
                                    </div>
                                </div>

                                <!-- 제목 -->
                                <div class="post-title">{{ board.TITLE }}</div>

                                <!-- 메타 -->
                                <div class="post-meta">
                                    <div class="author-avatar" @click="fnShowProfile($event, board.USER_ID)"
                                        style="cursor:pointer;">
                                        <img v-if="board.profileImg" :src="board.profileImg" alt="프로필">
                                        <div v-else class="default-avatar"><i class="ri-user-smile-line"></i></div>
                                    </div>
                                    <span style="font-weight:700;cursor:pointer;"
                                        @click="fnShowProfile($event, board.USER_ID)">
                                        {{ board.nickName }}
                                    </span>
                                    <span class="dot">·</span>
                                    <span>{{ fnFormatDate(board.CREATED_AT) }}</span>
                                    <span class="dot">·</span>
                                    <span class="meta-view"><i class="ri-eye-line"></i> {{ board.VIEW_COUNT }}</span>
                                </div>

                                <!-- 본문 -->
                                <div class="post-content editor-content" v-html="board.CONTENT"></div>

                                <!-- 태그 -->
                                <div class="tag-wrap" v-if="tagList.length > 0">
                                    <span class="board-tag" v-for="tag in tagList" :key="tag"
                                        @click="fnTagSearch(tag)">#{{ tag }}</span>
                                </div>

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
                                    <div v-else class="product-empty-img"><i class="ri-image-line"></i></div>
                                    <div>
                                        <div class="product-link-badge"><i class="ri-links-line"></i> 연관 제품</div>
                                        <div style="font-size:14px;font-weight:700;color:var(--brown);">{{
                                            board.productName }}</div>
                                        <div style="font-size:12px;color:var(--brown3);">{{
                                            Number(board.productPrice||0).toLocaleString() }}원</div>
                                    </div>
                                </div>

                                <!-- 투표 -->
                                <div class="poll-card" v-if="poll">
                                    <div class="poll-question">
                                        <i class="ri-bar-chart-box-fill"></i> {{ poll.QUESTION }}
                                    </div>
                                    <div v-for="opt in pollOptions" :key="opt.optionId" class="poll-option"
                                        :class="{ selected: poll.myOptionId == opt.optionId, voted: poll.myVoted }"
                                        @click="fnVote(opt.optionId)">
                                        <div class="poll-bar" :style="{ width: fnPollPct(opt) + '%' }"></div>
                                        <div class="poll-option-inner">
                                            <span class="poll-option-text">
                                                {{ opt.optionText }}
                                                <i v-if="poll.myOptionId == opt.optionId" class="ri-check-line"
                                                    style="color:var(--purple);font-size:15px;margin-left:4px;"></i>
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
                                        <i class="ri-heart-3-fill"></i> 추천 {{ board.LIKE_COUNT }}
                                    </button>
                                    <button class="bookmark-btn" :class="{ active: bookmarked }" @click="fnBookmark">
                                        <i :class="bookmarked ? 'ri-star-fill' : 'ri-star-line'"></i>
                                        {{ bookmarked ? '스크랩됨' : '스크랩' }}
                                    </button>
                                    <button class="react-btn" :class="{ disliked: myDisliked }"
                                        @click="fnReact('DISLIKE', 'BOARD')">
                                        <i class="ri-thumb-down-fill"></i> 싫어요 {{ board.DISLIKE_COUNT }}
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
                                    첫 번째 댓글을 남겨보세요
                                </div>

                                <template v-for="comment in topComments" :key="comment.COMMENT_ID">
                                    <!-- 원댓글 -->
                                    <div class="comment-item" :ref="'comment-' + comment.COMMENT_ID">
                                        <div class="comment-meta">
                                            <div class="comment-avatar" @click="fnShowProfile($event, comment.USER_ID)"
                                                style="cursor:pointer;">
                                                <img v-if="comment.profileImg" :src="comment.profileImg">
                                                <div v-else class="default-avatar small"><i
                                                        class="ri-user-smile-line"></i></div>
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
                                                <i class="ri-heart-3-fill"></i> {{ comment.LIKE_COUNT }}
                                            </button>
                                            <button class="reply-btn" @click="fnSetReply(comment)">
                                                <i class="ri-reply-line"></i> 답글
                                            </button>
                                            <button class="reply-btn"
                                                v-if="getAllDescendants(comment.COMMENT_ID).length > 0"
                                                @click="fnToggleReplies(comment.COMMENT_ID)">
                                                {{ openReplies[comment.COMMENT_ID]
                                                ? '답글 닫기'
                                                : '답글 ' + getAllDescendants(comment.COMMENT_ID).length + '개' }}
                                                <i
                                                    :class="openReplies[comment.COMMENT_ID] ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
                                            </button>
                                            <div class="comment-menu-wrap">
                                                <button class="comment-more-btn-icon" type="button"
                                                    @click.stop="fnToggleCommentMenu(comment.COMMENT_ID)">
                                                    <i class="ri-more-2-fill"></i>
                                                </button>
                                                <div class="comment-more-menu"
                                                    v-if="openCommentMenuId === comment.COMMENT_ID" @click.stop>
                                                    <button type="button" v-if="!isMyComment(comment.USER_ID)"
                                                        class="danger"
                                                        @click="openCommentMenuId = null; fnReportComment(comment.COMMENT_ID);">신고</button>
                                                    <button type="button" v-if="isMyComment(comment.USER_ID)"
                                                        class="danger"
                                                        @click="openCommentMenuId = null; fnDeleteComment(comment.COMMENT_ID);">삭제</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="inline-reply-box"
                                            v-if="replyTarget && replyTarget.COMMENT_ID === comment.COMMENT_ID">
                                            <textarea class="comment-textarea" v-model="commentContent"
                                                placeholder="답글을 입력하세요..."
                                                @keydown.ctrl.enter="fnSubmitComment"></textarea>
                                            <div style="display:flex;justify-content:flex-end;gap:8px;margin-top:8px;">
                                                <button class="reply-btn"
                                                    @click="replyTarget = null; commentContent = ''">취소</button>
                                                <button class="btn-comment-submit small" @click="fnSubmitComment">답글
                                                    등록</button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 대댓글 -->
                                    <div class="reply-thread-fold" :class="{
        open: openReplies[comment.COMMENT_ID],
        closing: closingReplies[comment.COMMENT_ID]
    }" v-show="openReplies[comment.COMMENT_ID] || closingReplies[comment.COMMENT_ID]">
                                        <div class="reply-thread-inner">
                                            <div v-for="reply in getAllDescendants(comment.COMMENT_ID)"
                                                :key="reply.COMMENT_ID" class="comment-item reply">
                                                <div class="comment-meta">
                                                    <div class="comment-avatar"
                                                        @click="fnShowProfile($event, reply.USER_ID)"
                                                        style="cursor:pointer;">
                                                        <img v-if="reply.profileImg" :src="reply.profileImg">
                                                        <div v-else class="default-avatar small"><i
                                                                class="ri-user-smile-line"></i></div>
                                                    </div>
                                                    <span style="font-weight:700;">{{ reply.nickName }}</span>
                                                    <span style="color:var(--brown4);">·</span>
                                                    <span>{{ fnFormatDate(reply.CREATED_AT) }}</span>
                                                </div>
                                                <div class="comment-content">
                                                    <span class="reply-mention" v-if="getParentNick(reply)">@{{
                                                        getParentNick(reply) }}</span>
                                                    {{ reply.CONTENT }}
                                                </div>
                                                <div class="comment-actions">
                                                    <button class="comment-like-btn"
                                                        :class="{ liked: isCommentLiked(reply.COMMENT_ID) }"
                                                        @click="fnReact('LIKE', 'COMMENT', reply.COMMENT_ID)">
                                                        <i class="ri-heart-3-fill"></i> {{ reply.LIKE_COUNT }}
                                                    </button>
                                                    <button class="reply-btn" @click="fnSetReply(reply)">
                                                        <i class="ri-reply-line"></i> 답글
                                                    </button>
                                                    <div class="comment-menu-wrap">
                                                        <button class="comment-more-btn-icon" type="button"
                                                            @click.stop="fnToggleCommentMenu(reply.COMMENT_ID)">
                                                            <i class="ri-more-2-fill"></i>
                                                        </button>
                                                        <div class="comment-more-menu"
                                                            v-if="openCommentMenuId === reply.COMMENT_ID" @click.stop>
                                                            <button type="button" v-if="!isMyComment(reply.USER_ID)"
                                                                class="danger"
                                                                @click="openCommentMenuId = null; fnReportComment(reply.COMMENT_ID);">신고</button>
                                                            <button type="button" v-if="isMyComment(reply.USER_ID)"
                                                                class="danger"
                                                                @click="openCommentMenuId = null; fnDeleteComment(reply.COMMENT_ID);">삭제</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="inline-reply-box"
                                                    v-if="replyTarget && replyTarget.COMMENT_ID === reply.COMMENT_ID">
                                                    <textarea class="comment-textarea" v-model="commentContent"
                                                        placeholder="답글을 입력하세요..."
                                                        @keydown.ctrl.enter="fnSubmitComment"></textarea>
                                                    <div
                                                        style="display:flex;justify-content:flex-end;gap:8px;margin-top:8px;">
                                                        <button class="reply-btn"
                                                            @click="replyTarget = null; commentContent = ''">취소</button>
                                                        <button class="btn-comment-submit small"
                                                            @click="fnSubmitComment">답글
                                                            등록</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </template>

                                <div class="comment-more-btn"
                                    v-if="!commentShowAll && topCommentsTotal > commentPageSize"
                                    @click="commentShowAll = true">
                                    댓글 {{ topCommentsTotal - commentPageSize }}개 더보기
                                </div>
                                <div class="comment-more-btn"
                                    v-if="commentShowAll && topCommentsTotal > commentPageSize"
                                    @click="fnCloseMoreComments">
                                    <i class="ri-arrow-up-s-line"></i>
                                    댓글 접기
                                </div>
                            </div>

                            <!-- 댓글 입력 -->
                            <div class="comment-write">
                                <div class="reply-indicator" v-if="replyTarget">
                                    <i class="ri-reply-line"></i>
                                    <strong>{{ replyTarget.nickName }}</strong>에게 답글
                                    <button class="reply-cancel-btn" @click="replyTarget = null; commentContent = ''">
                                        <i class="ri-close-line"></i>
                                    </button>
                                </div>
                                <div class="comment-input-row">
                                    <textarea class="comment-textarea" v-model="commentContent"
                                        :placeholder="replyTarget ? replyTarget.nickName + '에게 답글...' : '댓글을 입력하세요...'"
                                        @keydown.ctrl.enter="fnSubmitComment"></textarea>
                                    <button class="btn-comment-submit" @click="fnSubmitComment">등록</button>
                                </div>
                                <div style="font-size:11px;color:var(--brown4);margin-top:6px;">Ctrl+Enter로도 등록 가능</div>
                            </div>
                        </div>
                    </div>

                    <!-- 이미지 라이트박스 -->
                    <div class="lightbox" v-if="lightboxImg" @click.self="lightboxImg = null">
                        <button class="lightbox-close" @click="lightboxImg = null" aria-label="이미지 닫기">
                            <i class="ri-close-line"></i>
                        </button>
                        <img :src="lightboxImg" alt="이미지">
                    </div>

                    <!-- 신고 모달 -->
                    <div class="modal-bg" v-if="showReportModal" @click.self="showReportModal = false">
                        <div class="modal-box">
                            <div class="modal-title"><i class="ri-flag-line"></i> 신고</div>
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

                    <!-- ── 미니 프로필 팝업 ───────────────────────── -->
                    <div v-if="profilePopup.show"
                        :style="{ position:'absolute', top: profilePopup.y + 'px', left: profilePopup.x + 'px' }"
                        class="mini-profile-popup" @click.stop>

                        <div class="mp-header">
                            <div class="mp-avatar">
                                <img v-if="profilePopup.user.profileImg" :src="profilePopup.user.profileImg">
                                <div v-else class="default-avatar small"><i class="ri-user-smile-line"></i></div>
                            </div>
                            <div>
                                <div class="mp-nickname">{{ profilePopup.user.nickname }}</div>
                                <div class="mp-grade">
                                    <i :class="fnGradeIconClass(profilePopup.user.communityGrade)"></i>
                                    {{ fnGradeLabel(profilePopup.user.communityGrade) }}
                                </div>
                            </div>
                        </div>

                        <div class="mp-stats">
                            <div class="mp-stat">
                                <span class="mp-stat-num">{{ profilePopup.user.boardCount }}</span>
                                <span class="mp-stat-label">게시글</span>
                            </div>
                            <div class="mp-stat">
                                <span class="mp-stat-num">{{ profilePopup.user.commentCount }}</span>
                                <span class="mp-stat-label">댓글</span>
                            </div>
                            <div class="mp-stat">
                                <span class="mp-stat-num">{{ profilePopup.user.likeCount }}</span>
                                <span class="mp-stat-label">받은추천</span>
                            </div>
                        </div>

                        <!-- 프로필 상세보기 버튼 -->
                        <div style="margin-top:12px;display:flex;flex-direction:column;gap:7px;">
                            <button @click="fnGoProfile(profilePopup.user.userId)" style="width:100%;height:34px;border:1.5px solid var(--border);border-radius:10px;
                           background:var(--cream);color:var(--brown3);font-size:12px;font-weight:700;
                           cursor:pointer;transition:all .18s;font-family:inherit;"
                                onmouseover="this.style.borderColor='var(--orange)';this.style.color='var(--orange2)'"
                                onmouseout="this.style.borderColor='rgba(44,30,15,.1)';this.style.color='var(--brown3)'">
                                프로필 상세보기
                            </button>

                            <!-- ★ 채팅 신청 버튼 (자신에게는 표시 안 함) -->
                            <button v-if="profilePopup.user.userId !== currentUserId" class="mp-chat-btn"
                                :class="profilePopup.chatBtnState" :disabled="profilePopup.chatBtnState === 'pending'"
                                @click="fnRequestChat(profilePopup.user.userId)">
                                <i
                                    :class="profilePopup.chatBtnState === 'exists' ? 'ri-chat-3-line' : 'ri-chat-new-line'"></i>
                                {{ profilePopup.chatBtnLabel }}
                            </button>
                        </div>
                    </div>
                    <button type="button" class="page-top-btn" :class="{ show: showTopBtn }" @click="fnScrollTop"
                        aria-label="맨 위로 이동">
                        <i class="ri-arrow-up-line"></i>
                    </button>

                    <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
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
                                    currentUserId: '${sessionScope.sessionId}' || null,
                                    openReplies: {},
                                    closingReplies: {},
                                    tagList: [],
                                    bookmarked: false,
                                    profilePopup: {
                                        show: false, user: null, x: 0, y: 0,
                                        chatBtnState: '',       // '' | 'pending' | 'exists'
                                        chatBtnLabel: '대화 신청'
                                    },
                                    commentPageSize: 5,
                                    commentShowAll: false,
                                    gradeList: [
                                        { code: 'SPROUT', iconClass: 'ri-seedling-fill', name: '새싹', shortDesc: '기본' },
                                        { code: 'EMBER', iconClass: 'ri-fire-fill', name: '불씨', shortDesc: '글5+ 또는 댓글10+' },
                                        { code: 'CAMPER', iconClass: 'ri-tent-fill', name: '캠퍼', shortDesc: '글20+ 또는 추천50+' },
                                        { code: 'FIRE_CAMPER', iconClass: 'ri-blaze-fill', name: '불꽃캠퍼', shortDesc: '글50+ 또는 추천200+' },
                                        { code: 'MODAK', iconClass: 'ri-award-fill', name: '모닥불', shortDesc: '글100+ 또는 추천500+' },
                                    ],
                                    postMenuOpen: false,
                                    openCommentMenuId: null,
                                    showTopBtn: false,
                                };
                            },

                            computed: {
                                topComments() {
                                    const all = this.commentList.filter(c => !c.PARENT_ID);
                                    return this.commentShowAll ? all : all.slice(0, this.commentPageSize);
                                },
                                topCommentsTotal() { return this.commentList.filter(c => !c.PARENT_ID).length; },
                                myLiked() { return this.myReactions.some(r => r.type === 'LIKE' && r.target === 'BOARD'); },
                                myDisliked() { return this.myReactions.some(r => r.type === 'DISLIKE' && r.target === 'BOARD'); },
                                isMyPost() { return this.board && this.currentUserId && this.board.USER_ID === this.currentUserId; }
                            },

                            methods: {
                                // ── 데이터 로드 ───────────────────────────────
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
                                                this.tagList = res.tagList || [];
                                                this.pollOptions = res.pollOptions || [];
                                                this.myReactions = res.myReactions || [];
                                                this.bookmarked = res.bookmarked === true;
                                            }
                                        }
                                    });
                                },

                                // ── ★ 채팅 신청 ──────────────────────────────
                                fnRequestChat(toUser) {
                                    const pp = this.profilePopup;

                                    // 이미 채팅방 있으면 바로 이동
                                    if (pp.chatBtnState === 'exists') {
                                        location.href = '/chat-room/room.do?roomId=' + pp.chatRoomId + '&otherId=' + toUser;
                                        return;
                                    }

                                    pp.chatBtnLabel = '신청 중…';

                                    $.ajax({
                                        url: '/chat-room/request.dox', type: 'POST',
                                        data: { toUser },
                                        dataType: 'json',
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                pp.chatBtnState = 'pending';
                                                pp.chatBtnLabel = '신청 완료';
                                                this.showToast('대화 신청을 보냈어요!');
                                            } else if (res.result === 'exists') {
                                                pp.chatBtnState = 'exists';
                                                pp.chatRoomId = res.roomId;
                                                pp.chatBtnLabel = '채팅방 이동';
                                                this.showToast('이미 대화 중인 상대예요!');

                                            } else {
                                                pp.chatBtnLabel = '대화 신청';
                                                this.showToast(res.message || '신청할 수 없습니다.');
                                            }
                                        },
                                        error: () => {
                                            pp.chatBtnLabel = '대화 신청';
                                            this.showToast('네트워크 오류가 발생했어요.');
                                        }
                                    });
                                },

                                // ── 미니 프로필 팝업 ─────────────────────────
                                fnShowProfile(event, userId) {
                                    if (event) event.stopPropagation();
                                    if (!userId) return;

                                    $.ajax({
                                        url: '/user/mini-profile.dox', type: 'POST',
                                        data: { targetUserId: userId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                const el = event.target.closest('.comment-avatar')
                                                    || event.target.closest('.author-avatar')
                                                    || event.target;
                                                const rect = el.getBoundingClientRect();

                                                let x = rect.left + window.scrollX;
                                                let y = rect.bottom + window.scrollY + 8;

                                                const popupWidth = 236;
                                                const popupHeight = 300;
                                                const pageRight = window.scrollX + window.innerWidth;
                                                const pageBottom = window.scrollY + window.innerHeight;

                                                if (x + popupWidth > pageRight - 16) x = pageRight - popupWidth - 16;
                                                if (y + popupHeight > pageBottom - 16) y = rect.top + window.scrollY - popupHeight - 8;

                                                this.profilePopup = {
                                                    show: true, user: res.user, x, y,
                                                    chatBtnState: '',
                                                    chatBtnLabel: '대화 신청',
                                                    chatRoomId: null
                                                };
                                            }
                                        }
                                    });
                                },

                                fnCloseProfile() { this.profilePopup.show = false; },

                                fnGradeLabel(grade) {
                                    return {
                                        SPROUT: '새싹',
                                        EMBER: '불씨',
                                        CAMPER: '캠퍼',
                                        FIRE_CAMPER: '불꽃캠퍼',
                                        MODAK: '모닥불'
                                    }[grade] || '새싹';
                                },

                                fnGradeIconClass(grade) {
                                    return {
                                        SPROUT: 'ri-seedling-fill',
                                        EMBER: 'ri-fire-fill',
                                        CAMPER: 'ri-tent-fill',
                                        FIRE_CAMPER: 'ri-blaze-fill',
                                        MODAK: 'ri-award-fill'
                                    }[grade] || 'ri-seedling-fill';
                                },

                                // ── 기존 메서드들 (변경 없음) ─────────────────
                                fnToggleReplies(commentId) {
                                    const isOpen = this.openReplies[commentId] === true;

                                    // 열기
                                    if (!isOpen) {
                                        this.closingReplies[commentId] = false;
                                        this.openReplies[commentId] = true;
                                        return;
                                    }

                                    // 닫기: 바로 없애지 말고 closing 상태로 접기
                                    this.openReplies[commentId] = false;
                                    this.closingReplies[commentId] = true;

                                    this.$nextTick(() => {
                                        const ref = this.$refs['comment-' + commentId];
                                        const el = Array.isArray(ref) ? ref[0] : ref;

                                        if (el) {
                                            const headerOffset = 90;
                                            const targetTop = el.getBoundingClientRect().top + window.scrollY - headerOffset;

                                            window.scrollTo({
                                                top: targetTop,
                                                behavior: 'smooth'
                                            });
                                        }
                                    });

                                    setTimeout(() => {
                                        this.closingReplies[commentId] = false;
                                    }, 320);
                                },
                                getAllDescendants(rootId) {
                                    const result = [], queue = this.commentList.filter(c => c.PARENT_ID == rootId);
                                    while (queue.length) {
                                        const c = queue.shift();
                                        result.push(c);
                                        this.commentList.filter(r => r.PARENT_ID == c.COMMENT_ID).forEach(r => queue.push(r));
                                    }
                                    return result;
                                },
                                getParentNick(reply) {
                                    if (!reply.PARENT_ID) return '';
                                    const parent = this.commentList.find(c => c.COMMENT_ID == reply.PARENT_ID);
                                    return parent ? parent.nickName : '';
                                },
                                fnTagSearch(tag) { location.href = '/board/list.do?tag=' + encodeURIComponent(tag); },
                                fnBookmark() {
                                    $.ajax({
                                        url: '/board/bookmark.dox', type: 'POST', data: { boardId: this.boardId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.bookmarked = res.bookmarked;
                                                this.showToast(this.bookmarked ? '스크랩 완료 ⭐' : '스크랩 해제');
                                            } else { this.showToast(res.message || '로그인이 필요합니다.'); }
                                        }
                                    });
                                },
                                getReplies(parentId) { return this.commentList.filter(c => c.PARENT_ID == parentId); },
                                isCommentLiked(cid) { return this.myReactions.some(r => r.type === 'LIKE' && r.target === 'COMMENT' && r.commentId == cid); },
                                isMyComment(userId) { return this.currentUserId && userId === this.currentUserId; },
                                fnCatLabel(c) { return { FREE: '자유', REVIEW: '후기', TIP: '꿀팁', QNA: 'Q&A' }[c] || c; },
                                fnFormatDate(dt) {
                                    if (!dt) return '';
                                    const d = new Date(dt), now = new Date(), diff = (now - d) / 1000;
                                    if (diff < 60) return '방금 전';
                                    if (diff < 3600) return Math.floor(diff / 60) + '분 전';
                                    if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
                                    return dt.toString().slice(0, 10);
                                },
                                fnPollPct(opt) {
                                    const total = Number(this.poll?.totalVotes || 0);
                                    return total === 0 ? 0 : Math.round(Number(opt.voteCount) / total * 100);
                                },
                                fnOpenLightbox(url) { this.lightboxImg = url; },
                                fnGoProduct(id) { location.href = '/product/detail.do?productId=' + id; },
                                fnGoEdit() { location.href = '/board/write.do?boardId=' + this.boardId; },
                                fnGoBack() { location.href = '/board/list.do'; },
                                fnGoProfile(userId) { if (userId) location.href = '/user/profile.do?userId=' + encodeURIComponent(userId); },
                                fnDeletePost() {
                                    if (!confirm('게시글을 삭제하시겠습니까?')) return;
                                    $.ajax({
                                        url: '/board/delete.dox', type: 'POST', data: { boardId: this.boardId },
                                        success: (res) => { if (res.result === 'success') location.href = '/board/list.do'; else this.showToast(res.message || '삭제 실패'); }
                                    });
                                },
                                fnVote(optionId) {
                                    if (this.poll?.myVoted) { this.showToast('이미 투표하셨습니다.'); return; }
                                    $.ajax({
                                        url: '/board/poll/vote.dox', type: 'POST', data: { pollId: this.poll.POLL_ID, optionId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.poll.myVoted = true; this.poll.myOptionId = optionId;
                                                const opt = this.pollOptions.find(o => o.optionId == optionId);
                                                if (opt) { opt.voteCount++; this.poll.totalVotes = Number(this.poll.totalVotes || 0) + 1; }
                                                this.showToast('투표가 완료되었습니다.');
                                            } else this.showToast(res.message || '투표 실패');
                                        }
                                    });
                                },
                                fnReact(type, target, commentId) {
                                    $.ajax({
                                        url: '/board/reaction.dox', type: 'POST',
                                        data: { boardId: this.boardId, commentId: commentId || '', type, target },
                                        success: (res) => { if (res.result === 'success') this.fnLoad(); else this.showToast(res.message || '로그인이 필요합니다.'); }
                                    });
                                },
                                fnSetReply(comment) { this.replyTarget = comment; this.commentContent = ''; },
                                fnSubmitComment() {
                                    if (!this.commentContent.trim()) { this.showToast('댓글을 입력해주세요.'); return; }
                                    const data = { boardId: this.boardId, content: this.commentContent };
                                    if (this.replyTarget) data.parentId = this.replyTarget.COMMENT_ID;
                                    $.ajax({
                                        url: '/board/comment/write.dox', type: 'POST', data,
                                        success: (res) => {
                                            if (res.result === 'success') { this.commentContent = ''; this.replyTarget = null; this.fnLoad(); }
                                            else this.showToast(res.message || '로그인이 필요합니다.');
                                        }
                                    });
                                },
                                fnDeleteComment(commentId) {
                                    if (!confirm('댓글을 삭제하시겠습니까?')) return;
                                    $.ajax({
                                        url: '/board/comment/delete.dox', type: 'POST', data: { commentId, boardId: this.boardId },
                                        success: (res) => { if (res.result === 'success') this.fnLoad(); else this.showToast('삭제 실패'); }
                                    });
                                },
                                fnReportComment(commentId) { this.reportTarget = 'COMMENT'; this.reportCommentId = commentId; this.showReportModal = true; },
                                fnSubmitReport() {
                                    if (!this.reportReason) { this.showToast('신고 사유를 선택해주세요.'); return; }
                                    $.ajax({
                                        url: '/board/report.dox', type: 'POST',
                                        data: { boardId: this.boardId, commentId: this.reportCommentId || '', target: this.reportTarget, reason: this.reportReason },
                                        success: (res) => {
                                            this.showReportModal = false;
                                            if (res.result === 'success') this.showToast('신고가 접수되었습니다.');
                                            else if (res.result === 'duplicate') this.showToast('이미 신고한 게시글입니다.');
                                            else this.showToast('로그인이 필요합니다.');
                                        }
                                    });
                                },
                                showToast(msg) { this.toastMsg = msg; this.toastVisible = true; setTimeout(() => { this.toastVisible = false; }, 2500); },
                                fnToggleCommentMenu(commentId) { this.openCommentMenuId = this.openCommentMenuId === commentId ? null : commentId; },
                                fnHandleOutsideClick(event) {
                                    const popup = event.target.closest('.mini-profile-popup');
                                    const avatar = event.target.closest('.author-avatar, .comment-avatar');
                                    const postMenu = event.target.closest('.post-menu-wrap');
                                    const commentMenu = event.target.closest('.comment-menu-wrap');
                                    if (popup || avatar || postMenu || commentMenu) return;
                                    this.profilePopup.show = false;
                                    this.postMenuOpen = false;
                                    this.openCommentMenuId = null;
                                },
                                fnHandleScroll() {
                                    this.showTopBtn = window.scrollY > 320;
                                },

                                fnScrollTop() {
                                    window.scrollTo({
                                        top: 0,
                                        behavior: 'smooth'
                                    });
                                },
                                fnCloseMoreComments() {
                                    const lastVisibleComment = this.topComments[this.commentPageSize - 1];

                                    this.commentShowAll = false;

                                    this.$nextTick(() => {
                                        if (!lastVisibleComment) return;

                                        const ref = this.$refs['comment-' + lastVisibleComment.COMMENT_ID];

                                        const el = Array.isArray(ref) ? ref[0] : ref;
                                        if (!el) return;

                                        const headerOffset = 90;
                                        const targetTop = el.getBoundingClientRect().top + window.scrollY - headerOffset;

                                        window.scrollTo({
                                            top: targetTop,
                                            behavior: 'smooth'
                                        });
                                    });
                                },
                            },

                            mounted() {
                                this.fnLoad();
                                document.addEventListener('click', this.fnHandleOutsideClick);
                                window.addEventListener('scroll', this.fnHandleScroll);
                                this.fnHandleScroll();
                            },

                            unmounted() {
                                document.removeEventListener('click', this.fnHandleOutsideClick);
                                window.removeEventListener('scroll', this.fnHandleScroll);
                            }
                        }).mount('#app');
                    </script>
        </body>

        </html>