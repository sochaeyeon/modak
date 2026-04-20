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
                    <!-- <div class="brand-icon">
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
                    </div> -->
                    
                    <a href="/main.do" class="brand-name">모닥모닥</a>
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
                <!-- 피처 카드 -->
                <div class="features">
                    <div class="feat-card">
                        <div class="feat-icon">
                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                                <path
                                    d="M9 2C5 2 2 5 2 9c0 1.5.4 2.9 1.2 4L2 16l3.2-1.1A6.9 6.9 0 0 0 9 16c4 0 7-3 7-7s-3-7-7-7Z"
                                    stroke="#e0621a" stroke-width="1.4" stroke-linejoin="round" />
                                <circle cx="6" cy="9" r="1" fill="#e0621a" />
                                <circle cx="9" cy="9" r="1" fill="#e0621a" />
                                <circle cx="12" cy="9" r="1" fill="#e0621a" />
                            </svg>
                        </div>
                        <div class="feat-text">
                            <h4>따뜻한 이야기 공간</h4>
                            <p>일상의 작은 이야기부터 깊은 고민까지 편하게 나눠요.</p>
                        </div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">
                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                                <circle cx="9" cy="7" r="3.5" stroke="#e0621a" stroke-width="1.4" />
                                <path d="M2 16c0-3.3 3.1-6 7-6s7 2.7 7 6" stroke="#e0621a" stroke-width="1.4"
                                    stroke-linecap="round" />
                            </svg>
                        </div>
                        <div class="feat-text">
                            <h4>나만의 모닥불 커뮤니티</h4>
                            <p>비슷한 관심사를 가진 사람들과 모닥불 주위에 모여요.</p>
                        </div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">
                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                                <path d="M9 2.5L11 7h4.5L12 10l1.5 4.5L9 12l-4.5 2.5L6 10 2.5 7H7Z" stroke="#e0621a"
                                    stroke-width="1.4" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <div class="feat-text">
                            <h4>오늘의 불씨 Pick</h4>
                            <p>매일 새로운 주제로 이야기에 불을 지펴보세요.</p>
                        </div>
                    </div>
                </div>
                <!-- Campfire -->
                <div class="campfire-wrap">
                    <div class="flames">
                        <div class="flame flame-outer"></div>
                        <div class="flame flame-mid"></div>
                        <div class="flame flame-inner"></div>
                        <div class="flame flame-core"></div>
                    </div>
                    <div class="logs">
                        <div class="log log-3"></div>
                        <div class="log log-1"></div>
                        <div class="log log-2"></div>
                        <div class="ember-glow"></div>
                    </div>
                    <div class="stones">
                        <div class="stone stone-1"></div>
                        <div class="stone stone-2"></div>
                        <div class="stone stone-3"></div>
                        <div class="stone stone-4"></div>
                        <div class="stone stone-5"></div>
                    </div>
                    <div class="ground-shadow"></div>
                </div>
            </div>

            <!-- ── 오른쪽 패널 ── -->
            <div class="right-panel">
                <div class="login-box">
                    <div class="login-heading">
                        <h2>다시 불을 피워볼까요</h2>
                        <p>계정에 로그인하고 따뜻한 공간으로 돌아오세요.</p>
                    </div>

                    <div class="field">
                        <label>아이디</label>
                        <div class="input-wrap">
                            <input v-model="userId" type="text" placeholder="아이디를 입력하세요">
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
                            <input v-model="userPwd" type="password" placeholder="비밀번호를 입력하세요" id="pwInput">
                            <span class="input-icon" onclick="togglePw()" id="eyeBtn">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4" />
                                    <circle cx="8" cy="8" r="1.8" fill="#b09070" />
                                </svg>
                            </span>
                        </div>
                        <p v-if="loginMsg" class="login-msg">{{ loginMsg }}</p>

                    </div>

                    <div class="row-options">
                        <label class="remember">

                        </label>
                        <a href="http://localhost:8080/user/find-account.do" class="forgot">아이디/비밀번호 찾기</a>
                    </div>

                    <button class="btn-login" @click="fnLogin">로그인</button>

                    <div class="divider">
                        <div class="divider-line"></div>
                        <span>소셜 계정으로 로그인</span>
                        <div class="divider-line"></div>
                    </div>
                    <div class="social-row">
                        <a class="btn-social" href="/oauth2/authorization/kakao">
                            <svg width="16" height="16" viewBox="0 0 16 16">
                                <text x="8" y="12" text-anchor="middle" font-size="10" font-weight="700" fill="#FFBC00"
                                    font-family="sans-serif">K</text>
                            </svg>
                            카카오
                        </a>

                        <a class="btn-social" href="/oauth2/authorization/naver">
                            <svg width="16" height="16" viewBox="0 0 16 16">
                                <text x="8" y="12" text-anchor="middle" font-size="11" font-weight="700" fill="#03C75A"
                                    font-family="sans-serif">N</text>
                            </svg>
                            네이버
                        </a>

                        <a class="btn-social" href="/oauth2/authorization/google">
                            <svg width="16" height="16" viewBox="0 0 16 16">
                                <text x="8" y="12" text-anchor="middle" font-size="10" font-weight="700" fill="#EA4335"
                                    font-family="sans-serif">G</text>
                            </svg>
                            구글
                        </a>
                    </div>

                    <p class="signup-row">
                        아직 모닥이 없으신가요?
                        <a href="http://localhost:8080/user/sign-up.do">회원가입하기 →</a>
                    </p>
                </div>
            </div>
        </div>
    </body>

    </html>

    <script>

        function togglePw() {
            const input = document.getElementById("pwInput");
            const eye = document.getElementById("eyeBtn");

            if (input.type === "password") {
                input.type = "text";

                // 👁 열린 눈
                eye.innerHTML = `
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#e0621a" stroke-width="1.4" />
                <circle cx="8" cy="8" r="2" fill="#e0621a" />
            </svg>
            `;
            } else {
                input.type = "password";

                // 👁‍🗨 닫힌 눈 (선 추가)
                eye.innerHTML = `
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4" />
                <line x1="3" y1="13" x2="13" y2="3" stroke="#b09070" stroke-width="1.4" />
            </svg>
        `;
            }
        }
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (키 : 값)
                    // list : []
                    userId: '',
                    userPwd: '',
                    loginMsg: ''
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnLogin: function () {
                    let self = this;
                    let param = {
                        userId: self.userId,
                        userPwd: self.userPwd
                    };

                    $.ajax({
                        url: "http://localhost:8080/user/login.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            if (data.loginResult) {
                                // 🔥 여기 바꿔야 함
                                location.href = data.moveUrl;
                            } else {
                                self.loginMsg = data.message;
                            }
                        },
                        error: function () {
                            self.loginMsg = "로그인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
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