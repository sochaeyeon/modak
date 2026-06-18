<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page deferredSyntaxAllowedAsLiteral="true" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>유저 프로필 - 모닥모닥</title>
            <link rel="stylesheet" href="/css/common/font.css">
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
            <style>
                :root {
                    --cream: #F6F0E6;
                    --cream2: #EDE5D4;
                    --orange: #E8732A;
                    --orange2: #C4621E;
                    --brown: #2C1E0F;
                    --brown3: #8B6B4A;
                    --brown4: #B89A7A;
                    --white: #FFFDF8;
                    --border: rgba(44, 30, 15, .1);
                    --green: #2e7d32;
                    --amber: #9B6A00;
                }

                *,
                *::before,
                *::after {
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
                    max-width: 680px;
                    margin: 0 auto;
                    padding: 40px 24px 80px;
                }

                /* 프로필 카드 */
                .profile-card {
                    background: var(--white);
                    border: 1.5px solid var(--border);
                    border-radius: 20px;
                    padding: 32px;
                    margin-bottom: 16px;
                    text-align: center;
                }

                .profile-avatar {
                    width: 88px;
                    height: 88px;
                    border-radius: 50%;
                    margin: 0 auto 16px;
                    background: var(--cream2);
                    overflow: hidden;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 36px;
                    border: 3px solid rgba(232, 115, 42, .2);
                }

                .profile-avatar img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .profile-nickname {
                    font-size: 22px;
                    font-weight: 900;
                    color: var(--brown);
                    margin-bottom: 6px;
                }

                .profile-grade {
                    display: inline-block;
                    padding: 4px 14px;
                    border-radius: 999px;
                    background: rgba(232, 115, 42, .1);
                    color: var(--orange2);
                    font-size: 13px;
                    font-weight: 700;
                    margin-bottom: 20px;
                }

                /* 통계 */
                .profile-stats {
                    display: flex;
                    justify-content: space-around;
                    padding: 20px 0;
                    border-top: 1px solid var(--border);
                }

                .follow-row {
                    margin-top: 14px;
                }

                .follow-btn {
                    width: 140px;
                    height: 38px;
                    border: 1.5px solid var(--orange);
                    border-radius: 12px;
                    background: var(--white);
                    color: var(--orange2);
                    font-size: 13px;
                    font-weight: 800;
                    cursor: pointer;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 6px;
                    transition: all .18s;
                }

                .follow-btn:hover {
                    background: rgba(232, 115, 42, .08);
                }

                .follow-btn.on {
                    background: var(--orange);
                    border-color: var(--orange);
                    color: #fff;
                }

                .follow-btn.on:hover {
                    background: var(--orange2);
                }

                .follow-counts {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 10px;
                    margin-top: 12px;
                    font-size: 13px;
                    color: var(--brown3);
                }

                .follow-count-item {
                    cursor: pointer;
                    font-weight: 600;
                }

                .follow-count-item:hover {
                    color: var(--orange2);
                }

                .follow-count-item strong {
                    color: var(--brown);
                    font-weight: 900;
                }

                .follow-count-divider {
                    color: var(--brown4);
                }

                .follow-modal-box {
                    position: relative;
                    width: min(360px, calc(100vw - 48px));
                    max-height: 70vh;
                    border-radius: 20px;
                    background: var(--white);
                    padding: 18px;
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                }

                .follow-modal-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 16px;
                    font-weight: 900;
                    color: var(--brown);
                    margin-bottom: 12px;
                }

                .follow-modal-close {
                    position: static;
                    width: 28px;
                    height: 28px;
                    font-size: 16px;
                    background: var(--cream2);
                    color: var(--brown3);
                }

                .follow-modal-list {
                    overflow-y: auto;
                }

                .follow-modal-item {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 10px 4px;
                    cursor: pointer;
                    border-bottom: 1px solid rgba(44, 30, 15, .06);
                }

                .follow-modal-item:hover {
                    background: rgba(232, 115, 42, .04);
                }

                .follow-modal-avatar {
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    overflow: hidden;
                    background: var(--cream2);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 18px;
                    color: var(--orange2);
                    flex-shrink: 0;
                }

                .follow-modal-avatar img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .follow-modal-nick {
                    font-size: 14px;
                    font-weight: 700;
                    color: var(--brown);
                }

                .stat-item {
                    text-align: center;
                }

                .stat-num {
                    font-size: 22px;
                    font-weight: 900;
                    color: var(--brown);
                }

                .stat-label {
                    font-size: 11px;
                    color: var(--brown3);
                    font-weight: 600;
                    margin-top: 4px;
                }

                /* 등급 바 */
                .grade-bar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    gap: 4px;
                    margin-top: 20px;
                    padding-top: 20px;
                    border-top: 1px solid var(--border);
                }

                .grade-step {
                    flex: 1;
                    text-align: center;
                    padding: 8px 4px;
                    border-radius: 10px;
                    background: var(--cream2);
                    font-size: 11px;
                    font-weight: 700;
                    color: var(--brown4);
                    transition: all .18s;
                }

                .grade-step.active {
                    background: var(--orange);
                    color: #fff;
                    box-shadow: 0 4px 12px rgba(232, 115, 42, .3);
                }

                .grade-step .grade-icon {
                    font-size: 17px;
                    display: block;
                    margin-bottom: 4px;
                    line-height: 1;
                }

                /* 최근 게시글 */
                .section-card {
                    background: var(--white);
                    border: 1.5px solid var(--border);
                    border-radius: 16px;
                    overflow: hidden;
                    margin-bottom: 16px;
                }

                .section-head {
                    padding: 16px 20px;
                    border-bottom: 1px solid var(--border);
                    font-size: 15px;
                    font-weight: 800;
                    color: var(--brown);
                }

                .board-item {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 14px 20px;
                    border-bottom: 1px solid rgba(44, 30, 15, .06);
                    cursor: pointer;
                    transition: background .15s;
                }

                .board-item:last-child {
                    border-bottom: none;
                }

                .board-item:hover {
                    background: rgba(232, 115, 42, .04);
                }

                .board-title {
                    font-size: 14px;
                    font-weight: 700;
                    color: var(--brown);
                }

                .board-meta {
                    font-size: 11px;
                    color: var(--brown3);
                    margin-top: 4px;
                }

                .board-stats {
                    font-size: 11px;
                    color: var(--brown4);
                    text-align: right;
                    white-space: nowrap;
                }

                .cat-tag {
                    display: inline-block;
                    padding: 2px 8px;
                    border-radius: 999px;
                    font-size: 10px;
                    font-weight: 800;
                    margin-right: 6px;
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
                    color: #2f6fd8;
                }

                .cat-QNA {
                    background: rgba(232, 115, 42, .12);
                    color: var(--orange2);
                }

                .empty-state {
                    padding: 32px;
                    text-align: center;
                    color: var(--brown3);
                    font-size: 13px;
                }

                .back-btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    color: var(--brown3);
                    font-size: 13px;
                    font-weight: 800;
                    cursor: pointer;
                    margin-bottom: 20px;
                    background: none;
                    border: none;
                    padding: 0 0 3px;
                    border-bottom: 1.5px solid transparent;
                    transition: color .15s, border-color .15s;
                }

                .back-btn i {
                    font-size: 16px;
                    line-height: 1;
                }

                .back-btn:hover {
                    color: var(--orange);
                    border-bottom-color: var(--orange);
                }

                .board-stats {
                    display: flex;
                    align-items: center;
                    justify-content: flex-end;
                    gap: 8px;
                    font-size: 11px;
                    color: var(--brown4);
                    text-align: right;
                    white-space: nowrap;
                }

                .board-stats span {
                    display: inline-flex;
                    align-items: center;
                    gap: 3px;
                }

                .board-stats i {
                    font-size: 13px;
                    color: var(--brown4);
                }

                .profile-avatar i {
                    font-size: 38px;
                    color: var(--orange2);
                }

                .section-head {
                    display: flex;
                    align-items: center;
                    gap: 7px;
                    padding: 16px 20px;
                    border-bottom: 1px solid var(--border);
                    font-size: 15px;
                    font-weight: 800;
                    color: var(--brown);
                }

                .section-head i {
                    font-size: 17px;
                    color: var(--orange2);
                }

                .stat-clickable {
                    cursor: pointer;
                    padding: 8px 18px;
                    border-radius: 14px;
                    transition: background .18s, color .18s;
                }

                .stat-clickable:hover,
                .stat-clickable.active {
                    background: rgba(232, 115, 42, .08);
                }

                .stat-clickable.active .stat-num,
                .stat-clickable.active .stat-label {
                    color: var(--orange2);
                }

                .comment-item {
                    padding: 15px 20px;
                    border-bottom: 1px solid rgba(44, 30, 15, .06);
                    cursor: pointer;
                    transition: background .15s;
                }

                .comment-item:last-child {
                    border-bottom: none;
                }

                .comment-item:hover {
                    background: rgba(232, 115, 42, .04);
                }

                .comment-content {
                    margin-bottom: 8px;
                    color: var(--brown);
                    font-size: 14px;
                    font-weight: 700;
                    line-height: 1.55;

                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                .comment-board-title {
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    margin-bottom: 5px;
                    color: var(--brown3);
                    font-size: 12px;
                    font-weight: 700;
                }

                .comment-board-title i {
                    color: var(--orange2);
                    font-size: 14px;
                }

                .profile-avatar.clickable {
                    cursor: pointer;
                    transition: opacity .18s ease, transform .18s ease;
                }

                .profile-avatar.clickable:hover {
                    opacity: .86;
                }

                .profile-img-modal {
                    position: fixed;
                    inset: 0;
                    z-index: 9999;
                    background: rgba(44, 30, 15, .58);
                    backdrop-filter: blur(5px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 28px;
                }

                .profile-img-modal-box {
                    position: relative;
                    width: min(420px, calc(100vw - 48px));
                    max-height: calc(100vh - 80px);
                    border-radius: 24px;
                    background: var(--white);
                    padding: 16px;
                    border: 1.5px solid rgba(255, 253, 248, .35);
                    animation: profileImgPop .18s ease;
                }

                .profile-img-modal-box img {
                    display: block;
                    width: 100%;
                    max-height: calc(100vh - 130px);
                    object-fit: contain;
                    border-radius: 18px;
                    background: var(--cream2);
                }

                .profile-img-modal-close {
                    position: absolute;
                    top: -14px;
                    right: -14px;
                    width: 38px;
                    height: 38px;
                    border: none;
                    border-radius: 50%;
                    background: var(--orange);
                    color: #fff;
                    font-size: 22px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .profile-img-modal-close:hover {
                    background: var(--orange2);
                }

                @keyframes profileImgPop {
                    from {
                        opacity: 0;
                        transform: translateY(8px) scale(.96);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0) scale(1);
                    }
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">
                        <button class="back-btn" type="button" @click="fnGoBack">
                            <i class="ri-arrow-left-line"></i>
                            <span>뒤로</span>
                        </button>
                        <!-- 프로필 카드 -->
                        <div class="profile-card" v-if="user">
                            <div class="profile-avatar" :class="{ clickable: user.profileImg }"
                                @click="fnOpenProfileImgModal">
                                <img v-if="user.profileImg" :src="user.profileImg" alt="프로필 이미지">
                                <i v-else class="ri-user-smile-line"></i>
                            </div>
                            <div class="profile-nickname">{{ user.nickname }}</div>
                            <div class="profile-grade">{{ fnGradeLabel(user.communityGrade) }}</div>

                            <!-- ★ 팔로우 버튼 + 팔로워/팔로잉 카운트 -->
                            <div class="follow-row" v-if="user.userId !== currentUserId">
                                <button class="follow-btn" :class="{ on: isFollowing }" @click="fnToggleFollow">
                                    <i :class="isFollowing ? 'ri-user-unfollow-line' : 'ri-user-add-line'"></i>
                                    {{ isFollowing ? '팔로잉' : '팔로우' }}
                                </button>
                            </div>

                            <div class="follow-counts">
                                <span class="follow-count-item" @click="fnOpenFollowModal('followers')">
                                    <strong>{{ followerCount }}</strong> 팔로워
                                </span>
                                <span class="follow-count-divider">·</span>
                                <span class="follow-count-item" @click="fnOpenFollowModal('following')">
                                    <strong>{{ followingCount }}</strong> 팔로잉
                                </span>
                            </div>

                            <!-- 통계 -->
                            <div class="profile-stats">
                                <div class="stat-item stat-clickable" :class="{ active: activeTab === 'board' }"
                                    @click="activeTab = 'board'">
                                    <div class="stat-num">{{ user.boardCount || 0 }}</div>
                                    <div class="stat-label">게시글</div>
                                </div>

                                <div class="stat-item stat-clickable" :class="{ active: activeTab === 'comment' }"
                                    @click="activeTab = 'comment'">
                                    <div class="stat-num">{{ user.commentCount || 0 }}</div>
                                    <div class="stat-label">댓글</div>
                                </div>

                                <div class="stat-item">
                                    <div class="stat-num">{{ user.likeCount || 0 }}</div>
                                    <div class="stat-label">받은 좋아요</div>
                                </div>
                            </div>
                            <!-- 등급 단계 바 -->
                            <div class="grade-bar">
                                <div v-for="g in gradeList" :key="g.code" class="grade-step"
                                    :class="{ active: user.communityGrade === g.code }">
                                    <i class="grade-icon" :class="g.icon"></i>
                                    {{ g.name }}
                                </div>
                            </div>
                        </div>

                        <!-- ★ 팔로워/팔로잉 목록 모달 -->
                        <div class="profile-img-modal" v-if="followModal.show" @click.self="followModal.show = false">
                            <div class="follow-modal-box">
                                <div class="follow-modal-header">
                                    <span>{{ followModal.type === 'followers' ? '팔로워' : '팔로잉' }}</span>
                                    <button type="button" class="profile-img-modal-close follow-modal-close"
                                        @click="followModal.show = false">
                                        <i class="ri-close-line"></i>
                                    </button>
                                </div>

                                <div class="follow-modal-list">
                                    <div v-if="followModal.list.length === 0" class="empty-state">
                                        {{ followModal.type === 'followers' ? '팔로워가 없습니다.' : '팔로잉이 없습니다.' }}
                                    </div>

                                    <div v-for="f in followModal.list" :key="f.userId" class="follow-modal-item"
                                        @click="fnGoUserProfile(f.userId)">
                                        <div class="follow-modal-avatar">
                                            <img v-if="f.profileImg" :src="f.profileImg">
                                            <i v-else class="ri-user-smile-line"></i>
                                        </div>
                                        <span class="follow-modal-nick">{{ f.nickname || f.userName }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 게시글 / 댓글 목록 -->
                        <div class="section-card" v-if="activeTab === 'board'">
                            <div class="section-head">
                                <i class="ri-article-line"></i>
                                작성한 게시글
                            </div>

                            <div v-if="recentBoards.length > 0">
                                <div v-for="board in recentBoards" :key="board.BOARD_ID" class="board-item"
                                    @click="fnGoBoard(board.BOARD_ID)">
                                    <div>
                                        <div class="board-title">
                                            <span class="cat-tag" :class="'cat-' + board.CATEGORY">
                                                {{ fnCatLabel(board.CATEGORY) }}
                                            </span>
                                            {{ board.TITLE }}
                                        </div>
                                        <div class="board-meta">{{ fnFormatDate(board.CREATED_AT) }}</div>
                                    </div>

                                    <div class="board-stats">
                                        <span>
                                            <i class="ri-heart-3-line"></i>
                                            {{ board.LIKE_COUNT || 0 }}
                                        </span>
                                        <span>
                                            <i class="ri-chat-3-line"></i>
                                            {{ board.COMMENT_COUNT || 0 }}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-state" v-else>
                                아직 작성한 게시글이 없습니다.
                            </div>
                        </div>

                        <div class="section-card" v-if="activeTab === 'comment'">
                            <div class="section-head">
                                <i class="ri-chat-3-line"></i>
                                작성한 댓글
                            </div>

                            <div v-if="recentComments.length > 0">
                                <div v-for="comment in recentComments" :key="comment.COMMENT_ID" class="comment-item"
                                    @click="fnGoBoard(comment.BOARD_ID)">
                                    <div class="comment-content">
                                        {{ comment.CONTENT }}
                                    </div>

                                    <div class="comment-board-title">
                                        <i class="ri-article-line"></i>
                                        {{ comment.BOARD_TITLE || '게시글 보기' }}
                                    </div>

                                    <div class="board-meta">
                                        {{ fnFormatDate(comment.CREATED_AT) }}
                                    </div>
                                </div>
                            </div>

                            <div class="empty-state" v-else>
                                아직 작성한 댓글이 없습니다.
                            </div>
                        </div>
                        <!-- 프로필 이미지 확대 모달 -->
                        <div class="profile-img-modal" v-if="profileImgModalOpen" @click.self="fnCloseProfileImgModal">
                            <div class="profile-img-modal-box">
                                <button type="button" class="profile-img-modal-close" @click="fnCloseProfileImgModal">
                                    <i class="ri-close-line"></i>
                                </button>

                                <img :src="user.profileImg" alt="프로필 이미지 확대">
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    user: null,
                                    recentBoards: [],
                                    recentComments: [],
                                    activeTab: 'board',
                                    profileImgModalOpen: false,
                                    currentUserId: '${sessionScope.sessionId}' || null,
                                    isFollowing: false,
                                    followerCount: 0,
                                    followingCount: 0,
                                    followModal: {
                                        show: false,
                                        type: 'followers',
                                        list: []
                                    },
                                    gradeList: [
                                        { code: 'SPROUT', icon: 'ri-seedling-line', name: '새싹' },
                                        { code: 'EMBER', icon: 'ri-fire-line', name: '불씨' },
                                        { code: 'CAMPER', icon: 'ri-tent-line', name: '캠퍼' },
                                        { code: 'FIRE_CAMPER', icon: 'ri-sparkling-line', name: '불꽃' },
                                        { code: 'MODAK', icon: 'ri-bowl-line', name: '모닥불' }
                                    ]
                                };
                            },
                            methods: {
                                fnOpenProfileImgModal() {
                                    if (!this.user || !this.user.profileImg) {
                                        return;
                                    }

                                    this.profileImgModalOpen = true;
                                    document.body.style.overflow = 'hidden';
                                },

                                fnCloseProfileImgModal() {
                                    this.profileImgModalOpen = false;
                                    document.body.style.overflow = '';
                                },
                                fnLoad() {
                                    const userId = new URLSearchParams(location.search).get('userId');
                                    if (!userId) return;

                                    $.ajax({
                                        url: '/user/profile.dox', type: 'POST',
                                        data: { targetUserId: userId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.user = res.user;
                                                this.recentBoards = res.recentBoards || [];
                                                this.recentComments = res.recentComments || [];

                                                // ★ 팔로우 상태 별도 조회
                                                this.fnLoadFollowStatus(userId);
                                            }
                                        }
                                    });
                                },

                                // ★ 신규
                                fnLoadFollowStatus(userId) {
                                    $.ajax({
                                        url: '/follow/status.dox', type: 'POST',
                                        data: { targetUserId: userId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.isFollowing = res.isFollowing === true;
                                                this.followerCount = res.followerCount || 0;
                                                this.followingCount = res.followingCount || 0;
                                            }
                                        }
                                    });
                                },

                                // ★ 신규
                                fnToggleFollow() {
                                    const userId = new URLSearchParams(location.search).get('userId');

                                    $.ajax({
                                        url: '/follow/toggle.dox', type: 'POST',
                                        data: { targetUserId: userId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.isFollowing = res.following;
                                                this.followerCount = res.followerCount;
                                            } else {
                                                alert(res.message || '로그인이 필요합니다.');
                                            }
                                        }
                                    });
                                },

                                // ★ 신규
                                fnOpenFollowModal(type) {
                                    const userId = new URLSearchParams(location.search).get('userId');
                                    const url = type === 'followers' ? '/follow/followers.dox' : '/follow/followings.dox';

                                    $.ajax({
                                        url, type: 'POST',
                                        data: { userId },
                                        success: (res) => {
                                            if (res.result === 'success') {
                                                this.followModal = { show: true, type, list: res.list || [] };
                                            }
                                        }
                                    });
                                },

                                // ★ 신규
                                fnGoUserProfile(userId) {
                                    this.followModal.show = false;
                                    location.href = '/user/profile.do?userId=' + encodeURIComponent(userId);
                                },
                                fnGoBoard(id) { location.href = '/board/detail.do?boardId=' + id; },
                                fnGradeLabel(g) {
                                    return {
                                        SPROUT: '새싹',
                                        EMBER: '불씨',
                                        CAMPER: '캠퍼',
                                        FIRE_CAMPER: '불꽃캠퍼',
                                        MODAK: '모닥불'
                                    }[g] || '새싹';
                                },
                                fnCatLabel(c) { return { FREE: '자유', REVIEW: '후기', TIP: '꿀팁', QNA: 'Q&A' }[c] || c; },
                                fnFormatDate(dt) {
                                    if (!dt) return '';
                                    const d = new Date(dt), now = new Date(), diff = (now - d) / 1000;
                                    if (diff < 60) return '방금 전';
                                    if (diff < 3600) return Math.floor(diff / 60) + '분 전';
                                    if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
                                    return dt.toString().slice(0, 10);
                                },
                                fnGoBack() {
                                    const params = new URLSearchParams(location.search);
                                    const ref = params.get('ref');

                                    if (ref) {
                                        location.href = decodeURIComponent(ref);
                                        return;
                                    }

                                    if (document.referrer && document.referrer.includes(location.host)) {
                                        location.href = document.referrer;
                                        return;
                                    }

                                    location.href = '/board/list.do';
                                },
                            },
                            mounted() { this.fnLoad(); }
                        }).mount('#app');
                    </script>
        </body>

        </html>