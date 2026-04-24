<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="/css/user/sign-up.css">
</head>

<body>
    <div id="app">
        <!-- ── 왼쪽 패널 ── -->
        <div class="left-panel">
            <div class="brand">
                <a href="/main.do" class="brand-name">모닥모닥</a>
            </div>

            <div class="hero-text">
                <p class="hero-eyebrow">CAMPING RENTAL & SHOP</p>
                <h1 class="hero-title">모닥모닥과 함께<br><em>캠핑을 시작해보세요</em></h1>
                <p class="hero-desc">
                    회원가입 후 캠핑용품 구매부터 대여까지 한 번에.<br>
                    필요한 장비를 더 가볍고 편리하게 준비하고,<br>
                    주문과 대여 내역도 손쉽게 관리해보세요.
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
                <span class="quote-mark">"</span>
                <p>장비 준비는 가볍게, 캠핑의 설렘은 더 크게.</p>
            </div>

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
                    <h2>함께 불을 피워볼까요</h2>
                    <p>회원가입 후 모닥모닥의 구매·대여 서비스를 이용해보세요.</p>
                </div>

                <!-- 아이디 -->
                <div class="field">
                    <label>아이디<span class="required">*</span></label>
                    <div class="input-wrap input-with-btn">
                        <input v-model="userId" type="text" id="userIdInput"
                            placeholder="영문·숫자·_ 4~20자">
                        <button type="button" class="btn-check" @click="fnCheckUserId">중복체크</button>
                    </div>
                    <p class="field-hint" id="userIdHint"></p>
                </div>

                <!-- 이름 + 별명 -->
                <div class="field-row">
                    <div class="field">
                        <label>이름 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="userName" type="text" id="nameInput"
                                placeholder="홍길동" oninput="validateName()">
                            <span class="input-icon" id="nameIcon"></span>
                        </div>
                        <p class="field-hint" id="nameHint"></p>
                    </div>
                    <div class="field">
                        <label>별명 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="nickName" type="text" id="nickInput"
                                placeholder="불꽃이" oninput="validateNick()">
                            <span class="input-icon" id="nickIcon"></span>
                        </div>
                        <p class="field-hint" id="nickHint">커뮤니티에서 사용할 이름이에요.</p>
                    </div>
                </div>

                <!-- 이메일 -->
                <div class="field">
                    <label>이메일 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input v-model="email" type="email" id="emailInput"
                            placeholder="hello@modakmodak.kr" oninput="validateEmail()">
                        <span class="input-icon">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <rect x="1" y="3" width="14" height="10" rx="2" stroke="#b09070" stroke-width="1.4"/>
                                <path d="M1.5 4L8 9.5L14.5 4" stroke="#b09070" stroke-width="1.4" stroke-linecap="round"/>
                            </svg>
                        </span>
                    </div>
                    <p class="field-hint" id="emailHint"></p>
                </div>

                <!-- 비밀번호 -->
                <div class="field">
                    <label>비밀번호 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input v-model="userPwd" type="password" id="pwInput"
                            placeholder="영문·숫자 포함 8자 이상" oninput="validatePw()">
                        <span class="input-icon" onclick="togglePw('pwInput')" id="eyeIcon1">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4"/>
                                <circle cx="8" cy="8" r="1.8" fill="#b09070"/>
                            </svg>
                        </span>
                    </div>
                    <div style="margin-top:6px; display:flex; gap:4px;">
                        <div id="str1" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str2" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str3" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str4" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                    </div>
                    <p class="field-hint" id="pwHint"></p>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="field">
                    <label>비밀번호 확인 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input type="password" id="pwConfirm"
                            placeholder="비밀번호를 한 번 더 입력하세요" oninput="validateConfirm()">
                        <span class="input-icon" onclick="togglePw('pwConfirm')" id="eyeIcon2">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4"/>
                                <circle cx="8" cy="8" r="1.8" fill="#b09070"/>
                            </svg>
                        </span>
                    </div>
                    <p class="field-hint" id="confirmHint"></p>
                </div>

                <!-- 약관 -->
                <div class="terms-section">
                    <label class="terms-all">
                        <input type="checkbox" class="cb all-cb" id="agreeAll"
                            :checked="agreeAll" @change="toggleAll">
                        <span>전체 동의하기</span>
                    </label>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb required-term"
                                v-model="term1" @change="updateAll">
                            <span><em>[필수]</em>이용약관 동의</span>
                        </label>
                        <a href="http://localhost:8080/terms.do" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb required-term"
                                v-model="term2" @change="updateAll">
                            <span><em>[필수]</em>개인정보처리방침 동의</span>
                        </label>
                        <a href="http://localhost:8080/privacyPolicy.do" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb"
                                v-model="marketingYn" @change="updateAll">
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
                <div class="success-fire">🔥</div>
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
    /* ── 비밀번호 토글 ── */
    function togglePw(id) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }

    /* ── 아이콘 헬퍼 ── */
    const okSvg  = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#5a9a6a" opacity=".15"/><path d="M4.5 7.5L6.5 9.5L10.5 5.5" stroke="#5a9a6a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
    const errSvg = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#c94f1e" opacity=".12"/><path d="M5 5L10 10M10 5L5 10" stroke="#c94f1e" stroke-width="1.5" stroke-linecap="round"/></svg>`;

    function setField(inputId, iconId, hintId, valid, msg) {
        const inp  = document.getElementById(inputId);
        const hint = document.getElementById(hintId);
        if (inp.value === '') {
            inp.classList.remove('valid', 'invalid');
            if (iconId) document.getElementById(iconId).innerHTML = '';
            hint.className   = 'field-hint';
            hint.textContent = msg || '';
            return;
        }
        inp.classList.toggle('valid',   valid);
        inp.classList.toggle('invalid', !valid);
        if (iconId) document.getElementById(iconId).innerHTML = valid ? okSvg : errSvg;
        hint.className   = 'field-hint ' + (valid ? 'ok' : 'error');
        hint.textContent = msg;
    }

    function validateName() {
        const v = document.getElementById('nameInput').value;
        setField('nameInput', 'nameIcon', 'nameHint',
            v.length >= 2,
            v.length >= 2 ? '좋아요!' : '이름은 2자 이상 입력해주세요.');
    }
    function validateNick() {
        const v  = document.getElementById('nickInput').value;
        const ok = /^[가-힣a-zA-Z0-9_]{2,12}$/.test(v);
        setField('nickInput', 'nickIcon', 'nickHint',
            ok,
            ok ? '사용 가능한 닉네임이에요!' : '한글·영문·숫자·_ 2~12자로 입력해주세요.');
    }
    function validateEmail() {
        const v  = document.getElementById('emailInput').value;
        const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
        setField('emailInput', null, 'emailHint',
            ok,
            ok ? '올바른 이메일 형식이에요.' : '이메일 형식을 확인해주세요.');
    }
    function validatePw() {
        const v    = document.getElementById('pwInput').value;
        const bars = ['str1','str2','str3','str4'].map(id => document.getElementById(id));
        const colors = ['#e0621a','#e0621a','#f0a030','#5a9a6a'];
        let score = 0;
        if (v.length >= 8)                              score++;
        if (/[A-Za-z]/.test(v) && /[0-9]/.test(v))    score++;
        if (/[^A-Za-z0-9]/.test(v))                    score++;
        if (v.length >= 12)                             score++;
        bars.forEach((b, i) => {
            b.style.background = i < score ? colors[Math.min(score-1, 3)] : 'rgba(180,140,100,.2)';
        });
        const labels = ['','취약한 비밀번호','보통 비밀번호','강한 비밀번호','매우 강한 비밀번호'];
        setField('pwInput', null, 'pwHint',
            score >= 2,
            score > 0 ? labels[score] : '영문·숫자를 포함해 8자 이상 입력해주세요.');
        if (document.getElementById('pwConfirm').value) validateConfirm();
    }
    function validateConfirm() {
        const pw   = document.getElementById('pwInput').value;
        const conf = document.getElementById('pwConfirm').value;
        setField('pwConfirm', null, 'confirmHint',
            pw === conf && conf !== '',
            pw === conf ? '비밀번호가 일치해요.' : '비밀번호가 일치하지 않아요.');
    }

    /* ── Vue 앱 ── */
    const app = Vue.createApp({
        data() {
            return {
                userId:         '',
                userName:       '',
                nickName:       '',
                email:          '',
                userPwd:        '',
                checked:        false,
                signupSuccessed: false,
                marketingYn:    false,
                agreeAll:       false,
                term1:          false,
                term2:          false
            };
        },
        methods: {

            /* 전체 동의 토글 */
            toggleAll() {
                const all    = !this.agreeAll;
                this.agreeAll    = all;
                this.term1       = all;
                this.term2       = all;
                this.marketingYn = all;
            },

            /* 개별 체크 → 전체 동의 상태 갱신 */
            updateAll() {
                this.agreeAll = this.term1 && this.term2 && this.marketingYn;
            },

            /* ── 회원가입 ── */
            fnSignUp() {
                const self = this;

                /* 1. 아이디 빈값 체크 */
                if (!self.userId || self.userId.trim() === '') {
                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디를 입력해주세요.";
                    hint.className   = "field-hint error";
                    document.getElementById("userIdInput").focus();
                    return;
                }

                /* 2. 아이디 형식 체크 (영문·숫자·_ 4~20자) */
                const idRegex = /^[a-zA-Z0-9_]{4,20}$/;
                if (!idRegex.test(self.userId.trim())) {
                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디는 영문·숫자·_ 4~20자로 입력해주세요.";
                    hint.className   = "field-hint error";
                    document.getElementById("userIdInput").focus();
                    return;
                }

                /* 3. 중복체크 여부 */
                if (!self.checked) {
                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디 중복 확인을 해주세요.";
                    hint.className   = "field-hint error";
                    document.getElementById("userIdInput").focus();
                    return;
                }

                /* 4. 이름 체크 */
                if (!self.userName || self.userName.trim().length < 2) {
                    alert("이름을 2자 이상 입력해주세요.");
                    document.getElementById("nameInput").focus();
                    return;
                }

                /* 5. 닉네임 체크 */
                if (!self.nickName || !/^[가-힣a-zA-Z0-9_]{2,12}$/.test(self.nickName.trim())) {
                    alert("닉네임을 올바르게 입력해주세요. (한글·영문·숫자·_ 2~12자)");
                    document.getElementById("nickInput").focus();
                    return;
                }

                /* 6. 이메일 체크 */
                if (!self.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(self.email.trim())) {
                    alert("올바른 이메일을 입력해주세요.");
                    document.getElementById("emailInput").focus();
                    return;
                }

                /* 7. 비밀번호 체크 */
                if (!self.userPwd || self.userPwd.length < 8) {
                    alert("비밀번호를 8자 이상 입력해주세요.");
                    document.getElementById("pwInput").focus();
                    return;
                }
                if (!/[A-Za-z]/.test(self.userPwd) || !/[0-9]/.test(self.userPwd)) {
                    alert("비밀번호에 영문과 숫자를 모두 포함해주세요.");
                    document.getElementById("pwInput").focus();
                    return;
                }

                /* 8. 비밀번호 확인 일치 */
                const pwConfirm = document.getElementById("pwConfirm").value;
                if (self.userPwd !== pwConfirm) {
                    alert("비밀번호가 일치하지 않아요.");
                    document.getElementById("pwConfirm").focus();
                    return;
                }

                /* 9. 필수 약관 동의 */
                if (!self.term1 || !self.term2) {
                    alert("필수 약관에 동의해주세요.");
                    return;
                }

                /* 10. 서버 전송 */
                const param = {
                    userId:      self.userId.trim(),
                    userName:    self.userName.trim(),
                    nickName:    self.nickName.trim(),
                    email:       self.email.trim(),
                    userPwd:     self.userPwd,
                    marketingYn: self.marketingYn ? 'Y' : 'N'
                };

                console.log('전송 파라미터:', param);

                $.ajax({
                    url:      "http://localhost:8080/user/sign-up.dox",
                    dataType: "json",
                    type:     "POST",
                    data:     param,
                    success(data) {
                        if (data.result === "success") self.signupSuccessed = true;
                        else alert(data.message);
                    }
                });
            },

            /* 아이디 중복체크 */
            fnCheckUserId() {
                const self = this;

                /* 빈값·형식 먼저 체크 */
                if (!self.userId || self.userId.trim() === '') {
                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디를 입력해주세요.";
                    hint.className   = "field-hint error";
                    return;
                }
                if (!/^[a-zA-Z0-9_]{4,20}$/.test(self.userId.trim())) {
                    const hint = document.getElementById("userIdHint");
                    hint.textContent = "아이디는 영문·숫자·_ 4~20자로 입력해주세요.";
                    hint.className   = "field-hint error";
                    return;
                }

                $.ajax({
                    url:      "http://localhost:8080/user/check-user-id.dox",
                    dataType: "json",
                    type:     "POST",
                    data:     { userId: self.userId.trim() },
                    success(data) {
                        const hint = document.getElementById("userIdHint");
                        hint.textContent = data.message;
                        if (data.result === "success") {
                            hint.className = "field-hint ok";
                            self.checked   = true;
                        } else {
                            hint.className = "field-hint error";
                            self.checked   = false;
                        }
                    }
                });
            },

            fnGoLogin() {
                location.href = "/user/login.do";
            }
        },

        watch: {
            userId(newVal) {
                this.checked = false;

                /* 공백 입력 즉시 제거 */
                if (newVal !== newVal.trim()) {
                    this.userId = newVal.trim();
                    return;
                }

                const hint = document.getElementById("userIdHint");
                if (newVal.length > 0) {
                    hint.textContent = "아이디 중복 확인이 필요합니다.";
                    hint.className   = "field-hint";
                } else {
                    hint.textContent = "";
                    hint.className   = "field-hint";
                }
            }
        },

        mounted() {}
    });

    app.mount('#app');
</script>