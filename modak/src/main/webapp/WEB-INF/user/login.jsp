<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common/reset.css">
        <link rel="stylesheet" href="/css/common/variables.css">
        <link rel="stylesheet" href="/css/common/font.css">
        <link rel="stylesheet" href="/css/common/layout.css">
        <link rel="stylesheet" href="/css/common/component.css">
        <link rel="stylesheet" href="/css/common/animation.css">
        <link rel="stylesheet" href="/css/user/login.css">
    </head>

    <body>
        <div id="app">
            <!-- ── 왼쪽 패널 ── -->
            <div class="left-panel">
                <div class="brand">
                    <div class="brand-icon">
                        <svg width="28" height="34" viewBox="0 0 28 34" fill="none">
                            <path
                                d="M14 34C9 27 6.5 20 10 13 12 8.5 9.5 4.5 12 1 13 -0.5 14 0 14 0 14 0 15 -0.5 16 1 18.5 4.5 16 8.5 18 13 21.5 20 19 27 14 34Z"
                                fill="url(#bFlame)" />
                            <path
                                d="M14 34C11.5 28.5 11 23 13 18 13.8 15 12.5 12 14 9.5 15.5 12 14.2 15 15 18 17 23 16.5 28.5 14 34Z"
                                fill="url(#bInner)" />
                            <defs>
                                <linearGradient id="bFlame" x1="14" y1="34" x2="14" y2="0"
                                    gradientUnits="userSpaceOnUse">
                                    <stop offset="0%" stop-color="#c94f1e" />
                                    <stop offset="55%" stop-color="#f07d3a" />
                                    <stop offset="100%" stop-color="#fde090" stop-opacity="0.5" />
                                </linearGradient>
                                <linearGradient id="bInner" x1="14" y1="34" x2="14" y2="9.5"
                                    gradientUnits="userSpaceOnUse">
                                    <stop offset="0%" stop-color="#fff3c4" />
                                    <stop offset="100%" stop-color="#fbbf7a" stop-opacity="0.4" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>
                    <span class="brand-name">모닥모닥</span>
                </div>

                <div class="hero-text">
                    <p class="hero-eyebrow">MODAKMODAK</p>
                    <h1 class="hero-title">함께 모여<br><em>불을 피우다</em></h1>
                    <p class="hero-desc">
                        오늘도 따뜻한 이야기를 나눠보세요.<br>
                        모닥모닥에서 사람들과 함께하는<br>
                        아늑한 공간이 기다리고 있어요.
                    </p>
                </div>

                <!-- 모닥불 씬 -->
                <svg class="fire-scene" viewBox="0 0 320 170" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <!-- ground glow -->
                    <ellipse class="glow-el" cx="160" cy="148" rx="90" ry="18" fill="#f07d3a" opacity="0.2" />
                    <ellipse cx="160" cy="152" rx="60" ry="10" fill="#3d1a07" opacity="0.45" />

                    <!-- logs -->
                    <rect x="85" y="136" width="88" height="16" rx="8" fill="#4e2810" transform="rotate(-17 105 144)" />
                    <rect x="147" y="136" width="88" height="16" rx="8" fill="#5a3012" transform="rotate(17 185 144)" />
                    <rect x="128" y="144" width="44" height="12" rx="6" fill="#3d1a07" />

                    <!-- coals -->
                    <ellipse cx="152" cy="148" rx="8" ry="3.5" fill="#c94f1e" opacity="0.55" />
                    <ellipse cx="168" cy="149" rx="6" ry="3" fill="#e0621a" opacity="0.45" />
                    <ellipse cx="158" cy="151" rx="5" ry="2.5" fill="#f07d3a" opacity="0.4" />

                    <!-- main flame -->
                    <g class="flame-main">
                        <path
                            d="M160 150 C145 130 138 112 148 92 C153 80 146 68 151 56 C155 44 160 36 160 36 C160 36 165 44 169 56 C174 68 167 80 172 92 C182 112 175 130 160 150Z"
                            fill="url(#fg1)" opacity="0.93" />
                    </g>
                    <!-- inner flame -->
                    <g class="flame-inner">
                        <path
                            d="M160 150 C151 136 149 122 154 108 C157 98 153 89 156 78 C158 68 160 62 160 62 C160 62 162 68 164 78 C167 89 163 98 166 108 C171 122 169 136 160 150Z"
                            fill="url(#fg2)" opacity="0.96" />
                    </g>
                    <!-- core -->
                    <path
                        d="M160 150 C156 140 155 130 158 121 C159 115 157.5 109 160 104 C162.5 109 161 115 162 121 C165 130 164 140 160 150Z"
                        fill="url(#fg3)" opacity="0.88" />

                    <!-- embers -->
                    <circle class="e1" cx="146" cy="96" r="2.2" fill="#f4a460" />
                    <circle class="e2" cx="174" cy="102" r="1.8" fill="#e0621a" />
                    <circle class="e3" cx="153" cy="84" r="1.5" fill="#fbbf7a" />
                    <circle class="e4" cx="168" cy="90" r="1.3" fill="#f07d3a" />

                    <defs>
                        <linearGradient id="fg1" x1="160" y1="150" x2="160" y2="36" gradientUnits="userSpaceOnUse">
                            <stop offset="0%" stop-color="#e0621a" />
                            <stop offset="42%" stop-color="#f07d3a" />
                            <stop offset="78%" stop-color="#f4a460" />
                            <stop offset="100%" stop-color="#fde8a0" stop-opacity="0.25" />
                        </linearGradient>
                        <linearGradient id="fg2" x1="160" y1="150" x2="160" y2="62" gradientUnits="userSpaceOnUse">
                            <stop offset="0%" stop-color="#c94f1e" />
                            <stop offset="52%" stop-color="#f07d3a" />
                            <stop offset="100%" stop-color="#fde090" stop-opacity="0.35" />
                        </linearGradient>
                        <linearGradient id="fg3" x1="160" y1="150" x2="160" y2="104" gradientUnits="userSpaceOnUse">
                            <stop offset="0%" stop-color="#fff8e0" />
                            <stop offset="60%" stop-color="#fbbf7a" />
                            <stop offset="100%" stop-color="#f07d3a" stop-opacity="0.4" />
                        </linearGradient>
                    </defs>
                </svg>
            </div>

            <!-- ── 오른쪽 패널 ── -->
            <div class="right-panel">
                <div class="login-box">
                    <div class="login-heading">
                        <h2>다시 불을 피워볼까요</h2>
                        <p>계정에 로그인하고 따뜻한 공간으로 돌아오세요.</p>
                    </div>

                    <div class="field">
                        <label>이메일</label>
                        <div class="input-wrap">
                            <input type="email" placeholder="이메일 주소를 입력하세요">
                            <span class="input-icon">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <rect x="1" y="3" width="14" height="10" rx="2" stroke="#b09070"
                                        stroke-width="1.4" />
                                    <path d="M1.5 4L8 9.5L14.5 4" stroke="#b09070" stroke-width="1.4"
                                        stroke-linecap="round" />
                                </svg>
                            </span>
                        </div>
                    </div>

                    <div class="field">
                        <label>비밀번호</label>
                        <div class="input-wrap">
                            <input type="password" placeholder="비밀번호를 입력하세요" id="pwInput">
                            <span class="input-icon" onclick="togglePw()" id="eyeBtn">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4" />
                                    <circle cx="8" cy="8" r="1.8" fill="#b09070" />
                                </svg>
                            </span>
                        </div>
                    </div>

                    <div class="row-options">
                        <label class="remember">
                            <input type="checkbox">
                            <span>로그인 상태 유지</span>
                        </label>
                        <a href="#" class="forgot">비밀번호 찾기</a>
                    </div>

                    <button class="btn-login">로그인</button>

                    <div class="divider">
                        <div class="divider-line"></div>
                        <span>소셜 계정으로 로그인</span>
                        <div class="divider-line"></div>
                    </div>

                    <div class="social-row">
                        <button class="btn-social">
                            <svg width="16" height="16" viewBox="0 0 16 16"><text x="8" y="12" text-anchor="middle"
                                    font-size="10" font-weight="700" fill="#FFBC00"
                                    font-family="sans-serif">K</text></svg>
                            카카오
                        </button>
                        <button class="btn-social">
                            <svg width="16" height="16" viewBox="0 0 16 16"><text x="8" y="12" text-anchor="middle"
                                    font-size="11" font-weight="700" fill="#03C75A"
                                    font-family="sans-serif">N</text></svg>
                            네이버
                        </button>
                        <button class="btn-social">
                            <svg width="16" height="16" viewBox="0 0 16 16"><text x="8" y="12" text-anchor="middle"
                                    font-size="10" font-weight="700" fill="#EA4335"
                                    font-family="sans-serif">G</text></svg>
                            구글
                        </button>
                    </div>

                    <p class="signup-row">
                        아직 모닥이 없으신가요?
                        <a href="#">회원가입하기 →</a>
                    </p>
                </div>
            </div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (키 : 값)
                    // list : [] 
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnList: function () {
                    let self = this;
                    let param = {
                        // 백엔드로 전달할 데이터
                    };
                    $.ajax({
                        url: "http://localhost:8080/default.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // 받은 데이터를 변수에 저장하세요
                            // self.list = data.list;
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }
        });

        app.mount('#app');
    </script>