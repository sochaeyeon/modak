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
                                                    🏕
                                                </div>
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

                                            <button class="reply-btn" v-if="getReplies(comment.COMMENT_ID).length > 0"
                                                @click="fnToggleReplies(comment.COMMENT_ID)">
                                                {{ openReplies[comment.COMMENT_ID] ? '대댓글 닫기 ▲' : '대댓글 보기 ▼' }}
                                            </button>

                                            <button class="reply-btn" @click="fnReportComment(comment.COMMENT_ID)">🚩
                                                신고</button>

                                            <button class="comment-delete" v-if="isMyComment(comment.USER_ID)"
                                                @click="fnDeleteComment(comment.COMMENT_ID)">
                                                삭제
                                            </button>
                                        </div>

                                        <!-- 답글 입력창: 반드시 원댓글 안쪽, 대댓글 반복문 바깥 -->
                                        <div class="inline-reply-box"
                                            v-if="replyTarget && replyTarget.COMMENT_ID === comment.COMMENT_ID">
                                            <textarea class="comment-textarea" v-model="commentContent"
                                                placeholder="답글을 입력하세요..."
                                                @keydown.ctrl.enter="fnSubmitComment"></textarea>

                                            <div
                                                style="display:flex; justify-content:flex-end; gap:8px; margin-top:8px;">
                                                <button class="reply-btn"
                                                    @click="replyTarget = null; commentContent = ''">취소</button>
                                                <button class="btn-comment-submit small" @click="fnSubmitComment">답글
                                                    등록</button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 대댓글 -->
                                    <div v-if="openReplies[comment.COMMENT_ID]" class="comment-item reply"
                                        v-for="reply in getReplies(comment.COMMENT_ID)" :key="reply.COMMENT_ID">

                                        <div class="comment-meta">
                                            <span style="color:var(--orange);margin-right:4px;">↩</span>
                                            <div class="comment-avatar">
                                                <img v-if="reply.profileImg" :src="reply.profileImg">
                                                <div v-else
                                                    style="width:100%;height:100%;background:var(--cream2);display:flex;align-items:center;justify-content:center;font-size:12px;">
                                                    🏕
                                                </div>
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
                                                @click="fnDeleteComment(reply.COMMENT_ID)">
                                                삭제
                                            </button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <!-- 댓글 입력 -->
                            <div class="comment-write">
                                <div class="reply-indicator" v-if="replyTarget" style="display:none;">
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
                                    currentUserId: '${sessionScope.sessionId}' || null,
                                    openReplies: {}
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
                                fnToggleReplies(commentId) {
                                    this.openReplies[commentId] = !this.openReplies[commentId];
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
                                    if (!this.commentContent.trim()) {
                                        this.showToast('댓글을 입력해주세요.');
                                        return;
                                    }

                                    let data = {
                                        boardId: this.boardId,
                                        content: this.commentContent
                                    };

                                    if (this.replyTarget) {
                                        data.parentId = this.replyTarget.COMMENT_ID;
                                    }

                                    $.ajax({
                                        url: '/board/comment/write.dox',
                                        type: 'POST',
                                        data: data,
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.commentContent = '';
                                                this.replyTarget = null;
                                                this.fnLoad();
                                            } else {
                                                this.showToast(res.message || '로그인이 필요합니다.');
                                            }
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