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
                    <p class="hero-eyebrow">CAMPING RENTAL & SHOP</p>
                    <h1 class="hero-title">필요한 순간,<br><em>캠핑을 준비하다</em></h1>
                    <p class="hero-desc">
                        캠핑용품 구매부터 대여까지 한 번에.<br>
                        모닥모닥에서 더 가볍고 편리한<br>
                        캠핑 준비를 시작해보세요.
                    </p>
                </div>
                <div class="left-mini-badge">
                    <span>캠핑용품 대여</span>
                    <span>캠핑용품 구매</span>
                    <span>빠른 배송</span>
                </div>

                <div class="left-stats">
                    <div class="stat-card">
                        <strong>RENTAL</strong>
                        <p>필요한 기간만 부담 없이 대여</p>
                    </div>
                    <div class="stat-card">
                        <strong>SHOP</strong>
                        <p>원하는 장비는 바로 구매 가능</p>
                    </div>
                    <div class="stat-card">
                        <strong>DELIVERY</strong>
                        <p>집에서 받고 캠핑장으로 떠나요</p>
                    </div>
                </div>

                <div class="left-quote">
                    <span class="quote-mark">“</span>
                    <p>장비 준비는 가볍게, 캠핑의 설렘은 더 크게.</p>
                </div>
                <!-- 피처 카드 -->
               

                <!-- 떠다니는 불씨 파티클 -->
                <div class="embers-canvas" id="embersCanvas"></div>

                <!-- 캠프파이어 -->
                <div class="campfire-wrap">
                    <div class="fire-halo"></div>

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
                        <div class="ember-glow-log"></div>
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
                    <a href="/main.do" class="btn-guest">비회원으로 둘러보기</a>

                    <div class="divider">
                        <div class="divider-line"></div>
                        <span>소셜 계정으로 로그인</span>
                        <div class="divider-line"></div>
                    </div>
                    <div class="social-row">
                        <a class="btn-social kakao" href="/oauth2/authorization/kakao">
                            <span class="social-icon">
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="12" fill="#FEE500" />
                                    <path
                                        d="M12 6.5C8.4 6.5 5.5 8.8 5.5 11.7c0 1.9 1.2 3.5 3 4.5l-.8 2.8c-.1.2.2.4.4.3l3.4-2.2h.5c3.6 0 6.5-2.3 6.5-5.2S15.6 6.5 12 6.5z"
                                        fill="#3B1E1E" />
                                </svg>
                            </span>
                            <span class="social-text">카카오</span>
                        </a>

                        <a class="btn-social naver" href="/oauth2/authorization/naver">
                            <span class="social-icon">
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="12" fill="#DDF7E8" />
                                    <path d="M8 7h2.3l3.4 5V7H16v10h-2.2l-3.5-5.1V17H8V7z" fill="#12B76A" />
                                </svg>
                            </span>
                            <span class="social-text">네이버</span>
                        </a>

                        <a class="btn-social google" href="/oauth2/authorization/google">
                            <span class="social-icon">
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="12" fill="#FFF7EC" />
                                    <path
                                        d="M17.5 12.2c0-.4 0-.7-.1-1.1H12v2.1h3.1c-.1.7-.5 1.4-1.2 1.8v1.7h1.9c1.1-1 1.7-2.5 1.7-4.5z"
                                        fill="#4285F4" />
                                    <path
                                        d="M12 17.8c1.5 0 2.8-.5 3.8-1.4l-1.9-1.7c-.5.3-1.1.6-1.9.6-1.5 0-2.7-1-3.2-2.3H6.9v1.8c1 1.9 2.9 3 5.1 3z"
                                        fill="#34A853" />
                                    <path
                                        d="M8.8 13c-.1-.3-.2-.7-.2-1s.1-.7.2-1V9.2H6.9C6.5 10 6.3 10.9 6.3 12s.2 2 .6 2.8L8.8 13z"
                                        fill="#FBBC05" />
                                    <path
                                        d="M12 8.7c.8 0 1.6.3 2.2.8l1.6-1.6C14.8 7 13.5 6.5 12 6.5c-2.2 0-4.1 1.2-5.1 3l1.9 1.8c.5-1.4 1.7-2.6 3.2-2.6z"
                                        fill="#EA4335" />
                                </svg>
                            </span>
                            <span class="social-text">구글</span>
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
        (function spawnEmbers() {
            const canvas = document.getElementById('embersCanvas');
            const colors = ['#ff8c00', '#ff6a00', '#ffb347', '#ffa500', '#fff08a'];

            function spawn() {
                const el = document.createElement('div');
                el.className = 'sp';
                const size = Math.random() * 3.5 + 1.5;
                const dur = Math.random() * 2.5 + 2;
                const dx = (Math.random() - 0.5) * 100;
                const left = Math.random() * 80 + 60;
                el.style.cssText = `
          left:${left}px;
          width:${size}px; height:${size}px;
          background:${colors[Math.floor(Math.random() * colors.length)]};
          box-shadow: 0 0 ${size + 2}px #ff8c00;
          animation-duration:${dur}s;
          animation-delay:${Math.random() * 1.5}s;
          --dx:${dx}px;
        `;
                canvas.appendChild(el);
                setTimeout(() => el.remove(), (dur + 2) * 1000);
            }

            setInterval(spawn, 360);
        })();
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
                    const loginBtn = document.querySelector('.btn-login');
                    loginBtn.classList.add('loading');

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
                            if (data.loginResult) {
                                location.href = data.moveUrl;
                            } else {
                                self.loginMsg = data.message;
                                loginBtn.classList.remove('loading');
                            }
                        },
                        error: function () {
                            self.loginMsg = "로그인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
                            loginBtn.classList.remove('loading');
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                const msgs = [
                    "이번 캠핑, 필요한 장비만 가볍게 준비해보세요.",
                    "구매와 대여를 한 곳에서 더 편리하게.",
                    "캠핑 전 준비부터 배송 확인까지 한 번에.",
                    "모닥모닥과 함께 더 쉬운 캠핑을 시작해보세요."
                ];
                const el = document.querySelector(".hero-desc");
                el.innerHTML = msgs[Math.floor(Math.random() * msgs.length)];
            }
        });

        app.mount('#app');
    </script>