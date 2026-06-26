<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모닥모닥 | 관리자 로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-login.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>[v-cloak]{display:none}</style>
</head>
<body>

<div id="app" class="login-wrap" v-cloak>

    <!-- ── 왼쪽 브랜드 패널 ── -->
    <div class="login-brand">
        <div class="brand-glow"></div>
        <div class="brand-inner">
            <div class="brand-fire">🔥</div>
            <div class="brand-name">모닥모닥</div>
            <div class="brand-eng">MODAK MODAK</div>
            <p class="brand-desc">렌탈과 구매를 한 번에.<br>대한민국 대표 공유 플랫폼</p>
            <div class="brand-divider"></div>
            <div class="brand-features">
                <div class="feat-item"><span class="feat-icon">📊</span> 대시보드 & 통계</div>
                <div class="feat-item"><span class="feat-icon">📦</span> 상품 & 재고 관리</div>
                <div class="feat-item"><span class="feat-icon">💬</span> 1:1 문의 답변</div>
                <div class="feat-item"><span class="feat-icon">🎁</span> 이벤트 & 프로모션</div>
                <div class="feat-item"><span class="feat-icon">⭐</span> 리뷰 모니터링</div>
            </div>
        </div>
        <div class="brand-footer">운영팀 전용 관리 시스템 v2.0</div>
    </div>

    <!-- ── 오른쪽 폼 패널 ── -->
    <div class="login-form-panel">
        <div class="form-inner">
            <div class="admin-badge">ADMIN ONLY</div>
            <h1 class="login-title">관리자 로그인</h1>
            <p class="login-sub">모닥모닥 운영팀만 접근 가능합니다</p>

            <!-- 에러 메시지 -->
            <transition name="err-fade">
                <div class="error-box" v-if="errorMsg">
                    <span class="error-icon">⚠️</span>
                    {{ errorMsg }}
                </div>
            </transition>

            <div class="form-group">
                <label class="form-label">아이디</label>
                <div class="input-wrap" :class="{focused: focusId}">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
                    </span>
                    <input type="text" v-model="userId" @keyup.enter="fnLogin"
                           @focus="focusId=true" @blur="focusId=false"
                           placeholder="관리자 아이디 입력" autocomplete="username">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <div class="input-wrap" :class="{focused: focusPw}">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </span>
                    <input :type="showPw ? 'text' : 'password'" v-model="password" @keyup.enter="fnLogin"
                           @focus="focusPw=true" @blur="focusPw=false"
                           placeholder="비밀번호 입력" autocomplete="current-password">
                    <button type="button" class="pw-toggle" @click="showPw=!showPw" tabindex="-1">
                        <svg v-if="!showPw" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                    </button>
                </div>
            </div>

            <button class="btn-login" @click="fnLogin" :disabled="isLoading">
                <span v-if="isLoading" class="btn-spinner"></span>
                <span v-else class="btn-arrow">→</span>
                {{ isLoading ? '접속 중...' : '접속하기' }}
            </button>

            <a href="/main.do" class="back-home">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
                사용자 메인으로 돌아가기
            </a>
        </div>
    </div>
</div>

<script>
    const { createApp } = Vue;
    createApp({
        data() {
            return {
                userId: '',
                password: '',
                errorMsg: '',
                isLoading: false,
                focusId: false,
                focusPw: false,
                showPw: false
            };
        },
        methods: {
            fnLogin() {
                this.errorMsg = '';
                if (!this.userId.trim() || !this.password.trim()) {
                    this.errorMsg = '아이디와 비밀번호를 모두 입력해주세요.';
                    return;
                }
                this.isLoading = true;
                $.ajax({
                    url: '/admin/login.dox',
                    type: 'POST',
                    data: { id: this.userId, password: this.password },
                    success: (res) => {
                        if (res.result === 'success') {
                            location.href = '/admin/dashboard.do';
                        } else {
                            this.errorMsg = res.message || '아이디 또는 비밀번호가 올바르지 않습니다.';
                            this.password = '';
                            this.isLoading = false;
                        }
                    },
                    error: () => {
                        this.errorMsg = '서버 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                        this.isLoading = false;
                    }
                });
            }
        }
    }).mount('#app');
</script>
</body>
</html>
