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
        <link rel="stylesheet" href="/css/user/sign-up.css">
    </head>

    <body>
        <div id="app">
            <!-- ── 왼쪽 패널 (로그인 동일) ── -->
            <div class="left-panel">
                <!-- <video autoplay muted loop class="bg-video">
                        <source src="/video/모닥불.mp4" type="video/mp4">
                    </video> -->
                <div class="brand">
                    <!-- <svg width="26" height="32" viewBox="0 0 26 32" fill="none">
                        <path
                            d="M13 32C8.5 25.5 6 19 9.5 12.5 11.5 8 9 4 11.5 1 12.5-.5 13 0 13 0s.5-.5 1.5 1C17 4 14.5 8 16.5 12.5 20 19 17.5 25.5 13 32Z"
                            fill="url(#bl1)" />
                        <path
                            d="M13 32C10.5 27 10 21.5 12 17 12.8 14.2 11.5 11.5 13 9 14.5 11.5 13.2 14.2 14 17 16 21.5 15.5 27 13 32Z"
                            fill="url(#bl2)" />
                        <defs>
                            <linearGradient id="bl1" x1="13" y1="32" x2="13" y2="0" gradientUnits="userSpaceOnUse">
                                <stop offset="0%" stop-color="#c94f1e" />
                                <stop offset="55%" stop-color="#f07d3a" />
                                <stop offset="100%" stop-color="#fde090" stop-opacity=".5" />
                            </linearGradient>
                            <linearGradient id="bl2" x1="13" y1="32" x2="13" y2="9" gradientUnits="userSpaceOnUse">
                                <stop offset="0%" stop-color="#fff3c4" />
                                <stop offset="100%" stop-color="#fbbf7a" stop-opacity=".4" />
                            </linearGradient>
                        </defs>
                    </svg> -->
                    <span class="brand-name">모닥모닥</span>
                </div>

                <div class="hero">
                    <p class="hero-eyebrow">MODAKMODAK</p>
                    <h1 class="hero-title">새로운 불씨를<br><em>피워보세요</em></h1>
                    <p class="hero-desc">모닥모닥에 합류하고<br>함께하는 따뜻함을 경험해보세요.</p>
                </div>

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

                <!-- 가입 전 -->
                <div class="signup-box" v-if="!signupSuccessed">

                    <div class="signup-heading">
                        <h2>모닥에 합류하기</h2>
                        <p>계정을 만들고 따뜻한 불씨를 피워보세요.</p>
                    </div>

                    <div class="field">
                        <label>아이디<span class="required">*</span></label>
                        <div class="input-wrap input-with-btn">
                            <input v-model="userId" type="text" id="userIdInput" placeholder="아이디를 입력하세요">
                            <button type="button" class="btn-check" @click="fnCheckUserId">중복체크</button>
                        </div>
                        <p class="field-hint" id="userIdHint"></p>
                    </div>

                    <div class="field-row">
                        <div class="field">
                            <label>이름 <span class="required">*</span></label>
                            <div class="input-wrap">
                                <input v-model="userName" type="text" id="nameInput" placeholder="홍길동"
                                    oninput="validateName()">
                                <span class="input-icon" id="nameIcon"></span>
                            </div>
                            <p class="field-hint" id="nameHint"></p>
                        </div>

                        <div class="field">
                            <label>별명 <span class="required">*</span></label>
                            <div class="input-wrap">
                                <input v-model="nickName" type="text" id="nickInput" placeholder="불꽃이"
                                    oninput="validateNick()">
                                <span class="input-icon" id="nickIcon"></span>
                            </div>
                            <p class="field-hint" id="nickHint">커뮤니티에서 사용할 이름이에요.</p>
                        </div>
                    </div>

                    <div class="field">
                        <label>이메일 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="email" type="email" id="emailInput" placeholder="hello@modakmodak.kr"
                                oninput="validateEmail()">
                            <span class="input-icon">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <rect x="1" y="3" width="14" height="10" rx="2" stroke="#b09070"
                                        stroke-width="1.4" />
                                    <path d="M1.5 4L8 9.5L14.5 4" stroke="#b09070" stroke-width="1.4"
                                        stroke-linecap="round" />
                                </svg>
                            </span>
                        </div>
                        <p class="field-hint" id="emailHint"></p>
                    </div>

                    <div class="field">
                        <label>비밀번호 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="userPwd" type="password" id="pwInput" placeholder="영문·숫자 포함 8자 이상"
                                oninput="validatePw()">
                            <span class="input-icon" onclick="togglePw('pwInput','eyeIcon1')" id="eyeIcon1">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4" />
                                    <circle cx="8" cy="8" r="1.8" fill="#b09070" />
                                </svg>
                            </span>
                        </div>
                        <div style="margin-top:6px; display:flex; gap:4px;">
                            <div id="str1"
                                style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;">
                            </div>
                            <div id="str2"
                                style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;">
                            </div>
                            <div id="str3"
                                style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;">
                            </div>
                            <div id="str4"
                                style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;">
                            </div>
                        </div>
                        <p class="field-hint" id="pwHint"></p>
                    </div>

                    <div class="field">
                        <label>비밀번호 확인 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input type="password" id="pwConfirm" placeholder="비밀번호를 한 번 더 입력하세요"
                                oninput="validateConfirm()">
                            <span class="input-icon" onclick="togglePw('pwConfirm','eyeIcon2')" id="eyeIcon2">
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4" />
                                    <circle cx="8" cy="8" r="1.8" fill="#b09070" />
                                </svg>
                            </span>
                        </div>
                        <p class="field-hint" id="confirmHint"></p>
                    </div>

                    <div class="terms-section">
                        <label class="terms-all">
                            <input type="checkbox" class="cb all-cb" id="agreeAll" onchange="toggleAll()">
                            <span>전체 동의하기</span>
                        </label>

                        <div class="terms-item">
                            <label class="terms-check">
                                <input type="checkbox" class="cb term-cb required-term" onchange="updateAll()">
                                <span><em>[필수]</em>이용약관 동의</span>
                            </label>
                            <a href="http://localhost:8080/terms.do" class="terms-link">보기</a>
                        </div>
                        <div class="terms-item">
                            <label class="terms-check">
                                <input type="checkbox" class="cb term-cb required-term" onchange="updateAll()">
                                <span><em>[필수]</em>개인정보처리방침 동의</span>
                            </label>
                            <a href="http://localhost:8080/privacyPolicy.do" class="terms-link">보기</a>
                        </div>
                        <div class="terms-item">
                            <label class="terms-check">
                                <input type="checkbox" class="cb term-cb" onchange="updateAll()">
                                <span><em>[선택]</em>마케팅 정보 수신 동의</span>
                            </label>
                            <a href="http://localhost:8080/marketingConsent.do" class="terms-link">보기</a>
                        </div>
                    </div>

                    <button type="button" class="btn-signup" @click="fnSignUp">모닥 시작하기 🔥</button>

                    <p class="login-row">
                        이미 모닥이 있으신가요?
                        <a @click="fnGoLogin">로그인하기 →</a>
                    </p>
                </div>

                <!-- 가입 성공 후 -->
                <div class="signup-success-box" v-else>
                    <div class="success-fire">
                        🔥
                    </div>
                    <h2>회원가입이 완료되었어요</h2>
                    <p>이제 모닥모닥에서 따뜻한 이야기를 시작해보세요.</p>

                    <button type="button" class="btn-signup" @click="fnGoLogin">
                        로그인 페이지로 이동
                    </button>
                </div>

            </div>
        </div>
    </body>

    </html>

    <script>

        /* 비밀번호 토글 */
        function togglePw(id) {
            const inp = document.getElementById(id);
            inp.type = inp.type === 'password' ? 'text' : 'password';
        }

        /* 아이콘 헬퍼 */
        const okSvg = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#5a9a6a" opacity=".15"/><path d="M4.5 7.5L6.5 9.5L10.5 5.5" stroke="#5a9a6a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
        const errSvg = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#c94f1e" opacity=".12"/><path d="M5 5L10 10M10 5L5 10" stroke="#c94f1e" stroke-width="1.5" stroke-linecap="round"/></svg>`;

        function setField(inputId, iconId, hintId, valid, msg) {
            const inp = document.getElementById(inputId);
            const hint = document.getElementById(hintId);
            if (inp.value === '') {
                inp.classList.remove('valid', 'invalid');
                if (iconId) document.getElementById(iconId).innerHTML = '';
                hint.className = 'field-hint';
                hint.textContent = msg || '';
                return;
            }
            inp.classList.toggle('valid', valid);
            inp.classList.toggle('invalid', !valid);
            if (iconId) document.getElementById(iconId).innerHTML = valid ? okSvg : errSvg;
            hint.className = 'field-hint ' + (valid ? 'ok' : 'error');
            hint.textContent = msg;
        }

        function validateName() {
            const v = document.getElementById('nameInput').value;
            setField('nameInput', 'nameIcon', 'nameHint', v.length >= 2, v.length >= 2 ? '좋아요!' : '이름은 2자 이상 입력해주세요.');
        }
        function validateNick() {
            const v = document.getElementById('nickInput').value;
            const ok = /^[가-힣a-zA-Z0-9_]{2,12}$/.test(v);
            setField('nickInput', 'nickIcon', 'nickHint', ok, ok ? '사용 가능한 닉네임이에요!' : '한글·영문·숫자·_ 2~12자로 입력해주세요.');
        }
        function validateEmail() {
            const v = document.getElementById('emailInput').value;
            const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
            setField('emailInput', null, 'emailHint', ok, ok ? '올바른 이메일 형식이에요.' : '이메일 형식을 확인해주세요.');
        }

        function validatePw() {
            const v = document.getElementById('pwInput').value;
            const bars = [document.getElementById('str1'), document.getElementById('str2'), document.getElementById('str3'), document.getElementById('str4')];
            const colors = ['#e0621a', '#e0621a', '#f0a030', '#5a9a6a'];
            let score = 0;
            if (v.length >= 8) score++;
            if (/[A-Za-z]/.test(v) && /[0-9]/.test(v)) score++;
            if (/[^A-Za-z0-9]/.test(v)) score++;
            if (v.length >= 12) score++;
            bars.forEach((b, i) => { b.style.background = i < score ? colors[Math.min(score - 1, 3)] : 'rgba(180,140,100,.2)'; });
            const labels = ['', '취약한 비밀번호', '보통 비밀번호', '강한 비밀번호', '매우 강한 비밀번호'];
            setField('pwInput', null, 'pwHint', score >= 2, score > 0 ? labels[score] : '영문·숫자를 포함해 8자 이상 입력해주세요.');
            if (document.getElementById('pwConfirm').value) validateConfirm();
        }
        function validateConfirm() {
            const pw = document.getElementById('pwInput').value;
            const conf = document.getElementById('pwConfirm').value;
            setField('pwConfirm', null, 'confirmHint', pw === conf && conf !== '', pw === conf ? '비밀번호가 일치해요.' : '비밀번호가 일치하지 않아요.');
        }

        /* 전체 동의 */
        function toggleAll() {
            const all = document.getElementById('agreeAll').checked;
            document.querySelectorAll('.term-cb').forEach(cb => cb.checked = all);
        }
        function updateAll() {
            const cbs = document.querySelectorAll('.term-cb');
            document.getElementById('agreeAll').checked = [...cbs].every(c => c.checked);
        }
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (키 : 값)
                    // list : [] 
                    userId: '',
                    userName: '',
                    nickName: '',
                    email: '',
                    userPwd: '',
                    checked: false,
                    signupSuccessed: false
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnSignUp: function () {
                    let self = this;
                    if (!self.checked) {
                        const hint = document.getElementById("userIdHint");

                        hint.textContent = "아이디 중복 확인을 해주세요.";
                        hint.className = "field-hint error";

                        document.getElementById("userIdInput").focus();

                        return;
                    }

                    const requiredTerms = document.querySelectorAll(".required-term");

                    let allChecked = true;
                    requiredTerms.forEach(cb => {
                        if (!cb.checked) {
                            allChecked = false;
                        }
                    });

                    if (!allChecked) {
                        alert("필수 약관에 동의해주세요.");
                        return;
                    }
                    let param = {
                        userId: self.userId,
                        userName: self.userName,
                        nickName: self.nickName,
                        email: self.email,
                        userPwd: self.userPwd
                    };
                    $.ajax({
                        url: "http://localhost:8080/user/sign-up.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            if (data.result === "success") {
                                self.signupSuccessed = true;
                            } else {
                                alert(data.message);
                            }

                        }
                    });
                },
                fnCheckUserId: function () {
                    let self = this;
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "http://localhost:8080/user/check-user-id.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            const hint = document.getElementById("userIdHint");
                            hint.textContent = data.message;

                            if (data.result === "success") {
                                hint.className = "field-hint ok";
                                self.checked = true;
                            } else {
                                hint.className = "field-hint error";
                                self.checked = false;
                            }
                        }
                    });
                },

                fnGoLogin: function () {
                    location.href = "/user/login.do";
                }
            }, // methods
            watch: {
                userId(newVal, oldVal) {
                    let self = this
                    // 값 바뀌면 다시 검사 필요
                    self.checked = false;

                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디 중복 확인이 필요합니다.";
                    hint.className = "field-hint";
                }
            },
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }
        });

        app.mount('#app');
    </script>